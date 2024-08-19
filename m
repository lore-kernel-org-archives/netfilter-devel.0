Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9685E1CF83
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 22:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724105931; cv=none; b=AQPi8dK7RnrIK2qX6obcSeuRqiuRzuAGdW/SYGOpj53rJT9/FIRst5nh1xY0Y3ojrSWqxBdR2k4TZ9Fuuw0UQmXQkfzFi2snSiQ/G/3jnAdeQ0b0ghA/QnHcgB9mUH29Ns1QgQTiRVoQFK7WQ0JWZc4vhtysC9iNzDOzRpHtUZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724105931; c=relaxed/simple;
	bh=05LZq2qpojhtXrVsSccfcUQ9twOPFzTLURkuieLls10=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=cKgpVPQtQdeDgozvVwkVNUWMFYevX8dwS6Ep44IsgvQDkbpia86zE7IzN2S6aS/LrlwlvZ5AHhFn6NW5AuNCHZQmPl2kOKCS6620GmhhFmrxsFA0hOgut8hWXVtpobRQvAGYpjga32bfrG+CQtGYkc2TEDl6xWxpTXFllY/E8hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] src: remove DTYPE_F_PREFIX
Date: Tue, 20 Aug 2024 00:18:33 +0200
Message-Id: <20240819221834.972153-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

only ipv4 and ipv6 datatype support this, add datatype_prefix_notation()
helper function to report that datatype prefers prefix notation, if
possible.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h        | 3 +--
 src/datatype.c            | 7 +++++--
 src/netlink_delinearize.c | 2 +-
 src/segtree.c             | 4 ++--
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index d4b4737cc9ae..09b84eca27a7 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -124,11 +124,9 @@ struct expr;
  * enum datatype_flags
  *
  * @DTYPE_F_ALLOC:		datatype is dynamically allocated
- * @DTYPE_F_PREFIX:		preferred representation for ranges is a prefix
  */
 enum datatype_flags {
 	DTYPE_F_ALLOC		= (1 << 0),
-	DTYPE_F_PREFIX		= (1 << 1),
 };
 
 struct parse_ctx;
@@ -179,6 +177,7 @@ extern void datatype_set(struct expr *expr, const struct datatype *dtype);
 extern void __datatype_set(struct expr *expr, const struct datatype *dtype);
 extern void datatype_free(const struct datatype *dtype);
 struct datatype *datatype_clone(const struct datatype *orig_dtype);
+bool datatype_prefix_notation(const struct datatype *dtype);
 
 struct parse_ctx {
 	struct symbol_tables	*tbl;
diff --git a/src/datatype.c b/src/datatype.c
index 6bbe900295f7..9293f38ed713 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -123,6 +123,11 @@ void datatype_print(const struct expr *expr, struct output_ctx *octx)
 	    expr->dtype->name);
 }
 
+bool datatype_prefix_notation(const struct datatype *dtype)
+{
+	return dtype->type == TYPE_IPADDR || dtype->type == TYPE_IP6ADDR;
+}
+
 struct error_record *symbol_parse(struct parse_ctx *ctx, const struct expr *sym,
 				  struct expr **res)
 {
@@ -642,7 +647,6 @@ const struct datatype ipaddr_type = {
 	.basetype	= &integer_type,
 	.print		= ipaddr_type_print,
 	.parse		= ipaddr_type_parse,
-	.flags		= DTYPE_F_PREFIX,
 };
 
 static void ip6addr_type_print(const struct expr *expr, struct output_ctx *octx)
@@ -709,7 +713,6 @@ const struct datatype ip6addr_type = {
 	.basetype	= &integer_type,
 	.print		= ip6addr_type_print,
 	.parse		= ip6addr_type_parse,
-	.flags		= DTYPE_F_PREFIX,
 };
 
 static void inet_protocol_type_print(const struct expr *expr,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 82e68999a432..e3d9cfbbede5 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2536,7 +2536,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 			BUG("unknown operation type %d\n", expr->op);
 		}
 		expr_free(binop);
-	} else if (binop->left->dtype->flags & DTYPE_F_PREFIX &&
+	} else if (datatype_prefix_notation(binop->left->dtype) &&
 		   binop->op == OP_AND && expr->right->etype == EXPR_VALUE &&
 		   expr_mask_is_prefix(binop->right)) {
 		expr->left = expr_get(binop->left);
diff --git a/src/segtree.c b/src/segtree.c
index 4df96467c3f5..2e32a3291979 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -402,7 +402,7 @@ void concat_range_aggregate(struct expr *set)
 			}
 
 			if (prefix_len < 0 ||
-			    !(r1->dtype->flags & DTYPE_F_PREFIX)) {
+			    !datatype_prefix_notation(r1->dtype)) {
 				tmp = range_expr_alloc(&r1->location, r1,
 						       r2);
 
@@ -517,7 +517,7 @@ add_interval(struct expr *set, struct expr *low, struct expr *i)
 		expr = expr_get(low);
 	} else if (range_is_prefix(range) && !mpz_cmp_ui(p, 0)) {
 
-		if (i->dtype->flags & DTYPE_F_PREFIX)
+		if (datatype_prefix_notation(i->dtype))
 			expr = interval_to_prefix(low, i, range);
 		else if (expr_basetype(i)->type == TYPE_STRING)
 			expr = interval_to_string(low, i, range);
-- 
2.30.2

