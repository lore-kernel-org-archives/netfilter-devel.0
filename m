From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 029/103] netfilter: get rid of the grossness in netfilter.h
Date: Tue,  4 Aug 2009 09:25:13 +0200
Message-ID: <1249370787-17583-30-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50626 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548AbZHDH1E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:04 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

GCC is now smart enough to follow the inline trail correctly. vmlinux
size remain the same.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter.h |   42 +++++++++++++++++++++++++-----------------
 1 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 9a5383c..02bd472 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -196,25 +196,33 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
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
+static inline int NF_HOOK_THRESH(uint8_t pf, unsigned int hook,
+    struct sk_buff *skb, struct net_device *in, struct net_device *out,
+    int (*okfn)(struct sk_buff *), int thresh)
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
+static inline int NF_HOOK_COND(uint8_t pf, unsigned int hook,
+    struct sk_buff *skb, struct net_device *in, struct net_device *out,
+    int (*okfn)(struct sk_buff *), bool cond)
+{
+	int ret = 1;
+	if (cond ||
+	    (ret = nf_hook_thresh(pf, hook, skb, in, out, okfn, INT_MIN) == 1))
+		ret = okfn(skb);
+	return ret;
+}
 
-#define NF_HOOK(pf, hook, skb, indev, outdev, okfn) \
-	NF_HOOK_THRESH(pf, hook, skb, indev, outdev, okfn, INT_MIN)
+static inline int NF_HOOK(uint8_t pf, unsigned int hook, struct sk_buff *skb,
+    struct net_device *in, struct net_device *out,
+    int (*okfn)(struct sk_buff *))
+{
+	return NF_HOOK_THRESH(pf, hook, skb, in, out, okfn, INT_MIN);
+}
 
 /* Call setsockopt() */
 int nf_setsockopt(struct sock *sk, u_int8_t pf, int optval, char __user *opt,
-- 
1.6.3.3

