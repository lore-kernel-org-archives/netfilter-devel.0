From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH v2] rule: don't release the tree parameter in the function nft_jansson_parse_rule
Date: Wed, 11 Feb 2015 22:12:21 +0100
Message-ID: <1423689142-6300-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56763 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbbBKVMK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2015 16:12:10 -0500
Received: by mail-wi0-f173.google.com with SMTP id bs8so23600496wib.0
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2015 13:12:08 -0800 (PST)
Received: from localhost.localdomain ([77.231.217.97])
        by mx.google.com with ESMTPSA id hz9sm2881698wjb.17.2015.02.11.13.12.07
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Feb 2015 13:12:08 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Already, we release the tree that we receive from the parameter in
nft_jansson_parse_rule. With this patch, we're going to release the tree where
we create it. Therefore, we will have a code more traceable and readable.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v2]
 * Reworked the description

 src/rule.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 7f4d049..028dc2e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -597,10 +597,8 @@ int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree,
 		nft_rule_add_expr(r, e);
 	}
 
-	nft_jansson_free_root(tree);
 	return 0;
 err:
-	nft_jansson_free_root(tree);
 	return -1;
 }
 #endif
@@ -613,12 +611,16 @@ static int nft_rule_json_parse(struct nft_rule *r, const void *json,
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
+	int ret;
 
 	tree = nft_jansson_create_root(json, &error, err, input);
 	if (tree == NULL)
 		return -1;
 
-	return nft_jansson_parse_rule(r, tree, err, set_list);
+	ret = nft_jansson_parse_rule(r, tree, err, set_list);
+
+	nft_jansson_free_root(tree);
+	return ret;
 #else
 	errno = EOPNOTSUPP;
 	return -1;
-- 
1.7.10.4

