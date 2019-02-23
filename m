Return-Path: <SRS0=cwGx=Q6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DCFC4360F
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Feb 2019 21:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAC4D20661
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Feb 2019 21:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550957675;
	bh=iqXW3z7SXbyz+MFAlQfrgqROqWsBrSwuiPdbatg+CqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=S1hE6fZpF4YppJuAYyNdtDG7pVh+eFuibgzMf2CyBCBJ8GI6HYCC05JOJI0gaCCp3
	 XIlHZGe8l6F0bJ2K5MqlwxZQcn5tTc+nImbOU3uRzSDWCw7GU2W5tRQ+6vNYAJeydL
	 FTU/YHladDtdYIyXdJ50uQnKWu3ryVAwTX8ioh9Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbfBWVEd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Feb 2019 16:04:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbfBWVEc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Feb 2019 16:04:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C3BE206B6;
        Sat, 23 Feb 2019 21:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550955871;
        bh=iqXW3z7SXbyz+MFAlQfrgqROqWsBrSwuiPdbatg+CqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FaRdf3zViFvxvP0E7Fd2DfWiklf4FG5EbYuzFgTZPuDTFp0aOClDk95kR34v8NctU
         0CtL6UP1IIZ3jVomJD44iw6dfsGEEAzvhJbwAGy+RnZjxkN2H/S/4MEuNoRGzQuhZX
         3czY7kkWv7QNb6cdzHMBJmHrahVt0cH71IgQ0eAs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 05/72] netfilter: nft_compat: use refcnt_t type for nft_xt reference count
Date:   Sat, 23 Feb 2019 16:03:15 -0500
Message-Id: <20190223210422.199966-5-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190223210422.199966-1-sashal@kernel.org>
References: <20190223210422.199966-1-sashal@kernel.org>
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
index 7334e0b80a5ef..acc85acad31bd 100644
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
 
@@ -486,7 +486,7 @@ __nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return ret;
 
 	nft_xt = container_of(expr->ops, struct nft_xt, ops);
-	nft_xt->refcnt++;
+	refcount_inc(&nft_xt->refcnt);
 	return 0;
 }
 
@@ -789,7 +789,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nft_match->refcnt = 0;
+	refcount_set(&nft_match->refcnt, 0);
 	nft_match->ops.type = &nft_match_type;
 	nft_match->ops.eval = nft_match_eval;
 	nft_match->ops.init = nft_match_init;
@@ -893,7 +893,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nft_target->refcnt = 0;
+	refcount_set(&nft_target->refcnt, 0);
 	nft_target->ops.type = &nft_target_type;
 	nft_target->ops.size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
 	nft_target->ops.init = nft_target_init;
@@ -964,7 +964,7 @@ static void __exit nft_compat_module_exit(void)
 	list_for_each_entry_safe(xt, next, &nft_target_list, head) {
 		struct xt_target *target = xt->ops.data;
 
-		if (WARN_ON_ONCE(xt->refcnt))
+		if (WARN_ON_ONCE(refcount_read(&xt->refcnt)))
 			continue;
 		module_put(target->me);
 		kfree(xt);
@@ -973,7 +973,7 @@ static void __exit nft_compat_module_exit(void)
 	list_for_each_entry_safe(xt, next, &nft_match_list, head) {
 		struct xt_match *match = xt->ops.data;
 
-		if (WARN_ON_ONCE(xt->refcnt))
+		if (WARN_ON_ONCE(refcount_read(&xt->refcnt)))
 			continue;
 		module_put(match->me);
 		kfree(xt);
-- 
2.19.1

