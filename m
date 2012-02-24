From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] netfilter: fix soft lockup when netlink adds new
 entries
Date: Fri, 24 Feb 2012 11:45:49 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1202241143001.14577@blackhole.kfki.hu>
References: <1329832437-8733-1-git-send-email-kadlec@blackhole.kfki.hu> <1329832437-8733-2-git-send-email-kadlec@blackhole.kfki.hu> <20120221145234.GB25826@1984> <alpine.DEB.2.00.1202211601090.8952@blackhole.kfki.hu> <20120223101250.GA3547@1984>
 <alpine.DEB.2.00.1202231334060.12151@blackhole.kfki.hu> <20120223154646.GA4790@1984> <alpine.DEB.2.00.1202232137220.13020@blackhole.kfki.hu> <20120224012449.GA7005@1984> <alpine.DEB.2.00.1202240850220.14113@blackhole.kfki.hu> <20120224095959.GA9127@1984>
 <alpine.DEB.2.00.1202241104580.14329@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Zambo Marcell <marcell.zambo@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:54963 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab2BXKpv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:45:51 -0500
In-Reply-To: <alpine.DEB.2.00.1202241104580.14329@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 24 Feb 2012, Jozsef Kadlecsik wrote:

> OK, and I remove nf_conntrack_hash_insert then, and use a single ct 
> argument because as you noted net and zone can be extracted from the ct.

Here comes the second version of the patch, which assumes that the 
previous one is reverted.

Best regards,
Jozsef

Marcell Zambo and Janos Farago noticed and reported that when
new conntrack entries are added via netlink and the conntrack table
gets full, soft lockup happens. This is because the nf_conntrack_lock
is held while nf_conntrack_alloc is called, which is in turn wants
to lock nf_conntrack_lock while evicting entries from the full table.

The patch fixes the soft lockup with limiting the holding of the
nf_conntrack_lock to the minimum, where it's absolutely required.
It required to extend (and thus change) nf_conntrack_hash_insert
so that it makes sure conntrack and ctnetlink do not add the same entry
twice to the conntrack table.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/net/netfilter/nf_conntrack.h |    2 +-
 net/netfilter/nf_conntrack_core.c    |   38 ++++++++++++++++++++--
 net/netfilter/nf_conntrack_netlink.c |   58 +++++++++++++--------------------
 3 files changed, 58 insertions(+), 40 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 8a2b0ae..ab86036 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -209,7 +209,7 @@ extern struct nf_conntrack_tuple_hash *
 __nf_conntrack_find(struct net *net, u16 zone,
 		    const struct nf_conntrack_tuple *tuple);
 
-extern void nf_conntrack_hash_insert(struct nf_conn *ct);
+extern int nf_conntrack_hash_check_insert(struct nf_conn *ct);
 extern void nf_ct_delete_from_lists(struct nf_conn *ct);
 extern void nf_ct_insert_dying_list(struct nf_conn *ct);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 76613f5..ed86a3b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -404,19 +404,49 @@ static void __nf_conntrack_hash_insert(struct nf_conn *ct,
 			   &net->ct.hash[repl_hash]);
 }
 
-void nf_conntrack_hash_insert(struct nf_conn *ct)
+int
+nf_conntrack_hash_check_insert(struct nf_conn *ct)
 {
 	struct net *net = nf_ct_net(ct);
 	unsigned int hash, repl_hash;
+	struct nf_conntrack_tuple_hash *h;
+	struct hlist_nulls_node *n;
 	u16 zone;
 
 	zone = nf_ct_zone(ct);
-	hash = hash_conntrack(net, zone, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-	repl_hash = hash_conntrack(net, zone, &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+	hash = hash_conntrack(net, zone,
+			      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	repl_hash = hash_conntrack(net, zone,
+				   &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+
+	spin_lock_bh(&nf_conntrack_lock);
 
+	/* See if there's one in the list already, including reverse */
+	hlist_nulls_for_each_entry(h, n, &net->ct.hash[hash], hnnode)
+		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+				      &h->tuple) &&
+		    zone == nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)))
+			goto out;
+	hlist_nulls_for_each_entry(h, n, &net->ct.hash[repl_hash], hnnode)
+		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_REPLY].tuple,
+				      &h->tuple) &&
+		    zone == nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)))
+			goto out;
+
+	add_timer(&ct->timeout);
+	nf_conntrack_get(&ct->ct_general);
 	__nf_conntrack_hash_insert(ct, hash, repl_hash);
+	NF_CT_STAT_INC(net, insert);
+	spin_unlock_bh(&nf_conntrack_lock);
+
+	return 0;
+
+out:
+	NF_CT_STAT_INC(net, insert_failed);
+	spin_unlock_bh(&nf_conntrack_lock);
+	return -EEXIST;
 }
-EXPORT_SYMBOL_GPL(nf_conntrack_hash_insert);
+EXPORT_SYMBOL_GPL(nf_conntrack_hash_check_insert);
 
 /* Confirm a connection given skb; places it in hash table */
 int
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9307b03..6d73501 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1345,7 +1345,7 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
 	struct nf_conntrack_helper *helper;
 	struct nf_conn_tstamp *tstamp;
 
-	ct = nf_conntrack_alloc(net, zone, otuple, rtuple, GFP_ATOMIC);
+	ct = nf_conntrack_alloc(net, zone, otuple, rtuple, GFP_KERNEL);
 	if (IS_ERR(ct))
 		return ERR_PTR(-ENOMEM);
 
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
@@ -1391,7 +1388,7 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
 		} else {
 			struct nf_conn_help *help;
 
-			help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
+			help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
 			if (help == NULL) {
 				err = -ENOMEM;
 				goto err2;
@@ -1402,7 +1399,7 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
 		}
 	} else {
 		/* try an implicit helper assignation */
-		err = __nf_ct_try_assign_helper(ct, NULL, GFP_ATOMIC);
+		err = __nf_ct_try_assign_helper(ct, NULL, GFP_KERNEL);
 		if (err < 0)
 			goto err2;
 	}
@@ -1413,9 +1410,9 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
 			goto err2;
 	}
 
-	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
-	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
-	nf_ct_ecache_ext_add(ct, 0, 0, GFP_ATOMIC);
+	nf_ct_acct_ext_add(ct, GFP_KERNEL);
+	nf_ct_tstamp_ext_add(ct, GFP_KERNEL);
+	nf_ct_ecache_ext_add(ct, 0, 0, GFP_KERNEL);
 	/* we must add conntrack extensions before confirmation. */
 	ct->status |= IPS_CONFIRMED;
 
@@ -1468,8 +1465,10 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
 	if (tstamp)
 		tstamp->start = ktime_to_ns(ktime_get_real());
 
-	add_timer(&ct->timeout);
-	nf_conntrack_hash_insert(ct);
+	err = nf_conntrack_hash_check_insert(ct);
+	if (err < 0)
+		goto err2;
+
 	rcu_read_unlock();
 
 	return ct;
@@ -1490,6 +1489,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	struct nf_conntrack_tuple otuple, rtuple;
 	struct nf_conntrack_tuple_hash *h = NULL;
 	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	struct nf_conn *ct;
 	u_int8_t u3 = nfmsg->nfgen_family;
 	u16 zone;
 	int err;
@@ -1512,25 +1512,22 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 
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
@@ -1545,23 +1542,19 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
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
@@ -1570,15 +1563,10 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
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

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
