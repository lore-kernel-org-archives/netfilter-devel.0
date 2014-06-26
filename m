From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 4/5] src: table: Do not print unset values in xml file
Date: Thu, 26 Jun 2014 19:08:40 +0200
Message-ID: <1403802521-12571-5-git-send-email-anarey@gmail.com>
References: <1403802521-12571-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40937 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbaFZRI6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:08:58 -0400
Received: by mail-wg0-f46.google.com with SMTP id y10so3956675wgg.5
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2014 10:08:57 -0700 (PDT)
In-Reply-To: <1403802521-12571-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and snprintf functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/table.c | 47 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/src/table.c b/src/table.c
index 5a0135f..7874245 100644
--- a/src/table.c
+++ b/src/table.c
@@ -266,20 +266,17 @@ int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t,
 
 	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
 				  NFT_XML_MAND, err);
-	if (name == NULL)
-		return -1;
-	nft_table_attr_set_str(t, NFT_TABLE_ATTR_NAME, name);
+	if (name != NULL)
+		nft_table_attr_set_str(t, NFT_TABLE_ATTR_NAME, name);
 
 	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
 				       NFT_XML_MAND, err);
-	if (family < 0)
-		return -1;
-	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FAMILY, family);
+	if (family >= 0)
+		nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FAMILY, family);
 
 	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND, BASE_DEC,
-			       &flags, NFT_TYPE_U32, NFT_XML_MAND, err) != 0)
-		return -1;
-	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FLAGS, flags);
+			       &flags, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
+		nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FLAGS, flags);
 
 	if (nft_mxml_num_parse(tree, "use", MXML_DESCEND, BASE_DEC,
 			       &use, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
@@ -424,10 +421,34 @@ static int nft_table_snprintf_json(char *buf, size_t size, struct nft_table *t)
 
 static int nft_table_snprintf_xml(char *buf, size_t size, struct nft_table *t)
 {
-	return snprintf(buf, size, "<table><name>%s</name><family>%s</family>"
-			"<flags>%d</flags><use>%d</use></table>",
-			t->name, nft_family2str(t->family),
-			t->table_flags, t->use);
+	int ret, len = size, offset = 0;
+
+	ret = snprintf(buf, size, "<table>");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (t->flags & (1 << NFT_TABLE_ATTR_NAME)) {
+		ret = snprintf(buf + offset, size, "<name>%s</name>", t->name);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (t->flags & (1 << NFT_TABLE_ATTR_FAMILY)) {
+		ret = snprintf(buf + offset, size, "<family>%s</family>",
+			       nft_family2str(t->family));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (t->flags & (1 << NFT_TABLE_ATTR_FLAGS)) {
+		ret = snprintf(buf + offset, size, "<flags>%u</flags>",
+			       t->table_flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (t->flags & (1 << NFT_TABLE_ATTR_USE)) {
+		ret = snprintf(buf + offset, size, "<use>%u</use>", t->use);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret = snprintf(buf + offset, size, "</table>");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
 }
 
 static int nft_table_snprintf_default(char *buf, size_t size, struct nft_table *t)
-- 
2.0.0

