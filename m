Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0524EC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 May 2022 11:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbiEBLPM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 May 2022 07:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350043AbiEBLPB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 May 2022 07:15:01 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D4892BCB9
        for <netfilter-devel@vger.kernel.org>; Mon,  2 May 2022 04:11:31 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables,v2] nft: support for dynamic register allocation
Date:   Mon,  2 May 2022 13:11:28 +0200
Message-Id: <20220502111128.113816-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Starting Linux kernel 5.18-rc, operations on registers that already
contain the expected data are turned into noop.

Use libnftnl dynamic register allocation infrastructure to select
the registers to be used for payload and meta expressions.

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

In all of these cases above, iptables-nft generates netlink bytecode
which uses the native expressions, ie. payload + cmp and meta + cmp.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: now based on libnftnl.

 iptables/nft-shared.c                         |  12 +-
 iptables/nft.c                                |  37 +++-
 iptables/nft.h                                |   2 +
 .../nft-only/0009-needless-bitwise_0          | 180 +++++++++---------
 4 files changed, 127 insertions(+), 104 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 27e95c1ae4f3..49e0b05c4314 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -29,6 +29,7 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
+#include <libnftnl/regs.h>
 
 #include "nft-shared.h"
 #include "nft-bridge.h"
@@ -50,8 +51,8 @@ void add_meta(struct nft_handle *h, struct nftnl_rule *r, uint32_t key,
 	if (expr == NULL)
 		return;
 
-	reg = NFT_REG_1;
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_META_KEY, key);
+	reg = nftnl_reg_get(h->regs, expr);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_META_DREG, reg);
 	nftnl_rule_add_expr(r, expr);
 
@@ -68,11 +69,11 @@ void add_payload(struct nft_handle *h, struct nftnl_rule *r,
 	if (expr == NULL)
 		return;
 
-	reg = NFT_REG_1;
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_BASE, base);
-	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_DREG, reg);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_OFFSET, offset);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_LEN, len);
+	reg = nftnl_reg_get(h->regs, expr);
+	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_DREG, reg);
 	nftnl_rule_add_expr(r, expr);
 
 	*dreg = reg;
@@ -89,7 +90,7 @@ void add_bitwise_u16(struct nft_handle *h, struct nftnl_rule *r,
 	if (expr == NULL)
 		return;
 
-	reg = NFT_REG_1;
+	reg = nftnl_reg_get_scratch(h->regs, sizeof(uint32_t));
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
 
+	reg = nftnl_reg_get_scratch(h->regs, len);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_SREG, sreg);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_DREG, reg);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_LEN, len);
diff --git a/iptables/nft.c b/iptables/nft.c
index 07653ee1a3d6..3d2a6ee97769 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -49,6 +49,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
+#include <libnftnl/regs.h>
 #include <libnftnl/udata.h>
 #include <libnftnl/batch.h>
 
@@ -904,6 +905,12 @@ int nft_init(struct nft_handle *h, int family)
 	h->cache = &h->__cache[0];
 	h->family = family;
 
+	h->regs = nftnl_regs_alloc(16);
+	if (!h->regs) {
+		mnl_socket_close(h->nl);
+		return -1;
+	}
+
 	INIT_LIST_HEAD(&h->obj_list);
 	INIT_LIST_HEAD(&h->err_list);
 	INIT_LIST_HEAD(&h->cmd_list);
@@ -926,6 +933,7 @@ void nft_fini(struct nft_handle *h)
 		mnl_err_list_free(list_entry(pos, struct mnl_err, head));
 
 	nft_release_cache(h);
+	nftnl_regs_free(h->regs);
 	mnl_socket_close(h->nl);
 }
 
@@ -1109,11 +1117,17 @@ static struct nftnl_expr *
 gen_payload(struct nft_handle *h, uint32_t base, uint32_t offset, uint32_t len,
 	    uint8_t *dreg)
 {
-	struct nftnl_expr *e;
+	struct nftnl_expr *e = nftnl_expr_alloc("payload");
 	uint8_t reg;
 
-	reg = NFT_REG_1;
-	e = __gen_payload(base, offset, len, reg);
+	if (!e)
+		return NULL;
+
+	nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_BASE, base);
+	nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_OFFSET, offset);
+	nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_LEN, len);
+	reg = nftnl_reg_get(h->regs, e);
+	nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_DREG, reg);
 	*dreg = reg;
 
 	return e;
@@ -1157,10 +1171,10 @@ static int __add_nft_among(struct nft_handle *h, const char *table,
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
@@ -1201,21 +1215,26 @@ static int __add_nft_among(struct nft_handle *h, const char *table,
 		nftnl_set_elem_add(s, elem);
 	}
 
-	e = gen_payload(h, NFT_PAYLOAD_LL_HEADER,
-			eth_addr_off[dst], ETH_ALEN, &reg);
+	concat_len = ETH_ALEN;
+	if (ip)
+		concat_len += sizeof(struct in_addr);
+
+	reg = nftnl_reg_get_scratch(h->regs, concat_len);
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
+	reg = nftnl_reg_get_scratch(h->regs, sizeof(uint32_t));
 	e = gen_lookup(reg, "__set%d", set_id, inv);
 	if (!e)
 		return -ENOMEM;
diff --git a/iptables/nft.h b/iptables/nft.h
index 68b0910c8e18..09214db961f3 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -111,6 +111,8 @@ struct nft_handle {
 	bool			cache_init;
 	int			verbose;
 
+	struct nftnl_regs	*regs;
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

