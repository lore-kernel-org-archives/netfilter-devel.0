Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C33C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Apr 2022 11:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345623AbiDKLEn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Apr 2022 07:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345884AbiDKLEd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Apr 2022 07:04:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A99443FE
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Apr 2022 04:02:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ndroB-0000LW-Ol; Mon, 11 Apr 2022 13:02:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 10/10] netfilter: conntrack: avoid unconditional local_bh_disable
Date:   Mon, 11 Apr 2022 13:01:25 +0200
Message-Id: <20220411110125.4854-11-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411110125.4854-1-fw@strlen.de>
References: <20220411110125.4854-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Now that the conntrack entry isn't placed on the pcpu list anymore the
bh only needs to be disabled in the 'expectation present' case.

Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.35.1

