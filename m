From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/2] build: resolve compile abort on RHEL5 #1
Date: Sat, 13 Oct 2012 14:09:21 +0200
Message-ID: <1350130162-13193-2-git-send-email-jengelh@inai.de>
References: <1350130162-13193-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:60247 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab2JMMJ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Oct 2012 08:09:26 -0400
In-Reply-To: <1350130162-13193-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[   24s] In file included from libnetfilter_acct.c:18:
[   24s] ../include/linux/netfilter/nfnetlink.h:4:46: error:
linux/netfilter/nfnetlink_compat.h: No such file or directory

Slurp in new headers from the kernel du jour (v3.6-10970-g4d7127d).

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/linux/netfilter/nfnetlink.h        |   50 +++--------------------
 include/linux/netfilter/nfnetlink_acct.h   |   15 ++-----
 include/linux/netfilter/nfnetlink_compat.h |   61 ++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 56 deletions(-)
 create mode 100644 include/linux/netfilter/nfnetlink_compat.h

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index b64454c..4a4efaf 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -1,5 +1,5 @@
-#ifndef _NFNETLINK_H
-#define _NFNETLINK_H
+#ifndef _UAPI_NFNETLINK_H
+#define _UAPI_NFNETLINK_H
 #include <linux/types.h>
 #include <linux/netfilter/nfnetlink_compat.h>
 
@@ -49,46 +49,8 @@ struct nfgenmsg {
 #define NFNL_SUBSYS_OSF			5
 #define NFNL_SUBSYS_IPSET		6
 #define NFNL_SUBSYS_ACCT		7
-#define NFNL_SUBSYS_COUNT		8
+#define NFNL_SUBSYS_CTNETLINK_TIMEOUT	8
+#define NFNL_SUBSYS_CTHELPER		9
+#define NFNL_SUBSYS_COUNT		10
 
-#ifdef __KERNEL__
-
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
+#endif /* _UAPI_NFNETLINK_H */
diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index 7c4279b..c7b6269 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -1,5 +1,5 @@
-#ifndef _NFNL_ACCT_H_
-#define _NFNL_ACCT_H_
+#ifndef _UAPI_NFNL_ACCT_H_
+#define _UAPI_NFNL_ACCT_H_
 
 #ifndef NFACCT_NAME_MAX
 #define NFACCT_NAME_MAX		32
@@ -23,14 +23,5 @@ enum nfnl_acct_type {
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
 
-#ifdef __KERNEL__
 
-struct nf_acct;
-
-extern struct nf_acct *nfnl_acct_find_get(const char *filter_name);
-extern void nfnl_acct_put(struct nf_acct *acct);
-extern void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct);
-
-#endif /* __KERNEL__ */
-
-#endif /* _NFNL_ACCT_H */
+#endif /* _UAPI_NFNL_ACCT_H_ */
diff --git a/include/linux/netfilter/nfnetlink_compat.h b/include/linux/netfilter/nfnetlink_compat.h
new file mode 100644
index 0000000..74b9e55
--- /dev/null
+++ b/include/linux/netfilter/nfnetlink_compat.h
@@ -0,0 +1,61 @@
+#ifndef _NFNETLINK_COMPAT_H
+#define _NFNETLINK_COMPAT_H
+
+#include <linux/types.h>
+
+/* Old nfnetlink macros for userspace */
+
+/* nfnetlink groups: Up to 32 maximum */
+#define NF_NETLINK_CONNTRACK_NEW 		0x00000001
+#define NF_NETLINK_CONNTRACK_UPDATE		0x00000002
+#define NF_NETLINK_CONNTRACK_DESTROY		0x00000004
+#define NF_NETLINK_CONNTRACK_EXP_NEW		0x00000008
+#define NF_NETLINK_CONNTRACK_EXP_UPDATE		0x00000010
+#define NF_NETLINK_CONNTRACK_EXP_DESTROY	0x00000020
+
+/* Generic structure for encapsulation optional netfilter information.
+ * It is reminiscent of sockaddr, but with sa_family replaced
+ * with attribute type.
+ * ! This should someday be put somewhere generic as now rtnetlink and
+ * ! nfnetlink use the same attributes methods. - J. Schulist.
+ */
+
+struct nfattr {
+	__u16 nfa_len;
+	__u16 nfa_type;	/* we use 15 bits for the type, and the highest
+				 * bit to indicate whether the payload is nested */
+};
+
+/* FIXME: Apart from NFNL_NFA_NESTED shamelessly copy and pasted from
+ * rtnetlink.h, it's time to put this in a generic file */
+
+#define NFNL_NFA_NEST	0x8000
+#define NFA_TYPE(attr) 	((attr)->nfa_type & 0x7fff)
+
+#define NFA_ALIGNTO     4
+#define NFA_ALIGN(len)	(((len) + NFA_ALIGNTO - 1) & ~(NFA_ALIGNTO - 1))
+#define NFA_OK(nfa,len)	((len) > 0 && (nfa)->nfa_len >= sizeof(struct nfattr) \
+	&& (nfa)->nfa_len <= (len))
+#define NFA_NEXT(nfa,attrlen)	((attrlen) -= NFA_ALIGN((nfa)->nfa_len), \
+	(struct nfattr *)(((char *)(nfa)) + NFA_ALIGN((nfa)->nfa_len)))
+#define NFA_LENGTH(len)	(NFA_ALIGN(sizeof(struct nfattr)) + (len))
+#define NFA_SPACE(len)	NFA_ALIGN(NFA_LENGTH(len))
+#define NFA_DATA(nfa)   ((void *)(((char *)(nfa)) + NFA_LENGTH(0)))
+#define NFA_PAYLOAD(nfa) ((int)((nfa)->nfa_len) - NFA_LENGTH(0))
+#define NFA_NEST(skb, type) \
+({	struct nfattr *__start = (struct nfattr *)skb_tail_pointer(skb); \
+	NFA_PUT(skb, (NFNL_NFA_NEST | type), 0, NULL); \
+	__start;  })
+#define NFA_NEST_END(skb, start) \
+({      (start)->nfa_len = skb_tail_pointer(skb) - (unsigned char *)(start); \
+        (skb)->len; })
+#define NFA_NEST_CANCEL(skb, start) \
+({      if (start) \
+                skb_trim(skb, (unsigned char *) (start) - (skb)->data); \
+        -1; })
+
+#define NFM_NFA(n)      ((struct nfattr *)(((char *)(n)) \
+        + NLMSG_ALIGN(sizeof(struct nfgenmsg))))
+#define NFM_PAYLOAD(n)  NLMSG_PAYLOAD(n, sizeof(struct nfgenmsg))
+
+#endif /* _NFNETLINK_COMPAT_H */
-- 
1.7.10.4

