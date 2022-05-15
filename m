Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F53CC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 May 2022 21:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbiEOVGT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 May 2022 17:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiEOVFx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 May 2022 17:05:53 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9F382AB
        for <netfilter-devel@vger.kernel.org>; Sun, 15 May 2022 14:05:47 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     guigom@riseup.net
Subject: [PATCH libnftnl] expr: extend support for dynamic register allocation
Date:   Sun, 15 May 2022 23:05:43 +0200
Message-Id: <20220515210543.1622507-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: "Jose M. Guisado Gomez" <guigom@riseup.net>

Add expression support for:

- ct
- exthdr
- fib
- osf
- rt
- socket
- xfrm

to extend b9e00458b9f3 ("src: add dynamic register allocation
infrastructure").

Joint work with Pablo.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/regs.h    | 38 ++++++++++++++++++++++
 src/expr/ct.c     | 82 +++++++++++++++++++++++++++++++++++++++++++++++
 src/expr/exthdr.c | 37 +++++++++++++++++++++
 src/expr/fib.c    | 45 ++++++++++++++++++++++++++
 src/expr/osf.c    | 32 ++++++++++++++++++
 src/expr/rt.c     | 46 ++++++++++++++++++++++++++
 src/expr/socket.c | 47 +++++++++++++++++++++++++++
 src/expr/xfrm.c   | 51 +++++++++++++++++++++++++++++
 src/regs.c        | 16 ++++++++-
 9 files changed, 393 insertions(+), 1 deletion(-)

diff --git a/include/regs.h b/include/regs.h
index 5312f607f692..dcbb0f4b6f7c 100644
--- a/include/regs.h
+++ b/include/regs.h
@@ -5,6 +5,13 @@ enum nftnl_expr_type {
 	NFT_EXPR_UNSPEC	= 0,
 	NFT_EXPR_PAYLOAD,
 	NFT_EXPR_META,
+	NFT_EXPR_CT,
+	NFT_EXPR_EXTHDR,
+	NFT_EXPR_FIB,
+	NFT_EXPR_OSF,
+	NFT_EXPR_RT,
+	NFT_EXPR_XFRM,
+	NFT_EXPR_SOCKET,
 };
 
 struct nftnl_reg {
@@ -20,6 +27,37 @@ struct nftnl_reg {
 			enum nft_payload_bases		base;
 			uint32_t			offset;
 		} payload;
+		struct {
+			enum nft_ct_keys		key;
+			uint8_t				dir;
+		} ct;
+		struct {
+			uint32_t			offset;
+			uint32_t			len;
+			uint8_t				type;
+			uint32_t			op;
+			uint32_t			flags;
+		} exthdr;
+		struct {
+			uint32_t			flags;
+			uint32_t			result;
+		} fib;
+		struct {
+			uint8_t                 	ttl;
+			uint32_t                	flags;
+		} osf;
+		struct {
+			enum nft_rt_keys		key;
+		} rt;
+		struct {
+			enum nft_socket_keys		key;
+			uint32_t			level;
+		} socket;
+		struct {
+			enum nft_xfrm_keys		key;
+			uint32_t			spnum;
+			uint8_t				dir;
+		} xfrm;
 	};
 };
 
diff --git a/src/expr/ct.c b/src/expr/ct.c
index d5dfc81cfe0d..f17491c97bda 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -14,6 +14,7 @@
 #include <stdint.h>
 #include <arpa/inet.h>
 #include <errno.h>
+#include <assert.h>
 #include <linux/netfilter/nf_tables.h>
 
 #include "internal.h"
@@ -148,6 +149,82 @@ nftnl_expr_ct_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
+#ifndef XT_CONNLABEL_MAXBIT
+#define XT_CONNLABEL_MAXBIT	127
+#endif
+
+#ifndef NF_CT_LABELS_MAX_SIZE
+#define NF_CT_LABELS_MAX_SIZE ((XT_CONNLABEL_MAXBIT + 1) / 8)
+#endif
+
+#ifndef NF_CT_HELPER_NAME_LEN
+#define NF_CT_HELPER_NAME_LEN       16
+#endif
+
+static int
+nftnl_expr_ct_reg_len(const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_ct *ct = nftnl_expr_data(e);
+
+	switch (ct->key) {
+	case NFT_CT_DIRECTION:
+	case NFT_CT_PROTOCOL:
+	case NFT_CT_L3PROTOCOL:
+		return sizeof(uint8_t);
+	case NFT_CT_ZONE:
+	case NFT_CT_LABELS:
+		return NF_CT_LABELS_MAX_SIZE;
+	case NFT_CT_HELPER:
+		return NF_CT_HELPER_NAME_LEN;
+	case NFT_CT_PROTO_SRC:
+	case NFT_CT_PROTO_DST:
+		return sizeof(uint16_t);
+	case NFT_CT_ID:
+	case NFT_CT_STATE:
+	case NFT_CT_STATUS:
+	case NFT_CT_MARK:
+	case NFT_CT_SECMARK:
+	case NFT_CT_EXPIRATION:
+	case NFT_CT_EVENTMASK:
+	case NFT_CT_SRC_IP:
+	case NFT_CT_DST_IP:
+		return sizeof(uint32_t);
+	case NFT_CT_BYTES:
+	case NFT_CT_PKTS:
+	case NFT_CT_AVGPKT:
+		return sizeof(uint64_t);
+	case NFT_CT_SRC:
+	case NFT_CT_DST:
+	case NFT_CT_SRC_IP6:
+	case NFT_CT_DST_IP6:
+		return sizeof(uint32_t) * 4;
+	default:
+		assert(0);
+	}
+
+	return sizeof(uint32_t);
+}
+
+static bool
+nftnl_expr_ct_reg_cmp(const struct nftnl_reg *reg,
+		      const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_ct *ct = nftnl_expr_data(e);
+
+	return reg->ct.key == ct->key &&
+	       reg->ct.dir == ct->dir;
+}
+
+static void
+nftnl_expr_ct_reg_update(struct nftnl_reg *reg,
+			 const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_ct *ct = nftnl_expr_data(e);
+
+	reg->ct.key = ct->key;
+	reg->ct.dir = ct->dir;
+}
+
 static const char *ctkey2str_array[NFT_CT_MAX + 1] = {
 	[NFT_CT_STATE]		= "state",
 	[NFT_CT_DIRECTION]	= "direction",
@@ -259,4 +336,9 @@ struct expr_ops expr_ops_ct = {
 	.parse		= nftnl_expr_ct_parse,
 	.build		= nftnl_expr_ct_build,
 	.snprintf	= nftnl_expr_ct_snprintf,
+	.reg		= {
+		.len	= nftnl_expr_ct_reg_len,
+		.cmp	= nftnl_expr_ct_reg_cmp,
+		.update	= nftnl_expr_ct_reg_update,
+	},
 };
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 625dd5d3d0a4..53a2a807f49e 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -194,6 +194,38 @@ nftnl_expr_exthdr_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
+static int
+nftnl_expr_exthdr_reg_len(const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_exthdr *exthdr = nftnl_expr_data(e);
+
+	return exthdr->len;
+}
+
+static bool
+nftnl_expr_exthdr_reg_cmp(const struct nftnl_reg *reg,
+			       const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_exthdr *exthdr = nftnl_expr_data(e);
+
+	return reg->exthdr.offset == exthdr->offset &&
+	       reg->exthdr.type == exthdr->type &&
+	       reg->exthdr.op == exthdr->op &&
+	       reg->exthdr.flags == exthdr->flags;
+}
+
+static void
+nftnl_expr_exthdr_reg_update(struct nftnl_reg *reg,
+				  const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_exthdr *exthdr = nftnl_expr_data(e);
+
+	reg->exthdr.offset = exthdr->offset;
+	reg->exthdr.type = exthdr->type;
+	reg->exthdr.op = exthdr->op;
+	reg->exthdr.flags = exthdr->flags;
+}
+
 static const char *op2str(uint8_t op)
 {
 	switch (op) {
@@ -268,4 +300,9 @@ struct expr_ops expr_ops_exthdr = {
 	.parse		= nftnl_expr_exthdr_parse,
 	.build		= nftnl_expr_exthdr_build,
 	.snprintf	= nftnl_expr_exthdr_snprintf,
+	.reg		= {
+		.len	= nftnl_expr_exthdr_reg_len,
+		.cmp	= nftnl_expr_exthdr_reg_cmp,
+		.update	= nftnl_expr_exthdr_reg_update,
+	},
 };
diff --git a/src/expr/fib.c b/src/expr/fib.c
index aaff52acabdb..59b335a72546 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -14,6 +14,7 @@
 #include <string.h>
 #include <arpa/inet.h>
 #include <errno.h>
+#include <net/if.h>
 #include <linux/netfilter/nf_tables.h>
 
 #include "internal.h"
@@ -128,6 +129,45 @@ nftnl_expr_fib_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return ret;
 }
 
+static int
+nftnl_expr_fib_reg_len(const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_fib *fib = nftnl_expr_data(e);
+
+	switch (fib->result) {
+	case NFT_FIB_RESULT_OIF:
+		return sizeof(int);
+	case NFT_FIB_RESULT_OIFNAME:
+		return IFNAMSIZ;
+	case NFT_FIB_RESULT_ADDRTYPE:
+		return sizeof(uint32_t);
+	default:
+		assert(0);
+		break;
+	}
+	return sizeof(uint32_t);
+}
+
+static bool
+nftnl_expr_fib_reg_cmp(const struct nftnl_reg *reg,
+			       const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_fib *fib = nftnl_expr_data(e);
+
+	return reg->fib.result == fib->result &&
+	       reg->fib.flags == fib->flags;
+}
+
+static void
+nftnl_expr_fib_reg_update(struct nftnl_reg *reg,
+				  const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_fib *fib = nftnl_expr_data(e);
+
+	reg->fib.result = fib->result;
+	reg->fib.flags = fib->flags;
+}
+
 static const char *fib_type[NFT_FIB_RESULT_MAX + 1] = {
 	[NFT_FIB_RESULT_OIF] = "oif",
 	[NFT_FIB_RESULT_OIFNAME] = "oifname",
@@ -199,4 +239,9 @@ struct expr_ops expr_ops_fib = {
 	.parse		= nftnl_expr_fib_parse,
 	.build		= nftnl_expr_fib_build,
 	.snprintf	= nftnl_expr_fib_snprintf,
+	.reg		= {
+		.len	= nftnl_expr_fib_reg_len,
+		.cmp	= nftnl_expr_fib_reg_cmp,
+		.update	= nftnl_expr_fib_reg_update,
+	},
 };
diff --git a/src/expr/osf.c b/src/expr/osf.c
index 215a681a97aa..666b6b7dc942 100644
--- a/src/expr/osf.c
+++ b/src/expr/osf.c
@@ -11,6 +11,7 @@
 #include <libnftnl/rule.h>
 
 #define OSF_GENRE_SIZE	32
+#define NFT_OSF_MAXGENRELEN 16
 
 struct nftnl_expr_osf {
 	enum nft_registers	dreg;
@@ -124,6 +125,32 @@ nftnl_expr_osf_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
+static int
+nftnl_expr_osf_reg_len(const struct nftnl_expr *e)
+{
+	return NFT_OSF_MAXGENRELEN;
+}
+
+static bool
+nftnl_expr_osf_reg_cmp(const struct nftnl_reg *reg,
+		       const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_osf *osf = nftnl_expr_data(e);
+
+	return reg->osf.ttl == osf->ttl &&
+	       reg->osf.flags == osf->flags;
+}
+
+static void
+nftnl_expr_osf_reg_update(struct nftnl_reg *reg,
+			  const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_osf *osf = nftnl_expr_data(e);
+
+	reg->osf.ttl = osf->ttl;
+	reg->osf.flags = osf->flags;
+}
+
 static int
 nftnl_expr_osf_snprintf(char *buf, size_t len,
 			uint32_t flags, const struct nftnl_expr *e)
@@ -148,4 +175,9 @@ struct expr_ops expr_ops_osf = {
 	.parse		= nftnl_expr_osf_parse,
 	.build		= nftnl_expr_osf_build,
 	.snprintf	= nftnl_expr_osf_snprintf,
+	.reg		= {
+		.len	= nftnl_expr_osf_reg_len,
+		.cmp	= nftnl_expr_osf_reg_cmp,
+		.update	= nftnl_expr_osf_reg_update,
+	},
 };
diff --git a/src/expr/rt.c b/src/expr/rt.c
index 1ad9b2ad4043..16a1aff17a59 100644
--- a/src/expr/rt.c
+++ b/src/expr/rt.c
@@ -12,6 +12,7 @@
 #include <string.h>
 #include <arpa/inet.h>
 #include <errno.h>
+#include <assert.h>
 #include <linux/netfilter/nf_tables.h>
 
 #include "internal.h"
@@ -112,6 +113,46 @@ nftnl_expr_rt_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
+static int nftnl_expr_rt_reg_len(const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_rt *rt = nftnl_expr_data(e);
+
+	switch (rt->key) {
+	case NFT_RT_CLASSID:
+	case NFT_RT_NEXTHOP4:
+		return sizeof(uint32_t);
+	case NFT_RT_NEXTHOP6:
+		return sizeof(uint32_t) * 4;
+	case NFT_RT_TCPMSS:
+		return sizeof(uint16_t);
+	case NFT_RT_XFRM:
+		return sizeof(uint8_t);
+	default:
+		assert(0);
+		break;
+	}
+
+	return sizeof(uint32_t);
+}
+
+static bool
+nftnl_expr_rt_reg_cmp(const struct nftnl_reg *reg,
+			       const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_rt *rt = nftnl_expr_data(e);
+
+	return reg->rt.key == rt->key;
+}
+
+static void
+nftnl_expr_rt_reg_update(struct nftnl_reg *reg,
+				  const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_rt *rt = nftnl_expr_data(e);
+
+	reg->rt.key = rt->key;
+}
+
 static const char *rt_key2str_array[NFT_RT_MAX + 1] = {
 	[NFT_RT_CLASSID]	= "classid",
 	[NFT_RT_NEXTHOP4]	= "nexthop4",
@@ -163,4 +204,9 @@ struct expr_ops expr_ops_rt = {
 	.parse		= nftnl_expr_rt_parse,
 	.build		= nftnl_expr_rt_build,
 	.snprintf	= nftnl_expr_rt_snprintf,
+	.reg		= {
+		.len	= nftnl_expr_rt_reg_len,
+		.cmp	= nftnl_expr_rt_reg_cmp,
+		.update	= nftnl_expr_rt_reg_update,
+	},
 };
diff --git a/src/expr/socket.c b/src/expr/socket.c
index 02d86f8ac57c..edd28ca6a53c 100644
--- a/src/expr/socket.c
+++ b/src/expr/socket.c
@@ -12,6 +12,7 @@
 #include <string.h>
 #include <arpa/inet.h>
 #include <errno.h>
+#include <assert.h>
 #include <linux/netfilter/nf_tables.h>
 
 #include "internal.h"
@@ -126,6 +127,47 @@ nftnl_expr_socket_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
+static int
+nftnl_expr_socket_reg_len(const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_socket *socket = nftnl_expr_data(e);
+
+	switch(socket->key) {
+	case NFT_SOCKET_TRANSPARENT:
+	case NFT_SOCKET_WILDCARD:
+		return sizeof(uint8_t);
+	case NFT_SOCKET_MARK:
+		return sizeof(uint32_t);
+	case NFT_SOCKET_CGROUPV2:
+		return sizeof(uint64_t);
+	default:
+		assert(0);
+		break;
+	}
+
+	return sizeof(uint32_t);
+}
+
+static bool
+nftnl_expr_socket_reg_cmp(const struct nftnl_reg *reg,
+			  const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_socket *socket = nftnl_expr_data(e);
+
+	return reg->socket.key == socket->key &&
+	       reg->socket.level == socket->level;
+}
+
+static void
+nftnl_expr_socket_reg_update(struct nftnl_reg *reg,
+			     const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_socket *socket = nftnl_expr_data(e);
+
+	reg->socket.key = socket->key;
+	reg->socket.level = socket->level;
+}
+
 static const char *socket_key2str_array[NFT_SOCKET_MAX + 1] = {
 	[NFT_SOCKET_TRANSPARENT] = "transparent",
 	[NFT_SOCKET_MARK] = "mark",
@@ -166,4 +208,9 @@ struct expr_ops expr_ops_socket = {
 	.parse		= nftnl_expr_socket_parse,
 	.build		= nftnl_expr_socket_build,
 	.snprintf	= nftnl_expr_socket_snprintf,
+	.reg		= {
+		.len	= nftnl_expr_socket_reg_len,
+		.cmp	= nftnl_expr_socket_reg_cmp,
+		.update	= nftnl_expr_socket_reg_update,
+	},
 };
diff --git a/src/expr/xfrm.c b/src/expr/xfrm.c
index c81d14d638dc..7f6d7fe8d59e 100644
--- a/src/expr/xfrm.c
+++ b/src/expr/xfrm.c
@@ -10,6 +10,7 @@
 #include <stdint.h>
 #include <arpa/inet.h>
 #include <errno.h>
+#include <assert.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/xfrm.h>
 
@@ -141,6 +142,51 @@ nftnl_expr_xfrm_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
+static int
+nftnl_expr_xfrm_reg_len(const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_xfrm *xfrm = nftnl_expr_data(e);
+
+	switch (xfrm->key) {
+	case NFT_XFRM_KEY_REQID:
+	case NFT_XFRM_KEY_SPI:
+		return sizeof(uint32_t);
+	case NFT_XFRM_KEY_DADDR_IP4:
+	case NFT_XFRM_KEY_SADDR_IP4:
+		return sizeof(struct in_addr);
+	case NFT_XFRM_KEY_DADDR_IP6:
+	case NFT_XFRM_KEY_SADDR_IP6:
+		return sizeof(struct in6_addr);
+	default:
+		assert(0);
+		break;
+	}
+
+	return sizeof(struct in_addr);
+}
+
+static bool
+nftnl_expr_xfrm_reg_cmp(const struct nftnl_reg *reg,
+			const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_xfrm *xfrm = nftnl_expr_data(e);
+
+	return reg->xfrm.key == xfrm->key &&
+	       reg->xfrm.spnum == xfrm->spnum &&
+	       reg->xfrm.dir == xfrm->dir;
+}
+
+static void
+nftnl_expr_xfrm_reg_update(struct nftnl_reg *reg,
+			   const struct nftnl_expr *e)
+{
+	const struct nftnl_expr_xfrm *xfrm = nftnl_expr_data(e);
+
+	reg->xfrm.key = xfrm->key;
+	reg->xfrm.spnum = xfrm->spnum;
+	reg->xfrm.dir = xfrm->dir;
+}
+
 static const char *xfrmkey2str_array[] = {
 	[NFT_XFRM_KEY_DADDR_IP4]	= "daddr4",
 	[NFT_XFRM_KEY_SADDR_IP4]	= "saddr4",
@@ -197,4 +243,9 @@ struct expr_ops expr_ops_xfrm = {
 	.parse		= nftnl_expr_xfrm_parse,
 	.build		= nftnl_expr_xfrm_build,
 	.snprintf	= nftnl_expr_xfrm_snprintf,
+	.reg		= {
+		.len	= nftnl_expr_xfrm_reg_len,
+		.cmp	= nftnl_expr_xfrm_reg_cmp,
+		.update	= nftnl_expr_xfrm_reg_update,
+	},
 };
diff --git a/src/regs.c b/src/regs.c
index daedaba050a6..1551aa7d9ea7 100644
--- a/src/regs.c
+++ b/src/regs.c
@@ -55,10 +55,24 @@ void nftnl_regs_free(const struct nftnl_regs *regs)
 
 static enum nftnl_expr_type nftnl_expr_type(const struct nftnl_expr *expr)
 {
-	if (!strcmp(expr->ops->name, "meta"))
+	if (!strcmp(expr->ops->name, "ct"))
+		return NFT_EXPR_CT;
+	else if (!strcmp(expr->ops->name, "exthdr"))
+		return NFT_EXPR_EXTHDR;
+	else if (!strcmp(expr->ops->name, "fib"))
+		return NFT_EXPR_FIB;
+	else if (!strcmp(expr->ops->name, "meta"))
 		return NFT_EXPR_META;
+	else if (!strcmp(expr->ops->name, "osf"))
+		return NFT_EXPR_OSF;
 	else if (!strcmp(expr->ops->name, "payload"))
 		return NFT_EXPR_PAYLOAD;
+	else if (!strcmp(expr->ops->name, "rt"))
+		return NFT_EXPR_RT;
+	else if (!strcmp(expr->ops->name, "socket"))
+		return NFT_EXPR_SOCKET;
+	else if (!strcmp(expr->ops->name, "xfrm"))
+		return NFT_EXPR_XFRM;
 
 	assert(0);
 	return NFT_EXPR_UNSPEC;
-- 
2.30.2

