Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76412C76192
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 10:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 554F420880
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 10:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733156AbfGPK0y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 06:26:54 -0400
Received: from mail.us.es ([193.147.175.20]:60878 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732851AbfGPK0y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 06:26:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4A7F5B6BBC
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E9E4C1150DF
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 60F4F1158F4; Tue, 16 Jul 2019 12:26:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4C96F115412
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jul 2019 12:26:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2B6E44265A32
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:29 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 4/5] evaluate: honor NFT_SET_OBJECT flag
Date:   Tue, 16 Jul 2019 12:26:23 +0200
Message-Id: <20190716102624.4628-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190716102624.4628-1-pablo@netfilter.org>
References: <20190716102624.4628-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is noticeable when displaying mispelling errors, however, there are
also few spots not checking for the object map flag.

Before:

 # nft flush set inet filter countermxx
 Error: No such file or directory; did you mean set ‘countermap’ in table inet ‘filter’?
 flush set inet filter countermxx
                       ^^^^^^^^^^
After:

 # nft flush set inet filter countermxx
 Error: No such file or directory; did you mean map ‘countermap’ in table inet ‘filter’?
 flush set inet filter countermxx
                       ^^^^^^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 6 +++---
 src/json.c     | 5 ++---
 src/rule.c     | 5 ++---
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index e35291d28b6a..f95f42e1067a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -211,7 +211,7 @@ static int set_not_found(struct eval_ctx *ctx, const struct location *loc,
 	return cmd_error(ctx, loc,
 			 "%s; did you mean %s ‘%s’ in table %s ‘%s’?",
 			 strerror(ENOENT),
-			 set->flags & NFT_SET_MAP ? "map" : "set",
+			 set_is_map(set->flags) ? "map" : "set",
 			 set->handle.set.name,
 			 family2str(set->handle.family),
 			 table->handle.table.name);
@@ -3129,7 +3129,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	if (!(set->flags & NFT_SET_INTERVAL) && set->automerge)
 		return set_error(ctx, set, "auto-merge only works with interval sets");
 
-	type = set->flags & NFT_SET_MAP ? "map" : "set";
+	type = set_is_map(set->flags) ? "map" : "set";
 
 	if (set->key == NULL)
 		return set_error(ctx, set, "%s definition does not specify key",
@@ -3560,7 +3560,7 @@ static int cmd_evaluate_get(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		set = set_lookup(table, cmd->handle.set.name);
-		if (set == NULL || set->flags & NFT_SET_MAP)
+		if (set == NULL || set_is_map(set->flags))
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
 
diff --git a/src/json.c b/src/json.c
index b21677efea91..215de65a114a 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1605,14 +1605,13 @@ static json_t *do_list_sets_json(struct netlink_ctx *ctx, struct cmd *cmd)
 
 		list_for_each_entry(set, &table->sets, list) {
 			if (cmd->obj == CMD_OBJ_SETS &&
-			    (set->flags & NFT_SET_ANONYMOUS ||
-			    set->flags & NFT_SET_MAP))
+			    !set_is_literal(set->flags))
 				continue;
 			if (cmd->obj == CMD_OBJ_METERS &&
 			    !(set->flags & NFT_SET_EVAL))
 				continue;
 			if (cmd->obj == CMD_OBJ_MAPS &&
-			    !(set->flags & NFT_SET_MAP))
+			    !map_is_literal(set->flags))
 				continue;
 			json_array_append_new(root, set_print_json(octx, set));
 		}
diff --git a/src/rule.c b/src/rule.c
index 52d8181f0d92..4e07871a1f65 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1652,14 +1652,13 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 
 		list_for_each_entry(set, &table->sets, list) {
 			if (cmd->obj == CMD_OBJ_SETS &&
-			    (set->flags & NFT_SET_ANONYMOUS ||
-			    set->flags & NFT_SET_MAP))
+			    !set_is_literal(set->flags))
 				continue;
 			if (cmd->obj == CMD_OBJ_METERS &&
 			    !(set->flags & NFT_SET_EVAL))
 				continue;
 			if (cmd->obj == CMD_OBJ_MAPS &&
-			    !(set->flags & NFT_SET_MAP))
+			    !map_is_literal(set->flags))
 				continue;
 			set_print_declaration(set, &opts, &ctx->nft->output);
 			nft_print(&ctx->nft->output, "%s}%s", opts.tab, opts.nl);
-- 
2.11.0

