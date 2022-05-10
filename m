Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A09C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 May 2022 12:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241745AbiEJM2A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 May 2022 08:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241685AbiEJMZ6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 May 2022 08:25:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BBD19859D;
        Tue, 10 May 2022 05:22:01 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 10/17] netfilter: conntrack: avoid unconditional local_bh_disable
Date:   Tue, 10 May 2022 14:21:43 +0200
Message-Id: <20220510122150.92533-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220510122150.92533-1-pablo@netfilter.org>
References: <20220510122150.92533-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Now that the conntrack entry isn't placed on the pcpu list anymore the
bh only needs to be disabled in the 'expectation present' case.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c8d58d6d5b87..6e59a35a29b9 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1739,10 +1739,9 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 				 ecache ? ecache->expmask : 0,
 			     GFP_ATOMIC);
 
-	local_bh_disable();
 	cnet = nf_ct_pernet(net);
 	if (cnet->expect_count) {
-		spin_lock(&nf_conntrack_expect_lock);
+		spin_lock_bh(&nf_conntrack_expect_lock);
 		exp = nf_ct_find_expectation(net, zone, tuple);
 		if (exp) {
 			pr_debug("expectation arrives ct=%p exp=%p\n",
@@ -1765,7 +1764,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 #endif
 			NF_CT_STAT_INC(net, expect_new);
 		}
-		spin_unlock(&nf_conntrack_expect_lock);
+		spin_unlock_bh(&nf_conntrack_expect_lock);
 	}
 	if (!exp)
 		__nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
@@ -1773,8 +1772,6 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	/* Now it is going to be associated with an sk_buff, set refcount to 1. */
 	refcount_set(&ct->ct_general.use, 1);
 
-	local_bh_enable();
-
 	if (exp) {
 		if (exp->expectfn)
 			exp->expectfn(ct, exp);
-- 
2.30.2

