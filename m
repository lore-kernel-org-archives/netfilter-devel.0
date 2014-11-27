From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] datatype: fix crash when using basetype instead of symbolic constants
Date: Thu, 27 Nov 2014 13:59:56 +0100
Message-ID: <1417093196-19347-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, christophe.leroy@c-s.fr
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60055 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbaK0M54 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:57:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following example:

 # nft add rule filter input ct state 8 accept
 Segmentation fault

leads to a crash because we have the following datatype relation:

 ct_state -> bitmask -> integer

The bitmask, which is an intermediate basetype, has no parse()
function, this leads to a crash in symbolic_constant_parse().

So let's default to the leaf basetype parser when the intermediate
one has no specific parser() function.

Add a bugtrap too to catch inconsistent datatype configurations.

Reported-by: leroy christophe <christophe.leroy@c-s.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/datatype.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index 5f976aa..baeaea7 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -128,7 +128,17 @@ struct error_record *symbolic_constant_parse(const struct expr *sym,
 	dtype = sym->dtype;
 	if (s->identifier == NULL) {
 		*res = NULL;
-		erec = sym->dtype->basetype->parse(sym, res);
+
+		if (sym->dtype->basetype->parse) {
+			erec = sym->dtype->basetype->parse(sym, res);
+		} else if (sym->dtype->basetype->basetype &&
+			   sym->dtype->basetype->basetype->parse) {
+			erec = sym->dtype->basetype->basetype->parse(sym, res);
+		} else {
+			BUG("cannot parse symbol %s with datatype %s\n",
+			    sym->identifier, sym->dtype->basetype->name);
+		}
+
 		if (erec != NULL)
 			return erec;
 		if (*res)
-- 
1.7.10.4

