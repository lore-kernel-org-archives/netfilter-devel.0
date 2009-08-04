From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 028/103] netfilter: reduce NF_HOOK by one argument
Date: Tue,  4 Aug 2009 09:25:12 +0200
Message-ID: <1249370787-17583-29-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50624 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539AbZHDH1D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:03 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

No changes in vmlinux filesize.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter.h |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 48cfe51..9a5383c 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -163,11 +163,8 @@ static inline int nf_hook_thresh(u_int8_t pf, unsigned int hook,
 				 struct sk_buff *skb,
 				 struct net_device *indev,
 				 struct net_device *outdev,
-				 int (*okfn)(struct sk_buff *), int thresh,
-				 int cond)
+				 int (*okfn)(struct sk_buff *), int thresh)
 {
-	if (!cond)
-		return 1;
 #ifndef CONFIG_NETFILTER_DEBUG
 	if (list_empty(&nf_hooks[pf][hook]))
 		return 1;
@@ -179,7 +176,7 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
 			  struct net_device *indev, struct net_device *outdev,
 			  int (*okfn)(struct sk_buff *))
 {
-	return nf_hook_thresh(pf, hook, skb, indev, outdev, okfn, INT_MIN, 1);
+	return nf_hook_thresh(pf, hook, skb, indev, outdev, okfn, INT_MIN);
 }
                    
 /* Activate hook; either okfn or kfree_skb called, unless a hook
@@ -206,13 +203,13 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
 
 #define NF_HOOK_THRESH(pf, hook, skb, indev, outdev, okfn, thresh)	       \
 ({int __ret;								       \
-if ((__ret=nf_hook_thresh(pf, hook, (skb), indev, outdev, okfn, thresh, 1)) == 1)\
+if ((__ret=nf_hook_thresh(pf, hook, (skb), indev, outdev, okfn, thresh)) == 1)\
 	__ret = (okfn)(skb);						       \
 __ret;})
 
 #define NF_HOOK_COND(pf, hook, skb, indev, outdev, okfn, cond)		       \
 ({int __ret;								       \
-if ((__ret=nf_hook_thresh(pf, hook, (skb), indev, outdev, okfn, INT_MIN, cond)) == 1)\
+if ((cond) || (__ret = nf_hook_thresh(pf, hook, (skb), indev, outdev, okfn, INT_MIN)) == 1)\
 	__ret = (okfn)(skb);						       \
 __ret;})
 
@@ -327,8 +324,7 @@ static inline int nf_hook_thresh(u_int8_t pf, unsigned int hook,
 				 struct sk_buff *skb,
 				 struct net_device *indev,
 				 struct net_device *outdev,
-				 int (*okfn)(struct sk_buff *), int thresh,
-				 int cond)
+				 int (*okfn)(struct sk_buff *), int thresh)
 {
 	return okfn(skb);
 }
-- 
1.6.3.3

