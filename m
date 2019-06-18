Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611CAC31E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E96B20873
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbfFRO51 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:57:27 -0400
Received: from mail.us.es ([193.147.175.20]:58882 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbfFRO50 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:57:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 03562FF2C6
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 16:57:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E88CBDA701
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 16:57:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DE39CDA703; Tue, 18 Jun 2019 16:57:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF456DA705
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 16:57:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 16:57:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B66994265A32
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 16:57:21 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2,v3] evaluate: do not allow to list/flush anonymous sets via list command
Date:   Tue, 18 Jun 2019 16:57:19 +0200
Message-Id: <20190618145719.7866-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
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

Constant sets never change and they are attached to a rule (anonymous
flag is set on), do not list their content through this command. Do not
allow flush operation either.

After this patch:

 # nft list set x __set0
 Error: No such file or directory
 list set x __set0
            ^^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: do not exercise misspell path on mismatching set flags.

 src/evaluate.c                                | 34 ++++++++++++++++++++++-----
 tests/shell/testcases/listing/0016anonymous_0 | 33 ++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 6 deletions(-)
 create mode 100755 tests/shell/testcases/listing/0016anonymous_0

diff --git a/src/evaluate.c b/src/evaluate.c
index 07617a7c94cb..dfdd3c242530 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3587,9 +3587,12 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		set = set_lookup(table, cmd->handle.set.name);
-		if (set == NULL || set->flags & NFT_SET_MAP)
+		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
+		else if (set->flags & (NFT_SET_MAP | NFT_SET_ANONYMOUS))
+			return cmd_error(ctx,  &ctx->cmd->handle.set.location,
+					 "%s", strerror(ENOENT));
 
 		return 0;
 	case CMD_OBJ_METER:
@@ -3598,9 +3601,13 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		set = set_lookup(table, cmd->handle.set.name);
-		if (set == NULL || !(set->flags & NFT_SET_EVAL))
+		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
+		else if (!(set->flags & NFT_SET_EVAL) ||
+			 !(set->flags & NFT_SET_ANONYMOUS))
+			return cmd_error(ctx, &ctx->cmd->handle.set.location,
+					 "%s", strerror(ENOENT));
 
 		return 0;
 	case CMD_OBJ_MAP:
@@ -3609,9 +3616,13 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		set = set_lookup(table, cmd->handle.set.name);
-		if (set == NULL || !(set->flags & NFT_SET_MAP))
+		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
+		else if (!(set->flags & NFT_SET_MAP) ||
+			 set->flags & NFT_SET_ANONYMOUS)
+			return cmd_error(ctx, &ctx->cmd->handle.set.location,
+					 "%s", strerror(ENOENT));
 
 		return 0;
 	case CMD_OBJ_CHAIN:
@@ -3698,9 +3709,12 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		set = set_lookup(table, cmd->handle.set.name);
-		if (set == NULL || set->flags & NFT_SET_MAP)
+		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
+		else if (set->flags & (NFT_SET_MAP | NFT_SET_ANONYMOUS))
+			return cmd_error(ctx, &ctx->cmd->handle.set.location,
+					 "%s", strerror(ENOENT));
 
 		return 0;
 	case CMD_OBJ_MAP:
@@ -3709,9 +3723,13 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		set = set_lookup(table, cmd->handle.set.name);
-		if (set == NULL || !(set->flags & NFT_SET_MAP))
+		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
+		else if (!(set->flags & NFT_SET_MAP) ||
+			 set->flags & NFT_SET_ANONYMOUS)
+			return cmd_error(ctx, &ctx->cmd->handle.set.location,
+					 "%s", strerror(ENOENT));
 
 		return 0;
 	case CMD_OBJ_METER:
@@ -3720,9 +3738,13 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		set = set_lookup(table, cmd->handle.set.name);
-		if (set == NULL || !(set->flags & NFT_SET_EVAL))
+		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
+		else if (!(set->flags & NFT_SET_EVAL) ||
+			 !(set->flags & NFT_SET_ANONYMOUS))
+			return cmd_error(ctx, &ctx->cmd->handle.set.location,
+					 "%s", strerror(ENOENT));
 
 		return 0;
 	default:
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

