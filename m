From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/5] src: set: Do not print unset values in xml
Date: Wed, 11 Jun 2014 17:50:48 +0200
Message-ID: <1402501851-22208-4-git-send-email-anarey@gmail.com>
References: <1402501851-22208-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53724 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaFKPvQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:51:16 -0400
Received: by mail-wi0-f175.google.com with SMTP id r20so33445wiv.14
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2014 08:51:15 -0700 (PDT)
In-Reply-To: <1402501851-22208-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and the snprint functions to omit unset values.

This xml file is gotten for a set:

<set>
	<family>unknown</family>
	<table>test</table>
	<name>miset</name>
	<flags>0</flags>
	<key_type>0</key_type>
	<key_len>0</key_len>
	<set_elem>
		<flags>0</flags>
		<key>
			<data_reg type="value">
				<len>4</len>
				<data0>0x0401a8c0</data0>
			</data_reg>
		</key>
	</set_elem>
	<set_elem>
		<flags>0</flags>
		<key>
			<data_reg type="value">
				<len>4</len>
				<data0>0x0501a8c0</data0>
			</data_reg>
		</key>
	</set_elem>
</set>

Now, this xml file is gotten without unset values:

<set>
	<family>unknown</family>
	<table>test</table>
	<name>miset</name>
	<set_elem>
		<key>
			<data_reg type="value">
				<len>4</len>
				<data0>0x00000002</data0>
			</data_reg>
		</key>
	</set_elem>
	<set_elem>
		<key>
			<data_reg type="value">
				<len>4</len>
				<data0>0x0401a8c0</data0>
			</data_reg>
		</key>
	</set_elem>
</set>

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/set.c      | 76 +++++++++++++++++++++++++++++++++++++++-------------------
 src/set_elem.c | 36 ++++++++++++++++------------
 2 files changed, 72 insertions(+), 40 deletions(-)

diff --git a/src/set.c b/src/set.c
index d1d176c..e328288 100644
--- a/src/set.c
+++ b/src/set.c
@@ -471,19 +471,17 @@ int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s,
 
 	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
 				       NFT_XML_MAND, err);
-	if (family < 0)
-		return -1;
-	nft_set_attr_set_u32(s, NFT_SET_ATTR_FAMILY, family);
+	if (family >= 0)
+		nft_set_attr_set_u32(s, NFT_SET_ATTR_FAMILY, family);
 
 	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
-			       &set_flags, NFT_TYPE_U32, NFT_XML_MAND, err) < 0)
-		return -1;
-	nft_set_attr_set_u32(s, NFT_SET_ATTR_FLAGS, set_flags);
+			       &set_flags, NFT_TYPE_U32, NFT_XML_MAND,
+			       err) == 0)
+		nft_set_attr_set_u32(s, NFT_SET_ATTR_FLAGS, set_flags);
 
 	if (nft_mxml_num_parse(tree, "key_type", MXML_DESCEND_FIRST, BASE_DEC,
-			       &key_type, NFT_TYPE_U32, NFT_XML_MAND, err) < 0)
-		return -1;
-	nft_set_attr_set_u32(s, NFT_SET_ATTR_KEY_TYPE, key_type);
+			       &key_type, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
+		nft_set_attr_set_u32(s, NFT_SET_ATTR_KEY_TYPE, key_type);
 
 	if (nft_mxml_num_parse(tree, "key_len", MXML_DESCEND_FIRST, BASE_DEC,
 			       &key_len, NFT_TYPE_U32, NFT_XML_MAND, err) < 0)
@@ -497,9 +495,8 @@ int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s,
 
 		if (nft_mxml_num_parse(tree, "data_len", MXML_DESCEND_FIRST,
 				       BASE_DEC, &data_len, NFT_TYPE_U32,
-				       NFT_XML_MAND, err) < 0)
-			return -1;
-		nft_set_attr_set_u32(s, NFT_SET_ATTR_DATA_LEN, data_len);
+				       NFT_XML_MAND, err) == 0)
+			nft_set_attr_set_u32(s, NFT_SET_ATTR_DATA_LEN, data_len);
 
 	}
 
@@ -668,22 +665,51 @@ static int nft_set_snprintf_xml(char *buf, size_t size, struct nft_set *s,
 	int len = size, offset = 0;
 	struct nft_set_elem *elem;
 
-	ret = snprintf(buf, len, "<set><family>%s</family>"
-				  "<table>%s</table>"
-				  "<name>%s</name>"
-				  "<flags>%u</flags>"
-				  "<key_type>%u</key_type>"
-				  "<key_len>%u</key_len>",
-			nft_family2str(s->family), s->table, s->name,
-			s->set_flags, s->key_type, s->key_len);
+	ret = snprintf(buf, len, "<set>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	if (s->flags & (1 << NFT_SET_ATTR_DATA_TYPE) &&
-	    s->flags & (1 << NFT_SET_ATTR_DATA_LEN)) {
-		ret = snprintf(buf+offset, len, "<data_type>%u</data_type>"
-			       "<data_len>%u</data_len>",
-			       s->data_type, s->data_len);
+	if (s->flags & (1 << NFT_SET_ATTR_FAMILY)) {
+		ret = snprintf(buf+offset, len, "<family>%s</family>",
+			       nft_family2str(s->family));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (s->flags & (1 << NFT_SET_ATTR_TABLE)) {
+		ret = snprintf(buf+offset, len, "<table>%s</table>",
+			       s->table);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (s->flags & (1 << NFT_SET_ATTR_NAME)) {
+		ret = snprintf(buf+offset, len, "<name>%s</name>",
+			       s->name);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
+	if (s->flags & (1 << NFT_SET_ATTR_FLAGS)) {
+		ret = snprintf(buf+offset, len, "<flags>%u</flags>",
+			       s->set_flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (s->flags & (1 << NFT_SET_ATTR_KEY_TYPE)) {
+		ret = snprintf(buf+offset, len, "<key_type>%u</key_type>",
+			       s->key_type);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (s->flags & (1 << NFT_SET_ATTR_KEY_LEN)) {
+		ret = snprintf(buf+offset, len, "<key_len>%u</key_len>",
+			       s->key_len);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (s->flags & (1 << NFT_SET_ATTR_DATA_TYPE)) {
+		ret = snprintf(buf+offset, len, "<data_type>%u</data_type>",
+			       s->data_type);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (s->flags & (1 << NFT_SET_ATTR_DATA_LEN)) {
+		ret = snprintf(buf+offset, len, "<data_len>%u</data_len>",
+			       s->data_len);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
diff --git a/src/set_elem.c b/src/set_elem.c
index 9d1dc41..2ccaf3f 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -386,15 +386,12 @@ int nft_mxml_set_elem_parse(mxml_node_t *tree, struct nft_set_elem *e,
 
 	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
 			       &set_elem_flags, NFT_TYPE_U32, NFT_XML_MAND,
-			       err) < 0)
-		return -1;
-	nft_set_elem_attr_set_u32(e, NFT_SET_ELEM_ATTR_FLAGS, set_elem_flags);
+			       err) == 0)
+		nft_set_elem_attr_set_u32(e, NFT_SET_ELEM_ATTR_FLAGS, set_elem_flags);
 
 	if (nft_mxml_data_reg_parse(tree, "key", &e->key,
-				    NFT_XML_MAND, err) != DATA_VALUE)
-		return -1;
-
-	e->flags |= (1 << NFT_SET_ELEM_ATTR_KEY);
+				    NFT_XML_MAND, err) == DATA_VALUE)
+		e->flags |= (1 << NFT_SET_ELEM_ATTR_KEY);
 
 	/* <set_elem_data> is not mandatory */
 	set_elem_data = nft_mxml_data_reg_parse(tree, "data",
@@ -563,17 +560,26 @@ static int nft_set_elem_snprintf_xml(char *buf, size_t size,
 {
 	int ret, len = size, offset = 0, type = DATA_NONE;
 
-	ret = snprintf(buf, size, "<set_elem>"
-				"<flags>%u</flags><key>",
-				e->set_elem_flags);
+	ret = snprintf(buf, size, "<set_elem>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = nft_data_reg_snprintf(buf+offset, len, &e->key,
-				    NFT_OUTPUT_XML, flags, DATA_VALUE);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_SET_ELEM_ATTR_FLAGS)) {
+		ret = snprintf(buf, size, "<flags>%u</flags>",
+			       e->set_elem_flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
-	ret = snprintf(buf+offset, len, "</key>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_SET_ELEM_ATTR_KEY)) {
+		ret = snprintf(buf+offset, len, "<key>");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret = nft_data_reg_snprintf(buf+offset, len, &e->key,
+					    NFT_OUTPUT_XML, flags, DATA_VALUE);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret = snprintf(buf+offset, len, "</key>");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
 	if (e->flags & (1 << NFT_SET_ELEM_ATTR_DATA))
 		type = DATA_VALUE;
-- 
2.0.0

