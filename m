From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 5/6] src: chain: Rename variables in nft_jansson_parse_chain functions
Date: Thu, 26 Jun 2014 18:38:59 +0200
Message-ID: <1403800740-10572-6-git-send-email-anarey@gmail.com>
References: <1403800740-10572-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48042 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbaFZQj0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:39:26 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so3938508wgh.23
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2014 09:39:23 -0700 (PDT)
In-Reply-To: <1403800740-10572-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Renames some variables for code readability reasons.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/chain.c | 64 ++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 2a39985..042ff13 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -565,90 +565,90 @@ int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree,
 			    struct nft_parse_err *err)
 {
 	json_t *root;
-	uint64_t uval64;
-	int policy;
-	int32_t val32, use;
-	const char *valstr;
+	uint64_t handle, bytes, packets;
+	int policy_num;
+	int32_t family, prio, hooknum, use;
+	const char *name, *table, *type, *hooknum_str, *policy;
 
 	root = nft_jansson_get_node(tree, "chain", err);
 	if (root == NULL)
 		return -1;
 
-	valstr = nft_jansson_parse_str(root, "name", err);
-	if (valstr == NULL)
+	name = nft_jansson_parse_str(root, "name", err);
+	if (name == NULL)
 		return -1;
 
-	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_NAME, valstr);
+	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_NAME, name);
 
-	if (nft_jansson_parse_val(root, "handle", NFT_TYPE_U64, &uval64,
+	if (nft_jansson_parse_val(root, "handle", NFT_TYPE_U64, &handle,
 				  err) < 0)
 		return -1;
 
-	nft_chain_attr_set_u64(c,NFT_CHAIN_ATTR_HANDLE, uval64);
+	nft_chain_attr_set_u64(c,NFT_CHAIN_ATTR_HANDLE, handle);
 
-	if (nft_jansson_parse_val(root, "bytes", NFT_TYPE_U64, &uval64,
+	if (nft_jansson_parse_val(root, "bytes", NFT_TYPE_U64, &bytes,
 				  err) < 0)
 		return -1;
 
-	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_BYTES, uval64);
+	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_BYTES, bytes);
 
-	if (nft_jansson_parse_val(root, "packets", NFT_TYPE_U64, &uval64,
+	if (nft_jansson_parse_val(root, "packets", NFT_TYPE_U64, &packets,
 				  err) < 0)
 		return -1;
 
-	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_PACKETS, uval64);
+	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_PACKETS, packets);
 
-	if (nft_jansson_parse_family(root, &val32, err) != 0)
+	if (nft_jansson_parse_family(root, &family, err) != 0)
 		return -1;
 
-	nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_FAMILY, val32);
+	nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_FAMILY, family);
 
-	valstr = nft_jansson_parse_str(root, "table", err);
+	table = nft_jansson_parse_str(root, "table", err);
 
-	if (valstr == NULL)
+	if (table == NULL)
 		return -1;
 
-	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TABLE, valstr);
+	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TABLE, table);
 
 	if (nft_jansson_parse_val(root, "use", NFT_TYPE_U32, &use, err) == 0)
 		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_USE, use);
 
 	if (nft_jansson_node_exist(root, "hooknum")) {
-		valstr = nft_jansson_parse_str(root, "type", err);
+		type = nft_jansson_parse_str(root, "type", err);
 
-		if (valstr == NULL)
+		if (type == NULL)
 			return -1;
 
-		nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TYPE, valstr);
+		nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TYPE, type);
 
 		if (nft_jansson_parse_val(root, "prio", NFT_TYPE_S32,
-					  &val32, err) < 0)
+					  &prio, err) < 0)
 			return -1;
 
-		nft_chain_attr_set_s32(c, NFT_CHAIN_ATTR_PRIO, val32);
+		nft_chain_attr_set_s32(c, NFT_CHAIN_ATTR_PRIO, prio);
 
-		valstr = nft_jansson_parse_str(root, "hooknum", err);
-		if (valstr == NULL)
+		hooknum_str = nft_jansson_parse_str(root, "hooknum", err);
+		if (hooknum_str == NULL)
 			return -1;
 
-		val32 = nft_str2hooknum(c->family, valstr);
-		if (val32 == -1)
+		hooknum = nft_str2hooknum(c->family, hooknum_str);
+		if (hooknum == -1)
 			return -1;
 
-		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_HOOKNUM, val32);
+		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_HOOKNUM, hooknum);
 
-		valstr = nft_jansson_parse_str(root, "policy", err);
-		if (valstr == NULL)
+		policy = nft_jansson_parse_str(root, "policy", err);
+		if (policy == NULL)
 			return -1;
 
-		if (nft_str2verdict(valstr, &policy) != 0) {
+		if (nft_str2verdict(policy, &policy_num) != 0) {
 			errno = EINVAL;
 			err->node_name = "policy";
 			err->error = NFT_PARSE_EBADTYPE;
 			return -1;
 		}
 
-		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_POLICY, policy);
+		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_POLICY, policy_num);
 	}
 
 	return 0;
-- 
2.0.0

