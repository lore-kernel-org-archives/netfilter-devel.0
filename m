From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 4/5] src: set: Free memory in the same function that is reserved.
Date: Wed, 11 Jun 2014 17:50:50 +0200
Message-ID: <1402501851-22208-6-git-send-email-anarey@gmail.com>
References: <1402501851-22208-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:43760 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850AbaFKPvT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:51:19 -0400
Received: by mail-we0-f173.google.com with SMTP id t60so2497719wes.4
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2014 08:51:18 -0700 (PDT)
In-Reply-To: <1402501851-22208-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Free memory in the same function that is reserved.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/set.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/src/set.c b/src/set.c
index 152b81c..53e5db1 100644
--- a/src/set.c
+++ b/src/set.c
@@ -377,7 +377,7 @@ int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
 	if (nft_jansson_node_exist(root, "data_type")) {
 		if (nft_jansson_parse_val(root, "data_type", NFT_TYPE_U32,
 					  &uval32, err) < 0)
-			goto err;
+			return -1;
 
 		nft_set_attr_set_u32(s, NFT_SET_ATTR_DATA_TYPE, uval32);
 	}
@@ -385,7 +385,7 @@ int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
 	if (nft_jansson_node_exist(root, "data_len")) {
 		if (nft_jansson_parse_val(root, "data_len", NFT_TYPE_U32,
 					  &uval32, err) < 0)
-			goto err;
+			return -1;
 
 		nft_set_attr_set_u32(s, NFT_SET_ATTR_DATA_LEN, uval32);
 	}
@@ -395,27 +395,22 @@ int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
 		for (i = 0; i < json_array_size(array); i++) {
 			elem = nft_set_elem_alloc();
 			if (elem == NULL)
-				goto err;
+				return -1;
 
 			json_elem = json_array_get(array, i);
 			if (json_elem == NULL)
-				goto err;
+				return -1;
 
 			if (nft_jansson_set_elem_parse(elem,
 						       json_elem, err) < 0)
-				goto err;
+				return -1;
 
 			list_add_tail(&elem->head, &s->element_list);
 		}
 
 	}
 
-	nft_jansson_free_root(tree);
 	return 0;
-err:
-	nft_jansson_free_root(tree);
-	return -1;
-
 }
 #endif
 
@@ -426,12 +421,16 @@ static int nft_set_json_parse(struct nft_set *s, const void *json,
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
+	int ret;
 
 	tree = nft_jansson_create_root(json, &error, err, input);
 	if (tree == NULL)
 		return -1;
 
-	return nft_jansson_parse_set(s, tree, err);
+	ret = nft_jansson_parse_set(s, tree, err);
+	nft_jansson_free_root(tree);
+
+	return ret;
 #else
 	errno = EOPNOTSUPP;
 	return -1;
-- 
2.0.0

