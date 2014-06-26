From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/6] src: chain: Use nft_rule_expr_set_* in the xml parsing code
Date: Thu, 26 Jun 2014 18:38:56 +0200
Message-ID: <1403800740-10572-3-git-send-email-anarey@gmail.com>
References: <1403800740-10572-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:55353 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbaFZQjV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:39:21 -0400
Received: by mail-we0-f180.google.com with SMTP id x48so3942669wes.25
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2014 09:39:18 -0700 (PDT)
In-Reply-To: <1403800740-10572-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_set_* in parse functions.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/chain.c | 53 ++++++++++++++++-------------------------------------
 1 file changed, 16 insertions(+), 37 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index b7e1c5e..9e9f207 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -681,51 +681,41 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
 {
 	const char *table, *name, *hooknum_str, *policy_str, *type;
 	int family, hooknum, policy;
+	uint64_t handle, bytes, packets, prio;
 
 	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
 				  NFT_XML_MAND, err);
 	if (name == NULL)
 		return -1;
-
-	strncpy(c->name, name, NFT_CHAIN_MAXNAMELEN);
-	c->flags |= (1 << NFT_CHAIN_ATTR_NAME);
+	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_NAME, name);
 
 	if (nft_mxml_num_parse(tree, "handle", MXML_DESCEND_FIRST, BASE_DEC,
-			       &c->handle, NFT_TYPE_U64, NFT_XML_MAND, err) != 0)
+			       &handle, NFT_TYPE_U64, NFT_XML_MAND, err) != 0)
 		return -1;
-
-	c->flags |= (1 << NFT_CHAIN_ATTR_HANDLE);
+	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_HANDLE, handle);
 
 	if (nft_mxml_num_parse(tree, "bytes", MXML_DESCEND_FIRST, BASE_DEC,
-			       &c->bytes, NFT_TYPE_U64, NFT_XML_MAND, err) != 0)
+			       &bytes, NFT_TYPE_U64, NFT_XML_MAND, err) != 0)
 		return -1;
+	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_BYTES, bytes);
 
-	c->flags |= (1 << NFT_CHAIN_ATTR_BYTES);
 
 	if (nft_mxml_num_parse(tree, "packets", MXML_DESCEND_FIRST, BASE_DEC,
-			       &c->packets, NFT_TYPE_U64, NFT_XML_MAND, err) != 0)
+			       &packets, NFT_TYPE_U64, NFT_XML_MAND, err) != 0)
 		return -1;
-
-	c->flags |= (1 << NFT_CHAIN_ATTR_PACKETS);
+	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_PACKETS, packets);
 
 	table = nft_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST,
 				   NFT_XML_MAND, err);
 	if (table == NULL)
 		return -1;
-
-	if (c->table)
-		xfree(c->table);
-
-	c->table = strdup(table);
-	c->flags |= (1 << NFT_CHAIN_ATTR_TABLE);
+	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TABLE, table);
 
 	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
 				       NFT_XML_MAND, err);
 	if (family < 0)
 		return -1;
-
-	c->family = family;
-	c->flags |= (1 << NFT_CHAIN_ATTR_FAMILY);
+	nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_FAMILY, family);
 
 	hooknum_str = nft_mxml_str_parse(tree, "hooknum", MXML_DESCEND_FIRST,
 					 NFT_XML_OPT, err);
@@ -733,28 +723,19 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
 		hooknum = nft_str2hooknum(c->family, hooknum_str);
 		if (hooknum < 0)
 			return -1;
-
-		c->hooknum = hooknum;
-		c->flags |= (1 << NFT_CHAIN_ATTR_HOOKNUM);
+		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_HOOKNUM, hooknum);
 
 		type = nft_mxml_str_parse(tree, "type", MXML_DESCEND_FIRST,
 					  NFT_XML_MAND, err);
 		if (type == NULL)
 			return -1;
-
-		if (c->type)
-			xfree(c->type);
-
-		c->type = strdup(type);
-		c->flags |= (1 << NFT_CHAIN_ATTR_TYPE);
-
+		nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TYPE, type);
 
 		if (nft_mxml_num_parse(tree, "prio", MXML_DESCEND, BASE_DEC,
-				       &c->prio, NFT_TYPE_S32,
-				       NFT_XML_MAND, err) != 0)
+				       &prio, NFT_TYPE_S32, NFT_XML_MAND,
+				       err) != 0)
 			return -1;
-
-		c->flags |= (1 << NFT_CHAIN_ATTR_PRIO);
+		nft_chain_attr_set_s32(c, NFT_CHAIN_ATTR_PRIO, prio);
 
 		policy_str = nft_mxml_str_parse(tree, "policy",
 						MXML_DESCEND_FIRST,
@@ -768,9 +749,7 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
 			err->error = NFT_PARSE_EBADTYPE;
 			return -1;
 		}
-
-		c->policy = policy;
-		c->flags |= (1 << NFT_CHAIN_ATTR_POLICY);
+		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_POLICY, policy);
 	}
 
 	return 0;
-- 
2.0.0

