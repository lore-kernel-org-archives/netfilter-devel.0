From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 1/9] netfilter: ingress: don't use nf_hook_list_active
Date: Fri, 23 Oct 2015 12:43:18 +0200
Message-ID: <1445597006-11264-2-git-send-email-fw@strlen.de>
References: <1445597006-11264-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44999 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027AbbJWKnb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Oct 2015 06:43:31 -0400
In-Reply-To: <1445597006-11264-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_hook_list_active() always returns true once at least one device has
NF_INGRESS hook enabled.

Thus, don't use this function. Instead, inverse the test and use the static
key to elide list_empty test if no NF_INGRESS hooks are active.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 no changes since v1.
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

