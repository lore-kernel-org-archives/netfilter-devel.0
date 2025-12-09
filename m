Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE1A2FFF9A
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Dec 2025 15:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765294865; cv=none; b=BFVkryfaT1oELJ8PK63tWAxhMcPj1WHpzRFewKYZx0wcHRgUCvgNXFva88MDxwh3w0zW6eklpyO7HBLlx+SlpuTViDLS0NSJpHVRyfcYzXnOAa6f1teIZOiouYUmXSkwxeLddDwc0PgfshOELqH29C16UI4N05cyF1Rkhk9KnfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765294865; c=relaxed/simple;
	bh=dZ7zdiTp/YX/4rnXGq5ehqreI1kBTLQe3dZzA4o3iGc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jUNH7hD5id/wZAP0D7bn3pXyGOQsWBy6nzFi+P7b98P1lZk+Q/WDwNQ18bje4RA/iq4rCQ4QcK0R2PMbUH1YbgPXFGNNHtTMm78LB/9uUALFnHQsNpEBTO7J0LQuDH7qNygBjww9PawKAXK6RCWqaCc9Pw5CJbDDgzPhrzh9w2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ixwzkbvF; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ixwzkbvF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+Yl5Y0VHajaqiskDlrcaevoqDRkECVCm/7MMo7ITOMM=; b=ixwzkbvFs4UlnIgZS9vwHEOun8
	PUbDYEFa/l1EunPMPX3Oi+PknYKpekeFPjZLoNyYWYvzV9PnN24FPnEd05pD2PV3aBUACp/e/PH3x
	OO8STGKhzVqHBLzXMWwntIsXdwtRfxfp7rbNp75ziZODN9+stpMKTfqpRHg+QzdyzjreI3af2qzeU
	mok9SB2Ajg0FnVkxQ+SIe5bFpPmf/Rn7+kGV7EXBWRoQ3baMZ/oThQtAAVKjJptzLh6+LLmPmFHmG
	n2pClHWM6kGNC/YqGzQyS6SD6iI1zRsHYuCMzwI5L2XcLnAplbA/pTgAZRlasC8KlVozHQsnZ5tkg
	hL7U5nAA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vSzpd-00000000530-28Ph;
	Tue, 09 Dec 2025 16:40:53 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH] src: Implement ip {s,d}addr6 expressions
Date: Tue,  9 Dec 2025 16:40:48 +0100
Message-ID: <20251209154048.26338-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are pseudo payload expressions which represent an IPv4 packet's
source or destination address as an IPv4-mapped IPv6 address as
described in RFC4291 section 2.5.5.2[1]. It helps sharing ruleset
elements like IP address-based sets/maps between rules for IPv4 and IPv6
traffic.

Internally, this is implemented as a new binop expression which contains
a respective ip {s,d}addr expression. Upon serialization, it resolves
into an immediate expression followed by said payload expression.
Therefore it does not require specific kernel support.

Upon deserialization of an ip {s,d}addr expression, the new construct is
detected by probing for a previous immediate expression loading the
expected value into preceeding registers.

Special casing is needed in binop_expr_clone() and expr_postprocess() to
avoid expr->right dereference and to maintain payload expression's
behaviour regarding OP_EQ printing.

[1] https://www.rfc-editor.org/rfc/rfc4291#section-2.5.5.2

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/payload-expression.txt      |   8 ++-
 include/expression.h            |   1 +
 src/evaluate.c                  |   9 +++
 src/expression.c                |  11 +++-
 src/json.c                      |  10 ++++
 src/netlink_delinearize.c       |  34 +++++++++++
 src/netlink_linearize.c         |  23 +++++++
 src/parser_bison.y              |  12 ++++
 src/parser_json.c               |  30 ++++++++--
 src/scanner.l                   |   4 ++
 tests/py/ip/ip.t                |   6 ++
 tests/py/ip/ip.t.json           | 102 ++++++++++++++++++++++++++++++++
 tests/py/ip/ip.t.payload        |  34 +++++++++++
 tests/py/ip/ip.t.payload.bridge |  44 ++++++++++++++
 tests/py/ip/ip.t.payload.inet   |  44 ++++++++++++++
 tests/py/ip/ip.t.payload.netdev |  44 ++++++++++++++
 16 files changed, 408 insertions(+), 8 deletions(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 8b538968c84b5..e301e2e9b4ce2 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -90,7 +90,7 @@ ipv4_addr
 IPV4 HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*ip* {*version* | *hdrlength* | *dscp* | *ecn* | *length* | *id* | *frag-off* | *ttl* | *protocol* | *checksum* | *saddr* | *daddr* }
+*ip* {*version* | *hdrlength* | *dscp* | *ecn* | *length* | *id* | *frag-off* | *ttl* | *protocol* | *checksum* | *saddr* | *daddr* | *saddr6* | *daddr6* }
 
 .IPv4 header expression
 [options="header"]
@@ -132,6 +132,12 @@ ipv4_addr
 |daddr|
 Destination address |
 ipv4_addr
+|saddr6|
+Source address in mapped notation |
+ipv6_addr
+|daddr6|
+Destination address in mapped notation |
+ipv6_addr
 |======================
 
 Careful with matching on *ip length*: The Linux kernel might aggregate several
diff --git a/include/expression.h b/include/expression.h
index a960f8cb8b087..1e494b3f14230 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -107,6 +107,7 @@ enum ops {
 	OP_LTE,
 	OP_GTE,
 	OP_NEG,
+	OP_V6MAP,
 	__OP_MAX
 };
 #define OP_MAX		(__OP_MAX - 1)
diff --git a/src/evaluate.c b/src/evaluate.c
index 204845554f0b0..1ea859e5143c6 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1531,6 +1531,15 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 	unsigned int max_shift_len = ctx->ectx.len;
 	int ret = -1;
 
+	if (op->op == OP_V6MAP) {
+		op->len = sizeof(struct in6_addr) * BITS_PER_BYTE;
+		op->dtype = datatype_get(&ip6addr_type);
+		ret = expr_evaluate(ctx, &op->left);
+		__expr_set_context(&ctx->ectx, op->dtype,
+				   op->byteorder, op->len, 0);
+		return ret;
+	}
+
 	if (ctx->recursion.binop >= USHRT_MAX)
 		return expr_binary_error(ctx->msgs, op, NULL,
 					 "Binary operation limit %u reached ",
diff --git a/src/expression.c b/src/expression.c
index e036c4bb69965..2a8f5153c01d3 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -854,13 +854,19 @@ bool must_print_eq_op(const struct expr *expr)
 	    expr->right->etype == EXPR_VALUE)
 		return true;
 
-	return expr->left->etype == EXPR_BINOP;
+	return expr->left->etype == EXPR_BINOP &&
+	       expr->left->op != OP_V6MAP;
 }
 
 static void binop_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	binop_arg_print(expr, expr->left, octx);
 
+	if (expr->op == OP_V6MAP) {
+		nft_print(octx, "6");
+		return;
+	}
+
 	if (expr_op_symbols[expr->op] &&
 	    (expr->op != OP_EQ || must_print_eq_op(expr)))
 		nft_print(octx, " %s ", expr_op_symbols[expr->op]);
@@ -873,7 +879,8 @@ static void binop_expr_print(const struct expr *expr, struct output_ctx *octx)
 static void binop_expr_clone(struct expr *new, const struct expr *expr)
 {
 	new->left  = expr_clone(expr->left);
-	new->right = expr_clone(expr->right);
+	if (expr->right)
+		new->right = expr_clone(expr->right);
 }
 
 static void binop_expr_destroy(struct expr *expr)
diff --git a/src/json.c b/src/json.c
index 9fb6d715a53de..86bb9d9351262 100644
--- a/src/json.c
+++ b/src/json.c
@@ -668,6 +668,16 @@ __binop_expr_json(int op, const struct expr *expr, struct output_ctx *octx)
 
 json_t *binop_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
+	if (expr->op == OP_V6MAP) {
+		json_t *root = payload_expr_json(expr->left, octx);
+		json_t *payload = json_object_get(root, "payload");
+		const char *field;
+
+		json_unpack(payload, "{s:s}", "field", &field);
+		json_object_set_new(payload, "field",
+				    json_sprintf("%s6", field));
+		return root;
+	}
 	return nft_json_pack("{s:o}", expr_op_symbols[expr->op],
 			 __binop_expr_json(expr->op, expr, octx));
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 9561e298aebb5..1699b247cb55d 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -17,6 +17,7 @@
 #include <linux/netfilter/nf_nat.h>
 #include <linux/netfilter.h>
 #include <net/ethernet.h>
+#include <netinet/ip.h>
 #include <netlink.h>
 #include <rule.h>
 #include <statement.h>
@@ -649,10 +650,32 @@ static void netlink_parse_byteorder(struct netlink_parse_ctx *ctx,
 	netlink_set_register(ctx, dreg, expr);
 }
 
+static bool payload_is_ip_addr(const struct expr *expr)
+{
+	size_t saddr_offset = offsetof(struct iphdr, saddr) * BITS_PER_BYTE;
+	size_t daddr_offset = offsetof(struct iphdr, daddr) * BITS_PER_BYTE;
+
+	return expr->payload.base == PROTO_BASE_NETWORK_HDR &&
+	       expr->len == sizeof(struct in_addr) * BITS_PER_BYTE &&
+	       (expr->payload.offset == saddr_offset ||
+		expr->payload.offset == daddr_offset);
+}
+
+static bool immediate_is_v6map_pfx(const struct expr *expr)
+{
+	return expr &&
+	       expr->etype == EXPR_VALUE &&
+	       expr->len == (sizeof(struct in6_addr) -
+			     sizeof(struct in_addr)) * BITS_PER_BYTE &&
+	       !mpz_cmp_ui(expr->value, 0xffff);
+}
+
 static void netlink_parse_payload_expr(struct netlink_parse_ctx *ctx,
 				       const struct location *loc,
 				       const struct nftnl_expr *nle)
 {
+	size_t v6map_reg_off = (sizeof(struct in6_addr) -
+				sizeof(struct in_addr)) / NFT_REG32_SIZE;
 	enum nft_registers dreg;
 	uint32_t base, offset, len;
 	struct expr *expr;
@@ -670,6 +693,15 @@ static void netlink_parse_payload_expr(struct netlink_parse_ctx *ctx,
 
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_PAYLOAD_DREG);
 
+	if (dreg >= v6map_reg_off &&
+	    payload_is_ip_addr(expr) &&
+	    immediate_is_v6map_pfx(ctx->registers[dreg - v6map_reg_off])) {
+		expr = binop_expr_alloc(loc, OP_V6MAP, expr, NULL);
+		expr->len = sizeof(struct in6_addr) * BITS_PER_BYTE;
+		expr->dtype = datatype_get(&ip6addr_type);
+		dreg -= v6map_reg_off;
+	}
+
 	if (ctx->inner)
 		ctx->inner_reg = dreg;
 
@@ -2925,6 +2957,8 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 				return;
 			}
 			break;
+		case OP_V6MAP:
+			return;
 		default:
 			if (expr->right->len > expr->left->len) {
 				expr_set_type(expr->right, expr->left->dtype,
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index ac0eaff9a23ca..61577fe06326d 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -807,6 +807,26 @@ static void netlink_gen_bitwise_bool(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_v6map(struct netlink_linearize_ctx *ctx,
+			      const struct expr *expr, enum nft_registers dreg)
+{
+	size_t pfxlen = sizeof(struct in6_addr) - sizeof(struct in_addr);
+	struct nft_data_linearize nld = {
+		.len		= pfxlen,
+		.value		= { 0, 0, htonl(0xffff) },
+	};
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("immediate");
+	netlink_put_register(nle, NFTNL_EXPR_IMM_DREG, dreg);
+	nftnl_expr_set_imm(nle, NFTNL_EXPR_IMM_DATA,
+			   nld.value, nld.len, nld.byteorder);
+	nftnl_rule_add_expr(ctx->nlr, nle);
+
+	dreg += netlink_register_space(nld.len * BITS_PER_BYTE);
+	netlink_gen_expr(ctx, expr->left, dreg);
+}
+
 static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 			      const struct expr *expr,
 			      enum nft_registers dreg)
@@ -816,6 +836,9 @@ static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 	case OP_RSHIFT:
 		netlink_gen_bitwise_shift(ctx, expr, dreg);
 		break;
+	case OP_V6MAP:
+		netlink_gen_v6map(ctx, expr, dreg);
+		break;
 	default:
 		if (expr_is_constant(expr->right))
 			netlink_gen_bitwise_mask_xor(ctx, expr, dreg);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3ceef79469d7d..d2dbb5354f0c6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -403,6 +403,8 @@ int nft_lex(void *, void *, void *);
 %token ETHER			"ether"
 %token SADDR			"saddr"
 %token DADDR			"daddr"
+%token SADDR6			"saddr6"
+%token DADDR6			"daddr6"
 %token TYPE			"type"
 
 %token VLAN			"vlan"
@@ -926,6 +928,7 @@ int nft_lex(void *, void *, void *);
 %type <expr>			ip_hdr_expr	icmp_hdr_expr		igmp_hdr_expr numgen_expr	hash_expr
 %destructor { expr_free($$); }	ip_hdr_expr	icmp_hdr_expr		igmp_hdr_expr numgen_expr	hash_expr
 %type <val>			ip_hdr_field	icmp_hdr_field		igmp_hdr_field
+%type <val>			ip_pseudo_hdr_field
 %type <val>			ip_option_type	ip_option_field
 %type <expr>			ip6_hdr_expr    icmp6_hdr_expr
 %destructor { expr_free($$); }	ip6_hdr_expr	icmp6_hdr_expr
@@ -5956,6 +5959,11 @@ ip_hdr_expr		:	IP	ip_hdr_field	close_scope_ip
 			{
 				$$ = payload_expr_alloc(&@$, &proto_ip, $2);
 			}
+			|	IP	ip_pseudo_hdr_field	close_scope_ip
+			{
+				$$ = payload_expr_alloc(&@$, &proto_ip, $2);
+				$$ = binop_expr_alloc(&@$, OP_V6MAP, $$, NULL);
+			}
 			|	IP	OPTION	ip_option_type ip_option_field	close_scope_ip
 			{
 				$$ = ipopt_expr_alloc(&@$, $3, $4);
@@ -5988,6 +5996,10 @@ ip_hdr_field		:	HDRVERSION	{ $$ = IPHDR_VERSION; }
 			|	DADDR		{ $$ = IPHDR_DADDR; }
 			;
 
+ip_pseudo_hdr_field	:	SADDR6		{ $$ = IPHDR_SADDR; }
+			|	DADDR6		{ $$ = IPHDR_DADDR; }
+			;
+
 ip_option_type		:	LSRR		{ $$ = IPOPT_LSRR; }
 			|	RR		{ $$ = IPOPT_RR; }
 			|	SSRR		{ $$ = IPOPT_SSRR; }
diff --git a/src/parser_json.c b/src/parser_json.c
index 7b4f33848ce12..fb330159be659 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -528,6 +528,22 @@ static int json_parse_payload_field(const struct proto_desc *desc,
 	return 1;
 }
 
+static int json_parse_ip_pseudo_hdr_field(const struct proto_desc *desc,
+					  const char *name, int *field)
+{
+	if (desc != &proto_ip)
+		return 1;
+	if (!strcmp(name, "saddr6")) {
+		*field = IPHDR_SADDR;
+		return 0;
+	}
+	if (!strcmp(name, "daddr6")) {
+		*field = IPHDR_DADDR;
+		return 0;
+	}
+	return 1;
+}
+
 static int json_parse_tcp_option_type(const char *name, int *val)
 {
 	unsigned int i;
@@ -715,15 +731,19 @@ static struct expr *json_parse_payload_expr(struct json_ctx *ctx,
 				   protocol);
 			return NULL;
 		}
-		if (json_parse_payload_field(proto, field, &val)) {
+		if (!json_parse_payload_field(proto, field, &val)) {
+			expr = payload_expr_alloc(int_loc, proto, val);
+
+			if (proto == &proto_th)
+				expr->payload.is_raw = true;
+		} else if (!json_parse_ip_pseudo_hdr_field(proto, field, &val)) {
+			expr = payload_expr_alloc(int_loc, proto, val);
+			expr = binop_expr_alloc(int_loc, OP_V6MAP, expr, NULL);
+		} else {
 			json_error(ctx, "Unknown %s field '%s'.",
 				   protocol, field);
 			return NULL;
 		}
-		expr = payload_expr_alloc(int_loc, proto, val);
-
-		if (proto == &proto_th)
-			expr->payload.is_raw = true;
 
 		return expr;
 	}
diff --git a/src/scanner.l b/src/scanner.l
index df8e536be2276..6d9bbb1b289f6 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -491,6 +491,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"saddr"			{ return SADDR; }
 	"daddr"			{ return DADDR; }
 }
+<SCANSTATE_IP>{
+	"saddr6"		{ return SADDR6; }
+	"daddr6"		{ return DADDR6; }
+}
 "type"			{ scanner_push_start_cond(yyscanner, SCANSTATE_TYPE); return TYPE; }
 "typeof"		{ return TYPEOF; }
 
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 47262d9a43617..32d791ac26db4 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -110,6 +110,12 @@ ip saddr & 0.0.0.255 < 0.0.0.127;ok
 
 ip saddr & 0xffff0000 == 0xffff0000;ok;ip saddr 255.255.0.0/16
 
+ip saddr6 ::ffff:1.2.3.4;ok
+ip daddr6 ::ffff:1.2.3.4;ok
+ip saddr6 { ::ffff:1.2.3.4, feed::c0:ff:ee };ok
+ip daddr6 { ::ffff:1.2.3.4, feed::c0:ff:ee };ok
+ip saddr6 ::ffff:1.2.3.4 ip daddr 5.6.7.8;ok
+
 ip version 4 ip hdrlength 5;ok
 ip hdrlength 0;ok
 ip hdrlength 15;ok
diff --git a/tests/py/ip/ip.t.json b/tests/py/ip/ip.t.json
index 3c3a12d7117ce..40c1e0728348c 100644
--- a/tests/py/ip/ip.t.json
+++ b/tests/py/ip/ip.t.json
@@ -1350,6 +1350,108 @@
     }
 ]
 
+# ip saddr6 ::ffff:1.2.3.4
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr6",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": "::ffff:1.2.3.4"
+        }
+    }
+]
+
+# ip daddr6 ::ffff:1.2.3.4
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "daddr6",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": "::ffff:1.2.3.4"
+        }
+    }
+]
+
+# ip saddr6 { ::ffff:1.2.3.4, feed::c0:ff:ee }
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr6",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "::ffff:1.2.3.4",
+                    "feed::c0:ff:ee"
+                ]
+            }
+        }
+    }
+]
+
+# ip daddr6 { ::ffff:1.2.3.4, feed::c0:ff:ee }
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "daddr6",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "::ffff:1.2.3.4",
+                    "feed::c0:ff:ee"
+                ]
+            }
+        }
+    }
+]
+
+# ip saddr6 ::ffff:1.2.3.4 ip daddr 5.6.7.8
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr6",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": "::ffff:1.2.3.4"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "daddr",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": "5.6.7.8"
+        }
+    }
+]
+
 # ip version 4 ip hdrlength 5
 [
     {
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index b3442e49e5979..2d488b3e8dd9a 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -413,6 +413,40 @@ ip test-ip4 input
   [ bitwise reg 1 = ( reg 1 & 0xffff0000 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0xffff0000 ]
 
+# ip saddr6 ::ffff:1.2.3.4
+ip test-ip4 input
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x0000ffff 0x01020304 ]
+
+# ip daddr6 ::ffff:1.2.3.4
+ip test-ip4 input
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 16 => reg 11 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x0000ffff 0x01020304 ]
+
+# ip saddr6 { ::ffff:1.2.3.4, feed::c0:ff:ee }
+	element 00000000 00000000 0000ffff 01020304	element feed0000 00000000 000000c0 00ff00ee
+ip test-ip4 input
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ lookup reg 1 set __set%d ]
+
+# ip daddr6 { ::ffff:1.2.3.4, feed::c0:ff:ee }
+	element 00000000 00000000 0000ffff 01020304	element feed0000 00000000 000000c0 00ff00ee
+ip test-ip4 input
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 16 => reg 11 ]
+  [ lookup reg 1 set __set%d ]
+
+# ip saddr6 ::ffff:1.2.3.4 ip daddr 5.6.7.8
+ip test-ip4 input
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x0000ffff 0x01020304 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x05060708 ]
+
 # ip version 4 ip hdrlength 5
 ip test-ip4 input
   [ payload load 1b @ network header + 0 => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index 9da3fc266f52f..376ad6686e7c8 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -549,6 +549,50 @@ bridge test-bridge input
   [ bitwise reg 1 = ( reg 1 & 0xffff0000 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0xffff0000 ]
 
+# ip saddr6 ::ffff:1.2.3.4
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0800 ]
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x0000ffff 0x01020304 ]
+
+# ip daddr6 ::ffff:1.2.3.4
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0800 ]
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 16 => reg 11 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x0000ffff 0x01020304 ]
+
+# ip saddr6 { ::ffff:1.2.3.4, feed::c0:ff:ee }
+	element 00000000 00000000 0000ffff 01020304	element feed0000 00000000 000000c0 00ff00ee
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0800 ]
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ lookup reg 1 set __set%d ]
+
+# ip daddr6 { ::ffff:1.2.3.4, feed::c0:ff:ee }
+	element 00000000 00000000 0000ffff 01020304	element feed0000 00000000 000000c0 00ff00ee
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0800 ]
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 16 => reg 11 ]
+  [ lookup reg 1 set __set%d ]
+
+# ip saddr6 ::ffff:1.2.3.4 ip daddr 5.6.7.8
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0800 ]
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x0000ffff 0x01020304 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x05060708 ]
+
 # ip version 4 ip hdrlength 5
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index 912ce58aa8bcf..abb73f4668dec 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -549,6 +549,50 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0xffff0000 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0xffff0000 ]
 
+# ip saddr6 ::ffff:1.2.3.4
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x02 ]
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x0000ffff 0x01020304 ]
+
+# ip daddr6 ::ffff:1.2.3.4
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x02 ]
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 16 => reg 11 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x0000ffff 0x01020304 ]
+
+# ip saddr6 { ::ffff:1.2.3.4, feed::c0:ff:ee }
+	element 00000000 00000000 0000ffff 01020304	element feed0000 00000000 000000c0 00ff00ee
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x02 ]
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ lookup reg 1 set __set%d ]
+
+# ip daddr6 { ::ffff:1.2.3.4, feed::c0:ff:ee }
+	element 00000000 00000000 0000ffff 01020304	element feed0000 00000000 000000c0 00ff00ee
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x02 ]
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 16 => reg 11 ]
+  [ lookup reg 1 set __set%d ]
+
+# ip saddr6 ::ffff:1.2.3.4 ip daddr 5.6.7.8
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x02 ]
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x0000ffff 0x01020304 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x05060708 ]
+
 # ip version 4 ip hdrlength 5
 inet test-inet input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 9103ffcc0e8e7..9c8eb0a927338 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -448,6 +448,50 @@ netdev test-netdev ingress
   [ bitwise reg 1 = ( reg 1 & 0xffff0000 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0xffff0000 ]
 
+# ip saddr6 ::ffff:1.2.3.4
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0800 ]
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x0000ffff 0x01020304 ]
+
+# ip daddr6 ::ffff:1.2.3.4
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0800 ]
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 16 => reg 11 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x0000ffff 0x01020304 ]
+
+# ip saddr6 { ::ffff:1.2.3.4, feed::c0:ff:ee }
+	element 00000000 00000000 0000ffff 01020304	element feed0000 00000000 000000c0 00ff00ee
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0800 ]
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ lookup reg 1 set __set%d ]
+
+# ip daddr6 { ::ffff:1.2.3.4, feed::c0:ff:ee }
+	element 00000000 00000000 0000ffff 01020304	element feed0000 00000000 000000c0 00ff00ee
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0800 ]
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 16 => reg 11 ]
+  [ lookup reg 1 set __set%d ]
+
+# ip saddr6 ::ffff:1.2.3.4 ip daddr 5.6.7.8
+netdev test-netdev egress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0800 ]
+  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x0000ffff 0x01020304 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x05060708 ]
+
 # ip version 4 ip hdrlength 5
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-- 
2.51.0

