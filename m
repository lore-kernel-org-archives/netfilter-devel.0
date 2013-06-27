From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH v2] chain: add hooknum2str
Date: Thu, 27 Jun 2013 18:55:47 +0200
Message-ID: <20130627165512.26972.47124.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:33494 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752030Ab3F0Q4D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:56:03 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 9BCBD51ED2C
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2013 16:56:00 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0MsunwXEYkLx for <netfilter-devel@vger.kernel.org>;
	Thu, 27 Jun 2013 18:55:51 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id B576B51ED2B
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2013 18:55:49 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch translates the Netfilter hooknumber to a readable string.

Useful for printing and parsing in XML and JSON formats.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: Add "" to Json strings. 

 src/chain.c               |   36 +++++++++++++++++++++++++++---------
 test/nft-chain-xml-add.sh |    6 +++---
 2 files changed, 30 insertions(+), 12 deletions(-)


diff --git a/src/chain.c b/src/chain.c
index 6673b82..d290545 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -22,6 +22,7 @@
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter.h>
 
 #include <libnftables/chain.h>
 
@@ -42,6 +43,14 @@ struct nft_chain {
 	uint32_t	flags;
 };
 
+static const char *hooknum2str_array[NF_INET_NUMHOOKS] = {
+	[NF_INET_PRE_ROUTING] = "NF_INET_PRE_ROUTING",
+	[NF_INET_LOCAL_IN] = "NF_INET_LOCAL_IN",
+	[NF_INET_FORWARD] = "NF_INET_FORWARD",
+	[NF_INET_LOCAL_OUT] = "NF_INET_LOCAL_OUT",
+	[NF_INET_POST_ROUTING] = "NF_INET_POST_ROUTING",
+};
+
 struct nft_chain *nft_chain_alloc(void)
 {
 	return calloc(1, sizeof(struct nft_chain));
@@ -629,15 +638,22 @@ static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
 		mxmlDelete(tree);
 		return -1;
 	}
-	utmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (utmp > UINT32_MAX || utmp < 0 || *endptr) {
+
+	/* iterate the list of hooks until a match is found */
+	for (utmp = 0; utmp < NF_INET_NUMHOOKS; utmp++) {
+		if (strcmp(node->child->value.opaque, hooknum2str_array[utmp]) == 0) {
+			c->hooknum = utmp;
+			c->flags |= (1 << NFT_CHAIN_ATTR_HOOKNUM);
+			break;
+		}
+	}
+
+	/* if no hook was found, error */
+	if (!(c->flags & (1 << NFT_CHAIN_ATTR_HOOKNUM))) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
-	memcpy(&c->hooknum, &utmp, sizeof(c->hooknum));
-	c->flags |= (1 << NFT_CHAIN_ATTR_HOOKNUM);
-
 	/* Get and set <policy> */
 	node = mxmlFindElement(tree, tree, "policy", NULL, NULL, MXML_DESCEND);
 	if (node == NULL) {
@@ -709,7 +725,7 @@ static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
 				"\"table\" : \"%s\","
 				"\"prio\" : %d,"
 				"\"use\" : %d,"
-				"\"hooknum\" : %d,"
+				"\"hooknum\" : \"%s\","
 				"\"policy\" : %d,"
 				"\"family\" : %d"
 			"}"
@@ -717,7 +733,8 @@ static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
 		"}",
 			c->name, c->handle, c->bytes, c->packets,
 			NFT_CHAIN_JSON_VERSION, c->type, c->table,
-			c->prio, c->use, c->hooknum, c->policy, c->family);
+			c->prio, c->use, hooknum2str_array[c->hooknum],
+			c->policy, c->family);
 }
 
 static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
@@ -730,14 +747,15 @@ static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 				"<table>%s</table>"
 				"<prio>%d</prio>"
 				"<use>%d</use>"
-				"<hooknum>%d</hooknum>"
+				"<hooknum>%s</hooknum>"
 				"<policy>%d</policy>"
 				"<family>%d</family>"
 			"</properties>"
 		"</chain>",
 			c->name, c->handle, c->bytes, c->packets,
 			NFT_CHAIN_XML_VERSION, c->type, c->table,
-			c->prio, c->use, c->hooknum, c->policy, c->family);
+			c->prio, c->use, hooknum2str_array[c->hooknum],
+			c->policy, c->family);
 }
 
 static int nft_chain_snprintf_default(char *buf, size_t size, struct nft_chain *c)
diff --git a/test/nft-chain-xml-add.sh b/test/nft-chain-xml-add.sh
index d1bd839..fda28cb 100755
--- a/test/nft-chain-xml-add.sh
+++ b/test/nft-chain-xml-add.sh
@@ -40,7 +40,7 @@ XML="<chain name=\"test1\" handle=\"100\" bytes=\"123\" packets=\"321\" version=
                 <table>filter</table>
                 <prio>0</prio>
                 <use>0</use>
-                <hooknum>2</hooknum>
+                <hooknum>NF_INET_LOCAL_IN</hooknum>
                 <policy>1</policy>
                 <family>2</family>
         </properties>
@@ -61,7 +61,7 @@ XML="<chain name=\"test2\" handle=\"101\" bytes=\"59\" packets=\"1\" version=\"0
 		<table>filter</table>
 		<prio>1</prio>
 		<use>0</use>
-		<hooknum>4</hooknum>
+		<hooknum>NF_INET_POST_ROUTING</hooknum>
 		<policy>1</policy>
 		<family>10</family>
 	</properties>
@@ -83,7 +83,7 @@ XML="<chain name=\"test3\" handle=\"102\" bytes=\"51231239\" packets=\"112312312
 		<table>filter</table>
 		<prio>0</prio>
 		<use>0</use>
-		<hooknum>4</hooknum>
+		<hooknum>NF_INET_FORWARD</hooknum>
 		<policy>1</policy>
 		<family>2</family>
 	</properties>

