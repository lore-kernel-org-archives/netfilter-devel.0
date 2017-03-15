From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 4/7] net, netfilter: convert nf_acct.refcnt from atomic_t to refcount_t
Date: Wed, 15 Mar 2017 13:10:42 +0200
Message-ID: <1489576245-19472-5-git-send-email-elena.reshetova@intel.com>
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
 net/netfilter/nfnetlink_acct.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index d44d89b..f44cbd3 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/netlink.h>
 #include <linux/rculist.h>
 #include <linux/slab.h>
@@ -32,7 +33,7 @@ struct nf_acct {
 	atomic64_t		bytes;
 	unsigned long		flags;
 	struct list_head	head;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	char			name[NFACCT_NAME_MAX];
 	struct rcu_head		rcu_head;
 	char			data[0];
@@ -123,7 +124,7 @@ static int nfnl_acct_new(struct net *net, struct sock *nfnl,
 		atomic64_set(&nfacct->pkts,
 			     be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS])));
 	}
-	atomic_set(&nfacct->refcnt, 1);
+	refcount_set(&nfacct->refcnt, 1);
 	list_add_tail_rcu(&nfacct->head, &net->nfnl_acct_list);
 	return 0;
 }
@@ -166,7 +167,7 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 			 NFACCT_PAD) ||
 	    nla_put_be64(skb, NFACCT_BYTES, cpu_to_be64(bytes),
 			 NFACCT_PAD) ||
-	    nla_put_be32(skb, NFACCT_USE, htonl(atomic_read(&acct->refcnt))))
+	    nla_put_be32(skb, NFACCT_USE, htonl(refcount_read(&acct->refcnt))))
 		goto nla_put_failure;
 	if (acct->flags & NFACCT_F_QUOTA) {
 		u64 *quota = (u64 *)acct->data;
@@ -325,11 +326,12 @@ static int nfnl_acct_get(struct net *net, struct sock *nfnl,
 static int nfnl_acct_try_del(struct nf_acct *cur)
 {
 	int ret = 0;
+	unsigned int refcount;
 
 	/* We want to avoid races with nfnl_acct_put. So only when the current
 	 * refcnt is 1, we decrease it to 0.
 	 */
-	if (atomic_cmpxchg(&cur->refcnt, 1, 0) == 1) {
+	if (refcount_dec_if_one(&cur->refcnt)) {
 		/* We are protected by nfnl mutex. */
 		list_del_rcu(&cur->head);
 		kfree_rcu(cur, rcu_head);
@@ -413,7 +415,7 @@ struct nf_acct *nfnl_acct_find_get(struct net *net, const char *acct_name)
 		if (!try_module_get(THIS_MODULE))
 			goto err;
 
-		if (!atomic_inc_not_zero(&cur->refcnt)) {
+		if (!refcount_inc_not_zero(&cur->refcnt)) {
 			module_put(THIS_MODULE);
 			goto err;
 		}
@@ -429,7 +431,7 @@ EXPORT_SYMBOL_GPL(nfnl_acct_find_get);
 
 void nfnl_acct_put(struct nf_acct *acct)
 {
-	if (atomic_dec_and_test(&acct->refcnt))
+	if (refcount_dec_and_test(&acct->refcnt))
 		kfree_rcu(acct, rcu_head);
 
 	module_put(THIS_MODULE);
@@ -502,7 +504,7 @@ static void __net_exit nfnl_acct_net_exit(struct net *net)
 	list_for_each_entry_safe(cur, tmp, &net->nfnl_acct_list, head) {
 		list_del_rcu(&cur->head);
 
-		if (atomic_dec_and_test(&cur->refcnt))
+		if (refcount_dec_and_test(&cur->refcnt))
 			kfree_rcu(cur, rcu_head);
 	}
 }
-- 
2.7.4
