From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH] ruleset: fix a leak when we use the set lists
Date: Tue, 10 Feb 2015 17:46:14 +0100
Message-ID: <1423586774-20383-2-git-send-email-alvaroneay@gmail.com>
References: <1423586774-20383-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:41827 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbbBJQqD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2015 11:46:03 -0500
Received: by mail-wg0-f41.google.com with SMTP id b13so14720363wgh.0
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Feb 2015 08:46:01 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id hm6sm21477841wjb.32.2015.02.10.08.46.00
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Feb 2015 08:46:00 -0800 (PST)
In-Reply-To: <1423586774-20383-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When we parse the sets in a ruleset, we set up a id. To do that, we use
a set list. We alloc this set list and we need to free this set list. And we
don't do that. If we import a ruleset, valgrind shows:

==18632== 285 (16 direct, 269 indirect) bytes in 1 blocks are definitely lost in
loss record 6 of 6
==18632==    at 0x4C272B8: calloc (vg_replace_malloc.c:566)
==18632==    by 0x5043822: nft_set_list_alloc (set.c:977)
==18632==    by 0x5045483: nft_ruleset_json_parse (ruleset.c:442)
==18632==    by 0x50458BE: nft_ruleset_do_parse (ruleset.c:696)
==18632==    by 0x408AEC: do_command (rule.c:1317)
==18632==    by 0x406B05: nft_run (main.c:194)
==18632==    by 0x40667C: main (main.c:360)

With this changes, we alloc the set list when we create the nft_parse_ctx and
free it later.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/ruleset.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/src/ruleset.c b/src/ruleset.c
index 15e84cf..3ce6ccc 100644
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
@@ -525,6 +521,10 @@ static int nft_ruleset_json_parse(const void *json,
 	ctx.cb = cb;
 	ctx.format = type;
 
+	ctx.set_list = nft_set_list_alloc();
+	if (ctx.set_list == NULL)
+		return -1;
+
 	if (arg != NULL)
 		nft_ruleset_ctx_set(&ctx, NFT_RULESET_CTX_DATA, arg);
 
@@ -554,6 +554,7 @@ static int nft_ruleset_json_parse(const void *json,
 			goto err;
 	}
 
+	nft_set_list_free(ctx.set_list);
 	nft_jansson_free_root(root);
 	return 0;
 err:
@@ -573,10 +574,6 @@ static int nft_ruleset_xml_parse_ruleset(struct nft_parse_ctx *ctx,
 	mxml_node_t *node, *array = ctx->xml;
 	int len = 0, ret;
 
-	ctx->set_list = nft_set_list_alloc();
-	if (ctx->set_list == NULL)
-		return -1;
-
 	for (node = mxmlFindElement(array, array, NULL, NULL, NULL,
 				    MXML_DESCEND_FIRST);
 	     node != NULL;
@@ -653,6 +650,10 @@ static int nft_ruleset_xml_parse(const void *xml, struct nft_parse_err *err,
 	ctx.cb = cb;
 	ctx.format = type;
 
+	ctx.set_list = nft_set_list_alloc();
+	if (ctx.set_list == NULL)
+		return -1;
+
 	if (arg != NULL)
 		nft_ruleset_ctx_set(&ctx, NFT_RULESET_CTX_DATA, arg);
 
@@ -670,6 +671,7 @@ static int nft_ruleset_xml_parse(const void *xml, struct nft_parse_err *err,
 		nodecmd = mxmlWalkNext(tree, tree, MXML_NO_DESCEND);
 	}
 
+	nft_set_list_free(ctx.set_list);
 	mxmlDelete(tree);
 	return 0;
 err:
-- 
1.7.10.4

