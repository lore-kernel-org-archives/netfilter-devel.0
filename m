From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/5] src: set: Use nft_rule_expr_set_* in the xml parsing code
Date: Wed, 11 Jun 2014 17:50:46 +0200
Message-ID: <1402501851-22208-2-git-send-email-anarey@gmail.com>
References: <1402501851-22208-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:65163 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528AbaFKPvN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:51:13 -0400
Received: by mail-we0-f179.google.com with SMTP id w62so4973717wes.10
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2014 08:51:12 -0700 (PDT)
In-Reply-To: <1402501851-22208-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_set_* in parse functions.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/set.c      | 46 ++++++++++++++++------------------------------
 src/set_elem.c | 10 +++++-----
 2 files changed, 21 insertions(+), 35 deletions(-)

diff --git a/src/set.c b/src/set.c
index 57bbcaa..d1d176c 100644
--- a/src/set.c
+++ b/src/set.c
@@ -454,67 +454,53 @@ int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s,
 	struct nft_set_elem *elem;
 	const char *name, *table;
 	int family;
+	uint32_t set_flags, key_type, key_len;
+	uint32_t data_type, data_len;
 
 	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
 				  NFT_XML_MAND, err);
 	if (name == NULL)
 		return -1;
-
-	if (s->name)
-		xfree(s->name);
-
-	s->name = strdup(name);
-	s->flags |= (1 << NFT_SET_ATTR_NAME);
+	nft_set_attr_set_str(s, NFT_SET_ATTR_NAME, name);
 
 	table = nft_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST,
 				   NFT_XML_MAND, err);
 	if (table == NULL)
 		return -1;
-
-	if (s->table)
-		xfree(s->table);
-
-	s->table = strdup(table);
-	s->flags |= (1 << NFT_SET_ATTR_TABLE);
+	nft_set_attr_set_str(s, NFT_SET_ATTR_TABLE, table);
 
 	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
 				       NFT_XML_MAND, err);
 	if (family < 0)
 		return -1;
-
-	s->family = family;
-
-	s->flags |= (1 << NFT_SET_ATTR_FAMILY);
+	nft_set_attr_set_u32(s, NFT_SET_ATTR_FAMILY, family);
 
 	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
-			       &s->set_flags, NFT_TYPE_U32, NFT_XML_MAND, err) != 0)
+			       &set_flags, NFT_TYPE_U32, NFT_XML_MAND, err) < 0)
 		return -1;
-
-	s->flags |= (1 << NFT_SET_ATTR_FLAGS);
+	nft_set_attr_set_u32(s, NFT_SET_ATTR_FLAGS, set_flags);
 
 	if (nft_mxml_num_parse(tree, "key_type", MXML_DESCEND_FIRST, BASE_DEC,
-			       &s->key_type, NFT_TYPE_U32, NFT_XML_MAND, err) != 0)
+			       &key_type, NFT_TYPE_U32, NFT_XML_MAND, err) < 0)
 		return -1;
-
-	s->flags |= (1 << NFT_SET_ATTR_KEY_TYPE);
+	nft_set_attr_set_u32(s, NFT_SET_ATTR_KEY_TYPE, key_type);
 
 	if (nft_mxml_num_parse(tree, "key_len", MXML_DESCEND_FIRST, BASE_DEC,
-			       &s->key_len, NFT_TYPE_U32, NFT_XML_MAND, err) != 0)
+			       &key_len, NFT_TYPE_U32, NFT_XML_MAND, err) < 0)
 		return -1;
-
-	s->flags |= (1 << NFT_SET_ATTR_KEY_LEN);
+	nft_set_attr_set_u32(s, NFT_SET_ATTR_KEY_LEN, key_len);
 
 	if (nft_mxml_num_parse(tree, "data_type", MXML_DESCEND_FIRST, BASE_DEC,
-			       &s->data_type, NFT_TYPE_U32,
+			       &data_type, NFT_TYPE_U32,
 			       NFT_XML_OPT, err) == 0) {
-		s->flags |= (1 << NFT_SET_ATTR_DATA_TYPE);
+		nft_set_attr_set_u32(s, NFT_SET_ATTR_DATA_TYPE, data_type);
 
 		if (nft_mxml_num_parse(tree, "data_len", MXML_DESCEND_FIRST,
-				       BASE_DEC, &s->data_len, NFT_TYPE_U32,
-				       NFT_XML_MAND, err) != 0)
+				       BASE_DEC, &data_len, NFT_TYPE_U32,
+				       NFT_XML_MAND, err) < 0)
 			return -1;
+		nft_set_attr_set_u32(s, NFT_SET_ATTR_DATA_LEN, data_len);
 
-		s->flags |= (1 << NFT_SET_ATTR_DATA_LEN);
 	}
 
 	for (node = mxmlFindElement(tree, tree, "set_elem", NULL,
diff --git a/src/set_elem.c b/src/set_elem.c
index a56fcb2..9d1dc41 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -382,13 +382,13 @@ int nft_mxml_set_elem_parse(mxml_node_t *tree, struct nft_set_elem *e,
 			    struct nft_parse_err *err)
 {
 	int set_elem_data;
+	uint32_t set_elem_flags;
 
-	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST,
-			       BASE_DEC, &e->set_elem_flags,
-			       NFT_TYPE_U32, NFT_XML_MAND, err) != 0)
+	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
+			       &set_elem_flags, NFT_TYPE_U32, NFT_XML_MAND,
+			       err) < 0)
 		return -1;
-
-	e->flags |= (1 << NFT_SET_ELEM_ATTR_FLAGS);
+	nft_set_elem_attr_set_u32(e, NFT_SET_ELEM_ATTR_FLAGS, set_elem_flags);
 
 	if (nft_mxml_data_reg_parse(tree, "key", &e->key,
 				    NFT_XML_MAND, err) != DATA_VALUE)
-- 
2.0.0

