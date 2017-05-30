From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: RFC: Ideas about possible solutions for nfbz#949
Date: Tue, 30 May 2017 14:08:36 +0200
Message-ID: <20170530120836.GA3010@salvia>
References: <20170510153429.GZ20805@orbyte.nwl.cc>
 <20170529175218.GA19201@salvia>
 <20170530110424.xilg6ph3aqstopyl@base.sg13b.nwl.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59512 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750905AbdE3MIr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 May 2017 08:08:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 45B291DF5A3
        for <netfilter-devel@vger.kernel.org>; Tue, 30 May 2017 14:08:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FF791B3211
        for <netfilter-devel@vger.kernel.org>; Tue, 30 May 2017 14:08:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8FC511BA12E
        for <netfilter-devel@vger.kernel.org>; Tue, 30 May 2017 14:08:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170530110424.xilg6ph3aqstopyl@base.sg13b.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 30, 2017 at 01:04:24PM +0200, Phil Sutter wrote:
[...]
> On Mon, May 29, 2017 at 07:52:18PM +0200, Pablo Neira Ayuso wrote:
[...]
> > > My idea was to build something like the protocol dependencies we have
> > > for e.g. TCP header fields but with ICMP, a given header field might be
> > > present in multiple message types (e.g. icmp6_id is present in echo
> > > request as well as reply).
> > 
> > You mean adding more instructions when generating bytecode? This has
> > runtime overhead, just to provide context for just listing the
> > ruleset. I would prefer we skip this.
> 
> Yes, that is questionable. But it is a matter of definition in my PoV. A
> user saying 'icmp6 id 2' might not be aware that all possible icmp6
> packets might match, not only those making use of the ID field. Right
> now it feels like we want a low-level 'icmp6 offset X mask y' and a
> high-level 'icmp6 echo direction any id 2' but that's probably out of
> scope here.

If the user just specifies 'icmp6 id 2', we should reject this and ask
for a specific icmp type.

> > > I already considered inserting a match for icmp6 type against an
> > > anonymous set (like 'icmp6 type { echo-request, echo-reply }'), but
> > > having this as an implicit dependency and resolving with previous
> > > matches, etc. becomes pretty complex.
> > > 
> > > Do you think I should try following a different approach (via userdata
> > > e.g.)?
> > 
> > I think you should try adding some context structure to the
> > expr_print(), this context can be used to interpret this offset based
> > on the icmp type.
> > 
> > Someone (Elise?) send me a patch to add this context structure, just
> > to prepare introduction, but she got stuck in the context update
> > logic at some point. I can find such patch so you only have to figure
> > out how to annotate the information we need in this context structure.
> 
> Yes, that would be great. Having something to get me started is always
> very helpful. :)

I'm attaching what Elise sent me for review.

This is just an initial patch to add some context structure for
expr_print(), so it's pretty much the simple initial step.

Not telling here you have to use 'struct proto_ctx' specifically, I
guess we need some print_ctx structure for this to annotate that we
have seen "icmp type" already, so offset interpretation is based on

I would need to spend more time here to provide a more specific design
for this, so if you can come back with initial ideas, that would be
good.

--8t9RHnE3ZwKMSgU+
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-First-part-of-icmp-print-patch.patch"

>From b4531696ec0c2c9407c9a7655f9cb133280294ff Mon Sep 17 00:00:00 2001
From: Elise Lennion <elise.lennion@gmail.com>
Date: Tue, 17 Jan 2017 21:53:15 -0200
Subject: [PATCH] First part of icmp print patch.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 include/expression.h |  5 ++--
 src/ct.c             |  5 ++--
 src/evaluate.c       |  2 +-
 src/expression.c     | 70 +++++++++++++++++++++++++++++++---------------------
 src/exthdr.c         |  3 ++-
 src/fib.c            |  3 ++-
 src/hash.c           |  5 ++--
 src/meta.c           |  5 ++--
 src/netlink.c        |  6 ++---
 src/numgen.c         |  3 ++-
 src/payload.c        |  7 +++---
 src/rt.c             |  3 ++-
 src/rule.c           |  2 +-
 src/segtree.c        |  2 +-
 src/statement.c      | 40 +++++++++++++++---------------
 15 files changed, 92 insertions(+), 69 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index ec90265..8010f34 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -157,7 +157,8 @@ struct expr_ops {
 	void			(*set_type)(const struct expr *expr,
 					    const struct datatype *dtype,
 					    enum byteorder byteorder);
-	void			(*print)(const struct expr *expr);
+	void			(*print)(const struct expr *expr,
+					 const struct proto_ctx *ctx);
 	bool			(*cmp)(const struct expr *e1,
 				       const struct expr *e2);
 	void			(*pctx_update)(struct proto_ctx *ctx,
@@ -324,7 +325,7 @@ extern struct expr *expr_alloc(const struct location *loc,
 extern struct expr *expr_clone(const struct expr *expr);
 extern struct expr *expr_get(struct expr *expr);
 extern void expr_free(struct expr *expr);
-extern void expr_print(const struct expr *expr);
+extern void expr_print(const struct expr *expr, const struct proto_ctx *ctx);
 extern bool expr_cmp(const struct expr *e1, const struct expr *e2);
 extern void expr_describe(const struct expr *expr);
 
diff --git a/src/ct.c b/src/ct.c
index 31c7a4b..20bbeea 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -236,7 +236,8 @@ static const struct ct_template ct_templates[] = {
 					      BYTEORDER_HOST_ENDIAN, 64),
 };
 
-static void ct_expr_print(const struct expr *expr)
+static void ct_expr_print(const struct expr *expr,
+			  const struct proto_ctx *ctx)
 {
 	const struct symbolic_constant *s;
 
@@ -398,7 +399,7 @@ void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr)
 static void ct_stmt_print(const struct stmt *stmt)
 {
 	printf("ct %s set ", ct_templates[stmt->ct.key].token);
-	expr_print(stmt->ct.expr);
+	expr_print(stmt->ct.expr, NULL);
 }
 
 static const struct stmt_ops ct_stmt_ops = {
diff --git a/src/evaluate.c b/src/evaluate.c
index bcbced1..d0f2421 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1622,7 +1622,7 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		struct error_record *erec;
 		erec = erec_create(EREC_INFORMATIONAL, &(*expr)->location,
 				   "Evaluate %s", (*expr)->ops->name);
-		erec_print(stdout, erec); expr_print(*expr); printf("\n\n");
+		erec_print(stdout, erec); expr_print(*expr, NULL); printf("\n\n");
 	}
 #endif
 
diff --git a/src/expression.c b/src/expression.c
index 1567870..17f7911 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -70,9 +70,9 @@ void expr_free(struct expr *expr)
 	xfree(expr);
 }
 
-void expr_print(const struct expr *expr)
+void expr_print(const struct expr *expr, const struct proto_ctx *ctx)
 {
-	expr->ops->print(expr);
+	expr->ops->print(expr, ctx);
 }
 
 bool expr_cmp(const struct expr *e1, const struct expr *e2)
@@ -160,7 +160,8 @@ int __fmtstring(4, 5) expr_binary_error(struct list_head *msgs,
 	return -1;
 }
 
-static void verdict_expr_print(const struct expr *expr)
+static void verdict_expr_print(const struct expr *expr,
+			       const struct proto_ctx *ctx)
 {
 	datatype_print(expr);
 }
@@ -213,7 +214,8 @@ struct expr *verdict_expr_alloc(const struct location *loc,
 	return expr;
 }
 
-static void symbol_expr_print(const struct expr *expr)
+static void symbol_expr_print(const struct expr *expr,
+			      const struct proto_ctx *ctx)
 {
 	printf("%s%s", expr->scope != NULL ? "$" : "", expr->identifier);
 }
@@ -252,7 +254,8 @@ struct expr *symbol_expr_alloc(const struct location *loc,
 	return expr;
 }
 
-static void constant_expr_print(const struct expr *expr)
+static void constant_expr_print(const struct expr *expr,
+				const struct proto_ctx *ctx)
 {
 	datatype_print(expr);
 }
@@ -394,9 +397,10 @@ struct expr *bitmask_expr_to_binops(struct expr *expr)
 	return binop;
 }
 
-static void prefix_expr_print(const struct expr *expr)
+static void prefix_expr_print(const struct expr *expr,
+			      const struct proto_ctx *ctx)
 {
-	expr_print(expr->prefix);
+	expr_print(expr->prefix, NULL);
 	printf("/%u", expr->prefix_len);
 }
 
@@ -458,11 +462,12 @@ const char *expr_op_symbols[] = {
 	[OP_LOOKUP]	= NULL,
 };
 
-static void unary_expr_print(const struct expr *expr)
+static void unary_expr_print(const struct expr *expr,
+			     const struct proto_ctx *ctx)
 {
 	if (expr_op_symbols[expr->op] != NULL)
 		printf("%s(", expr_op_symbols[expr->op]);
-	expr_print(expr->arg);
+	expr_print(expr->arg, NULL);
 	printf(")");
 }
 
@@ -515,7 +520,7 @@ static void binop_arg_print(const struct expr *op, const struct expr *arg)
 
 	if (prec)
 		printf("(");
-	expr_print(arg);
+	expr_print(arg, NULL);
 	if (prec)
 		printf(")");
 }
@@ -529,7 +534,8 @@ static bool must_print_eq_op(const struct expr *expr)
 	return expr->left->ops->type == EXPR_BINOP;
 }
 
-static void binop_expr_print(const struct expr *expr)
+static void binop_expr_print(const struct expr *expr,
+			     const struct proto_ctx *ctx)
 {
 	binop_arg_print(expr, expr->left);
 
@@ -595,11 +601,12 @@ struct expr *relational_expr_alloc(const struct location *loc, enum ops op,
 	return expr;
 }
 
-static void range_expr_print(const struct expr *expr)
+static void range_expr_print(const struct expr *expr,
+			     const struct proto_ctx *ctx)
 {
-	expr_print(expr->left);
+	expr_print(expr->left, NULL);
 	printf("-");
-	expr_print(expr->right);
+	expr_print(expr->right, NULL);
 }
 
 static void range_expr_clone(struct expr *new, const struct expr *expr)
@@ -677,7 +684,7 @@ static void compound_expr_print(const struct expr *expr, const char *delim)
 
 	list_for_each_entry(i, &expr->expressions, list) {
 		printf("%s", d);
-		expr_print(i);
+		expr_print(i, NULL);
 		d = delim;
 	}
 }
@@ -700,7 +707,8 @@ static void concat_expr_destroy(struct expr *expr)
 	compound_expr_destroy(expr);
 }
 
-static void concat_expr_print(const struct expr *expr)
+static void concat_expr_print(const struct expr *expr,
+			      const struct proto_ctx *ctx)
 {
 	compound_expr_print(expr, " . ");
 }
@@ -718,7 +726,8 @@ struct expr *concat_expr_alloc(const struct location *loc)
 	return compound_expr_alloc(loc, &concat_expr_ops);
 }
 
-static void list_expr_print(const struct expr *expr)
+static void list_expr_print(const struct expr *expr,
+			    const struct proto_ctx *ctx)
 {
 	compound_expr_print(expr, ",");
 }
@@ -736,7 +745,8 @@ struct expr *list_expr_alloc(const struct location *loc)
 	return compound_expr_alloc(loc, &list_expr_ops);
 }
 
-static void set_expr_print(const struct expr *expr)
+static void set_expr_print(const struct expr *expr,
+			   const struct proto_ctx *ctx)
 {
 	printf("{ ");
 	compound_expr_print(expr, ", ");
@@ -767,11 +777,12 @@ struct expr *set_expr_alloc(const struct location *loc)
 	return compound_expr_alloc(loc, &set_expr_ops);
 }
 
-static void mapping_expr_print(const struct expr *expr)
+static void mapping_expr_print(const struct expr *expr,
+			       const struct proto_ctx *ctx)
 {
-	expr_print(expr->left);
+	expr_print(expr->left, NULL);
 	printf(" : ");
-	expr_print(expr->right);
+	expr_print(expr->right, NULL);
 }
 
 static void mapping_expr_set_type(const struct expr *expr,
@@ -814,15 +825,16 @@ struct expr *mapping_expr_alloc(const struct location *loc,
 	return expr;
 }
 
-static void map_expr_print(const struct expr *expr)
+static void map_expr_print(const struct expr *expr,
+			   const struct proto_ctx *ctx)
 {
-	expr_print(expr->map);
+	expr_print(expr->map, NULL);
 	if (expr->mappings->ops->type == EXPR_SET_REF &&
 	    expr->mappings->set->datatype->type == TYPE_VERDICT)
 		printf(" vmap ");
 	else
 		printf(" map ");
-	expr_print(expr->mappings);
+	expr_print(expr->mappings, NULL);
 }
 
 static void map_expr_clone(struct expr *new, const struct expr *expr)
@@ -856,13 +868,14 @@ struct expr *map_expr_alloc(const struct location *loc, struct expr *arg,
 	return expr;
 }
 
-static void set_ref_expr_print(const struct expr *expr)
+static void set_ref_expr_print(const struct expr *expr,
+			       const struct proto_ctx *ctx)
 {
 	if (expr->set->flags & NFT_SET_ANONYMOUS) {
 		if (expr->set->flags & NFT_SET_EVAL)
 			printf("table %s", expr->set->handle.set);
 		else
-			expr_print(expr->set->init);
+			expr_print(expr->set->init, NULL);
 	} else {
 		printf("@%s", expr->set->handle.set);
 	}
@@ -896,9 +909,10 @@ struct expr *set_ref_expr_alloc(const struct location *loc, struct set *set)
 	return expr;
 }
 
-static void set_elem_expr_print(const struct expr *expr)
+static void set_elem_expr_print(const struct expr *expr,
+				const struct proto_ctx *ctx)
 {
-	expr_print(expr->key);
+	expr_print(expr->key, NULL);
 	if (expr->timeout) {
 		printf(" timeout ");
 		time_print(expr->timeout / 1000);
diff --git a/src/exthdr.c b/src/exthdr.c
index c641d4a..a5fb58b 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -22,7 +22,8 @@
 #include <headers.h>
 #include <expression.h>
 
-static void exthdr_expr_print(const struct expr *expr)
+static void exthdr_expr_print(const struct expr *expr,
+			      const struct proto_ctx *ctx)
 {
 	printf("%s %s", expr->exthdr.desc->name, expr->exthdr.tmpl->token);
 }
diff --git a/src/fib.c b/src/fib.c
index c65677c..aafeec0 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -71,7 +71,8 @@ static void __fib_expr_print_f(unsigned int *flags, unsigned int f, const char *
 		printf(" . ");
 }
 
-static void fib_expr_print(const struct expr *expr)
+static void fib_expr_print(const struct expr *expr,
+			   const struct proto_ctx *ctx)
 {
 	unsigned int flags = expr->fib.flags;
 
diff --git a/src/hash.c b/src/hash.c
index d26b2ed..61b2ae0 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -15,10 +15,11 @@
 #include <hash.h>
 #include <utils.h>
 
-static void hash_expr_print(const struct expr *expr)
+static void hash_expr_print(const struct expr *expr,
+		            const struct proto_ctx *ctx)
 {
 	printf("jhash ");
-	expr_print(expr->hash.expr);
+	expr_print(expr->hash.expr, NULL);
 	printf(" mod %u", expr->hash.mod);
 	if (expr->hash.seed)
 		printf(" seed 0x%x", expr->hash.seed);
diff --git a/src/meta.c b/src/meta.c
index cb7c136..00284cf 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -464,7 +464,8 @@ static bool meta_key_is_qualified(enum nft_meta_keys key)
 	}
 }
 
-static void meta_expr_print(const struct expr *expr)
+static void meta_expr_print(const struct expr *expr,
+		            const struct proto_ctx *ctx)
 {
 	if (meta_key_is_qualified(expr->meta.key))
 		printf("meta %s", meta_templates[expr->meta.key].token);
@@ -591,7 +592,7 @@ static void meta_stmt_print(const struct stmt *stmt)
 	else
 		printf("%s set ", meta_templates[stmt->meta.key].token);
 
-	expr_print(stmt->meta.expr);
+	expr_print(stmt->meta.expr, NULL);
 }
 
 static const struct stmt_ops meta_stmt_ops = {
diff --git a/src/netlink.c b/src/netlink.c
index 4135f25..439dd2f 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2184,7 +2184,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 			goto out;
 		}
 		printf("element %s %s %s ", family2str(family), table, setname);
-		expr_print(dummyset->init);
+		expr_print(dummyset->init, NULL);
 		printf("\n");
 
 		set_free(dummyset);
@@ -2546,7 +2546,7 @@ static void trace_print_expr(const struct nftnl_trace *nlt, unsigned int attr,
 				   len * BITS_PER_BYTE, data);
 	rel  = relational_expr_alloc(&netlink_location, OP_EQ, lhs, rhs);
 
-	expr_print(rel);
+	expr_print(rel, NULL);
 	printf(" ");
 	expr_free(rel);
 }
@@ -2563,7 +2563,7 @@ static void trace_print_verdict(const struct nftnl_trace *nlt)
 	expr = verdict_expr_alloc(&netlink_location, verdict, chain);
 
 	printf("verdict ");
-	expr_print(expr);
+	expr_print(expr, NULL);
 	expr_free(expr);
 }
 
diff --git a/src/numgen.c b/src/numgen.c
index 5c1d00a..9f17cdc 100644
--- a/src/numgen.c
+++ b/src/numgen.c
@@ -28,7 +28,8 @@ static const char *numgen_type_str(enum nft_ng_types type)
 	return numgen_type[type];
 }
 
-static void numgen_expr_print(const struct expr *expr)
+static void numgen_expr_print(const struct expr *expr,
+		              const struct proto_ctx *ctx)
 {
 	printf("numgen %s mod %u", numgen_type_str(expr->numgen.type),
 	       expr->numgen.mod);
diff --git a/src/payload.c b/src/payload.c
index af533b2..a0f0816 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -38,7 +38,8 @@ bool payload_is_known(const struct expr *expr)
 	       tmpl != &proto_unknown_template;
 }
 
-static void payload_expr_print(const struct expr *expr)
+static void payload_expr_print(const struct expr *expr,
+		               const struct proto_ctx *ctx)
 {
 	const struct proto_desc *desc;
 	const struct proto_hdr_template *tmpl;
@@ -164,9 +165,9 @@ unsigned int payload_hdr_field(const struct expr *expr)
 
 static void payload_stmt_print(const struct stmt *stmt)
 {
-	expr_print(stmt->payload.expr);
+	expr_print(stmt->payload.expr, NULL);
 	printf(" set ");
-	expr_print(stmt->payload.val);
+	expr_print(stmt->payload.val, NULL);
 }
 
 static const struct stmt_ops payload_stmt_ops = {
diff --git a/src/rt.c b/src/rt.c
index 232c1dc..455eac0 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -75,7 +75,8 @@ static const struct rt_template rt_templates[] = {
 					      true),
 };
 
-static void rt_expr_print(const struct expr *expr)
+static void rt_expr_print(const struct expr *expr,
+			  const struct proto_ctx *ctx)
 {
 	printf("rt %s", rt_templates[expr->rt.key].token);
 }
diff --git a/src/rule.c b/src/rule.c
index f2ffd4b..327988a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -351,7 +351,7 @@ static void do_set_print(const struct set *set, struct print_fmt_options *opts)
 
 	if (set->init != NULL && set->init->size > 0) {
 		printf("%s%selements = ", opts->tab, opts->tab);
-		expr_print(set->init);
+		expr_print(set->init, NULL);
 		printf("%s", opts->nl);
 	}
 	printf("%s}%s", opts->tab, opts->nl);
diff --git a/src/segtree.c b/src/segtree.c
index 8df82a8..456a9ea 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -563,7 +563,7 @@ int set_to_intervals(struct list_head *errs, struct set *set,
 	}
 
 	if (segtree_debug()) {
-		expr_print(init);
+		expr_print(init, NULL);
 		pr_gmp_debug("\n");
 	}
 	return 0;
diff --git a/src/statement.c b/src/statement.c
index 25bed65..7e2e448 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -67,7 +67,7 @@ void stmt_print(const struct stmt *stmt)
 
 static void expr_stmt_print(const struct stmt *stmt)
 {
-	expr_print(stmt->expr);
+	expr_print(stmt->expr, NULL);
 }
 
 static void expr_stmt_destroy(struct stmt *stmt)
@@ -111,11 +111,11 @@ static void flow_stmt_print(const struct stmt *stmt)
 {
 	printf("flow ");
 	if (stmt->flow.set) {
-		expr_print(stmt->flow.set);
+		expr_print(stmt->flow.set, NULL);
 		printf(" ");
 	}
 	printf("{ ");
-	expr_print(stmt->flow.key);
+	expr_print(stmt->flow.key, NULL);
 	printf(" ");
 	stmt_print(stmt->flow.stmt);
 	printf("} ");
@@ -182,7 +182,7 @@ static const char *objref_type_name(uint32_t type)
 static void objref_stmt_print(const struct stmt *stmt)
 {
 	printf("%s name ", objref_type_name(stmt->objref.type));
-	expr_print(stmt->objref.expr);
+	expr_print(stmt->objref.expr, NULL);
 }
 
 static const struct stmt_ops objref_stmt_ops = {
@@ -364,7 +364,7 @@ static void queue_stmt_print(const struct stmt *stmt)
 	printf("queue");
 	if (stmt->queue.queue != NULL) {
 		printf(" num ");
-		expr_print(stmt->queue.queue);
+		expr_print(stmt->queue.queue, NULL);
 	}
 	if (stmt->queue.flags & NFT_QUEUE_FLAG_BYPASS) {
 		printf("%sbypass", delim);
@@ -428,7 +428,7 @@ static void reject_stmt_print(const struct stmt *stmt)
 		if (stmt->reject.icmp_code == NFT_REJECT_ICMPX_PORT_UNREACH)
 			break;
 		printf(" with icmpx type ");
-		expr_print(stmt->reject.expr);
+		expr_print(stmt->reject.expr, NULL);
 		break;
 	case NFT_REJECT_ICMP_UNREACH:
 		switch (stmt->reject.family) {
@@ -436,13 +436,13 @@ static void reject_stmt_print(const struct stmt *stmt)
 			if (stmt->reject.icmp_code == ICMP_PORT_UNREACH)
 				break;
 			printf(" with icmp type ");
-			expr_print(stmt->reject.expr);
+			expr_print(stmt->reject.expr, NULL);
 			break;
 		case NFPROTO_IPV6:
 			if (stmt->reject.icmp_code == ICMP6_DST_UNREACH_NOPORT)
 				break;
 			printf(" with icmpv6 type ");
-			expr_print(stmt->reject.expr);
+			expr_print(stmt->reject.expr, NULL);
 			break;
 		}
 		break;
@@ -494,24 +494,24 @@ static void nat_stmt_print(const struct stmt *stmt)
 			if (stmt->nat.addr->ops->type == EXPR_VALUE &&
 			    stmt->nat.addr->dtype->type == TYPE_IP6ADDR) {
 				printf("[");
-				expr_print(stmt->nat.addr);
+				expr_print(stmt->nat.addr, NULL);
 				printf("]");
 			} else if (stmt->nat.addr->ops->type == EXPR_RANGE &&
 				   stmt->nat.addr->left->dtype->type == TYPE_IP6ADDR) {
 				printf("[");
-				expr_print(stmt->nat.addr->left);
+				expr_print(stmt->nat.addr->left, NULL);
 				printf("]-[");
-				expr_print(stmt->nat.addr->right);
+				expr_print(stmt->nat.addr->right, NULL);
 				printf("]");
 			}
 		} else {
-			expr_print(stmt->nat.addr);
+			expr_print(stmt->nat.addr, NULL);
 		}
 	}
 
 	if (stmt->nat.proto) {
 		printf(":");
-		expr_print(stmt->nat.proto);
+		expr_print(stmt->nat.proto, NULL);
 	}
 
 	print_nf_nat_flags(stmt->nat.flags);
@@ -541,7 +541,7 @@ static void masq_stmt_print(const struct stmt *stmt)
 
 	if (stmt->masq.proto) {
 		printf(" to :");
-		expr_print(stmt->masq.proto);
+		expr_print(stmt->masq.proto, NULL);
 	}
 
 	print_nf_nat_flags(stmt->masq.flags);
@@ -570,7 +570,7 @@ static void redir_stmt_print(const struct stmt *stmt)
 
 	if (stmt->redir.proto) {
 		printf(" to :");
-		expr_print(stmt->redir.proto);
+		expr_print(stmt->redir.proto, NULL);
 	}
 
 	print_nf_nat_flags(stmt->redir.flags);
@@ -601,9 +601,9 @@ static const char * const set_stmt_op_names[] = {
 static void set_stmt_print(const struct stmt *stmt)
 {
 	printf("set %s ", set_stmt_op_names[stmt->set.op]);
-	expr_print(stmt->set.key);
+	expr_print(stmt->set.key, NULL);
 	printf(" ");
-	expr_print(stmt->set.set);
+	expr_print(stmt->set.set, NULL);
 }
 
 static void set_stmt_destroy(struct stmt *stmt)
@@ -629,11 +629,11 @@ static void dup_stmt_print(const struct stmt *stmt)
 	printf("dup");
 	if (stmt->dup.to != NULL) {
 		printf(" to ");
-		expr_print(stmt->dup.to);
+		expr_print(stmt->dup.to, NULL);
 
 		if (stmt->dup.dev != NULL) {
 			printf(" device ");
-			expr_print(stmt->dup.dev);
+			expr_print(stmt->dup.dev, NULL);
 		}
 	}
 }
@@ -659,7 +659,7 @@ struct stmt *dup_stmt_alloc(const struct location *loc)
 static void fwd_stmt_print(const struct stmt *stmt)
 {
 	printf("fwd to ");
-	expr_print(stmt->fwd.to);
+	expr_print(stmt->fwd.to, NULL);
 }
 
 static void fwd_stmt_destroy(struct stmt *stmt)
-- 
2.7.4


--8t9RHnE3ZwKMSgU+--
