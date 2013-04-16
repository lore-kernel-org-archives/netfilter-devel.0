From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/5] netfilter: nf_queue: move device refcount bump to extra function
Date: Tue, 16 Apr 2013 17:32:04 +0200
Message-ID: <1366126328-25874-2-git-send-email-fw@strlen.de>
References: <1366126328-25874-1-git-send-email-fw@strlen.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41718 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757381Ab3DPPaE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:30:04 -0400
In-Reply-To: <1366126328-25874-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

required by future patch that will need to duplicate the
nf_queue_entry, bumping refcounts of the copy.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_queue.c |   49 ++++++++++++++++++++++++++-------------------
 1 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index d812c12..40a5001 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -61,6 +61,33 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 	module_put(entry->elem->owner);
 }
 
+/* Bump dev refs so they don't vanish while packet is out */
+static bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
+{
+	if (!try_module_get(entry->elem->owner))
+		return false;
+
+	if (entry->indev)
+		dev_hold(entry->indev);
+	if (entry->outdev)
+		dev_hold(entry->outdev);
+#ifdef CONFIG_BRIDGE_NETFILTER
+	if (entry->skb->nf_bridge) {
+		struct nf_bridge_info *nf_bridge = entry->skb->nf_bridge;
+		struct net_device *physdev;
+
+		physdev = nf_bridge->physindev;
+		if (physdev)
+			dev_hold(physdev);
+		physdev = nf_bridge->physoutdev;
+		if (physdev)
+			dev_hold(physdev);
+	}
+#endif
+
+	return true;
+}
+
 /*
  * Any packet that leaves via this function must come back
  * through nf_reinject().
@@ -75,10 +102,6 @@ static int __nf_queue(struct sk_buff *skb,
 {
 	int status = -ENOENT;
 	struct nf_queue_entry *entry = NULL;
-#ifdef CONFIG_BRIDGE_NETFILTER
-	struct net_device *physindev;
-	struct net_device *physoutdev;
-#endif
 	const struct nf_afinfo *afinfo;
 	const struct nf_queue_handler *qh;
 
@@ -111,26 +134,10 @@ static int __nf_queue(struct sk_buff *skb,
 		.okfn	= okfn,
 	};
 
-	/* If it's going away, ignore hook. */
-	if (!try_module_get(entry->elem->owner)) {
+	if (!nf_queue_entry_get_refs(entry)) {
 		status = -ECANCELED;
 		goto err_unlock;
 	}
-	/* Bump dev refs so they don't vanish while packet is out */
-	if (indev)
-		dev_hold(indev);
-	if (outdev)
-		dev_hold(outdev);
-#ifdef CONFIG_BRIDGE_NETFILTER
-	if (skb->nf_bridge) {
-		physindev = skb->nf_bridge->physindev;
-		if (physindev)
-			dev_hold(physindev);
-		physoutdev = skb->nf_bridge->physoutdev;
-		if (physoutdev)
-			dev_hold(physoutdev);
-	}
-#endif
 	skb_dst_force(skb);
 	afinfo->saveroute(skb, entry);
 	status = qh->outfn(entry, queuenum);
-- 
1.7.8.6

