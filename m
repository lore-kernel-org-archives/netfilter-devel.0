Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813D8C433B4
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 May 2021 16:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F55961421
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 May 2021 16:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhEJQye (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 May 2021 12:54:34 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54296 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbhEJQyd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 May 2021 12:54:33 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 030E564165
        for <netfilter-devel@vger.kernel.org>; Mon, 10 May 2021 18:52:39 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables 2/2] src: add set element catch-all support
Date:   Mon, 10 May 2021 18:53:21 +0200
Message-Id: <20210510165322.130181-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510165322.130181-1-pablo@netfilter.org>
References: <20210510165322.130181-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a catchall expression (EXPR_SET_ELEM_CATCHALL).

Use the underscore (_) to represent the catch-all set element, e.g.

 table x {
     set y {
	type ipv4_addr
	counter
	elements = { 1.2.3.4 counter packets 0 bytes 0, _ counter packets 0 bytes 0 }
     }
 }

Special handling for segtree: zap the catch-all element from the set
element list and re-add it after processing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h                |  3 ++
 include/linux/netfilter/nf_tables.h |  2 +
 src/evaluate.c                      | 11 +++++
 src/expression.c                    | 29 +++++++++++-
 src/mergesort.c                     |  4 ++
 src/netlink.c                       | 71 ++++++++++++++++++-----------
 src/parser_bison.y                  |  2 +
 src/scanner.l                       |  1 +
 src/segtree.c                       | 31 ++++++++++++-
 9 files changed, 125 insertions(+), 29 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 7e626c48d5ea..be703d755b6e 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -71,6 +71,7 @@ enum expr_types {
 	EXPR_RT,
 	EXPR_FIB,
 	EXPR_XFRM,
+	EXPR_SET_ELEM_CATCHALL,
 };
 #define EXPR_MAX EXPR_XFRM
 
@@ -497,6 +498,8 @@ extern struct expr *set_ref_expr_alloc(const struct location *loc,
 extern struct expr *set_elem_expr_alloc(const struct location *loc,
 					struct expr *key);
 
+struct expr *set_elem_catchall_expr_alloc(const struct location *loc);
+
 extern void range_expr_value_low(mpz_t rop, const struct expr *expr);
 extern void range_expr_value_high(mpz_t rop, const struct expr *expr);
 
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 8c85ef8e994d..894a62cf881f 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -393,9 +393,11 @@ enum nft_set_attributes {
  * enum nft_set_elem_flags - nf_tables set element flags
  *
  * @NFT_SET_ELEM_INTERVAL_END: element ends the previous interval
+ * @NFT_SET_ELEM_CATCHALL: special catch-all element
  */
 enum nft_set_elem_flags {
 	NFT_SET_ELEM_INTERVAL_END	= 0x1,
+	NFT_SET_ELEM_CATCHALL		= 0x2,
 };
 
 /**
diff --git a/src/evaluate.c b/src/evaluate.c
index b5dcdd3542f1..e91d5236564e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1413,6 +1413,15 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+static int expr_evaluate_set_elem_catchall(struct eval_ctx *ctx, struct expr **expr)
+{
+	struct expr *elem = *expr;
+
+	elem->flags |= EXPR_F_CONSTANT | EXPR_F_SINGLETON;
+
+	return 0;
+}
+
 static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *set = *expr, *i, *next;
@@ -2201,6 +2210,8 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		return expr_evaluate_hash(ctx, expr);
 	case EXPR_XFRM:
 		return expr_evaluate_xfrm(ctx, expr);
+	case EXPR_SET_ELEM_CATCHALL:
+		return expr_evaluate_set_elem_catchall(ctx, expr);
 	default:
 		BUG("unknown expression type %s\n", expr_name(*expr));
 	}
diff --git a/src/expression.c b/src/expression.c
index 9fdf23d98446..d6f7ac052fdd 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1270,7 +1270,11 @@ static void set_elem_expr_print(const struct expr *expr,
 {
 	struct stmt *stmt;
 
-	expr_print(expr->key, octx);
+	if (expr->key->etype == EXPR_SET_ELEM_CATCHALL)
+		nft_print(octx, "_");
+	else
+		expr_print(expr->key, octx);
+
 	list_for_each_entry(stmt, &expr->stmt_list, list) {
 		nft_print(octx, " ");
 		stmt_print(stmt, octx);
@@ -1299,7 +1303,9 @@ static void set_elem_expr_destroy(struct expr *expr)
 
 static void set_elem_expr_clone(struct expr *new, const struct expr *expr)
 {
-	new->key = expr_clone(expr->key);
+	if (expr->key)
+		new->key = expr_clone(expr->key);
+
 	new->expiration = expr->expiration;
 	new->timeout = expr->timeout;
 	if (expr->comment)
@@ -1328,6 +1334,24 @@ struct expr *set_elem_expr_alloc(const struct location *loc, struct expr *key)
 	return expr;
 }
 
+static void set_elem_catchall_expr_print(const struct expr *expr,
+					 struct output_ctx *octx)
+{
+	nft_print(octx, "_");
+}
+
+static const struct expr_ops set_elem_catchall_expr_ops = {
+	.type		= EXPR_SET_ELEM_CATCHALL,
+	.name		= "catch-all set element",
+	.print		= set_elem_catchall_expr_print,
+};
+
+struct expr *set_elem_catchall_expr_alloc(const struct location *loc)
+{
+	return expr_alloc(loc, EXPR_SET_ELEM_CATCHALL, &invalid_type,
+			  BYTEORDER_INVALID, 0);
+}
+
 void range_expr_value_low(mpz_t rop, const struct expr *expr)
 {
 	switch (expr->etype) {
@@ -1403,6 +1427,7 @@ static const struct expr_ops *__expr_ops_by_type(enum expr_types etype)
 	case EXPR_RT: return &rt_expr_ops;
 	case EXPR_FIB: return &fib_expr_ops;
 	case EXPR_XFRM: return &xfrm_expr_ops;
+	case EXPR_SET_ELEM_CATCHALL: return &set_elem_catchall_expr_ops;
 	}
 
 	BUG("Unknown expression type %d\n", etype);
diff --git a/src/mergesort.c b/src/mergesort.c
index 41f35856cdf4..ef967cec8759 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -44,6 +44,10 @@ static void expr_msort_value(const struct expr *expr, mpz_t value)
 	case EXPR_CONCAT:
 		concat_expr_msort_value(expr, value);
 		break;
+	case EXPR_SET_ELEM_CATCHALL:
+		/* Ensures listing shows it last */
+		mpz_bitmask(value, expr->len);
+		break;
 	default:
 		BUG("Unknown expression %s\n", expr_name(expr));
 	}
diff --git a/src/netlink.c b/src/netlink.c
index e4926a80d79a..8cdd6d818221 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -104,6 +104,7 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 	struct nftnl_set_elem *nlse;
 	struct nft_data_linearize nld;
 	struct nftnl_udata_buf *udbuf = NULL;
+	uint32_t flags = 0;
 	int num_exprs = 0;
 	struct stmt *stmt;
 	struct expr *key;
@@ -125,16 +126,21 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 
 	key = elem->key;
 
-	netlink_gen_data(key, &nld);
-	nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, &nld.value, nld.len);
-
-	if (set->set_flags & NFT_SET_INTERVAL && key->field_count > 1) {
-		key->flags |= EXPR_F_INTERVAL_END;
+	switch (key->etype) {
+	case EXPR_SET_ELEM_CATCHALL:
+		break;
+	default:
 		netlink_gen_data(key, &nld);
-		key->flags &= ~EXPR_F_INTERVAL_END;
-
-		nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY_END, &nld.value,
-				   nld.len);
+		nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, &nld.value, nld.len);
+		if (set->set_flags & NFT_SET_INTERVAL && key->field_count > 1) {
+			key->flags |= EXPR_F_INTERVAL_END;
+			netlink_gen_data(key, &nld);
+			key->flags &= ~EXPR_F_INTERVAL_END;
+
+			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY_END,
+					   &nld.value, nld.len);
+		}
+		break;
 	}
 
 	if (elem->timeout)
@@ -209,8 +215,12 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 	}
 
 	if (expr->flags & EXPR_F_INTERVAL_END)
-		nftnl_set_elem_set_u32(nlse, NFTNL_SET_ELEM_FLAGS,
-				       NFT_SET_ELEM_INTERVAL_END);
+		flags |= NFT_SET_ELEM_INTERVAL_END;
+	if (key->etype == EXPR_SET_ELEM_CATCHALL)
+		flags |= NFT_SET_ELEM_CATCHALL;
+
+	if (flags)
+		nftnl_set_elem_set_u32(nlse, NFTNL_SET_ELEM_FLAGS, flags);
 
 	return nlse;
 }
@@ -1133,25 +1143,34 @@ int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 
 	init_list_head(&setelem_parse_ctx.stmt_list);
 
-	nld.value =
-		nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_KEY, &nld.len);
+	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_KEY))
+		nld.value = nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_KEY, &nld.len);
 	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_FLAGS))
 		flags = nftnl_set_elem_get_u32(nlse, NFTNL_SET_ELEM_FLAGS);
 
 key_end:
-	key = netlink_alloc_value(&netlink_location, &nld);
-	datatype_set(key, set->key->dtype);
-	key->byteorder	= set->key->byteorder;
-	if (set->key->dtype->subtypes)
-		key = netlink_parse_concat_elem(set->key->dtype, key);
-
-	if (!(set->flags & NFT_SET_INTERVAL) &&
-	    key->byteorder == BYTEORDER_HOST_ENDIAN)
-		mpz_switch_byteorder(key->value, key->len / BITS_PER_BYTE);
-
-	if (key->dtype->basetype != NULL &&
-	    key->dtype->basetype->type == TYPE_BITMASK)
-		key = bitmask_expr_to_binops(key);
+	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_KEY)) {
+		key = netlink_alloc_value(&netlink_location, &nld);
+		datatype_set(key, set->key->dtype);
+		key->byteorder	= set->key->byteorder;
+		if (set->key->dtype->subtypes)
+			key = netlink_parse_concat_elem(set->key->dtype, key);
+
+		if (!(set->flags & NFT_SET_INTERVAL) &&
+		    key->byteorder == BYTEORDER_HOST_ENDIAN)
+			mpz_switch_byteorder(key->value, key->len / BITS_PER_BYTE);
+
+		if (key->dtype->basetype != NULL &&
+		    key->dtype->basetype->type == TYPE_BITMASK)
+			key = bitmask_expr_to_binops(key);
+	} else if (flags & NFT_SET_ELEM_CATCHALL) {
+		key = set_elem_catchall_expr_alloc(&netlink_location);
+		datatype_set(key, set->key->dtype);
+		key->byteorder = set->key->byteorder;
+		key->len = set->key->len;
+	} else {
+		BUG("Unexpected set element with no key\n");
+	}
 
 	expr = set_elem_expr_alloc(&netlink_location, key);
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index e4a5ade296d7..031647b71289 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -209,6 +209,7 @@ int nft_lex(void *, void *, void *);
 %token SLASH			"/"
 %token ASTERISK			"*"
 %token DASH			"-"
+%token UNDERSCORE		"_"
 %token AT			"@"
 %token VMAP			"vmap"
 
@@ -4088,6 +4089,7 @@ set_elem_expr		:	set_elem_expr_alloc
 			;
 
 set_elem_key_expr	:	set_lhs_expr		{ $$ = $1; }
+			|	UNDERSCORE		{ $$ = set_elem_catchall_expr_alloc(&@1); }
 			;
 
 set_elem_expr_alloc	:	set_elem_key_expr	set_elem_stmt_list
diff --git a/src/scanner.l b/src/scanner.l
index 72469b4e07b0..f5bc814197c8 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -254,6 +254,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "not"			{ return NOT; }
 "/"			{ return SLASH; }
 "-"			{ return DASH; }
+"_"			{ return UNDERSCORE; }
 "*"			{ return ASTERISK; }
 "@"			{ return AT; }
 "$"			{ return '$'; }
diff --git a/src/segtree.c b/src/segtree.c
index 353a0053ebc0..447837d71d68 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -619,9 +619,20 @@ int set_to_intervals(struct list_head *errs, struct set *set,
 		     bool merge, struct output_ctx *octx)
 {
 	struct elementary_interval *ei, *next;
+	struct expr *catchall = NULL, *i, *in;
 	struct seg_tree tree;
 	LIST_HEAD(list);
 
+	list_for_each_entry_safe(i, in, &init->expressions, list) {
+		if (i->etype == EXPR_SET_ELEM &&
+		    i->key->etype == EXPR_SET_ELEM_CATCHALL) {
+			init->size--;
+			catchall = i;
+			list_del(&i->list);
+			break;
+		}
+	}
+
 	seg_tree_init(&tree, set, init, debug_mask);
 	if (set_to_segtree(errs, set, init, &tree, add, merge) < 0)
 		return -1;
@@ -643,6 +654,11 @@ int set_to_intervals(struct list_head *errs, struct set *set,
 		pr_gmp_debug("\n");
 	}
 
+	if (catchall) {
+		list_add_tail(&catchall->list, &init->expressions);
+		init->size++;
+	}
+
 	return 0;
 }
 
@@ -682,6 +698,9 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 			i->flags |= EXPR_F_INTERVAL_END;
 			compound_expr_add(new_init, expr_clone(i));
 			break;
+		case EXPR_SET_ELEM_CATCHALL:
+			compound_expr_add(new_init, expr_clone(i));
+			break;
 		default:
 			range_expr_value_low(low, i);
 			set_elem_add(set, new_init, low, 0, i->byteorder);
@@ -941,8 +960,8 @@ next:
 
 void interval_map_decompose(struct expr *set)
 {
+	struct expr *i, *next, *low = NULL, *end, *catchall = NULL;
 	struct expr **elements, **ranges;
-	struct expr *i, *next, *low = NULL, *end;
 	unsigned int n, m, size;
 	mpz_t range, p;
 	bool interval;
@@ -959,6 +978,13 @@ void interval_map_decompose(struct expr *set)
 	/* Sort elements */
 	n = 0;
 	list_for_each_entry_safe(i, next, &set->expressions, list) {
+		if (i->etype == EXPR_SET_ELEM &&
+		    i->key->etype == EXPR_SET_ELEM_CATCHALL) {
+			list_del(&i->list);
+			catchall = i;
+			continue;
+		}
+
 		compound_expr_remove(set, i);
 		elements[n++] = i;
 	}
@@ -1094,6 +1120,9 @@ void interval_map_decompose(struct expr *set)
 
 	compound_expr_add(set, i);
 out:
+	if (catchall)
+		compound_expr_add(set, catchall);
+
 	mpz_clear(range);
 	mpz_clear(p);
 
-- 
2.30.2

