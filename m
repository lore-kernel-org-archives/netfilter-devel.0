From: pablo@netfilter.org
Subject: [PATCH 2/3] netfilter: fix race in conntrack between dump_table and destroy
Date: Wed, 12 Jan 2011 00:26:17 +0100
Message-ID: <1294788378-11475-3-git-send-email-pablo@netfilter.org>
References: <1294788378-11475-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Stephen Hemminger <shemminger@vyatta.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41004 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab1AKX1g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:27:36 -0500
In-Reply-To: <1294788378-11475-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Stephen Hemminger <shemminger@vyatta.com>

The netlink interface to dump the connection tracking table has a race
when entries are deleted at the same time. A customer reported a crash
and the backtrace showed thatctnetlink_dump_table was running while a
conntrack entry was being destroyed.
(see https://bugzilla.vyatta.com/show_bug.cgi?id=6402).

According to RCU documentation, when using hlist_nulls the reader
must handle the case of seeing a deleted entry and not proceed
further down the linked list.  The old code would continue
which caused the scan to walk into the free list.

This patch uses locking (rather than RCU) for this operation which
is guaranteed safe, and no longer requires getting reference while
doing dump operation.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 7461402..5cb8d30 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -645,25 +645,23 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	u_int8_t l3proto = nfmsg->nfgen_family;
 
-	rcu_read_lock();
+	spin_lock_bh(&nf_conntrack_lock);
 	last = (struct nf_conn *)cb->args[1];
 	for (; cb->args[0] < net->ct.htable_size; cb->args[0]++) {
 restart:
-		hlist_nulls_for_each_entry_rcu(h, n, &net->ct.hash[cb->args[0]],
+		hlist_nulls_for_each_entry(h, n, &net->ct.hash[cb->args[0]],
 					 hnnode) {
 			if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
 			ct = nf_ct_tuplehash_to_ctrack(h);
-			if (!atomic_inc_not_zero(&ct->ct_general.use))
-				continue;
 			/* Dump entries of a given L3 protocol number.
 			 * If it is not specified, ie. l3proto == 0,
 			 * then dump everything. */
 			if (l3proto && nf_ct_l3num(ct) != l3proto)
-				goto releasect;
+				continue;
 			if (cb->args[1]) {
 				if (ct != last)
-					goto releasect;
+					continue;
 				cb->args[1] = 0;
 			}
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
@@ -681,8 +679,6 @@ restart:
 				if (acct)
 					memset(acct, 0, sizeof(struct nf_conn_counter[IP_CT_DIR_MAX]));
 			}
-releasect:
-		nf_ct_put(ct);
 		}
 		if (cb->args[1]) {
 			cb->args[1] = 0;
@@ -690,7 +686,7 @@ releasect:
 		}
 	}
 out:
-	rcu_read_unlock();
+	spin_unlock_bh(&nf_conntrack_lock);
 	if (last)
 		nf_ct_put(last);
 
-- 
1.7.2.3

