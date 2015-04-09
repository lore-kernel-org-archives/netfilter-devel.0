From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft v2 2/3] src: expose delinearize/linearize structures and stmt_error()
Date: Thu,  9 Apr 2015 18:55:13 +0200
Message-ID: <1428598514-1915-2-git-send-email-pablo@netfilter.org>
References: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49023 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251AbbDIQvK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 12:51:10 -0400
In-Reply-To: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Needed by the follow up xt compatibility layer patch.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no need to include <rule.h> in erec.h.

 include/erec.h            |   12 ++++++++++++
 include/netlink.h         |   40 +++++++++++++++++++++++++++++++++++++++-
 src/erec.c                |   17 +++++++++++++++++
 src/evaluate.c            |   26 ++------------------------
 src/netlink_delinearize.c |   13 -------------
 src/netlink_linearize.c   |    5 -----
 6 files changed, 70 insertions(+), 43 deletions(-)

diff --git a/include/erec.h b/include/erec.h
index 25df1d0..d03859a 100644
--- a/include/erec.h
+++ b/include/erec.h
@@ -61,4 +61,16 @@ static inline void erec_queue(struct error_record *erec,
 extern void erec_print(FILE *f, const struct error_record *erec);
 extern void erec_print_list(FILE *f, struct list_head *list);
 
+struct eval_ctx;
+
+extern int __fmtstring(4, 5) __binary_error(struct eval_ctx *ctx,
+					    const struct location *l1,
+					    const struct location *l2,
+					    const char *fmt, ...);
+
+#define stmt_error(ctx, s1, fmt, args...) \
+	__binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
+#define stmt_binary_error(ctx, s1, s2, fmt, args...) \
+	__binary_error(ctx, &(s1)->location, &(s2)->location, fmt, ## args)
+
 #endif /* NFTABLES_EREC_H */
diff --git a/include/netlink.h b/include/netlink.h
index 9f24ea5..0762990 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -12,10 +12,48 @@
 
 #include <rule.h>
 
+/** struct netlink_linearize_ctx
+ *
+ * @nlr:	nftnl rule object
+ * @reg_low:	next spare register
+ */
+struct netlink_linearize_ctx {
+	struct nft_rule		*nlr;
+	unsigned int		reg_low;
+};
+
+/**
+ * struct netlink_parse_ctx
+ *
+ * @msgs:	message queue
+ * @table:	current table
+ * @rule:	pointer to current rule that is being delinearized
+ * @expr:	registers
+ */
+struct netlink_parse_ctx {
+	struct list_head	*msgs;
+	struct table		*table;
+	struct rule		*rule;
+	struct expr		*registers[NFT_REG_MAX + 1];
+};
+
+/**
+ * struct rule_pp_ctx
+ *
+ * @pctx:	protocol context
+ * @pbase:	protocol base
+ * @pdep:	dependency statement
+ */
+struct rule_pp_ctx {
+	struct proto_ctx	pctx;
+	enum proto_bases	pbase;
+	struct stmt		*pdep;
+};
+
 extern const struct input_descriptor indesc_netlink;
 extern const struct location netlink_location;
 
-/** 
+/**
  * struct netlink_ctx
  *
  * @msgs:	message queue
diff --git a/src/erec.c b/src/erec.c
index 810e9bf..ba331a5 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -166,3 +166,20 @@ void erec_print_list(FILE *f, struct list_head *list)
 		erec_destroy(erec);
 	}
 }
+
+int __fmtstring(4, 5) __binary_error(struct eval_ctx *ctx,
+				     const struct location *l1,
+				     const struct location *l2,
+				     const char *fmt, ...)
+{
+	struct error_record *erec;
+	va_list ap;
+
+	va_start(ap, fmt);
+	erec = erec_vcreate(EREC_ERROR, l1, fmt, ap);
+	if (l2 != NULL)
+		erec_add_location(erec, l2);
+	va_end(ap);
+	erec_queue(erec, ctx->msgs);
+	return -1;
+}
diff --git a/src/evaluate.c b/src/evaluate.c
index 7ecb793..b216fb1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -36,32 +36,10 @@ static const char *byteorder_names[] = {
 	[BYTEORDER_BIG_ENDIAN]		= "big endian",
 };
 
-static int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
-						 const struct location *l1,
-						 const struct location *l2,
-						 const char *fmt, ...)
-{
-	struct error_record *erec;
-	va_list ap;
-
-	va_start(ap, fmt);
-	erec = erec_vcreate(EREC_ERROR, l1, fmt, ap);
-	if (l2 != NULL)
-		erec_add_location(erec, l2);
-	va_end(ap);
-	erec_queue(erec, ctx->msgs);
-	return -1;
-
-}
-
-#define stmt_error(ctx, s1, fmt, args...) \
-	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
-#define stmt_binary_error(ctx, s1, s2, fmt, args...) \
-	__stmt_binary_error(ctx, &(s1)->location, &(s2)->location, fmt, ## args)
 #define chain_error(ctx, s1, fmt, args...) \
-	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
+	__binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
 #define monitor_error(ctx, s1, fmt, args...) \
-	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
+	__binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
 
 static int __fmtstring(3, 4) set_error(struct eval_ctx *ctx,
 				       const struct set *set,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ec1a964..e0bb726 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -26,13 +26,6 @@
 #include <erec.h>
 #include <sys/socket.h>
 
-struct netlink_parse_ctx {
-	struct list_head	*msgs;
-	struct table		*table;
-	struct rule		*rule;
-	struct expr		*registers[NFT_REG_MAX + 1];
-};
-
 static void __fmtstring(3, 4) netlink_error(struct netlink_parse_ctx *ctx,
 					    const struct location *loc,
 					    const char *fmt, ...)
@@ -741,12 +734,6 @@ static int netlink_parse_expr(struct nft_rule_expr *nle, void *arg)
 	return 0;
 }
 
-struct rule_pp_ctx {
-	struct proto_ctx	pctx;
-	enum proto_bases	pbase;
-	struct stmt		*pdep;
-};
-
 /*
  * Kill a redundant payload dependecy that is implied by a higher layer payload expression.
  */
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 9bef67b..6a637a4 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -19,11 +19,6 @@
 #include <gmputil.h>
 #include <utils.h>
 
-struct netlink_linearize_ctx {
-	struct nft_rule		*nlr;
-	unsigned int		reg_low;
-};
-
 static void netlink_put_register(struct nft_rule_expr *nle,
 				 uint32_t attr, uint32_t reg)
 {
-- 
1.7.10.4

