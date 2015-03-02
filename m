From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH v2] ruleset: crash in path error when we build the xml tree
Date: Mon,  2 Mar 2015 19:59:38 +0100
Message-ID: <1425322779-6689-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33753 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbbCBS73 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 13:59:29 -0500
Received: by wghb13 with SMTP id b13so35408124wgh.0
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Mar 2015 10:59:28 -0800 (PST)
Received: from localhost.localdomain ([77.231.225.145])
        by mx.google.com with ESMTPSA id cf12sm20465342wjb.10.2015.03.02.10.59.26
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2015 10:59:27 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Crash when we try to release a tree that is not initialized.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v2]
 * Used the goto to make error paths without crash.

 src/ruleset.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/src/ruleset.c b/src/ruleset.c
index 89ea344..f56500b 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -535,12 +535,12 @@ static int nft_ruleset_json_parse(const void *json,
 
 	root = nft_jansson_create_root(json, &error, err, input);
 	if (root == NULL)
-		goto err;
+		goto err1;
 
 	array = json_object_get(root, "nftables");
 	if (array == NULL) {
 		errno = EINVAL;
-		goto err;
+		goto err2;
 	}
 
 	len = json_array_size(array);
@@ -548,23 +548,24 @@ static int nft_ruleset_json_parse(const void *json,
 		node = json_array_get(array, i);
 		if (node == NULL) {
 			errno = EINVAL;
-			goto err;
+			goto err2;
 		}
 		ctx.json = node;
 		key = json_object_iter_key(json_object_iter(node));
 		if (key == NULL)
-			goto err;
+			goto err2;
 
 		if (nft_ruleset_json_parse_cmd(key, err, &ctx) < 0)
-			goto err;
+			goto err2;
 	}
 
 	nft_set_list_free(ctx.set_list);
 	nft_jansson_free_root(root);
 	return 0;
-err:
-	nft_set_list_free(ctx.set_list);
+err2:
 	nft_jansson_free_root(root);
+err1:
+	nft_set_list_free(ctx.set_list);
 	return -1;
 #else
 	errno = EOPNOTSUPP;
@@ -665,7 +666,7 @@ static int nft_ruleset_xml_parse(const void *xml, struct nft_parse_err *err,
 
 	tree = nft_mxml_build_tree(xml, "nftables", err, input);
 	if (tree == NULL)
-		goto err;
+		goto err1;
 
 	ctx.xml = tree;
 
@@ -673,16 +674,17 @@ static int nft_ruleset_xml_parse(const void *xml, struct nft_parse_err *err,
 	while (nodecmd != NULL) {
 		cmd = nodecmd->value.opaque;
 		if (nft_ruleset_xml_parse_cmd(cmd, err, &ctx) < 0)
-			goto err;
+			goto err2;
 		nodecmd = mxmlWalkNext(tree, tree, MXML_NO_DESCEND);
 	}
 
 	nft_set_list_free(ctx.set_list);
 	mxmlDelete(tree);
 	return 0;
-err:
-	nft_set_list_free(ctx.set_list);
+err2:
 	mxmlDelete(tree);
+err1:
+	nft_set_list_free(ctx.set_list);
 	return -1;
 #else
 	errno = EOPNOTSUPP;
-- 
1.7.10.4

