From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] nf_queue: Put devs after calling handler
Date: Fri, 20 Nov 2009 10:27:44 +0800
Message-ID: <4B05FEA0.402@gmail.com>
Reply-To: xiaosuo@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, xiaosuo <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:42094 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132AbZKTC1u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Nov 2009 21:27:50 -0500
Received: by yxe17 with SMTP id 17so2598996yxe.33
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2009 18:27:56 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Put devs after calling handler.

If we put the devs before calling handler, the devs may disappear when the handler is running.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 include/net/netfilter/nf_queue.h |    4 ++++
 net/netfilter/nf_queue.c         |   36 +++++++++++++++---------------------
 2 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 252fd10..6886a2a 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -12,6 +12,10 @@ struct nf_queue_entry {
 	unsigned int		hook;
 	struct net_device	*indev;
 	struct net_device	*outdev;
+#ifdef CONFIG_BRIDGE_NETFILTER
+	struct net_device	*physindev;
+	struct net_device	*physoutdev;
+#endif
 	int			(*okfn)(struct sk_buff *);
 };
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 3a6fd77..f65d3b0 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -88,14 +88,10 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 	if (entry->outdev)
 		dev_put(entry->outdev);
 #ifdef CONFIG_BRIDGE_NETFILTER
-	if (entry->skb->nf_bridge) {
-		struct nf_bridge_info *nf_bridge = entry->skb->nf_bridge;
-
-		if (nf_bridge->physindev)
-			dev_put(nf_bridge->physindev);
-		if (nf_bridge->physoutdev)
-			dev_put(nf_bridge->physoutdev);
-	}
+	if (entry->physindev)
+		dev_put(entry->physindev);
+	if (entry->physoutdev)
+		dev_put(entry->physoutdev);
 #endif
 	/* Drop reference to owner of hook which queued us. */
 	module_put(entry->elem->owner);
@@ -115,10 +111,6 @@ static int __nf_queue(struct sk_buff *skb,
 {
 	int status;
 	struct nf_queue_entry *entry = NULL;
-#ifdef CONFIG_BRIDGE_NETFILTER
-	struct net_device *physindev;
-	struct net_device *physoutdev;
-#endif
 	const struct nf_afinfo *afinfo;
 	const struct nf_queue_handler *qh;
 
@@ -161,12 +153,15 @@ static int __nf_queue(struct sk_buff *skb,
 		dev_hold(outdev);
 #ifdef CONFIG_BRIDGE_NETFILTER
 	if (skb->nf_bridge) {
-		physindev = skb->nf_bridge->physindev;
-		if (physindev)
-			dev_hold(physindev);
-		physoutdev = skb->nf_bridge->physoutdev;
-		if (physoutdev)
-			dev_hold(physoutdev);
+		entry->physindev = skb->nf_bridge->physindev;
+		if (entry->physindev)
+			dev_hold(entry->physindev);
+		entry->physoutdev = skb->nf_bridge->physoutdev;
+		if (entry->physoutdev)
+			dev_hold(entry->physoutdev);
+	} else {
+		entry->physindev = NULL;
+		entry->physoutdev = NULL;
 	}
 #endif
 	afinfo->saveroute(skb, entry);
@@ -236,9 +231,6 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	const struct nf_afinfo *afinfo;
 
 	rcu_read_lock();
-
-	nf_queue_entry_release_refs(entry);
-
 	/* Continue traversal iff userspace said ok... */
 	if (verdict == NF_REPEAT) {
 		elem = elem->prev;
@@ -277,6 +269,8 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 		kfree_skb(skb);
 	}
 	rcu_read_unlock();
+
+	nf_queue_entry_release_refs(entry);
 	kfree(entry);
 	return;
 }

