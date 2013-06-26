From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 12/21] chain: xml: use string for policy
Date: Wed, 26 Jun 2013 13:37:10 +0200
Message-ID: <20130626113710.23511.49021.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54691 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752049Ab3FZLhT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:19 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now the <policy> node is using "accept" or "drop".

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/chain.c               |   52 +++++++++++++++++++++++++++++++--------------
 test/nft-chain-xml-add.sh |    6 +++--
 2 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index ce9bb1b..a66ffe9 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -660,13 +660,16 @@ static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
 		mxmlDelete(tree);
 		return -1;
 	}
-	utmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (utmp > UINT32_MAX || utmp < 0 || *endptr) {
+
+	if (strcmp(node->child->value.opaque, "accept") == 0) {
+		c->policy = NF_ACCEPT;
+	} else if (strcmp(node->child->value.opaque, "drop") == 0) {
+		c->policy = NF_DROP;
+	} else {
 		mxmlDelete(tree);
 		return -1;
 	}
 
-	c->policy = (uint32_t)utmp;
 	c->flags |= (1 << NFT_CHAIN_ATTR_POLICY);
 
 	/* Get and set <family> */
@@ -739,23 +742,40 @@ static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
 
 static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 {
-	return snprintf(buf, size,
-		"<chain name=\"%s\" handle=\"%lu\""
-			" bytes=\"%lu\" packets=\"%lu\" version=\"%d\">"
-			"<properties>"
+	int ret, len = size, offset = 0;
+
+	ret = snprintf(buf, size,
+		       "<chain name=\"%s\" handle=\"%lu\""
+		       " bytes=\"%lu\" packets=\"%lu\" version=\"%d\">"
+		       "<properties>"
 				"<type>%s</type>"
 				"<table>%s</table>"
 				"<prio>%d</prio>"
 				"<use>%d</use>"
-				"<hooknum>%s</hooknum>"
-				"<policy>%d</policy>"
-				"<family>%s</family>"
-			"</properties>"
-		"</chain>",
-			c->name, c->handle, c->bytes, c->packets,
-			NFT_CHAIN_XML_VERSION, c->type, c->table,
-			c->prio, c->use, hooknum2str_array[c->hooknum],
-			c->policy, nft_family2str(c->family));
+				"<hooknum>%s</hooknum>",
+		       c->name, c->handle, c->bytes, c->packets,
+		       NFT_CHAIN_XML_VERSION, c->type, c->table,
+		       c->prio, c->use, hooknum2str_array[c->hooknum]);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	/* The parsing will fail both if there are something different
+	 * than {accept|drop} or if the <policy> node is missing.
+	 */
+
+	if (c->policy == NF_ACCEPT) {
+		ret = snprintf(buf+offset, size, "<policy>accept</policy>");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	} else if (c->policy == NF_DROP) {
+		ret = snprintf(buf+offset, size, "<policy>drop</policy>");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret = snprintf(buf+offset, size, "<family>%s</family>"
+		       "</properties></chain>",
+		       nft_family2str(c->family));
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
 }
 
 static int nft_chain_snprintf_default(char *buf, size_t size,
diff --git a/test/nft-chain-xml-add.sh b/test/nft-chain-xml-add.sh
index ab50e2b..ed39d54 100755
--- a/test/nft-chain-xml-add.sh
+++ b/test/nft-chain-xml-add.sh
@@ -41,7 +41,7 @@ XML="<chain name=\"test1\" handle=\"100\" bytes=\"123\" packets=\"321\" version=
                 <prio>0</prio>
                 <use>0</use>
                 <hooknum>NF_INET_LOCAL_IN</hooknum>
-                <policy>1</policy>
+                <policy>accept</policy>
                 <family>ip</family>
         </properties>
 </chain>"
@@ -62,7 +62,7 @@ XML="<chain name=\"test2\" handle=\"101\" bytes=\"59\" packets=\"1\" version=\"0
 		<prio>1</prio>
 		<use>0</use>
 		<hooknum>NF_INET_POST_ROUTING</hooknum>
-		<policy>1</policy>
+		<policy>accept</policy>
 		<family>ip6</family>
 	</properties>
 </chain>"
@@ -84,7 +84,7 @@ XML="<chain name=\"test3\" handle=\"102\" bytes=\"51231239\" packets=\"112312312
 		<prio>0</prio>
 		<use>0</use>
 		<hooknum>NF_INET_FORWARD</hooknum>
-		<policy>1</policy>
+		<policy>drop</policy>
 		<family>ip</family>
 	</properties>
 </chain>"

