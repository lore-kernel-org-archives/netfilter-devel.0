From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2 v2] datatype: fix crash when using basetype instead of symbolic constants
Date: Fri, 28 Nov 2014 21:10:06 +0100
Message-ID: <1417205407-31166-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51628 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbaK1UIB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Nov 2014 15:08:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following example:

 # nft add rule filter input ct state 8 accept
 Segmentation fault

leads to a crash because we have the following datatype relation:

 ct_state -> bitmask -> integer

The bitmask, which is an intermediate basetype, has no parse()
function, this leads to a crash in symbolic_constant_parse().

Patrick suggested to walk down the chain until we find a parser
function.

Reported-by: leroy christophe <christophe.leroy@c-s.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/datatype.c            |   33 ++++++++++++++++++++-------------
 tests/regression/any/ct.t |    1 +
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 5f976aa..7c9c3d4 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -125,21 +125,28 @@ struct error_record *symbolic_constant_parse(const struct expr *sym,
 			break;
 	}
 
-	dtype = sym->dtype;
-	if (s->identifier == NULL) {
-		*res = NULL;
-		erec = sym->dtype->basetype->parse(sym, res);
-		if (erec != NULL)
-			return erec;
-		if (*res)
-			return NULL;
+	if (s->identifier != NULL)
+		goto out;
 
-		return error(&sym->location, "Could not parse %s", dtype->desc);
-	}
+	dtype = sym->dtype;
+	*res = NULL;
+	do {
+		if (dtype->basetype->parse) {
+			erec = dtype->basetype->parse(sym, res);
+			if (erec != NULL)
+				return erec;
+			if (*res)
+				return NULL;
+			goto out;
+		}
+	} while ((dtype = dtype->basetype));
 
-	*res = constant_expr_alloc(&sym->location, dtype,
-				   dtype->byteorder, dtype->size,
-				   constant_data_ptr(s->value, dtype->size));
+	return error(&sym->location, "Could not parse %s", sym->dtype->desc);
+out:
+	*res = constant_expr_alloc(&sym->location, sym->dtype,
+				   sym->dtype->byteorder, sym->dtype->size,
+				   constant_data_ptr(s->value,
+				   sym->dtype->size));
 	return NULL;
 }
 
diff --git a/tests/regression/any/ct.t b/tests/regression/any/ct.t
index 7ce898d..79674ee 100644
--- a/tests/regression/any/ct.t
+++ b/tests/regression/any/ct.t
@@ -13,6 +13,7 @@ ct state {new,established, related, untracked};ok
 - ct state != {new,established, related, untracked};ok
 ct state invalid drop;ok
 ct state established accept;ok
+ct state 8;ok;ct state new
 
 ct direction original;ok
 ct direction != original;ok
-- 
1.7.10.4

