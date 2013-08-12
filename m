From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] chain: xml: delete <use> node
Date: Mon, 12 Aug 2013 09:35:34 +0200
Message-ID: <20130812073534.20663.87896.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:59735 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754266Ab3HLHfn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:35:43 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 06D6D51ED7C
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Aug 2013 07:35:42 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t7Es6VyiOue7 for <netfilter-devel@vger.kernel.org>;
	Mon, 12 Aug 2013 09:35:37 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id F2B4B51ED78
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Aug 2013 09:35:36 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since the 'use' attribute in a chain can't be set, ignore it in the
XML printing.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/xmlfiles/10-chain.xml |    2 +-
 tests/xmlfiles/11-chain.xml |    2 +-
 tests/xmlfiles/12-chain.xml |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index a6d99ca..e2296d3 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -756,11 +756,11 @@ static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 	ret = snprintf(buf, size, "<chain><name>%s</name>"
 		       "<handle>%"PRIu64"</handle><bytes>%"PRIu64"</bytes>"
 		       "<packets>%"PRIu64"</packets><type>%s</type>"
-		       "<table>%s</table><prio>%d</prio><use>%d</use>"
+		       "<table>%s</table><prio>%d</prio>"
 		       "<hooknum>%s</hooknum>",
 		       c->name, c->handle, c->bytes, c->packets,
 		       c->type, c->table,
-		       c->prio, c->use, hooknum2str_array[c->hooknum]);
+		       c->prio, hooknum2str_array[c->hooknum]);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	/* The parsing will fail both if there are something different
diff --git a/tests/xmlfiles/10-chain.xml b/tests/xmlfiles/10-chain.xml
index 347626c..e22178a 100644
--- a/tests/xmlfiles/10-chain.xml
+++ b/tests/xmlfiles/10-chain.xml
@@ -1 +1 @@
-<chain><name>test</name><handle>0</handle><bytes>0</bytes><packets>0</packets><type>filter</type><table>filter</table><prio>0</prio><use>1</use><hooknum>NF_INET_LOCAL_IN</hooknum><policy>accept</policy><family>ip</family></chain>
+<chain><name>test</name><handle>0</handle><bytes>0</bytes><packets>0</packets><type>filter</type><table>filter</table><prio>0</prio><hooknum>NF_INET_LOCAL_IN</hooknum><policy>accept</policy><family>ip</family></chain>
diff --git a/tests/xmlfiles/11-chain.xml b/tests/xmlfiles/11-chain.xml
index beec5ee..41cac4e 100644
--- a/tests/xmlfiles/11-chain.xml
+++ b/tests/xmlfiles/11-chain.xml
@@ -1 +1 @@
-<chain><name>test</name><handle>0</handle><bytes>59</bytes><packets>1</packets><type>filter</type><table>filter</table><prio>0</prio><use>1</use><hooknum>NF_INET_FORWARD</hooknum><policy>drop</policy><family>ip6</family></chain>
+<chain><name>test</name><handle>0</handle><bytes>59</bytes><packets>1</packets><type>filter</type><table>filter</table><prio>0</prio><hooknum>NF_INET_FORWARD</hooknum><policy>drop</policy><family>ip6</family></chain>
diff --git a/tests/xmlfiles/12-chain.xml b/tests/xmlfiles/12-chain.xml
index 9036fa1..040eca4 100644
--- a/tests/xmlfiles/12-chain.xml
+++ b/tests/xmlfiles/12-chain.xml
@@ -1 +1 @@
-<chain><name>foo</name><handle>100</handle><bytes>59264154979</bytes><packets>2548796325</packets><type>nat</type><table>nat</table><prio>0</prio><use>1</use><hooknum>NF_INET_POST_ROUTING</hooknum><policy>accept</policy><family>ip</family></chain>
+<chain><name>foo</name><handle>100</handle><bytes>59264154979</bytes><packets>2548796325</packets><type>nat</type><table>nat</table><prio>0</prio><hooknum>NF_INET_POST_ROUTING</hooknum><policy>accept</policy><family>ip</family></chain>

