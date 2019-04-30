Return-Path: <SRS0=Ro/3=TA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7DCEC43219
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 12:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BD4E2075E
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 12:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfD3Mv2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 08:51:28 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36786 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726166AbfD3Mv1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 08:51:27 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hLSEH-0006Yw-U8; Tue, 30 Apr 2019 14:51:26 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_tables: fix oops during rule dump
Date:   Tue, 30 Apr 2019 14:53:11 +0200
Message-Id: <20190430125311.7267-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <netfilter-devel>
References: <netfilter-devel>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We can oops in nf_tables_fill_rule_info().

Its not possible to fetch previous element in rcu-protected lists
when deletions are not prevented somehow: list_del_rcu poisons
the ->prev pointer value.

Before rcu-conversion this was safe as dump operations did hold
nfnetlink mutex.

Pass previous rule as argument, obtained by keeping a pointer to
the previous rule during traversal.

Fixes: d9adf22a291883 ("netfilter: nf_tables: use call_rcu in netlink dumps")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index aa5e7b00a581..0969f9647927 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2261,13 +2261,13 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 				    u32 flags, int family,
 				    const struct nft_table *table,
 				    const struct nft_chain *chain,
-				    const struct nft_rule *rule)
+				    const struct nft_rule *rule,
+				    const struct nft_rule *prule)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
 	const struct nft_expr *expr, *next;
 	struct nlattr *list;
-	const struct nft_rule *prule;
 	u16 type = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
 
 	nlh = nlmsg_put(skb, portid, seq, type, sizeof(struct nfgenmsg), flags);
@@ -2287,8 +2287,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 			 NFTA_RULE_PAD))
 		goto nla_put_failure;
 
-	if ((event != NFT_MSG_DELRULE) && (rule->list.prev != &chain->rules)) {
-		prule = list_prev_entry(rule, list);
+	if (event != NFT_MSG_DELRULE && prule) {
 		if (nla_put_be64(skb, NFTA_RULE_POSITION,
 				 cpu_to_be64(prule->handle),
 				 NFTA_RULE_PAD))
@@ -2335,7 +2334,7 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 
 	err = nf_tables_fill_rule_info(skb, ctx->net, ctx->portid, ctx->seq,
 				       event, 0, ctx->family, ctx->table,
-				       ctx->chain, rule);
+				       ctx->chain, rule, NULL);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -2360,12 +2359,13 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 				  const struct nft_chain *chain)
 {
 	struct net *net = sock_net(skb->sk);
+	const struct nft_rule *rule, *prule;
 	unsigned int s_idx = cb->args[0];
-	const struct nft_rule *rule;
 
+	prule = NULL;
 	list_for_each_entry_rcu(rule, &chain->rules, list) {
 		if (!nft_is_active(net, rule))
-			goto cont;
+			goto cont_skip;
 		if (*idx < s_idx)
 			goto cont;
 		if (*idx > s_idx) {
@@ -2377,11 +2377,13 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 					NFT_MSG_NEWRULE,
 					NLM_F_MULTI | NLM_F_APPEND,
 					table->family,
-					table, chain, rule) < 0)
+					table, chain, rule, prule) < 0)
 			return 1;
 
 		nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 cont:
+		prule = rule;
+cont_skip:
 		(*idx)++;
 	}
 	return 0;
@@ -2537,7 +2539,7 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 
 	err = nf_tables_fill_rule_info(skb2, net, NETLINK_CB(skb).portid,
 				       nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
-				       family, table, chain, rule);
+				       family, table, chain, rule, NULL);
 	if (err < 0)
 		goto err;
 
-- 
2.21.0

