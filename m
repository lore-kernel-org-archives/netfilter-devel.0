Return-Path: <SRS0=ah1+=RK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A424DC43381
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Mar 2019 19:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75EBD20840
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Mar 2019 19:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfCGTbs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 14:31:48 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59228 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbfCGTbs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 14:31:48 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1h1yk5-0000AM-Ra; Thu, 07 Mar 2019 20:31:45 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     kfm@plushkava.net, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_tables: fix set double-free in abort path
Date:   Thu,  7 Mar 2019 20:30:41 +0100
Message-Id: <20190307193041.28798-1-fw@strlen.de>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The abort path can cause a double-free of an (anon) set.

Added-and-to-be-aborted rule looks like this:

udp dport { 137, 138 } drop

The to-be-aborted transaction list looks like this:
newset
newsetelem
newsetelem
rule

This gets walked in reverse order, so first pass disables
the rule, the set elements, then the set.

After synchronize_rcu(), we then destroy those in same order:
rule, set element, set element, newset.

Problem is that the (anon) set has already been bound to the rule,
so the rule (lookup expression destructor) already frees the set,
when then cause use-after-free when trying to delete the elements
from this set, then try to free the set again when handling the
newset expression.

To resolve this, check in first phase if the newset is bound already.
If so, remove the newset transaction from the list, rule destructor
will handle cleanup.

This is still causes the use-after-free on set element removal.
To handle this, move all affected set elements to a extra list
and process it first.

This forces strict 'destroy elements, then set' ordering.

Fixes: f6ac8585897684 ("netfilter: nf_tables: unbind set in rule from commit path")
Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1325
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 38 +++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index faf6bd10a19f..dcd9cb68d826 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6726,10 +6726,39 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 	kfree(trans);
 }
 
+static void __nf_tables_newset_abort(struct net *net,
+				     struct nft_trans *set_trans,
+				     struct list_head *set_elements)
+{
+	const struct nft_set *set = nft_trans_set(set_trans);
+	struct nft_trans *trans, *next;
+
+	if (!nft_trans_set_bound(set_trans))
+		return;
+
+	/* When abort is in progress, NFT_MSG_NEWRULE will remove the
+	 * set if its bound, so we need to remove the NEWSET transaction,
+	 * else the set is released twice.  NEWSETELEM need to be moved
+	 * to special list to ensure 'free elements, then set' ordering.
+	 */
+	list_for_each_entry_safe_reverse(trans, next,
+					 &net->nft.commit_list, list) {
+		if (trans == set_trans)
+			break;
+
+		if (trans->msg_type == NFT_MSG_NEWSETELEM &&
+		    nft_trans_set(trans) == set)
+			list_move(&trans->list, set_elements);
+	}
+
+	nft_trans_destroy(set_trans);
+}
+
 static int __nf_tables_abort(struct net *net)
 {
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
+	LIST_HEAD(set_elements);
 
 	list_for_each_entry_safe_reverse(trans, next, &net->nft.commit_list,
 					 list) {
@@ -6785,6 +6814,8 @@ static int __nf_tables_abort(struct net *net)
 			trans->ctx.table->use--;
 			if (!nft_trans_set_bound(trans))
 				list_del_rcu(&nft_trans_set(trans)->list);
+
+			__nf_tables_newset_abort(net, trans, &set_elements);
 			break;
 		case NFT_MSG_DELSET:
 			trans->ctx.table->use++;
@@ -6831,6 +6862,13 @@ static int __nf_tables_abort(struct net *net)
 
 	synchronize_rcu();
 
+	/* free set elements before the set they belong to is freed */
+	list_for_each_entry_safe_reverse(trans, next,
+					 &set_elements, list) {
+		list_del(&trans->list);
+		nf_tables_abort_release(trans);
+	}
+
 	list_for_each_entry_safe_reverse(trans, next,
 					 &net->nft.commit_list, list) {
 		list_del(&trans->list);
-- 
2.19.2

