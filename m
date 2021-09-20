Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F024C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Sep 2021 18:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4030F613B5
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Sep 2021 18:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350585AbhITSGW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Sep 2021 14:06:22 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38812 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345653AbhITSC1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Sep 2021 14:02:27 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 08E4D63EA3
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Sep 2021 19:59:36 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: add position handle in event notification
Date:   Mon, 20 Sep 2021 20:00:48 +0200
Message-Id: <20210920180048.30432-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add position handle to allow to identify the rule location from netlink
events. Otherwise, userspace cannot incrementally update a userspace
cache through monitoring events.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 081437dd75b7..7150b96894c4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2866,8 +2866,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 				    u32 flags, int family,
 				    const struct nft_table *table,
 				    const struct nft_chain *chain,
-				    const struct nft_rule *rule,
-				    const struct nft_rule *prule)
+				    const struct nft_rule *rule, u64 handle)
 {
 	struct nlmsghdr *nlh;
 	const struct nft_expr *expr, *next;
@@ -2887,9 +2886,8 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 			 NFTA_RULE_PAD))
 		goto nla_put_failure;
 
-	if (event != NFT_MSG_DELRULE && prule) {
-		if (nla_put_be64(skb, NFTA_RULE_POSITION,
-				 cpu_to_be64(prule->handle),
+	if (event != NFT_MSG_DELRULE && handle) {
+		if (nla_put_be64(skb, NFTA_RULE_POSITION, cpu_to_be64(handle),
 				 NFTA_RULE_PAD))
 			goto nla_put_failure;
 	}
@@ -2925,7 +2923,10 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 				  const struct nft_rule *rule, int event)
 {
 	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
+	const struct nft_rule *prule;
 	struct sk_buff *skb;
+	u64 handle = 0;
+	u16 flags = 0;
 	int err;
 
 	if (!ctx->report &&
@@ -2936,9 +2937,15 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 	if (skb == NULL)
 		goto err;
 
+	if (!list_is_first(&rule->list, &ctx->chain->rules)) {
+		prule = list_prev_entry(rule, list);
+		handle = prule->handle;
+		flags |= NLM_F_APPEND;
+	}
+
 	err = nf_tables_fill_rule_info(skb, ctx->net, ctx->portid, ctx->seq,
-				       event, 0, ctx->family, ctx->table,
-				       ctx->chain, rule, NULL);
+				       event, flags, ctx->family, ctx->table,
+				       ctx->chain, rule, handle);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -2964,6 +2971,7 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	const struct nft_rule *rule, *prule;
 	unsigned int s_idx = cb->args[0];
+	u64 handle;
 
 	prule = NULL;
 	list_for_each_entry_rcu(rule, &chain->rules, list) {
@@ -2975,12 +2983,17 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 			memset(&cb->args[1], 0,
 					sizeof(cb->args) - sizeof(cb->args[0]));
 		}
+		if (prule)
+			handle = prule->handle;
+		else
+			handle = 0;
+
 		if (nf_tables_fill_rule_info(skb, net, NETLINK_CB(cb->skb).portid,
 					cb->nlh->nlmsg_seq,
 					NFT_MSG_NEWRULE,
 					NLM_F_MULTI | NLM_F_APPEND,
 					table->family,
-					table, chain, rule, prule) < 0)
+					table, chain, rule, handle) < 0)
 			return 1;
 
 		nl_dump_check_consistent(cb, nlmsg_hdr(skb));
@@ -3143,7 +3156,7 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 	err = nf_tables_fill_rule_info(skb2, net, NETLINK_CB(skb).portid,
 				       info->nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
-				       family, table, chain, rule, NULL);
+				       family, table, chain, rule, 0);
 	if (err < 0)
 		goto err_fill_rule_info;
 
-- 
2.30.2

