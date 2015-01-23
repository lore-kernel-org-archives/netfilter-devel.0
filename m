From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH] set: refactor code in json parse function
Date: Fri, 23 Jan 2015 15:49:51 +0100
Message-ID: <1422024596-8839-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:50802 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbbAWOtl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:49:41 -0500
Received: by mail-we0-f173.google.com with SMTP id w62so8007154wes.4
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2015 06:49:40 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id ev7sm2462989wjb.47.2015.01.23.06.49.39
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Jan 2015 06:49:39 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch refactor code to parse the set in two functions
nft_jansson_parse_set_info and nft_jansson_parse_set. Those changes is used
in follow up patches.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/set.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/src/set.c b/src/set.c
index 61e0632..4fd786a 100644
--- a/src/set.c
+++ b/src/set.c
@@ -410,19 +410,15 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s)
 EXPORT_SYMBOL(nft_set_nlmsg_parse);
 
 #ifdef JSON_PARSING
-int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
-			  struct nft_parse_err *err)
+static int nft_jansson_parse_set_info(struct nft_set *s, json_t *tree,
+				      struct nft_parse_err *err)
 {
-	json_t *root, *array, *json_elem;
+	json_t *root = tree, *array, *json_elem;
 	uint32_t flags, key_type, key_len, data_type, data_len, policy, size;
 	int family, i;
 	const char *name, *table;
 	struct nft_set_elem *elem;
 
-	root = nft_jansson_get_node(tree, "set", err);
-	if (root == NULL)
-		return -1;
-
 	name = nft_jansson_parse_str(root, "name", err);
 	if (name == NULL)
 		return -1;
@@ -503,6 +499,18 @@ int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
 
 	return 0;
 }
+
+int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
+			  struct nft_parse_err *err)
+{
+	json_t *root;
+
+	root = nft_jansson_get_node(tree, "set", err);
+	if (root == NULL)
+		return -1;
+
+	return nft_jansson_parse_set_info(s, root, err);
+}
 #endif
 
 static int nft_set_json_parse(struct nft_set *s, const void *json,
-- 
1.7.10.4

