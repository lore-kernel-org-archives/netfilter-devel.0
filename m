From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 1/3] src: expose delinearize/linearize structures and
 stmt_error()
Date: Wed, 25 Mar 2015 20:15:56 +0100
Message-ID: <20150325191556.13491.88761.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57069 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752205AbbCYTQG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 15:16:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Needed by the follow up xt compatibility layer patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/netlink.h         |   41 ++++++++++++++++++++++++++++++++++++++++-
 include/statement.h       |   10 ++++++++++
 src/evaluate.c            |   12 ++++--------
 src/netlink_delinearize.c |   13 -------------
 src/netlink_linearize.c   |    5 -----
 5 files changed, 54 insertions(+), 27 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index c1ff9c6..57f7a7b 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -12,10 +12,49 @@
 
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
+
 extern const struct input_descriptor indesc_netlink;
 extern const struct location netlink_location;
 
-/** 
+/**
  * struct netlink_ctx
  *
  * @msgs:	message queue
diff --git a/include/statement.h b/include/statement.h
index d143121..23d2d84 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -194,4 +194,14 @@ extern void stmt_free(struct stmt *stmt);
 extern void stmt_list_free(struct list_head *list);
 extern void stmt_print(const struct stmt *stmt);
 
+int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
+					  const struct location *l1,
+					  const struct location *l2,
+					  const char *fmt, ...);
+
+#define stmt_error(ctx, s1, fmt, args...) \
+	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
+#define stmt_binary_error(ctx, s1, s2, fmt, args...) \
+	__stmt_binary_error(ctx, &(s1)->location, &(s2)->location, fmt, ## args)
+
 #endif /* NFTABLES_STATEMENT_H */
diff --git a/src/evaluate.c b/src/evaluate.c
index 7ecb793..c420cd4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -36,10 +36,10 @@ static const char *byteorder_names[] = {
 	[BYTEORDER_BIG_ENDIAN]		= "big endian",
 };
 
-static int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
-						 const struct location *l1,
-						 const struct location *l2,
-						 const char *fmt, ...)
+int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
+					  const struct location *l1,
+					  const struct location *l2,
+					  const char *fmt, ...)
 {
 	struct error_record *erec;
 	va_list ap;
@@ -54,10 +54,6 @@ static int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
 
 }
 
-#define stmt_error(ctx, s1, fmt, args...) \
-	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
-#define stmt_binary_error(ctx, s1, s2, fmt, args...) \
-	__stmt_binary_error(ctx, &(s1)->location, &(s2)->location, fmt, ## args)
 #define chain_error(ctx, s1, fmt, args...) \
 	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
 #define monitor_error(ctx, s1, fmt, args...) \
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 387bb67..3bae7d6 100644
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

