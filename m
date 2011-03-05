From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] include: use sanitized header from headers_install
Date: Sat,  5 Mar 2011 13:31:30 +0100
Message-ID: <1299328292-4469-3-git-send-email-jengelh@medozas.de>
References: <1299328292-4469-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58543 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab1CEMbg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Mar 2011 07:31:36 -0500
In-Reply-To: <1299328292-4469-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netlink.h |  128 +----------------------------------------------
 1 files changed, 1 insertions(+), 127 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 1235669..f55ed8c 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -70,7 +70,7 @@ struct nlmsghdr {
    Check		NLM_F_EXCL
  */
 
-#define NLMSG_ALIGNTO	4
+#define NLMSG_ALIGNTO	4U
 #define NLMSG_ALIGN(len) ( ((len)+NLMSG_ALIGNTO-1) & ~(NLMSG_ALIGNTO-1) )
 #define NLMSG_HDRLEN	 ((int) NLMSG_ALIGN(sizeof(struct nlmsghdr)))
 #define NLMSG_LENGTH(len) ((len)+NLMSG_ALIGN(NLMSG_HDRLEN))
@@ -144,131 +144,5 @@ struct nlattr {
 #define NLA_ALIGN(len)		(((len) + NLA_ALIGNTO - 1) & ~(NLA_ALIGNTO - 1))
 #define NLA_HDRLEN		((int) NLA_ALIGN(sizeof(struct nlattr)))
 
-#ifdef __KERNEL__
-
-#include <linux/capability.h>
-#include <linux/skbuff.h>
-
-struct net;
-
-static inline struct nlmsghdr *nlmsg_hdr(const struct sk_buff *skb)
-{
-	return (struct nlmsghdr *)skb->data;
-}
-
-struct netlink_skb_parms {
-	struct ucred		creds;		/* Skb credentials	*/
-	__u32			pid;
-	__u32			dst_group;
-	kernel_cap_t		eff_cap;
-	__u32			loginuid;	/* Login (audit) uid */
-	__u32			sessionid;	/* Session id (audit) */
-	__u32			sid;		/* SELinux security id */
-};
-
-#define NETLINK_CB(skb)		(*(struct netlink_skb_parms*)&((skb)->cb))
-#define NETLINK_CREDS(skb)	(&NETLINK_CB((skb)).creds)
-
-
-extern void netlink_table_grab(void);
-extern void netlink_table_ungrab(void);
-
-extern struct sock *netlink_kernel_create(struct net *net,
-					  int unit,unsigned int groups,
-					  void (*input)(struct sk_buff *skb),
-					  struct mutex *cb_mutex,
-					  struct module *module);
-extern void netlink_kernel_release(struct sock *sk);
-extern int __netlink_change_ngroups(struct sock *sk, unsigned int groups);
-extern int netlink_change_ngroups(struct sock *sk, unsigned int groups);
-extern void __netlink_clear_multicast_users(struct sock *sk, unsigned int group);
-extern void netlink_clear_multicast_users(struct sock *sk, unsigned int group);
-extern void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err);
-extern int netlink_has_listeners(struct sock *sk, unsigned int group);
-extern int netlink_unicast(struct sock *ssk, struct sk_buff *skb, __u32 pid, int nonblock);
-extern int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, __u32 pid,
-			     __u32 group, gfp_t allocation);
-extern int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
-	__u32 pid, __u32 group, gfp_t allocation,
-	int (*filter)(struct sock *dsk, struct sk_buff *skb, void *data),
-	void *filter_data);
-extern int netlink_set_err(struct sock *ssk, __u32 pid, __u32 group, int code);
-extern int netlink_register_notifier(struct notifier_block *nb);
-extern int netlink_unregister_notifier(struct notifier_block *nb);
-
-/* finegrained unicast helpers: */
-struct sock *netlink_getsockbyfilp(struct file *filp);
-int netlink_attachskb(struct sock *sk, struct sk_buff *skb,
-		      long *timeo, struct sock *ssk);
-void netlink_detachskb(struct sock *sk, struct sk_buff *skb);
-int netlink_sendskb(struct sock *sk, struct sk_buff *skb);
-
-/*
- *	skb should fit one page. This choice is good for headerless malloc.
- *	But we should limit to 8K so that userspace does not have to
- *	use enormous buffer sizes on recvmsg() calls just to avoid
- *	MSG_TRUNC when PAGE_SIZE is very large.
- */
-#if PAGE_SIZE < 8192UL
-#define NLMSG_GOODSIZE	SKB_WITH_OVERHEAD(PAGE_SIZE)
-#else
-#define NLMSG_GOODSIZE	SKB_WITH_OVERHEAD(8192UL)
-#endif
-
-#define NLMSG_DEFAULT_SIZE (NLMSG_GOODSIZE - NLMSG_HDRLEN)
-
-
-struct netlink_callback {
-	struct sk_buff		*skb;
-	const struct nlmsghdr	*nlh;
-	int			(*dump)(struct sk_buff * skb,
-					struct netlink_callback *cb);
-	int			(*done)(struct netlink_callback *cb);
-	int			family;
-	long			args[6];
-};
-
-struct netlink_notify {
-	struct net *net;
-	int pid;
-	int protocol;
-};
-
-static __inline__ struct nlmsghdr *
-__nlmsg_put(struct sk_buff *skb, u32 pid, u32 seq, int type, int len, int flags)
-{
-	struct nlmsghdr *nlh;
-	int size = NLMSG_LENGTH(len);
-
-	nlh = (struct nlmsghdr*)skb_put(skb, NLMSG_ALIGN(size));
-	nlh->nlmsg_type = type;
-	nlh->nlmsg_len = size;
-	nlh->nlmsg_flags = flags;
-	nlh->nlmsg_pid = pid;
-	nlh->nlmsg_seq = seq;
-	if (!__builtin_constant_p(size) || NLMSG_ALIGN(size) - size != 0)
-		memset(NLMSG_DATA(nlh) + len, 0, NLMSG_ALIGN(size) - size);
-	return nlh;
-}
-
-#define NLMSG_NEW(skb, pid, seq, type, len, flags) \
-({	if (unlikely(skb_tailroom(skb) < (int)NLMSG_SPACE(len))) \
-		goto nlmsg_failure; \
-	__nlmsg_put(skb, pid, seq, type, len, flags); })
-
-#define NLMSG_PUT(skb, pid, seq, type, len) \
-	NLMSG_NEW(skb, pid, seq, type, len, 0)
-
-extern int netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
-			      const struct nlmsghdr *nlh,
-			      int (*dump)(struct sk_buff *skb, struct netlink_callback*),
-			      int (*done)(struct netlink_callback*));
-
-
-#define NL_NONROOT_RECV 0x1
-#define NL_NONROOT_SEND 0x2
-extern void netlink_set_nonroot(int protocol, unsigned flag);
-
-#endif /* __KERNEL__ */
 
 #endif	/* __LINUX_NETLINK_H */
-- 
1.7.1

