Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED37E283FE5
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Oct 2025 08:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760690610; cv=none; b=Y9Fj/ju+uMYEej/RRwJClnw80Ob2RezWyenJpI8CERiDSAG0hgPOQttmmho2aZbM6j6tV5ufxUjI/nlSZYjAN6vJLkcMHjgqNm4bnb4u4Fo4gpytwdtzpCyfa7Eq5ykgpMJMQ4GZshREHFSbD1/wvLMG09UgY58FZqBxs8+AGdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760690610; c=relaxed/simple;
	bh=05CmfAFysb5dcxsBEmwp+KLw1hNBpm5IWKGC1kj9U6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kfHn3sjQFvSbZ9pEl88fytgCqFPb7XLeEhkfCCLZHPq/xkx2nDZORHSMlvOH6pOFagC4hTQPhQt1kO06S8uZ0gVLOt+5GFL7nFHrUQiLETGAPbBU9hxyp+2nKPVDr2T0NKcWGm/KjdonWzZeBDM8bLf/yPwBsCPF0JPnV3efIY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 32AAC60329; Fri, 17 Oct 2025 10:43:25 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: fix fmt string warnings
Date: Fri, 17 Oct 2025 10:43:16 +0200
Message-ID: <20251017084320.19462-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

for some reason several functions had a __gmp_fmtstring annotation,
but that was an empty macro.

After fixing it up, we get several new warnings:

In file included from src/datatype.c:28:
src/datatype.c:174:24: note: in expansion of macro 'error'
  174 |                 return error(&sym->location,
      |                        ^~~~~
src/datatype.c:405:24: note: in expansion of macro 'error'
  405 |                 return error(&sym->location, "Could not parse %s; did you mean `%s'?",
      |                        ^~~~~

Fmt string says '%s', but unqailified void *, add 'const char *' cast,
it is safe in both cases.

In file included from src/evaluate.c:29:
src/evaluate.c: In function 'byteorder_conversion':
src/evaluate.c:232:35: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
  232 |                                   "Byteorder mismatch: %s expected %s, %s got %s",
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Actual bug, fmt string has one '%s' too many, remove it.

All other warnings were due to '%u' instead of '%lu' / '%zu'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/erec.h       | 4 ++--
 include/expression.h | 2 +-
 include/utils.h      | 5 -----
 src/datatype.c       | 4 ++--
 src/evaluate.c       | 8 ++++----
 src/parser_bison.y   | 2 +-
 6 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/include/erec.h b/include/erec.h
index c17f5def5302..8ad5d83a705d 100644
--- a/include/erec.h
+++ b/include/erec.h
@@ -40,10 +40,10 @@ struct error_record {
 extern struct error_record *erec_vcreate(enum error_record_types type,
 					 const struct location *loc,
 					 const char *fmt, va_list ap)
-					 __gmp_fmtstring(3, 0);
+					 __fmtstring(3, 0);
 extern struct error_record *erec_create(enum error_record_types type,
 					const struct location *loc,
-					const char *fmt, ...) __gmp_fmtstring(3, 4);
+					const char *fmt, ...) __fmtstring(3, 4);
 extern void erec_add_location(struct error_record *erec,
 			      const struct location *loc);
 extern void erec_destroy(struct error_record *erec);
diff --git a/include/expression.h b/include/expression.h
index e73ad90e7e5d..a960f8cb8b08 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -441,7 +441,7 @@ extern void expr_set_type(struct expr *expr, const struct datatype *dtype,
 struct eval_ctx;
 extern int expr_binary_error(struct list_head *msgs,
 			     const struct expr *e1, const struct expr *e2,
-			     const char *fmt, ...) __gmp_fmtstring(4, 5);
+			     const char *fmt, ...) __fmtstring(4, 5);
 
 #define expr_error(msgs, expr, fmt, args...) \
 	expr_binary_error(msgs, expr, NULL, fmt, ## args)
diff --git a/include/utils.h b/include/utils.h
index e18fabec56ba..474c7595f7cd 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -27,11 +27,6 @@
 #endif
 
 #define __fmtstring(x, y)	__attribute__((format(printf, x, y)))
-#if 0
-#define __gmp_fmtstring(x, y)	__fmtstring(x, y)
-#else
-#define __gmp_fmtstring(x, y)
-#endif
 
 #define __must_check		__attribute__((warn_unused_result))
 #define __noreturn		__attribute__((__noreturn__))
diff --git a/src/datatype.c b/src/datatype.c
index f347010f4a1a..956ce2ac0a97 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -173,7 +173,7 @@ static struct error_record *__symbol_parse_fuzzy(const struct expr *sym,
 	if (st.obj) {
 		return error(&sym->location,
 			     "Could not parse %s expression; did you you mean `%s`?",
-			     sym->dtype->desc, st.obj);
+			     sym->dtype->desc, (const char *)st.obj);
 	}
 
 	return NULL;
@@ -403,7 +403,7 @@ static struct error_record *verdict_type_error(const struct expr *sym)
 
 	if (st.obj) {
 		return error(&sym->location, "Could not parse %s; did you mean `%s'?",
-			     sym->dtype->desc, st.obj);
+			     sym->dtype->desc, (const char *)st.obj);
 	}
 
 	/* assume user would like to jump to chain as a hint. */
diff --git a/src/evaluate.c b/src/evaluate.c
index a5cc41819198..ffd3ce626859 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -229,7 +229,7 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 		return 0;
 	default:
 		return expr_error(ctx->msgs, *expr,
-				  "Byteorder mismatch: %s expected %s, %s got %s",
+				  "Byteorder mismatch: expected %s, %s got %s",
 				  byteorder_names[byteorder],
 				  expr_name(*expr),
 				  byteorder_names[(*expr)->byteorder]);
@@ -1811,7 +1811,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 		ctx->inner_desc = NULL;
 
 		if (size > NFT_MAX_EXPR_LEN_BITS)
-			return expr_error(ctx->msgs, i, "Concatenation of size %u exceeds maximum size of %u",
+			return expr_error(ctx->msgs, i, "Concatenation of size %u exceeds maximum size of %lu",
 					  size, NFT_MAX_EXPR_LEN_BITS);
 	}
 
@@ -3507,7 +3507,7 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 
 	if (payload_byte_size > sizeof(data))
 		return expr_error(ctx->msgs, stmt->payload.expr,
-				  "uneven load cannot span more than %u bytes, got %u",
+				  "uneven load cannot span more than %zu bytes, got %u",
 				  sizeof(data), payload_byte_size);
 
 	if (aligned_fetch && payload_byte_size & 1) {
@@ -5187,7 +5187,7 @@ static int set_expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 		size += netlink_padded_len(i->len);
 
 		if (size > NFT_MAX_EXPR_LEN_BITS)
-			return expr_error(ctx->msgs, i, "Concatenation of size %u exceeds maximum size of %u",
+			return expr_error(ctx->msgs, i, "Concatenation of size %u exceeds maximum size of %lu",
 					  size, NFT_MAX_EXPR_LEN_BITS);
 	}
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3c21c7584d01..52730f71b880 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -5863,7 +5863,7 @@ payload_expr		:	payload_raw_expr
 payload_raw_len		:	NUM
 			{
 				if ($1 > NFT_MAX_EXPR_LEN_BITS) {
-					erec_queue(error(&@1, "raw payload length %u exceeds upper limit of %u",
+					erec_queue(error(&@1, "raw payload length %lu exceeds upper limit of %lu",
 							 $1, NFT_MAX_EXPR_LEN_BITS),
 						 state->msgs);
 					YYERROR;
-- 
2.51.0

