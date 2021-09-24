Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C400C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Sep 2021 23:46:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CDF261212
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Sep 2021 23:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhIXXrm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 19:47:42 -0400
Received: from mail.netfilter.org ([217.70.188.207]:50100 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhIXXrm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 19:47:42 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 74DC063EA7
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Sep 2021 01:44:46 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/2] netfilter: nf_tables: reverse order in rule replacement expansion
Date:   Sat, 25 Sep 2021 01:46:02 +0200
Message-Id: <20210924234602.5553-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924234602.5553-1-pablo@netfilter.org>
References: <20210924234602.5553-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Deactivate old rule first, then append the new rule, so rule replacement
notification via netlink first reports the deletion of the old rule with
handle X in first place, then it adds the new rule (reusing the handle X
of the replaced old rule).

Note that the abort path releases the transaction that has been created
by nft_delrule() on error.

Fixes: ca08987885a1 ("netfilter: nf_tables: deactivate expressions in rule replecement routine")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 085783b14075..c8acd26c7201 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3419,17 +3419,15 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (info->nlh->nlmsg_flags & NLM_F_REPLACE) {
+		err = nft_delrule(&ctx, old_rule);
+		if (err < 0)
+			goto err_destroy_flow_rule;
+
 		trans = nft_trans_rule_add(&ctx, NFT_MSG_NEWRULE, rule);
 		if (trans == NULL) {
 			err = -ENOMEM;
 			goto err_destroy_flow_rule;
 		}
-		err = nft_delrule(&ctx, old_rule);
-		if (err < 0) {
-			nft_trans_destroy(trans);
-			goto err_destroy_flow_rule;
-		}
-
 		list_add_tail_rcu(&rule->list, &old_rule->list);
 	} else {
 		trans = nft_trans_rule_add(&ctx, NFT_MSG_NEWRULE, rule);
-- 
2.30.2

