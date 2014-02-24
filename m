From: mathieu.poirier@linaro.org
Subject: [PATCH RESEND v5] netfilter: xtables: add quota support for nfacct
Date: Mon, 24 Feb 2014 07:26:24 -0700
Message-ID: <1393251984-20687-1-git-send-email-mathieu.poirier@linaro.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	mathieu.poirier@linaro.org
To: pablo@netfilter.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Adding packet and byte quota support.  Once a quota has been
reached a noticifaction is sent to user space that includes
the name of the accounting object along with the current byte
and packet count.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
Changes for v5:
- Removed spinlock from 'nfnl_acct_update'.
- Added accounting object store.
---
 include/linux/netfilter/nfnetlink_acct.h      |  17 ++-
 include/uapi/linux/netfilter/nfnetlink.h      |   2 +
 include/uapi/linux/netfilter/nfnetlink_acct.h |   1 +
 include/uapi/linux/netfilter/xt_nfacct.h      |  18 ++-
 net/netfilter/Kconfig                         |   3 +-
 net/netfilter/nfnetlink_acct.c                |  46 +++++--
 net/netfilter/xt_nfacct.c                     | 179 ++++++++++++++++++++++++--
 7 files changed, 238 insertions(+), 28 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index b2e85e5..bb04204 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -3,11 +3,24 @@
 
 #include <uapi/linux/netfilter/nfnetlink_acct.h>
 
+struct nf_acct {
+	atomic64_t		pkts;
+	atomic64_t		bytes;
+	struct list_head	head;
+	atomic_t		refcnt;
+	char			name[NFACCT_NAME_MAX];
+	struct rcu_head		rcu_head;
+};
 
-struct nf_acct;
+enum nfnl_acct_udt_type {
+	NFNL_ACCT_UDT_PACKETS,
+	NFNL_ACCT_UDT_BYTES,
+};
 
 struct nf_acct *nfnl_acct_find_get(const char *filter_name);
 void nfnl_acct_put(struct nf_acct *acct);
-void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct);
+extern u64 nfnl_acct_update(const struct sk_buff *skb,
+			   struct nf_acct *nfacct, int mode);
+void nfnl_quota_event(struct nf_acct *cur);
 
 #endif /* _NFNL_ACCT_H */
diff --git a/include/uapi/linux/netfilter/nfnetlink.h b/include/uapi/linux/netfilter/nfnetlink.h
index 596ddd4..354a7e5 100644
--- a/include/uapi/linux/netfilter/nfnetlink.h
+++ b/include/uapi/linux/netfilter/nfnetlink.h
@@ -20,6 +20,8 @@ enum nfnetlink_groups {
 #define NFNLGRP_CONNTRACK_EXP_DESTROY	NFNLGRP_CONNTRACK_EXP_DESTROY
 	NFNLGRP_NFTABLES,
 #define NFNLGRP_NFTABLES                NFNLGRP_NFTABLES
+	NFNLGRP_ACCT_QUOTA,
+#define NFNLGRP_ACCT_QUOTA		NFNLGRP_ACCT_QUOTA
 	__NFNLGRP_MAX,
 };
 #define NFNLGRP_MAX	(__NFNLGRP_MAX - 1)
diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
index c7b6269..ae8ea0a 100644
--- a/include/uapi/linux/netfilter/nfnetlink_acct.h
+++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
@@ -19,6 +19,7 @@ enum nfnl_acct_type {
 	NFACCT_PKTS,
 	NFACCT_BYTES,
 	NFACCT_USE,
+	NFACCT_QUOTA,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
diff --git a/include/uapi/linux/netfilter/xt_nfacct.h b/include/uapi/linux/netfilter/xt_nfacct.h
index 3e19c8a..7c35ce0 100644
--- a/include/uapi/linux/netfilter/xt_nfacct.h
+++ b/include/uapi/linux/netfilter/xt_nfacct.h
@@ -3,11 +3,27 @@
 
 #include <linux/netfilter/nfnetlink_acct.h>
 
+enum xt_quota_flags {
+	XT_NFACCT_QUOTA_PKTS	= 1 << 0,
+	XT_NFACCT_QUOTA		= 1 << 1,
+};
+
 struct nf_acct;
+struct nf_acct_quota;
 
 struct xt_nfacct_match_info {
 	char		name[NFACCT_NAME_MAX];
-	struct nf_acct	*nfacct;
+	struct nf_acct	*nfacct __aligned(8);
 };
 
+struct xt_nfacct_match_info_v1 {
+	char		name[NFACCT_NAME_MAX];
+	struct nf_acct	*nfacct __aligned(8);
+
+	__u32 flags;
+	__aligned_u64 quota;
+
+	/* used internally by kernel */
+	struct nf_acct_quota *priv __aligned(8);
+};
 #endif /* _XT_NFACCT_MATCH_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 748f304..ce184951 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -1108,7 +1108,8 @@ config NETFILTER_XT_MATCH_NFACCT
 	select NETFILTER_NETLINK_ACCT
 	help
 	  This option allows you to use the extended accounting through
-	  nfnetlink_acct.
+	  nfnetlink_acct.  It is also possible to add quotas at the
+	  packet and byte level.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index c7b6d46..5c580a7 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -29,15 +29,6 @@ MODULE_DESCRIPTION("nfacct: Extended Netfilter accounting infrastructure");
 
 static LIST_HEAD(nfnl_acct_list);
 
-struct nf_acct {
-	atomic64_t		pkts;
-	atomic64_t		bytes;
-	struct list_head	head;
-	atomic_t		refcnt;
-	char			name[NFACCT_NAME_MAX];
-	struct rcu_head		rcu_head;
-};
-
 static int
 nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
@@ -92,7 +83,7 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 	return 0;
 }
 
-static int
+int
 nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 		   int event, struct nf_acct *acct)
 {
@@ -134,6 +125,7 @@ nla_put_failure:
 	nlmsg_cancel(skb, nlh);
 	return -1;
 }
+EXPORT_SYMBOL_GPL(nfnl_acct_fill_info);
 
 static int
 nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
@@ -329,13 +321,41 @@ void nfnl_acct_put(struct nf_acct *acct)
 }
 EXPORT_SYMBOL_GPL(nfnl_acct_put);
 
-void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct)
+u64 nfnl_acct_update(const struct sk_buff *skb,
+		    struct nf_acct *nfacct, int mode)
 {
-	atomic64_inc(&nfacct->pkts);
-	atomic64_add(skb->len, &nfacct->bytes);
+	u64 pkts, bytes;
+
+	pkts = atomic64_inc_return(&nfacct->pkts);
+	bytes = atomic64_add_return(skb->len, &nfacct->bytes);
+
+	return (mode == NFNL_ACCT_UDT_PACKETS) ? pkts : bytes;
 }
 EXPORT_SYMBOL_GPL(nfnl_acct_update);
 
+void
+nfnl_quota_event(struct nf_acct *cur)
+{
+	int ret;
+	struct sk_buff *skb;
+
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (skb == NULL)
+		return;
+
+	ret = nfnl_acct_fill_info(skb, 0, 0, NFACCT_QUOTA,
+				 NFNL_MSG_ACCT_NEW, cur);
+
+	if (ret <= 0) {
+		kfree_skb(skb);
+		return;
+	}
+
+	netlink_broadcast(init_net.nfnl, skb, 0,
+			 NFNLGRP_ACCT_QUOTA, GFP_ATOMIC);
+}
+EXPORT_SYMBOL_GPL(nfnl_quota_event);
+
 static int __init nfnl_acct_init(void)
 {
 	int ret;
diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
index b3be0ef..d1bd5ea 100644
--- a/net/netfilter/xt_nfacct.c
+++ b/net/netfilter/xt_nfacct.c
@@ -9,8 +9,10 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 
+#include <net/netlink.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/nfnetlink_acct.h>
+#include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/xt_nfacct.h>
 
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
@@ -19,15 +21,62 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_nfacct");
 MODULE_ALIAS("ip6t_nfacct");
 
+static LIST_HEAD(nfacct_list);
+static DEFINE_MUTEX(nfacct_list_mutex);
+
+struct nf_acct_quota {
+	char			name[NFACCT_NAME_MAX];
+	int			count;
+	u32			flags;
+	u64			quota;
+	struct list_head	node;
+	atomic_t		notified;
+};
+
 static bool nfacct_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_nfacct_match_info *info = par->targinfo;
+	u64 __always_unused val;
 
-	nfnl_acct_update(skb, info->nfacct);
+	val = nfnl_acct_update(skb, info->nfacct, 0);
 
 	return true;
 }
 
+static bool
+nfacct_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	int mode;
+	u64 val;
+	const struct xt_nfacct_match_info_v1 *info = par->matchinfo;
+	struct nf_acct_quota *acct_quota = info->priv;
+	bool ret = true;
+
+	mode = (acct_quota->flags & XT_NFACCT_QUOTA_PKTS) ?
+	       NFNL_ACCT_UDT_PACKETS : NFNL_ACCT_UDT_BYTES;
+
+	/* upgrade accounting stats */
+	val = nfnl_acct_update(skb, info->nfacct, mode);
+
+	/* no need to go further if we don't have a quota */
+	if (!(acct_quota->flags & XT_NFACCT_QUOTA))
+		return ret;
+
+	/* are we over the limit ? */
+	if (val <= info->quota) {
+		/* reset flag in case userspace cleared the counters */
+		atomic_set(&acct_quota->notified, 0);
+		ret = !ret;
+	}
+
+	if (val >= info->quota)
+		/* cmpxchg guarantees only one CPU can send a notification */
+		if (atomic_cmpxchg(&acct_quota->notified, 0, 1) == 0)
+			nfnl_quota_event(info->nfacct);
+
+	return ret;
+}
+
 static int
 nfacct_mt_checkentry(const struct xt_mtchk_param *par)
 {
@@ -44,32 +93,140 @@ nfacct_mt_checkentry(const struct xt_mtchk_param *par)
 	return 0;
 }
 
+static
+struct nf_acct_quota *nfacct_find_quota(char *name)
+{
+	struct nf_acct_quota *curr, *match = NULL;
+
+	mutex_lock(&nfacct_list_mutex);
+	list_for_each_entry(curr, &nfacct_list, node)
+		if (strncmp(curr->name, name, NFACCT_NAME_MAX) == 0) {
+			match = curr;
+			match->count++;
+			break;
+		}
+
+	mutex_unlock(&nfacct_list_mutex);
+
+	return match;
+}
+
+static struct  nf_acct_quota *
+nfacct_create_quota(struct xt_nfacct_match_info_v1 *info)
+{
+	struct nf_acct_quota *acct_quota;
+
+	mutex_lock(&nfacct_list_mutex);
+
+	acct_quota = kmalloc(sizeof(struct nf_acct_quota), GFP_ATOMIC);
+
+	if (!acct_quota) {
+		mutex_unlock(&nfacct_list_mutex);
+		return NULL;
+	}
+
+	strncpy(acct_quota->name, info->name, NFACCT_NAME_MAX);
+	acct_quota->flags = info->flags;
+	acct_quota->quota = info->quota;
+	acct_quota->count = 1;
+	atomic_set(&acct_quota->notified, 0);
+	list_add_tail(&acct_quota->node, &nfacct_list);
+
+	mutex_unlock(&nfacct_list_mutex);
+
+	return acct_quota;
+}
+
+static int
+nfacct_mt_checkentry_v1(const struct xt_mtchk_param *par)
+{
+	struct xt_nfacct_match_info_v1 *info = par->matchinfo;
+	struct nf_acct *nfacct;
+	struct nf_acct_quota *acct_quota = NULL;
+
+	nfacct = nfnl_acct_find_get(info->name);
+	if (nfacct == NULL) {
+		pr_info("xt_nfacct: invalid accounting object `%s'\n",
+		       info->name);
+		return -ENOENT;
+	}
+
+	info->nfacct = nfacct;
+
+	if (info->flags & XT_NFACCT_QUOTA) {
+		/* get quota object from list */
+		acct_quota = nfacct_find_quota(info->name);
+
+		/* object doesn't exist - create it */
+		if (acct_quota == NULL) {
+			acct_quota = nfacct_create_quota(info);
+			/* something went wrong - get out of here */
+			if (acct_quota == NULL) {
+				nfnl_acct_put(info->nfacct);
+				return -ENOMEM;
+			}
+		}
+	}
+
+	info->priv = acct_quota;
+
+	return 0;
+}
+
 static void
 nfacct_mt_destroy(const struct xt_mtdtor_param *par)
 {
 	const struct xt_nfacct_match_info *info = par->matchinfo;
+	nfnl_acct_put(info->nfacct);
+}
+
+static void
+nfacct_mt_destroy_v1(const struct xt_mtdtor_param *par)
+{
+	const struct xt_nfacct_match_info_v1 *info = par->matchinfo;
+	struct nf_acct_quota *acct_quota = info->priv;
 
 	nfnl_acct_put(info->nfacct);
+
+	mutex_lock(&nfacct_list_mutex);
+	if (--acct_quota->count == 0) {
+		list_del(&acct_quota->node);
+		kfree(acct_quota);
+	}
+	mutex_unlock(&nfacct_list_mutex);
 }
 
-static struct xt_match nfacct_mt_reg __read_mostly = {
-	.name       = "nfacct",
-	.family     = NFPROTO_UNSPEC,
-	.checkentry = nfacct_mt_checkentry,
-	.match      = nfacct_mt,
-	.destroy    = nfacct_mt_destroy,
-	.matchsize  = sizeof(struct xt_nfacct_match_info),
-	.me         = THIS_MODULE,
+static struct xt_match nfacct_mt_reg[] __read_mostly = {
+	{
+		.name       = "nfacct",
+		.family     = NFPROTO_UNSPEC,
+		.checkentry = nfacct_mt_checkentry,
+		.match      = nfacct_mt,
+		.destroy    = nfacct_mt_destroy,
+		.matchsize  = sizeof(struct xt_nfacct_match_info),
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "nfacct",
+		.revision   = 1,
+		.family     = NFPROTO_UNSPEC,
+		.checkentry = nfacct_mt_checkentry_v1,
+		.match      = nfacct_mt_v1,
+		.destroy    = nfacct_mt_destroy_v1,
+		.matchsize  = sizeof(struct xt_nfacct_match_info_v1),
+		.me         = THIS_MODULE,
+	},
+
 };
 
 static int __init nfacct_mt_init(void)
 {
-	return xt_register_match(&nfacct_mt_reg);
+	return xt_register_matches(nfacct_mt_reg, ARRAY_SIZE(nfacct_mt_reg));
 }
 
 static void __exit nfacct_mt_exit(void)
 {
-	xt_unregister_match(&nfacct_mt_reg);
+	xt_unregister_matches(nfacct_mt_reg, ARRAY_SIZE(nfacct_mt_reg));
 }
 
 module_init(nfacct_mt_init);
-- 
1.8.3.2

