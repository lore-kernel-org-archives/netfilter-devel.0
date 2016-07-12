From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft v5 2/3] src: expose delinearize/linearize structures and stmt_error()
Date: Tue, 12 Jul 2016 22:04:16 +0200
Message-ID: <20160712200417.21890-2-pablombg@gmail.com>
References: <20160712200417.21890-1-pablombg@gmail.com>
Cc: pablo@netfilter.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36118 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbcGLUGP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jul 2016 16:06:15 -0400
Received: by mail-wm0-f66.google.com with SMTP id x83so3192393wma.3
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2016 13:06:00 -0700 (PDT)
In-Reply-To: <20160712200417.21890-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira <pablo@netfilter.org>

Needed by the follow up xt compatibility layer patch.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

Resubmission of xt compat support preparatory patch.

Changes in v5:
  - Discard __stmt_binary_error() rename.

 include/erec.h            | 12 ++++++++++++
 include/netlink.h         | 14 ++++++++++++++
 src/erec.c                | 17 +++++++++++++++++
 src/evaluate.c            | 22 ----------------------
 src/netlink_delinearize.c | 14 --------------
 5 files changed, 43 insertions(+), 36 deletions(-)

diff --git a/include/erec.h b/include/erec.h
index 25df1d0..36e0efa 100644
--- a/include/erec.h
+++ b/include/erec.h
@@ -61,4 +61,16 @@ static inline void erec_queue(struct error_record *erec,
 extern void erec_print(FILE *f, const struct error_record *erec);
 extern void erec_print_list(FILE *f, struct list_head *list);
 
+struct eval_ctx;
+
+extern int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
+						 const struct location *l1,
+						 const struct location *l2,
+						 const char *fmt, ...);
+
+#define stmt_error(ctx, s1, fmt, args...) \
+	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
+#define stmt_binary_error(ctx, s1, s2, fmt, args...) \
+	__stmt_binary_error(ctx, &(s1)->location, &(s2)->location, fmt, ## args)
+
 #endif /* NFTABLES_EREC_H */
diff --git a/include/netlink.h b/include/netlink.h
index 9f46560..76a9da4 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -12,6 +12,20 @@
 
 #include <rule.h>
 
+struct netlink_parse_ctx {
+	struct list_head	*msgs;
+	struct table		*table;
+	struct rule		*rule;
+	struct stmt		*stmt;
+	struct expr		*registers[1 + NFT_REG32_15 - NFT_REG32_00 + 1];
+};
+
+struct rule_pp_ctx {
+	struct proto_ctx	pctx;
+	struct payload_dep_ctx	pdctx;
+	struct stmt		*stmt;
+};
+
 extern const struct input_descriptor indesc_netlink;
 extern const struct location netlink_location;
 
diff --git a/src/erec.c b/src/erec.c
index d514230..0a1e6c7 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -176,3 +176,20 @@ void erec_print_list(FILE *f, struct list_head *list)
 		erec_destroy(erec);
 	}
 }
+
+int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
+					  const struct location *l1,
+					  const struct location *l2,
+					  const char *fmt, ...)
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
index f24e5f3..27deb15 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -37,28 +37,6 @@ static const char *byteorder_names[] = {
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
 	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
 #define monitor_error(ctx, s1, fmt, args...) \
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 7735699..fffbe26 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -27,14 +27,6 @@
 #include <sys/socket.h>
 #include <libnftnl/udata.h>
 
-struct netlink_parse_ctx {
-	struct list_head	*msgs;
-	struct table		*table;
-	struct rule		*rule;
-	struct stmt		*stmt;
-	struct expr		*registers[1 + NFT_REG32_15 - NFT_REG32_00 + 1];
-};
-
 static int netlink_parse_expr(const struct nftnl_expr *nle,
 			      struct netlink_parse_ctx *ctx);
 
@@ -1047,12 +1039,6 @@ struct stmt *netlink_parse_set_expr(const struct set *set,
 	return pctx->stmt;
 }
 
-struct rule_pp_ctx {
-	struct proto_ctx	pctx;
-	struct payload_dep_ctx	pdctx;
-	struct stmt		*stmt;
-};
-
 static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp);
 
 static void integer_type_postprocess(struct expr *expr)
-- 
2.9.0

