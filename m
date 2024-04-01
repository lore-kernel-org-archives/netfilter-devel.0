Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 576A833982
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Apr 2024 22:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712012257; cv=none; b=g3+XH/t2lNF5BK8nFd1q21otuEnOAFOSk7Y7wvrJ57PTYglu7EH6SLfN9XUJOwATIJjQ4nw2K0ltJn0bFsY6So1n4O1cF60yECnGE7HbDnkv/ZAz1xY6pFNDQnAu29QILiSELrcAiS7XAXy+Cj5XdbT+5yg1iZHUXVy7T/cYXVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712012257; c=relaxed/simple;
	bh=r3XZSCtpirzlkp5AjZc6oTMBny+zUB87p0uBmpxBMEo=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=LSMb0IM8bWC+9RIVi3WUQ98SErRZLR2stXEhcDSWRcCYWBTFdDn7VlVSGa/N1hEeI9tPa3SqfRFqZxvdLklQiVENp5mwo+3l1pYyPfSGv1CmdWPwWLwt8E/ArF5E7qJnpFzQ2aaCynxAm0CemfqNRwOs3P8x7UI3NcNPr6TZ4N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: disentangle ICMP code types
Date: Tue,  2 Apr 2024 00:57:26 +0200
Message-Id: <20240401225726.1106334-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, ICMP{v4,v6,inet} code datatypes only describe those that are
supported by the reject statement, but they can also be used for icmp
code matching. Moreover, ICMP code types go hand-to-hand with ICMP
types, that is, ICMP code symbols depend on the ICMP type.

Thus, the output of:

  nft describe icmp_code

look confusing because that only displays the values that are supported
by the reject statement.

Disentangle this by adding internal datatypes for the reject statement
to handle the ICMP code symbol conversion to value as well as ruleset
listing.

The existing icmp_code, icmpv6_code and icmpx_code remain in place. For
backward compatibility, a parser function is defined in case an existing
ruleset relies on these symbols.

As for the manpage, move existing ICMP code tables from the DATA TYPES
section to the REJECT STATEMENT section, where this really belongs to.
But the icmp_code and icmpv6_code table stubs remain in the DATA TYPES
section because that describe that this is an 8-bit integer field.

After this patch:

 # nft describe icmp_code
 datatype icmp_code (icmp code) (basetype integer), 8 bits
 # nft describe icmpv6_code
 datatype icmpv6_code (icmpv6 code) (basetype integer), 8 bits
 # nft describe icmpx_code
 datatype icmpx_code (icmpx code) (basetype integer), 8 bits

do not display the symbol table of the reject statement anymore.

icmpx_code_type is not used anymore, but keep it in place for backward
compatibility reasons.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/data-types.txt        | 68 -----------------------------------
 doc/statements.txt        | 74 ++++++++++++++++++++++++++++++---------
 include/datatype.h        |  5 +++
 src/datatype.c            | 71 +++++++++++++++++++++++++++++++++----
 src/netlink_delinearize.c | 10 +++---
 src/parser_bison.y        | 12 +++----
 src/parser_json.c         |  6 ++--
 tests/py/ip/icmp.t        |  6 ++--
 tests/py/ip6/icmpv6.t     |  8 ++---
 9 files changed, 147 insertions(+), 113 deletions(-)

diff --git a/doc/data-types.txt b/doc/data-types.txt
index e5ee91a97386..6c0e2f9420fe 100644
--- a/doc/data-types.txt
+++ b/doc/data-types.txt
@@ -242,28 +242,6 @@ integer
 
 The ICMP Code type is used to conveniently specify the ICMP header's code field.
 
-.Keywords may be used when specifying the ICMP code
-[options="header"]
-|==================
-|Keyword | Value
-|net-unreachable |
-0
-|host-unreachable |
-1
-|prot-unreachable|
-2
-|port-unreachable|
-3
-|frag-needed|
-4
-|net-prohibited|
-9
-|host-prohibited|
-10
-|admin-prohibited|
-13
-|===================
-
 ICMPV6 TYPE TYPE
 ~~~~~~~~~~~~~~~~
 [options="header"]
@@ -340,52 +318,6 @@ integer
 
 The ICMPv6 Code type is used to conveniently specify the ICMPv6 header's code field.
 
-.keywords may be used when specifying the ICMPv6 code
-[options="header"]
-|==================
-|Keyword |Value
-|no-route|
-0
-|admin-prohibited|
-1
-|addr-unreachable|
-3
-|port-unreachable|
-4
-|policy-fail|
-5
-|reject-route|
-6
-|==================
-
-ICMPVX CODE TYPE
-~~~~~~~~~~~~~~~~
-[options="header"]
-|==================
-|Name | Keyword | Size | Base type
-|ICMPvX Code |
-icmpx_code |
-8 bit |
-integer
-|===================
-
-The ICMPvX Code type abstraction is a set of values which overlap between ICMP
-and ICMPv6 Code types to be used from the inet family.
-
-.keywords may be used when specifying the ICMPvX code
-[options="header"]
-|==================
-|Keyword |Value
-|no-route|
-0
-|port-unreachable|
-1
-|host-unreachable|
-2
-|admin-prohibited|
-3
-|=================
-
 CONNTRACK TYPES
 ~~~~~~~~~~~~~~~
 
diff --git a/doc/statements.txt b/doc/statements.txt
index ae6442b03e46..39b31fd2c825 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -171,9 +171,9 @@ REJECT STATEMENT
 ____
 *reject* [ *with* 'REJECT_WITH' ]
 
-'REJECT_WITH' := *icmp* 'icmp_code' |
-                 *icmpv6* 'icmpv6_code' |
-                 *icmpx* 'icmpx_code' |
+'REJECT_WITH' := *icmp* 'icmp_reject_code' |
+                 *icmpv6* 'icmpv6_reject_code' |
+                 *icmpx* 'icmpx_reject_code' |
                  *tcp reset*
 ____
 
@@ -184,24 +184,64 @@ using the *prerouting*, *input*,
 *forward* or *output* hooks, and user-defined chains which are only called from
 those chains.
 
-.different ICMP reject variants are meant for use in different table families
+.Keywords may be used to reject when specifying the ICMP code
 [options="header"]
 |==================
-|Variant |Family | Type
-|icmp|
-ip|
-icmp_code
-|icmpv6|
-ip6|
-icmpv6_code
-|icmpx|
-inet|
-icmpx_code
+|Keyword | Value
+|net-unreachable |
+0
+|host-unreachable |
+1
+|prot-unreachable|
+2
+|port-unreachable|
+3
+|frag-needed|
+4
+|net-prohibited|
+9
+|host-prohibited|
+10
+|admin-prohibited|
+13
+|===================
+
+.keywords may be used to reject when specifying the ICMPv6 code
+[options="header"]
 |==================
+|Keyword |Value
+|no-route|
+0
+|admin-prohibited|
+1
+|addr-unreachable|
+3
+|port-unreachable|
+4
+|policy-fail|
+5
+|reject-route|
+6
+|==================
+
+The ICMPvX Code type abstraction is a set of values which overlap between ICMP
+and ICMPv6 Code types to be used from the inet family.
+
+.keywords may be used when specifying the ICMPvX code
+[options="header"]
+|==================
+|Keyword |Value
+|no-route|
+0
+|port-unreachable|
+1
+|host-unreachable|
+2
+|admin-prohibited|
+3
+|=================
 
-For a description of the different types and a list of supported keywords refer
-to DATA TYPES section above. The common default reject value is
-*port-unreachable*. +
+The common default ICMP code to reject is *port-unreachable*.
 
 Note that in bridge family, reject statement is only allowed in base chains
 which hook into input or prerouting.
diff --git a/include/datatype.h b/include/datatype.h
index c4d6282d6f59..d4b4737cc9ae 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -283,6 +283,11 @@ extern const struct datatype priority_type;
 extern const struct datatype policy_type;
 extern const struct datatype cgroupv2_type;
 
+/* private datatypes for reject statement. */
+extern const struct datatype reject_icmp_code_type;
+extern const struct datatype reject_icmpv6_code_type;
+extern const struct datatype reject_icmpx_code_type;
+
 void inet_service_type_print(const struct expr *expr, struct output_ctx *octx);
 
 extern const struct datatype *concat_type_alloc(uint32_t type);
diff --git a/src/datatype.c b/src/datatype.c
index b368ea9125fc..d398a9c8c618 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1017,6 +1017,7 @@ const struct datatype mark_type = {
 	.parse		= mark_type_parse,
 };
 
+/* symbol table for private datatypes for reject statement. */
 static const struct symbol_table icmp_code_tbl = {
 	.base		= BASE_DECIMAL,
 	.symbols	= {
@@ -1032,16 +1033,17 @@ static const struct symbol_table icmp_code_tbl = {
 	},
 };
 
-const struct datatype icmp_code_type = {
-	.type		= TYPE_ICMP_CODE,
+/* private datatype for reject statement. */
+const struct datatype reject_icmp_code_type = {
 	.name		= "icmp_code",
-	.desc		= "icmp code",
+	.desc		= "reject icmp code",
 	.size		= BITS_PER_BYTE,
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.basetype	= &integer_type,
 	.sym_tbl	= &icmp_code_tbl,
 };
 
+/* symbol table for private datatypes for reject statement. */
 static const struct symbol_table icmpv6_code_tbl = {
 	.base		= BASE_DECIMAL,
 	.symbols	= {
@@ -1055,16 +1057,17 @@ static const struct symbol_table icmpv6_code_tbl = {
 	},
 };
 
-const struct datatype icmpv6_code_type = {
-	.type		= TYPE_ICMPV6_CODE,
+/* private datatype for reject statement. */
+const struct datatype reject_icmpv6_code_type = {
 	.name		= "icmpv6_code",
-	.desc		= "icmpv6 code",
+	.desc		= "reject icmpv6 code",
 	.size		= BITS_PER_BYTE,
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.basetype	= &integer_type,
 	.sym_tbl	= &icmpv6_code_tbl,
 };
 
+/* symbol table for private datatypes for reject statement. */
 static const struct symbol_table icmpx_code_tbl = {
 	.base		= BASE_DECIMAL,
 	.symbols	= {
@@ -1076,6 +1079,60 @@ static const struct symbol_table icmpx_code_tbl = {
 	},
 };
 
+/* private datatype for reject statement. */
+const struct datatype reject_icmpx_code_type = {
+	.name		= "icmpx_code",
+	.desc		= "reject icmpx code",
+	.size		= BITS_PER_BYTE,
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.basetype	= &integer_type,
+	.sym_tbl	= &icmpx_code_tbl,
+};
+
+/* Backward compatible parser for the reject statement. */
+static struct error_record *icmp_code_parse(struct parse_ctx *ctx,
+					    const struct expr *sym,
+					    struct expr **res)
+{
+	return symbolic_constant_parse(ctx, sym, &icmp_code_tbl, res);
+}
+
+const struct datatype icmp_code_type = {
+	.type		= TYPE_ICMP_CODE,
+	.name		= "icmp_code",
+	.desc		= "icmp code",
+	.size		= BITS_PER_BYTE,
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.basetype	= &integer_type,
+	.parse		= icmp_code_parse,
+};
+
+/* Backward compatible parser for the reject statement. */
+static struct error_record *icmpv6_code_parse(struct parse_ctx *ctx,
+					      const struct expr *sym,
+					      struct expr **res)
+{
+	return symbolic_constant_parse(ctx, sym, &icmpv6_code_tbl, res);
+}
+
+const struct datatype icmpv6_code_type = {
+	.type		= TYPE_ICMPV6_CODE,
+	.name		= "icmpv6_code",
+	.desc		= "icmpv6 code",
+	.size		= BITS_PER_BYTE,
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.basetype	= &integer_type,
+	.parse		= icmpv6_code_parse,
+};
+
+/* Backward compatible parser for the reject statement. */
+static struct error_record *icmpx_code_parse(struct parse_ctx *ctx,
+					     const struct expr *sym,
+					     struct expr **res)
+{
+	return symbolic_constant_parse(ctx, sym, &icmpx_code_tbl, res);
+}
+
 const struct datatype icmpx_code_type = {
 	.type		= TYPE_ICMPX_CODE,
 	.name		= "icmpx_code",
@@ -1083,7 +1140,7 @@ const struct datatype icmpx_code_type = {
 	.size		= BITS_PER_BYTE,
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.basetype	= &integer_type,
-	.sym_tbl	= &icmpx_code_tbl,
+	.parse		= icmpx_code_parse,
 };
 
 void time_print(uint64_t ms, struct output_ctx *octx)
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 24dfb3116eab..da9f7a91e4b3 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2948,7 +2948,7 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 	switch (dl->pctx.family) {
 	case NFPROTO_IPV4:
 		stmt->reject.family = dl->pctx.family;
-		datatype_set(stmt->reject.expr, &icmp_code_type);
+		datatype_set(stmt->reject.expr, &reject_icmp_code_type);
 		if (stmt->reject.type == NFT_REJECT_TCP_RST &&
 		    payload_dependency_exists(&dl->pdctx,
 					      PROTO_BASE_TRANSPORT_HDR))
@@ -2957,7 +2957,7 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 		break;
 	case NFPROTO_IPV6:
 		stmt->reject.family = dl->pctx.family;
-		datatype_set(stmt->reject.expr, &icmpv6_code_type);
+		datatype_set(stmt->reject.expr, &reject_icmpv6_code_type);
 		if (stmt->reject.type == NFT_REJECT_TCP_RST &&
 		    payload_dependency_exists(&dl->pdctx,
 					      PROTO_BASE_TRANSPORT_HDR))
@@ -2968,7 +2968,7 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 	case NFPROTO_BRIDGE:
 	case NFPROTO_NETDEV:
 		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH) {
-			datatype_set(stmt->reject.expr, &icmpx_code_type);
+			datatype_set(stmt->reject.expr, &reject_icmpx_code_type);
 			break;
 		}
 
@@ -2984,12 +2984,12 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 		case NFPROTO_IPV4:			/* INET */
 		case __constant_htons(ETH_P_IP):	/* BRIDGE, NETDEV */
 			stmt->reject.family = NFPROTO_IPV4;
-			datatype_set(stmt->reject.expr, &icmp_code_type);
+			datatype_set(stmt->reject.expr, &reject_icmp_code_type);
 			break;
 		case NFPROTO_IPV6:			/* INET */
 		case __constant_htons(ETH_P_IPV6):	/* BRIDGE, NETDEV */
 			stmt->reject.family = NFPROTO_IPV6;
-			datatype_set(stmt->reject.expr, &icmpv6_code_type);
+			datatype_set(stmt->reject.expr, &reject_icmpv6_code_type);
 			break;
 		default:
 			break;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index bdb73911759c..61bed761b0a9 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3740,40 +3740,40 @@ reject_opts		:       /* empty */
 				$<stmt>0->reject.family = NFPROTO_IPV4;
 				$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
 				$<stmt>0->reject.expr = $4;
-				datatype_set($<stmt>0->reject.expr, &icmp_code_type);
+				datatype_set($<stmt>0->reject.expr, &reject_icmp_code_type);
 			}
 			|	WITH	ICMP	reject_with_expr
 			{
 				$<stmt>0->reject.family = NFPROTO_IPV4;
 				$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
 				$<stmt>0->reject.expr = $3;
-				datatype_set($<stmt>0->reject.expr, &icmp_code_type);
+				datatype_set($<stmt>0->reject.expr, &reject_icmp_code_type);
 			}
 			|	WITH	ICMP6	TYPE	reject_with_expr close_scope_type close_scope_icmp
 			{
 				$<stmt>0->reject.family = NFPROTO_IPV6;
 				$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
 				$<stmt>0->reject.expr = $4;
-				datatype_set($<stmt>0->reject.expr, &icmpv6_code_type);
+				datatype_set($<stmt>0->reject.expr, &reject_icmpv6_code_type);
 			}
 			|	WITH	ICMP6	reject_with_expr
 			{
 				$<stmt>0->reject.family = NFPROTO_IPV6;
 				$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
 				$<stmt>0->reject.expr = $3;
-				datatype_set($<stmt>0->reject.expr, &icmpv6_code_type);
+				datatype_set($<stmt>0->reject.expr, &reject_icmpv6_code_type);
 			}
 			|	WITH	ICMPX	TYPE	reject_with_expr close_scope_type
 			{
 				$<stmt>0->reject.type = NFT_REJECT_ICMPX_UNREACH;
 				$<stmt>0->reject.expr = $4;
-				datatype_set($<stmt>0->reject.expr, &icmpx_code_type);
+				datatype_set($<stmt>0->reject.expr, &reject_icmpx_code_type);
 			}
 			|	WITH	ICMPX	reject_with_expr
 			{
 				$<stmt>0->reject.type = NFT_REJECT_ICMPX_UNREACH;
 				$<stmt>0->reject.expr = $3;
-				datatype_set($<stmt>0->reject.expr, &icmpx_code_type);
+				datatype_set($<stmt>0->reject.expr, &reject_icmpx_code_type);
 			}
 			|	WITH	TCP	close_scope_tcp RESET close_scope_reset
 			{
diff --git a/src/parser_json.c b/src/parser_json.c
index 4fc0479cf497..efe494949460 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2331,17 +2331,17 @@ static struct stmt *json_parse_reject_stmt(struct json_ctx *ctx,
 			stmt->reject.icmp_code = 0;
 		} else if (!strcmp(type, "icmpx")) {
 			stmt->reject.type = NFT_REJECT_ICMPX_UNREACH;
-			dtype = &icmpx_code_type;
+			dtype = &reject_icmpx_code_type;
 			stmt->reject.icmp_code = 0;
 		} else if (!strcmp(type, "icmp")) {
 			stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
 			stmt->reject.family = NFPROTO_IPV4;
-			dtype = &icmp_code_type;
+			dtype = &reject_icmp_code_type;
 			stmt->reject.icmp_code = 0;
 		} else if (!strcmp(type, "icmpv6")) {
 			stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
 			stmt->reject.family = NFPROTO_IPV6;
-			dtype = &icmpv6_code_type;
+			dtype = &reject_icmpv6_code_type;
 			stmt->reject.icmp_code = 0;
 		}
 	}
diff --git a/tests/py/ip/icmp.t b/tests/py/ip/icmp.t
index 7ddf8b38a538..4b8049d78b7a 100644
--- a/tests/py/ip/icmp.t
+++ b/tests/py/ip/icmp.t
@@ -26,8 +26,8 @@ icmp code 111 accept;ok
 icmp code != 111 accept;ok
 icmp code 33-55;ok
 icmp code != 33-55;ok
-icmp code { 2, 4, 54, 33, 56};ok;icmp code { prot-unreachable, frag-needed, 33, 54, 56}
-icmp code != { prot-unreachable, frag-needed, 33, 54, 56};ok
+icmp code { 2, 4, 54, 33, 56};ok
+icmp code != { 2, 4, 33, 54, 56};ok
 
 icmp checksum 12343 accept;ok
 icmp checksum != 12343 accept;ok
@@ -73,5 +73,5 @@ icmp gateway != { 33, 55, 67, 88};ok
 icmp gateway != 34;ok
 icmp gateway != { 333, 334};ok
 
-icmp code 1 icmp type 2;ok;icmp type 2 icmp code host-unreachable
+icmp code 1 icmp type 2;ok;icmp type 2 icmp code 1
 icmp code != 1 icmp type 2 icmp mtu 5;fail
diff --git a/tests/py/ip6/icmpv6.t b/tests/py/ip6/icmpv6.t
index 35dad2be54a4..b2cf6f70fbd1 100644
--- a/tests/py/ip6/icmpv6.t
+++ b/tests/py/ip6/icmpv6.t
@@ -28,10 +28,10 @@ icmpv6 type {router-renumbering, mld-listener-done, time-exceeded, nd-router-sol
 icmpv6 type {mld-listener-query, time-exceeded, nd-router-advert} accept;ok
 icmpv6 type != {mld-listener-query, time-exceeded, nd-router-advert} accept;ok
 
-icmpv6 code 4;ok;icmpv6 code port-unreachable
+icmpv6 code 4;ok
 icmpv6 code 3-66;ok
-icmpv6 code {5, 6, 7} accept;ok;icmpv6 code {policy-fail, reject-route, 7} accept
-icmpv6 code != {policy-fail, reject-route, 7} accept;ok
+icmpv6 code {5, 6, 7} accept;ok
+icmpv6 code != {5, 6, 7} accept;ok
 
 icmpv6 checksum 2222 log;ok
 icmpv6 checksum != 2222 log;ok
@@ -84,7 +84,7 @@ icmpv6 max-delay != 33-45;ok
 icmpv6 max-delay {33, 55, 67, 88};ok
 icmpv6 max-delay != {33, 55, 67, 88};ok
 
-icmpv6 type parameter-problem icmpv6 code no-route;ok
+icmpv6 type parameter-problem icmpv6 code 0;ok
 
 icmpv6 type mld-listener-query icmpv6 taddr 2001:db8::133;ok
 icmpv6 type nd-neighbor-solicit icmpv6 taddr 2001:db8::133;ok
-- 
2.30.2

