Return-Path: <SRS0=cwGx=Q6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1682C4360F
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Feb 2019 21:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94CFC206B6
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Feb 2019 21:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550955878;
	bh=fxjziN0NIrFrP471E1bKVWdmhc2aaJOPYJLblK/FAiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Xbmqt0zgNwpKTuObPiSUXbcIOtFXacDZoBG26G7hphDd0Cd8ngvU9ZK7msoH5cqlD
	 wCXx0MZq8tAoCqa3nRV83r2kM2bkJYsiJq6zuhsueSkEsd/ovfNgSgd32z2YywUGHm
	 jiWo3DFVcHDGhqf2AFQPbEJdI9ti9ldeg58W22no=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfBWVEg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Feb 2019 16:04:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:39662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbfBWVEf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Feb 2019 16:04:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A80720855;
        Sat, 23 Feb 2019 21:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550955874;
        bh=fxjziN0NIrFrP471E1bKVWdmhc2aaJOPYJLblK/FAiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFJPWxGTTVFJkRhWKiBQ+UhcaSYRId+guULyJGU737ahcccMAM8G9k9MNAGIkvPos
         n9Tc4ghtaWxToEpByZoS6mf+WhuyPI/O2S8V5ytV2wU/f0e0PXm1xT68XCUukO+puw
         jRBbpuikYLxwJZil76BmPEX9MurE0GsztzDe59ls=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 07/72] netfilter: nft_compat: destroy function must not have side effects
Date:   Sat, 23 Feb 2019 16:03:17 -0500
Message-Id: <20190223210422.199966-7-sashal@kernel.org>
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

[ Upstream commit b2e3d68d1251a051a620f9086e18f7ffa6833b5b ]

The nft_compat destroy function deletes the nft_xt object from a list.
This isn't allowed anymore. Destroy functions are called asynchronously,
i.e. next batch can find the object that has a pending ->destroy()
invocation:

cpu0                       cpu1
 worker
   ->destroy               for_each_entry()
	                     if (x == ...
			        return x->ops;
     list_del(x)
     kfree_rcu(x)
                           expr->ops->... // ops was free'd

To resolve this, the list_del needs to occur before the transaction
mutex gets released.  nf_tables has a 'deactivate' hook for this
purpose, so use that to unlink the object from the list.

Fixes: 0935d5588400 ("netfilter: nf_tables: asynchronous release")
Reported-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 48 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index abed3490a8f8a..5eb269428832c 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -29,6 +29,9 @@ struct nft_xt {
 	struct nft_expr_ops	ops;
 	refcount_t		refcnt;
 
+	/* used only when transaction mutex is locked */
+	unsigned int		listcnt;
+
 	/* Unlike other expressions, ops doesn't have static storage duration.
 	 * nft core assumes they do.  We use kfree_rcu so that nft core can
 	 * can check expr->ops->size even after nft_compat->destroy() frees
@@ -61,7 +64,7 @@ static struct nft_compat_net *nft_compat_pernet(struct net *net)
 static bool nft_xt_put(struct nft_xt *xt)
 {
 	if (refcount_dec_and_test(&xt->refcnt)) {
-		list_del(&xt->head);
+		WARN_ON_ONCE(!list_empty(&xt->head));
 		kfree_rcu(xt, rcu_head);
 		return true;
 	}
@@ -555,6 +558,43 @@ nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 	__nft_match_destroy(ctx, expr, nft_expr_priv(expr));
 }
 
+static void nft_compat_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr,
+				struct list_head *h)
+{
+	struct nft_xt *xt = container_of(expr->ops, struct nft_xt, ops);
+
+	if (xt->listcnt == 0)
+		list_add(&xt->head, h);
+
+	xt->listcnt++;
+}
+
+static void nft_compat_activate_mt(const struct nft_ctx *ctx,
+				   const struct nft_expr *expr)
+{
+	struct nft_compat_net *cn = nft_compat_pernet(ctx->net);
+
+	nft_compat_activate(ctx, expr, &cn->nft_match_list);
+}
+
+static void nft_compat_activate_tg(const struct nft_ctx *ctx,
+				   const struct nft_expr *expr)
+{
+	struct nft_compat_net *cn = nft_compat_pernet(ctx->net);
+
+	nft_compat_activate(ctx, expr, &cn->nft_target_list);
+}
+
+static void nft_compat_deactivate(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr)
+{
+	struct nft_xt *xt = container_of(expr->ops, struct nft_xt, ops);
+
+	if (--xt->listcnt == 0)
+		list_del_init(&xt->head);
+}
+
 static void
 nft_match_large_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
@@ -808,6 +848,8 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	nft_match->ops.eval = nft_match_eval;
 	nft_match->ops.init = nft_match_init;
 	nft_match->ops.destroy = nft_match_destroy;
+	nft_match->ops.activate = nft_compat_activate_mt;
+	nft_match->ops.deactivate = nft_compat_deactivate;
 	nft_match->ops.dump = nft_match_dump;
 	nft_match->ops.validate = nft_match_validate;
 	nft_match->ops.data = match;
@@ -824,6 +866,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 
 	nft_match->ops.size = matchsize;
 
+	nft_match->listcnt = 1;
 	list_add(&nft_match->head, &cn->nft_match_list);
 
 	return &nft_match->ops;
@@ -910,6 +953,8 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	nft_target->ops.size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
 	nft_target->ops.init = nft_target_init;
 	nft_target->ops.destroy = nft_target_destroy;
+	nft_target->ops.activate = nft_compat_activate_tg;
+	nft_target->ops.deactivate = nft_compat_deactivate;
 	nft_target->ops.dump = nft_target_dump;
 	nft_target->ops.validate = nft_target_validate;
 	nft_target->ops.data = target;
@@ -919,6 +964,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	else
 		nft_target->ops.eval = nft_target_eval_xt;
 
+	nft_target->listcnt = 1;
 	list_add(&nft_target->head, &cn->nft_target_list);
 
 	return &nft_target->ops;
-- 
2.19.1

