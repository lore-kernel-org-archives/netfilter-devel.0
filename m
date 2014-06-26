From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/5] src: table: Add set, unset and parse implementation for use value
Date: Thu, 26 Jun 2014 19:08:39 +0200
Message-ID: <1403802521-12571-4-git-send-email-anarey@gmail.com>
References: <1403802521-12571-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:42580 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424AbaFZRI6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:08:58 -0400
Received: by mail-wg0-f48.google.com with SMTP id n12so3826415wgh.19
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2014 10:08:55 -0700 (PDT)
In-Reply-To: <1403802521-12571-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add some parts of the implemention of 'use' vualue in table that miss it.

These changes are neeeded for a correct import/export of xml/json file

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/table.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/src/table.c b/src/table.c
index de4a64d..5a0135f 100644
--- a/src/table.c
+++ b/src/table.c
@@ -72,8 +72,7 @@ void nft_table_attr_unset(struct nft_table *t, uint16_t attr)
 	case NFT_TABLE_ATTR_FAMILY:
 		break;
 	case NFT_TABLE_ATTR_USE:
-		/* Cannot be unset, ignoring it */
-		return;
+		break;
 	}
 	t->flags &= ~(1 << attr);
 }
@@ -106,8 +105,8 @@ void nft_table_attr_set_data(struct nft_table *t, uint16_t attr,
 		t->family = *((uint32_t *)data);
 		break;
 	case NFT_TABLE_ATTR_USE:
-		/* Cannot be set, ignoring it */
-		return;
+		t->use = *((uint32_t *)data);
+		break;
 	}
 	t->flags |= (1 << attr);
 }
@@ -263,7 +262,7 @@ int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t,
 {
 	const char *name;
 	int family;
-	uint32_t flags;
+	uint32_t flags, use;
 
 	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
 				  NFT_XML_MAND, err);
@@ -282,6 +281,10 @@ int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t,
 		return -1;
 	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FLAGS, flags);
 
+	if (nft_mxml_num_parse(tree, "use", MXML_DESCEND, BASE_DEC,
+			       &use, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
+		nft_table_attr_set_u32(t, NFT_TABLE_ATTR_USE, use);
+
 	return 0;
 }
 #endif
@@ -310,7 +313,7 @@ int nft_jansson_parse_table(struct nft_table *t, json_t *tree,
 			    struct nft_parse_err *err)
 {
 	json_t *root;
-	uint32_t flags;
+	uint32_t flags, use;
 	const char *str;
 	int family;
 
@@ -334,6 +337,9 @@ int nft_jansson_parse_table(struct nft_table *t, json_t *tree,
 
 	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FLAGS, flags);
 
+	if (nft_jansson_parse_val(root, "use", NFT_TYPE_U32, &use, err) == 0)
+		nft_table_attr_set_u32(t, NFT_TABLE_ATTR_USE, use);
+
 	return 0;
 }
 #endif
-- 
2.0.0

