From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] set: xml: data_type/data_len are optional
Date: Mon, 13 Jan 2014 13:14:52 +0100
Message-ID: <20140113121452.28355.87886.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:58054 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751357AbaAMMSx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:18:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Don't print data_type and data_len if they aren't set.
Also, they are optional when parsing.

Printing and parsing unconditionally leads to false values and other errors.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/set.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/src/set.c b/src/set.c
index 822a715..bee9540 100644
--- a/src/set.c
+++ b/src/set.c
@@ -453,16 +453,17 @@ int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s,
 	s->flags |= (1 << NFT_SET_ATTR_KEY_LEN);
 
 	if (nft_mxml_num_parse(tree, "data_type", MXML_DESCEND_FIRST, BASE_DEC,
-			       &s->data_type, NFT_TYPE_U32, NFT_XML_MAND, err) != 0)
-		return -1;
-
-	s->flags |= (1 << NFT_SET_ATTR_DATA_TYPE);
+			       &s->data_type, NFT_TYPE_U32,
+			       NFT_XML_OPT, err) == 0) {
+		s->flags |= (1 << NFT_SET_ATTR_DATA_TYPE);
 
-	if (nft_mxml_num_parse(tree, "data_len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &s->data_len, NFT_TYPE_U32, NFT_XML_MAND, err) != 0)
-		return -1;
+		if (nft_mxml_num_parse(tree, "data_len", MXML_DESCEND_FIRST,
+				       BASE_DEC, &s->data_len, NFT_TYPE_U32,
+				       NFT_XML_MAND, err) != 0)
+			return -1;
 
-	s->flags |= (1 << NFT_SET_ATTR_DATA_LEN);
+		s->flags |= (1 << NFT_SET_ATTR_DATA_LEN);
+	}
 
 	for (node = mxmlFindElement(tree, tree, "set_elem", NULL,
 				    NULL, MXML_DESCEND);
@@ -634,14 +635,20 @@ static int nft_set_snprintf_xml(char *buf, size_t size, struct nft_set *s,
 				  "<name>%s</name>"
 				  "<flags>%u</flags>"
 				  "<key_type>%u</key_type>"
-				  "<key_len>%u</key_len>"
-				  "<data_type>%u</data_type>"
-				  "<data_len>%u</data_len>",
+				  "<key_len>%u</key_len>",
 			nft_family2str(s->family), s->table, s->name,
-			s->set_flags, s->key_type,
-			s->key_len, s->data_type, s->data_len);
+			s->set_flags, s->key_type, s->key_len);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	if (s->flags & (1 << NFT_SET_ATTR_DATA_TYPE) &&
+	    s->flags & (1 << NFT_SET_ATTR_DATA_LEN)) {
+		ret = snprintf(buf+offset, len, "<data_type>%u</data_type>"
+			       "<data_len>%u</data_len>",
+			       s->data_type, s->data_len);
+
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	if (!list_empty(&s->element_list)) {
 		list_for_each_entry(elem, &s->element_list, head) {
 			ret = nft_set_elem_snprintf(buf+offset, len, elem,

