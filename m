Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD46C46477
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2188820B1F
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfFROoJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:44:09 -0400
Received: from mail.us.es ([193.147.175.20]:53722 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727105AbfFROoJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:44:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8AA8EB6325
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 16:44:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7AB54DA704
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 16:44:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 705D9DA701; Tue, 18 Jun 2019 16:44:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5DC5DDA70C
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 16:44:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 16:44:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 401574265A2F
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 16:44:05 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 2/2] evaluate: do not allow to list/flush anonymous sets via list command
Date:   Tue, 18 Jun 2019 16:44:00 +0200
Message-Id: <20190618144400.31411-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190618144400.31411-1-pablo@netfilter.org>
References: <20190618144400.31411-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Don't allow this:

 # nft list set x __set0
 table ip x {
        set __set0 {
                type ipv4_addr
                flags constant
                elements = { 1.1.1.1 }
        }
 }

Anonymous sets never change and they are attached to a rule, do not list
their content.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: extend testcase to cover maps. Extend it to cover flush command too.

 src/evaluate.c                                | 19 +++++++++------
 tests/shell/testcases/listing/0016anonymous_0 | 33 +++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 7 deletions(-)
 create mode 100755 tests/shell/testcases/listing/0016anonymous_0

diff --git a/src/evaluate.c b/src/evaluate.c
index 07617a7c94cb..5b1946a1fd09 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3587,7 +3587,8 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		set = set_lookup(table, cmd->handle.set.name);
-		if (set == NULL || set->flags & NFT_SET_MAP)
+		if (set == NULL ||
+		    set->flags & (NFT_SET_MAP | NFT_SET_ANONYMOUS))
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
 
@@ -3598,7 +3599,8 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		set = set_lookup(table, cmd->handle.set.name);
-		if (set == NULL || !(set->flags & NFT_SET_EVAL))
+		if (set == NULL || !(set->flags & NFT_SET_EVAL) ||
+		    !(set->flags & NFT_SET_ANONYMOUS))
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
 
@@ -3609,7 +3611,8 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		set = set_lookup(table, cmd->handle.set.name);
-		if (set == NULL || !(set->flags & NFT_SET_MAP))
+		if (set == NULL || !(set->flags & NFT_SET_MAP) ||
+		    set->flags & NFT_SET_ANONYMOUS)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
 
@@ -3698,10 +3701,10 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		set = set_lookup(table, cmd->handle.set.name);
-		if (set == NULL || set->flags & NFT_SET_MAP)
+		if (set == NULL ||
+		    (set->flags & (NFT_SET_MAP | NFT_SET_ANONYMOUS)))
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
-
 		return 0;
 	case CMD_OBJ_MAP:
 		table = table_lookup(&cmd->handle, &ctx->nft->cache);
@@ -3709,7 +3712,8 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		set = set_lookup(table, cmd->handle.set.name);
-		if (set == NULL || !(set->flags & NFT_SET_MAP))
+		if (set == NULL || !(set->flags & NFT_SET_MAP) ||
+		    set->flags & NFT_SET_ANONYMOUS)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
 
@@ -3720,7 +3724,8 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		set = set_lookup(table, cmd->handle.set.name);
-		if (set == NULL || !(set->flags & NFT_SET_EVAL))
+		if (set == NULL || !(set->flags & NFT_SET_EVAL) ||
+		    !(set->flags & NFT_SET_ANONYMOUS))
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
 
diff --git a/tests/shell/testcases/listing/0016anonymous_0 b/tests/shell/testcases/listing/0016anonymous_0
new file mode 100755
index 000000000000..83acbccae7db
--- /dev/null
+++ b/tests/shell/testcases/listing/0016anonymous_0
@@ -0,0 +1,33 @@
+#!/bin/bash
+
+$NFT add table x
+$NFT add chain x y
+$NFT add rule x y ip saddr { 1.1.1.1 }
+$NFT add rule x y meta mark set ip saddr map { 1.1.1.1 : 2 }
+
+$NFT list set x __set0 &>/dev/null
+ret=$?
+if [ $ret -eq 0 ]
+then
+	exit 1
+fi
+
+$NFT flush set x __set0 &>/dev/null
+ret=$?
+if [ $ret -eq 0 ]
+then
+	exit 1
+fi
+
+$NFT list map x __map0 &>/dev/null
+if [ $ret -eq 0 ]
+then
+	exit 1
+fi
+
+$NFT flush map x __map0 &>/dev/null
+ret=$?
+if [ $ret -eq 0 ]
+then
+	exit 1
+fi
-- 
2.11.0

