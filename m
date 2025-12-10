Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0D43019CB
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Dec 2025 15:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765379025; cv=none; b=BEgTBvlGMnrCQ5zSSS+nWEwuny2Pg7fliUcJGDReapTQp7NRcgqXTV/R7EnyBVHYZQYKwSJ69Ul1zuCK+thVpdIeLcyCCPu7Fc+jFVvZ4WmkTadxplOgjGsyfZ8Kr415oXh5bYiePp+Cz/jpZLdiTcMivWEmK2T3SGINL4djnKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765379025; c=relaxed/simple;
	bh=lDqSqJih4uR/pHuQvVkWF2DBr/RPK/WwuxUOViv6csA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yv8VFZCSckuokJxHJXHd+a1ZYkuf40uxQW7dMMGTtgMhEQR/JnnOZoLxVYO1pt/+G9toGPfD+Wgzrzz0X3mXfOVYgWwnhwqAbQzntL2/5K0pkLaNR7lnQO7RloQIIHD6myb8Pqym25Ei4fmDLJIWlCLkZgkmNINpP/gls1KauN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PGYpggGf; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PGYpggGf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=AacyXkJNjEA9XQ0mLxV5k9wXhL3SAC11HANXisARqPQ=; b=PGYpggGfc4P1hCy2jsgwSbUWmK
	cy7o0AjTLA9O36WwOmZCRPwHJC3TpMV56oQuQeKAwqPCN5kMOq9d48yK/sZDe4Ffhd+iBQsmF3nrF
	r9tfDVi6EiM6tOsKAZzhIq/LXPXNM5XD585BfCsbfAlgVWVBtn3K8U1FD//mWqrfb5963YdwjZpjI
	qBgsMOEw6V24oTZ6rxS6shZoGoVHHuFYuzRUJBM+rcW8t5JDSZI1jADvGBJsvVgo4Mdf1d5DARidX
	eKTWR7NxpR6CwpsPRPLYDzseNaTeddnpIu5AHrk0nv4Jv8tMpazi8Ccjw09gABPCdWAHrUBCZfD3a
	dsc8H+Ig==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vTLj8-000000005Hz-1bow;
	Wed, 10 Dec 2025 16:03:38 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2] src: Convert ip {s,d}addr to IPv4-mapped as needed
Date: Wed, 10 Dec 2025 16:03:33 +0100
Message-ID: <20251210150333.14654-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to reuse IPv6 address-based data structures like sets and maps
with IPv4 packets, if a relational's RHS data type is ip6addr_type, turn
these payload expressions into binop expressions with new OP_V6MAP
internally to have them produce IPv4-mapped IPv6 addresses from the
packet-extracted data as described in RFC4291 section 2.5.5.2[1].

Since the adjustment merely consists of injecting an immediate
expression, no specific kernel support is required for this feature.

Upon deserialization of an ip {s,d}addr expression, the new construct is
detected by probing for a previous immediate expression loading the
expected value into preceeding registers.

Special casing is needed in binop_expr_clone() and expr_postprocess() to
avoid expr->right dereference and to maintain payload expression's
behaviour regarding OP_EQ printing.

While at it, fix documentation of accepted IPv4 address notations: While
dotted hexadecimal is not accepted at all, dotted octal works with
two-digit numbers only (the scanner expects at most three digits).
Therefore drop both from the list.

[1] https://www.rfc-editor.org/rfc/rfc4291#section-2.5.5.2

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- This is v2 of "src: Implement ip {s,d}addr6 expressions" avoiding the
  introduction of new keywords.

Note that adding IPv4 addresses to sets of type ip6addr_type is still
rejected although easily enabled by passing AI_V4MAPPED flag to
getaddrinfo(): Since this also resolves DNS names, users may
unexpectedly add a host's IPv4 address in mapped notation if the name
doesn't resolve to an IPv6 address for whatever reason. If we really
want to open this can of worms, it deserves a separate patch anyway.
---
 doc/data-types.txt              |   5 +-
 doc/payload-expression.txt      |   4 +
 include/expression.h            |   1 +
 src/evaluate.c                  |   9 +++
 src/expression.c                |   9 ++-
 src/json.c                      |   3 +
 src/netlink_delinearize.c       |  33 ++++++++
 src/netlink_linearize.c         |  18 +++++
 tests/py/ip/ip.t                |  16 ++++
 tests/py/ip/ip.t.json           | 128 ++++++++++++++++++++++++++++++++
 tests/py/ip/ip.t.json.output    |  60 +++++++++++++++
 tests/py/ip/ip.t.payload        |  37 +++++++++
 tests/py/ip/ip.t.payload.bridge |  49 ++++++++++++
 tests/py/ip/ip.t.payload.inet   |  49 ++++++++++++
 tests/py/ip/ip.t.payload.netdev |  49 ++++++++++++
 15 files changed, 467 insertions(+), 3 deletions(-)

diff --git a/doc/data-types.txt b/doc/data-types.txt
index e44308b5322cb..d6bdac0b10c06 100644
--- a/doc/data-types.txt
+++ b/doc/data-types.txt
@@ -116,7 +116,7 @@ integer
 |===================
 
 The IPv4 address type is used for IPv4 addresses. Addresses are specified in
-either dotted decimal, dotted hexadecimal, dotted octal, decimal, hexadecimal,
+either dotted decimal, IPv4-mapped (::ffff:0:0/96), decimal, hexadecimal,
 octal notation or as a host name. A host name will be resolved using the
 standard system resolver.
 
@@ -125,6 +125,9 @@ standard system resolver.
 # dotted decimal notation
 filter output ip daddr 127.0.0.1
 
+# IPv4-mapped notation
+filter output ip daddr ::ffff:127.0.0.1
+
 # host name
 filter output ip daddr localhost
 ----------------------------
diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 8b538968c84b5..3c2cb4d39410a 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -141,6 +141,10 @@ gro_ipv4_max_size and gso_ipv4_max_size), then *ip length* might be 0 for such
 jumbo packets. *meta length* allows you to match on the packet length including
 the IP header size.
 
+If needed, *ip saddr* and *ip daddr* expressions are converted to produce
+IPv4-mapped IPv6 addresses (e.g. ::ffff:1.2.3.4). This way, a common set or map
+with key type *ipv6_addr* may be used for both IPv4 and IPv6 packets.
+
 ICMP HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~
 [verse]
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
index 4be5299274d26..179b192c6f4d1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -991,6 +991,7 @@ static bool payload_needs_adjustment(const struct expr *expr)
 
 static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **exprp)
 {
+	const struct datatype *dtype = ctx->ectx.dtype;
 	const struct expr *key = ctx->ectx.key;
 	struct expr *expr = *exprp;
 
@@ -1012,6 +1013,14 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **exprp)
 			return err;
 	}
 
+	if (expr->dtype == &ipaddr_type && dtype == &ip6addr_type) {
+		*exprp = binop_expr_alloc(&expr->location,
+					  OP_V6MAP, expr, NULL);
+		datatype_set(*exprp, &ip6addr_type);
+		(*exprp)->len = ip6addr_type.size;
+		return 0;
+	}
+
 	expr->payload.evaluated = true;
 
 	return 0;
diff --git a/src/expression.c b/src/expression.c
index 4d68967f112e4..17bc613b23551 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -854,13 +854,17 @@ bool must_print_eq_op(const struct expr *expr)
 	    expr->right->etype == EXPR_VALUE)
 		return true;
 
-	return expr->left->etype == EXPR_BINOP;
+	return expr->left->etype == EXPR_BINOP &&
+	       expr->left->op != OP_V6MAP;
 }
 
 static void binop_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	binop_arg_print(expr, expr->left, octx);
 
+	if (expr->op == OP_V6MAP)
+		return;
+
 	if (expr_op_symbols[expr->op] &&
 	    (expr->op != OP_EQ || must_print_eq_op(expr)))
 		nft_print(octx, " %s ", expr_op_symbols[expr->op]);
@@ -873,7 +877,8 @@ static void binop_expr_print(const struct expr *expr, struct output_ctx *octx)
 static void binop_expr_clone(struct expr *new, const struct expr *expr)
 {
 	new->left  = expr_clone(expr->left);
-	new->right = expr_clone(expr->right);
+	if (expr->right)
+		new->right = expr_clone(expr->right);
 }
 
 static void binop_expr_destroy(struct expr *expr)
diff --git a/src/json.c b/src/json.c
index 9fb6d715a53de..9a10d8ae6298b 100644
--- a/src/json.c
+++ b/src/json.c
@@ -668,6 +668,9 @@ __binop_expr_json(int op, const struct expr *expr, struct output_ctx *octx)
 
 json_t *binop_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
+	if (expr->op == OP_V6MAP)
+		return payload_expr_json(expr->left, octx);
+
 	return nft_json_pack("{s:o}", expr_op_symbols[expr->op],
 			 __binop_expr_json(expr->op, expr, octx));
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 9561e298aebb5..061178e2ade9b 100644
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
@@ -649,10 +650,31 @@ static void netlink_parse_byteorder(struct netlink_parse_ctx *ctx,
 	netlink_set_register(ctx, dreg, expr);
 }
 
+static bool payload_is_ip_addr(const struct expr *expr)
+{
+	size_t saddr_offset = offsetof(struct iphdr, saddr) * BITS_PER_BYTE;
+	size_t daddr_offset = offsetof(struct iphdr, daddr) * BITS_PER_BYTE;
+
+	return expr->payload.base == PROTO_BASE_NETWORK_HDR &&
+	       expr->len == ipaddr_type.size &&
+	       (expr->payload.offset == saddr_offset ||
+		expr->payload.offset == daddr_offset);
+}
+
+static bool immediate_is_v6map_pfx(const struct expr *expr)
+{
+	return expr &&
+	       expr->etype == EXPR_VALUE &&
+	       expr->len == ip6addr_type.size - ipaddr_type.size &&
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
@@ -670,6 +692,15 @@ static void netlink_parse_payload_expr(struct netlink_parse_ctx *ctx,
 
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_PAYLOAD_DREG);
 
+	if (dreg >= v6map_reg_off &&
+	    payload_is_ip_addr(expr) &&
+	    immediate_is_v6map_pfx(ctx->registers[dreg - v6map_reg_off])) {
+		expr = binop_expr_alloc(loc, OP_V6MAP, expr, NULL);
+		datatype_set(expr, &ip6addr_type);
+		expr->len = ip6addr_type.size;
+		dreg -= v6map_reg_off;
+	}
+
 	if (ctx->inner)
 		ctx->inner_reg = dreg;
 
@@ -2925,6 +2956,8 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 				return;
 			}
 			break;
+		case OP_V6MAP:
+			return;
 		default:
 			if (expr->right->len > expr->left->len) {
 				expr_set_type(expr->right, expr->left->dtype,
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 30bc0094cc7e6..1d90e49ba44bd 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -798,6 +798,21 @@ static void netlink_gen_bitwise_bool(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_v6map(struct netlink_linearize_ctx *ctx,
+			      const struct expr *expr, enum nft_registers dreg)
+{
+	const uint16_t pfx[6] = { 0, 0, 0, 0, 0, 0xffff };
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("immediate");
+	netlink_put_register(nle, NFTNL_EXPR_IMM_DREG, dreg);
+	nftnl_expr_set(nle, NFTNL_EXPR_IMM_DATA, pfx, sizeof(pfx));
+	nftnl_rule_add_expr(ctx->nlr, nle);
+
+	dreg += netlink_register_space(sizeof(pfx) * BITS_PER_BYTE);
+	netlink_gen_expr(ctx, expr->left, dreg);
+}
+
 static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 			      const struct expr *expr,
 			      enum nft_registers dreg)
@@ -807,6 +822,9 @@ static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 	case OP_RSHIFT:
 		netlink_gen_bitwise_shift(ctx, expr, dreg);
 		break;
+	case OP_V6MAP:
+		netlink_gen_v6map(ctx, expr, dreg);
+		break;
 	default:
 		if (expr_is_constant(expr->right))
 			netlink_gen_bitwise_mask_xor(ctx, expr, dreg);
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 47262d9a43617..2b218015afdc0 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -7,6 +7,13 @@
 *bridge;test-bridge;input
 *netdev;test-netdev;ingress,egress
 
+!ip6addrset type ipv6_addr;ok
+?ip6addrset feed::c0:ffee, ::ffff:1.2.3.4;ok
+!v4v6set type ipv4_addr . ipv6_addr;ok
+?v4v6set 1.2.3.4 . ::ffff:5.6.7.8;ok
+!v6v4set type ipv6_addr . ipv4_addr;ok
+?v6v4set ::ffff:5.6.7.8 . 1.2.3.4;ok
+
 - ip version 2;ok
 
 # bug ip hdrlength
@@ -110,6 +117,15 @@ ip saddr & 0.0.0.255 < 0.0.0.127;ok
 
 ip saddr & 0xffff0000 == 0xffff0000;ok;ip saddr 255.255.0.0/16
 
+ip saddr ::ffff:1.2.3.4;ok;ip saddr 1.2.3.4
+ip daddr ::ffff:1.2.3.4;ok;ip daddr 1.2.3.4
+ip saddr { ::ffff:1.2.3.4, feed::c0:ff:ee };fail
+ip daddr { ::ffff:1.2.3.4, feed::c0:ff:ee };fail
+ip saddr ::ffff:1.2.3.4 ip daddr 5.6.7.8;ok;ip saddr 1.2.3.4 ip daddr 5.6.7.8
+ip saddr @ip6addrset;ok
+ip saddr . ip daddr @v4v6set;ok
+ip saddr . ip daddr @v6v4set;ok
+
 ip version 4 ip hdrlength 5;ok
 ip hdrlength 0;ok
 ip hdrlength 15;ok
diff --git a/tests/py/ip/ip.t.json b/tests/py/ip/ip.t.json
index 3c3a12d7117ce..bf15cca406ec1 100644
--- a/tests/py/ip/ip.t.json
+++ b/tests/py/ip/ip.t.json
@@ -1350,6 +1350,134 @@
     }
 ]
 
+# ip saddr ::ffff:1.2.3.4
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": "::ffff:1.2.3.4"
+        }
+    }
+]
+
+# ip daddr ::ffff:1.2.3.4
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "daddr",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": "::ffff:1.2.3.4"
+        }
+    }
+]
+
+# ip saddr ::ffff:1.2.3.4 ip daddr 5.6.7.8
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
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
+# ip saddr @ip6addrset
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": "@ip6addrset"
+        }
+    }
+]
+
+# ip saddr . ip daddr @v4v6set
+[
+    {
+        "match": {
+            "left": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "daddr",
+                            "protocol": "ip"
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": "@v4v6set"
+        }
+    }
+]
+
+# ip saddr . ip daddr @v6v4set
+[
+    {
+        "match": {
+            "left": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "daddr",
+                            "protocol": "ip"
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": "@v6v4set"
+        }
+    }
+]
+
 # ip version 4 ip hdrlength 5
 [
     {
diff --git a/tests/py/ip/ip.t.json.output b/tests/py/ip/ip.t.json.output
index 351ae93549fa6..8155e44c558f7 100644
--- a/tests/py/ip/ip.t.json.output
+++ b/tests/py/ip/ip.t.json.output
@@ -206,6 +206,66 @@
     }
 ]
 
+# ip saddr ::ffff:1.2.3.4
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": "1.2.3.4"
+        }
+    }
+]
+
+# ip daddr ::ffff:1.2.3.4
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "daddr",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": "1.2.3.4"
+        }
+    }
+]
+
+# ip saddr ::ffff:1.2.3.4 ip daddr 5.6.7.8
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": "1.2.3.4"
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
 # iif "lo" ip ecn set 1
 [
     {
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index 0e9936278008b..dfd90028a7475 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -413,6 +413,43 @@ ip test-ip4 input
   [ bitwise reg 1 = ( reg 1 & 0x0000ffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000ffff ]
 
+# ip saddr ::ffff:1.2.3.4
+ip test-ip4 input
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+
+# ip daddr ::ffff:1.2.3.4
+ip test-ip4 input
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+
+# ip saddr ::ffff:1.2.3.4 ip daddr 5.6.7.8
+ip test-ip4 input
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x08070605 ]
+
+# ip saddr @ip6addrset
+ip test-ip4 input
+  [ immediate reg 1 0x00000000 0x00000000 0xffff0000 ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ lookup reg 1 set ip6addrset ]
+
+# ip saddr . ip daddr @v4v6set
+ip test-ip4 input
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ immediate reg 9 0x00000000 0x00000000 0xffff0000 ]
+  [ payload load 4b @ network header + 16 => reg 2 ]
+  [ lookup reg 1 set v4v6set ]
+
+# ip saddr . ip daddr @v6v4set
+ip test-ip4 input
+  [ immediate reg 1 0x00000000 0x00000000 0xffff0000 ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ payload load 4b @ network header + 16 => reg 2 ]
+  [ lookup reg 1 set v6v4set ]
+
 # ip version 4 ip hdrlength 5
 ip test-ip4 input
   [ payload load 1b @ network header + 0 => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index 663f87d7b4acf..0b1d0cf105ae1 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -549,6 +549,55 @@ bridge test-bridge input
   [ bitwise reg 1 = ( reg 1 & 0x0000ffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000ffff ]
 
+# ip saddr ::ffff:1.2.3.4
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+
+# ip daddr ::ffff:1.2.3.4
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+
+# ip saddr ::ffff:1.2.3.4 ip daddr 5.6.7.8
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x08070605 ]
+
+# ip saddr @ip6addrset
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ immediate reg 1 0x00000000 0x00000000 0xffff0000 ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ lookup reg 1 set ip6addrset ]
+
+# ip saddr . ip daddr @v4v6set
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ immediate reg 9 0x00000000 0x00000000 0xffff0000 ]
+  [ payload load 4b @ network header + 16 => reg 2 ]
+  [ lookup reg 1 set v4v6set ]
+
+# ip saddr . ip daddr @v6v4set
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ immediate reg 1 0x00000000 0x00000000 0xffff0000 ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ payload load 4b @ network header + 16 => reg 2 ]
+  [ lookup reg 1 set v6v4set ]
+
 # ip version 4 ip hdrlength 5
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index b8ab49c871430..50321962402df 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -549,6 +549,55 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x0000ffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000ffff ]
 
+# ip saddr ::ffff:1.2.3.4
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+
+# ip daddr ::ffff:1.2.3.4
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+
+# ip saddr ::ffff:1.2.3.4 ip daddr 5.6.7.8
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x08070605 ]
+
+# ip saddr @ip6addrset
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ immediate reg 1 0x00000000 0x00000000 0xffff0000 ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ lookup reg 1 set ip6addrset ]
+
+# ip saddr . ip daddr @v4v6set
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ immediate reg 9 0x00000000 0x00000000 0xffff0000 ]
+  [ payload load 4b @ network header + 16 => reg 2 ]
+  [ lookup reg 1 set v4v6set ]
+
+# ip saddr . ip daddr @v6v4set
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ immediate reg 1 0x00000000 0x00000000 0xffff0000 ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ payload load 4b @ network header + 16 => reg 2 ]
+  [ lookup reg 1 set v6v4set ]
+
 # ip version 4 ip hdrlength 5
 inet test-inet input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index bd3495324b918..768eb077b92fe 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -448,6 +448,55 @@ netdev test-netdev ingress
   [ bitwise reg 1 = ( reg 1 & 0x0000ffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000ffff ]
 
+# ip saddr ::ffff:1.2.3.4
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+
+# ip daddr ::ffff:1.2.3.4
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+
+# ip saddr ::ffff:1.2.3.4 ip daddr 5.6.7.8
+netdev test-netdev egress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x08070605 ]
+
+# ip saddr @ip6addrset
+netdev test-netdev egress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ immediate reg 1 0x00000000 0x00000000 0xffff0000 ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ lookup reg 1 set ip6addrset ]
+
+# ip saddr . ip daddr @v4v6set
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ immediate reg 9 0x00000000 0x00000000 0xffff0000 ]
+  [ payload load 4b @ network header + 16 => reg 2 ]
+  [ lookup reg 1 set v4v6set ]
+
+# ip saddr . ip daddr @v6v4set
+netdev test-netdev egress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ immediate reg 1 0x00000000 0x00000000 0xffff0000 ]
+  [ payload load 4b @ network header + 12 => reg 11 ]
+  [ payload load 4b @ network header + 16 => reg 2 ]
+  [ lookup reg 1 set v6v4set ]
+
 # ip version 4 ip hdrlength 5
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-- 
2.51.0

