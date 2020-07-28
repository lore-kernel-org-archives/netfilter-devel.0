Return-Path: <SRS0=tHxH=BH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC057C433EA
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jul 2020 18:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB50220714
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jul 2020 18:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732439AbgG1S3B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jul 2020 14:29:01 -0400
Received: from correo.us.es ([193.147.175.20]:44550 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728179AbgG1S3B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jul 2020 14:29:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3391315AEAB
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:28:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 252B9DA722
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:28:59 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1AC79DA78B; Tue, 28 Jul 2020 20:28:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0559CDA722
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:28:57 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Jul 2020 20:28:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E5DA24265A2F
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:28:56 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/3] evaluate: flush set cache from the evaluation phase
Date:   Tue, 28 Jul 2020 20:28:52 +0200
Message-Id: <20200728182854.4473-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch reworks 40ef308e19b6 ("rule: flush set cache before flush
command"). This patch flushes the set cache earlier, from the command
evaluation step.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 15 +++++++++++++++
 src/rule.c     | 16 ----------------
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1f56dae5ec13..bb504962ea8d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4375,6 +4375,14 @@ static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 	}
 }
 
+static void __flush_set_cache(struct set *set)
+{
+	if (set->init != NULL) {
+		expr_free(set->init);
+		set->init = NULL;
+	}
+}
+
 static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
@@ -4402,6 +4410,9 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 		else if (!set_is_literal(set->flags))
 			return cmd_error(ctx, &ctx->cmd->handle.set.location,
 					 "%s", strerror(ENOENT));
+
+		__flush_set_cache(set);
+
 		return 0;
 	case CMD_OBJ_MAP:
 		table = table_lookup(&cmd->handle, &ctx->nft->cache);
@@ -4416,6 +4427,8 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 			return cmd_error(ctx, &ctx->cmd->handle.set.location,
 					 "%s", strerror(ENOENT));
 
+		__flush_set_cache(set);
+
 		return 0;
 	case CMD_OBJ_METER:
 		table = table_lookup(&cmd->handle, &ctx->nft->cache);
@@ -4430,6 +4443,8 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 			return cmd_error(ctx, &ctx->cmd->handle.set.location,
 					 "%s", strerror(ENOENT));
 
+		__flush_set_cache(set);
+
 		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
diff --git a/src/rule.c b/src/rule.c
index dadb26f85567..65973ccb296e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2693,21 +2693,6 @@ static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
 	return do_list_obj(ctx, cmd, type);
 }
 
-static void flush_set_cache(struct netlink_ctx *ctx, struct cmd *cmd)
-{
-	struct table *table;
-	struct set *set;
-
-	table = table_lookup(&cmd->handle, &ctx->nft->cache);
-	assert(table);
-	set = set_lookup(table, cmd->handle.set.name);
-	assert(set);
-	if (set->init != NULL) {
-		expr_free(set->init);
-		set->init = NULL;
-	}
-}
-
 static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
@@ -2717,7 +2702,6 @@ static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
 	case CMD_OBJ_METER:
-		flush_set_cache(ctx, cmd);
 		return mnl_nft_setelem_flush(ctx, cmd);
 	case CMD_OBJ_RULESET:
 		return mnl_nft_table_del(ctx, cmd);
-- 
2.20.1

