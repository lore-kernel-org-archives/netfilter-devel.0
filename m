From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next 1/8] netfilter: ingress: don't use nf_hook_list_active
Date: Fri,  2 Oct 2015 13:49:10 +0200
Message-ID: <1443786557-21315-2-git-send-email-fw@strlen.de>
References: <1443786557-21315-1-git-send-email-fw@strlen.de>
Cc: ebiederm@xmission.com, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50301 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425AbbJBLt1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Oct 2015 07:49:27 -0400
In-Reply-To: <1443786557-21315-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_hook_list_active() always returns true once at least one device has
NF_INGRESS hook enabled.

Thus, don't use this function. Instead, inverse the test and use the static
key to elide list_empty test if no NF_INGRESS hooks are active.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter_ingress.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter_ingress.h b/include/linux/netfilter_ingress.h
index 187feab..ba7ce88 100644
--- a/include/linux/netfilter_ingress.h
+++ b/include/linux/netfilter_ingress.h
@@ -5,10 +5,13 @@
 #include <linux/netdevice.h>
 
 #ifdef CONFIG_NETFILTER_INGRESS
-static inline int nf_hook_ingress_active(struct sk_buff *skb)
+static inline bool nf_hook_ingress_active(const struct sk_buff *skb)
 {
-	return nf_hook_list_active(&skb->dev->nf_hooks_ingress,
-				   NFPROTO_NETDEV, NF_NETDEV_INGRESS);
+#ifdef HAVE_JUMP_LABEL
+	if (!static_key_false(&nf_hooks_needed[NFPROTO_NETDEV][NF_NETDEV_INGRESS]))
+		return false;
+#endif
+	return !list_empty(&skb->dev->nf_hooks_ingress);
 }
 
 static inline int nf_hook_ingress(struct sk_buff *skb)
-- 
2.0.5

