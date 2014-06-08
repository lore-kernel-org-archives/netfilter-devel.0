From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: ctnetlink: fix refcnt leak in dying/unconfirmed list dumper
Date: Sun,  8 Jun 2014 11:41:23 +0200
Message-ID: <1402220483-10565-1-git-send-email-fw@strlen.de>
Cc: brouer@redhat.com, Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45420 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753358AbaFHJrW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jun 2014 05:47:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

'last' keeps track of the ct that had its refcnt bumped during previous
dump cycle.  Thus it must not be overwritten until end-of-function.

Another (unrelated, theoretical) issue: Don't attempt to bump refcnt of a conntrack
whose reference count is already 0.  Such conntrack is being destroyed
right now, its memory is freed once we release the percpu dying spinlock.

Fixes: b7779d06 ('netfilter: conntrack: spinlock per cpu to protect special lists.')
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 With this patch I do not see any more stale entries on the dying list with eache evictor
 not being scheduled.  Such 'leaked' entries are easy to spot since their 'use' count
 is growing, i.e. invoking conntrack -L dying repeatedly yields 'use=$bignum++' output.

 net/netfilter/nf_conntrack_netlink.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 5857963..7e89c1a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1150,7 +1150,7 @@ static int ctnetlink_done_list(struct netlink_callback *cb)
 static int
 ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying)
 {
-	struct nf_conn *ct, *last = NULL;
+	struct nf_conn *ct, *last;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
@@ -1166,6 +1166,8 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 	if (cb->args[0] == nr_cpu_ids)
 		return 0;
 
+	last = (struct nf_conn *)cb->args[1];
+
 	for (cpu = cb->args[0]; cpu < nr_cpu_ids; cpu++) {
 		struct ct_pcpu *pcpu;
 
@@ -1174,7 +1176,6 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 
 		pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
 		spin_lock_bh(&pcpu->lock);
-		last = (struct nf_conn *)cb->args[1];
 		list = dying ? &pcpu->dying : &pcpu->unconfirmed;
 restart:
 		hlist_nulls_for_each_entry(h, n, list, hnnode) {
@@ -1193,7 +1194,8 @@ restart:
 						  ct);
 			rcu_read_unlock();
 			if (res < 0) {
-				nf_conntrack_get(&ct->ct_general);
+				if (!atomic_inc_not_zero(&ct->ct_general.use))
+					continue;
 				cb->args[1] = (unsigned long)ct;
 				spin_unlock_bh(&pcpu->lock);
 				goto out;
-- 
1.8.1.5

