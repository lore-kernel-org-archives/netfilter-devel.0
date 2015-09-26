From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] src: allow filtering on L2 header in inet family
Date: Sat, 26 Sep 2015 05:14:02 +0200
Message-ID: <1443237243-4571-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34197 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932316AbbIZDOU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Sep 2015 23:14:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Error: conflicting protocols specified: inet vs. ether
tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4
                                   ^^^^^^^^^^^

This allows the implicit inet proto dependency to get replaced
by an ethernet one.

This is possible since by the time we detect the conflict the
meta dependency for the network protocol has already been added.

So we only need to add another dependency on the Linklayer frame type.

Closes: http://bugzilla.netfilter.org/show_bug.cgi?id=981
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/meta.h |  1 +
 src/evaluate.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 src/meta.c     | 24 +++++++++++++++++++++++-
 src/payload.c  |  8 +-------
 4 files changed, 71 insertions(+), 9 deletions(-)

diff --git a/include/meta.h b/include/meta.h
index 459221f..40652e3 100644
--- a/include/meta.h
+++ b/include/meta.h
@@ -26,4 +26,5 @@ struct meta_template {
 extern struct expr *meta_expr_alloc(const struct location *loc,
 				    enum nft_meta_keys key);
 
+struct stmt *meta_stmt_meta_iiftype(const struct location *loc, uint16_t type);
 #endif /* NFTABLES_META_H */
diff --git a/src/evaluate.c b/src/evaluate.c
index 581f364..165d360 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -286,6 +286,34 @@ conflict_resolution_gen_dependency(struct eval_ctx *ctx, int protocol,
 	return 0;
 }
 
+/* dependency supersede.
+ *
+ * 'inet' is a 'phony' l2 dependeny used by NFPROTO_INET to fulfill network
+ * header dependency, i.e. ensure that 'ip saddr 1.2.3.4' only sees ip headers.
+ *
+ * If a match expression that depends on a particular L2 header, e.g. ethernet,
+ * is used, we thus get a conflict since we already have a l2 header dependency.
+ *
+ * But in the inet case we can just ignore the conflict since only another
+ * restriction is added, and these are not mutually exclusive.
+ *
+ * Example: inet filter in ip saddr 1.2.3.4 ether saddr a:b:c:d:e:f
+ *
+ * ip saddr adds meta dependency on ipv4 packets
+ * ether saddr adds another dependeny on ethernet frames.
+ */
+static bool supersede_dep(const struct proto_desc *have,
+			  struct expr *payload)
+{
+	if (payload->payload.base != PROTO_BASE_LL_HDR || have->length)
+		return false;
+
+	if (have != &proto_inet)
+		return false;
+
+	return true;
+}
+
 static bool resolve_protocol_conflict(struct eval_ctx *ctx,
 				      struct expr *payload)
 {
@@ -305,7 +333,24 @@ static bool resolve_protocol_conflict(struct eval_ctx *ctx,
 	if (payload->payload.base != h->base)
 		return false;
 
-	assert(desc->length);
+	if (supersede_dep(desc, payload)) {
+		uint16_t type;
+
+		if (proto_dev_type(payload->payload.desc, &type) < 0)
+			return expr_error(ctx->msgs, payload,
+					  "protocol specification is invalid "
+					  "for this family");
+
+		nstmt = meta_stmt_meta_iiftype(&payload->location, type);
+		if (stmt_evaluate(ctx, nstmt) < 0)
+			return expr_error(ctx->msgs, payload,
+					  "dependency statement is invalid");
+
+		list_add_tail(&nstmt->list, &ctx->stmt->list);
+		ctx->pctx.protocol[base].desc = payload->payload.desc;
+		return true;
+	}
+
 	if (base < PROTO_BASE_MAX) {
 		const struct proto_desc *next = ctx->pctx.protocol[base + 1].desc;
 
diff --git a/src/meta.c b/src/meta.c
index bfc1258..0b52fda 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -19,6 +19,8 @@
 #include <net/if_arp.h>
 #include <pwd.h>
 #include <grp.h>
+#include <arpa/inet.h>
+#include <linux/netfilter.h>
 #include <linux/pkt_sched.h>
 #include <linux/if_packet.h>
 
@@ -468,7 +470,7 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 
 	switch (left->meta.key) {
 	case NFT_META_IIFTYPE:
-		if (h->base < PROTO_BASE_NETWORK_HDR)
+		if (h->base < PROTO_BASE_NETWORK_HDR && ctx->family != NFPROTO_INET)
 			return;
 
 		desc = proto_dev_desc(mpz_get_uint16(right->value));
@@ -572,3 +574,23 @@ static void __init meta_init(void)
 	datatype_register(&devgroup_type);
 	datatype_register(&pkttype_type);
 }
+
+/*
+ * @expr:	payload expression
+ * @res:	dependency expression
+ *
+ * Generate a NFT_META_IIFTYPE expression to check for ethernet frames.
+ * Only works on input path.
+ */
+struct stmt *meta_stmt_meta_iiftype(const struct location *loc, uint16_t type)
+{
+	struct expr *dep, *left, *right;
+
+	left = meta_expr_alloc(loc, NFT_META_IIFTYPE);
+	right = constant_expr_alloc(loc, &arphrd_type,
+				    BYTEORDER_HOST_ENDIAN,
+				    2 * BITS_PER_BYTE, &type);
+
+	dep = relational_expr_alloc(loc, OP_EQ, left, right);
+	return expr_stmt_alloc(&dep->location, dep);
+}
diff --git a/src/payload.c b/src/payload.c
index 23afa2f..b75527a 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -183,13 +183,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 					  "protocol specification is invalid "
 					  "for this family");
 
-		left = meta_expr_alloc(&expr->location, NFT_META_IIFTYPE);
-		right = constant_expr_alloc(&expr->location, &arphrd_type,
-					    BYTEORDER_HOST_ENDIAN,
-					    2 * BITS_PER_BYTE, &type);
-
-		dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
-		stmt = expr_stmt_alloc(&dep->location, dep);
+		stmt = meta_stmt_meta_iiftype(&expr->location, type);
 		if (stmt_evaluate(ctx, stmt) < 0) {
 			return expr_error(ctx->msgs, expr,
 					  "dependency statement is invalid");
-- 
2.0.5

