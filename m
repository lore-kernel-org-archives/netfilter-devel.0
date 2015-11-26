From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Thu, 26 Nov 2015 10:50:17 +0000
Message-ID: <20151126105017.GB16828@macbook.localdomain>
References: <20151124105300.GK2310@macbook.localdomain>
 <20151124111029.GH1740@breakpoint.cc>
 <20151124113341.GO2310@macbook.localdomain>
 <20151124151542.GA20972@breakpoint.cc>
 <20151124152649.GK14478@macbook.localdomain>
 <20151124153550.GC20972@breakpoint.cc>
 <20151124154241.GL14478@macbook.localdomain>
 <20151125150640.GE18449@macbook.localdomain>
 <20151125162424.GJ23215@breakpoint.cc>
 <20151125164629.GB30712@macbook.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:34431 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751014AbbKZKuW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 05:50:22 -0500
Content-Disposition: inline
In-Reply-To: <20151125164629.GB30712@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 25.11, Patrick McHardy wrote:
> On 25.11, Florian Westphal wrote:
> > I would propose to annotate the address fields in the protocol
> > description, similar to the filter you added, and then walk
> > header several times.
> > 
> > 1st round dumps source address
> > 2nd round dumps dst address
> > 3rd round dumps the next protocol field
> > 4th round dumps the rest that isn't 'blacklisted' (such as checksum).
> > 
> > Ugly, but given headers differ completely I don't see a better
> > solution.
> > Since headers are commonly small the overhead should not be
> > a big deal.
> 
> I've also considered this and so far it was my favourite approach as
> well. Unfortunately it requires annotations for all headers, but I guess
> that's an acceptable tradeoff.

Ok here's might current state. I've added an output filter and defined
output ordering, so we can surpress some fields and order the remaining
ones the way we want. I've also added redundant payload dependency
elimination.

Example output looks like this:

trace id 85060d00 arp packet: iif ens3 ether saddr 63:f6:4b:00:54:52 ether daddr c9:4b:a9:00:54:52 arp operation reply arp sha 63:f6:4b:00:54:52 arp sip 192.168.122.1 arp tha c9:4b:a9:00:54:52 arp tip 192.168.122.84

trace id 853ff400 ip packet: iif ens3 ether saddr 63:f6:4b:00:54:52 ether daddr c9:4b:a9:00:54:52 ip saddr 192.168.122.1 ip daddr 192.168.122.84 ip tos 16 ip ttl 64 ip id 38325 ip length 60 tcp sport 46156 tcp dport 10000

trace id 853ffc00 ip packet: oif ens3 ip saddr 192.168.122.84 ip daddr 192.168.122.1 ip tos 16 ip ttl 64 ip id 51655 ip length 40 tcp sport 10000 tcp dport 46156

If people are happy this way I'll start getting it into final shape.

Cheers,
Patrick

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="1.diff"

commit 0df38a649c851291352a410ee6ebbc9492f9b7d2
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed Nov 25 18:46:14 2015 +0000

    payload: move payload depedency tracking to payload.c
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/payload.h b/include/payload.h
index ca9b013..619a9c9 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -15,6 +15,24 @@ struct stmt;
 extern int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				  struct stmt **res);
 
+/**
+ * struct payload_dep_ctx - payload protocol dependency tracking
+ *
+ * @pbase: protocol base of last dependency match
+ * @pdep: last dependency match
+ */
+struct payload_dep_ctx {
+	enum proto_bases	pbase;
+	struct stmt		*pdep;
+};
+
+extern void payload_dependency_store(struct payload_dep_ctx *ctx,
+				     struct stmt *stmt,
+				     enum proto_bases base);
+extern void payload_dependency_kill(struct payload_dep_ctx *ctx,
+				    struct expr *expr);
+
+
 extern bool payload_is_adjacent(const struct expr *e1, const struct expr *e2);
 extern struct expr *payload_expr_join(const struct expr *e1,
 				      const struct expr *e2);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 614fbe0..5d81068 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -945,34 +945,10 @@ static int netlink_parse_expr(struct nftnl_expr *nle, void *arg)
 
 struct rule_pp_ctx {
 	struct proto_ctx	pctx;
-	enum proto_bases	pbase;
-	struct stmt		*pdep;
+	struct payload_dep_ctx	pdctx;
 	struct stmt		*stmt;
 };
 
-/*
- * Kill a redundant payload dependecy that is implied by a higher layer payload expression.
- */
-static void payload_dependency_kill(struct rule_pp_ctx *ctx, struct expr *expr)
-{
-	if (ctx->pbase != PROTO_BASE_INVALID &&
-	    ctx->pbase == expr->payload.base &&
-	    ctx->pdep != NULL) {
-		list_del(&ctx->pdep->list);
-		stmt_free(ctx->pdep);
-		ctx->pbase = PROTO_BASE_INVALID;
-		ctx->pdep = NULL;
-	}
-}
-
-static void payload_dependency_store(struct rule_pp_ctx *ctx,
-				     struct stmt *stmt,
-				     enum proto_bases base)
-{
-	ctx->pbase = base + 1;
-	ctx->pdep  = stmt;
-}
-
 static void integer_type_postprocess(struct expr *expr)
 {
 	struct expr *i;
@@ -1036,7 +1012,7 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		 * kill it later on if made redundant by a higher layer
 		 * payload expression.
 		 */
-		if (ctx->pbase == PROTO_BASE_INVALID &&
+		if (ctx->pdctx.pbase == PROTO_BASE_INVALID &&
 		    left->flags & EXPR_F_PROTOCOL) {
 			unsigned int proto = mpz_get_be16(tmp->value);
 			const struct proto_desc *desc, *next;
@@ -1052,12 +1028,14 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 			if (stacked_header) {
 				ctx->pctx.protocol[base].desc = next;
 				ctx->pctx.protocol[base].offset += desc->length;
-				payload_dependency_store(ctx, nstmt, base - 1);
+				payload_dependency_store(&ctx->pdctx,
+							 nstmt, base - 1);
 			} else {
-				payload_dependency_store(ctx, nstmt, base);
+				payload_dependency_store(&ctx->pdctx,
+							 nstmt, base);
 			}
 		} else {
-			payload_dependency_kill(ctx, nexpr->left);
+			payload_dependency_kill(&ctx->pdctx, nexpr->left);
 		}
 	}
 	list_del(&ctx->stmt->list);
@@ -1087,7 +1065,7 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 		payload_expr_complete(payload, &ctx->pctx);
 		expr_set_type(expr->right, payload->dtype,
 			      payload->byteorder);
-		payload_dependency_kill(ctx, payload);
+		payload_dependency_kill(&ctx->pdctx, payload);
 		break;
 	}
 }
@@ -1104,9 +1082,9 @@ static void meta_match_postprocess(struct rule_pp_ctx *ctx,
 
 		expr->left->ops->pctx_update(&ctx->pctx, expr);
 
-		if (ctx->pbase == PROTO_BASE_INVALID &&
+		if (ctx->pdctx.pbase == PROTO_BASE_INVALID &&
 		    left->flags & EXPR_F_PROTOCOL)
-			payload_dependency_store(ctx, ctx->stmt,
+			payload_dependency_store(&ctx->pdctx, ctx->stmt,
 						 left->meta.base);
 		break;
 	case OP_LOOKUP:
@@ -1410,7 +1388,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		break;
 	case EXPR_PAYLOAD:
 		payload_expr_complete(expr, &ctx->pctx);
-		payload_dependency_kill(ctx, expr);
+		payload_dependency_kill(&ctx->pdctx, expr);
 		break;
 	case EXPR_VALUE:
 		// FIXME
diff --git a/src/payload.c b/src/payload.c
index a97041e..dabd504 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -282,6 +282,42 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 }
 
 /**
+ * payload_dependency_store - store a possibly redundant protocol match
+ *
+ * @ctx: payload dependency context
+ * @stmt: payload match
+ * @base: base of payload match
+ */
+void payload_dependency_store(struct payload_dep_ctx *ctx,
+			      struct stmt *stmt, enum proto_bases base)
+{
+	ctx->pbase = base + 1;
+	ctx->pdep  = stmt;
+}
+
+/**
+ * payload_dependency_kill - kill a redundant payload depedency
+ *
+ * @ctx: payload dependency context
+ * @expr: higher layer payload expression
+ *
+ * Kill a redundant payload expression if a higher layer payload expression
+ * implies its existance.
+ */
+void payload_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr)
+{
+	if (ctx->pbase != PROTO_BASE_INVALID &&
+	    ctx->pbase == expr->payload.base &&
+	    ctx->pdep != NULL) {
+		list_del(&ctx->pdep->list);
+		stmt_free(ctx->pdep);
+
+		ctx->pbase = PROTO_BASE_INVALID;
+		ctx->pdep  = NULL;
+	}
+}
+
+/**
  * payload_expr_complete - fill in type information of a raw payload expr
  *
  * @expr:	the payload expression

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.diff"

commit a42310894bdb739f3e0e11bf500bfb580790b49f
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed Nov 25 16:51:10 2015 +0000

    .

diff --git a/include/payload.h b/include/payload.h
index 619a9c9..59027a1 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -9,6 +9,7 @@ extern struct expr *payload_expr_alloc(const struct location *loc,
 				       unsigned int type);
 extern void payload_init_raw(struct expr *expr, enum proto_bases base,
 			     unsigned int offset, unsigned int len);
+extern unsigned int payload_hdr_field(const struct expr *expr);
 
 struct eval_ctx;
 struct stmt;
diff --git a/include/proto.h b/include/proto.h
index a31ab91..6397107 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -85,6 +85,11 @@ struct proto_desc {
 		const struct proto_desc		*desc;
 	}				protocols[PROTO_UPPER_MAX];
 	struct proto_hdr_template	templates[PROTO_HDRS_MAX];
+	struct {
+		uint8_t				order[PROTO_HDRS_MAX];
+		uint32_t			filter;
+	}				format;
+
 };
 
 #define PROTO_LINK(__num, __desc)	{ .num = (__num), .desc = (__desc), }
diff --git a/src/netlink.c b/src/netlink.c
index 8ab7bbe..63e7ac5 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -31,6 +31,7 @@
 #include <netlink.h>
 #include <mnl.h>
 #include <expression.h>
+#include <statement.h>
 #include <gmputil.h>
 #include <utils.h>
 #include <erec.h>
@@ -2165,19 +2166,130 @@ static void trace_print_rule(const struct nftnl_trace *nlt)
 	}
 }
 
-static void trace_print_if(const struct nftnl_trace *nlt, uint16_t attr, const char *str)
+static void trace_gen_hdr(struct list_head *stmts,
+			  struct proto_ctx *ctx, struct payload_dep_ctx *pctx,
+			  const struct nftnl_trace *nlt, unsigned int attr,
+			  enum proto_bases base)
 {
-	char __name[IFNAMSIZ];
-	const char *ifname;
+	struct list_head unordered = LIST_HEAD_INIT(unordered);
+	struct list_head list = LIST_HEAD_INIT(list);
+	struct expr *rel, *lhs, *rhs, *tmp, *nexpr;
+	struct stmt *stmt, *nstmt;
+	const struct proto_desc *desc;
+	const void *hdr;
+	uint32_t hlen;
+	unsigned int n;
 
-        if (!nftnl_trace_is_set(nlt, attr))
+	if (!nftnl_trace_is_set(nlt, attr))
 		return;
+	hdr = nftnl_trace_get_data(nlt, attr, &hlen);
+
+	lhs = payload_expr_alloc(&netlink_location, NULL, 0);
+	payload_init_raw(lhs, base, 0, hlen * BITS_PER_BYTE);
+	rhs = constant_expr_alloc(&netlink_location,
+				  &invalid_type, BYTEORDER_INVALID,
+				  hlen * BITS_PER_BYTE, hdr);
+
+	payload_expr_expand(&list, lhs, NULL, ctx);
+	list_for_each_entry_safe(lhs, nexpr, &list, list) {
+		tmp = constant_expr_splice(rhs, lhs->len);
+		expr_set_type(tmp, lhs->dtype, lhs->byteorder);
+
+		/* Skip unknown and filtered expressions */
+		desc = lhs->payload.desc;
+		if (lhs->dtype == &invalid_type ||
+		    desc->format.filter & (1 << payload_hdr_field(lhs))) {
+			expr_free(lhs);
+			expr_free(tmp);
+			continue;
+		}
 
-	ifname = nft_if_indextoname(nftnl_trace_get_u32(nlt, attr), __name);
-	if (ifname)
-		printf(" %s %s", str, ifname);
-	else
-		printf(" %s %d", str, nftnl_trace_get_u32(nlt, attr));
+		rel  = relational_expr_alloc(&lhs->location, OP_EQ, lhs, tmp);
+		stmt = expr_stmt_alloc(&rel->location, rel);
+		list_add_tail(&stmt->list, &unordered);
+	}
+
+	n = 0;
+next:
+	list_for_each_entry_safe(stmt, nstmt, &unordered, list) {
+		rel = stmt->expr;
+		lhs = rel->left;
+
+		/* Move statements to result list in defined order */
+		desc = lhs->payload.desc;
+		if (desc->format.order[n] &&
+		    desc->format.order[n] != payload_hdr_field(lhs))
+			continue;
+
+		list_move_tail(&stmt->list, stmts);
+		n++;
+
+		lhs->ops->pctx_update(ctx, rel);
+		if (lhs->flags & EXPR_F_PROTOCOL &&
+		    pctx->pbase == PROTO_BASE_INVALID)
+			payload_dependency_store(pctx, stmt, base);
+		else
+			payload_dependency_kill(pctx, lhs);
+
+		goto next;
+	}
+}
+
+static void trace_alloc_expr(const struct nftnl_trace *nlt, unsigned int attr,
+			     struct expr *lhs)
+{
+	struct expr *rhs, *rel;
+	const void *data;
+	uint32_t len;
+
+	data = nftnl_trace_get_data(nlt, attr, &len);
+	rhs  = constant_expr_alloc(&netlink_location,
+				   lhs->dtype, lhs->byteorder,
+				   len * BITS_PER_BYTE, data);
+	rel  = relational_expr_alloc(&netlink_location, OP_EQ, lhs, rhs);
+
+	expr_print(rel);
+	printf(" ");
+	expr_free(rel);
+}
+
+static void trace_print_packet(const struct nftnl_trace *nlt)
+{
+	struct list_head stmts = LIST_HEAD_INIT(stmts);
+	struct payload_dep_ctx pctx = {};
+	struct proto_ctx ctx;
+	uint16_t dev_type;
+	struct stmt *stmt, *next;
+
+	proto_ctx_init(&ctx, nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY));
+	if (ctx.protocol[PROTO_BASE_LL_HDR].desc == NULL &&
+	    nftnl_trace_is_set(nlt, NFTNL_TRACE_DEV_TYPE)) {
+		dev_type = nftnl_trace_get_u16(nlt, NFTNL_TRACE_DEV_TYPE);
+		proto_ctx_update(&ctx, PROTO_BASE_LL_HDR, &netlink_location,
+				 proto_dev_desc(dev_type));
+	}
+
+	printf("packet: ");
+
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_IIF))
+		trace_alloc_expr(nlt, NFTNL_TRACE_IIF,
+			meta_expr_alloc(&netlink_location, NFT_META_IIF));
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_OIF))
+		trace_alloc_expr(nlt, NFTNL_TRACE_OIF,
+			meta_expr_alloc(&netlink_location, NFT_META_OIF));
+
+	trace_gen_hdr(&stmts, &ctx, &pctx, nlt, NFTNL_TRACE_LL_HEADER,
+		      PROTO_BASE_LL_HDR);
+	trace_gen_hdr(&stmts, &ctx, &pctx, nlt, NFTNL_TRACE_NETWORK_HEADER,
+		      PROTO_BASE_NETWORK_HDR);
+	trace_gen_hdr(&stmts, &ctx, &pctx, nlt, NFTNL_TRACE_TRANSPORT_HEADER,
+		      PROTO_BASE_TRANSPORT_HDR);
+
+	list_for_each_entry_safe(stmt, next, &stmts, list) {
+		stmt_print(stmt);
+		printf(" ");
+		stmt_free(stmt);
+	}
 }
 
 static int netlink_events_trace_cb(const struct nlmsghdr *nlh, int type,
@@ -2194,11 +2306,37 @@ static int netlink_events_trace_cb(const struct nlmsghdr *nlh, int type,
 	if (nftnl_trace_nlmsg_parse(nlh, nlt) < 0)
 		netlink_abi_error();
 
-	printf("trace ");
-	nftnl_trace_fprintf(stdout, nlt, monh->format);
+	printf("trace id %08x ", nftnl_trace_get_u32(nlt, NFTNL_TRACE_ID));
+
+	printf("%s ", family2str(nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY)));
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_TABLE))
+		printf("%s ", nftnl_trace_get_str(nlt, NFTNL_TRACE_TABLE));
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_CHAIN))
+		printf("%s ", nftnl_trace_get_str(nlt, NFTNL_TRACE_CHAIN));
+
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_VERDICT)) {
+		unsigned int verdict;
+		struct expr *expr;
+
+		verdict = nftnl_trace_get_u32(nlt, NFTNL_TRACE_VERDICT);
+		expr = verdict_expr_alloc(&netlink_location, verdict, "");
+
+		printf("verdict ");
+		expr_print(expr);
+		printf(" ");
+	}
+
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_MARK))
+		trace_alloc_expr(nlt, NFTNL_TRACE_MARK,
+			meta_expr_alloc(&netlink_location, NFT_META_MARK));
+
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_VLAN_TAG))
+		printf("vlan id %u ",
+		       nftnl_trace_get_u16(nlt, NFTNL_TRACE_VLAN_TAG));
 
-	trace_print_if(nlt, NFTNL_TRACE_IIF, "iif");
-	trace_print_if(nlt, NFTNL_TRACE_OIF, "oif");
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_LL_HEADER) ||
+	    nftnl_trace_is_set(nlt, NFTNL_TRACE_NETWORK_HEADER))
+		trace_print_packet(nlt);
 
 	trace_print_rule(nlt);
 	printf("\n");
diff --git a/src/payload.c b/src/payload.c
index dabd504..d00ddf6 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -138,6 +138,11 @@ void payload_init_raw(struct expr *expr, enum proto_bases base,
 	expr->len		= len;
 }
 
+unsigned int payload_hdr_field(const struct expr *expr)
+{
+	return expr->payload.tmpl - expr->payload.desc->templates;
+}
+
 static void payload_stmt_print(const struct stmt *stmt)
 {
 	expr_print(stmt->payload.expr);
@@ -457,6 +462,7 @@ void payload_expr_expand(struct list_head *list, struct expr *expr,
 		goto raw;
 	assert(desc->base == expr->payload.base);
 
+restart:
 	for (i = 1; i < array_size(desc->templates); i++) {
 		tmpl = &desc->templates[i];
 		if (tmpl->offset != expr->payload.offset)
@@ -469,6 +475,7 @@ void payload_expr_expand(struct list_head *list, struct expr *expr,
 			expr->payload.offset += tmpl->len;
 			if (expr->len == off)
 				return;
+			goto restart;
 		} else
 			break;
 	}
diff --git a/src/proto.c b/src/proto.c
index 803ee97..8e1fa02 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -331,6 +331,9 @@ const struct proto_desc proto_icmp = {
 		[ICMPHDR_GATEWAY]	= ICMPHDR_FIELD("gateway", un.gateway),
 		[ICMPHDR_MTU]		= ICMPHDR_FIELD("mtu", un.frag.mtu),
 	},
+	.format		= {
+		.filter	= (1 << ICMPHDR_CHECKSUM),
+	},
 };
 
 /*
@@ -520,6 +523,14 @@ const struct proto_desc proto_ip = {
 		[IPHDR_SADDR]		= IPHDR_ADDR("saddr",		saddr),
 		[IPHDR_DADDR]		= IPHDR_ADDR("daddr",		daddr),
 	},
+	.format		= {
+		.order	= {
+			IPHDR_SADDR, IPHDR_DADDR, IPHDR_TOS, IPHDR_TTL,
+			IPHDR_ID, IPHDR_PROTOCOL, IPHDR_LENGTH,
+		},
+		.filter	= (1 << IPHDR_VERSION)  | (1 << IPHDR_HDRLENGTH) |
+			  (1 << IPHDR_FRAG_OFF) | (1 << IPHDR_CHECKSUM),
+	},
 };
 
 /*
@@ -708,6 +719,10 @@ const struct proto_desc proto_arp = {
 		[ARPHDR_THA]		= PROTO_HDR_TEMPLATE("tha", &etheraddr_type, BYTEORDER_BIG_ENDIAN, 18 * BITS_PER_BYTE, 6 * BITS_PER_BYTE),
 		[ARPHDR_TPA]		= PROTO_HDR_TEMPLATE("tip", &ipaddr_type, BYTEORDER_BIG_ENDIAN, 24 * BITS_PER_BYTE, 4 * BITS_PER_BYTE),
 	},
+	.format		= {
+		.filter	= (1 << ARPHDR_HRD) | (1 << ARPHDR_PRO) |
+			  (1 << ARPHDR_HLN) | (1 << ARPHDR_PLN),
+	},
 };
 
 /*
@@ -807,6 +822,12 @@ const struct proto_desc proto_eth = {
 		[ETHHDR_SADDR]		= ETHHDR_ADDR("saddr", ether_shost),
 		[ETHHDR_TYPE]		= ETHHDR_TYPE("type", ether_type),
 	},
+	.format		= {
+		.order	= {
+			ETHHDR_SADDR, ETHHDR_DADDR, ETHHDR_TYPE,
+		},
+	},
+
 };
 
 static void __init proto_init(void)

--ZGiS0Q5IWpPtfppv--
