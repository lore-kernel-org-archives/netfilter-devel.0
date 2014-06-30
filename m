From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH v2 2/4] src: chain: Do not print unset values in xml
Date: Mon, 30 Jun 2014 13:50:06 +0200
Message-ID: <1404129008-29564-3-git-send-email-anarey@gmail.com>
References: <1404129008-29564-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:37654 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbaF3Lu2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:50:28 -0400
Received: by mail-wg0-f46.google.com with SMTP id y10so7990052wgg.5
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Jun 2014 04:50:26 -0700 (PDT)
In-Reply-To: <1404129008-29564-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and snprintf functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/chain.c | 123 +++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 77 insertions(+), 46 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index ea7bc56..983c91e 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -689,31 +689,27 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
 
 	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
 				  NFT_XML_MAND, err);
-	if (name == NULL)
-		return -1;
-	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_NAME, name);
+	if (name != NULL)
+		nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_NAME, name);
 
 	if (nft_mxml_num_parse(tree, "handle", MXML_DESCEND_FIRST, BASE_DEC,
-			       &handle, NFT_TYPE_U64, NFT_XML_MAND, err) != 0)
-		return -1;
-	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_HANDLE, handle);
+			       &handle, NFT_TYPE_U64, NFT_XML_MAND, err) == 0)
+		nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_HANDLE, handle);
 
 	if (nft_mxml_num_parse(tree, "bytes", MXML_DESCEND_FIRST, BASE_DEC,
-			       &bytes, NFT_TYPE_U64, NFT_XML_MAND, err) != 0)
-		return -1;
-	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_BYTES, bytes);
+			       &bytes, NFT_TYPE_U64, NFT_XML_MAND, err) == 0)
+		nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_BYTES, bytes);
 
 
 	if (nft_mxml_num_parse(tree, "packets", MXML_DESCEND_FIRST, BASE_DEC,
-			       &packets, NFT_TYPE_U64, NFT_XML_MAND, err) != 0)
-		return -1;
-	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_PACKETS, packets);
+			       &packets, NFT_TYPE_U64, NFT_XML_MAND, err) == 0)
+		nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_PACKETS, packets);
 
 	table = nft_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST,
 				   NFT_XML_MAND, err);
-	if (table == NULL)
-		return -1;
-	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TABLE, table);
+
+	if (table != NULL)
+		nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TABLE, table);
 
 	if (nft_mxml_num_parse(tree, "use", MXML_DESCEND_FIRST, BASE_DEC,
 			       &use, NFT_TYPE_U64, NFT_XML_MAND, err) == 0)
@@ -721,9 +717,8 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
 
 	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
 				       NFT_XML_MAND, err);
-	if (family < 0)
-		return -1;
-	nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_FAMILY, family);
+	if (family >= 0)
+		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_FAMILY, family);
 
 	hooknum_str = nft_mxml_str_parse(tree, "hooknum", MXML_DESCEND_FIRST,
 					 NFT_XML_OPT, err);
@@ -735,29 +730,28 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
 
 		type = nft_mxml_str_parse(tree, "type", MXML_DESCEND_FIRST,
 					  NFT_XML_MAND, err);
-		if (type == NULL)
-			return -1;
-		nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TYPE, type);
+
+		if (type != NULL)
+			nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TYPE, type);
 
 		if (nft_mxml_num_parse(tree, "prio", MXML_DESCEND, BASE_DEC,
 				       &prio, NFT_TYPE_S32, NFT_XML_MAND,
-				       err) != 0)
-			return -1;
-		nft_chain_attr_set_s32(c, NFT_CHAIN_ATTR_PRIO, prio);
+				       err) == 0)
+			nft_chain_attr_set_s32(c, NFT_CHAIN_ATTR_PRIO, prio);
 
 		policy_str = nft_mxml_str_parse(tree, "policy",
 						MXML_DESCEND_FIRST,
 						NFT_XML_MAND, err);
-		if (policy_str == NULL)
-			return -1;
-
-		if (nft_str2verdict(policy_str, &policy) != 0) {
-			errno = EINVAL;
-			err->node_name = "policy";
-			err->error = NFT_PARSE_EBADTYPE;
-			return -1;
+		if (policy_str != NULL) {
+			if (nft_str2verdict(policy_str, &policy) != 0) {
+				errno = EINVAL;
+				err->node_name = "policy";
+				err->error = NFT_PARSE_EBADTYPE;
+				return -1;
+			}
+			nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_POLICY,
+					       policy);
 		}
-		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_POLICY, policy);
 	}
 
 	return 0;
@@ -862,29 +856,66 @@ static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 {
 	int ret, len = size, offset = 0;
 
-	ret = snprintf(buf, len, "<chain><name>%s</name>"
-		       "<handle>%"PRIu64"</handle><bytes>%"PRIu64"</bytes>"
-		       "<packets>%"PRIu64"</packets><table>%s</table>",
-		       c->name, c->handle, c->bytes, c->packets, c->table);
+	ret = snprintf(buf, len, "<chain>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	if (c->flags & (1 << NFT_CHAIN_ATTR_NAME)) {
+		ret = snprintf(buf + offset, len, "<name>%s</name>", c->name);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (c->flags & (1 << NFT_CHAIN_ATTR_HANDLE)) {
+		ret = snprintf(buf + offset, len, "<handle>%"PRIu64"</handle>",
+			       c->handle);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (c->flags & (1 << NFT_CHAIN_ATTR_BYTES)) {
+		ret = snprintf(buf + offset, len, "<bytes>%"PRIu64"</bytes>",
+			       c->bytes);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (c->flags & (1 << NFT_CHAIN_ATTR_PACKETS)) {
+		ret = snprintf(buf + offset, len, "<packets>%"PRIu64"</packets>",
+			       c->packets);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (c->flags & (1 << NFT_CHAIN_ATTR_TABLE)) {
+		ret = snprintf(buf + offset, len, "<table>%s</table>",
+			       c->table);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 	if (c->flags & (1 << NFT_CHAIN_ATTR_USE)) {
 		ret = snprintf(buf + offset, len, "<use>%u</use>", c->use);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 	if (c->flags & (1 << NFT_CHAIN_ATTR_HOOKNUM)) {
-		ret =  snprintf(buf+offset, len,
-				"<type>%s</type>"
-				"<hooknum>%s</hooknum>"
-				"<prio>%d</prio>"
-				"<policy>%s</policy>",
-			c->type, nft_hooknum2str(c->family, c->hooknum),
-			c->prio, nft_verdict2str(c->policy));
+		if (c->flags & (1 << NFT_CHAIN_ATTR_TYPE)) {
+			ret = snprintf(buf + offset, len, "<type>%s</type>",
+				       c->type);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+
+		ret = snprintf(buf + offset, len, "<hooknum>%s</hooknum>",
+			       nft_hooknum2str(c->family, c->hooknum));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		if (c->flags & (1 << NFT_CHAIN_ATTR_PRIO)) {
+			ret = snprintf(buf + offset, len, "<prio>%d</prio>",
+				       c->prio);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+		if (c->flags & (1 << NFT_CHAIN_ATTR_POLICY)) {
+			ret = snprintf(buf + offset, len, "<policy>%s</policy>",
+				       nft_verdict2str(c->policy));
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+	}
+	if (c->flags & (1 << NFT_CHAIN_ATTR_FAMILY)) {
+		ret = snprintf(buf + offset, len, "<family>%s</family>",
+			       nft_family2str(c->family));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	ret = snprintf(buf+offset, len, "<family>%s</family></chain>",
-		       nft_family2str(c->family));
+	ret = snprintf(buf + offset, len, "</chain>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
-- 
2.0.0

