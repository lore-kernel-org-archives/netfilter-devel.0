From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH v2] ruleset: fix a leak when we use the set lists
Date: Wed, 11 Feb 2015 22:12:22 +0100
Message-ID: <1423689142-6300-2-git-send-email-alvaroneay@gmail.com>
References: <1423689142-6300-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:46649 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbbBKVML (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2015 16:12:11 -0500
Received: by mail-we0-f181.google.com with SMTP id w62so6063109wes.12
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2015 13:12:10 -0800 (PST)
Received: from localhost.localdomain ([77.231.217.97])
        by mx.google.com with ESMTPSA id hz9sm2881698wjb.17.2015.02.11.13.12.08
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Feb 2015 13:12:09 -0800 (PST)
In-Reply-To: <1423689142-6300-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

==18632== 285 (16 direct, 269 indirect) bytes in 1 blocks are definitely lost in
loss record 6 of 6
==18632==    at 0x4C272B8: calloc (vg_replace_malloc.c:566)
==18632==    by 0x5043822: nft_set_list_alloc (set.c:977)
==18632==    by 0x5045483: nft_ruleset_json_parse (ruleset.c:442)
==18632==    by 0x50458BE: nft_ruleset_do_parse (ruleset.c:696)
==18632==    by 0x408AEC: do_command (rule.c:1317)
==18632==    by 0x406B05: nft_run (main.c:194)
==18632==    by 0x40667C: main (main.c:360)

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v2]
 * Reworked the description. Removed overelaborate info.
 * Fixed leaks in error path.

 src/ruleset.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/src/ruleset.c b/src/ruleset.c
index 15e84cf..f5b6d55 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -439,10 +439,6 @@ static int nft_ruleset_json_parse_ruleset(struct nft_parse_ctx *ctx,
 	json_t *node, *array = ctx->json;
 	int len, i, ret;
 
-	ctx->set_list = nft_set_list_alloc();
-	if (ctx->set_list == NULL)
-		return -1;
-
 	len = json_array_size(array);
 	for (i = 0; i < len; i++) {
 		node = json_array_get(array, i);
@@ -525,12 +521,16 @@ static int nft_ruleset_json_parse(const void *json,
 	ctx.cb = cb;
 	ctx.format = type;
 
+	ctx.set_list = nft_set_list_alloc();
+	if (ctx.set_list == NULL)
+		return -1;
+
 	if (arg != NULL)
 		nft_ruleset_ctx_set(&ctx, NFT_RULESET_CTX_DATA, arg);
 
 	root = nft_jansson_create_root(json, &error, err, input);
 	if (root == NULL)
-		return -1;
+		goto err;
 
 	array = json_object_get(root, "nftables");
 	if (array == NULL) {
@@ -554,9 +554,11 @@ static int nft_ruleset_json_parse(const void *json,
 			goto err;
 	}
 
+	nft_set_list_free(ctx.set_list);
 	nft_jansson_free_root(root);
 	return 0;
 err:
+	nft_set_list_free(ctx.set_list);
 	nft_jansson_free_root(root);
 	return -1;
 #else
@@ -573,10 +575,6 @@ static int nft_ruleset_xml_parse_ruleset(struct nft_parse_ctx *ctx,
 	mxml_node_t *node, *array = ctx->xml;
 	int len = 0, ret;
 
-	ctx->set_list = nft_set_list_alloc();
-	if (ctx->set_list == NULL)
-		return -1;
-
 	for (node = mxmlFindElement(array, array, NULL, NULL, NULL,
 				    MXML_DESCEND_FIRST);
 	     node != NULL;
@@ -653,12 +651,16 @@ static int nft_ruleset_xml_parse(const void *xml, struct nft_parse_err *err,
 	ctx.cb = cb;
 	ctx.format = type;
 
+	ctx.set_list = nft_set_list_alloc();
+	if (ctx.set_list == NULL)
+		return -1;
+
 	if (arg != NULL)
 		nft_ruleset_ctx_set(&ctx, NFT_RULESET_CTX_DATA, arg);
 
 	tree = nft_mxml_build_tree(xml, "nftables", err, input);
 	if (tree == NULL)
-		return -1;
+		goto err;
 
 	ctx.xml = tree;
 
@@ -670,9 +672,11 @@ static int nft_ruleset_xml_parse(const void *xml, struct nft_parse_err *err,
 		nodecmd = mxmlWalkNext(tree, tree, MXML_NO_DESCEND);
 	}
 
+	nft_set_list_free(ctx.set_list);
 	mxmlDelete(tree);
 	return 0;
 err:
+	nft_set_list_free(ctx.set_list);
 	mxmlDelete(tree);
 	return -1;
 #else
-- 
1.7.10.4

