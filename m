From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 5/7] net, netfilter: convert nf_conntrack_expect.use from atomic_t to refcount_t
Date: Wed, 15 Mar 2017 13:10:43 +0200
Message-ID: <1489576245-19472-6-git-send-email-elena.reshetova@intel.com>
References: <1489576245-19472-1-git-send-email-elena.reshetova@intel.com>
Cc: linux-kernel@vger.kernel.org, kadlec@blackhole.kfki.hu,
        pablo@netfilter.org, peterz@infradead.org, keescook@chromium.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        David Windsor <dwindsor@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1489576245-19472-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 include/net/netfilter/nf_conntrack_expect.h |  4 +++-
 net/netfilter/nf_conntrack_expect.c         | 10 +++++-----
 net/netfilter/nf_conntrack_netlink.c        |  4 ++--
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 5ed33ea..65cc2cb 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -5,6 +5,8 @@
 #ifndef _NF_CONNTRACK_EXPECT_H
 #define _NF_CONNTRACK_EXPECT_H
 
+#include <linux/refcount.h>
+
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 
@@ -37,7 +39,7 @@ struct nf_conntrack_expect {
 	struct timer_list timeout;
 
 	/* Usage count. */
-	atomic_t use;
+	refcount_t use;
 
 	/* Flags */
 	unsigned int flags;
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 4b2e1fb..cb29e59 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -133,7 +133,7 @@ nf_ct_expect_find_get(struct net *net,
 
 	rcu_read_lock();
 	i = __nf_ct_expect_find(net, zone, tuple);
-	if (i && !atomic_inc_not_zero(&i->use))
+	if (i && !refcount_inc_not_zero(&i->use))
 		i = NULL;
 	rcu_read_unlock();
 
@@ -186,7 +186,7 @@ nf_ct_find_expectation(struct net *net,
 		return NULL;
 
 	if (exp->flags & NF_CT_EXPECT_PERMANENT) {
-		atomic_inc(&exp->use);
+		refcount_inc(&exp->use);
 		return exp;
 	} else if (del_timer(&exp->timeout)) {
 		nf_ct_unlink_expect(exp);
@@ -275,7 +275,7 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 		return NULL;
 
 	new->master = me;
-	atomic_set(&new->use, 1);
+	refcount_set(&new->use, 1);
 	return new;
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_alloc);
@@ -348,7 +348,7 @@ static void nf_ct_expect_free_rcu(struct rcu_head *head)
 
 void nf_ct_expect_put(struct nf_conntrack_expect *exp)
 {
-	if (atomic_dec_and_test(&exp->use))
+	if (refcount_dec_and_test(&exp->use))
 		call_rcu(&exp->rcu, nf_ct_expect_free_rcu);
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_put);
@@ -361,7 +361,7 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 	unsigned int h = nf_ct_expect_dst_hash(net, &exp->tuple);
 
 	/* two references : one for hash insert, one for the timer */
-	atomic_add(2, &exp->use);
+	refcount_add(2, &exp->use);
 
 	hlist_add_head(&exp->lnode, &master_help->expectations);
 	master_help->expecting[exp->class]++;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6806b5e..d49cc1e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2693,7 +2693,7 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 						    cb->nlh->nlmsg_seq,
 						    IPCTNL_MSG_EXP_NEW,
 						    exp) < 0) {
-				if (!atomic_inc_not_zero(&exp->use))
+				if (!refcount_inc_not_zero(&exp->use))
 					continue;
 				cb->args[1] = (unsigned long)exp;
 				goto out;
@@ -2739,7 +2739,7 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 					    cb->nlh->nlmsg_seq,
 					    IPCTNL_MSG_EXP_NEW,
 					    exp) < 0) {
-			if (!atomic_inc_not_zero(&exp->use))
+			if (!refcount_inc_not_zero(&exp->use))
 				continue;
 			cb->args[1] = (unsigned long)exp;
 			goto out;
-- 
2.7.4
