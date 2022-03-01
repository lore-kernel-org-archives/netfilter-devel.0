Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19319C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Mar 2022 20:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237733AbiCAU7Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Mar 2022 15:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236688AbiCAU7X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Mar 2022 15:59:23 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2813C506DE
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2022 12:58:41 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0C9D2623FC
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2022 21:57:13 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v3 4/7] mnl: update mnl_nft_setelem_del() to allow for more reuse
Date:   Tue,  1 Mar 2022 21:58:31 +0100
Message-Id: <20220301205834.290720-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301205834.290720-1-pablo@netfilter.org>
References: <20220301205834.290720-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pass handle and element list as parameters to allow for code reuse.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h | 3 ++-
 src/mnl.c     | 6 +++---
 src/rule.c    | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index a4abe1ae3242..4c701d4ee6dc 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -62,7 +62,8 @@ struct nftnl_set_list *mnl_nft_set_dump(struct netlink_ctx *ctx, int family,
 
 int mnl_nft_setelem_add(struct netlink_ctx *ctx, const struct set *set,
 			const struct expr *expr, unsigned int flags);
-int mnl_nft_setelem_del(struct netlink_ctx *ctx, const struct cmd *cmd);
+int mnl_nft_setelem_del(struct netlink_ctx *ctx, const struct handle *h,
+			const struct expr *init);
 int mnl_nft_setelem_flush(struct netlink_ctx *ctx, const struct cmd *cmd);
 int mnl_nft_setelem_get(struct netlink_ctx *ctx, struct nftnl_set *nls);
 struct nftnl_set *mnl_nft_setelem_get_one(struct netlink_ctx *ctx,
diff --git a/src/mnl.c b/src/mnl.c
index 6be991a4827c..1ef124eb9dcf 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1730,9 +1730,9 @@ int mnl_nft_setelem_flush(struct netlink_ctx *ctx, const struct cmd *cmd)
 	return 0;
 }
 
-int mnl_nft_setelem_del(struct netlink_ctx *ctx, const struct cmd *cmd)
+int mnl_nft_setelem_del(struct netlink_ctx *ctx, const struct handle *h,
+			const struct expr *init)
 {
-	const struct handle *h = &cmd->handle;
 	struct nftnl_set *nls;
 	int err;
 
@@ -1750,7 +1750,7 @@ int mnl_nft_setelem_del(struct netlink_ctx *ctx, const struct cmd *cmd)
 	netlink_dump_set(nls, ctx);
 
 	err = mnl_nft_setelem_batch(nls, ctx->batch, NFT_MSG_DELSETELEM, 0,
-				    ctx->seqnum, cmd->expr, ctx);
+				    ctx->seqnum, init, ctx);
 	nftnl_set_free(nls);
 
 	return err;
diff --git a/src/rule.c b/src/rule.c
index f2ca2621e895..e57e037a9e99 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1598,7 +1598,7 @@ static int do_delete_setelems(struct netlink_ctx *ctx, struct cmd *cmd)
 	    set_to_intervals(set, expr, false) < 0)
 		return -1;
 
-	if (mnl_nft_setelem_del(ctx, cmd) < 0)
+	if (mnl_nft_setelem_del(ctx, &cmd->handle, cmd->elem.expr) < 0)
 		return -1;
 
 	return 0;
-- 
2.30.2

