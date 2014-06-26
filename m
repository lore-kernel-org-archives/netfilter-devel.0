From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/5] src: table: Use nft_table_attr_set_* in the xml functions
Date: Thu, 26 Jun 2014 19:08:38 +0200
Message-ID: <1403802521-12571-3-git-send-email-anarey@gmail.com>
References: <1403802521-12571-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:57738 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431AbaFZRI7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:08:59 -0400
Received: by mail-wg0-f43.google.com with SMTP id b13so3923758wgh.26
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2014 10:08:54 -0700 (PDT)
In-Reply-To: <1403802521-12571-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_table_attr_set_* in parse xml functions.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/table.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/src/table.c b/src/table.c
index ed6e615..de4a64d 100644
--- a/src/table.c
+++ b/src/table.c
@@ -263,32 +263,24 @@ int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t,
 {
 	const char *name;
 	int family;
+	uint32_t flags;
 
 	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
 				  NFT_XML_MAND, err);
 	if (name == NULL)
 		return -1;
-
-	if (t->name)
-		xfree(t->name);
-
-	t->name = strdup(name);
-	t->flags |= (1 << NFT_TABLE_ATTR_NAME);
+	nft_table_attr_set_str(t, NFT_TABLE_ATTR_NAME, name);
 
 	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
 				       NFT_XML_MAND, err);
 	if (family < 0)
 		return -1;
-
-	t->family = family;
-	t->flags |= (1 << NFT_TABLE_ATTR_FAMILY);
+	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FAMILY, family);
 
 	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND, BASE_DEC,
-			       &t->table_flags, NFT_TYPE_U32,
-			       NFT_XML_MAND, err) != 0)
+			       &flags, NFT_TYPE_U32, NFT_XML_MAND, err) != 0)
 		return -1;
-
-	t->flags |= (1 << NFT_TABLE_ATTR_FLAGS);
+	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FLAGS, flags);
 
 	return 0;
 }
-- 
2.0.0

