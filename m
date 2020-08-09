Return-Path: <SRS0=i4m2=BT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE0CC433E1
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Aug 2020 18:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECCFB206CD
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Aug 2020 18:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgHIS2P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Aug 2020 14:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgHIS2P (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Aug 2020 14:28:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208C1C061756;
        Sun,  9 Aug 2020 11:28:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k4q3H-0006qj-Ks; Sun, 09 Aug 2020 20:28:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     lkp@lists.01.org, linux-kernel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        kernel test robot <rong.a.chen@intel.com>
Subject: [PATCH nf] netfilter: nft_compat: remove flush counter optimization
Date:   Sun,  9 Aug 2020 20:28:01 +0200
Message-Id: <20200809182801.9315-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200809063030.GA1538@shao2-debian>
References: <20200809063030.GA1538@shao2-debian>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

WARNING: CPU: 1 PID: 16059 at lib/refcount.c:31 refcount_warn_saturate+0xdf/0xf
[..]
 __nft_mt_tg_destroy+0x42/0x50 [nft_compat]
 nft_target_destroy+0x63/0x80 [nft_compat]
 nf_tables_expr_destroy+0x1b/0x30 [nf_tables]
 nf_tables_rule_destroy+0x3a/0x70 [nf_tables]
 nf_tables_exit_net+0x186/0x3d0 [nf_tables]

Happens when a compat expr is destoyed from abort path.
There is no functional impact; after this work queue is flushed
unconditionally if its pending.

This removes the waitcount optimization.  Test of repeated
iptables-restore of a ~60k kubernetes ruleset doesn't indicate
a slowdown.  In case the counter is needed after all for some workloads
we can revert this and increment the refcount for the
!= NFT_PREPARE_TRANS case to avoid the increment/decrement imbalance.

While at it, also flush for match case, this was an oversight
in the original patch.

Fixes: ffe8923f109b7e ("netfilter: nft_compat: make sure xtables destructors have run")
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_compat.c | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 6428856ccbec..8e56f353ff35 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -27,8 +27,6 @@ struct nft_xt_match_priv {
 	void *info;
 };
 
-static refcount_t nft_compat_pending_destroy = REFCOUNT_INIT(1);
-
 static int nft_compat_chain_validate_dependency(const struct nft_ctx *ctx,
 						const char *tablename)
 {
@@ -215,6 +213,17 @@ static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
 	return 0;
 }
 
+static void nft_compat_wait_for_destructors(void)
+{
+	/* xtables matches or targets can have side effects, e.g.
+	 * creation/destruction of /proc files.
+	 * The xt ->destroy functions are run asynchronously from
+	 * work queue.  If we have pending invocations we thus
+	 * need to wait for those to finish.
+	 */
+	nf_tables_trans_destroy_flush_work();
+}
+
 static int
 nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		const struct nlattr * const tb[])
@@ -238,14 +247,7 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	nft_target_set_tgchk_param(&par, ctx, target, info, &e, proto, inv);
 
-	/* xtables matches or targets can have side effects, e.g.
-	 * creation/destruction of /proc files.
-	 * The xt ->destroy functions are run asynchronously from
-	 * work queue.  If we have pending invocations we thus
-	 * need to wait for those to finish.
-	 */
-	if (refcount_read(&nft_compat_pending_destroy) > 1)
-		nf_tables_trans_destroy_flush_work();
+	nft_compat_wait_for_destructors();
 
 	ret = xt_check_target(&par, size, proto, inv);
 	if (ret < 0)
@@ -260,7 +262,6 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 static void __nft_mt_tg_destroy(struct module *me, const struct nft_expr *expr)
 {
-	refcount_dec(&nft_compat_pending_destroy);
 	module_put(me);
 	kfree(expr->ops);
 }
@@ -468,6 +469,8 @@ __nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	nft_match_set_mtchk_param(&par, ctx, match, info, &e, proto, inv);
 
+	nft_compat_wait_for_destructors();
+
 	return xt_check_match(&par, size, proto, inv);
 }
 
@@ -716,14 +719,6 @@ static const struct nfnetlink_subsystem nfnl_compat_subsys = {
 
 static struct nft_expr_type nft_match_type;
 
-static void nft_mt_tg_deactivate(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr,
-				 enum nft_trans_phase phase)
-{
-	if (phase == NFT_TRANS_COMMIT)
-		refcount_inc(&nft_compat_pending_destroy);
-}
-
 static const struct nft_expr_ops *
 nft_match_select_ops(const struct nft_ctx *ctx,
 		     const struct nlattr * const tb[])
@@ -762,7 +757,6 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	ops->type = &nft_match_type;
 	ops->eval = nft_match_eval;
 	ops->init = nft_match_init;
-	ops->deactivate = nft_mt_tg_deactivate,
 	ops->destroy = nft_match_destroy;
 	ops->dump = nft_match_dump;
 	ops->validate = nft_match_validate;
@@ -853,7 +847,6 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	ops->size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
 	ops->init = nft_target_init;
 	ops->destroy = nft_target_destroy;
-	ops->deactivate = nft_mt_tg_deactivate,
 	ops->dump = nft_target_dump;
 	ops->validate = nft_target_validate;
 	ops->data = target;
@@ -917,8 +910,6 @@ static void __exit nft_compat_module_exit(void)
 	nfnetlink_subsys_unregister(&nfnl_compat_subsys);
 	nft_unregister_expr(&nft_target_type);
 	nft_unregister_expr(&nft_match_type);
-
-	WARN_ON_ONCE(refcount_read(&nft_compat_pending_destroy) != 1);
 }
 
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_NFT_COMPAT);
-- 
2.26.2

