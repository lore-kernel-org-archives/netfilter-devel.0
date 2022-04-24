Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A33C4321E
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Apr 2022 21:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239697AbiDXV72 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Apr 2022 17:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239695AbiDXV72 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Apr 2022 17:59:28 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9FAFB393F7
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Apr 2022 14:56:25 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables 7/7] nft: support for dynamic register allocation
Date:   Sun, 24 Apr 2022 23:56:13 +0200
Message-Id: <20220424215613.106165-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220424215613.106165-1-pablo@netfilter.org>
References: <20220424215613.106165-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Starting Linux kernel 5.18-rc, operations on registers that already
contain the expected data are turned into noop.

Track operation on registers to use the same register through
payload_get_register() and meta_get_register(). This patch introduces an
LRU eviction strategy when all the registers are in used.

get_register() is used to allocate a register as scratchpad area: no
tracking is performed in this case. This is used for concatenations,
eg. ebt_among.

Using samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh

Benchmark #1: match on IPv6 address list

 *raw
 :PREROUTING DROP [9:2781]
 :OUTPUT ACCEPT [0:0]
 -A PREROUTING -d aaaa::bbbb -j DROP
 [... 98 times same rule above to trigger mismatch ...]
 -A PREROUTING -d fd00::1 -j DROP			# matching rule

 iptables-legacy	798Mb
 iptables-nft		801Mb (+0.37)

Benchmark #2: match on layer 4 protocol + port list

 *raw
 :PREROUTING DROP [9:2781]
 :OUTPUT ACCEPT [0:0]
 -A PREROUTING -p tcp --dport 23 -j DROP
 [... 98 times same rule above to trigger mismatch ...]
 -A PREROUTING -p udp --dport 9 -j DROP 		# matching rule

 iptables-legacy	648Mb
 iptables-nft		892Mb (+37.65%)

Benchmark #3: match on mark

 *raw
 :PREROUTING DROP [9:2781]
 :OUTPUT ACCEPT [0:0]
 -A PREROUTING -m mark --mark 100 -j DROP
 [... 98 times same rule above to trigger mismatch ...]
 -A PREROUTING -d 198.18.0.42/32 -j DROP		# matching rule

 iptables-legacy	255Mb
 iptables-nft		865Mb (+239.21%)

In these cases, iptables-nft generates netlink bytecode which uses the
native expressions, ie. payload + cmp and meta + cmp.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/Makefile.am                          |   2 +-
 iptables/nft-regs.c                           | 191 ++++++++++++++++++
 iptables/nft-regs.h                           |   9 +
 iptables/nft-shared.c                         |  10 +-
 iptables/nft.c                                |  20 +-
 iptables/nft.h                                |  25 +++
 .../nft-only/0009-needless-bitwise_0          | 180 ++++++++---------
 7 files changed, 335 insertions(+), 102 deletions(-)
 create mode 100644 iptables/nft-regs.c
 create mode 100644 iptables/nft-regs.h

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 0258264c4c70..2f8fe107cb05 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -35,7 +35,7 @@ endif
 xtables_nft_multi_CFLAGS  += -DENABLE_NFTABLES -DENABLE_IPV4 -DENABLE_IPV6
 xtables_nft_multi_SOURCES += xtables-save.c xtables-restore.c \
 				xtables-standalone.c xtables.c nft.c \
-				nft-shared.c nft-ipv4.c nft-ipv6.c nft-arp.c \
+				nft-shared.c nft-regs.c nft-ipv4.c nft-ipv6.c nft-arp.c \
 				xtables-monitor.c nft-cache.c \
 				xtables-arp.c \
 				nft-bridge.c nft-cmd.c nft-chain.c \
diff --git a/iptables/nft-regs.c b/iptables/nft-regs.c
new file mode 100644
index 000000000000..bfc762e4186f
--- /dev/null
+++ b/iptables/nft-regs.c
@@ -0,0 +1,191 @@
+/*
+ * (C) 2012-2022 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Funded through the NGI0 PET Fund established by NLnet (https://nlnet.nl)
+ * with support from the European Commission's Next Generation Internet
+ * programme.
+ */
+
+#include <string.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <errno.h>
+#include <assert.h>
+
+#include "nft.h"
+#include "nft-regs.h"
+
+static uint64_t reg_genid(struct nft_handle *h)
+{
+	return ++h->reg_genid;
+}
+
+struct nft_reg_ctx {
+	uint64_t	genid;
+	int		reg;
+	int		evict;
+};
+
+static int reg_space(int i)
+{
+	return sizeof(uint32_t) * 16 - sizeof(uint32_t) * i;
+}
+
+static void register_track(const struct nft_handle *h,
+			   struct nft_reg_ctx *ctx, int i, int len)
+{
+	if (ctx->reg >= 0 || h->regs[i].word || reg_space(i) < len)
+		return;
+
+	if (h->regs[i].type == NFT_REG_UNSPEC) {
+		ctx->genid = h->reg_genid;
+		ctx->reg = i;
+	} else if (h->regs[i].genid < ctx->genid) {
+		ctx->genid = h->regs[i].genid;
+		ctx->evict = i;
+	} else if (h->regs[i].len == len) {
+		ctx->evict = i;
+		ctx->genid = 0;
+	}
+}
+
+static void register_evict(struct nft_reg_ctx *ctx, int i)
+{
+	if (ctx->reg < 0) {
+		assert(ctx->evict >= 0);
+		ctx->reg = ctx->evict;
+	}
+}
+
+static void __register_update(struct nft_handle *h, uint8_t reg,
+			      int type, uint32_t len, uint8_t word,
+			      uint64_t genid)
+{
+	h->regs[reg].type = type;
+	h->regs[reg].genid = genid;
+	h->regs[reg].len = len;
+	h->regs[reg].word = word;
+}
+
+static void register_cancel(struct nft_handle *h, struct nft_reg_ctx *ctx)
+{
+	int plen = h->regs[ctx->reg].len, i;
+
+	for (i = ctx->reg; plen > 0; i++, plen -= sizeof(uint32_t)) {
+		h->regs[i].type = NFT_REG_UNSPEC;
+		h->regs[i].word = 0;
+	}
+
+	while (h->regs[i].word != 0) {
+		h->regs[i].type = NFT_REG_UNSPEC;
+		h->regs[i].word = 0;
+		i++;
+	}
+}
+
+static void register_update(struct nft_handle *h, struct nft_reg_ctx *ctx,
+			    int type, uint32_t len, uint64_t genid)
+{
+	register_cancel(h, ctx);
+	__register_update(h, ctx->reg, type, len, 0, genid);
+}
+
+uint8_t meta_get_register(struct nft_handle *h, enum nft_meta_keys key)
+{
+	struct nft_reg_ctx ctx = {
+		.reg	= -1,
+		.evict	= -1,
+		.genid	= UINT64_MAX,
+	};
+	uint64_t genid;
+	int i;
+
+	for (i = 0; i < 16; i++) {
+		register_track(h, &ctx, i, sizeof(uint32_t));
+
+		if (h->regs[i].type != NFT_REG_META)
+			continue;
+
+		if (h->regs[i].meta.key == key &&
+		    h->regs[i].len == sizeof(uint32_t)) {
+			h->regs[i].genid = reg_genid(h);
+			return i + NFT_REG32_00;
+		}
+	}
+
+	register_evict(&ctx, i);
+
+	genid = reg_genid(h);
+	register_update(h, &ctx, NFT_REG_META, sizeof(uint32_t), genid);
+	h->regs[ctx.reg].meta.key = key;
+
+	return ctx.reg + NFT_REG32_00;
+}
+
+uint8_t payload_get_register(struct nft_handle *h, enum nft_payload_bases base,
+			    uint32_t offset, uint32_t len)
+{
+	struct nft_reg_ctx ctx = {
+		.reg	= -1,
+		.evict	= -1,
+		.genid	= UINT64_MAX,
+	};
+	int i, j, plen = len;
+	uint64_t genid;
+
+	for (i = 0; i < 16; i++) {
+		register_track(h, &ctx, i, len);
+
+		if (h->regs[i].type != NFT_REG_PAYLOAD)
+			continue;
+
+		if (h->regs[i].payload.base == base &&
+		    h->regs[i].payload.offset == offset &&
+		    h->regs[i].len >= plen) {
+			h->regs[i].genid = reg_genid(h);
+			return i + NFT_REG32_00;
+		}
+	}
+
+	register_evict(&ctx, i);
+
+	genid = reg_genid(h);
+	register_update(h, &ctx, NFT_REG_PAYLOAD, len, genid);
+	h->regs[ctx.reg].payload.base = base;
+	h->regs[ctx.reg].payload.offset = offset;
+
+	plen -= sizeof(uint32_t);
+	j = 1;
+	for (i = ctx.reg + 1; plen > 0; i++, plen -= sizeof(uint32_t)) {
+		__register_update(h, i, NFT_REG_PAYLOAD, len, j++, genid);
+		h->regs[i].payload.base = base;
+		h->regs[i].payload.offset = offset;
+	}
+
+	return ctx.reg + NFT_REG32_00;
+}
+
+uint8_t get_register(struct nft_handle *h, uint8_t len)
+{
+	struct nft_reg_ctx ctx = {
+		.reg	= -1,
+		.evict	= -1,
+		.genid	= UINT64_MAX,
+	};
+	int i;
+
+	for (i = 0; i < 16; i++)
+		register_track(h, &ctx, i, len);
+
+	register_evict(&ctx, i);
+	register_cancel(h, &ctx);
+
+	return ctx.reg + NFT_REG32_00;
+}
diff --git a/iptables/nft-regs.h b/iptables/nft-regs.h
new file mode 100644
index 000000000000..3953eae9f217
--- /dev/null
+++ b/iptables/nft-regs.h
@@ -0,0 +1,9 @@
+#ifndef _NFT_REGS_H_
+#define _NFT_REGS_H_
+
+uint8_t payload_get_register(struct nft_handle *h, enum nft_payload_bases base,
+			     uint32_t offset, uint32_t len);
+uint8_t meta_get_register(struct nft_handle *h, enum nft_meta_keys key);
+uint8_t get_register(struct nft_handle *h, uint8_t len);
+
+#endif /* _NFT_REGS_H_ */
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 27e95c1ae4f3..ad5361942093 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -32,6 +32,7 @@
 
 #include "nft-shared.h"
 #include "nft-bridge.h"
+#include "nft-regs.h"
 #include "xshared.h"
 #include "nft.h"
 
@@ -50,7 +51,7 @@ void add_meta(struct nft_handle *h, struct nftnl_rule *r, uint32_t key,
 	if (expr == NULL)
 		return;
 
-	reg = NFT_REG_1;
+	reg = meta_get_register(h, key);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_META_KEY, key);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_META_DREG, reg);
 	nftnl_rule_add_expr(r, expr);
@@ -68,7 +69,7 @@ void add_payload(struct nft_handle *h, struct nftnl_rule *r,
 	if (expr == NULL)
 		return;
 
-	reg = NFT_REG_1;
+	reg = payload_get_register(h, base, offset, len);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_BASE, base);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_DREG, reg);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_OFFSET, offset);
@@ -89,7 +90,7 @@ void add_bitwise_u16(struct nft_handle *h, struct nftnl_rule *r,
 	if (expr == NULL)
 		return;
 
-	reg = NFT_REG_1;
+	reg = get_register(h, sizeof(uint32_t));
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_SREG, sreg);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_DREG, reg);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_LEN, sizeof(uint16_t));
@@ -105,12 +106,13 @@ void add_bitwise(struct nft_handle *h, struct nftnl_rule *r,
 {
 	struct nftnl_expr *expr;
 	uint32_t xor[4] = { 0 };
-	uint8_t reg = *dreg;
+	uint8_t reg;
 
 	expr = nftnl_expr_alloc("bitwise");
 	if (expr == NULL)
 		return;
 
+	reg = get_register(h, len);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_SREG, sreg);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_DREG, reg);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_LEN, len);
diff --git a/iptables/nft.c b/iptables/nft.c
index 07653ee1a3d6..48330f285703 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -56,6 +56,7 @@
 #include <arpa/inet.h>
 
 #include "nft.h"
+#include "nft-regs.h"
 #include "xshared.h" /* proto_to_name */
 #include "nft-cache.h"
 #include "nft-shared.h"
@@ -1112,7 +1113,7 @@ gen_payload(struct nft_handle *h, uint32_t base, uint32_t offset, uint32_t len,
 	struct nftnl_expr *e;
 	uint8_t reg;
 
-	reg = NFT_REG_1;
+	reg = payload_get_register(h, base, offset, len);
 	e = __gen_payload(base, offset, len, reg);
 	*dreg = reg;
 
@@ -1157,10 +1158,10 @@ static int __add_nft_among(struct nft_handle *h, const char *table,
 		offsetof(struct iphdr, saddr),
 		offsetof(struct iphdr, daddr)
 	};
+	uint8_t reg, concat_len;
 	struct nftnl_expr *e;
 	struct nftnl_set *s;
 	uint32_t flags = 0;
-	uint8_t reg;
 	int idx = 0;
 
 	if (ip) {
@@ -1201,21 +1202,26 @@ static int __add_nft_among(struct nft_handle *h, const char *table,
 		nftnl_set_elem_add(s, elem);
 	}
 
-	e = gen_payload(h, NFT_PAYLOAD_LL_HEADER,
-			eth_addr_off[dst], ETH_ALEN, &reg);
+	concat_len = ETH_ALEN;
+	if (ip)
+		concat_len += sizeof(struct in_addr);
+
+	reg = get_register(h, concat_len);
+	e = __gen_payload(NFT_PAYLOAD_LL_HEADER,
+			  eth_addr_off[dst], ETH_ALEN, reg);
 	if (!e)
 		return -ENOMEM;
 	nftnl_rule_add_expr(r, e);
 
 	if (ip) {
-		e = gen_payload(h, NFT_PAYLOAD_NETWORK_HEADER, ip_addr_off[dst],
-				sizeof(struct in_addr), &reg);
+		e = __gen_payload(NFT_PAYLOAD_NETWORK_HEADER, ip_addr_off[dst],
+				  sizeof(struct in_addr), reg + 2);
 		if (!e)
 			return -ENOMEM;
 		nftnl_rule_add_expr(r, e);
 	}
 
-	reg = NFT_REG_1;
+	reg = get_register(h, sizeof(uint32_t));
 	e = gen_lookup(reg, "__set%d", set_id, inv);
 	if (!e)
 		return -ENOMEM;
diff --git a/iptables/nft.h b/iptables/nft.h
index 68b0910c8e18..3dc907b188ce 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -85,6 +85,28 @@ struct nft_cache_req {
 	struct list_head	chain_list;
 };
 
+enum nft_reg_type {
+	NFT_REG_UNSPEC	= 0,
+	NFT_REG_PAYLOAD,
+	NFT_REG_META,
+};
+
+struct nft_regs {
+	enum nft_reg_type			type;
+	uint32_t				len;
+	uint64_t				genid;
+	uint8_t					word;
+	union {
+		struct {
+			enum nft_meta_keys	key;
+		} meta;
+		struct {
+			enum nft_payload_bases	base;
+			uint32_t		offset;
+		} payload;
+	};
+};
+
 struct nft_handle {
 	int			family;
 	struct mnl_socket	*nl;
@@ -111,6 +133,9 @@ struct nft_handle {
 	bool			cache_init;
 	int			verbose;
 
+	struct nft_regs		regs[20];
+	uint64_t		reg_genid;
+
 	/* meta data, for error reporting */
 	struct {
 		unsigned int	lineno;
diff --git a/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0 b/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0
index 41588a10863e..34987b239d35 100755
--- a/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0
+++ b/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0
@@ -64,8 +64,8 @@ ip filter OUTPUT 5 4
 
 ip filter OUTPUT 6 5
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xfcffffff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0002010a ]
+  [ bitwise reg 9 = ( reg 1 & 0xfcffffff ) ^ 0x00000000 ]
+  [ cmp eq reg 9 0x0002010a ]
   [ counter pkts 0 bytes 0 ]
 
 ip filter OUTPUT 7 6
@@ -98,8 +98,8 @@ ip6 filter OUTPUT 5 4
 
 ip6 filter OUTPUT 6 5
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xffffffff 0xffffffff 0xffffffff 0xf0ffffff ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
-  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x06050403 0x00090807 ]
+  [ bitwise reg 2 = ( reg 1 & 0xffffffff 0xffffffff 0xffffffff 0xf0ffffff ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 2 0xffc0edfe 0x020100ee 0x06050403 0x00090807 ]
   [ counter pkts 0 bytes 0 ]
 
 ip6 filter OUTPUT 7 6
@@ -148,155 +148,155 @@ ip6 filter OUTPUT 15 14
 arp filter OUTPUT 3
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 4b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0302010a ]
+  [ payload load 1b @ network header + 4 => reg 9 ]
+  [ cmp eq reg 9 0x00000006 ]
+  [ payload load 1b @ network header + 5 => reg 10 ]
+  [ cmp eq reg 10 0x00000004 ]
+  [ payload load 4b @ network header + 24 => reg 11 ]
+  [ cmp eq reg 11 0x0302010a ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 4 3
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 4b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0302010a ]
+  [ payload load 1b @ network header + 4 => reg 9 ]
+  [ cmp eq reg 9 0x00000006 ]
+  [ payload load 1b @ network header + 5 => reg 10 ]
+  [ cmp eq reg 10 0x00000004 ]
+  [ payload load 4b @ network header + 24 => reg 11 ]
+  [ cmp eq reg 11 0x0302010a ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 5 4
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 4b @ network header + 24 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xfcffffff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0002010a ]
+  [ payload load 1b @ network header + 4 => reg 9 ]
+  [ cmp eq reg 9 0x00000006 ]
+  [ payload load 1b @ network header + 5 => reg 10 ]
+  [ cmp eq reg 10 0x00000004 ]
+  [ payload load 4b @ network header + 24 => reg 11 ]
+  [ bitwise reg 2 = ( reg 11 & 0xfcffffff ) ^ 0x00000000 ]
+  [ cmp eq reg 2 0x0002010a ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 6 5
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 3b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0002010a ]
+  [ payload load 1b @ network header + 4 => reg 9 ]
+  [ cmp eq reg 9 0x00000006 ]
+  [ payload load 1b @ network header + 5 => reg 10 ]
+  [ cmp eq reg 10 0x00000004 ]
+  [ payload load 3b @ network header + 24 => reg 11 ]
+  [ cmp eq reg 11 0x0002010a ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 7 6
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 2b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0000010a ]
+  [ payload load 1b @ network header + 4 => reg 9 ]
+  [ cmp eq reg 9 0x00000006 ]
+  [ payload load 1b @ network header + 5 => reg 10 ]
+  [ cmp eq reg 10 0x00000004 ]
+  [ payload load 2b @ network header + 24 => reg 11 ]
+  [ cmp eq reg 11 0x0000010a ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 8 7
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 1b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 1b @ network header + 4 => reg 9 ]
+  [ cmp eq reg 9 0x00000006 ]
+  [ payload load 1b @ network header + 5 => reg 10 ]
+  [ cmp eq reg 10 0x00000004 ]
+  [ payload load 1b @ network header + 24 => reg 11 ]
+  [ cmp eq reg 11 0x0000000a ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 9 8
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ payload load 1b @ network header + 4 => reg 9 ]
+  [ cmp eq reg 9 0x00000006 ]
+  [ payload load 1b @ network header + 5 => reg 10 ]
+  [ cmp eq reg 10 0x00000004 ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 10 9
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 6b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0xc000edfe 0x0000eeff ]
+  [ payload load 1b @ network header + 4 => reg 9 ]
+  [ cmp eq reg 9 0x00000006 ]
+  [ payload load 1b @ network header + 5 => reg 10 ]
+  [ cmp eq reg 10 0x00000004 ]
+  [ payload load 6b @ network header + 18 => reg 2 ]
+  [ cmp eq reg 2 0xc000edfe 0x0000eeff ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 11 10
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 6b @ network header + 18 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xffffffff 0x0000f0ff ) ^ 0x00000000 0x00000000 ]
-  [ cmp eq reg 1 0xc000edfe 0x0000e0ff ]
+  [ payload load 1b @ network header + 4 => reg 9 ]
+  [ cmp eq reg 9 0x00000006 ]
+  [ payload load 1b @ network header + 5 => reg 10 ]
+  [ cmp eq reg 10 0x00000004 ]
+  [ payload load 6b @ network header + 18 => reg 2 ]
+  [ bitwise reg 14 = ( reg 2 & 0xffffffff 0x0000f0ff ) ^ 0x00000000 0x00000000 ]
+  [ cmp eq reg 14 0xc000edfe 0x0000e0ff ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 12 11
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 5b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0xc000edfe 0x000000ff ]
+  [ payload load 1b @ network header + 4 => reg 9 ]
+  [ cmp eq reg 9 0x00000006 ]
+  [ payload load 1b @ network header + 5 => reg 10 ]
+  [ cmp eq reg 10 0x00000004 ]
+  [ payload load 5b @ network header + 18 => reg 2 ]
+  [ cmp eq reg 2 0xc000edfe 0x000000ff ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 13 12
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 4b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0xc000edfe ]
+  [ payload load 1b @ network header + 4 => reg 9 ]
+  [ cmp eq reg 9 0x00000006 ]
+  [ payload load 1b @ network header + 5 => reg 10 ]
+  [ cmp eq reg 10 0x00000004 ]
+  [ payload load 4b @ network header + 18 => reg 2 ]
+  [ cmp eq reg 2 0xc000edfe ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 14 13
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 3b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0x0000edfe ]
+  [ payload load 1b @ network header + 4 => reg 9 ]
+  [ cmp eq reg 9 0x00000006 ]
+  [ payload load 1b @ network header + 5 => reg 10 ]
+  [ cmp eq reg 10 0x00000004 ]
+  [ payload load 3b @ network header + 18 => reg 2 ]
+  [ cmp eq reg 2 0x0000edfe ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 15 14
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 2b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0x0000edfe ]
+  [ payload load 1b @ network header + 4 => reg 9 ]
+  [ cmp eq reg 9 0x00000006 ]
+  [ payload load 1b @ network header + 5 => reg 10 ]
+  [ cmp eq reg 10 0x00000004 ]
+  [ payload load 2b @ network header + 18 => reg 2 ]
+  [ cmp eq reg 2 0x0000edfe ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 16 15
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 1b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0x000000fe ]
+  [ payload load 1b @ network header + 4 => reg 9 ]
+  [ cmp eq reg 9 0x00000006 ]
+  [ payload load 1b @ network header + 5 => reg 10 ]
+  [ cmp eq reg 10 0x00000004 ]
+  [ payload load 1b @ network header + 18 => reg 2 ]
+  [ cmp eq reg 2 0x000000fe ]
   [ counter pkts 0 bytes 0 ]
 
 bridge filter OUTPUT 4
@@ -306,8 +306,8 @@ bridge filter OUTPUT 4
 
 bridge filter OUTPUT 5 4
   [ payload load 6b @ link header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xffffffff 0x0000f0ff ) ^ 0x00000000 0x00000000 ]
-  [ cmp eq reg 1 0xc000edfe 0x0000e0ff ]
+  [ bitwise reg 10 = ( reg 1 & 0xffffffff 0x0000f0ff ) ^ 0x00000000 0x00000000 ]
+  [ cmp eq reg 10 0xc000edfe 0x0000e0ff ]
   [ counter pkts 0 bytes 0 ]
 
 bridge filter OUTPUT 6 5
-- 
2.30.2

