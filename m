From: Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC nft] src: ct: add connection counting support
Date: Fri, 12 Jan 2018 14:41:11 +0100
Message-ID: <20180112134111.19132-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33580 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933544AbeALNyH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Jan 2018 08:54:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds support for a native connlimit replacement.

It re-uses nftables concatenation support and thus allows
using any key combinations supported by nftables.

Because counting is expensive, it is useful to limit this
to new connections only.  Example:

  ct state new ct count { ip saddr . tcp dport } gt 10 drop

TODO: man page entry.

NB: This uses {} to separate ct count statement from grouping to
avoid shift/reduce conflicts in the parser, unlike fib we do not
have distinct 'end marker' available.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/expression.h                |  1 +
 include/linux/netfilter/nf_tables.h |  1 +
 src/ct.c                            | 12 ++++++++++++
 src/evaluate.c                      |  7 +++++++
 src/netlink_delinearize.c           | 24 ++++++++++++++++++++++++
 src/netlink_linearize.c             | 12 ++++++++++++
 src/parser_bison.y                  |  5 +++++
 tests/py/inet/ct.t                  |  2 ++
 tests/py/inet/ct.t.payload          | 16 ++++++++++++++++
 9 files changed, 80 insertions(+)

diff --git a/include/expression.h b/include/expression.h
index 0a0e178fe468..b80d081b1595 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -303,6 +303,7 @@ struct expr {
 			enum proto_bases	base;
 			int8_t			direction;
 			uint8_t			nfproto;
+			struct expr		*expr;
 		} ct;
 		struct {
 			/* EXPR_NUMGEN */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index a3ee277b17a1..695e307e6e8e 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -929,6 +929,7 @@ enum nft_ct_keys {
 	NFT_CT_AVGPKT,
 	NFT_CT_ZONE,
 	NFT_CT_EVENTMASK,
+	NFT_CT_COUNT,
 };
 
 /**
diff --git a/src/ct.c b/src/ct.c
index d5347974bd0d..ffa5fb70154a 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -269,6 +269,8 @@ static const struct ct_template ct_templates[] = {
 					      BYTEORDER_HOST_ENDIAN, 16),
 	[NFT_CT_EVENTMASK]	= CT_TEMPLATE("event", &ct_event_type,
 					      BYTEORDER_HOST_ENDIAN, 32),
+	[NFT_CT_COUNT]		= CT_TEMPLATE("count", &integer_type,
+					      BYTEORDER_HOST_ENDIAN, 32),
 };
 
 static void ct_print(enum nft_ct_keys key, int8_t dir, uint8_t nfproto,
@@ -306,6 +308,16 @@ static void ct_print(enum nft_ct_keys key, int8_t dir, uint8_t nfproto,
 static void ct_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	ct_print(expr->ct.key, expr->ct.direction, expr->ct.nfproto, octx);
+
+	switch (expr->ct.key) {
+	case NFT_CT_COUNT:
+		nft_print(octx, " { ");
+		expr_print(expr->ct.expr, octx);
+		nft_print(octx, " }");
+		break;
+	default:
+		break;
+	}
 }
 
 static bool ct_expr_cmp(const struct expr *e1, const struct expr *e2)
diff --git a/src/evaluate.c b/src/evaluate.c
index 7fe738d8d590..c8ebbf02a11a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -767,6 +767,13 @@ static int expr_evaluate_ct(struct eval_ctx *ctx, struct expr **expr)
 	case NFT_CT_DST:
 		ct_gen_nh_dependency(ctx, ct);
 		break;
+	case NFT_CT_COUNT:
+		if (ct->ct.expr == NULL)
+			return expr_error(ctx->msgs, ct, "missing key\n");
+
+		if (expr_evaluate(ctx, &ct->ct.expr) < 0)
+			return -1;
+		break;
 	default:
 		break;
 	}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 2637f4baaec4..8ad3bf239019 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -718,6 +718,28 @@ static void netlink_parse_ct_expr(struct netlink_parse_ctx *ctx,
 	key  = nftnl_expr_get_u32(nle, NFTNL_EXPR_CT_KEY);
 	expr = ct_expr_alloc(loc, key, dir, NFPROTO_UNSPEC);
 
+	if (key == NFT_CT_COUNT) {
+		enum nft_registers sreg;
+		struct expr *sexpr;
+		uint32_t len;
+
+		sreg = netlink_parse_register(nle, NFTNL_EXPR_CT_SREG);
+		sexpr = netlink_get_register(ctx, loc, sreg);
+
+		if (sexpr == NULL)
+			return netlink_error(ctx, loc,
+					     "ct count has no expression");
+
+		len = nftnl_expr_get_u32(nle,
+					 NFTNL_EXPR_CT_SREG_LEN) * BITS_PER_BYTE;
+		if (sexpr->len < len) {
+			sexpr = netlink_parse_concat_expr(ctx, loc, sreg, len);
+			if (sexpr == NULL)
+				return;
+		}
+		expr->ct.expr = sexpr;
+	}
+
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_CT_DREG);
 	netlink_set_register(ctx, dreg, expr);
 }
@@ -1848,6 +1870,8 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 			expr_postprocess(ctx, &expr->hash.expr);
 		break;
 	case EXPR_CT:
+		if (expr->ct.expr)
+			expr_postprocess(ctx, &expr->ct.expr);
 		ct_expr_update_type(&ctx->pctx, expr);
 		break;
 	default:
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 99a4dde22adb..76457c6d324a 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -234,6 +234,18 @@ static void netlink_gen_ct(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set_u8(nle, NFTNL_EXPR_CT_DIR,
 				  expr->ct.direction);
 
+	if (expr->ct.expr) {
+		enum nft_registers sreg;
+
+		sreg = get_register(ctx, expr->ct.expr);
+		netlink_gen_expr(ctx, expr->ct.expr, sreg);
+		release_register(ctx, expr->ct.expr);
+		netlink_put_register(nle, NFTNL_EXPR_CT_SREG, sreg);
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_CT_SREG_LEN,
+				   div_round_up(expr->ct.expr->len,
+						BITS_PER_BYTE));
+	}
+
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6e85a62804d4..cd934b9c22dc 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3323,6 +3323,11 @@ ct_expr			: 	CT	ct_key
 			{
 				$$ = ct_expr_alloc(&@$, $4, $2, $3);
 			}
+			|	CT	COUNT	'{'	concat_expr	'}'
+			{
+				$$ = ct_expr_alloc(&@$, NFT_CT_COUNT, -1, NFPROTO_UNSPEC);
+				$$->ct.expr = $4;
+			}
 			;
 
 ct_dir			:	ORIGINAL	{ $$ = IP_CT_DIR_ORIGINAL; }
diff --git a/tests/py/inet/ct.t b/tests/py/inet/ct.t
index 1a656aa4375f..25533da51803 100644
--- a/tests/py/inet/ct.t
+++ b/tests/py/inet/ct.t
@@ -6,6 +6,8 @@
 meta nfproto ipv4 ct original saddr 1.2.3.4;ok;ct original ip saddr 1.2.3.4
 ct original ip6 saddr ::1;ok
 
+ct state new ct count { ip saddr . tcp dport } gt 2 counter;ok;ct state new ct count { ip saddr . tcp dport } > 2 counter
+
 # missing protocol context
 ct original saddr ::1;fail
 
diff --git a/tests/py/inet/ct.t.payload b/tests/py/inet/ct.t.payload
index 97128eccf540..61e9692670d1 100644
--- a/tests/py/inet/ct.t.payload
+++ b/tests/py/inet/ct.t.payload
@@ -11,3 +11,19 @@ inet test-inet input
   [ cmp eq reg 1 0x0000000a ]
   [ ct load src => reg 1 , dir original ]
   [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
+
+# ct state new ct count { ip saddr . tcp dport } gt 2 counter
+inet test-inet input
+  [ ct load state => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000008 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ network header + 12 => reg 2 ]
+  [ payload load 2b @ transport header + 2 => reg 13 ]
+  [ ct reg 1 = ct count (reg 2, 8) ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ cmp gt reg 1 0x02000000 ]
+  [ counter pkts 0 bytes 0 ]
-- 
2.13.6

