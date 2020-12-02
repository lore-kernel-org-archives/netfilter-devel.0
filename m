Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC17C6369E
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAE4220758
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgLBW1s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 17:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgLBW1s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 17:27:48 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23480C0613D6
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Dec 2020 14:27:08 -0800 (PST)
Received: from localhost ([::1]:47342 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kkaaX-0007Ik-HP; Wed, 02 Dec 2020 23:27:05 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Derek Dai <daiderek@gmail.com>
Subject: [nft PATCH] json: Fix seqnum_to_json() functionality
Date:   Wed,  2 Dec 2020 23:27:01 +0100
Message-Id: <20201202222701.459-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduction of json_cmd_assoc_hash missed that by the time the hash
table insert happens, the struct cmd object's 'seqnum' field which is
used as key is not initialized yet. This doesn't happen until
nft_netlink() prepares the batch object which records the lowest seqnum.
Therefore push all json_cmd_assoc objects into a temporary list until
the first lookup happens. At this time, all referenced cmd objects have
their seqnum set and the list entries can be moved into the hash table
for fast lookups.

To expose such problems in the future, make json_events_cb() emit an
error message if the passed message has a handle but no assoc entry is
found for its seqnum.

Fixes: 389a0e1edc89a ("json: echo: Speedup seqnum_to_json()")
Cc: Derek Dai <daiderek@gmail.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 6ebbb408d6839..c6f511663f663 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3762,6 +3762,7 @@ static int json_verify_metainfo(struct json_ctx *ctx, json_t *root)
 }
 
 struct json_cmd_assoc {
+	struct json_cmd_assoc *next;
 	struct hlist_node hnode;
 	const struct cmd *cmd;
 	json_t *json;
@@ -3769,6 +3770,7 @@ struct json_cmd_assoc {
 
 #define CMD_ASSOC_HSIZE		512
 static struct hlist_head json_cmd_assoc_hash[CMD_ASSOC_HSIZE];
+static struct json_cmd_assoc *json_cmd_assoc_list;
 
 static void json_cmd_assoc_free(void)
 {
@@ -3776,6 +3778,12 @@ static void json_cmd_assoc_free(void)
 	struct hlist_node *pos, *n;
 	int i;
 
+	while (json_cmd_assoc_list) {
+		cur = json_cmd_assoc_list->next;
+		free(json_cmd_assoc_list);
+		json_cmd_assoc_list = cur;
+	}
+
 	for (i = 0; i < CMD_ASSOC_HSIZE; i++) {
 		hlist_for_each_entry_safe(cur, pos, n,
 					  &json_cmd_assoc_hash[i], hnode)
@@ -3786,21 +3794,29 @@ static void json_cmd_assoc_free(void)
 static void json_cmd_assoc_add(json_t *json, const struct cmd *cmd)
 {
 	struct json_cmd_assoc *new = xzalloc(sizeof *new);
-	int key = cmd->seqnum % CMD_ASSOC_HSIZE;
 
 	new->json	= json;
 	new->cmd	= cmd;
+	new->next	= json_cmd_assoc_list;
 
-	hlist_add_head(&new->hnode, &json_cmd_assoc_hash[key]);
+	json_cmd_assoc_list = new;
 }
 
 static json_t *seqnum_to_json(const uint32_t seqnum)
 {
-	int key = seqnum % CMD_ASSOC_HSIZE;
 	struct json_cmd_assoc *cur;
 	struct hlist_node *n;
+	int key;
 
+	while (json_cmd_assoc_list) {
+		cur = json_cmd_assoc_list;
+		json_cmd_assoc_list = cur->next;
 
+		key = cur->cmd->seqnum % CMD_ASSOC_HSIZE;
+		hlist_add_head(&cur->hnode, &json_cmd_assoc_hash[key]);
+	}
+
+	key = seqnum % CMD_ASSOC_HSIZE;
 	hlist_for_each_entry(cur, n, &json_cmd_assoc_hash[key], hnode) {
 		if (cur->cmd->seqnum == seqnum)
 			return cur->json;
@@ -3981,8 +3997,11 @@ int json_events_cb(const struct nlmsghdr *nlh, struct netlink_mon_handler *monh)
 		return MNL_CB_OK;
 
 	json = seqnum_to_json(nlh->nlmsg_seq);
-	if (!json)
+	if (!json) {
+		json_echo_error(monh, "No JSON command found with seqnum %lu\n",
+				nlh->nlmsg_seq);
 		return MNL_CB_OK;
+	}
 
 	tmp = json_object_get(json, "add");
 	if (!tmp)
-- 
2.28.0

