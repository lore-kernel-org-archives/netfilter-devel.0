From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] chain: xml: optional attributes
Date: Mon, 02 Sep 2013 01:32:31 +0200
Message-ID: <20130901233230.3018.51446.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:37504 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753231Ab3IAXcm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Sep 2013 19:32:42 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id A5E0B520324
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Sep 2013 23:32:38 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4q9oSZy7hT-e for <netfilter-devel@vger.kernel.org>;
	Mon,  2 Sep 2013 01:32:33 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 1E89A52031F
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2013 01:32:32 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch makes optional print/parse of some attributes
of chain objects in XML.

In order to pass nft-parsing-test, some XML nodes are reordered.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/xmlfiles/10-chain.xml |    2 +-
 tests/xmlfiles/11-chain.xml |    2 +-
 tests/xmlfiles/12-chain.xml |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 86beb01..1761772 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -616,16 +616,6 @@ static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
 
 	c->flags |= (1 << NFT_CHAIN_ATTR_PACKETS);
 
-	type = nft_mxml_str_parse(tree, "type", MXML_DESCEND_FIRST);
-	if (type == NULL)
-		goto err;
-
-	if (c->type)
-		xfree(c->type);
-
-	c->type = strdup(type);
-	c->flags |= (1 << NFT_CHAIN_ATTR_TYPE);
-
 	table = nft_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST);
 	if (table == NULL)
 		goto err;
@@ -636,40 +626,50 @@ static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
 	c->table = strdup(table);
 	c->flags |= (1 << NFT_CHAIN_ATTR_TABLE);
 
-	if (nft_mxml_num_parse(tree, "prio", MXML_DESCEND, BASE_DEC, &c->prio,
-			       NFT_TYPE_S32) != 0)
+	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST);
+	if (family < 0)
 		goto err;
 
-	c->flags |= (1 << NFT_CHAIN_ATTR_PRIO);
+	c->family = family;
+	c->flags |= (1 << NFT_CHAIN_ATTR_FAMILY);
 
 	hooknum_str = nft_mxml_str_parse(tree, "hooknum", MXML_DESCEND_FIRST);
-	if (hooknum_str == NULL)
-		goto err;
+	if (hooknum_str != NULL) {
+		hooknum = nft_str2hooknum(hooknum_str);
+		if (hooknum < 0)
+			goto err;
 
-	hooknum = nft_str2hooknum(hooknum_str);
-	if (hooknum < 0)
-		goto err;
+		c->hooknum = hooknum;
+		c->flags |= (1 << NFT_CHAIN_ATTR_HOOKNUM);
 
-	c->hooknum = hooknum;
-	c->flags |= (1 << NFT_CHAIN_ATTR_HOOKNUM);
+		type = nft_mxml_str_parse(tree, "type", MXML_DESCEND_FIRST);
+		if (type == NULL)
+			goto err;
 
-	policy_str = nft_mxml_str_parse(tree, "policy", MXML_DESCEND);
-	if (policy_str == NULL)
-		goto err;
+		if (c->type)
+			xfree(c->type);
 
-	policy = nft_str2verdict(policy_str);
-	if (policy == -1)
-		goto err;
+		c->type = strdup(type);
+		c->flags |= (1 << NFT_CHAIN_ATTR_TYPE);
 
-	c->policy = policy;
-	c->flags |= (1 << NFT_CHAIN_ATTR_POLICY);
 
-	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST);
-	if (family < 0)
-		goto err;
+		if (nft_mxml_num_parse(tree, "prio", MXML_DESCEND, BASE_DEC,
+				       &c->prio, NFT_TYPE_S32) != 0)
+			goto err;
 
-	c->family = family;
-	c->flags |= (1 << NFT_CHAIN_ATTR_FAMILY);
+		c->flags |= (1 << NFT_CHAIN_ATTR_PRIO);
+
+		policy_str = nft_mxml_str_parse(tree, "policy", MXML_DESCEND);
+		if (policy_str == NULL)
+			goto err;
+
+		policy = nft_str2verdict(policy_str);
+		if (policy == -1)
+			goto err;
+
+		c->policy = policy;
+		c->flags |= (1 << NFT_CHAIN_ATTR_POLICY);
+	}
 
 	mxmlDelete(tree);
 	return 0;
@@ -747,22 +747,18 @@ static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 
 	ret = snprintf(buf, size, "<chain><name>%s</name>"
 		       "<handle>%"PRIu64"</handle><bytes>%"PRIu64"</bytes>"
-		       "<packets>%"PRIu64"</packets><type>%s</type>"
-		       "<table>%s</table><prio>%d</prio>"
-		       "<hooknum>%s</hooknum>",
-		       c->name, c->handle, c->bytes, c->packets,
-		       c->type, c->table,
-		       c->prio, hooknum2str_array[c->hooknum]);
+		       "<packets>%"PRIu64"</packets><table>%s</table>",
+		       c->name, c->handle, c->bytes, c->packets, c->table);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	/* The parsing will fail both if there are something different
-	 * than {accept|drop} or if the <policy> node is missing.
-	 */
-	if (c->policy == NF_ACCEPT) {
-		ret = snprintf(buf+offset, size, "<policy>accept</policy>");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	} else if (c->policy == NF_DROP) {
-		ret = snprintf(buf+offset, size, "<policy>drop</policy>");
+	if (c->flags & (1 << NFT_CHAIN_ATTR_HOOKNUM)) {
+		ret =  snprintf(buf+offset, size,
+				"<type>%s</type>"
+				"<hooknum>%s</hooknum>"
+				"<prio>%d</prio>"
+				"<policy>%s</policy>",
+			c->type, hooknum2str_array[c->hooknum], c->prio,
+			nft_verdict2str(c->policy));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
diff --git a/tests/xmlfiles/10-chain.xml b/tests/xmlfiles/10-chain.xml
index e22178a..f0d9da9 100644
--- a/tests/xmlfiles/10-chain.xml
+++ b/tests/xmlfiles/10-chain.xml
@@ -1 +1 @@
-<chain><name>test</name><handle>0</handle><bytes>0</bytes><packets>0</packets><type>filter</type><table>filter</table><prio>0</prio><hooknum>NF_INET_LOCAL_IN</hooknum><policy>accept</policy><family>ip</family></chain>
+<chain><name>test</name><handle>0</handle><bytes>0</bytes><packets>0</packets><table>filter</table><type>filter</type><hooknum>NF_INET_LOCAL_IN</hooknum><prio>0</prio><policy>accept</policy><family>ip</family></chain>
diff --git a/tests/xmlfiles/11-chain.xml b/tests/xmlfiles/11-chain.xml
index 41cac4e..1e04d0f 100644
--- a/tests/xmlfiles/11-chain.xml
+++ b/tests/xmlfiles/11-chain.xml
@@ -1 +1 @@
-<chain><name>test</name><handle>0</handle><bytes>59</bytes><packets>1</packets><type>filter</type><table>filter</table><prio>0</prio><hooknum>NF_INET_FORWARD</hooknum><policy>drop</policy><family>ip6</family></chain>
+<chain><name>test</name><handle>0</handle><bytes>59</bytes><packets>1</packets><table>filter</table><type>filter</type><hooknum>NF_INET_FORWARD</hooknum><prio>0</prio><policy>drop</policy><family>ip6</family></chain>
diff --git a/tests/xmlfiles/12-chain.xml b/tests/xmlfiles/12-chain.xml
index 040eca4..5903760 100644
--- a/tests/xmlfiles/12-chain.xml
+++ b/tests/xmlfiles/12-chain.xml
@@ -1 +1 @@
-<chain><name>foo</name><handle>100</handle><bytes>59264154979</bytes><packets>2548796325</packets><type>nat</type><table>nat</table><prio>0</prio><hooknum>NF_INET_POST_ROUTING</hooknum><policy>accept</policy><family>ip</family></chain>
+<chain><name>foo</name><handle>100</handle><bytes>59264154979</bytes><packets>2548796325</packets><table>nat</table><type>nat</type><hooknum>NF_INET_POST_ROUTING</hooknum><prio>0</prio><policy>accept</policy><family>ip</family></chain>

