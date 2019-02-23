Return-Path: <SRS0=cwGx=Q6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664DBC43381
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Feb 2019 21:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C80F20652
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Feb 2019 21:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550957288;
	bh=m/80ITJYCJKFFIoAgypZScOLu1w1OMDMyOtsLmMXcU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=aVJaDFqVU7gx53PanC3wqQA8c91Ci/tdgINM8BBEX+eGshVtZd0xzyLPaJ28OKR1T
	 eItyZqOlJjuVVUOswrBHBu6YMZxNrJvpKwwqFYZQ6vNcDJpqUOllz2q99kyS7FRrWF
	 19vWPo5fa6zc57hyS6L8prLUjYX6xzl7zKMbod88=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbfBWVGt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Feb 2019 16:06:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728821AbfBWVGs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Feb 2019 16:06:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EF3320861;
        Sat, 23 Feb 2019 21:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550956007;
        bh=m/80ITJYCJKFFIoAgypZScOLu1w1OMDMyOtsLmMXcU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eDnNbcxd0AV98Er47f7CbO4FsIsF+HBR3gtkwSQj01Cch0zVyrCCf8ImmXxCK/yp3
         7SyjdlYgKbJEh0RieJbs/4wotVZNqg91Q1+HFrXjMY61+9J4YYC+1PQceTc5Vfvj61
         8CxHUkpwDg1E9c5KUDFvPnstDFKLXgLRewsIkUnk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/65] netfilter: nft_compat: make lists per netns
Date:   Sat, 23 Feb 2019 16:05:40 -0500
Message-Id: <20190223210640.200911-5-sashal@kernel.org>
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

[ Upstream commit cf52572ebbd7189a1966c2b5fc34b97078cd1dce ]

There are two problems with nft_compat since the netlink config
plane uses a per-netns mutex:

1. Concurrent add/del accesses to the same list
2. accesses to a list element after it has been free'd already.

This patch fixes the first problem.

Freeing occurs from a work queue, after transaction mutexes have been
released, i.e., it still possible for a new transaction (even from
same net ns) to find the to-be-deleted expression in the list.

The ->destroy functions are not allowed to have any such side effects,
i.e. the list_del() in the destroy function is not allowed.

This part of the problem is solved in the next patch.
I tried to make this work by serializing list access via mutex
and by moving list_del() to a deactivate callback, but
Taehee spotted following race on this approach:

  NET #0                          NET #1
   >select_ops()
   ->init()
                                   ->select_ops()
   ->deactivate()
   ->destroy()
      nft_xt_put()
       kfree_rcu(xt, rcu_head);
                                   ->init() <-- use-after-free occurred.

Unfortunately, we can't increment reference count in
select_ops(), because we can't undo the refcount increase in
case a different expression fails in the same batch.

(The destroy hook will only be called in case the expression
 was initialized successfully).

Fixes: f102d66b335a ("netfilter: nf_tables: use dedicated mutex to guard transactions")
Reported-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 129 +++++++++++++++++++++++++------------
 1 file changed, 89 insertions(+), 40 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 3e629ee59ddab..c56eb909f718c 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -22,6 +22,7 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_arp/arp_tables.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netns/generic.h>
 
 struct nft_xt {
 	struct list_head	head;
@@ -43,6 +44,20 @@ struct nft_xt_match_priv {
 	void *info;
 };
 
+struct nft_compat_net {
+	struct list_head nft_target_list;
+	struct list_head nft_match_list;
+};
+
+static unsigned int nft_compat_net_id __read_mostly;
+static struct nft_expr_type nft_match_type;
+static struct nft_expr_type nft_target_type;
+
+static struct nft_compat_net *nft_compat_pernet(struct net *net)
+{
+	return net_generic(net, nft_compat_net_id);
+}
+
 static bool nft_xt_put(struct nft_xt *xt)
 {
 	if (refcount_dec_and_test(&xt->refcnt)) {
@@ -714,10 +729,6 @@ static const struct nfnetlink_subsystem nfnl_compat_subsys = {
 	.cb		= nfnl_nft_compat_cb,
 };
 
-static LIST_HEAD(nft_match_list);
-
-static struct nft_expr_type nft_match_type;
-
 static bool nft_match_cmp(const struct xt_match *match,
 			  const char *name, u32 rev, u32 family)
 {
@@ -729,6 +740,7 @@ static const struct nft_expr_ops *
 nft_match_select_ops(const struct nft_ctx *ctx,
 		     const struct nlattr * const tb[])
 {
+	struct nft_compat_net *cn;
 	struct nft_xt *nft_match;
 	struct xt_match *match;
 	unsigned int matchsize;
@@ -745,8 +757,10 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	rev = ntohl(nla_get_be32(tb[NFTA_MATCH_REV]));
 	family = ctx->family;
 
+	cn = nft_compat_pernet(ctx->net);
+
 	/* Re-use the existing match if it's already loaded. */
-	list_for_each_entry(nft_match, &nft_match_list, head) {
+	list_for_each_entry(nft_match, &cn->nft_match_list, head) {
 		struct xt_match *match = nft_match->ops.data;
 
 		if (nft_match_cmp(match, mt_name, rev, family))
@@ -790,7 +804,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 
 	nft_match->ops.size = matchsize;
 
-	list_add(&nft_match->head, &nft_match_list);
+	list_add(&nft_match->head, &cn->nft_match_list);
 
 	return &nft_match->ops;
 err:
@@ -806,10 +820,6 @@ static struct nft_expr_type nft_match_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
-static LIST_HEAD(nft_target_list);
-
-static struct nft_expr_type nft_target_type;
-
 static bool nft_target_cmp(const struct xt_target *tg,
 			   const char *name, u32 rev, u32 family)
 {
@@ -821,6 +831,7 @@ static const struct nft_expr_ops *
 nft_target_select_ops(const struct nft_ctx *ctx,
 		      const struct nlattr * const tb[])
 {
+	struct nft_compat_net *cn;
 	struct nft_xt *nft_target;
 	struct xt_target *target;
 	char *tg_name;
@@ -841,8 +852,9 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	    strcmp(tg_name, "standard") == 0)
 		return ERR_PTR(-EINVAL);
 
+	cn = nft_compat_pernet(ctx->net);
 	/* Re-use the existing target if it's already loaded. */
-	list_for_each_entry(nft_target, &nft_target_list, head) {
+	list_for_each_entry(nft_target, &cn->nft_target_list, head) {
 		struct xt_target *target = nft_target->ops.data;
 
 		if (!target->target)
@@ -887,7 +899,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	else
 		nft_target->ops.eval = nft_target_eval_xt;
 
-	list_add(&nft_target->head, &nft_target_list);
+	list_add(&nft_target->head, &cn->nft_target_list);
 
 	return &nft_target->ops;
 err:
@@ -903,13 +915,74 @@ static struct nft_expr_type nft_target_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
+static int __net_init nft_compat_init_net(struct net *net)
+{
+	struct nft_compat_net *cn = nft_compat_pernet(net);
+
+	INIT_LIST_HEAD(&cn->nft_target_list);
+	INIT_LIST_HEAD(&cn->nft_match_list);
+
+	return 0;
+}
+
+static void __net_exit nft_compat_exit_net(struct net *net)
+{
+	struct nft_compat_net *cn = nft_compat_pernet(net);
+	struct nft_xt *xt, *next;
+
+	if (list_empty(&cn->nft_match_list) &&
+	    list_empty(&cn->nft_target_list))
+		return;
+
+	/* If there was an error that caused nft_xt expr to not be initialized
+	 * fully and noone else requested the same expression later, the lists
+	 * contain 0-refcount entries that still hold module reference.
+	 *
+	 * Clean them here.
+	 */
+	mutex_lock(&net->nft.commit_mutex);
+	list_for_each_entry_safe(xt, next, &cn->nft_target_list, head) {
+		struct xt_target *target = xt->ops.data;
+
+		list_del_init(&xt->head);
+
+		if (refcount_read(&xt->refcnt))
+			continue;
+		module_put(target->me);
+		kfree(xt);
+	}
+
+	list_for_each_entry_safe(xt, next, &cn->nft_match_list, head) {
+		struct xt_match *match = xt->ops.data;
+
+		list_del_init(&xt->head);
+
+		if (refcount_read(&xt->refcnt))
+			continue;
+		module_put(match->me);
+		kfree(xt);
+	}
+	mutex_unlock(&net->nft.commit_mutex);
+}
+
+static struct pernet_operations nft_compat_net_ops = {
+	.init	= nft_compat_init_net,
+	.exit	= nft_compat_exit_net,
+	.id	= &nft_compat_net_id,
+	.size	= sizeof(struct nft_compat_net),
+};
+
 static int __init nft_compat_module_init(void)
 {
 	int ret;
 
+	ret = register_pernet_subsys(&nft_compat_net_ops);
+	if (ret < 0)
+		goto err_target;
+
 	ret = nft_register_expr(&nft_match_type);
 	if (ret < 0)
-		return ret;
+		goto err_pernet;
 
 	ret = nft_register_expr(&nft_target_type);
 	if (ret < 0)
@@ -922,45 +995,21 @@ static int __init nft_compat_module_init(void)
 	}
 
 	return ret;
-
 err_target:
 	nft_unregister_expr(&nft_target_type);
 err_match:
 	nft_unregister_expr(&nft_match_type);
+err_pernet:
+	unregister_pernet_subsys(&nft_compat_net_ops);
 	return ret;
 }
 
 static void __exit nft_compat_module_exit(void)
 {
-	struct nft_xt *xt, *next;
-
-	/* list should be empty here, it can be non-empty only in case there
-	 * was an error that caused nft_xt expr to not be initialized fully
-	 * and noone else requested the same expression later.
-	 *
-	 * In this case, the lists contain 0-refcount entries that still
-	 * hold module reference.
-	 */
-	list_for_each_entry_safe(xt, next, &nft_target_list, head) {
-		struct xt_target *target = xt->ops.data;
-
-		if (WARN_ON_ONCE(refcount_read(&xt->refcnt)))
-			continue;
-		module_put(target->me);
-		kfree(xt);
-	}
-
-	list_for_each_entry_safe(xt, next, &nft_match_list, head) {
-		struct xt_match *match = xt->ops.data;
-
-		if (WARN_ON_ONCE(refcount_read(&xt->refcnt)))
-			continue;
-		module_put(match->me);
-		kfree(xt);
-	}
 	nfnetlink_subsys_unregister(&nfnl_compat_subsys);
 	nft_unregister_expr(&nft_target_type);
 	nft_unregister_expr(&nft_match_type);
+	unregister_pernet_subsys(&nft_compat_net_ops);
 }
 
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_NFT_COMPAT);
-- 
2.19.1

