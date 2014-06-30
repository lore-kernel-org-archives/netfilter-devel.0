From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH v2 1/4] src: chain: Add all support of use attribute
Date: Mon, 30 Jun 2014 13:50:05 +0200
Message-ID: <1404129008-29564-2-git-send-email-anarey@gmail.com>
References: <1404129008-29564-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:41254 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaF3Lu0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:50:26 -0400
Received: by mail-we0-f171.google.com with SMTP id q58so7993219wes.16
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Jun 2014 04:50:24 -0700 (PDT)
In-Reply-To: <1404129008-29564-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add set, unset, get, parse and build payload implementation for use value.

These changes are neeeded for a correct import/export of xml/json file

Signed-off-by: Ana Rey <anarey@gmail.com>
---
[Changes in v2:]

I add a xml support for 'use' attribute that I did not add in v1

Moreover, I improve the subject and description of this patch

 src/chain.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 9e9f207..ea7bc56 100644
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
 
@@ -681,7 +685,7 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
 {
 	const char *table, *name, *hooknum_str, *policy_str, *type;
 	int family, hooknum, policy;
-	uint64_t handle, bytes, packets, prio;
+	uint64_t handle, bytes, packets, prio, use;
 
 	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
 				  NFT_XML_MAND, err);
@@ -711,6 +715,10 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
 		return -1;
 	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TABLE, table);
 
+	if (nft_mxml_num_parse(tree, "use", MXML_DESCEND_FIRST, BASE_DEC,
+			       &use, NFT_TYPE_U64, NFT_XML_MAND, err) == 0)
+		nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_PACKETS, use);
+
 	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
 				       NFT_XML_MAND, err);
 	if (family < 0)
@@ -860,6 +868,10 @@ static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 		       c->name, c->handle, c->bytes, c->packets, c->table);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	if (c->flags & (1 << NFT_CHAIN_ATTR_USE)) {
+		ret = snprintf(buf + offset, len, "<use>%u</use>", c->use);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 	if (c->flags & (1 << NFT_CHAIN_ATTR_HOOKNUM)) {
 		ret =  snprintf(buf+offset, len,
 				"<type>%s</type>"
-- 
2.0.0

