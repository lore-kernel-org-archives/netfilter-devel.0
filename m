From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH nft 2/4] src: add offset attribute for hash expression
Date: Sat, 22 Oct 2016 23:35:32 +0200
Message-ID: <c029fd344047975b1be38d7bf174c72c48de0258.1477170966.git.nevola@gmail.com>
References: <cover.1477170966.git.nevola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35095 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755759AbcJVVfh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Oct 2016 17:35:37 -0400
Received: by mail-wm0-f67.google.com with SMTP id o81so3944802wma.2
        for <netfilter-devel@vger.kernel.org>; Sat, 22 Oct 2016 14:35:36 -0700 (PDT)
Received: from sonyv (72.red-88-15-56.dynamicip.rima-tde.net. [88.15.56.72])
        by smtp.gmail.com with ESMTPSA id 63sm6553249wmv.1.2016.10.22.14.35.34
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sat, 22 Oct 2016 14:35:34 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <cover.1477170966.git.nevola@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support to add an offset to the hash generator.

Example:

 ct mark set hash ip saddr mod 10 offset 100

This will generate marks with series between 100-110.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 include/expression.h                |  1 +
 include/hash.h                      |  3 ++-
 include/linux/netfilter/nf_tables.h |  2 ++
 src/hash.c                          |  9 +++++++--
 src/netlink_delinearize.c           |  5 +++--
 src/netlink_linearize.c             |  1 +
 src/parser_bison.y                  | 15 ++++++++++-----
 src/scanner.l                       |  1 +
 tests/py/ip/hash.t                  |  2 ++
 9 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 13ca315..38073ee 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -297,6 +297,7 @@ struct expr {
 			struct expr		*expr;
 			uint32_t		mod;
 			uint32_t		seed;
+			uint32_t		offset;
 		} hash;
 	};
 };
diff --git a/include/hash.h b/include/hash.h
index 5350cb2..7883277 100644
--- a/include/hash.h
+++ b/include/hash.h
@@ -12,6 +12,7 @@
 #endif
 
 extern struct expr *hash_expr_alloc(const struct location *loc,
-				    uint32_t modulus, uint32_t seed);
+				    uint32_t modulus, uint32_t seed,
+				    uint32_t offset);
 
 #endif /* NFTABLES_HASH_H */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b21a844..335102d 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -760,6 +760,7 @@ enum nft_meta_keys {
  * @NFTA_HASH_LEN: source data length (NLA_U32)
  * @NFTA_HASH_MODULUS: modulus value (NLA_U32)
  * @NFTA_HASH_SEED: seed value (NLA_U32)
+ * @NFTA_HASH_OFFSET: offset value (NLA_U32)
  */
 enum nft_hash_attributes {
 	NFTA_HASH_UNSPEC,
@@ -768,6 +769,7 @@ enum nft_hash_attributes {
 	NFTA_HASH_LEN,
 	NFTA_HASH_MODULUS,
 	NFTA_HASH_SEED,
+	NFTA_HASH_OFFSET,
 	__NFTA_HASH_MAX,
 };
 #define NFTA_HASH_MAX	(__NFTA_HASH_MAX - 1)
diff --git a/src/hash.c b/src/hash.c
index 125b320..d26b2ed 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -22,13 +22,16 @@ static void hash_expr_print(const struct expr *expr)
 	printf(" mod %u", expr->hash.mod);
 	if (expr->hash.seed)
 		printf(" seed 0x%x", expr->hash.seed);
+	if (expr->hash.offset)
+		printf(" offset %u", expr->hash.offset);
 }
 
 static bool hash_expr_cmp(const struct expr *e1, const struct expr *e2)
 {
 	return expr_cmp(e1->hash.expr, e2->hash.expr) &&
 	       e1->hash.mod == e2->hash.mod &&
-	       e1->hash.seed == e2->hash.seed;
+	       e1->hash.seed == e2->hash.seed &&
+	       e1->hash.offset == e2->hash.offset;
 }
 
 static void hash_expr_clone(struct expr *new, const struct expr *expr)
@@ -36,6 +39,7 @@ static void hash_expr_clone(struct expr *new, const struct expr *expr)
 	new->hash.expr = expr_clone(expr->hash.expr);
 	new->hash.mod = expr->hash.mod;
 	new->hash.seed = expr->hash.seed;
+	new->hash.offset = expr->hash.offset;
 }
 
 static const struct expr_ops hash_expr_ops = {
@@ -47,7 +51,7 @@ static const struct expr_ops hash_expr_ops = {
 };
 
 struct expr *hash_expr_alloc(const struct location *loc, uint32_t mod,
-			     uint32_t seed)
+			     uint32_t seed, uint32_t offset)
 {
 	struct expr *expr;
 
@@ -55,6 +59,7 @@ struct expr *hash_expr_alloc(const struct location *loc, uint32_t mod,
 			  BYTEORDER_HOST_ENDIAN, 4 * BITS_PER_BYTE);
 	expr->hash.mod  = mod;
 	expr->hash.seed = seed;
+	expr->hash.offset = offset;
 
 	return expr;
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index d8d1d7d..7db109d 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -513,7 +513,7 @@ static void netlink_parse_hash(struct netlink_parse_ctx *ctx,
 {
 	enum nft_registers sreg, dreg;
 	struct expr *expr, *hexpr;
-	uint32_t mod, seed, len;
+	uint32_t mod, seed, len, offset;
 
 	sreg = netlink_parse_register(nle, NFTNL_EXPR_HASH_SREG);
 	hexpr = netlink_get_register(ctx, loc, sreg);
@@ -521,6 +521,7 @@ static void netlink_parse_hash(struct netlink_parse_ctx *ctx,
 		return netlink_error(ctx, loc,
 				     "hash statement has no expression");
 
+	offset = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_OFFSET);
 	seed = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_SEED);
 	mod  = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_MODULUS);
 	len = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_LEN) * BITS_PER_BYTE;
@@ -531,7 +532,7 @@ static void netlink_parse_hash(struct netlink_parse_ctx *ctx,
 			return;
 	}
 
-	expr = hash_expr_alloc(loc, mod, seed);
+	expr = hash_expr_alloc(loc, mod, seed, offset);
 	expr->hash.expr = hexpr;
 
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_HASH_DREG);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 0072dca..117ea8c 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -122,6 +122,7 @@ static void netlink_gen_hash(struct netlink_linearize_ctx *ctx,
 			   div_round_up(expr->hash.expr->len, BITS_PER_BYTE));
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_MODULUS, expr->hash.mod);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_SEED, expr->hash.seed);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_OFFSET, expr->hash.offset);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0fa469d..bb9320d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -413,6 +413,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token JHASH			"jhash"
 %token SEED			"seed"
+%token OFFSET			"offset"
 
 %token POSITION			"position"
 %token COMMENT			"comment"
@@ -561,7 +562,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <val>			arp_hdr_field
 %type <expr>			ip_hdr_expr	icmp_hdr_expr		numgen_expr	hash_expr
 %destructor { expr_free($$); }	ip_hdr_expr	icmp_hdr_expr		numgen_expr	hash_expr
-%type <val>			ip_hdr_field	icmp_hdr_field
+%type <val>			ip_hdr_field	icmp_hdr_field		offset_opt
 %type <expr>			ip6_hdr_expr    icmp6_hdr_expr
 %destructor { expr_free($$); }	ip6_hdr_expr	icmp6_hdr_expr
 %type <val>			ip6_hdr_field   icmp6_hdr_field
@@ -2480,18 +2481,22 @@ numgen_expr		:	NUMGEN	numgen_type	MOD	NUM
 			}
 			;
 
-hash_expr		:	JHASH	expr	MOD	NUM	SEED	NUM
+hash_expr		:	JHASH	expr	MOD	NUM	SEED	NUM	offset_opt
 			{
-				$$ = hash_expr_alloc(&@$, $4, $6);
+				$$ = hash_expr_alloc(&@$, $4, $6, $7);
 				$$->hash.expr = $2;
 			}
-			|	JHASH	expr	MOD	NUM
+			|	JHASH	expr	MOD	NUM	offset_opt
 			{
-				$$ = hash_expr_alloc(&@$, $4, getrandom());
+				$$ = hash_expr_alloc(&@$, $4, getrandom(), $5);
 				$$->hash.expr = $2;
 			}
 			;
 
+offset_opt		:	/* empty */	{ $$ = 0; }
+			|	OFFSET	NUM	{ $$ = $2; }
+			;
+
 ct_expr			: 	CT	ct_key
 			{
 				$$ = ct_expr_alloc(&@$, $2, -1);
diff --git a/src/scanner.l b/src/scanner.l
index 8b5a383..868b77b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -473,6 +473,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "jhash"			{ return JHASH; }
 "seed"			{ return SEED; }
+"offset"		{ return OFFSET; }
 
 "dup"			{ return DUP; }
 "fwd"			{ return FWD; }
diff --git a/tests/py/ip/hash.t b/tests/py/ip/hash.t
index 85f9b18..27a9dbe 100644
--- a/tests/py/ip/hash.t
+++ b/tests/py/ip/hash.t
@@ -2,6 +2,8 @@
 *ip;test-ip4;pre
 
 ct mark set jhash ip saddr . ip daddr mod 2 seed 0xdeadbeef;ok
+ct mark set jhash ip saddr . ip daddr mod 2 seed 0xdeadbeef offset 100;ok
 ct mark set jhash ip saddr . ip daddr mod 2;ok
+ct mark set jhash ip saddr . ip daddr mod 2 offset 100;ok
 dnat to jhash ip saddr mod 2 seed 0xdeadbeef map { 0 : 192.168.20.100, 1 : 192.168.30.100 };ok
 dnat to jhash ip saddr mod 2 map { 0 : 192.168.20.100, 1 : 192.168.30.100 };ok
-- 
2.9.3

