From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 4/7] netfilter: evict stale entries on netlink dumps
Date: Thu, 25 Aug 2016 15:33:32 +0200
Message-ID: <1472132015-10264-5-git-send-email-fw@strlen.de>
References: <1472132015-10264-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49996 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933523AbcHYNdo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 09:33:44 -0400
In-Reply-To: <1472132015-10264-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When dumping we already have to look at the entire table, so we might
as well toss those entries whose timeout value is in the past.

We also look at every entry during resize operations.
However, eviction there is not as simple because we hold the
global resize lock so we can't evict without adding a 'expired' list
to drop from later.  Considering that resizes are very rare it doesn't
seem worth doing it.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Eric Dumazet <edumazet@google.com>
---
 net/netfilter/nf_conntrack_netlink.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 81fd34c..dedbe4b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -815,14 +815,23 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	struct hlist_nulls_node *n;
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	u_int8_t l3proto = nfmsg->nfgen_family;
-	int res;
+	struct nf_conn *nf_ct_evict[8];
+	int res, i;
 	spinlock_t *lockp;
 
 	last = (struct nf_conn *)cb->args[1];
+	i = 0;
 
 	local_bh_disable();
 	for (; cb->args[0] < nf_conntrack_htable_size; cb->args[0]++) {
 restart:
+		while (i) {
+			i--;
+			if (nf_ct_should_gc(nf_ct_evict[i]))
+				nf_ct_kill(nf_ct_evict[i]);
+			nf_ct_put(nf_ct_evict[i]);
+		}
+
 		lockp = &nf_conntrack_locks[cb->args[0] % CONNTRACK_LOCKS];
 		nf_conntrack_lock(lockp);
 		if (cb->args[0] >= nf_conntrack_htable_size) {
@@ -834,6 +843,13 @@ restart:
 			if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
 			ct = nf_ct_tuplehash_to_ctrack(h);
+			if (nf_ct_is_expired(ct)) {
+				if (i < ARRAY_SIZE(nf_ct_evict) &&
+				    atomic_inc_not_zero(&ct->ct_general.use))
+					nf_ct_evict[i++] = ct;
+				continue;
+			}
+
 			if (!net_eq(net, nf_ct_net(ct)))
 				continue;
 
@@ -875,6 +891,13 @@ out:
 	if (last)
 		nf_ct_put(last);
 
+	while (i) {
+		i--;
+		if (nf_ct_should_gc(nf_ct_evict[i]))
+			nf_ct_kill(nf_ct_evict[i]);
+		nf_ct_put(nf_ct_evict[i]);
+	}
+
 	return skb->len;
 }
 
-- 
2.7.3

