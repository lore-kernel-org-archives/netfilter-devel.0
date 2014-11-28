From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2 v2] datatype: relax datatype check in integer_type_parse()
Date: Fri, 28 Nov 2014 21:43:07 +0100
Message-ID: <1417207387-12560-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54300 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaK1Uk6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Nov 2014 15:40:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Otherwise parsing with basetypes doesn't work. Now nft displays
an error when the symbolic constant is not correct:

 <cmdline>:1:29-31: Error: Could not parse conntrack state
 add rule test test ct state xxx accept
                             ^^^

Use .sym_tbl instead and default on the symbol_constant_parse()
function. An alternative can be to invert the logic in ethertype_parse
and pkttype_type_parse. Thus, we first look up for the symbol in the
table, otherwise default to the basetype. Otherwise, the regression
test were reporting a breakage in the ether type / pkttype.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Smaller than v1, use .sym_tbl instead, remove pkttype_type_parse() and
    ethertype_parse().

 src/datatype.c            |    2 --
 src/meta.c                |   28 +---------------------------
 src/proto.c               |   16 +---------------
 tests/regression/any/ct.t |    3 +++
 4 files changed, 5 insertions(+), 44 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 7c9c3d4..1ace3fa 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -280,8 +280,6 @@ static struct error_record *integer_type_parse(const struct expr *sym,
 	if (gmp_sscanf(sym->identifier, "%Zu%n", v, &len) != 1 ||
 	    (int)strlen(sym->identifier) != len) {
 		mpz_clear(v);
-		if (sym->dtype != &integer_type)
-			return NULL;
 		return error(&sym->location, "Could not parse %s",
 			     sym->dtype->desc);
 	}
diff --git a/src/meta.c b/src/meta.c
index 61dc5cf..9c1ea58 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -312,32 +312,6 @@ static void pkttype_type_print(const struct expr *expr)
 	return symbolic_constant_print(&pkttype_type_tbl, expr);
 }
 
-static struct error_record *pkttype_type_parse(const struct expr *sym,
-					       struct expr **res)
-{
-	struct error_record *erec;
-	const struct symbolic_constant *s;
-
-	for (s = pkttype_type_tbl.symbols; s->identifier != NULL; s++) {
-		if (!strcmp(sym->identifier, s->identifier)) {
-			*res = constant_expr_alloc(&sym->location, sym->dtype,
-						   sym->dtype->byteorder,
-						   sym->dtype->size,
-						   &s->value);
-			return NULL;
-		}
-	}
-
-	*res = NULL;
-	erec = sym->dtype->basetype->parse(sym, res);
-	if (erec != NULL)
-		return erec;
-	if (*res)
-		return NULL;
-
-	return symbolic_constant_parse(sym, &pkttype_type_tbl, res);
-}
-
 static const struct datatype pkttype_type = {
 	.type		= TYPE_PKTTYPE,
 	.name		= "pkt_type",
@@ -346,7 +320,7 @@ static const struct datatype pkttype_type = {
 	.size		= BITS_PER_BYTE,
 	.basetype	= &integer_type,
 	.print		= pkttype_type_print,
-	.parse		= pkttype_type_parse,
+	.sym_tbl	= &pkttype_type_tbl,
 };
 
 static struct symbol_table *devgroup_tbl;
diff --git a/src/proto.c b/src/proto.c
index 6eb4bb2..7dc7b3e 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -751,20 +751,6 @@ static const struct symbol_table ethertype_tbl = {
 	},
 };
 
-static struct error_record *ethertype_parse(const struct expr *sym,
-					    struct expr **res)
-{
-	struct error_record *erec;
-
-	*res = NULL;
-	erec = sym->dtype->basetype->parse(sym, res);
-	if (erec != NULL)
-		return erec;
-	if (*res)
-		return NULL;
-	return symbolic_constant_parse(sym, &ethertype_tbl, res);
-}
-
 static void ethertype_print(const struct expr *expr)
 {
 	return symbolic_constant_print(&ethertype_tbl, expr);
@@ -779,7 +765,7 @@ const struct datatype ethertype_type = {
 	.basetype	= &integer_type,
 	.basefmt	= "0x%.4Zx",
 	.print		= ethertype_print,
-	.parse		= ethertype_parse,
+	.sym_tbl	= &ethertype_tbl,
 };
 
 #define ETHHDR_TEMPLATE(__name, __dtype, __member) \
diff --git a/tests/regression/any/ct.t b/tests/regression/any/ct.t
index 79674ee..09f72ed 100644
--- a/tests/regression/any/ct.t
+++ b/tests/regression/any/ct.t
@@ -14,6 +14,7 @@ ct state {new,established, related, untracked};ok
 ct state invalid drop;ok
 ct state established accept;ok
 ct state 8;ok;ct state new
+ct state xxx;fail
 
 ct direction original;ok
 ct direction != original;ok
@@ -21,12 +22,14 @@ ct direction reply;ok
 ct direction != reply;ok
 ct direction {reply, original};ok
 - ct direction != {reply, original};ok
+ct direction xxx;fail
 
 ct status expected;ok
 ct status != expected;ok
 ct status seen-reply;ok
 ct status != seen-reply;ok
 ct status {expected, seen-reply, assured, confirmed, dying};ok
+ct status xxx;fail
 
 # SYMBOL("snat", IPS_SRC_NAT)
 # SYMBOL("dnat", IPS_DST_NAT)
-- 
1.7.10.4

