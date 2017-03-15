From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 3/7] net, netfilter: convert ctnl_timeout.refcnt from atomic_t to refcount_t
Date: Wed, 15 Mar 2017 13:10:41 +0200
Message-ID: <1489576245-19472-4-git-send-email-elena.reshetova@intel.com>
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
 include/net/netfilter/nf_conntrack_timeout.h |  3 ++-
 net/netfilter/nfnetlink_cttimeout.c          | 12 ++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index 5cc5e9e..d40b893 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -4,6 +4,7 @@
 #include <net/net_namespace.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <linux/refcount.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
@@ -12,7 +13,7 @@
 struct ctnl_timeout {
 	struct list_head	head;
 	struct rcu_head		rcu_head;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	char			name[CTNL_TIMEOUT_NAME_MAX];
 	__u16			l3num;
 	struct nf_conntrack_l4proto *l4proto;
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 139e086..baa75f3 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -138,7 +138,7 @@ static int cttimeout_new_timeout(struct net *net, struct sock *ctnl,
 	strcpy(timeout->name, nla_data(cda[CTA_TIMEOUT_NAME]));
 	timeout->l3num = l3num;
 	timeout->l4proto = l4proto;
-	atomic_set(&timeout->refcnt, 1);
+	refcount_set(&timeout->refcnt, 1);
 	list_add_tail_rcu(&timeout->head, &net->nfct_timeout_list);
 
 	return 0;
@@ -172,7 +172,7 @@ ctnl_timeout_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	    nla_put_be16(skb, CTA_TIMEOUT_L3PROTO, htons(timeout->l3num)) ||
 	    nla_put_u8(skb, CTA_TIMEOUT_L4PROTO, timeout->l4proto->l4proto) ||
 	    nla_put_be32(skb, CTA_TIMEOUT_USE,
-			 htonl(atomic_read(&timeout->refcnt))))
+			 htonl(refcount_read(&timeout->refcnt))))
 		goto nla_put_failure;
 
 	if (likely(l4proto->ctnl_timeout.obj_to_nlattr)) {
@@ -339,7 +339,7 @@ static int ctnl_timeout_try_del(struct net *net, struct ctnl_timeout *timeout)
 	/* We want to avoid races with ctnl_timeout_put. So only when the
 	 * current refcnt is 1, we decrease it to 0.
 	 */
-	if (atomic_cmpxchg(&timeout->refcnt, 1, 0) == 1) {
+	if (refcount_dec_if_one(&timeout->refcnt)) {
 		/* We are protected by nfnl mutex. */
 		list_del_rcu(&timeout->head);
 		nf_ct_l4proto_put(timeout->l4proto);
@@ -536,7 +536,7 @@ ctnl_timeout_find_get(struct net *net, const char *name)
 		if (!try_module_get(THIS_MODULE))
 			goto err;
 
-		if (!atomic_inc_not_zero(&timeout->refcnt)) {
+		if (!refcount_inc_not_zero(&timeout->refcnt)) {
 			module_put(THIS_MODULE);
 			goto err;
 		}
@@ -550,7 +550,7 @@ ctnl_timeout_find_get(struct net *net, const char *name)
 
 static void ctnl_timeout_put(struct ctnl_timeout *timeout)
 {
-	if (atomic_dec_and_test(&timeout->refcnt))
+	if (refcount_dec_and_test(&timeout->refcnt))
 		kfree_rcu(timeout, rcu_head);
 
 	module_put(THIS_MODULE);
@@ -601,7 +601,7 @@ static void __net_exit cttimeout_net_exit(struct net *net)
 		list_del_rcu(&cur->head);
 		nf_ct_l4proto_put(cur->l4proto);
 
-		if (atomic_dec_and_test(&cur->refcnt))
+		if (refcount_dec_and_test(&cur->refcnt))
 			kfree_rcu(cur, rcu_head);
 	}
 }
-- 
2.7.4
