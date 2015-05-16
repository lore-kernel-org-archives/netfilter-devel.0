From: Felix Janda <felix.janda@posteo.de>
Subject: [nfacct PATCH] Sync with kernel headers
Date: Sat, 16 May 2015 15:00:45 +0200
Message-ID: <20150516130045.GA14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:46331 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbbEPNBQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 09:01:16 -0400
Received: from dovecot04.posteo.de (unknown [185.67.36.27])
	by mx02.posteo.de (Postfix) with ESMTPS id 0984C25A3DCF
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 15:01:15 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot04.posteo.de (Postfix) with ESMTPSA id 3lpmvG6BpCzFpVg
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 15:01:14 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/linux/netfilter/nfnetlink.h      | 52 ++++++--------------------------
 include/linux/netfilter/nfnetlink_acct.h | 19 +++---------
 2 files changed, 15 insertions(+), 56 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index ea27bb6..c755646 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -19,7 +19,7 @@ enum nfnetlink_groups {
 	NFNLGRP_CONNTRACK_EXP_DESTROY,
 #define NFNLGRP_CONNTRACK_EXP_DESTROY	NFNLGRP_CONNTRACK_EXP_DESTROY
 	NFNLGRP_NFTABLES,
-#define NFNLGRP_NFTABLES		NFNLGRP_NFTABLES
+#define NFNLGRP_NFTABLES                NFNLGRP_NFTABLES
 	NFNLGRP_ACCT_QUOTA,
 #define NFNLGRP_ACCT_QUOTA		NFNLGRP_ACCT_QUOTA
 	__NFNLGRP_MAX,
@@ -53,46 +53,14 @@ struct nfgenmsg {
 #define NFNL_SUBSYS_OSF			5
 #define NFNL_SUBSYS_IPSET		6
 #define NFNL_SUBSYS_ACCT		7
-#define NFNL_SUBSYS_COUNT		8
+#define NFNL_SUBSYS_CTNETLINK_TIMEOUT	8
+#define NFNL_SUBSYS_CTHELPER		9
+#define NFNL_SUBSYS_NFTABLES		10
+#define NFNL_SUBSYS_NFT_COMPAT		11
+#define NFNL_SUBSYS_COUNT		12
 
-#ifdef __KERNEL__
+/* Reserved control nfnetlink messages */
+#define NFNL_MSG_BATCH_BEGIN		NLMSG_MIN_TYPE
+#define NFNL_MSG_BATCH_END		NLMSG_MIN_TYPE+1
 
-#include <linux/netlink.h>
-#include <linux/capability.h>
-#include <net/netlink.h>
-
-struct nfnl_callback {
-	int (*call)(struct sock *nl, struct sk_buff *skb, 
-		    const struct nlmsghdr *nlh,
-		    const struct nlattr * const cda[]);
-	int (*call_rcu)(struct sock *nl, struct sk_buff *skb, 
-		    const struct nlmsghdr *nlh,
-		    const struct nlattr * const cda[]);
-	const struct nla_policy *policy;	/* netlink attribute policy */
-	const u_int16_t attr_count;		/* number of nlattr's */
-};
-
-struct nfnetlink_subsystem {
-	const char *name;
-	__u8 subsys_id;			/* nfnetlink subsystem ID */
-	__u8 cb_count;			/* number of callbacks */
-	const struct nfnl_callback *cb;	/* callback for individual types */
-};
-
-extern int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n);
-extern int nfnetlink_subsys_unregister(const struct nfnetlink_subsystem *n);
-
-extern int nfnetlink_has_listeners(struct net *net, unsigned int group);
-extern int nfnetlink_send(struct sk_buff *skb, struct net *net, u32 pid, unsigned group,
-			  int echo, gfp_t flags);
-extern int nfnetlink_set_err(struct net *net, u32 pid, u32 group, int error);
-extern int nfnetlink_unicast(struct sk_buff *skb, struct net *net, u_int32_t pid, int flags);
-
-extern void nfnl_lock(void);
-extern void nfnl_unlock(void);
-
-#define MODULE_ALIAS_NFNL_SUBSYS(subsys) \
-	MODULE_ALIAS("nfnetlink-subsys-" __stringify(subsys))
-
-#endif	/* __KERNEL__ */
-#endif	/* _NFNETLINK_H */
+#endif /* _NFNETLINK_H */
diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index 6c99213..98b6286 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -15,9 +15,9 @@ enum nfnl_acct_msg_types {
 };
 
 enum nfnl_acct_flags {
-	NFACCT_F_QUOTA_PKTS     = (1 << 0),
-	NFACCT_F_QUOTA_BYTES    = (1 << 1),
-	NFACCT_F_OVERQUOTA      = (1 << 2), /* can't be set from userspace */
+	NFACCT_F_QUOTA_PKTS	= (1 << 0),
+	NFACCT_F_QUOTA_BYTES	= (1 << 1),
+	NFACCT_F_OVERQUOTA	= (1 << 2), /* can't be set from userspace */
 };
 
 enum nfnl_acct_type {
@@ -39,15 +39,6 @@ enum nfnl_attr_filter_type {
 	NFACCT_FILTER_VALUE,
 	__NFACCT_FILTER_MAX
 };
+#define NFACCT_FILTER_MAX (__NFACCT_FILTER_MAX - 1)
 
-#ifdef __KERNEL__
-
-struct nf_acct;
-
-extern struct nf_acct *nfnl_acct_find_get(const char *filter_name);
-extern void nfnl_acct_put(struct nf_acct *acct);
-extern void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct);
-
-#endif /* __KERNEL__ */
-
-#endif /* _NFNL_ACCT_H */
+#endif /* _NFNL_ACCT_H_ */
-- 
2.3.6
