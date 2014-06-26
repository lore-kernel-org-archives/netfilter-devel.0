From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 5/5] src: table: Do not print unset values in json file
Date: Thu, 26 Jun 2014 19:08:41 +0200
Message-ID: <1403802521-12571-6-git-send-email-anarey@gmail.com>
References: <1403802521-12571-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63411 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431AbaFZRJC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:09:02 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so1443190wib.1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2014 10:08:58 -0700 (PDT)
In-Reply-To: <1403802521-12571-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and snprintf functions to omit unset values.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/table.c | 64 ++++++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 22 deletions(-)

diff --git a/src/table.c b/src/table.c
index 7874245..abbaa52 100644
--- a/src/table.c
+++ b/src/table.c
@@ -319,20 +319,15 @@ int nft_jansson_parse_table(struct nft_table *t, json_t *tree,
 		return -1;
 
 	str = nft_jansson_parse_str(root, "name", err);
-	if (str == NULL)
-		return -1;
-
-	nft_table_attr_set_str(t, NFT_TABLE_ATTR_NAME, str);
-
-	if (nft_jansson_parse_family(root, &family, err) != 0)
-		return -1;
-
-	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FAMILY, family);
+	if (str != NULL)
+		nft_table_attr_set_str(t, NFT_TABLE_ATTR_NAME, str);
 
-	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &flags, err) < 0)
-		return -1;
+	if (nft_jansson_parse_family(root, &family, err) == 0)
+		nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FAMILY, family);
 
-	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FLAGS, flags);
+	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &flags,
+				  err) == 0)
+		nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FLAGS, flags);
 
 	if (nft_jansson_parse_val(root, "use", NFT_TYPE_U32, &use, err) == 0)
 		nft_table_attr_set_u32(t, NFT_TABLE_ATTR_USE, use);
@@ -407,16 +402,41 @@ EXPORT_SYMBOL(nft_table_parse_file);
 
 static int nft_table_snprintf_json(char *buf, size_t size, struct nft_table *t)
 {
-	return snprintf(buf, size,
-			"{\"table\":{"
-			"\"name\":\"%s\","
-			"\"family\":\"%s\","
-			"\"flags\":%d,"
-			"\"use\":%d"
-			"}"
-			"}" ,
-			t->name, nft_family2str(t->family),
-			t->table_flags, t->use);
+	int ret, len = size, offset = 0;
+
+	ret = snprintf(buf, size, "{\"table\":{");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = 0;
+
+	if (t->flags & (1 << NFT_TABLE_ATTR_NAME)) {
+		ret = snprintf(buf + offset, size, "\"name\":\"%s\",", t->name);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (t->flags & (1 << NFT_TABLE_ATTR_FAMILY)) {
+		ret = snprintf(buf + offset, size, "\"family\":\"%s\",",
+			       nft_family2str(t->family));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (t->flags & (1 << NFT_TABLE_ATTR_FLAGS)) {
+		ret = snprintf(buf + offset, size, "\"flags\":%u,",
+			       t->table_flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (t->flags & (1 << NFT_TABLE_ATTR_USE)) {
+		ret = snprintf(buf + offset, size, "\"use\":%u,", t->use);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	/* If  some values is set, ret is not 0. So, It's needed to remove the
+	 * last comma characther
+	 */
+	if (ret > 0)
+		offset--;
+
+	ret = snprintf(buf + offset, size, "}}");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
 }
 
 static int nft_table_snprintf_xml(char *buf, size_t size, struct nft_table *t)
-- 
2.0.0

