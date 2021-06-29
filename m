Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3C3C11F66
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Jun 2021 12:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B3EE61D6C
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Jun 2021 12:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbhF2MrD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Jun 2021 08:47:03 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33934 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbhF2MrD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 08:47:03 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B6BC960786
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Jun 2021 14:44:30 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cmd: incorrect error reporting when table declaration exists
Date:   Tue, 29 Jun 2021 14:44:33 +0200
Message-Id: <20210629124433.10519-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This example ruleset is missing the chain declaration:

 add table x
 add set x y { typeof ip saddr ; }
 add rule x y counter

After this patch, error reporting provides suggestions for the missing
chain:

 # nft -f ruleset.nft
 ruleset.nft:3:12-12: Error: No such file or directory; did you mean chain ‘INPUT’ in table ip ‘filter’?
 add rule x y counter
            ^

Before this patch, it incorrectly refers to the table:

 ruleset.nft:3:10-10: Error: No such file or directory; did you mean table ‘filter’ in family ip?
 add rule x y counter
          ^

This patch invalidates the table that is found via fuzzy lookup if it
exists in the cache.

Fixes: 0276c2fee939 ("cmd: check for table mismatch first in error reporting")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cmd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/cmd.c b/src/cmd.c
index 8d4bf8bc13aa..d956919b6b5e 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -30,6 +30,10 @@ static int nft_cmd_enoent_table(struct netlink_ctx *ctx, const struct cmd *cmd,
 static int table_fuzzy_check(struct netlink_ctx *ctx, const struct cmd *cmd,
 			     const struct table *table)
 {
+	if (table_cache_find(&ctx->nft->cache.table_cache,
+			     cmd->handle.table.name, cmd->handle.family))
+		return 0;
+
 	if (strcmp(cmd->handle.table.name, table->handle.table.name) ||
 	    cmd->handle.family != table->handle.family) {
 		netlink_io_error(ctx, &cmd->handle.table.location,
-- 
2.20.1

