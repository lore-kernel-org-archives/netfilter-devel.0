Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75FD0C43461
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50527613DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhD2Xnv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 19:43:51 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59536 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhD2Xnu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 19:43:50 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id E50E264133
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 01:42:23 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 03/18] rule: skip fuzzy lookup for unexisting 64-bit handle
Date:   Fri, 30 Apr 2021 01:42:40 +0200
Message-Id: <20210429234255.16840-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210429234255.16840-1-pablo@netfilter.org>
References: <20210429234255.16840-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Deletion by handle, if incorrect, should not exercise the misspell
lookup functions.

Fixes: 3a0e07106f66 ("src: combine extended netlink error reporting with mispelling support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cmd.c                                         | 15 +++++++++++++++
 .../cache/0009_delete_by_handle_incorrect_0       |  8 ++++++++
 2 files changed, 23 insertions(+)
 create mode 100755 tests/shell/testcases/cache/0009_delete_by_handle_incorrect_0

diff --git a/src/cmd.c b/src/cmd.c
index 9cb5b6a3f33d..c04efce3801a 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -14,6 +14,9 @@ static int nft_cmd_enoent_table(struct netlink_ctx *ctx, const struct cmd *cmd,
 {
 	struct table *table;
 
+	if (!cmd->handle.table.name)
+		return 0;
+
 	table = table_lookup_fuzzy(&cmd->handle, &ctx->nft->cache);
 	if (!table)
 		return 0;
@@ -30,6 +33,9 @@ static int nft_cmd_enoent_chain(struct netlink_ctx *ctx, const struct cmd *cmd,
 	const struct table *table;
 	struct chain *chain;
 
+	if (!cmd->handle.chain.name)
+		return 0;
+
 	chain = chain_lookup_fuzzy(&cmd->handle, &ctx->nft->cache, &table);
 	if (!chain)
 		return 0;
@@ -81,6 +87,9 @@ static int nft_cmd_enoent_set(struct netlink_ctx *ctx, const struct cmd *cmd,
 	const struct table *table;
 	struct set *set;
 
+	if (!cmd->handle.set.name)
+		return 0;
+
 	set = set_lookup_fuzzy(cmd->handle.set.name, &ctx->nft->cache, &table);
 	if (!set)
 		return 0;
@@ -100,6 +109,9 @@ static int nft_cmd_enoent_obj(struct netlink_ctx *ctx, const struct cmd *cmd,
 	const struct table *table;
 	struct obj *obj;
 
+	if (!cmd->handle.obj.name)
+		return 0;
+
 	obj = obj_lookup_fuzzy(cmd->handle.obj.name, &ctx->nft->cache, &table);
 	if (!obj)
 		return 0;
@@ -118,6 +130,9 @@ static int nft_cmd_enoent_flowtable(struct netlink_ctx *ctx,
 	const struct table *table;
 	struct flowtable *ft;
 
+	if (!cmd->handle.flowtable.name)
+		return 0;
+
 	ft = flowtable_lookup_fuzzy(cmd->handle.flowtable.name,
 				    &ctx->nft->cache, &table);
 	if (!ft)
diff --git a/tests/shell/testcases/cache/0009_delete_by_handle_incorrect_0 b/tests/shell/testcases/cache/0009_delete_by_handle_incorrect_0
new file mode 100755
index 000000000000..f0bb02a636ee
--- /dev/null
+++ b/tests/shell/testcases/cache/0009_delete_by_handle_incorrect_0
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+$NFT delete table handle 4000 && exit 1
+$NFT delete chain t handle 4000 && exit 1
+$NFT delete set t handle 4000 && exit 1
+$NFT delete flowtable t handle 4000 && exit 1
+$NFT delete counter t handle 4000 && exit 1
+exit 0
-- 
2.20.1

