From: mathieu.poirier@linaro.org
Subject: [PATCH v4 2/2] netfilter: xtables: add quota support for nfacct
Date: Mon, 10 Feb 2014 19:27:08 -0700
Message-ID: <1392085628-24804-3-git-send-email-mathieu.poirier@linaro.org>
References: <1392085628-24804-1-git-send-email-mathieu.poirier@linaro.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	fw@strlen.de, mathieu.poirier@linaro.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35494 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaBKC13 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Feb 2014 21:27:29 -0500
Received: by mail-pb0-f41.google.com with SMTP id up15so7083013pbc.14
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Feb 2014 18:27:28 -0800 (PST)
In-Reply-To: <1392085628-24804-1-git-send-email-mathieu.poirier@linaro.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Adding packet and byte quota support.  Once a quota has been
reached a noticifaction is sent to user space that includes
the name of the accounting object along with the current byte
and packet count.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 include/linux/netfilter/nfnetlink_acct.h      |  15 ++-
 include/uapi/linux/netfilter/nfnetlink.h      |   2 +
 include/uapi/linux/netfilter/nfnetlink_acct.h |   1 +
 include/uapi/linux/netfilter/xt_nfacct.h      |  14 ++-
 net/netfilter/Kconfig                         |   3 +-
 net/netfilter/nfnetlink_acct.c                |  50 ++++++---
 net/netfilter/xt_nfacct.c                     | 139 ++++++++++++++++++++++++--
 7 files changed, 194 insertions(+), 30 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index b2e85e5..3353390 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -3,11 +3,20 @@
 
 #include <uapi/linux/netfilter/nfnetlink_acct.h>
 
-
-struct nf_acct;
+struct nf_acct {
+	atomic64_t              pkts;
+	atomic64_t              bytes;
+	struct list_head        head;
+	atomic_t                refcnt;
+	char                    name[NFACCT_NAME_MAX];
+	struct rcu_head         rcu_head;
+	spinlock_t              lock;
+};
 
 struct nf_acct *nfnl_acct_find_get(const char *filter_name);
 void nfnl_acct_put(struct nf_acct *acct);
-void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct);
+extern void nfnl_acct_update(const struct sk_buff *skb,
+			    struct nf_acct *nfacct, u64 *pkts, u64 *bytes);
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
index 3e19c8a..c4d7674 100644
--- a/include/uapi/linux/netfilter/xt_nfacct.h
+++ b/include/uapi/linux/netfilter/xt_nfacct.h
@@ -3,11 +3,23 @@
 
 #include <linux/netfilter/nfnetlink_acct.h>
 
+enum xt_quota_flags {
+	XT_NFACCT_QUOTA_PKTS	= 1 << 0,
+	XT_NFACCT_QUOTA		= 1 << 1,
+};
+
 struct nf_acct;
 
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
index 225a886..8d23a15 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -29,16 +29,6 @@ MODULE_DESCRIPTION("nfacct: Extended Netfilter accounting infrastructure");
 
 static LIST_HEAD(nfnl_acct_list);
 
-struct nf_acct {
-	atomic64_t		pkts;
-	atomic64_t		bytes;
-	struct list_head	head;
-	atomic_t		refcnt;
-	char			name[NFACCT_NAME_MAX];
-	struct rcu_head		rcu_head;
-	spinlock_t		lock;
-};
-
 static int
 nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
@@ -96,7 +86,7 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 	return 0;
 }
 
-static int
+int
 nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 		   int event, struct nf_acct *acct)
 {
@@ -141,6 +131,7 @@ nla_put_failure:
 	nlmsg_cancel(skb, nlh);
 	return -1;
 }
+EXPORT_SYMBOL_GPL(nfnl_acct_fill_info);
 
 static int
 nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
@@ -336,15 +327,46 @@ void nfnl_acct_put(struct nf_acct *acct)
 }
 EXPORT_SYMBOL_GPL(nfnl_acct_put);
 
-void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct)
+void nfnl_acct_update(const struct sk_buff *skb,
+		     struct nf_acct *nfacct, u64 *pkts, u64 *bytes)
 {
+	u64 lpkts, lbytes;
+
 	spin_lock_bh(&nfacct->lock);
-	atomic64_inc(&nfacct->pkts);
-	atomic64_add(skb->len, &nfacct->bytes);
+	lpkts = atomic64_inc_return(&nfacct->pkts);
+	lbytes = atomic64_add_return(skb->len, &nfacct->bytes);
 	spin_unlock_bh(&nfacct->lock);
+
+	if (pkts)
+		*pkts = lpkts;
+	if (bytes)
+		*bytes = lbytes;
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
+					NFNL_MSG_ACCT_NEW, cur);
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
index b3be0ef..63ca22f 100644
--- a/net/netfilter/xt_nfacct.c
+++ b/net/netfilter/xt_nfacct.c
@@ -8,9 +8,12 @@
  */
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/spinlock.h>
 
+#include <net/netlink.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/nfnetlink_acct.h>
+#include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/xt_nfacct.h>
 
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
@@ -23,11 +26,86 @@ static bool nfacct_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_nfacct_match_info *info = par->targinfo;
 
-	nfnl_acct_update(skb, info->nfacct);
+	nfnl_acct_update(skb, info->nfacct, NULL, NULL);
 
 	return true;
 }
 
+/* Someone in the system may be upgrading 'info' at any moment.
+ * To avoid using a lock we simply make sure the packet count
+ * hasn't increased while we were updating the byte count.
+ */
+static void
+nfacct_get_values(const struct xt_nfacct_match_info_v1 *info,
+		 u64 *pkts, u64 *bytes) {
+	u64 old_pkts, new_pkts, lbytes;
+
+repeat:
+	old_pkts = atomic64_read(&info->nfacct->pkts);
+	lbytes = atomic64_read(&info->nfacct->bytes);
+	new_pkts = atomic64_read(&info->nfacct->pkts);
+
+	if (old_pkts != new_pkts)
+		goto repeat;
+
+	*pkts = new_pkts;
+	*bytes = lbytes;
+}
+
+static bool
+nfacct_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	int packet_mode;
+	u64 val;
+	u64 old_pkts, new_pkts, old_bytes, new_bytes;
+	const struct xt_nfacct_match_info_v1 *info = par->matchinfo;
+	bool ret = true;
+
+	/* get a reference count */
+	nfacct_get_values(info, &old_pkts, &old_bytes);
+	/* upgrade accounting stats */
+	nfnl_acct_update(skb, info->nfacct, &new_pkts, &new_bytes);
+
+	/* no need to go further if we don't have a quota */
+	if (!(info->flags & XT_NFACCT_QUOTA))
+		return ret;
+
+	packet_mode = info->flags & XT_NFACCT_QUOTA_PKTS;
+
+	val = (packet_mode) ? new_pkts : new_bytes;
+
+	/* are we over the limit ? */
+	if (val <= info->quota)
+		ret = !ret;
+
+	/* see if we need to tell userspace */
+	if (packet_mode) {
+		/* Easy case - send notification if we are handling the
+		 * packet that got us over quota.
+		 */
+		if (old_pkts < info->quota &&
+		   new_pkts >= info->quota &&
+		   old_pkts + 1 == new_pkts)
+			nfnl_quota_event(info->nfacct);
+	} else {
+		/* Need to be careful in byte mode - if nobody got in front
+		 * of us simply check if we are over quota.  If someone got
+		 * faster we need to see if they sent a notification by
+		 * checking how many bytes they contributed.
+		 *
+		 * If what they contributed went over quota they sent the
+		 * notification, otherwise we need to do so.
+		 */
+		if (old_pkts + 1 != new_pkts)
+			old_bytes = new_bytes - skb->len;
+
+		if (old_bytes < info->quota && val >= info->quota)
+			nfnl_quota_event(info->nfacct);
+	}
+
+	return ret;
+}
+
 static int
 nfacct_mt_checkentry(const struct xt_mtchk_param *par)
 {
@@ -44,6 +122,24 @@ nfacct_mt_checkentry(const struct xt_mtchk_param *par)
 	return 0;
 }
 
+static int
+nfacct_mt_checkentry_v1(const struct xt_mtchk_param *par)
+{
+	struct xt_nfacct_match_info_v1 *info = par->matchinfo;
+	struct nf_acct *nfacct;
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
+	return 0;
+}
+
 static void
 nfacct_mt_destroy(const struct xt_mtdtor_param *par)
 {
@@ -52,24 +148,45 @@ nfacct_mt_destroy(const struct xt_mtdtor_param *par)
 	nfnl_acct_put(info->nfacct);
 }
 
-static struct xt_match nfacct_mt_reg __read_mostly = {
-	.name       = "nfacct",
-	.family     = NFPROTO_UNSPEC,
-	.checkentry = nfacct_mt_checkentry,
-	.match      = nfacct_mt,
-	.destroy    = nfacct_mt_destroy,
-	.matchsize  = sizeof(struct xt_nfacct_match_info),
-	.me         = THIS_MODULE,
+static void
+nfacct_mt_destroy_v1(const struct xt_mtdtor_param *par)
+{
+	const struct xt_nfacct_match_info_v1 *info = par->matchinfo;
+
+	nfnl_acct_put(info->nfacct);
+}
+
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

