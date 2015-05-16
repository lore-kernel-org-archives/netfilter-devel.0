From: Felix Janda <felix.janda@posteo.de>
Subject: [libnetfilter_cthelper PATCH] Sync with kernel headers
Date: Sat, 16 May 2015 13:35:14 +0200
Message-ID: <20150516113259.GP14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:58451 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbbEPLfa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 07:35:30 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 057A925A3DEB
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 13:35:29 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpl0J6FGqz5vMs
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 13:35:28 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/linux/netfilter/nfnetlink.h | 52 ++++++++-----------------------------
 1 file changed, 11 insertions(+), 41 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index f1b546e..c755646 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -18,6 +18,10 @@ enum nfnetlink_groups {
 #define NFNLGRP_CONNTRACK_EXP_UPDATE	NFNLGRP_CONNTRACK_EXP_UPDATE
 	NFNLGRP_CONNTRACK_EXP_DESTROY,
 #define NFNLGRP_CONNTRACK_EXP_DESTROY	NFNLGRP_CONNTRACK_EXP_DESTROY
+	NFNLGRP_NFTABLES,
+#define NFNLGRP_NFTABLES                NFNLGRP_NFTABLES
+	NFNLGRP_ACCT_QUOTA,
+#define NFNLGRP_ACCT_QUOTA		NFNLGRP_ACCT_QUOTA
 	__NFNLGRP_MAX,
 };
 #define NFNLGRP_MAX	(__NFNLGRP_MAX - 1)
@@ -51,46 +55,12 @@ struct nfgenmsg {
 #define NFNL_SUBSYS_ACCT		7
 #define NFNL_SUBSYS_CTNETLINK_TIMEOUT	8
 #define NFNL_SUBSYS_CTHELPER		9
-#define NFNL_SUBSYS_COUNT		10
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
-- 
2.3.6
