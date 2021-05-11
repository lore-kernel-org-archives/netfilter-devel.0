Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F9FC433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 May 2021 15:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCBFD61430
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 May 2021 15:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhEKP3E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 May 2021 11:29:04 -0400
Received: from mail.netfilter.org ([217.70.188.207]:56884 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbhEKP3E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 May 2021 11:29:04 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C9C5164167
        for <netfilter-devel@vger.kernel.org>; Tue, 11 May 2021 17:27:07 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables,v3 2/2] src: add set element catch-all support
Date:   Tue, 11 May 2021 17:27:52 +0200
Message-Id: <20210511152752.123885-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a catchall expression (EXPR_SET_ELEM_CATCHALL).

Use the asterisk (*) to represent the catch-all set element, e.g.

 table x {
     set y {
	type ipv4_addr
	counter
	elements = { 1.2.3.4 counter packets 0 bytes 0, * counter packets 0 bytes 0 }
     }
 }

Special handling for segtree: zap the catch-all element from the set
element list and re-add it after processing.

Remove wildcard_expr deadcode in src/parser_bison.y

This patch also adds several tests for the tests/py and tests/shell
infrastructures.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: fix catch-all element with mappings
    extend testcases to cover mappings
    remove set_element expression updates (per Phil Sutter)
    remove evaluation step, set expression flags from constructor.

 include/expression.h                          |  3 +
 include/linux/netfilter/nf_tables.h           |  2 +
 src/evaluate.c                                |  2 +
 src/expression.c                              | 24 +++++++
 src/mergesort.c                               |  4 ++
 src/netlink.c                                 | 71 ++++++++++++-------
 src/parser_bison.y                            | 19 +----
 src/segtree.c                                 | 41 ++++++++++-
 tests/py/ip/sets.t                            |  8 +++
 tests/py/ip/sets.t.payload.inet               | 29 ++++++++
 tests/py/ip/sets.t.payload.ip                 | 23 ++++++
 tests/py/ip/sets.t.payload.netdev             | 29 ++++++++
 tests/shell/testcases/sets/0063set_catchall_0 | 21 ++++++
 tests/shell/testcases/sets/0064map_catchall_0 | 19 +++++
 .../sets/dumps/0063set_catchall_0.nft         | 14 ++++
 .../sets/dumps/0064map_catchall_0.nft         | 12 ++++
 16 files changed, 278 insertions(+), 43 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0063set_catchall_0
 create mode 100755 tests/shell/testcases/sets/0064map_catchall_0
 create mode 100644 tests/shell/testcases/sets/dumps/0063set_catchall_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0064map_catchall_0.nft

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
index b5dcdd3542f1..95189180fe89 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2201,6 +2201,8 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		return expr_evaluate_hash(ctx, expr);
 	case EXPR_XFRM:
 		return expr_evaluate_xfrm(ctx, expr);
+	case EXPR_SET_ELEM_CATCHALL:
+		return 0;
 	default:
 		BUG("unknown expression type %s\n", expr_name(*expr));
 	}
diff --git a/src/expression.c b/src/expression.c
index 9fdf23d98446..b3400751f312 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1328,6 +1328,29 @@ struct expr *set_elem_expr_alloc(const struct location *loc, struct expr *key)
 	return expr;
 }
 
+static void set_elem_catchall_expr_print(const struct expr *expr,
+					 struct output_ctx *octx)
+{
+	nft_print(octx, "*");
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
+	struct expr *expr;
+
+	expr = expr_alloc(loc, EXPR_SET_ELEM_CATCHALL, &invalid_type,
+			  BYTEORDER_INVALID, 0);
+	expr->flags = EXPR_F_CONSTANT | EXPR_F_SINGLETON;
+
+	return expr;
+}
+
 void range_expr_value_low(mpz_t rop, const struct expr *expr)
 {
 	switch (expr->etype) {
@@ -1403,6 +1426,7 @@ static const struct expr_ops *__expr_ops_by_type(enum expr_types etype)
 	case EXPR_RT: return &rt_expr_ops;
 	case EXPR_FIB: return &fib_expr_ops;
 	case EXPR_XFRM: return &xfrm_expr_ops;
+	case EXPR_SET_ELEM_CATCHALL: return &set_elem_catchall_expr_ops;
 	}
 
 	BUG("Unknown expression type %d\n", etype);
diff --git a/src/mergesort.c b/src/mergesort.c
index 41f35856cdf4..152b0556b164 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -44,6 +44,10 @@ static void expr_msort_value(const struct expr *expr, mpz_t value)
 	case EXPR_CONCAT:
 		concat_expr_msort_value(expr, value);
 		break;
+	case EXPR_SET_ELEM_CATCHALL:
+		/* max value to ensure listing shows it in the last position */
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
index e4a5ade296d7..000eb40a20a4 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -697,8 +697,8 @@ int nft_lex(void *, void *, void *);
 
 %type <expr>			multiton_stmt_expr
 %destructor { expr_free($$); }	multiton_stmt_expr
-%type <expr>			prefix_stmt_expr range_stmt_expr wildcard_expr
-%destructor { expr_free($$); }	prefix_stmt_expr range_stmt_expr wildcard_expr
+%type <expr>			prefix_stmt_expr range_stmt_expr
+%destructor { expr_free($$); }	prefix_stmt_expr range_stmt_expr
 
 %type <expr>			primary_stmt_expr basic_stmt_expr
 %destructor { expr_free($$); }	primary_stmt_expr basic_stmt_expr
@@ -3470,20 +3470,8 @@ range_stmt_expr		:	basic_stmt_expr	DASH	basic_stmt_expr
 			}
 			;
 
-wildcard_expr		:	ASTERISK
-			{
-				struct expr *expr;
-
-				expr = constant_expr_alloc(&@$, &integer_type,
-							   BYTEORDER_HOST_ENDIAN,
-							   0, NULL);
-				$$ = prefix_expr_alloc(&@$, expr, 0);
-			}
-			;
-
 multiton_stmt_expr	:	prefix_stmt_expr
 			|	range_stmt_expr
-			|	wildcard_expr
 			;
 
 stmt_expr		:	map_stmt_expr
@@ -4088,6 +4076,7 @@ set_elem_expr		:	set_elem_expr_alloc
 			;
 
 set_elem_key_expr	:	set_lhs_expr		{ $$ = $1; }
+			|	ASTERISK		{ $$ = set_elem_catchall_expr_alloc(&@1); }
 			;
 
 set_elem_expr_alloc	:	set_elem_key_expr	set_elem_stmt_list
@@ -4227,7 +4216,6 @@ set_elem_expr_option	:	TIMEOUT			time_spec
 			;
 
 set_lhs_expr		:	concat_rhs_expr
-			|	wildcard_expr
 			;
 
 set_rhs_expr		:	concat_rhs_expr
@@ -4500,7 +4488,6 @@ list_rhs_expr		:	basic_rhs_expr		COMMA		basic_rhs_expr
 			;
 
 rhs_expr		:	concat_rhs_expr		{ $$ = $1; }
-			|	wildcard_expr		{ $$ = $1; }
 			|	set_expr		{ $$ = $1; }
 			|	set_ref_symbol_expr	{ $$ = $1; }
 			;
diff --git a/src/segtree.c b/src/segtree.c
index 353a0053ebc0..a4e047e79fc4 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -618,10 +618,27 @@ int set_to_intervals(struct list_head *errs, struct set *set,
 		     struct expr *init, bool add, unsigned int debug_mask,
 		     bool merge, struct output_ctx *octx)
 {
+	struct expr *catchall = NULL, *i, *in, *key;
 	struct elementary_interval *ei, *next;
 	struct seg_tree tree;
 	LIST_HEAD(list);
 
+	list_for_each_entry_safe(i, in, &init->expressions, list) {
+		if (i->etype == EXPR_MAPPING)
+			key = i->left->key;
+		else if (i->etype == EXPR_SET_ELEM)
+			key = i->key;
+		else
+			continue;
+
+		if (key->etype == EXPR_SET_ELEM_CATCHALL) {
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
@@ -643,6 +660,11 @@ int set_to_intervals(struct list_head *errs, struct set *set,
 		pr_gmp_debug("\n");
 	}
 
+	if (catchall) {
+		list_add_tail(&catchall->list, &init->expressions);
+		init->size++;
+	}
+
 	return 0;
 }
 
@@ -682,6 +704,9 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 			i->flags |= EXPR_F_INTERVAL_END;
 			compound_expr_add(new_init, expr_clone(i));
 			break;
+		case EXPR_SET_ELEM_CATCHALL:
+			compound_expr_add(new_init, expr_clone(i));
+			break;
 		default:
 			range_expr_value_low(low, i);
 			set_elem_add(set, new_init, low, 0, i->byteorder);
@@ -941,8 +966,8 @@ next:
 
 void interval_map_decompose(struct expr *set)
 {
+	struct expr *i, *next, *low = NULL, *end, *catchall = NULL, *key;
 	struct expr **elements, **ranges;
-	struct expr *i, *next, *low = NULL, *end;
 	unsigned int n, m, size;
 	mpz_t range, p;
 	bool interval;
@@ -959,6 +984,17 @@ void interval_map_decompose(struct expr *set)
 	/* Sort elements */
 	n = 0;
 	list_for_each_entry_safe(i, next, &set->expressions, list) {
+		key = NULL;
+		if (i->etype == EXPR_SET_ELEM)
+			key = i->key;
+		else if (i->etype == EXPR_MAPPING)
+			key = i->left->key;
+
+		if (key && key->etype == EXPR_SET_ELEM_CATCHALL) {
+			list_del(&i->list);
+			catchall = i;
+			continue;
+		}
 		compound_expr_remove(set, i);
 		elements[n++] = i;
 	}
@@ -1094,6 +1130,9 @@ void interval_map_decompose(struct expr *set)
 
 	compound_expr_add(set, i);
 out:
+	if (catchall)
+		compound_expr_add(set, catchall);
+
 	mpz_clear(range);
 	mpz_clear(p);
 
diff --git a/tests/py/ip/sets.t b/tests/py/ip/sets.t
index 7b7e07226492..7dc884fc69f1 100644
--- a/tests/py/ip/sets.t
+++ b/tests/py/ip/sets.t
@@ -54,3 +54,11 @@ add @set5 { ip saddr . ip daddr };ok
 # test nested anonymous sets
 ip saddr { { 1.1.1.0, 3.3.3.0 }, 2.2.2.0 };ok;ip saddr { 1.1.1.0, 2.2.2.0, 3.3.3.0 }
 ip saddr { { 1.1.1.0/24, 3.3.3.0/24 }, 2.2.2.0/24 };ok;ip saddr { 1.1.1.0/24, 2.2.2.0/24, 3.3.3.0/24 }
+
+!set6 type ipv4_addr;ok
+?set6 192.168.3.5, *;ok
+ip saddr @set6 drop;ok
+
+ip saddr vmap { 1.1.1.1 : drop, * : accept };ok
+meta mark set ip saddr map { 1.1.1.1 : 0x00000001, * : 0x00000002 };ok
+
diff --git a/tests/py/ip/sets.t.payload.inet b/tests/py/ip/sets.t.payload.inet
index fa956c0cdd44..d7d70b0c2537 100644
--- a/tests/py/ip/sets.t.payload.inet
+++ b/tests/py/ip/sets.t.payload.inet
@@ -66,3 +66,32 @@ inet test-inet input
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __set%d ]
+
+# ip saddr @set6 drop
+inet
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set set6 ]
+  [ immediate reg 0 drop ]
+
+# ip saddr vmap { 1.1.1.1 : drop, * : accept }
+__map%d test-inet b
+__map%d test-inet 0
+        element 01010101  : drop 0 [end]        element  : accept 2 [end]
+inet
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+
+# meta mark set ip saddr map { 1.1.1.1 : 0x00000001, * : 0x00000002 }
+__map%d test-inet b
+__map%d test-inet 0
+        element 01010101  : 00000001 0 [end]    element  : 00000002 2 [end]
+inet
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ meta set mark with reg 1 ]
diff --git a/tests/py/ip/sets.t.payload.ip b/tests/py/ip/sets.t.payload.ip
index ca3b5adea3ab..97a9669354b6 100644
--- a/tests/py/ip/sets.t.payload.ip
+++ b/tests/py/ip/sets.t.payload.ip
@@ -50,3 +50,26 @@ __set%d test-ip4 0
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __set%d ]
+
+# ip saddr @set6 drop
+ip
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set set6 ]
+  [ immediate reg 0 drop ]
+
+# ip saddr vmap { 1.1.1.1 : drop, * : accept }
+__map%d test-ip4 b
+__map%d test-ip4 0
+        element 01010101  : drop 0 [end]        element  : accept 2 [end]
+ip
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+
+# meta mark set ip saddr map { 1.1.1.1 : 0x00000001, * : 0x00000002 }
+__map%d test-ip4 b
+__map%d test-ip4 0
+        element 01010101  : 00000001 0 [end]    element  : 00000002 2 [end]
+ip
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ meta set mark with reg 1 ]
diff --git a/tests/py/ip/sets.t.payload.netdev b/tests/py/ip/sets.t.payload.netdev
index 9772d756747d..d4317d290fc4 100644
--- a/tests/py/ip/sets.t.payload.netdev
+++ b/tests/py/ip/sets.t.payload.netdev
@@ -66,3 +66,32 @@ netdev test-netdev ingress
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __set%d ]
+
+# ip saddr @set6 drop
+netdev
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set set6 ]
+  [ immediate reg 0 drop ]
+
+# ip saddr vmap { 1.1.1.1 : drop, * : accept }
+__map%d test-netdev b
+__map%d test-netdev 0
+        element 01010101  : drop 0 [end]        element  : accept 2 [end]
+netdev
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+
+# meta mark set ip saddr map { 1.1.1.1 : 0x00000001, * : 0x00000002 }
+__map%d test-netdev b
+__map%d test-netdev 0
+        element 01010101  : 00000001 0 [end]    element  : 00000002 2 [end]
+netdev
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ meta set mark with reg 1 ]
diff --git a/tests/shell/testcases/sets/0063set_catchall_0 b/tests/shell/testcases/sets/0063set_catchall_0
new file mode 100755
index 000000000000..faca56a18dc5
--- /dev/null
+++ b/tests/shell/testcases/sets/0063set_catchall_0
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip x {
+	set y {
+		type ipv4_addr
+		counter
+		elements = { 1.1.1.1, * }
+	}
+	set z {
+		type ipv4_addr
+		flags interval
+		counter
+		elements = { 1.1.1.0/24 , * }
+	}
+}"
+
+$NFT -f - <<< $RULESET
+$NFT delete element x y { \* }
+$NFT add element x y { \* }
diff --git a/tests/shell/testcases/sets/0064map_catchall_0 b/tests/shell/testcases/sets/0064map_catchall_0
new file mode 100755
index 000000000000..6f2a7c6f0249
--- /dev/null
+++ b/tests/shell/testcases/sets/0064map_catchall_0
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip x {
+	map y {
+		type ipv4_addr : ipv4_addr
+		elements = { 10.141.0.1 : 192.168.0.2, * : 192.168.0.3 }
+	}
+	map z {
+		type ipv4_addr : ipv4_addr
+		flags interval
+		elements = { 10.141.0.0/24 : 192.168.0.2, * : 192.168.0.3 }
+	}
+}"
+
+$NFT -f - <<< $RULESET
+$NFT delete element x y { \* : 192.168.0.3 }
+$NFT add element x y { \* : 192.168.0.4 }
diff --git a/tests/shell/testcases/sets/dumps/0063set_catchall_0.nft b/tests/shell/testcases/sets/dumps/0063set_catchall_0.nft
new file mode 100644
index 000000000000..f0d42cc24e60
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0063set_catchall_0.nft
@@ -0,0 +1,14 @@
+table ip x {
+	set y {
+		type ipv4_addr
+		counter
+		elements = { 1.1.1.1 counter packets 0 bytes 0, * counter packets 0 bytes 0 }
+	}
+
+	set z {
+		type ipv4_addr
+		flags interval
+		counter
+		elements = { 1.1.1.0/24 counter packets 0 bytes 0, * counter packets 0 bytes 0 }
+	}
+}
diff --git a/tests/shell/testcases/sets/dumps/0064map_catchall_0.nft b/tests/shell/testcases/sets/dumps/0064map_catchall_0.nft
new file mode 100644
index 000000000000..286683a05df9
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0064map_catchall_0.nft
@@ -0,0 +1,12 @@
+table ip x {
+	map y {
+		type ipv4_addr : ipv4_addr
+		elements = { 10.141.0.1 : 192.168.0.2, * : 192.168.0.4 }
+	}
+
+	map z {
+		type ipv4_addr : ipv4_addr
+		flags interval
+		elements = { 10.141.0.0/24 : 192.168.0.2, * : 192.168.0.3 }
+	}
+}
-- 
2.30.2

