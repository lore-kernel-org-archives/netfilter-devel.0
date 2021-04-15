Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 047D6C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 19:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C47FC60FF0
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 19:48:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbhDOTs1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 15:48:27 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58736 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234735AbhDOTs0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 15:48:26 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2B5FE63E45;
        Thu, 15 Apr 2021 21:47:35 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     wenxu@cloud.cn
Subject: [PATCH nf-next] netfilter: nftables: counter hardware offload support
Date:   Thu, 15 Apr 2021 21:47:57 +0200
Message-Id: <20210415194757.1991-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds the .offload_stats operation to synchronize hardware
stats with the expression data. Update the counter expression to use
this new interface. The hardware stats are retrieved from the netlink
dump path via FLOW_CLS_STATS command to the driver.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h         |  2 ++
 include/net/netfilter/nf_tables_offload.h |  1 +
 net/netfilter/nf_tables_api.c             |  3 ++
 net/netfilter/nf_tables_offload.c         | 44 +++++++++++++++++++----
 net/netfilter/nft_counter.c               | 30 ++++++++++++++++
 5 files changed, 73 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5aaced6bf13e..9619052fb80f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -867,6 +867,8 @@ struct nft_expr_ops {
 	int				(*offload)(struct nft_offload_ctx *ctx,
 						   struct nft_flow_rule *flow,
 						   const struct nft_expr *expr);
+	void				(*offload_stats)(struct nft_expr *expr,
+							 const struct flow_stats *stats);
 	u32				offload_flags;
 	const struct nft_expr_type	*type;
 	void				*data;
diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 1d34fe154fe0..b8c2d5f0b328 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -68,6 +68,7 @@ void nft_flow_rule_set_addr_type(struct nft_flow_rule *flow,
 
 struct nft_rule;
 struct nft_flow_rule *nft_flow_rule_create(struct net *net, const struct nft_rule *rule);
+int nft_flow_rule_stats(const struct nft_chain *chain, const struct nft_rule *rule);
 void nft_flow_rule_destroy(struct nft_flow_rule *flow);
 int nft_flow_rule_offload_commit(struct net *net);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 589d2f6978d3..4504904bfe35 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2832,6 +2832,9 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 			goto nla_put_failure;
 	}
 
+	if (chain->flags & NFT_CHAIN_HW_OFFLOAD)
+		nft_flow_rule_stats(chain, rule);
+
 	list = nla_nest_start_noflag(skb, NFTA_RULE_EXPRESSIONS);
 	if (list == NULL)
 		goto nla_put_failure;
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 9ae14270c543..640bc52117bc 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -197,26 +197,56 @@ static void nft_flow_cls_offload_setup(struct flow_cls_offload *cls_flow,
 		cls_flow->rule = flow->rule;
 }
 
-static int nft_flow_offload_rule(struct nft_chain *chain,
-				 struct nft_rule *rule,
-				 struct nft_flow_rule *flow,
-				 enum flow_cls_command command)
+static int nft_flow_offload_cmd(const struct nft_chain *chain,
+				const struct nft_rule *rule,
+				struct nft_flow_rule *flow,
+				enum flow_cls_command command,
+				struct flow_cls_offload *cls_flow)
 {
 	struct netlink_ext_ack extack = {};
-	struct flow_cls_offload cls_flow;
 	struct nft_base_chain *basechain;
 
 	if (!nft_is_base_chain(chain))
 		return -EOPNOTSUPP;
 
 	basechain = nft_base_chain(chain);
-	nft_flow_cls_offload_setup(&cls_flow, basechain, rule, flow, &extack,
+	nft_flow_cls_offload_setup(cls_flow, basechain, rule, flow, &extack,
 				   command);
 
-	return nft_setup_cb_call(TC_SETUP_CLSFLOWER, &cls_flow,
+	return nft_setup_cb_call(TC_SETUP_CLSFLOWER, cls_flow,
 				 &basechain->flow_block.cb_list);
 }
 
+static int nft_flow_offload_rule(const struct nft_chain *chain,
+				 struct nft_rule *rule,
+				 struct nft_flow_rule *flow,
+				 enum flow_cls_command command)
+{
+	struct flow_cls_offload cls_flow;
+
+	return nft_flow_offload_cmd(chain, rule, flow, command, &cls_flow);
+}
+
+int nft_flow_rule_stats(const struct nft_chain *chain,
+			const struct nft_rule *rule)
+{
+	struct flow_cls_offload cls_flow = {};
+	struct nft_expr *expr, *next;
+	int err;
+
+	err = nft_flow_offload_cmd(chain, rule, NULL, FLOW_CLS_STATS,
+				   &cls_flow);
+	if (err < 0)
+		return err;
+
+	nft_rule_for_each_expr(expr, next, rule) {
+		if (expr->ops->offload_stats)
+			expr->ops->offload_stats(expr, &cls_flow.stats);
+	}
+
+	return 0;
+}
+
 static int nft_flow_offload_bind(struct flow_block_offload *bo,
 				 struct nft_base_chain *basechain)
 {
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 85ed461ec24e..9e1c09ada6eb 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -13,6 +13,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_offload.h>
 
 struct nft_counter {
 	s64		bytes;
@@ -248,6 +249,33 @@ static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src)
 	return 0;
 }
 
+static int nft_counter_offload(struct nft_offload_ctx *ctx,
+			       struct nft_flow_rule *flow,
+			       const struct nft_expr *expr)
+{
+	/* No specific offload action is needed, but report success. */
+	return 0;
+}
+
+static void nft_counter_offload_stats(struct nft_expr *expr,
+				      const struct flow_stats *stats)
+{
+	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
+	struct nft_counter *this_cpu;
+	seqcount_t *myseq;
+
+	preempt_disable();
+	this_cpu = this_cpu_ptr(priv->counter);
+	myseq = this_cpu_ptr(&nft_counter_seq);
+
+	write_seqcount_begin(myseq);
+	this_cpu->packets += stats->pkts;
+	this_cpu->bytes += stats->bytes;
+	write_seqcount_end(myseq);
+
+	preempt_enable();
+}
+
 static struct nft_expr_type nft_counter_type;
 static const struct nft_expr_ops nft_counter_ops = {
 	.type		= &nft_counter_type,
@@ -258,6 +286,8 @@ static const struct nft_expr_ops nft_counter_ops = {
 	.destroy_clone	= nft_counter_destroy,
 	.dump		= nft_counter_dump,
 	.clone		= nft_counter_clone,
+	.offload	= nft_counter_offload,
+	.offload_stats	= nft_counter_offload_stats,
 };
 
 static struct nft_expr_type nft_counter_type __read_mostly = {
-- 
2.30.2

