From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 08/17] src: add alternate syntax for ct saddr
Date: Wed, 28 Jun 2017 12:06:50 +0200
Message-ID: <20170628100659.26976-9-fw@strlen.de>
References: <20170628100659.26976-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33370 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751489AbdF1KHK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 06:07:10 -0400
In-Reply-To: <20170628100659.26976-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

current syntax is:

ct original saddr $address

problem is that in inet, bridge etc. we lack context to
figure out if this should fetch ipv6 or ipv4 from the conntrack
structure.

$address might not exist, rhs could e.g. be a set reference.

One way to do this is to have users manually specifiy the dependeny:

ct l3proto ipv4 ct original saddr $address

Thats ugly, and, moreover, only needed for table families
other than ip or ipv6.

Pablo suggested to instead specify ip saddr, ip6 saddr:

ct original ip saddr $address

and let nft handle the dependency injection.

This adds the required parts to the scanner and the grammar, next
commit adds code to eval step to make use of this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/ct.h              |  3 ++-
 include/expression.h      |  1 +
 src/ct.c                  |  3 ++-
 src/netlink_delinearize.c |  2 +-
 src/parser_bison.y        | 27 ++++++++++++++++++++++++---
 5 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/include/ct.h b/include/ct.h
index 69ccc913dd74..1c0ef0e423ae 100644
--- a/include/ct.h
+++ b/include/ct.h
@@ -24,7 +24,8 @@ struct ct_template {
 }
 
 extern struct expr *ct_expr_alloc(const struct location *loc,
-				  enum nft_ct_keys key, int8_t direction);
+				  enum nft_ct_keys key, int8_t direction,
+				  uint8_t nfproto);
 extern void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr);
 
 extern struct error_record *ct_dir_parse(const struct location *loc,
diff --git a/include/expression.h b/include/expression.h
index 3e67938a6390..0a07646ac4ad 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -300,6 +300,7 @@ struct expr {
 			/* EXPR_CT */
 			enum nft_ct_keys	key;
 			int8_t			direction;
+			uint8_t			nfproto;
 		} ct;
 		struct {
 			/* EXPR_NUMGEN */
diff --git a/src/ct.c b/src/ct.c
index f76f7867a77d..ffdc6a52ac97 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -350,7 +350,7 @@ struct error_record *ct_dir_parse(const struct location *loc, const char *str,
 }
 
 struct expr *ct_expr_alloc(const struct location *loc, enum nft_ct_keys key,
-			   int8_t direction)
+			   int8_t direction, uint8_t nfproto)
 {
 	const struct ct_template *tmpl = &ct_templates[key];
 	struct expr *expr;
@@ -359,6 +359,7 @@ struct expr *ct_expr_alloc(const struct location *loc, enum nft_ct_keys key,
 			  tmpl->byteorder, tmpl->len);
 	expr->ct.key = key;
 	expr->ct.direction = direction;
+	expr->ct.nfproto = nfproto;
 
 	switch (key) {
 	case NFT_CT_PROTOCOL:
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 3ee07c0a1306..c523c8ed4862 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -699,7 +699,7 @@ static void netlink_parse_ct_expr(struct netlink_parse_ctx *ctx,
 		dir = nftnl_expr_get_u8(nle, NFTNL_EXPR_CT_DIR);
 
 	key  = nftnl_expr_get_u32(nle, NFTNL_EXPR_CT_KEY);
-	expr = ct_expr_alloc(loc, key, dir);
+	expr = ct_expr_alloc(loc, key, dir, NFPROTO_UNSPEC);
 
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_CT_DREG);
 	netlink_set_register(ctx, dreg, expr);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 577f4bee167e..352acb5dda20 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -649,7 +649,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <expr>			ct_expr		ct_stmt_expr
 %destructor { expr_free($$); }	ct_expr		ct_stmt_expr
-%type <val>			ct_key		ct_key_dir	ct_key_dir_optional
+%type <val>			ct_key		ct_key_dir	ct_key_dir_optional	ct_key_proto	ct_key_proto_field
 
 %type <expr>			fib_expr
 %destructor { expr_free($$); }	fib_expr
@@ -3047,7 +3047,7 @@ rt_key			:	CLASSID		{ $$ = NFT_RT_CLASSID; }
 
 ct_expr			: 	CT	ct_key
 			{
-				$$ = ct_expr_alloc(&@$, $2, -1);
+				$$ = ct_expr_alloc(&@$, $2, -1, NFPROTO_UNSPEC);
 			}
 			|	CT	STRING	ct_key_dir
 			{
@@ -3060,7 +3060,20 @@ ct_expr			: 	CT	ct_key
 					YYERROR;
 				}
 
-				$$ = ct_expr_alloc(&@$, $3, direction);
+				$$ = ct_expr_alloc(&@$, $3, direction, NFPROTO_UNSPEC);
+			}
+			|	CT	STRING	ct_key_proto ct_key_proto_field
+			{
+				struct error_record *erec;
+				int8_t direction;
+
+				erec = ct_dir_parse(&@$, $2, &direction);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+
+				$$ = ct_expr_alloc(&@$, $4, direction, $3);
 			}
 			;
 
@@ -3086,6 +3099,14 @@ ct_key_dir		:	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
 			|	ct_key_dir_optional
 			;
 
+ct_key_proto		:	IP		{ $$ = NFPROTO_IPV4; }
+			|	IP6		{ $$ = NFPROTO_IPV6; }
+			;
+
+ct_key_proto_field	:	SADDR		{ $$ = NFT_CT_SRC; }
+			|	DADDR		{ $$ = NFT_CT_DST; }
+			;
+
 ct_key_dir_optional	:	BYTES		{ $$ = NFT_CT_BYTES; }
 			|	PACKETS		{ $$ = NFT_CT_PKTS; }
 			|	AVGPKT		{ $$ = NFT_CT_AVGPKT; }
-- 
2.13.0

