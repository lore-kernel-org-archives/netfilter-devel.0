From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/6] netfilter: get rid of the grossness in netfilter.h
Date: Tue,  3 Nov 2009 19:04:39 +0100
Message-ID: <1257271483-26772-4-git-send-email-jengelh@medozas.de>
References: <1257271483-26772-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43232 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbZKCSEn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:04:43 -0500
In-Reply-To: <1257271483-26772-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

GCC is now smart enough to follow the inline trail correctly.
vmlinux size remain the same.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter.h |   45 ++++++++++++++++++++++++++++-----------------
 1 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index d02dc03..bea0e0c 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -196,25 +196,36 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
    coders :)
 */
 
-/* This is gross, but inline doesn't cut it for avoiding the function
-   call in fast path: gcc doesn't inline (needs value tracking?). --RR */
-
-/* HX: It's slightly less gross now. */
-
-#define NF_HOOK_THRESH(pf, hook, skb, indev, outdev, okfn, thresh)	       \
-({int __ret;								       \
-if ((__ret=nf_hook_thresh(pf, hook, (skb), indev, outdev, okfn, thresh)) == 1)\
-	__ret = (okfn)(skb);						       \
-__ret;})
+static inline int
+NF_HOOK_THRESH(uint8_t pf, unsigned int hook, struct sk_buff *skb,
+	       struct net_device *in, struct net_device *out,
+	       int (*okfn)(struct sk_buff *), int thresh)
+{
+	int ret = nf_hook_thresh(pf, hook, skb, in, out, okfn, thresh);
+	if (ret == 1)
+		ret = okfn(skb);
+	return ret;
+}
 
-#define NF_HOOK_COND(pf, hook, skb, indev, outdev, okfn, cond)		       \
-({int __ret;								       \
-if ((cond) || (__ret = nf_hook_thresh(pf, hook, (skb), indev, outdev, okfn, INT_MIN)) == 1)\
-	__ret = (okfn)(skb);						       \
-__ret;})
+static inline int
+NF_HOOK_COND(uint8_t pf, unsigned int hook, struct sk_buff *skb,
+	     struct net_device *in, struct net_device *out,
+	     int (*okfn)(struct sk_buff *), bool cond)
+{
+	int ret = 1;
+	if (cond ||
+	    (ret = nf_hook_thresh(pf, hook, skb, in, out, okfn, INT_MIN) == 1))
+		ret = okfn(skb);
+	return ret;
+}
 
-#define NF_HOOK(pf, hook, skb, indev, outdev, okfn) \
-	NF_HOOK_THRESH(pf, hook, skb, indev, outdev, okfn, INT_MIN)
+static inline int
+NF_HOOK(uint8_t pf, unsigned int hook, struct sk_buff *skb,
+	struct net_device *in, struct net_device *out,
+	int (*okfn)(struct sk_buff *))
+{
+	return NF_HOOK_THRESH(pf, hook, skb, in, out, okfn, INT_MIN);
+}
 
 /* Call setsockopt() */
 int nf_setsockopt(struct sock *sk, u_int8_t pf, int optval, char __user *opt,
-- 
1.6.5.2

