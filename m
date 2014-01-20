From: mathieu.poirier@linaro.org
Subject: [PATCH v2 1/1] netfilter: xtables: add quota support to nfacct
Date: Mon, 20 Jan 2014 07:55:38 -0700
Message-ID: <1390229738-20183-2-git-send-email-mathieu.poirier@linaro.org>
References: <1390229738-20183-1-git-send-email-mathieu.poirier@linaro.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	john.stultz@linaro.org, jpa@google.com, mathieu.poirier@linaro.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:43027 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaATOzu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:55:50 -0500
Received: by mail-pd0-f175.google.com with SMTP id w10so1669665pde.20
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jan 2014 06:55:49 -0800 (PST)
In-Reply-To: <1390229738-20183-1-git-send-email-mathieu.poirier@linaro.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Adding packet and byte quota support.  Once a quota has been
reached a noticifaction is sent to user space that includes
the name of the accounting object along with the current byte
and packet count.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
Changes for v2:
 - Modified broadcast group name.
 - Remove invert logic.
 - Modified flad name.
 - Fixed match_info alignment.
 - Added versionning to xt_nfacct_match_info structure.
 - Removed export symbols after moving code around.
 - Removed miscellaneous error messages.
 - Moved to GFP_ATOMIC for sk_buff packet allocation.
 - Added check for kmalloc failure.

 include/linux/netfilter/nfnetlink_acct.h      |  12 ++-
 include/uapi/linux/netfilter/nfnetlink.h      |   2 +
 include/uapi/linux/netfilter/nfnetlink_acct.h |   1 +
 include/uapi/linux/netfilter/xt_nfacct.h      |  14 ++++
 net/netfilter/Kconfig                         |   3 +-
 net/netfilter/nfnetlink_acct.c                |  35 ++++++---
 net/netfilter/xt_nfacct.c                     | 107 +++++++++++++++++++++++---
 7 files changed, 150 insertions(+), 24 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index bb4bbc9..76b99f3 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -3,11 +3,17 @@
 
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
+};
 
 extern struct nf_acct *nfnl_acct_find_get(const char *filter_name);
 extern void nfnl_acct_put(struct nf_acct *acct);
 extern void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct);
-
+extern void nfnl_quota_event(struct nf_acct *cur);
 #endif /* _NFNL_ACCT_H */
diff --git a/include/uapi/linux/netfilter/nfnetlink.h b/include/uapi/linux/netfilter/nfnetlink.h
index 4a4efaf..c987dc3 100644
--- a/include/uapi/linux/netfilter/nfnetlink.h
+++ b/include/uapi/linux/netfilter/nfnetlink.h
@@ -18,6 +18,8 @@ enum nfnetlink_groups {
 #define NFNLGRP_CONNTRACK_EXP_UPDATE	NFNLGRP_CONNTRACK_EXP_UPDATE
 	NFNLGRP_CONNTRACK_EXP_DESTROY,
 #define NFNLGRP_CONNTRACK_EXP_DESTROY	NFNLGRP_CONNTRACK_EXP_DESTROY
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
index 3e19c8a..d38104f 100644
--- a/include/uapi/linux/netfilter/xt_nfacct.h
+++ b/include/uapi/linux/netfilter/xt_nfacct.h
@@ -3,11 +3,25 @@
 
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
 	struct nf_acct	*nfacct;
 };
 
+struct xt_nfacct_match_info_v1 {
+	char		name[NFACCT_NAME_MAX];
+	struct nf_acct	*nfacct;
+
+	__u32 flags;
+	__aligned_u64 quota;
+	struct nf_acct_quota	*priv;
+};
 #endif /* _XT_NFACCT_MATCH_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index bdf9c60..bebbc0c 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -1064,7 +1064,8 @@ config NETFILTER_XT_MATCH_NFACCT
 	select NETFILTER_NETLINK_ACCT
 	help
 	  This option allows you to use the extended accounting through
-	  nfnetlink_acct.
+	  nfnetlink_acct.  It is also possible to add quotas at the
+	  packet and byte level.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index c7b6d46..d825f60 100644
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
@@ -336,6 +328,29 @@ void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct)
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
index b3be0ef..ff66792 100644
--- a/net/netfilter/xt_nfacct.c
+++ b/net/netfilter/xt_nfacct.c
@@ -8,10 +8,14 @@
  */
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/spinlock.h>
 
+#include <net/netlink.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/nfnetlink_acct.h>
+#include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/xt_nfacct.h>
+#include <linux/netfilter_ipv4/ipt_ULOG.h>
 
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: match for the extended accounting infrastructure");
@@ -19,6 +23,11 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_nfacct");
 MODULE_ALIAS("ip6t_nfacct");
 
+struct nf_acct_quota {
+	spinlock_t lock;
+	bool quota_reached; /* true if quota has been reached. */
+};
+
 static bool nfacct_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_nfacct_match_info *info = par->targinfo;
@@ -28,6 +37,36 @@ static bool nfacct_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return true;
 }
 
+static bool
+nfacct_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	u64 val;
+	const struct xt_nfacct_match_info_v1 *info = par->matchinfo;
+	bool ret = true;
+
+	nfnl_acct_update(skb, info->nfacct);
+
+	if (info->flags & XT_NFACCT_QUOTA) {
+		spin_lock_bh(&info->priv->lock);
+		val = (info->flags & XT_NFACCT_QUOTA_PKTS) ?
+				atomic64_read(&info->nfacct->pkts) :
+				atomic64_read(&info->nfacct->bytes);
+		if (val <= info->quota) {
+			ret = !ret;
+			info->priv->quota_reached = false;
+		}
+
+		if (val >= info->quota && !info->priv->quota_reached) {
+			info->priv->quota_reached = true;
+			nfnl_quota_event(info->nfacct);
+		}
+
+		spin_unlock_bh(&info->priv->lock);
+	}
+
+	return ret;
+}
+
 static int
 nfacct_mt_checkentry(const struct xt_mtchk_param *par)
 {
@@ -44,6 +83,32 @@ nfacct_mt_checkentry(const struct xt_mtchk_param *par)
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
+	if ((info->flags & XT_NFACCT_QUOTA) && !info->priv) {
+		info->priv =  kmalloc(sizeof(struct nf_acct_quota), GFP_KERNEL);
+		if (info->priv == NULL)
+			return -ENOMEM;
+		spin_lock_init(&info->priv->lock);
+		info->priv->quota_reached = false;
+	}
+
+	return 0;
+}
+
 static void
 nfacct_mt_destroy(const struct xt_mtdtor_param *par)
 {
@@ -52,24 +117,46 @@ nfacct_mt_destroy(const struct xt_mtdtor_param *par)
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
+	kfree(info->priv);
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

