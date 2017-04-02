From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nf_ct_expect: use proper RCU list traversal/update APIs
Date: Sun,  2 Apr 2017 18:25:37 +0800
Message-ID: <1491128737-14747-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:49550 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750947AbdDBK0M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Apr 2017 06:26:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

We should use proper RCU list APIs to manipulate help->expectations,
as we can dump the conntrack's expectations via nfnetlink, i.e. in
ctnetlink_exp_ct_dump_table(), where only rcu_read_lock is acquired.

So for list traversal, use hlist_for_each_entry_rcu; for list add/del,
use hlist_add_head_rcu and hlist_del_rcu.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nf_conntrack_expect.c  | 4 ++--
 net/netfilter/nf_conntrack_netlink.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 4b2e1fb..d800730 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -57,7 +57,7 @@ void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
 	hlist_del_rcu(&exp->hnode);
 	net->ct.expect_count--;
 
-	hlist_del(&exp->lnode);
+	hlist_del_rcu(&exp->lnode);
 	master_help->expecting[exp->class]--;
 
 	nf_ct_expect_event_report(IPEXP_DESTROY, exp, portid, report);
@@ -363,7 +363,7 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 	/* two references : one for hash insert, one for the timer */
 	atomic_add(2, &exp->use);
 
-	hlist_add_head(&exp->lnode, &master_help->expectations);
+	hlist_add_head_rcu(&exp->lnode, &master_help->expectations);
 	master_help->expecting[exp->class]++;
 
 	hlist_add_head_rcu(&exp->hnode, &nf_ct_expect_hash[h]);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1bb2f27..b7ebacb 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2669,8 +2669,8 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	last = (struct nf_conntrack_expect *)cb->args[1];
 	for (; cb->args[0] < nf_ct_expect_hsize; cb->args[0]++) {
 restart:
-		hlist_for_each_entry(exp, &nf_ct_expect_hash[cb->args[0]],
-				     hnode) {
+		hlist_for_each_entry_rcu(exp, &nf_ct_expect_hash[cb->args[0]],
+					 hnode) {
 			if (l3proto && exp->tuple.src.l3num != l3proto)
 				continue;
 
@@ -2721,7 +2721,7 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	rcu_read_lock();
 	last = (struct nf_conntrack_expect *)cb->args[1];
 restart:
-	hlist_for_each_entry(exp, &help->expectations, lnode) {
+	hlist_for_each_entry_rcu(exp, &help->expectations, lnode) {
 		if (l3proto && exp->tuple.src.l3num != l3proto)
 			continue;
 		if (cb->args[1]) {
-- 
2.5.5


