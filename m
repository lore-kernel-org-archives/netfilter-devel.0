From: Felix Janda <felix.janda@posteo.de>
Subject: [libnetfilter_cttimeout PATCH] Sync with kernel headers
Date: Fri, 15 May 2015 23:36:44 +0200
Message-ID: <20150515213644.GA9601@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:50094 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422770AbbEOVhA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 May 2015 17:37:00 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id C90B025A213D
	for <netfilter-devel@vger.kernel.org>; Fri, 15 May 2015 23:36:58 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpNNp4jNLz5vMp
	for <netfilter-devel@vger.kernel.org>; Fri, 15 May 2015 23:36:58 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/linux/netfilter/nf_conntrack_tcp.h    | 28 --------------
 include/linux/netfilter/nfnetlink.h           | 53 ++++++---------------------
 include/linux/netfilter/nfnetlink_cttimeout.h |  2 +
 3 files changed, 14 insertions(+), 69 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/linux/netfilter/nf_conntrack_tcp.h
index e59868a..08c2fb3 100644
--- a/include/linux/netfilter/nf_conntrack_tcp.h
+++ b/include/linux/netfilter/nf_conntrack_tcp.h
@@ -47,33 +47,5 @@ struct nf_ct_tcp_flags {
 	__u8 mask;
 };
 
-#ifdef __KERNEL__
-
-struct ip_ct_tcp_state {
-	u_int32_t	td_end;		/* max of seq + len */
-	u_int32_t	td_maxend;	/* max of ack + max(win, 1) */
-	u_int32_t	td_maxwin;	/* max(win) */
-	u_int32_t	td_maxack;	/* max of ack */
-	u_int8_t	td_scale;	/* window scale factor */
-	u_int8_t	flags;		/* per direction options */
-};
-
-struct ip_ct_tcp {
-	struct ip_ct_tcp_state seen[2];	/* connection parameters per direction */
-	u_int8_t	state;		/* state of the connection (enum tcp_conntrack) */
-	/* For detecting stale connections */
-	u_int8_t	last_dir;	/* Direction of the last packet (enum ip_conntrack_dir) */
-	u_int8_t	retrans;	/* Number of retransmitted packets */
-	u_int8_t	last_index;	/* Index of the last packet */
-	u_int32_t	last_seq;	/* Last sequence number seen in dir */
-	u_int32_t	last_ack;	/* Last sequence number seen in opposite dir */
-	u_int32_t	last_end;	/* Last seq + len */
-	u_int16_t	last_win;	/* Last window advertisement seen in dir */
-	/* For SYN packets while we may be out-of-sync */
-	u_int8_t	last_wscale;	/* Last window scaling factor seen */
-	u_int8_t	last_flags;	/* Last flags set */
-};
-
-#endif /* __KERNEL__ */
 
 #endif /* _NF_CONNTRACK_TCP_H */
diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 6fd1f0d..c755646 100644
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
@@ -50,46 +54,13 @@ struct nfgenmsg {
 #define NFNL_SUBSYS_IPSET		6
 #define NFNL_SUBSYS_ACCT		7
 #define NFNL_SUBSYS_CTNETLINK_TIMEOUT	8
-#define NFNL_SUBSYS_COUNT		9
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
diff --git a/include/linux/netfilter/nfnetlink_cttimeout.h b/include/linux/netfilter/nfnetlink_cttimeout.h
index a2810a7..1ab0b97 100644
--- a/include/linux/netfilter/nfnetlink_cttimeout.h
+++ b/include/linux/netfilter/nfnetlink_cttimeout.h
@@ -6,6 +6,8 @@ enum ctnl_timeout_msg_types {
 	IPCTNL_MSG_TIMEOUT_NEW,
 	IPCTNL_MSG_TIMEOUT_GET,
 	IPCTNL_MSG_TIMEOUT_DELETE,
+	IPCTNL_MSG_TIMEOUT_DEFAULT_SET,
+	IPCTNL_MSG_TIMEOUT_DEFAULT_GET,
 
 	IPCTNL_MSG_TIMEOUT_MAX
 };
-- 
2.3.6
