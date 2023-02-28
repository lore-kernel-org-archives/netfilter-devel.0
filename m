Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B114EC64ED6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Feb 2023 19:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjB1TtZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Feb 2023 14:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjB1TtY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2023 14:49:24 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E40969748
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2023 11:49:23 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_quota: copy content when cloning expression
Date:   Tue, 28 Feb 2023 20:49:19 +0100
Message-Id: <20230228194919.91329-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the ruleset contains consumed quota, restore them accordingly.
Otherwise, listing after restoration shows never used items.

Restore the user-defined quota and flags too.

Fixes: ed0a0c60f0e5 ("netfilter: nft_quota: move stateful fields out of expression data")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_quota.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 123578e28917..3ba12a7471b0 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -236,12 +236,16 @@ static void nft_quota_destroy(const struct nft_ctx *ctx,
 static int nft_quota_clone(struct nft_expr *dst, const struct nft_expr *src)
 {
 	struct nft_quota *priv_dst = nft_expr_priv(dst);
+	struct nft_quota *priv_src = nft_expr_priv(src);
+
+	priv_dst->quota = priv_src->quota;
+	priv_dst->flags = priv_src->flags;
 
 	priv_dst->consumed = kmalloc(sizeof(*priv_dst->consumed), GFP_ATOMIC);
 	if (!priv_dst->consumed)
 		return -ENOMEM;
 
-	atomic64_set(priv_dst->consumed, 0);
+	*priv_dst->consumed = *priv_src->consumed;
 
 	return 0;
 }
-- 
2.30.2

