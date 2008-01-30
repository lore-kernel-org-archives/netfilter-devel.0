From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 39/69]: nf_conntrack: switch rwlock to spinlock
Date: Wed, 30 Jan 2008 21:17:55 +0100 (MET)
Message-ID: <20080130201752.29874.20045.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60736 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765137AbYA3UR4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:56 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: switch rwlock to spinlock

With the RCU conversion only write_lock usages of nf_conntrack_lock are
left (except one read_lock that should actually use write_lock in the
H.323 helper). Switch to a spinlock.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0d9d7643b39dae81d0b16b54365d7985a278227f
tree 47e3dd620e54d57464c87140391c9a2a4805443b
parent b3deb266341ef2957c9386657243bfdf3480cf84
author Patrick McHardy <kaber@trash.net> Tue, 29 Jan 2008 16:22:13 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:07 +0100

 include/net/netfilter/nf_conntrack_core.h |    2 +-
 net/netfilter/nf_conntrack_core.c         |   38 +++++++++++++++--------------
 net/netfilter/nf_conntrack_expect.c       |   12 +++++----
 net/netfilter/nf_conntrack_h323_main.c    |    4 ++-
 net/netfilter/nf_conntrack_helper.c       |    4 ++-
 net/netfilter/nf_conntrack_netlink.c      |   22 ++++++++---------
 6 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 7ad0828..2b9e571 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -72,7 +72,7 @@ print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
 	    struct nf_conntrack_l4proto *proto);
 
 extern struct hlist_head *nf_conntrack_hash;
-extern rwlock_t nf_conntrack_lock ;
+extern spinlock_t nf_conntrack_lock ;
 extern struct hlist_head unconfirmed;
 
 #endif /* _NF_CONNTRACK_CORE_H */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a54bfec..f284ddd 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -40,7 +40,7 @@
 
 #define NF_CONNTRACK_VERSION	"0.5.0"
 
-DEFINE_RWLOCK(nf_conntrack_lock);
+DEFINE_SPINLOCK(nf_conntrack_lock);
 EXPORT_SYMBOL_GPL(nf_conntrack_lock);
 
 /* nf_conntrack_standalone needs this */
@@ -199,7 +199,7 @@ destroy_conntrack(struct nf_conntrack *nfct)
 
 	rcu_read_unlock();
 
-	write_lock_bh(&nf_conntrack_lock);
+	spin_lock_bh(&nf_conntrack_lock);
 	/* Expectations will have been removed in clean_from_lists,
 	 * except TFTP can create an expectation on the first packet,
 	 * before connection is in the list, so we need to clean here,
@@ -213,7 +213,7 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	}
 
 	NF_CT_STAT_INC(delete);
-	write_unlock_bh(&nf_conntrack_lock);
+	spin_unlock_bh(&nf_conntrack_lock);
 
 	if (ct->master)
 		nf_ct_put(ct->master);
@@ -236,12 +236,12 @@ static void death_by_timeout(unsigned long ul_conntrack)
 		rcu_read_unlock();
 	}
 
-	write_lock_bh(&nf_conntrack_lock);
+	spin_lock_bh(&nf_conntrack_lock);
 	/* Inside lock so preempt is disabled on module removal path.
 	 * Otherwise we can get spurious warnings. */
 	NF_CT_STAT_INC(delete_list);
 	clean_from_lists(ct);
-	write_unlock_bh(&nf_conntrack_lock);
+	spin_unlock_bh(&nf_conntrack_lock);
 	nf_ct_put(ct);
 }
 
@@ -303,9 +303,9 @@ void nf_conntrack_hash_insert(struct nf_conn *ct)
 	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 
-	write_lock_bh(&nf_conntrack_lock);
+	spin_lock_bh(&nf_conntrack_lock);
 	__nf_conntrack_hash_insert(ct, hash, repl_hash);
-	write_unlock_bh(&nf_conntrack_lock);
+	spin_unlock_bh(&nf_conntrack_lock);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_hash_insert);
 
@@ -342,7 +342,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
 	pr_debug("Confirming conntrack %p\n", ct);
 
-	write_lock_bh(&nf_conntrack_lock);
+	spin_lock_bh(&nf_conntrack_lock);
 
 	/* See if there's one in the list already, including reverse:
 	   NAT could have grabbed it without realizing, since we're
@@ -368,7 +368,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	atomic_inc(&ct->ct_general.use);
 	set_bit(IPS_CONFIRMED_BIT, &ct->status);
 	NF_CT_STAT_INC(insert);
-	write_unlock_bh(&nf_conntrack_lock);
+	spin_unlock_bh(&nf_conntrack_lock);
 	help = nfct_help(ct);
 	if (help && help->helper)
 		nf_conntrack_event_cache(IPCT_HELPER, skb);
@@ -383,7 +383,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 
 out:
 	NF_CT_STAT_INC(insert_failed);
-	write_unlock_bh(&nf_conntrack_lock);
+	spin_unlock_bh(&nf_conntrack_lock);
 	return NF_DROP;
 }
 EXPORT_SYMBOL_GPL(__nf_conntrack_confirm);
@@ -538,7 +538,7 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 		return NULL;
 	}
 
-	write_lock_bh(&nf_conntrack_lock);
+	spin_lock_bh(&nf_conntrack_lock);
 	exp = nf_ct_find_expectation(tuple);
 	if (exp) {
 		pr_debug("conntrack: expectation arrives ct=%p exp=%p\n",
@@ -576,7 +576,7 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 	hlist_add_head(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].hnode,
 		       &unconfirmed);
 
-	write_unlock_bh(&nf_conntrack_lock);
+	spin_unlock_bh(&nf_conntrack_lock);
 
 	if (exp) {
 		if (exp->expectfn)
@@ -787,7 +787,7 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 	NF_CT_ASSERT(ct->timeout.data == (unsigned long)ct);
 	NF_CT_ASSERT(skb);
 
-	write_lock_bh(&nf_conntrack_lock);
+	spin_lock_bh(&nf_conntrack_lock);
 
 	/* Only update if this is not a fixed timeout */
 	if (test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status))
@@ -824,7 +824,7 @@ acct:
 	}
 #endif
 
-	write_unlock_bh(&nf_conntrack_lock);
+	spin_unlock_bh(&nf_conntrack_lock);
 
 	/* must be unlocked when calling event cache */
 	if (event)
@@ -909,7 +909,7 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 	struct nf_conn *ct;
 	struct hlist_node *n;
 
-	write_lock_bh(&nf_conntrack_lock);
+	spin_lock_bh(&nf_conntrack_lock);
 	for (; *bucket < nf_conntrack_htable_size; (*bucket)++) {
 		hlist_for_each_entry(h, n, &nf_conntrack_hash[*bucket], hnode) {
 			ct = nf_ct_tuplehash_to_ctrack(h);
@@ -922,11 +922,11 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 		if (iter(ct, data))
 			set_bit(IPS_DYING_BIT, &ct->status);
 	}
-	write_unlock_bh(&nf_conntrack_lock);
+	spin_unlock_bh(&nf_conntrack_lock);
 	return NULL;
 found:
 	atomic_inc(&ct->ct_general.use);
-	write_unlock_bh(&nf_conntrack_lock);
+	spin_unlock_bh(&nf_conntrack_lock);
 	return ct;
 }
 
@@ -1055,7 +1055,7 @@ int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp)
 	 * created because of a false negative won't make it into the hash
 	 * though since that required taking the lock.
 	 */
-	write_lock_bh(&nf_conntrack_lock);
+	spin_lock_bh(&nf_conntrack_lock);
 	for (i = 0; i < nf_conntrack_htable_size; i++) {
 		while (!hlist_empty(&nf_conntrack_hash[i])) {
 			h = hlist_entry(nf_conntrack_hash[i].first,
@@ -1073,7 +1073,7 @@ int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp)
 	nf_conntrack_vmalloc = vmalloced;
 	nf_conntrack_hash = hash;
 	nf_conntrack_hash_rnd = rnd;
-	write_unlock_bh(&nf_conntrack_lock);
+	spin_unlock_bh(&nf_conntrack_lock);
 
 	nf_ct_free_hashtable(old_hash, old_vmalloced, old_size);
 	return 0;
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index a5c8ef0..e06bf00 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -65,9 +65,9 @@ static void nf_ct_expectation_timed_out(unsigned long ul_expect)
 {
 	struct nf_conntrack_expect *exp = (void *)ul_expect;
 
-	write_lock_bh(&nf_conntrack_lock);
+	spin_lock_bh(&nf_conntrack_lock);
 	nf_ct_unlink_expect(exp);
-	write_unlock_bh(&nf_conntrack_lock);
+	spin_unlock_bh(&nf_conntrack_lock);
 	nf_ct_expect_put(exp);
 }
 
@@ -201,12 +201,12 @@ static inline int expect_matches(const struct nf_conntrack_expect *a,
 /* Generally a bad idea to call this: could have matched already. */
 void nf_ct_unexpect_related(struct nf_conntrack_expect *exp)
 {
-	write_lock_bh(&nf_conntrack_lock);
+	spin_lock_bh(&nf_conntrack_lock);
 	if (del_timer(&exp->timeout)) {
 		nf_ct_unlink_expect(exp);
 		nf_ct_expect_put(exp);
 	}
-	write_unlock_bh(&nf_conntrack_lock);
+	spin_unlock_bh(&nf_conntrack_lock);
 }
 EXPORT_SYMBOL_GPL(nf_ct_unexpect_related);
 
@@ -355,7 +355,7 @@ int nf_ct_expect_related(struct nf_conntrack_expect *expect)
 
 	NF_CT_ASSERT(master_help);
 
-	write_lock_bh(&nf_conntrack_lock);
+	spin_lock_bh(&nf_conntrack_lock);
 	if (!master_help->helper) {
 		ret = -ESHUTDOWN;
 		goto out;
@@ -390,7 +390,7 @@ int nf_ct_expect_related(struct nf_conntrack_expect *expect)
 	nf_ct_expect_event(IPEXP_NEW, expect);
 	ret = 0;
 out:
-	write_unlock_bh(&nf_conntrack_lock);
+	spin_unlock_bh(&nf_conntrack_lock);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_related);
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 872c1aa..0256305 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1415,7 +1415,7 @@ static int process_rcf(struct sk_buff *skb, struct nf_conn *ct,
 		nf_ct_refresh(ct, skb, info->timeout * HZ);
 
 		/* Set expect timeout */
-		read_lock_bh(&nf_conntrack_lock);
+		spin_lock_bh(&nf_conntrack_lock);
 		exp = find_expect(ct, &ct->tuplehash[dir].tuple.dst.u3,
 				  info->sig_port[!dir]);
 		if (exp) {
@@ -1425,7 +1425,7 @@ static int process_rcf(struct sk_buff *skb, struct nf_conn *ct,
 			NF_CT_DUMP_TUPLE(&exp->tuple);
 			set_expect_timeout(exp, info->timeout);
 		}
-		read_unlock_bh(&nf_conntrack_lock);
+		spin_unlock_bh(&nf_conntrack_lock);
 	}
 
 	return 0;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 42f781f..b1fd21c 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -138,7 +138,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	 */
 	synchronize_rcu();
 
-	write_lock_bh(&nf_conntrack_lock);
+	spin_lock_bh(&nf_conntrack_lock);
 
 	/* Get rid of expectations */
 	for (i = 0; i < nf_ct_expect_hsize; i++) {
@@ -160,7 +160,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 		hlist_for_each_entry(h, n, &nf_conntrack_hash[i], hnode)
 			unhelp(h, me);
 	}
-	write_unlock_bh(&nf_conntrack_lock);
+	spin_unlock_bh(&nf_conntrack_lock);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b701dcc..b6a8c08 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1220,7 +1220,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			return err;
 	}
 
-	write_lock_bh(&nf_conntrack_lock);
+	spin_lock_bh(&nf_conntrack_lock);
 	if (cda[CTA_TUPLE_ORIG])
 		h = __nf_conntrack_find(&otuple, NULL);
 	else if (cda[CTA_TUPLE_REPLY])
@@ -1248,7 +1248,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			atomic_inc(&master_ct->ct_general.use);
 		}
 
-		write_unlock_bh(&nf_conntrack_lock);
+		spin_unlock_bh(&nf_conntrack_lock);
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE)
 			err = ctnetlink_create_conntrack(cda,
@@ -1281,7 +1281,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	}
 
 out_unlock:
-	write_unlock_bh(&nf_conntrack_lock);
+	spin_unlock_bh(&nf_conntrack_lock);
 	return err;
 }
 
@@ -1614,10 +1614,10 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 		struct nf_conn_help *m_help;
 
 		/* delete all expectations for this helper */
-		write_lock_bh(&nf_conntrack_lock);
+		spin_lock_bh(&nf_conntrack_lock);
 		h = __nf_conntrack_helper_find_byname(name);
 		if (!h) {
-			write_unlock_bh(&nf_conntrack_lock);
+			spin_unlock_bh(&nf_conntrack_lock);
 			return -EINVAL;
 		}
 		for (i = 0; i < nf_ct_expect_hsize; i++) {
@@ -1632,10 +1632,10 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 				}
 			}
 		}
-		write_unlock_bh(&nf_conntrack_lock);
+		spin_unlock_bh(&nf_conntrack_lock);
 	} else {
 		/* This basically means we have to flush everything*/
-		write_lock_bh(&nf_conntrack_lock);
+		spin_lock_bh(&nf_conntrack_lock);
 		for (i = 0; i < nf_ct_expect_hsize; i++) {
 			hlist_for_each_entry_safe(exp, n, next,
 						  &nf_ct_expect_hash[i],
@@ -1646,7 +1646,7 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 				}
 			}
 		}
-		write_unlock_bh(&nf_conntrack_lock);
+		spin_unlock_bh(&nf_conntrack_lock);
 	}
 
 	return 0;
@@ -1732,11 +1732,11 @@ ctnetlink_new_expect(struct sock *ctnl, struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	write_lock_bh(&nf_conntrack_lock);
+	spin_lock_bh(&nf_conntrack_lock);
 	exp = __nf_ct_expect_find(&tuple);
 
 	if (!exp) {
-		write_unlock_bh(&nf_conntrack_lock);
+		spin_unlock_bh(&nf_conntrack_lock);
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE)
 			err = ctnetlink_create_expect(cda, u3);
@@ -1746,7 +1746,7 @@ ctnetlink_new_expect(struct sock *ctnl, struct sk_buff *skb,
 	err = -EEXIST;
 	if (!(nlh->nlmsg_flags & NLM_F_EXCL))
 		err = ctnetlink_change_expect(exp, cda);
-	write_unlock_bh(&nf_conntrack_lock);
+	spin_unlock_bh(&nf_conntrack_lock);
 
 	return err;
 }
