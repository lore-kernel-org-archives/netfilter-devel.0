Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 186F5C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Mar 2022 10:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiCLKuf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Mar 2022 05:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiCLKuf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Mar 2022 05:50:35 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A00066CBC
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 02:49:29 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0685860866;
        Sat, 12 Mar 2022 11:47:20 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     strlen.de@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables: do not reduce read-only expressions
Date:   Sat, 12 Mar 2022 11:49:25 +0100
Message-Id: <20220312104925.11590-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip register tracking for expressions that perform read-only operations
on the registers. Define and use a cookie pointer NFT_REDUCE_READONLY to
avoid defining stubs for these expressions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
as an alternative to define stubs everywhere.

 include/net/netfilter/nf_tables.h | 10 ++++++++++
 net/netfilter/nf_tables_api.c     |  2 ++
 net/netfilter/nft_cmp.c           |  3 +++
 net/netfilter/nft_compat.c        |  1 +
 net/netfilter/nft_connlimit.c     |  1 +
 net/netfilter/nft_counter.c       |  1 +
 net/netfilter/nft_ct.c            |  1 +
 net/netfilter/nft_dup_netdev.c    |  1 +
 net/netfilter/nft_flow_offload.c  |  1 +
 net/netfilter/nft_fwd_netdev.c    |  2 ++
 net/netfilter/nft_last.c          |  1 +
 net/netfilter/nft_limit.c         |  2 ++
 net/netfilter/nft_log.c           |  1 +
 net/netfilter/nft_masq.c          |  3 +++
 net/netfilter/nft_nat.c           |  2 ++
 net/netfilter/nft_objref.c        |  2 ++
 net/netfilter/nft_queue.c         |  2 ++
 net/netfilter/nft_quota.c         |  1 +
 net/netfilter/nft_range.c         |  1 +
 net/netfilter/nft_redir.c         |  3 +++
 net/netfilter/nft_reject_inet.c   |  1 +
 net/netfilter/nft_reject_netdev.c |  1 +
 net/netfilter/nft_rt.c            |  1 +
 net/netfilter/nft_synproxy.c      |  1 +
 net/netfilter/nft_tproxy.c        |  1 +
 25 files changed, 46 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c4c0861deac1..cea50bfa406d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1633,4 +1633,14 @@ static inline struct nftables_pernet *nft_pernet(const struct net *net)
 	return net_generic(net, nf_tables_net_id);
 }
 
+#define NFT_REDUCE_INFOMASK	1UL
+#define __NFT_REDUCE_READONLY	1UL
+#define NFT_REDUCE_READONLY	(void *)__NFT_REDUCE_READONLY
+#define NFT_REDUCE_PTRMASK	~(NFT_REDUCE_INFOMASK)
+
+static inline bool nft_reduce_is_readonly(struct expr *expr)
+{
+	return expr->ops->reduce & NFT_REDUCE_INFOMASK == __NFT_REDUCE_READONLY;
+}
+
 #endif /* _NET_NF_TABLES_H */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3168ad8cffd1..0fbe7d4ac3c6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9842,6 +9842,8 @@ static int __init nf_tables_module_init(void)
 {
 	int err;
 
+	BUILD_BUG_ON(NFT_REDUCE_INFOMASK <= NFT_REDUCE_READONLY);
+
 	err = register_pernet_subsys(&nf_tables_net_ops);
 	if (err < 0)
 		return err;
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 917072af09df..6528f76ca29e 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -193,6 +193,7 @@ static const struct nft_expr_ops nft_cmp_ops = {
 	.eval		= nft_cmp_eval,
 	.init		= nft_cmp_init,
 	.dump		= nft_cmp_dump,
+	.reduce		= NFT_REDUCE_READONLY,
 	.offload	= nft_cmp_offload,
 };
 
@@ -269,6 +270,7 @@ const struct nft_expr_ops nft_cmp_fast_ops = {
 	.eval		= NULL,	/* inlined */
 	.init		= nft_cmp_fast_init,
 	.dump		= nft_cmp_fast_dump,
+	.reduce		= NFT_REDUCE_READONLY,
 	.offload	= nft_cmp_fast_offload,
 };
 
@@ -359,6 +361,7 @@ const struct nft_expr_ops nft_cmp16_fast_ops = {
 	.eval		= NULL,	/* inlined */
 	.init		= nft_cmp16_fast_init,
 	.dump		= nft_cmp16_fast_dump,
+	.reduce		= NFT_REDUCE_READONLY,
 	.offload	= nft_cmp16_fast_offload,
 };
 
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 5a46d8289d1d..c16172427622 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -871,6 +871,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	ops->dump = nft_target_dump;
 	ops->validate = nft_target_validate;
 	ops->data = target;
+	ops->reduce = NFT_REDUCE_READONLY;
 
 	if (family == NFPROTO_BRIDGE)
 		ops->eval = nft_target_eval_bridge;
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 3362417ebfdb..67fa70486c8b 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -257,6 +257,7 @@ static const struct nft_expr_ops nft_connlimit_ops = {
 	.destroy_clone	= nft_connlimit_destroy_clone,
 	.dump		= nft_connlimit_dump,
 	.gc		= nft_connlimit_gc,
+	.reduce		= nft_connlimit_reduce,
 };
 
 static struct nft_expr_type nft_connlimit_type __read_mostly = {
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index f179e8c3b0ca..da9083605a61 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -293,6 +293,7 @@ static const struct nft_expr_ops nft_counter_ops = {
 	.destroy_clone	= nft_counter_destroy,
 	.dump		= nft_counter_dump,
 	.clone		= nft_counter_clone,
+	.reduce		= NFT_REDUCE_READONLY,
 	.offload	= nft_counter_offload,
 	.offload_stats	= nft_counter_offload_stats,
 };
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 66ee49045d8e..20d04fef6d42 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -832,6 +832,7 @@ static const struct nft_expr_ops nft_notrack_ops = {
 	.type		= &nft_notrack_type,
 	.size		= NFT_EXPR_SIZE(0),
 	.eval		= nft_notrack_eval,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_notrack_type __read_mostly = {
diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
index 5b5c607fbf83..63507402716d 100644
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -79,6 +79,7 @@ static const struct nft_expr_ops nft_dup_netdev_ops = {
 	.eval		= nft_dup_netdev_eval,
 	.init		= nft_dup_netdev_init,
 	.dump		= nft_dup_netdev_dump,
+	.reduce		= NFT_REDUCE_READONLY,
 	.offload	= nft_dup_netdev_offload,
 	.offload_action	= nft_dup_netdev_offload_action,
 };
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 731b5d87ef45..900d48c810a1 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -441,6 +441,7 @@ static const struct nft_expr_ops nft_flow_offload_ops = {
 	.destroy	= nft_flow_offload_destroy,
 	.validate	= nft_flow_offload_validate,
 	.dump		= nft_flow_offload_dump,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_flow_offload_type __read_mostly = {
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 619e394a91de..d566e8ea49d7 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -217,6 +217,7 @@ static const struct nft_expr_ops nft_fwd_neigh_netdev_ops = {
 	.init		= nft_fwd_neigh_init,
 	.dump		= nft_fwd_neigh_dump,
 	.validate	= nft_fwd_validate,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nft_expr_ops nft_fwd_netdev_ops = {
@@ -226,6 +227,7 @@ static const struct nft_expr_ops nft_fwd_netdev_ops = {
 	.init		= nft_fwd_netdev_init,
 	.dump		= nft_fwd_netdev_dump,
 	.validate	= nft_fwd_validate,
+	.reduce		= NFT_REDUCE_READONLY,
 	.offload	= nft_fwd_netdev_offload,
 	.offload_action	= nft_fwd_netdev_offload_action,
 };
diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index 4f745a409d34..43d0d4aadb1f 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -120,6 +120,7 @@ static const struct nft_expr_ops nft_last_ops = {
 	.destroy	= nft_last_destroy,
 	.clone		= nft_last_clone,
 	.dump		= nft_last_dump,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 struct nft_expr_type nft_last_type __read_mostly = {
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index a726b623963d..d4a6cf3cd697 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -225,6 +225,7 @@ static const struct nft_expr_ops nft_limit_pkts_ops = {
 	.destroy	= nft_limit_pkts_destroy,
 	.clone		= nft_limit_pkts_clone,
 	.dump		= nft_limit_pkts_dump,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static void nft_limit_bytes_eval(const struct nft_expr *expr,
@@ -279,6 +280,7 @@ static const struct nft_expr_ops nft_limit_bytes_ops = {
 	.dump		= nft_limit_bytes_dump,
 	.clone		= nft_limit_bytes_clone,
 	.destroy	= nft_limit_bytes_destroy,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 54f6c2035e84..0e13c003f0c1 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -290,6 +290,7 @@ static const struct nft_expr_ops nft_log_ops = {
 	.init		= nft_log_init,
 	.destroy	= nft_log_destroy,
 	.dump		= nft_log_dump,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_log_type __read_mostly = {
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 9953e8053753..2a0adc497bbb 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -129,6 +129,7 @@ static const struct nft_expr_ops nft_masq_ipv4_ops = {
 	.destroy	= nft_masq_ipv4_destroy,
 	.dump		= nft_masq_dump,
 	.validate	= nft_masq_validate,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_masq_ipv4_type __read_mostly = {
@@ -175,6 +176,7 @@ static const struct nft_expr_ops nft_masq_ipv6_ops = {
 	.destroy	= nft_masq_ipv6_destroy,
 	.dump		= nft_masq_dump,
 	.validate	= nft_masq_validate,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_masq_ipv6_type __read_mostly = {
@@ -230,6 +232,7 @@ static const struct nft_expr_ops nft_masq_inet_ops = {
 	.destroy	= nft_masq_inet_destroy,
 	.dump		= nft_masq_dump,
 	.validate	= nft_masq_validate,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_masq_inet_type __read_mostly = {
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index be1595d6979d..4394df4bc99b 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -317,6 +317,7 @@ static const struct nft_expr_ops nft_nat_ops = {
 	.destroy        = nft_nat_destroy,
 	.dump           = nft_nat_dump,
 	.validate	= nft_nat_validate,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_nat_type __read_mostly = {
@@ -346,6 +347,7 @@ static const struct nft_expr_ops nft_nat_inet_ops = {
 	.destroy        = nft_nat_destroy,
 	.dump           = nft_nat_dump,
 	.validate	= nft_nat_validate,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_inet_nat_type __read_mostly = {
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 94b2327e71dc..5d8d91b3904d 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -91,6 +91,7 @@ static const struct nft_expr_ops nft_objref_ops = {
 	.activate	= nft_objref_activate,
 	.deactivate	= nft_objref_deactivate,
 	.dump		= nft_objref_dump,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 struct nft_objref_map {
@@ -204,6 +205,7 @@ static const struct nft_expr_ops nft_objref_map_ops = {
 	.deactivate	= nft_objref_map_deactivate,
 	.destroy	= nft_objref_map_destroy,
 	.dump		= nft_objref_map_dump,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index 9ba1de51ac07..15e4b7640dc0 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -164,6 +164,7 @@ static const struct nft_expr_ops nft_queue_ops = {
 	.eval		= nft_queue_eval,
 	.init		= nft_queue_init,
 	.dump		= nft_queue_dump,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nft_expr_ops nft_queue_sreg_ops = {
@@ -172,6 +173,7 @@ static const struct nft_expr_ops nft_queue_sreg_ops = {
 	.eval		= nft_queue_sreg_eval,
 	.init		= nft_queue_sreg_init,
 	.dump		= nft_queue_sreg_dump,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index f394a0b562f6..d7db57ed3bc1 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -254,6 +254,7 @@ static const struct nft_expr_ops nft_quota_ops = {
 	.destroy	= nft_quota_destroy,
 	.clone		= nft_quota_clone,
 	.dump		= nft_quota_dump,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_quota_type __read_mostly = {
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index e4a1c44d7f51..66f77484c227 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -140,6 +140,7 @@ static const struct nft_expr_ops nft_range_ops = {
 	.eval		= nft_range_eval,
 	.init		= nft_range_init,
 	.dump		= nft_range_dump,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 struct nft_expr_type nft_range_type __read_mostly = {
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index ba09890dddb5..5086adfe731c 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -134,6 +134,7 @@ static const struct nft_expr_ops nft_redir_ipv4_ops = {
 	.destroy	= nft_redir_ipv4_destroy,
 	.dump		= nft_redir_dump,
 	.validate	= nft_redir_validate,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_redir_ipv4_type __read_mostly = {
@@ -183,6 +184,7 @@ static const struct nft_expr_ops nft_redir_ipv6_ops = {
 	.destroy	= nft_redir_ipv6_destroy,
 	.dump		= nft_redir_dump,
 	.validate	= nft_redir_validate,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_redir_ipv6_type __read_mostly = {
@@ -225,6 +227,7 @@ static const struct nft_expr_ops nft_redir_inet_ops = {
 	.destroy	= nft_redir_inet_destroy,
 	.dump		= nft_redir_dump,
 	.validate	= nft_redir_validate,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_redir_inet_type __read_mostly = {
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index 554caf967baa..973fa31a9dd6 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -80,6 +80,7 @@ static const struct nft_expr_ops nft_reject_inet_ops = {
 	.init		= nft_reject_init,
 	.dump		= nft_reject_dump,
 	.validate	= nft_reject_inet_validate,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_reject_inet_type __read_mostly = {
diff --git a/net/netfilter/nft_reject_netdev.c b/net/netfilter/nft_reject_netdev.c
index 61cd8c4ac385..7865cd8b11bb 100644
--- a/net/netfilter/nft_reject_netdev.c
+++ b/net/netfilter/nft_reject_netdev.c
@@ -159,6 +159,7 @@ static const struct nft_expr_ops nft_reject_netdev_ops = {
 	.init		= nft_reject_init,
 	.dump		= nft_reject_dump,
 	.validate	= nft_reject_netdev_validate,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_reject_netdev_type __read_mostly = {
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index bcd01a63e38f..71931ec91721 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -191,6 +191,7 @@ static const struct nft_expr_ops nft_rt_get_ops = {
 	.init		= nft_rt_get_init,
 	.dump		= nft_rt_get_dump,
 	.validate	= nft_rt_validate,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 struct nft_expr_type nft_rt_type __read_mostly = {
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 1133e06f3c40..6cf9a04fbfe2 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -288,6 +288,7 @@ static const struct nft_expr_ops nft_synproxy_ops = {
 	.dump		= nft_synproxy_dump,
 	.type		= &nft_synproxy_type,
 	.validate	= nft_synproxy_validate,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_synproxy_type __read_mostly = {
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index b5b09a902c7a..801f013971df 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -320,6 +320,7 @@ static const struct nft_expr_ops nft_tproxy_ops = {
 	.init		= nft_tproxy_init,
 	.destroy	= nft_tproxy_destroy,
 	.dump		= nft_tproxy_dump,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static struct nft_expr_type nft_tproxy_type __read_mostly = {
-- 
2.30.2

