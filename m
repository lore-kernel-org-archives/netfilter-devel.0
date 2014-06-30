From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH v2 4/4] src: chain: Do not print unser values in json
Date: Mon, 30 Jun 2014 13:50:08 +0200
Message-ID: <1404129008-29564-5-git-send-email-anarey@gmail.com>
References: <1404129008-29564-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:36648 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbaF3Lua (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:50:30 -0400
Received: by mail-we0-f175.google.com with SMTP id k48so8111302wev.20
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Jun 2014 04:50:29 -0700 (PDT)
In-Reply-To: <1404129008-29564-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and snprintf functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/chain.c | 166 ++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 95 insertions(+), 71 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index a3872a0..ad9da51 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -575,40 +575,28 @@ int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree,
 		return -1;
 
 	name = nft_jansson_parse_str(root, "name", err);
-	if (name == NULL)
-		return -1;
-
-	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_NAME, name);
+	if (name != NULL)
+		nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_NAME, name);
 
 	if (nft_jansson_parse_val(root, "handle", NFT_TYPE_U64, &handle,
-				  err) < 0)
-		return -1;
-
-	nft_chain_attr_set_u64(c,NFT_CHAIN_ATTR_HANDLE, handle);
+				  err) == 0)
+		nft_chain_attr_set_u64(c,NFT_CHAIN_ATTR_HANDLE, handle);
 
 	if (nft_jansson_parse_val(root, "bytes", NFT_TYPE_U64, &bytes,
-				  err) < 0)
-		return -1;
-
-	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_BYTES, bytes);
+				  err) == 0)
+		nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_BYTES, bytes);
 
 	if (nft_jansson_parse_val(root, "packets", NFT_TYPE_U64, &packets,
-				  err) < 0)
-		return -1;
-
-	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_PACKETS, packets);
-
-	if (nft_jansson_parse_family(root, &family, err) != 0)
-		return -1;
+				  err) == 0)
+		nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_PACKETS, packets);
 
-	nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_FAMILY, family);
+	if (nft_jansson_parse_family(root, &family, err) == 0)
+		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_FAMILY, family);
 
 	table = nft_jansson_parse_str(root, "table", err);
 
-	if (table == NULL)
-		return -1;
-
-	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TABLE, table);
+	if (table != NULL)
+		nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TABLE, table);
 
 	if (nft_jansson_parse_val(root, "use", NFT_TYPE_U32, &use, err) == 0)
 		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_USE, use);
@@ -616,39 +604,33 @@ int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree,
 	if (nft_jansson_node_exist(root, "hooknum")) {
 		type = nft_jansson_parse_str(root, "type", err);
 
-		if (type == NULL)
-			return -1;
-
-		nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TYPE, type);
+		if (type != NULL)
+			nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TYPE, type);
 
 		if (nft_jansson_parse_val(root, "prio", NFT_TYPE_S32,
-					  &prio, err) < 0)
-			return -1;
-
-		nft_chain_attr_set_s32(c, NFT_CHAIN_ATTR_PRIO, prio);
+					  &prio, err) == 0)
+			nft_chain_attr_set_s32(c, NFT_CHAIN_ATTR_PRIO, prio);
 
 		hooknum_str = nft_jansson_parse_str(root, "hooknum", err);
-		if (hooknum_str == NULL)
-			return -1;
-
-		hooknum = nft_str2hooknum(c->family, hooknum_str);
-		if (hooknum == -1)
-			return -1;
-
-		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_HOOKNUM, hooknum);
+		if (hooknum_str != NULL) {
+			hooknum = nft_str2hooknum(c->family, hooknum_str);
+			if (hooknum == -1)
+				return -1;
+			nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_HOOKNUM,
+					       hooknum);
+		}
 
 		policy = nft_jansson_parse_str(root, "policy", err);
-		if (policy == NULL)
-			return -1;
-
-		if (nft_str2verdict(policy, &policy_num) != 0) {
-			errno = EINVAL;
-			err->node_name = "policy";
-			err->error = NFT_PARSE_EBADTYPE;
-			return -1;
+		if (policy != NULL) {
+			if (nft_str2verdict(policy, &policy_num) != 0) {
+				errno = EINVAL;
+				err->node_name = "policy";
+				err->error = NFT_PARSE_EBADTYPE;
+				return -1;
+			}
+			nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_POLICY,
+					       policy_num);
 		}
-
-		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_POLICY, policy_num);
 	}
 
 	return 0;
@@ -821,32 +803,74 @@ static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
 {
 	int ret, len = size, offset = 0;
 
-	ret = snprintf(buf, len,
-			"{\"chain\":{"
-			"\"name\":\"%s\","
-			"\"handle\":%"PRIu64","
-			"\"bytes\":%"PRIu64","
-			"\"packets\":%"PRIu64","
-			"\"family\":\"%s\","
-			"\"table\":\"%s\","
-			"\"use\":%d",
-			c->name, c->handle, c->bytes, c->packets,
-			nft_family2str(c->family),
-			c->table, c->use);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf, len, "{\"chain\":{");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = 0;
 
+	if (c->flags & (1 << NFT_CHAIN_ATTR_NAME)) {
+		ret = snprintf(buf + offset, len, "\"name\":\"%s\",", c->name);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (c->flags & (1 << NFT_CHAIN_ATTR_HANDLE)) {
+		ret = snprintf(buf + offset, len, "\"handle\":%"PRIu64",",
+			       c->handle);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (c->flags & (1 << NFT_CHAIN_ATTR_BYTES)) {
+		ret = snprintf(buf + offset, len, "\"bytes\":%"PRIu64",",
+			       c->bytes);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (c->flags & (1 << NFT_CHAIN_ATTR_PACKETS)) {
+		ret = snprintf(buf + offset, len, "\"packets\":%"PRIu64",",
+			       c->packets);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (c->flags & (1 << NFT_CHAIN_ATTR_FAMILY)) {
+		ret = snprintf(buf + offset, len, "\"family\":\"%s\",",
+			       nft_family2str(c->family));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (c->flags & (1 << NFT_CHAIN_ATTR_FAMILY)) {
+		ret = snprintf(buf + offset, len, "\"table\":\"%s\",",
+			       c->table);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (c->flags & (1 << NFT_CHAIN_ATTR_USE)) {
+		ret = snprintf(buf + offset, len, "\"use\":%d,", c->use);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 	if (c->flags & (1 << NFT_CHAIN_ATTR_HOOKNUM)) {
-		ret =  snprintf(buf+offset, len,
-				",\"type\":\"%s\","
-				"\"hooknum\":\"%s\","
-				"\"prio\":%d,"
-				"\"policy\":\"%s\"",
-			c->type, nft_hooknum2str(c->family, c->hooknum),
-			c->prio, nft_verdict2str(c->policy));
+		if (c->flags & (1 << NFT_CHAIN_ATTR_TYPE)) {
+			ret = snprintf(buf + offset, len, "\"type\":\"%s\",",
+				       c->type);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+
+		ret = snprintf(buf + offset, len, "\"hooknum\":\"%s\",",
+			       nft_hooknum2str(c->family, c->hooknum));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		if (c->flags & (1 << NFT_CHAIN_ATTR_PRIO)) {
+			ret = snprintf(buf + offset, len, "\"prio\":%d,",
+				       c->prio);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+		if (c->flags & (1 << NFT_CHAIN_ATTR_POLICY)) {
+			ret = snprintf(buf + offset, len, "\"policy\":\"%s\",",
+				       nft_verdict2str(c->policy));
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
 	}
 
-	ret = snprintf(buf+offset, len, "}}");
+	/* If ret is not 0, some values are printed. So, It's necessary to
+	 * delete the last comma character
+	 */
+	if (ret > 0)
+		offset--;
+
+	ret = snprintf(buf + offset, len, "}}");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
-- 
2.0.0

