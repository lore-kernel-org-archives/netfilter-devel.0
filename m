Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB68C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Mar 2022 10:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348080AbiCKKzo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Mar 2022 05:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiCKKzj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Mar 2022 05:55:39 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8732D1B60B8
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Mar 2022 02:54:36 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nScup-0002E0-17; Fri, 11 Mar 2022 11:54:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_tables: add stubs for readonly expressions
Date:   Fri, 11 Mar 2022 11:54:30 +0100
Message-Id: <20220311105430.12075-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

None of these write to a register, so there is no need to cancel
tracking.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_cmp.c        | 1 +
 net/netfilter/nft_ct.c         | 1 +
 net/netfilter/nft_dup_netdev.c | 7 +++++++
 net/netfilter/nft_fwd_netdev.c | 8 ++++++++
 net/netfilter/nft_log.c        | 7 +++++++
 net/netfilter/nft_masq.c       | 7 +++++++
 net/netfilter/nft_nat.c        | 8 ++++++++
 net/netfilter/nft_range.c      | 7 +++++++
 8 files changed, 46 insertions(+)

diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 9ec5cb0e6331..f46a47ccd0b8 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -368,6 +368,7 @@ const struct nft_expr_ops nft_cmp16_fast_ops = {
 	.init		= nft_cmp16_fast_init,
 	.dump		= nft_cmp16_fast_dump,
 	.offload	= nft_cmp16_fast_offload,
+	.reduce		= nft_cmp_reduce,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 66ee49045d8e..eb0dae5bef6d 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -776,6 +776,7 @@ static const struct nft_expr_ops nft_ct_set_zone_ops = {
 	.init		= nft_ct_set_init,
 	.destroy	= nft_ct_set_destroy,
 	.dump		= nft_ct_set_dump,
+	.reduce		= nft_ct_set_reduce,
 };
 #endif
 
diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
index 5b5c607fbf83..9476658c97b7 100644
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -72,6 +72,12 @@ static bool nft_dup_netdev_offload_action(const struct nft_expr *expr)
 	return true;
 }
 
+static bool nft_dup_reduce(struct nft_regs_track *track,
+                           const struct nft_expr *expr)
+{
+	return false;
+}
+
 static struct nft_expr_type nft_dup_netdev_type;
 static const struct nft_expr_ops nft_dup_netdev_ops = {
 	.type		= &nft_dup_netdev_type,
@@ -81,6 +87,7 @@ static const struct nft_expr_ops nft_dup_netdev_ops = {
 	.dump		= nft_dup_netdev_dump,
 	.offload	= nft_dup_netdev_offload,
 	.offload_action	= nft_dup_netdev_offload_action,
+	.reduce		= nft_dup_reduce,
 };
 
 static struct nft_expr_type nft_dup_netdev_type __read_mostly = {
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 619e394a91de..b76a4084a6a0 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -209,6 +209,12 @@ static int nft_fwd_validate(const struct nft_ctx *ctx,
 						    (1 << NF_NETDEV_EGRESS));
 }
 
+static bool nft_fwd_reduce(struct nft_regs_track *track,
+                           const struct nft_expr *expr)
+{
+	return false;
+}
+
 static struct nft_expr_type nft_fwd_netdev_type;
 static const struct nft_expr_ops nft_fwd_neigh_netdev_ops = {
 	.type		= &nft_fwd_netdev_type,
@@ -217,6 +223,7 @@ static const struct nft_expr_ops nft_fwd_neigh_netdev_ops = {
 	.init		= nft_fwd_neigh_init,
 	.dump		= nft_fwd_neigh_dump,
 	.validate	= nft_fwd_validate,
+	.reduce		= nft_fwd_reduce,
 };
 
 static const struct nft_expr_ops nft_fwd_netdev_ops = {
@@ -228,6 +235,7 @@ static const struct nft_expr_ops nft_fwd_netdev_ops = {
 	.validate	= nft_fwd_validate,
 	.offload	= nft_fwd_netdev_offload,
 	.offload_action	= nft_fwd_netdev_offload_action,
+	.reduce		= nft_fwd_reduce,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 54f6c2035e84..27dbf7d7beed 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -282,12 +282,19 @@ static int nft_log_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static bool nft_log_reduce(struct nft_regs_track *track,
+			   const struct nft_expr *expr)
+{
+	return false;
+}
+
 static struct nft_expr_type nft_log_type;
 static const struct nft_expr_ops nft_log_ops = {
 	.type		= &nft_log_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_log)),
 	.eval		= nft_log_eval,
 	.init		= nft_log_init,
+	.reduce		= nft_log_reduce,
 	.destroy	= nft_log_destroy,
 	.dump		= nft_log_dump,
 };
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 9953e8053753..48a3a711fa1a 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -221,6 +221,12 @@ nft_masq_inet_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 	nf_ct_netns_put(ctx->net, NFPROTO_INET);
 }
 
+static bool nft_masq_reduce(struct nft_regs_track *track,
+			    const struct nft_expr *expr)
+{
+	return false;
+}
+
 static struct nft_expr_type nft_masq_inet_type;
 static const struct nft_expr_ops nft_masq_inet_ops = {
 	.type		= &nft_masq_inet_type,
@@ -230,6 +236,7 @@ static const struct nft_expr_ops nft_masq_inet_ops = {
 	.destroy	= nft_masq_inet_destroy,
 	.dump		= nft_masq_dump,
 	.validate	= nft_masq_validate,
+	.reduce		= nft_masq_reduce,
 };
 
 static struct nft_expr_type nft_masq_inet_type __read_mostly = {
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index be1595d6979d..81c1be454378 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -308,6 +308,12 @@ nft_nat_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 	nf_ct_netns_put(ctx->net, priv->family);
 }
 
+static bool nft_nat_reduce(struct nft_regs_track *track,
+			    const struct nft_expr *expr)
+{
+	return false;
+}
+
 static struct nft_expr_type nft_nat_type;
 static const struct nft_expr_ops nft_nat_ops = {
 	.type           = &nft_nat_type,
@@ -317,6 +323,7 @@ static const struct nft_expr_ops nft_nat_ops = {
 	.destroy        = nft_nat_destroy,
 	.dump           = nft_nat_dump,
 	.validate	= nft_nat_validate,
+	.reduce		= nft_nat_reduce,
 };
 
 static struct nft_expr_type nft_nat_type __read_mostly = {
@@ -346,6 +353,7 @@ static const struct nft_expr_ops nft_nat_inet_ops = {
 	.destroy        = nft_nat_destroy,
 	.dump           = nft_nat_dump,
 	.validate	= nft_nat_validate,
+	.reduce		= nft_nat_reduce,
 };
 
 static struct nft_expr_type nft_inet_nat_type __read_mostly = {
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index e4a1c44d7f51..bfd692a5e527 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -134,12 +134,19 @@ static int nft_range_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static bool nft_range_reduce(struct nft_regs_track *track,
+			     const struct nft_expr *expr)
+{
+	return false;
+}
+
 static const struct nft_expr_ops nft_range_ops = {
 	.type		= &nft_range_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_range_expr)),
 	.eval		= nft_range_eval,
 	.init		= nft_range_init,
 	.dump		= nft_range_dump,
+	.reduce		= nft_range_reduce,
 };
 
 struct nft_expr_type nft_range_type __read_mostly = {
-- 
2.34.1

