From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: nf_ct_expect: rework userspace expectation
	support
Date: Tue, 12 Apr 2011 23:59:54 +0200
Message-ID: <20110412215954.3145.40163.stgit@decadence>
References: <20110412215458.3145.40830.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46111 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322Ab1DLV77 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:59:59 -0400
In-Reply-To: <20110412215458.3145.40830.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This partially reworks bc01befdcf3e40979eb518085a075cbf0aacede0
which added userspace expectation support.

This patch removes the nf_ct_userspace_expect_list since now we
force to use the new iptables CT target feature to add the helper
extension for conntracks that have attached expectations from
userspace.

A new version of the proof-of-concept code to implement userspace
helpers from userspace is available at:

http://people.netfilter.org/pablo/userspace-conntrack-helpers/nf-ftp-helper-POC.tar.bz2

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_expect.h |    1 
 net/netfilter/nf_conntrack_expect.c         |   63 +++++++++------------------
 net/netfilter/nf_conntrack_netlink.c        |    5 ++
 3 files changed, 25 insertions(+), 44 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 0f8a8c5..4619caa 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -91,7 +91,6 @@ static inline void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
 
 void nf_ct_remove_expectations(struct nf_conn *ct);
 void nf_ct_unexpect_related(struct nf_conntrack_expect *exp);
-void nf_ct_remove_userspace_expectations(void);
 
 /* Allocate space for an expectation: this is mandatory before calling
    nf_ct_expect_related.  You will have to call put afterwards. */
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index cd1e8e0..73670e9 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -36,8 +36,6 @@ unsigned int nf_ct_expect_max __read_mostly;
 
 static struct kmem_cache *nf_ct_expect_cachep __read_mostly;
 
-static HLIST_HEAD(nf_ct_userspace_expect_list);
-
 /* nf_conntrack_expect helper functions */
 void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
 				u32 pid, int report)
@@ -45,14 +43,14 @@ void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
 	struct nf_conn_help *master_help = nfct_help(exp->master);
 	struct net *net = nf_ct_exp_net(exp);
 
+	NF_CT_ASSERT(master_help);
 	NF_CT_ASSERT(!timer_pending(&exp->timeout));
 
 	hlist_del_rcu(&exp->hnode);
 	net->ct.expect_count--;
 
 	hlist_del(&exp->lnode);
-	if (!(exp->flags & NF_CT_EXPECT_USERSPACE))
-		master_help->expecting[exp->class]--;
+	master_help->expecting[exp->class]--;
 
 	nf_ct_expect_event_report(IPEXP_DESTROY, exp, pid, report);
 	nf_ct_expect_put(exp);
@@ -312,37 +310,34 @@ void nf_ct_expect_put(struct nf_conntrack_expect *exp)
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_put);
 
-static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
+static int nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 {
 	struct nf_conn_help *master_help = nfct_help(exp->master);
+	struct nf_conntrack_helper *helper;
 	struct net *net = nf_ct_exp_net(exp);
-	const struct nf_conntrack_expect_policy *p;
 	unsigned int h = nf_ct_expect_dst_hash(&exp->tuple);
 
 	/* two references : one for hash insert, one for the timer */
 	atomic_add(2, &exp->use);
 
-	if (master_help) {
-		hlist_add_head(&exp->lnode, &master_help->expectations);
-		master_help->expecting[exp->class]++;
-	} else if (exp->flags & NF_CT_EXPECT_USERSPACE)
-		hlist_add_head(&exp->lnode, &nf_ct_userspace_expect_list);
+	hlist_add_head(&exp->lnode, &master_help->expectations);
+	master_help->expecting[exp->class]++;
 
 	hlist_add_head_rcu(&exp->hnode, &net->ct.expect_hash[h]);
 	net->ct.expect_count++;
 
 	setup_timer(&exp->timeout, nf_ct_expectation_timed_out,
 		    (unsigned long)exp);
-	if (master_help) {
-		p = &rcu_dereference_protected(
-				master_help->helper,
-				lockdep_is_held(&nf_conntrack_lock)
-				)->expect_policy[exp->class];
-		exp->timeout.expires = jiffies + p->timeout * HZ;
+	helper = rcu_dereference_protected(master_help->helper,
+					   lockdep_is_held(&nf_conntrack_lock));
+	if (helper) {
+		exp->timeout.expires = jiffies +
+			helper->expect_policy[exp->class].timeout * HZ;
 	}
 	add_timer(&exp->timeout);
 
 	NF_CT_STAT_INC(net, expect_create);
+	return 0;
 }
 
 /* Race with expectations being used means we could have none to find; OK. */
@@ -387,14 +382,13 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 	struct nf_conntrack_expect *i;
 	struct nf_conn *master = expect->master;
 	struct nf_conn_help *master_help = nfct_help(master);
+	struct nf_conntrack_helper *helper;
 	struct net *net = nf_ct_exp_net(expect);
 	struct hlist_node *n;
 	unsigned int h;
 	int ret = 1;
 
-	/* Don't allow expectations created from kernel-space with no helper */
-	if (!(expect->flags & NF_CT_EXPECT_USERSPACE) &&
-	    (!master_help || (master_help && !master_help->helper))) {
+	if (!master_help) {
 		ret = -ESHUTDOWN;
 		goto out;
 	}
@@ -412,11 +406,10 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 		}
 	}
 	/* Will be over limit? */
-	if (master_help) {
-		p = &rcu_dereference_protected(
-			master_help->helper,
-			lockdep_is_held(&nf_conntrack_lock)
-			)->expect_policy[expect->class];
+	helper = rcu_dereference_protected(master_help->helper,
+					   lockdep_is_held(&nf_conntrack_lock));
+	if (helper) {
+		p = &helper->expect_policy[expect->class];
 		if (p->max_expected &&
 		    master_help->expecting[expect->class] >= p->max_expected) {
 			evict_oldest_expect(master, expect);
@@ -448,8 +441,9 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 	if (ret <= 0)
 		goto out;
 
-	ret = 0;
-	nf_ct_expect_insert(expect);
+	ret = nf_ct_expect_insert(expect);
+	if (ret < 0)
+		goto out;
 	spin_unlock_bh(&nf_conntrack_lock);
 	nf_ct_expect_event_report(IPEXP_NEW, expect, pid, report);
 	return ret;
@@ -459,21 +453,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_related_report);
 
-void nf_ct_remove_userspace_expectations(void)
-{
-	struct nf_conntrack_expect *exp;
-	struct hlist_node *n, *next;
-
-	hlist_for_each_entry_safe(exp, n, next,
-				  &nf_ct_userspace_expect_list, lnode) {
-		if (del_timer(&exp->timeout)) {
-			nf_ct_unlink_expect(exp);
-			nf_ct_expect_put(exp);
-		}
-	}
-}
-EXPORT_SYMBOL_GPL(nf_ct_remove_userspace_expectations);
-
 #ifdef CONFIG_PROC_FS
 struct ct_expect_iter_state {
 	struct seq_net_private p;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 30bf8a1..7ab2227 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2019,6 +2019,10 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 	}
 	help = nfct_help(ct);
 	if (!help) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+	if (test_bit(IPS_USERSPACE_HELPER_BIT, &ct->status)) {
 		if (!cda[CTA_EXPECT_TIMEOUT]) {
 			err = -EINVAL;
 			goto out;
@@ -2208,7 +2212,6 @@ static void __exit ctnetlink_exit(void)
 {
 	pr_info("ctnetlink: unregistering from nfnetlink.\n");
 
-	nf_ct_remove_userspace_expectations();
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	nf_ct_expect_unregister_notifier(&ctnl_notifier_exp);
 	nf_conntrack_unregister_notifier(&ctnl_notifier);

