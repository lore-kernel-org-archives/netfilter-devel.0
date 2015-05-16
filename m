From: Felix Janda <felix.janda@posteo.de>
Subject: [libnfnetlink PATCH 1/3] Sync with kernel headers
Date: Sat, 16 May 2015 14:49:07 +0200
Message-ID: <20150516124638.GX14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:34389 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbbEPMtj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 08:49:39 -0400
Received: from dovecot04.posteo.de (unknown [185.67.36.27])
	by mx02.posteo.de (Postfix) with ESMTPS id 316AF25A211D
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 14:49:37 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot04.posteo.de (Postfix) with ESMTPSA id 3lpmdr4jrfzFpVq
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 14:49:36 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/libnfnetlink/linux_nfnetlink.h        | 55 +++++++++------------------
 include/libnfnetlink/linux_nfnetlink_compat.h | 12 +++---
 2 files changed, 24 insertions(+), 43 deletions(-)

diff --git a/include/libnfnetlink/linux_nfnetlink.h b/include/libnfnetlink/linux_nfnetlink.h
index 76a8550..f7af94f 100644
--- a/include/libnfnetlink/linux_nfnetlink.h
+++ b/include/libnfnetlink/linux_nfnetlink.h
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
@@ -25,8 +29,8 @@ enum nfnetlink_groups {
 /* General form of address family dependent message.
  */
 struct nfgenmsg {
-	u_int8_t  nfgen_family;		/* AF_xxx */
-	u_int8_t  version;		/* nfnetlink version */
+	__u8  nfgen_family;		/* AF_xxx */
+	__u8  version;		/* nfnetlink version */
 	u_int16_t    res_id;		/* resource id */
 };
 
@@ -46,40 +50,17 @@ struct nfgenmsg {
 #define NFNL_SUBSYS_CTNETLINK_EXP	2
 #define NFNL_SUBSYS_QUEUE		3
 #define NFNL_SUBSYS_ULOG		4
-#define NFNL_SUBSYS_COUNT		5
+#define NFNL_SUBSYS_OSF			5
+#define NFNL_SUBSYS_IPSET		6
+#define NFNL_SUBSYS_ACCT		7
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
-struct nfnl_callback
-{
-	int (*call)(struct sock *nl, struct sk_buff *skb, 
-		struct nlmsghdr *nlh, struct nlattr *cda[]);
-	const struct nla_policy *policy;	/* netlink attribute policy */
-	const u_int16_t attr_count;		/* number of nlattr's */
-};
-
-struct nfnetlink_subsystem
-{
-	const char *name;
-	__u8 subsys_id;			/* nfnetlink subsystem ID */
-	__u8 cb_count;			/* number of callbacks */
-	const struct nfnl_callback *cb;	/* callback for individual types */
-};
-
-extern int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n);
-extern int nfnetlink_subsys_unregister(const struct nfnetlink_subsystem *n);
-
-extern int nfnetlink_has_listeners(unsigned int group);
-extern int nfnetlink_send(struct sk_buff *skb, u32 pid, unsigned group, 
-			  int echo);
-extern int nfnetlink_unicast(struct sk_buff *skb, u_int32_t pid, int flags);
-
-#define MODULE_ALIAS_NFNL_SUBSYS(subsys) \
-	MODULE_ALIAS("nfnetlink-subsys-" __stringify(subsys))
-
-#endif	/* __KERNEL__ */
-#endif	/* _NFNETLINK_H */
+#endif /* _NFNETLINK_H */
diff --git a/include/libnfnetlink/linux_nfnetlink_compat.h b/include/libnfnetlink/linux_nfnetlink_compat.h
index e145176..74b9e55 100644
--- a/include/libnfnetlink/linux_nfnetlink_compat.h
+++ b/include/libnfnetlink/linux_nfnetlink_compat.h
@@ -1,6 +1,8 @@
 #ifndef _NFNETLINK_COMPAT_H
 #define _NFNETLINK_COMPAT_H
-#ifndef __KERNEL__
+
+#include <linux/types.h>
+
 /* Old nfnetlink macros for userspace */
 
 /* nfnetlink groups: Up to 32 maximum */
@@ -18,10 +20,9 @@
  * ! nfnetlink use the same attributes methods. - J. Schulist.
  */
 
-struct nfattr
-{
-	u_int16_t nfa_len;
-	u_int16_t nfa_type;	/* we use 15 bits for the type, and the highest
+struct nfattr {
+	__u16 nfa_len;
+	__u16 nfa_type;	/* we use 15 bits for the type, and the highest
 				 * bit to indicate whether the payload is nested */
 };
 
@@ -57,5 +58,4 @@ struct nfattr
         + NLMSG_ALIGN(sizeof(struct nfgenmsg))))
 #define NFM_PAYLOAD(n)  NLMSG_PAYLOAD(n, sizeof(struct nfgenmsg))
 
-#endif /* ! __KERNEL__ */
 #endif /* _NFNETLINK_COMPAT_H */
-- 
2.3.6
