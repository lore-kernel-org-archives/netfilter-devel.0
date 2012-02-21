From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/1] netfilter: fix soft lockup when netlink adds new entries
Date: Tue, 21 Feb 2012 14:53:57 +0100
Message-ID: <1329832437-8733-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1329832437-8733-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Zambo Marcell <marcell.zambo@gmail.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:59953 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab2BUNyM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Feb 2012 08:54:12 -0500
In-Reply-To: <1329832437-8733-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Marcell Zambo and Janos Farago noticed and reported that when
new conntrack entries are added via netlink and the conntrack table
gets full, soft lockup happens. This is because the nf_conntrack_lock
is held while nf_conntrack_alloc is called, which is in turn wants
to lock nf_conntrack_lock while evicting entries from the full table.

The patch fixes the soft lockup with limiting the holding of the
nf_conntrack_lock to the minimum, where it's absolutely required.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/nf_conntrack_netlink.c |   43 ++++++++++++---------------------
 1 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9307b03..cc70517 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1367,15 +1367,12 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
 						    nf_ct_protonum(ct));
 		if (helper == NULL) {
 			rcu_read_unlock();
-			spin_unlock_bh(&nf_conntrack_lock);
 #ifdef CONFIG_MODULES
 			if (request_module("nfct-helper-%s", helpname) < 0) {
-				spin_lock_bh(&nf_conntrack_lock);
 				err = -EOPNOTSUPP;
 				goto err1;
 			}
 
-			spin_lock_bh(&nf_conntrack_lock);
 			rcu_read_lock();
 			helper = __nf_conntrack_helper_find(helpname,
 							    nf_ct_l3num(ct),
@@ -1469,7 +1466,10 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
 		tstamp->start = ktime_to_ns(ktime_get_real());
 
 	add_timer(&ct->timeout);
+	spin_lock_bh(&nf_conntrack_lock);
 	nf_conntrack_hash_insert(ct);
+	nf_conntrack_get(&ct->ct_general);
+	spin_unlock_bh(&nf_conntrack_lock);
 	rcu_read_unlock();
 
 	return ct;
@@ -1490,6 +1490,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	struct nf_conntrack_tuple otuple, rtuple;
 	struct nf_conntrack_tuple_hash *h = NULL;
 	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	struct nf_conn *ct;
 	u_int8_t u3 = nfmsg->nfgen_family;
 	u16 zone;
 	int err;
@@ -1512,25 +1513,22 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 
 	spin_lock_bh(&nf_conntrack_lock);
 	if (cda[CTA_TUPLE_ORIG])
-		h = __nf_conntrack_find(net, zone, &otuple);
+		h = nf_conntrack_find_get(net, zone, &otuple);
 	else if (cda[CTA_TUPLE_REPLY])
-		h = __nf_conntrack_find(net, zone, &rtuple);
+		h = nf_conntrack_find_get(net, zone, &rtuple);
+	spin_unlock_bh(&nf_conntrack_lock);
 
 	if (h == NULL) {
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE) {
-			struct nf_conn *ct;
 			enum ip_conntrack_events events;
 
 			ct = ctnetlink_create_conntrack(net, zone, cda, &otuple,
 							&rtuple, u3);
-			if (IS_ERR(ct)) {
-				err = PTR_ERR(ct);
-				goto out_unlock;
-			}
+			if (IS_ERR(ct))
+				return PTR_ERR(ct);
+
 			err = 0;
-			nf_conntrack_get(&ct->ct_general);
-			spin_unlock_bh(&nf_conntrack_lock);
 			if (test_bit(IPS_EXPECTED_BIT, &ct->status))
 				events = IPCT_RELATED;
 			else
@@ -1545,23 +1543,19 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 						      ct, NETLINK_CB(skb).pid,
 						      nlmsg_report(nlh));
 			nf_ct_put(ct);
-		} else
-			spin_unlock_bh(&nf_conntrack_lock);
+		}
 
 		return err;
 	}
 	/* implicit 'else' */
 
-	/* We manipulate the conntrack inside the global conntrack table lock,
-	 * so there's no need to increase the refcount */
 	err = -EEXIST;
+	ct = nf_ct_tuplehash_to_ctrack(h);
 	if (!(nlh->nlmsg_flags & NLM_F_EXCL)) {
-		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
-
+		spin_lock_bh(&nf_conntrack_lock);
 		err = ctnetlink_change_conntrack(ct, cda);
+		spin_unlock_bh(&nf_conntrack_lock);
 		if (err == 0) {
-			nf_conntrack_get(&ct->ct_general);
-			spin_unlock_bh(&nf_conntrack_lock);
 			nf_conntrack_eventmask_report((1 << IPCT_REPLY) |
 						      (1 << IPCT_ASSURED) |
 						      (1 << IPCT_HELPER) |
@@ -1570,15 +1564,10 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 						      (1 << IPCT_MARK),
 						      ct, NETLINK_CB(skb).pid,
 						      nlmsg_report(nlh));
-			nf_ct_put(ct);
-		} else
-			spin_unlock_bh(&nf_conntrack_lock);
-
-		return err;
+		}
 	}
 
-out_unlock:
-	spin_unlock_bh(&nf_conntrack_lock);
+	nf_ct_put(ct);
 	return err;
 }
 
-- 
1.7.0.4

