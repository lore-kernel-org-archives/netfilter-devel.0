Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A54C2D0E4
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 19:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE97A22240
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 19:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732296AbgKTTQv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 14:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732258AbgKTTQv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 14:16:51 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0144AC0613CF
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2020 11:16:50 -0800 (PST)
Received: from localhost ([::1]:50718 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kgBto-0008ED-Sh; Fri, 20 Nov 2020 20:16:48 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Derek Dai <daiderek@gmail.com>
Subject: [nft PATCH] json: echo: Speedup seqnum_to_json()
Date:   Fri, 20 Nov 2020 20:16:40 +0100
Message-Id: <20201120191640.21243-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Derek Dai reports:
"If there are a lot of command in JSON node, seqnum_to_json() will slow
down application (eg: firewalld) dramatically since it iterate whole
command list every time."

He sent a patch implementing a lookup table, but we can do better: Speed
this up by introducing a hash table to store the struct json_cmd_assoc
objects in, taking their netlink sequence number as key.

Quickly tested restoring a ruleset containing about 19k rules:

| # time ./before/nft -jeaf large_ruleset.json >/dev/null
| 4.85user 0.47system 0:05.48elapsed 97%CPU (0avgtext+0avgdata 69732maxresident)k
| 0inputs+0outputs (15major+16937minor)pagefaults 0swaps

| # time ./after/nft -jeaf large_ruleset.json >/dev/null
| 0.18user 0.44system 0:00.70elapsed 89%CPU (0avgtext+0avgdata 68484maxresident)k
| 0inputs+0outputs (15major+16645minor)pagefaults 0swaps

Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1479
Reported-by: Derek Dai <daiderek@gmail.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index b1de56a4a0d27..6ebbb408d6839 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3762,42 +3762,50 @@ static int json_verify_metainfo(struct json_ctx *ctx, json_t *root)
 }
 
 struct json_cmd_assoc {
-	struct json_cmd_assoc *next;
+	struct hlist_node hnode;
 	const struct cmd *cmd;
 	json_t *json;
 };
 
-static struct json_cmd_assoc *json_cmd_list = NULL;
+#define CMD_ASSOC_HSIZE		512
+static struct hlist_head json_cmd_assoc_hash[CMD_ASSOC_HSIZE];
 
 static void json_cmd_assoc_free(void)
 {
 	struct json_cmd_assoc *cur;
+	struct hlist_node *pos, *n;
+	int i;
 
-	while (json_cmd_list) {
-		cur = json_cmd_list;
-		json_cmd_list = cur->next;
-		free(cur);
+	for (i = 0; i < CMD_ASSOC_HSIZE; i++) {
+		hlist_for_each_entry_safe(cur, pos, n,
+					  &json_cmd_assoc_hash[i], hnode)
+			free(cur);
 	}
 }
 
 static void json_cmd_assoc_add(json_t *json, const struct cmd *cmd)
 {
 	struct json_cmd_assoc *new = xzalloc(sizeof *new);
+	int key = cmd->seqnum % CMD_ASSOC_HSIZE;
 
-	new->next	= json_cmd_list;
 	new->json	= json;
 	new->cmd	= cmd;
-	json_cmd_list	= new;
+
+	hlist_add_head(&new->hnode, &json_cmd_assoc_hash[key]);
 }
 
 static json_t *seqnum_to_json(const uint32_t seqnum)
 {
-	const struct json_cmd_assoc *cur;
+	int key = seqnum % CMD_ASSOC_HSIZE;
+	struct json_cmd_assoc *cur;
+	struct hlist_node *n;
 
-	for (cur = json_cmd_list; cur; cur = cur->next) {
+
+	hlist_for_each_entry(cur, n, &json_cmd_assoc_hash[key], hnode) {
 		if (cur->cmd->seqnum == seqnum)
 			return cur->json;
 	}
+
 	return NULL;
 }
 
-- 
2.28.0

