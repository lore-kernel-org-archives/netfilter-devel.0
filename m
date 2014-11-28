From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] datatype: relax datatype check in integer_type_parse()
Date: Fri, 28 Nov 2014 21:10:07 +0100
Message-ID: <1417205407-31166-2-git-send-email-pablo@netfilter.org>
References: <1417205407-31166-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51627 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbaK1UIB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Nov 2014 15:08:01 -0500
In-Reply-To: <1417205407-31166-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Otherwise parsing with basetypes doesn't work. Now nft displays
an error when the symbolic constant is not correct:

 <cmdline>:1:29-31: Error: Could not parse conntrack state
 add rule test test ct state xxx accept
                             ^^^

I also needed to revert the logic in ethertype_parse and pkttype_type_parse
so we first look up for the symbol in the table, otherwise default to the
basetype. Otherwise, the regression test were reporting a breakage in the
ether type / pkttype.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/datatype.c              |    2 --
 src/meta.c                  |   16 ++--------------
 src/proto.c                 |    4 ++--
 tests/regression/any/ct.t   |    3 +++
 tests/regression/any/meta.t |    1 +
 5 files changed, 8 insertions(+), 18 deletions(-)

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
index 61dc5cf..de83391 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -316,26 +316,14 @@ static struct error_record *pkttype_type_parse(const struct expr *sym,
 					       struct expr **res)
 {
 	struct error_record *erec;
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
 
 	*res = NULL;
-	erec = sym->dtype->basetype->parse(sym, res);
+	erec = symbolic_constant_parse(sym, &pkttype_type_tbl, res);
 	if (erec != NULL)
 		return erec;
 	if (*res)
 		return NULL;
-
-	return symbolic_constant_parse(sym, &pkttype_type_tbl, res);
+	return sym->dtype->basetype->parse(sym, res);
 }
 
 static const struct datatype pkttype_type = {
diff --git a/src/proto.c b/src/proto.c
index 6eb4bb2..94ecc58 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -757,12 +757,12 @@ static struct error_record *ethertype_parse(const struct expr *sym,
 	struct error_record *erec;
 
 	*res = NULL;
-	erec = sym->dtype->basetype->parse(sym, res);
+	erec = symbolic_constant_parse(sym, &ethertype_tbl, res);
 	if (erec != NULL)
 		return erec;
 	if (*res)
 		return NULL;
-	return symbolic_constant_parse(sym, &ethertype_tbl, res);
+	return sym->dtype->basetype->parse(sym, res);
 }
 
 static void ethertype_print(const struct expr *expr)
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
diff --git a/tests/regression/any/meta.t b/tests/regression/any/meta.t
index b3f91c9..3acf953 100644
--- a/tests/regression/any/meta.t
+++ b/tests/regression/any/meta.t
@@ -150,6 +150,7 @@ meta pkttype != unicast;ok;pkttype != unicast
 meta pkttype != multicast;ok;pkttype != multicast
 meta pkttype broadcastttt;fail
 -meta pkttype { broadcast, multicast} accept;ok
+meta pkttype xxx;fail
 
 meta cpu 1;ok;cpu 1
 meta cpu != 1;ok;cpu != 1
-- 
1.7.10.4

