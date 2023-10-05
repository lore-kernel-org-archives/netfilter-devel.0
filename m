Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7BBE9270D
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Oct 2023 15:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbjJEPst (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Oct 2023 11:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbjJEPsH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Oct 2023 11:48:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC09AFAE
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Oct 2023 07:18:56 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qoPBl-0000ZB-Hb; Thu, 05 Oct 2023 16:18:53 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Timo Sigurdsson <public_timo.s@silentcreek.de>
Subject: [PATCH nf] netfilter: nf_tables: work around newrule after chain binding
Date:   Thu,  5 Oct 2023 16:18:39 +0200
Message-ID: <20231005141843.8203-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nftables versions prior to
commit 3975430b12d9 ("src: expand table command before evaluation"), i.e.
1.0.6 and earlier, will handle the following snippet in the wrong order:

table ip t {
	chain c {
		jump { counter; }
	}
}

1. create the table, chain,c and an anon chain.
2. append a rule to chain c to jump to the anon chain.
3. append the rule(s) (here: "counter") to the anon chain.

(step 3 should be before 2).

With below commit, this is now rejected by the kernel.

Reason is that the 'jump {' rule added to chain c adds an explicit binding
(dependency), i.e. the kernel will automatically remove the anon chain when
userspace later asks to delete the 'jump {' rule from chain c.

This caused crashes in the kernel in case of a errors further down
in the same transaction.

The abort part has to unroll all pending changes, including the request to
add the rule 'jump {'.  As its already bound, all the rules added to it
get deleted as well.

Because we tolerated late-add-after-bind, the transaction log also contains
the NEWRULE requests (here "counter"), so those were deleted again.

Instead of rejecting newrule-to-bound-chain, allow it iff the anon chain
is new in this transaction and we are appending.

Mark the newrule transaction as already_bound so abort path skips them.

Fixes: 0ebc1064e487 ("netfilter: nf_tables: disallow rule addition to bound chain via NFTA_RULE_CHAIN_ID")
Reported-by: Timo Sigurdsson <public_timo.s@silentcreek.de>
Closes: https://lore.kernel.org/netfilter-devel/20230911213750.5B4B663206F5@dd20004.kasserver.com/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a72b6aeefb1b..dd5b78a58023 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3805,6 +3805,26 @@ static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 					     const struct nft_chain *chain,
 					     const struct nlattr *nla);
 
+/* nft <= 1.0.6 appends rules to anon chains after they have been bound */
+static bool nft_rule_work_around_old_version(const struct nfnl_info *info,
+					     struct nft_chain *chain)
+{
+	/* bound (anonymous) chain is already used */
+	if (nft_is_active(info->net, chain))
+		return false;
+
+	/* nft never asks to replace rules here */
+	if (info->nlh->nlmsg_flags & (NLM_F_REPLACE | NLM_F_EXCL))
+		return false;
+
+	/* nft and it only ever appends. */
+	if ((info->nlh->nlmsg_flags & NLM_F_APPEND) == 0)
+		return false;
+
+	pr_warn_once("enabling workaround for nftables 1.0.6 and older\n");
+	return true;
+}
+
 #define NFT_RULE_MAXEXPRS	128
 
 static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
@@ -3818,6 +3838,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	struct nft_expr_info *expr_info = NULL;
 	u8 family = info->nfmsg->nfgen_family;
 	struct nft_flow_rule *flow = NULL;
+	bool add_after_bind = false;
 	struct net *net = info->net;
 	struct nft_userdata *udata;
 	struct nft_table *table;
@@ -3857,8 +3878,12 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 		return -EINVAL;
 	}
 
-	if (nft_chain_is_bound(chain))
-		return -EOPNOTSUPP;
+	if (nft_chain_is_bound(chain)) {
+		if (!nft_rule_work_around_old_version(info, chain))
+			return -EOPNOTSUPP;
+
+		add_after_bind = true;
+	}
 
 	if (nla[NFTA_RULE_HANDLE]) {
 		handle = be64_to_cpu(nla_get_be64(nla[NFTA_RULE_HANDLE]));
@@ -4003,6 +4028,10 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 			goto err_destroy_flow_rule;
 		}
 
+		/* work around nftables versions <= 1.0.5 that append rules after bind. */
+		if (add_after_bind)
+			nft_trans_rule_bound(trans) = true;
+
 		if (info->nlh->nlmsg_flags & NLM_F_APPEND) {
 			if (old_rule)
 				list_add_rcu(&rule->list, &old_rule->list);
-- 
2.41.0

