Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D65CCE79DE
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 15:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbjITPES (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 11:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235326AbjITPER (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 11:04:17 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0147DE
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 08:04:08 -0700 (PDT)
Received: from evilbit.green-communications.fr ([85.168.41.102]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.103]) with ESMTPSA (Nemesis)
 id 1MBUVj-1qpstN1TeJ-00CyNv; Wed, 20 Sep 2023 17:04:06 +0200
From:   Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft v2] icmpv6: Allow matching target address in NS/NA, redirect and MLD
Date:   Wed, 20 Sep 2023 17:03:34 +0200
Message-Id: <20230920150334.16922-1-nicolas.cavallari@green-communications.fr>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:PIvFAuxkzw0M5T5FYDiNhyZrZXIOsnKCajl9eJthW3qlZOrxLEr
 jjAXva/efiYPKhxD9v7WnMkIM65bnBjOTPqWlvvNUKzTu8E4yMm/SR3CObQRhyEPA6eBg5X
 W/lfSaEcyQGT+jsImW6bDTKp3d51dqXg65zqInA2911WwT/2hY+0EOgtx9TJJoooymi98AV
 xltJcbXg61Z9YoPZ9lYMA==
UI-OutboundReport: notjunk:1;M01:P0:Trnm9/IYS5g=;Vg7nXz/pElcoCVmyt1atVFVOtTa
 5qhK4fUoKBipkjR5LdamWzhMqbHvFuaiKC6F+Zj4V5WXvX10EqdGYKVK8hUYz9D37KQqg4PpZ
 UDBKyV5YGP7bPlr0u9E30dooZVa8IiObZXXRrA/noIQk6o7YysdAbHSCA5KKwsaKunQ0fqksR
 eR5pOL+wUSV1XbGJTGKnZLdxMdfP+uimQqP8JKyeR3YHcGGwojVT1XH+W5c9LkxgPzIxkcmC8
 sgHvWLFJEITz0YzyZ1f1D5ZZ721sRh5KYrfFIVLRNOYLUOUIajCABO70M2s53uPoELTptZUHd
 cXGNkg3RLnmdqyJ20mdL75Ho4y05c5wIIRjVheXlRyGdbkDr9ULRzOjhIQN51Iqyca7vmsKoS
 nZnKaiHNtxfk4N8ZPt5Vx5gdZ1nnci1fO1vlDMJSw8ld/1Y8Gy6TKe64zoHPiRH4hZxDoDzU2
 qyE6VuNboOV9rchBgDQ8DOsVboa7KKj/9HmUNFNkQMTR4kjetspykuMC1wtK5NmbmtRlalBua
 4305pYRzW/mKCADvVRqDSvRIHaUNBE1qhpN+J1P+x90skAJ4/+9BRDlNucCGGKL0nXG8EsMYC
 wFlI/OE9qN/zhVWABx0Pn709R1xF6HFPOnBUaDhYpVbqkvNJMC4ivAP5fPPrRD/YlUiIFgTIP
 Ed6gnElkE0FLrAuOiCcfCkzWSeLkJAY1Wp+h2r93x1LIO9iimgmlwxdRGzAXDuWy/LMQk5kW+
 GXiEFpYWMYXpDzF7sz29O54xavdxXBUqrpuIXV+/XiXDW20DssR0STN7dLx7wvtGHmsqo/Gie
 Kaq+/TRE0Kajog65OCER4nQmJNz0Na4FbuutseAvQ2WLnV78jSDN6Egm0kBGjIKLwSyyR9ENI
 aBDjbKy2I/rtWWQ==
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It was currently not possible to match the target address of a neighbor
solicitation or neighbor advertisement against a dynamic set, unlike in
IPv4.

Since they are many ICMPv6 messages with an address at the same offset,
allow filtering on the target address for all icmp types that have one.

While at it, also allow matching the destination address of an ICMPv6
redirect.

Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
---
v2: fix style, RFC -> PATCH
---
 doc/payload-expression.txt        |   8 +-
 include/proto.h                   |   4 +
 src/parser_bison.y                |   3 +
 src/payload.c                     |  82 +++++++++-
 src/proto.c                       |  14 +-
 src/scanner.l                     |   2 +
 tests/py/ip6/icmpv6.t             |  12 ++
 tests/py/ip6/icmpv6.t.json        | 260 ++++++++++++++++++++++++++++++
 tests/py/ip6/icmpv6.t.payload.ip6 |  80 +++++++++
 9 files changed, 458 insertions(+), 7 deletions(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 505cc0aa..c7c267da 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -269,7 +269,7 @@ ip6 nexthdr ipv6-frag
 ICMPV6 HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*icmpv6* {*type* | *code* | *checksum* | *parameter-problem* | *packet-too-big* | *id* | *sequence* | *max-delay*}
+*icmpv6* {*type* | *code* | *checksum* | *parameter-problem* | *packet-too-big* | *id* | *sequence* | *max-delay* | *taddr* | *daddr*}
 
 This expression refers to ICMPv6 header fields. When using it in *inet*,
 *bridge* or *netdev* families, it will cause an implicit dependency on IPv6 to
@@ -304,6 +304,12 @@ integer (16 bit)
 |max-delay|
 maximum response delay of MLD queries|
 integer (16 bit)
+|taddr|
+target address of neighbor solicit/advert, redirect or MLD|
+ipv6_addr
+|daddr|
+destination address of redirect|
+ipv6_addr
 |==============================
 
 TCP HEADER EXPRESSION
diff --git a/include/proto.h b/include/proto.h
index 3a20ff8c..9c98a0b7 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -35,6 +35,8 @@ enum icmp_hdr_field_type {
 	PROTO_ICMP6_PPTR,
 	PROTO_ICMP6_ECHO,
 	PROTO_ICMP6_MGMQ,
+	PROTO_ICMP6_ADDRESS,	/* neighbor solicit/advert, redirect and MLD */
+	PROTO_ICMP6_REDIRECT,
 };
 
 /**
@@ -305,6 +307,8 @@ enum icmp6_hdr_fields {
 	ICMP6HDR_ID,
 	ICMP6HDR_SEQ,
 	ICMP6HDR_MAXDELAY,
+	ICMP6HDR_TADDR,
+	ICMP6HDR_DADDR,
 };
 
 enum ip6_hdr_fields {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index bfd53ab3..c517dc38 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -422,6 +422,7 @@ int nft_lex(void *, void *, void *);
 %token ICMP6			"icmpv6"
 %token PPTR			"param-problem"
 %token MAXDELAY			"max-delay"
+%token TADDR			"taddr"
 
 %token AH			"ah"
 %token RESERVED			"reserved"
@@ -5746,6 +5747,8 @@ icmp6_hdr_field		:	TYPE		close_scope_type	{ $$ = ICMP6HDR_TYPE; }
 			|	ID		{ $$ = ICMP6HDR_ID; }
 			|	SEQUENCE	{ $$ = ICMP6HDR_SEQ; }
 			|	MAXDELAY	{ $$ = ICMP6HDR_MAXDELAY; }
+			|	TADDR		{ $$ = ICMP6HDR_TADDR; }
+			|	DADDR		{ $$ = ICMP6HDR_DADDR; }
 			;
 
 auth_hdr_expr		:	AH	auth_hdr_field	close_scope_ah
diff --git a/src/payload.c b/src/payload.c
index dcd87485..e7d74d8c 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -795,11 +795,40 @@ static uint8_t icmp_dep_to_type(enum icmp_hdr_field_type t)
 	case PROTO_ICMP6_MTU: return ICMP6_PACKET_TOO_BIG;
 	case PROTO_ICMP6_MGMQ: return MLD_LISTENER_QUERY;
 	case PROTO_ICMP6_PPTR: return ICMP6_PARAM_PROB;
+	case PROTO_ICMP6_REDIRECT: return ND_REDIRECT;
+	case PROTO_ICMP6_ADDRESS: return ND_NEIGHBOR_SOLICIT;
 	}
 
 	BUG("Missing icmp type mapping");
 }
 
+static bool icmp_dep_type_match(enum icmp_hdr_field_type t, uint8_t type)
+{
+	switch (t) {
+	case PROTO_ICMP_ECHO:
+		return type == ICMP_ECHO || type == ICMP_ECHOREPLY;
+	case PROTO_ICMP6_ECHO:
+		return type == ICMP6_ECHO_REQUEST || type == ICMP6_ECHO_REPLY;
+	case PROTO_ICMP6_ADDRESS:
+		return type == ND_NEIGHBOR_SOLICIT ||
+		       type == ND_NEIGHBOR_ADVERT ||
+		       type == ND_REDIRECT ||
+		       type == MLD_LISTENER_QUERY ||
+		       type == MLD_LISTENER_REPORT ||
+		       type == MLD_LISTENER_REDUCTION;
+	case PROTO_ICMP_ADDRESS:
+	case PROTO_ICMP_MTU:
+	case PROTO_ICMP6_MTU:
+	case PROTO_ICMP6_MGMQ:
+	case PROTO_ICMP6_PPTR:
+	case PROTO_ICMP6_REDIRECT:
+		return icmp_dep_to_type(t) == type;
+	case PROTO_ICMP_ANY:
+		return true;
+	}
+	BUG("Missing icmp type mapping");
+}
+
 static bool payload_may_dependency_kill_icmp(struct payload_dep_ctx *ctx, struct expr *expr)
 {
 	const struct expr *dep = payload_dependency_get(ctx, expr->payload.base);
@@ -812,6 +841,11 @@ static bool payload_may_dependency_kill_icmp(struct payload_dep_ctx *ctx, struct
 	if (dep->left->payload.desc != expr->payload.desc)
 		return false;
 
+	if (expr->payload.tmpl->icmp_dep == PROTO_ICMP_ECHO ||
+	    expr->payload.tmpl->icmp_dep == PROTO_ICMP6_ECHO ||
+	    expr->payload.tmpl->icmp_dep == PROTO_ICMP6_ADDRESS)
+		return false;
+
 	icmp_type = icmp_dep_to_type(expr->payload.tmpl->icmp_dep);
 
 	return ctx->icmp_type == icmp_type;
@@ -999,7 +1033,8 @@ void payload_expr_complete(struct expr *expr, const struct proto_ctx *ctx)
 			continue;
 
 		if (tmpl->icmp_dep && ctx->th_dep.icmp.type &&
-		    ctx->th_dep.icmp.type != icmp_dep_to_type(tmpl->icmp_dep))
+		    !icmp_dep_type_match(tmpl->icmp_dep,
+					 ctx->th_dep.icmp.type))
 			continue;
 
 		expr->dtype	   = tmpl->dtype;
@@ -1134,7 +1169,8 @@ void payload_expr_expand(struct list_head *list, struct expr *expr,
 			continue;
 
 		if (tmpl->icmp_dep && ctx->th_dep.icmp.type &&
-		     ctx->th_dep.icmp.type != icmp_dep_to_type(tmpl->icmp_dep))
+		    !icmp_dep_type_match(tmpl->icmp_dep,
+					 ctx->th_dep.icmp.type))
 			continue;
 
 		if (tmpl->len <= expr->len) {
@@ -1291,6 +1327,38 @@ __payload_gen_icmp_echo_dependency(struct eval_ctx *ctx, const struct expr *expr
 	return expr_stmt_alloc(&dep->location, dep);
 }
 
+static struct stmt *
+__payload_gen_icmp6_addr_dependency(struct eval_ctx *ctx, const struct expr *expr,
+				    const struct proto_desc *desc)
+{
+	static const uint8_t icmp_addr_types[] = {
+		MLD_LISTENER_QUERY,
+		MLD_LISTENER_REPORT,
+		MLD_LISTENER_REDUCTION,
+		ND_NEIGHBOR_SOLICIT,
+		ND_NEIGHBOR_ADVERT,
+		ND_REDIRECT
+	};
+	struct expr *left, *right, *dep, *set;
+	size_t i;
+
+	left = payload_expr_alloc(&expr->location, desc, desc->protocol_key);
+
+	set = set_expr_alloc(&expr->location, NULL);
+
+	for (i = 0; i < array_size(icmp_addr_types); ++i) {
+		right = constant_expr_alloc(&expr->location, &icmp6_type_type,
+					    BYTEORDER_BIG_ENDIAN, BITS_PER_BYTE,
+					    constant_data_ptr(icmp_addr_types[i],
+							      BITS_PER_BYTE));
+		right = set_elem_expr_alloc(&expr->location, right);
+		compound_expr_add(set, right);
+	}
+
+	dep = relational_expr_alloc(&expr->location, OP_IMPLICIT, left, set);
+	return expr_stmt_alloc(&dep->location, dep);
+}
+
 int payload_gen_icmp_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				struct stmt **res)
 {
@@ -1349,6 +1417,16 @@ int payload_gen_icmp_dependency(struct eval_ctx *ctx, const struct expr *expr,
 							  &icmp6_type_type,
 							  desc);
 		break;
+	case PROTO_ICMP6_ADDRESS:
+		if (icmp_dep_type_match(PROTO_ICMP6_ADDRESS,
+					pctx->th_dep.icmp.type))
+			goto done;
+		type = ND_NEIGHBOR_SOLICIT;
+		if (pctx->th_dep.icmp.type)
+			goto bad_proto;
+		stmt = __payload_gen_icmp6_addr_dependency(ctx, expr, desc);
+		break;
+	case PROTO_ICMP6_REDIRECT:
 	case PROTO_ICMP6_MTU:
 	case PROTO_ICMP6_MGMQ:
 	case PROTO_ICMP6_PPTR:
diff --git a/src/proto.c b/src/proto.c
index b5cb0106..a57460ad 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -439,10 +439,10 @@ const struct datatype icmp_type_type = {
 	.sym_tbl	= &icmp_type_tbl,
 };
 
-#define ICMP46HDR_FIELD(__token, __struct, __member, __dep)			\
+#define ICMP46HDR_FIELD(__token, __dtype, __struct, __member, __dep)		\
 	{									\
 		.token		= (__token),					\
-		.dtype		= &integer_type,				\
+		.dtype		= &__dtype,					\
 		.byteorder	= BYTEORDER_BIG_ENDIAN,				\
 		.offset		= offsetof(__struct, __member) * 8,		\
 		.len		= field_sizeof(__struct, __member) * 8,		\
@@ -450,7 +450,7 @@ const struct datatype icmp_type_type = {
 	}
 
 #define ICMPHDR_FIELD(__token, __member, __dep) \
-	ICMP46HDR_FIELD(__token, struct icmphdr, __member, __dep)
+	ICMP46HDR_FIELD(__token, integer_type, struct icmphdr, __member, __dep)
 
 #define ICMPHDR_TYPE(__name, __type, __member) \
 	HDR_TYPE(__name,  __type, struct icmphdr, __member)
@@ -914,7 +914,7 @@ const struct datatype icmp6_type_type = {
 };
 
 #define ICMP6HDR_FIELD(__token, __member, __dep) \
-	ICMP46HDR_FIELD(__token, struct icmp6_hdr, __member, __dep)
+	ICMP46HDR_FIELD(__token, integer_type, struct icmp6_hdr, __member, __dep)
 #define ICMP6HDR_TYPE(__name, __type, __member) \
 	HDR_TYPE(__name, __type, struct icmp6_hdr, __member)
 
@@ -934,6 +934,12 @@ const struct proto_desc proto_icmp6 = {
 		[ICMP6HDR_ID]		= ICMP6HDR_FIELD("id", icmp6_id, PROTO_ICMP6_ECHO),
 		[ICMP6HDR_SEQ]		= ICMP6HDR_FIELD("sequence", icmp6_seq, PROTO_ICMP6_ECHO),
 		[ICMP6HDR_MAXDELAY]	= ICMP6HDR_FIELD("max-delay", icmp6_maxdelay, PROTO_ICMP6_MGMQ),
+		[ICMP6HDR_TADDR]	= ICMP46HDR_FIELD("taddr", ip6addr_type,
+							  struct nd_neighbor_solicit, nd_ns_target,
+							  PROTO_ICMP6_ADDRESS),
+		[ICMP6HDR_DADDR]	= ICMP46HDR_FIELD("daddr", ip6addr_type,
+							  struct nd_redirect, nd_rd_dst,
+							  PROTO_ICMP6_REDIRECT),
 	},
 };
 
diff --git a/src/scanner.l b/src/scanner.l
index 1aae1ecb..624f21a1 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -588,6 +588,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"param-problem"		{ return PPTR; }
 	"max-delay"		{ return MAXDELAY; }
 	"mtu"			{ return MTU; }
+	"taddr"			{ return TADDR; }
+	"daddr"			{ return DADDR; }
 }
 <SCANSTATE_EXPR_AH,SCANSTATE_EXPR_ESP,SCANSTATE_ICMP,SCANSTATE_TCP>{
 	"sequence"		{ return SEQUENCE; }
diff --git a/tests/py/ip6/icmpv6.t b/tests/py/ip6/icmpv6.t
index 4de6ee23..35dad2be 100644
--- a/tests/py/ip6/icmpv6.t
+++ b/tests/py/ip6/icmpv6.t
@@ -85,3 +85,15 @@ icmpv6 max-delay {33, 55, 67, 88};ok
 icmpv6 max-delay != {33, 55, 67, 88};ok
 
 icmpv6 type parameter-problem icmpv6 code no-route;ok
+
+icmpv6 type mld-listener-query icmpv6 taddr 2001:db8::133;ok
+icmpv6 type nd-neighbor-solicit icmpv6 taddr 2001:db8::133;ok
+icmpv6 type nd-neighbor-advert icmpv6 taddr 2001:db8::133;ok
+icmpv6 taddr 2001:db8::133;ok;icmpv6 type { mld-listener-query, mld-listener-report, mld-listener-done, nd-neighbor-solicit, nd-neighbor-advert, nd-redirect} icmpv6 taddr 2001:db8::133
+
+icmpv6 taddr 2001:db8::133;ok;icmpv6 type { mld-listener-query, mld-listener-report, mld-listener-done, nd-neighbor-solicit, nd-neighbor-advert, nd-redirect} icmpv6 taddr 2001:db8::133
+
+icmpv6 type { mld-listener-query, mld-listener-report, mld-listener-done, nd-neighbor-solicit, nd-neighbor-advert, nd-redirect} icmpv6 taddr 2001:db8::133;ok
+icmpv6 type { nd-neighbor-solicit, nd-neighbor-advert } icmpv6 taddr 2001:db8::133;ok
+icmpv6 daddr 2001:db8::133;ok
+icmpv6 type nd-redirect icmpv6 daddr 2001:db8::133;ok;icmpv6 daddr 2001:db8::133
diff --git a/tests/py/ip6/icmpv6.t.json b/tests/py/ip6/icmpv6.t.json
index 2251be82..224a8e81 100644
--- a/tests/py/ip6/icmpv6.t.json
+++ b/tests/py/ip6/icmpv6.t.json
@@ -1163,3 +1163,263 @@
         }
     }
 ]
+
+# icmpv6 type mld-listener-query icmpv6 taddr 2001:db8::133
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": "mld-listener-query"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "taddr",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": "2001:db8::133"
+        }
+    }
+]
+
+# icmpv6 type nd-neighbor-solicit icmpv6 taddr 2001:db8::133
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": "nd-neighbor-solicit"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "taddr",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": "2001:db8::133"
+        }
+    }
+]
+
+# icmpv6 type nd-neighbor-advert icmpv6 taddr 2001:db8::133
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": "nd-neighbor-advert"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "taddr",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": "2001:db8::133"
+        }
+    }
+]
+
+# icmpv6 taddr 2001:db8::133
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "mld-listener-query",
+                    "mld-listener-report",
+                    "mld-listener-done",
+                    "nd-neighbor-solicit",
+                    "nd-neighbor-advert",
+                    "nd-redirect"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "taddr",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": "2001:db8::133"
+        }
+    }
+]
+
+# icmpv6 taddr 2001:db8::133
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "mld-listener-query",
+                    "mld-listener-report",
+                    "mld-listener-done",
+                    "nd-neighbor-solicit",
+                    "nd-neighbor-advert",
+                    "nd-redirect"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "taddr",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": "2001:db8::133"
+        }
+    }
+]
+
+# icmpv6 type { mld-listener-query, mld-listener-report, mld-listener-done, nd-neighbor-solicit, nd-neighbor-advert, nd-redirect} icmpv6 taddr 2001:db8::133
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "mld-listener-query",
+                    "mld-listener-report",
+                    "mld-listener-done",
+                    "nd-neighbor-solicit",
+                    "nd-neighbor-advert",
+                    "nd-redirect"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "taddr",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": "2001:db8::133"
+        }
+    }
+]
+
+# icmpv6 type { nd-neighbor-solicit, nd-neighbor-advert } icmpv6 taddr 2001:db8::133
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "nd-neighbor-solicit",
+                    "nd-neighbor-advert"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "taddr",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": "2001:db8::133"
+        }
+    }
+]
+
+# icmpv6 daddr 2001:db8::133
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "daddr",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": "2001:db8::133"
+        }
+    }
+]
+
+# icmpv6 type nd-redirect icmpv6 daddr 2001:db8::133
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "daddr",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": "2001:db8::133"
+        }
+    }
+]
diff --git a/tests/py/ip6/icmpv6.t.payload.ip6 b/tests/py/ip6/icmpv6.t.payload.ip6
index 0e96be2d..fcaf4812 100644
--- a/tests/py/ip6/icmpv6.t.payload.ip6
+++ b/tests/py/ip6/icmpv6.t.payload.ip6
@@ -561,3 +561,83 @@ ip6
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000004 ]
 
+# icmpv6 type mld-listener-query icmpv6 taddr 2001:db8::133
+ip6 test-ip6 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000082 ]
+  [ payload load 16b @ transport header + 8 => reg 1 ]
+  [ cmp eq reg 1 0xb80d0120 0x00000000 0x00000000 0x33010000 ]
+
+# icmpv6 type nd-neighbor-solicit icmpv6 taddr 2001:db8::133
+ip6 test-ip6 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000087 ]
+  [ payload load 16b @ transport header + 8 => reg 1 ]
+  [ cmp eq reg 1 0xb80d0120 0x00000000 0x00000000 0x33010000 ]
+
+# icmpv6 type nd-neighbor-advert icmpv6 taddr 2001:db8::133
+ip6 test-ip6 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000088 ]
+  [ payload load 16b @ transport header + 8 => reg 1 ]
+  [ cmp eq reg 1 0xb80d0120 0x00000000 0x00000000 0x33010000 ]
+
+# icmpv6 taddr 2001:db8::133
+__set%d test-ip6 3 size 6
+__set%d test-ip6 0
+	element 00000082  : 0 [end]	element 00000083  : 0 [end]	element 00000084  : 0 [end]	element 00000087  : 0 [end]	element 00000088  : 0 [end]	element 00000089  : 0 [end]
+ip6 test-ip6 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+  [ payload load 16b @ transport header + 8 => reg 1 ]
+  [ cmp eq reg 1 0xb80d0120 0x00000000 0x00000000 0x33010000 ]
+
+# icmpv6 type { mld-listener-query, mld-listener-report, mld-listener-done, nd-neighbor-solicit, nd-neighbor-advert, nd-redirect} icmpv6 taddr 2001:db8::133
+__set%d test-ip6 3 size 6
+__set%d test-ip6 0
+	element 00000082  : 0 [end]	element 00000083  : 0 [end]	element 00000084  : 0 [end]	element 00000087  : 0 [end]	element 00000088  : 0 [end]	element 00000089  : 0 [end]
+ip6 test-ip6 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+  [ payload load 16b @ transport header + 8 => reg 1 ]
+  [ cmp eq reg 1 0xb80d0120 0x00000000 0x00000000 0x33010000 ]
+
+# icmpv6 type { nd-neighbor-solicit, nd-neighbor-advert } icmpv6 taddr 2001:db8::133
+__set%d test-ip6 3 size 2
+__set%d test-ip6 0
+	element 00000087  : 0 [end]	element 00000088  : 0 [end]
+ip6 test-ip6 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+  [ payload load 16b @ transport header + 8 => reg 1 ]
+  [ cmp eq reg 1 0xb80d0120 0x00000000 0x00000000 0x33010000 ]
+
+# icmpv6 daddr 2001:db8::133
+ip6 test-ip6 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000089 ]
+  [ payload load 16b @ transport header + 24 => reg 1 ]
+  [ cmp eq reg 1 0xb80d0120 0x00000000 0x00000000 0x33010000 ]
+
+# icmpv6 type nd-redirect icmpv6 daddr 2001:db8::133
+ip6 test-ip6 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000089 ]
+  [ payload load 16b @ transport header + 24 => reg 1 ]
+  [ cmp eq reg 1 0xb80d0120 0x00000000 0x00000000 0x33010000 ]
-- 
2.40.1

