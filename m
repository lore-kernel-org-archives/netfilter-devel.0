From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft RFC] payload: use ethertype in hexadecimal for meta protocol
Date: Wed, 15 Jan 2014 18:11:42 +0100
Message-ID: <1389805902-8807-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46492 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaAORLu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:11:50 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a temporary workaround to avoid parsing problems since
ip and arp are misinterpreted by the parser. It also uses ipv6
which is different from ip6 and it seems inconsistent to me.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
A possible alternative to this patch could be to use something
like: ether-arp ether-ip ether-ipv6 ether-vlan, as these represent
ethernet protocol types.

 src/payload.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/src/payload.c b/src/payload.c
index 86d75fa..c4ea6da 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -978,16 +978,6 @@ const struct datatype etheraddr_type = {
 	.basetype	= &lladdr_type,
 };
 
-static const struct symbol_table ethertype_tbl = {
-	.symbols	= {
-		SYMBOL("ip",		ETH_P_IP),
-		SYMBOL("arp",		ETH_P_ARP),
-		SYMBOL("ipv6",		ETH_P_IPV6),
-		SYMBOL("vlan",		ETH_P_8021Q),
-		SYMBOL_LIST_END
-	},
-};
-
 static struct error_record *ethertype_parse(const struct expr *sym,
 					    struct expr **res)
 {
@@ -996,14 +986,13 @@ static struct error_record *ethertype_parse(const struct expr *sym,
 	erec = sym->dtype->basetype->parse(sym, res);
 	if (erec != NULL)
 		return erec;
-	if (*res)
-		return NULL;
-	return symbolic_constant_parse(sym, &ethertype_tbl, res);
+
+	return NULL;
 }
 
 static void ethertype_print(const struct expr *expr)
 {
-	return symbolic_constant_print(&ethertype_tbl, expr);
+	expr_basetype(expr)->print(expr);
 }
 
 const struct datatype ethertype_type = {
-- 
1.7.10.4

