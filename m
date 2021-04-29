Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD22C43460
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8F4F613DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhD2Xnu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 19:43:50 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59530 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhD2Xnu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 19:43:50 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5A0B364141
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 01:42:23 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 02/18] src: unbreak deletion by table handle
Date:   Fri, 30 Apr 2021 01:42:39 +0200
Message-Id: <20210429234255.16840-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210429234255.16840-1-pablo@netfilter.org>
References: <20210429234255.16840-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use NFTA_TABLE_HANDLE instead of NFTA_TABLE_NAME to refer to the
table 64-bit unique handle.

Fixes: 7840b9224d5b ("evaluate: remove table from cache on delete table")
Fixes: f8aec603aa7e ("src: initial extended netlink error reporting")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                |  3 +++
 src/mnl.c                                     |  2 +-
 .../testcases/cache/0008_delete_by_handle_0   | 20 +++++++++++++++++++
 3 files changed, 24 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/cache/0008_delete_by_handle_0

diff --git a/src/evaluate.c b/src/evaluate.c
index a6bb1792c58a..c52309f46f59 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4335,6 +4335,9 @@ static void table_del_cache(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
 
+	if (!cmd->handle.table.name)
+		return;
+
 	table = table_lookup(&cmd->handle, &ctx->nft->cache);
 	if (!table)
 		return;
diff --git a/src/mnl.c b/src/mnl.c
index d5ea87d8d609..1a8e8105707b 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -960,7 +960,7 @@ int mnl_nft_table_del(struct netlink_ctx *ctx, struct cmd *cmd)
 		mnl_attr_put_strz(nlh, NFTA_TABLE_NAME, cmd->handle.table.name);
 	} else if (cmd->handle.handle.id) {
 		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.handle.location);
-		mnl_attr_put_u64(nlh, NFTA_TABLE_NAME,
+		mnl_attr_put_u64(nlh, NFTA_TABLE_HANDLE,
 				 htobe64(cmd->handle.handle.id));
 	}
 	nftnl_table_nlmsg_build_payload(nlh, nlt);
diff --git a/tests/shell/testcases/cache/0008_delete_by_handle_0 b/tests/shell/testcases/cache/0008_delete_by_handle_0
new file mode 100755
index 000000000000..24b2607b236f
--- /dev/null
+++ b/tests/shell/testcases/cache/0008_delete_by_handle_0
@@ -0,0 +1,20 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table t
+$NFT delete table handle 1
+
+$NFT add table t
+
+$NFT add chain t c
+$NFT delete chain t handle 1
+
+$NFT add set t s { type ipv4_addr\; }
+$NFT delete set t handle 2
+
+$NFT add flowtable t f { hook ingress priority 0\; }
+$NFT delete flowtable t handle 4
+
+$NFT add counter t x
+$NFT delete counter t handle 5
-- 
2.20.1

