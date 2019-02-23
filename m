Return-Path: <SRS0=cwGx=Q6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2875C43381
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Feb 2019 21:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EDDC20652
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Feb 2019 21:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550957310;
	bh=VcsB3pNZSpFzMTjD0LZmczWhbZh44ujquiyNeBgpxV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=yLaTeAsibsBys5d+vYPn1uHoOtuIEgAWWXJ9coSZNZT70eEkPVYzd1iuSNZbrKLTM
	 PIl5v/xldzpVm7SMs7qpqHnQp3SPSPjewZq9itBiuohkvvpMRLwmU1dKCDhlpeBQmt
	 zm0X2oxgVFBcM72LIKBllF8uMJVA1k7+vFT2IRXI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbfBWV2W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Feb 2019 16:28:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728816AbfBWVGq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Feb 2019 16:06:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9E692086A;
        Sat, 23 Feb 2019 21:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550956005;
        bh=VcsB3pNZSpFzMTjD0LZmczWhbZh44ujquiyNeBgpxV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQ7KatCl0OPy1jiKJKO2DCgPVn59hhahEnbgihbstlrPfXF3xXr+dPfJboMk2plRI
         qe9k1rt6laAGZTgQ/WI9fkjBotDiQ9ScuJ7jpiAOp6nM36OV3QFG7FZgpytco4QBp/
         936NSdg9U5UaIuvPtUWvo4PNB2/I1Jkue5Rsuw3U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/65] netfilter: nft_compat: use refcnt_t type for nft_xt reference count
Date:   Sat, 23 Feb 2019 16:05:39 -0500
Message-Id: <20190223210640.200911-4-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190223210640.200911-1-sashal@kernel.org>
References: <20190223210640.200911-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 12c44aba6618b7f6c437076e5722237190f6cd5f ]

Using standard integer type was fine while all operations on it were
guarded by the nftnl subsys mutex.

This isn't true anymore:
1. transactions are guarded only by a pernet mutex, so concurrent
   rule manipulation in different netns is racy
2. the ->destroy hook runs from a work queue after the transaction
   mutex has been released already.

cpu0                           cpu1 (net 1)        cpu2 (net 2)
 kworker
    nft_compat->destroy        nft_compat->init    nft_compat->init
      if (--nft_xt->ref == 0)   nft_xt->ref++        nft_xt->ref++

Switch to refcount_t.  Doing this however only fixes a minor aspect,
nft_compat also performs linked-list operations in an unsafe way.

This is addressed in the next two patches.

Fixes: f102d66b335a ("netfilter: nf_tables: use dedicated mutex to guard transactions")
Fixes: 0935d5588400 ("netfilter: nf_tables: asynchronous release")
Reported-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 29d6fc73caf99..3e629ee59ddab 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -26,7 +26,7 @@
 struct nft_xt {
 	struct list_head	head;
 	struct nft_expr_ops	ops;
-	unsigned int		refcnt;
+	refcount_t		refcnt;
 
 	/* Unlike other expressions, ops doesn't have static storage duration.
 	 * nft core assumes they do.  We use kfree_rcu so that nft core can
@@ -45,7 +45,7 @@ struct nft_xt_match_priv {
 
 static bool nft_xt_put(struct nft_xt *xt)
 {
-	if (--xt->refcnt == 0) {
+	if (refcount_dec_and_test(&xt->refcnt)) {
 		list_del(&xt->head);
 		kfree_rcu(xt, rcu_head);
 		return true;
@@ -273,7 +273,7 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return -EINVAL;
 
 	nft_xt = container_of(expr->ops, struct nft_xt, ops);
-	nft_xt->refcnt++;
+	refcount_inc(&nft_xt->refcnt);
 	return 0;
 }
 
@@ -467,7 +467,7 @@ __nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return ret;
 
 	nft_xt = container_of(expr->ops, struct nft_xt, ops);
-	nft_xt->refcnt++;
+	refcount_inc(&nft_xt->refcnt);
 	return 0;
 }
 
@@ -769,7 +769,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nft_match->refcnt = 0;
+	refcount_set(&nft_match->refcnt, 0);
 	nft_match->ops.type = &nft_match_type;
 	nft_match->ops.eval = nft_match_eval;
 	nft_match->ops.init = nft_match_init;
@@ -873,7 +873,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nft_target->refcnt = 0;
+	refcount_set(&nft_target->refcnt, 0);
 	nft_target->ops.type = &nft_target_type;
 	nft_target->ops.size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
 	nft_target->ops.init = nft_target_init;
@@ -944,7 +944,7 @@ static void __exit nft_compat_module_exit(void)
 	list_for_each_entry_safe(xt, next, &nft_target_list, head) {
 		struct xt_target *target = xt->ops.data;
 
-		if (WARN_ON_ONCE(xt->refcnt))
+		if (WARN_ON_ONCE(refcount_read(&xt->refcnt)))
 			continue;
 		module_put(target->me);
 		kfree(xt);
@@ -953,7 +953,7 @@ static void __exit nft_compat_module_exit(void)
 	list_for_each_entry_safe(xt, next, &nft_match_list, head) {
 		struct xt_match *match = xt->ops.data;
 
-		if (WARN_ON_ONCE(xt->refcnt))
+		if (WARN_ON_ONCE(refcount_read(&xt->refcnt)))
 			continue;
 		module_put(match->me);
 		kfree(xt);
-- 
2.19.1

