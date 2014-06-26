From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/6] src: chain: add set, unset, get, parse and build payload implementation for use value
Date: Thu, 26 Jun 2014 18:38:57 +0200
Message-ID: <1403800740-10572-4-git-send-email-anarey@gmail.com>
References: <1403800740-10572-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:52043 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbaFZQjX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:39:23 -0400
Received: by mail-wi0-f179.google.com with SMTP id cc10so1415419wib.0
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2014 09:39:20 -0700 (PDT)
In-Reply-To: <1403800740-10572-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add some parts of the implemention of 'use' vualue in chain that miss it.

These changes are neeeded for a correct import/export of xml/json file

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/chain.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 9e9f207..f01abb9 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -115,8 +115,7 @@ void nft_chain_attr_unset(struct nft_chain *c, uint16_t attr)
 		}
 		break;
 	case NFT_CHAIN_ATTR_USE:
-		/* cannot be unset?, ignore it */
-		return;
+		break;
 	case NFT_CHAIN_ATTR_TYPE:
 		if (c->type) {
 			xfree(c->type);
@@ -178,8 +177,8 @@ void nft_chain_attr_set_data(struct nft_chain *c, uint16_t attr,
 		c->policy = *((uint32_t *)data);
 		break;
 	case NFT_CHAIN_ATTR_USE:
-		/* cannot be set, ignore it */
-		return;
+		c->use = *((uint32_t *)data);
+		break;
 	case NFT_CHAIN_ATTR_BYTES:
 		c->bytes = *((uint64_t *)data);
 		break;
@@ -356,6 +355,8 @@ void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain
 	}
 	if (c->flags & (1 << NFT_CHAIN_ATTR_POLICY))
 		mnl_attr_put_u32(nlh, NFTA_CHAIN_POLICY, htonl(c->policy));
+	if (c->flags & (1 << NFT_CHAIN_ATTR_USE))
+		mnl_attr_put_u32(nlh, NFTA_CHAIN_USE, htonl(c->use));
 	if ((c->flags & (1 << NFT_CHAIN_ATTR_PACKETS)) &&
 	    (c->flags & (1 << NFT_CHAIN_ATTR_BYTES))) {
 		struct nlattr *nest;
@@ -566,7 +567,7 @@ int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree,
 	json_t *root;
 	uint64_t uval64;
 	int policy;
-	int32_t val32;
+	int32_t val32, use;
 	const char *valstr;
 
 	root = nft_jansson_get_node(tree, "chain", err);
@@ -609,6 +610,9 @@ int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree,
 
 	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TABLE, valstr);
 
+	if (nft_jansson_parse_val(root, "use", NFT_TYPE_U32, &use, err) == 0)
+		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_USE, use);
+
 	if (nft_jansson_node_exist(root, "hooknum")) {
 		valstr = nft_jansson_parse_str(root, "type", err);
 
-- 
2.0.0

