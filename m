From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] netfilter: fix soft lockup when netlink adds new
 entries
Date: Thu, 23 Feb 2012 21:44:21 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1202232137220.13020@blackhole.kfki.hu>
References: <1329832437-8733-1-git-send-email-kadlec@blackhole.kfki.hu> <1329832437-8733-2-git-send-email-kadlec@blackhole.kfki.hu> <20120221145234.GB25826@1984> <alpine.DEB.2.00.1202211601090.8952@blackhole.kfki.hu> <20120223101250.GA3547@1984>
 <alpine.DEB.2.00.1202231334060.12151@blackhole.kfki.hu> <20120223154646.GA4790@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Zambo Marcell <marcell.zambo@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:47078 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756347Ab2BWUoY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:44:24 -0500
In-Reply-To: <20120223154646.GA4790@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 23 Feb 2012, Pablo Neira Ayuso wrote:

> On Thu, Feb 23, 2012 at 01:43:06PM +0100, Jozsef Kadlecsik wrote:
> > 
> > On Thu, 23 Feb 2012, Pablo Neira Ayuso wrote:
> > 
> > > On Tue, Feb 21, 2012 at 04:06:59PM +0100, Jozsef Kadlecsik wrote:
> > > > Or do I miss something else here?
> > > 
> > > I just noticed one problem.
> > > 
> > > With your approach, we may lose race if one packet inserts same conntrack
> > > entry while we're adding one conntrack. Thus resulting in two conntracks
> > > with the same tuples in the table.
> > 
> > Yes, you're right, that race condition is possible.
> >  
> > > One possible solution would be to check if it already exists before
> > > adding it to the list, but this will add too many extra cycles for
> > > each conntrack that is added via ctnetlink.
> > 
> > Actually, netfilter for normal conntrack entries does the same in 
> > __nf_conntrack_confirm. So entries added via ctnetlink would not be 
> > penalized if the same checking were added to ctnetlink_create_conntrack
> > in the locked region. Shall I send a patch over the previous one?
> 
> Yes, please.

OK, here it comes:

The previous patch with the title "netfilter: fix soft lockup
when netlink adds new entries" introduced a race: conntrack and
ctnetlink could insert the same entry twice into the hash table.
The patch eliminates the race condition by using the same checking
as conntrack confirm does.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/net/netfilter/nf_conntrack.h |    2 +
 net/netfilter/nf_conntrack_core.c    |   41 ++++++++++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_netlink.c |    9 +++----
 3 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 8a2b0ae..48bfe75 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -210,6 +210,8 @@ __nf_conntrack_find(struct net *net, u16 zone,
 		    const struct nf_conntrack_tuple *tuple);
 
 extern void nf_conntrack_hash_insert(struct nf_conn *ct);
+extern int nf_conntrack_hash_check_insert(struct net *net, u16 zone,
+					  struct nf_conn *ct);
 extern void nf_ct_delete_from_lists(struct nf_conn *ct);
 extern void nf_ct_insert_dying_list(struct nf_conn *ct);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 76613f5..3d829d6 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -418,6 +418,47 @@ void nf_conntrack_hash_insert(struct nf_conn *ct)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_hash_insert);
 
+int
+nf_conntrack_hash_check_insert(struct net *net, u16 zone, struct nf_conn *ct)
+{
+	unsigned int hash, repl_hash;
+	struct nf_conntrack_tuple_hash *h;
+	struct hlist_nulls_node *n;
+
+	hash = hash_conntrack(net, zone,
+			      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	repl_hash = hash_conntrack(net, zone,
+				   &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+
+	spin_lock_bh(&nf_conntrack_lock);
+
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
+	atomic_inc(&ct->ct_general.use);
+	__nf_conntrack_hash_insert(ct, hash, repl_hash);
+	NF_CT_STAT_INC(net, insert);
+	spin_unlock_bh(&nf_conntrack_lock);
+
+	return 0;
+
+out:
+	NF_CT_STAT_INC(net, insert_failed);
+	spin_unlock_bh(&nf_conntrack_lock);
+	return -EEXIST;
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_hash_check_insert);
+
 /* Confirm a connection given skb; places it in hash table */
 int
 __nf_conntrack_confirm(struct sk_buff *skb)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index cc70517..379d34e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1465,11 +1465,10 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
 	if (tstamp)
 		tstamp->start = ktime_to_ns(ktime_get_real());
 
-	add_timer(&ct->timeout);
-	spin_lock_bh(&nf_conntrack_lock);
-	nf_conntrack_hash_insert(ct);
-	nf_conntrack_get(&ct->ct_general);
-	spin_unlock_bh(&nf_conntrack_lock);
+	err = nf_conntrack_hash_check_insert(net, zone, ct);
+	if (err < 0)
+		goto err2;
+
 	rcu_read_unlock();
 
 	return ct;
-- 
1.7.0.4

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
