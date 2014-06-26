From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/5] src: table: Free memory in the same function that is reserved
Date: Thu, 26 Jun 2014 19:08:37 +0200
Message-ID: <1403802521-12571-2-git-send-email-anarey@gmail.com>
References: <1403802521-12571-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:60438 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713AbaFZRI6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:08:58 -0400
Received: by mail-wi0-f182.google.com with SMTP id bs8so1447108wib.15
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2014 10:08:53 -0700 (PDT)
In-Reply-To: <1403802521-12571-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Free memory in the same function that is reserved.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/table.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/src/table.c b/src/table.c
index b4d1663..ed6e615 100644
--- a/src/table.c
+++ b/src/table.c
@@ -328,25 +328,21 @@ int nft_jansson_parse_table(struct nft_table *t, json_t *tree,
 
 	str = nft_jansson_parse_str(root, "name", err);
 	if (str == NULL)
-		goto err;
+		return -1;
 
 	nft_table_attr_set_str(t, NFT_TABLE_ATTR_NAME, str);
 
 	if (nft_jansson_parse_family(root, &family, err) != 0)
-		goto err;
+		return -1;
 
 	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FAMILY, family);
 
 	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &flags, err) < 0)
-		goto err;
+		return -1;
 
 	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FLAGS, flags);
 
-	nft_jansson_free_root(tree);
 	return 0;
-err:
-	nft_jansson_free_root(tree);
-	return -1;
 }
 #endif
 
@@ -357,12 +353,17 @@ static int nft_table_json_parse(struct nft_table *t, const void *json,
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
+	int ret;
 
 	tree = nft_jansson_create_root(json, &error, err, input);
 	if (tree == NULL)
 		return -1;
 
-	return nft_jansson_parse_table(t, tree, err);
+	ret = nft_jansson_parse_table(t, tree, err);
+
+	nft_jansson_free_root(tree);
+
+	return ret;
 #else
 	errno = EOPNOTSUPP;
 	return -1;
-- 
2.0.0

