From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH] rule: don't release the tree parameter in the function nft_jansson_parse_rule
Date: Tue, 10 Feb 2015 17:46:13 +0100
Message-ID: <1423586774-20383-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:52549 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbbBJQp6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2015 11:45:58 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so34682971wgh.6
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Feb 2015 08:45:57 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id hm6sm21477841wjb.32.2015.02.10.08.45.56
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Feb 2015 08:45:56 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The function nft_jansson_parse_rule receives the tree like parameter and we
release it inside the functions. We use this function in the ruleset import
support. Therefore, we release the child nodes in the tree that  contains the
rule information before to release the tree. Then, if we import a ruleset,
valgrind shows:

==16551== Invalid write of size 8
==16551==    at 0x5EC92AA: json_delete (in
/usr/lib/x86_64-linux-gnu/libjansson.so.4.3.1)
==16551==    by 0x5EC4FC4: ??? (in
/usr/lib/x86_64-linux-gnu/libjansson.so.4.3.1)
==16551==    by 0x5EC5058: ??? (in
/usr/lib/x86_64-linux-gnu/libjansson.so.4.3.1)
==16551==    by 0x5EC9270: json_delete (in
/usr/lib/x86_64-linux-gnu/libjansson.so.4.3.1)
==16551==    by 0x5EC92B4: json_delete (in
/usr/lib/x86_64-linux-gnu/libjansson.so.4.3.1)
==16551==    by 0x5EC4FC4: ??? (in
/usr/lib/x86_64-linux-gnu/libjansson.so.4.3.1)
==16551==    by 0x5EC5058: ??? (in
/usr/lib/x86_64-linux-gnu/libjansson.so.4.3.1)
==16551==    by 0x5EC9270: json_delete (in
/usr/lib/x86_64-linux-gnu/libjansson.so.4.3.1)
==16551==    by 0x50455D0: nft_ruleset_json_parse (ruleset.c:557)
==16551==    by 0x50458AE: nft_ruleset_do_parse (ruleset.c:696)
==16551==    by 0x408AEC: do_command (rule.c:1317)
==16551==    by 0x406B05: nft_run (main.c:194)

With this patch, we release the tree only in the function nft_rule_json_parse
(the caller function of nft_jansson_parse_rule).

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
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

