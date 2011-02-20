From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 1/2] netfilter: fix race in conntrack between dump_table and
 destroy
Date: Sun, 20 Feb 2011 12:51:10 -0800
Message-ID: <20110220125110.55400d52@nehalam>
References: <20110123231602.3383.31480.stgit@decadence>
 <20110220124814.2e89da91@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, kaber@trash.net, stable@kernel.org
To: Greg KH <greg@kroah.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:60458 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab1BTUvm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Feb 2011 15:51:42 -0500
In-Reply-To: <20110220124814.2e89da91@nehalam>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


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
(cherry picked from commit 13ee6ac579574a2a95e982b19920fd2495dce8cd)
---
 Patch against 2.6.37.1

 net/netfilter/nf_conntrack_netlink.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b729ace..d57dcdb 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -642,25 +642,23 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -678,8 +676,6 @@ restart:
 				if (acct)
 					memset(acct, 0, sizeof(struct nf_conn_counter[IP_CT_DIR_MAX]));
 			}
-releasect:
-		nf_ct_put(ct);
 		}
 		if (cb->args[1]) {
 			cb->args[1] = 0;
@@ -687,7 +683,7 @@ releasect:
 		}
 	}
 out:
-	rcu_read_unlock();
+	spin_unlock_bh(&nf_conntrack_lock);
 	if (last)
 		nf_ct_put(last);
 
-- 
1.7.1

