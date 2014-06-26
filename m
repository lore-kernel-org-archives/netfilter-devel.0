From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/6] src: chain: Free memory in the same function that is reserved
Date: Thu, 26 Jun 2014 18:38:55 +0200
Message-ID: <1403800740-10572-2-git-send-email-anarey@gmail.com>
References: <1403800740-10572-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:37605 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376AbaFZQjU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:39:20 -0400
Received: by mail-we0-f175.google.com with SMTP id k48so3967684wev.34
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2014 09:39:15 -0700 (PDT)
In-Reply-To: <1403800740-10572-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Free memory in the same function that is reserved.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/chain.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 5311af6..b7e1c5e 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -575,37 +575,37 @@ int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree,
 
 	valstr = nft_jansson_parse_str(root, "name", err);
 	if (valstr == NULL)
-		goto err;
+		return -1;
 
 	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_NAME, valstr);
 
 	if (nft_jansson_parse_val(root, "handle", NFT_TYPE_U64, &uval64,
 				  err) < 0)
-		goto err;
+		return -1;
 
 	nft_chain_attr_set_u64(c,NFT_CHAIN_ATTR_HANDLE, uval64);
 
 	if (nft_jansson_parse_val(root, "bytes", NFT_TYPE_U64, &uval64,
 				  err) < 0)
-		goto err;
+		return -1;
 
 	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_BYTES, uval64);
 
 	if (nft_jansson_parse_val(root, "packets", NFT_TYPE_U64, &uval64,
 				  err) < 0)
-		goto err;
+		return -1;
 
 	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_PACKETS, uval64);
 
 	if (nft_jansson_parse_family(root, &val32, err) != 0)
-		goto err;
+		return -1;
 
 	nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_FAMILY, val32);
 
 	valstr = nft_jansson_parse_str(root, "table", err);
 
 	if (valstr == NULL)
-		goto err;
+		return -1;
 
 	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TABLE, valstr);
 
@@ -613,46 +613,41 @@ int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree,
 		valstr = nft_jansson_parse_str(root, "type", err);
 
 		if (valstr == NULL)
-			goto err;
+			return -1;
 
 		nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TYPE, valstr);
 
 		if (nft_jansson_parse_val(root, "prio", NFT_TYPE_S32,
 					  &val32, err) < 0)
-			goto err;
+			return -1;
 
 		nft_chain_attr_set_s32(c, NFT_CHAIN_ATTR_PRIO, val32);
 
 		valstr = nft_jansson_parse_str(root, "hooknum", err);
 		if (valstr == NULL)
-			goto err;
+			return -1;
 
 		val32 = nft_str2hooknum(c->family, valstr);
 		if (val32 == -1)
-			goto err;
+			return -1;
 
 		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_HOOKNUM, val32);
 
 		valstr = nft_jansson_parse_str(root, "policy", err);
 		if (valstr == NULL)
-			goto err;
+			return -1;
 
 		if (nft_str2verdict(valstr, &policy) != 0) {
 			errno = EINVAL;
 			err->node_name = "policy";
 			err->error = NFT_PARSE_EBADTYPE;
-			goto err;
+			return -1;
 		}
 
 		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_POLICY, policy);
 	}
 
-	nft_jansson_free_root(tree);
 	return 0;
-
-err:
-	nft_jansson_free_root(tree);
-	return -1;
 }
 #endif
 
@@ -663,12 +658,17 @@ static int nft_chain_json_parse(struct nft_chain *c, const void *json,
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
+	int ret;
 
 	tree = nft_jansson_create_root(json, &error, err, input);
 	if (tree == NULL)
 		return -1;
 
-	return nft_jansson_parse_chain(c, tree, err);
+	ret = nft_jansson_parse_chain(c, tree, err);
+
+	nft_jansson_free_root(tree);
+
+	return ret;
 #else
 	errno = EOPNOTSUPP;
 	return -1;
-- 
2.0.0

