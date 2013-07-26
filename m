From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] set: xml: change XML attributes to nodes.
Date: Fri, 26 Jul 2013 14:11:07 +0200
Message-ID: <20130726121107.5396.26597.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39516 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757545Ab3GZMLR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:11:17 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 82CA251EEAB
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2013 12:11:15 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WpnUMb1HwxMO for <netfilter-devel@vger.kernel.org>;
	Fri, 26 Jul 2013 14:11:10 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 301B651EE9B
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2013 14:11:09 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch changes all XML attributes to XML nodes in nft_set.

In order to avoid issues regarding XML nodes with the same name but
different meanings, I've followed this pattern for the new elements:

<set>
	<set_table>string</set_table>
	<set_name>string</set_name>
	<set_xml_version>int</set_xml_version>
	[...]
</set>

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/set.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/src/set.c b/src/set.c
index ef15527..f525fa8 100644
--- a/src/set.c
+++ b/src/set.c
@@ -386,20 +386,18 @@ static int nft_set_snprintf_xml(char *buf, size_t size, struct nft_set *s,
 	int len = size, offset = 0;
 	struct nft_set_elem *elem;
 
-	ret = snprintf(buf, size,
-		       "<set name=\"%s\" table=\"%s\" version=\"%d\">",
-		       s->name, s->table, NFT_SET_XML_VERSION);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	ret = snprintf(buf+offset, size, "<family>%s</family>"
+	ret = snprintf(buf, size, "<set><family>%s</family>"
+					"<set_table>%s</set_table>"
+					"<set_name>%s</set_name>"
+					"<set_xml_version>%d</set_xml_version>"
 					"<set_flags>%u</set_flags>"
 					"<key_type>%u</key_type>"
 					"<key_len>%u</key_len>"
 					"<data_type>%u</data_type>"
 					"<data_len>%u</data_len>",
-			nft_family2str(s->family),
-			s->set_flags, s->key_type, s->key_len,
-			s->data_type, s->data_len);
+			nft_family2str(s->family), s->table, s->name,
+			NFT_SET_XML_VERSION,  s->set_flags, s->key_type,
+			s->key_len, s->data_type, s->data_len);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (!list_empty(&s->element_list)) {

