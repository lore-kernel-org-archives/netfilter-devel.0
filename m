From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 24/49]: nf_queue: minor cleanup
Date: Tue,  4 Dec 2007 13:02:29 +0100 (MET)
Message-ID: <20071204120229.2442.92259.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62173 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbXLDMCa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:30 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_queue: minor cleanup

Clean up

if (x) y;

constructs. We've got nothing to hide :)

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 327c86b66756bd289a3ddde5f390411406534acf
tree 44538fbe157fca4f26e9b8fe1d97c438b5833b9b
parent eb9d6d08051c003ea481be88c27526d3cccb4507
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:20 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:30:33 +0100

 net/netfilter/nf_queue.c |   31 ++++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 0cef143..81d010a 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -138,15 +138,18 @@ static int __nf_queue(struct sk_buff *skb,
 	}
 
 	/* Bump dev refs so they don't vanish while packet is out */
-	if (indev) dev_hold(indev);
-	if (outdev) dev_hold(outdev);
-
+	if (indev)
+		dev_hold(indev);
+	if (outdev)
+		dev_hold(outdev);
 #ifdef CONFIG_BRIDGE_NETFILTER
 	if (skb->nf_bridge) {
 		physindev = skb->nf_bridge->physindev;
-		if (physindev) dev_hold(physindev);
+		if (physindev)
+			dev_hold(physindev);
 		physoutdev = skb->nf_bridge->physoutdev;
-		if (physoutdev) dev_hold(physoutdev);
+		if (physoutdev)
+			dev_hold(physoutdev);
 	}
 #endif
 	afinfo->saveroute(skb, info);
@@ -156,11 +159,15 @@ static int __nf_queue(struct sk_buff *skb,
 
 	if (status < 0) {
 		/* James M doesn't say fuck enough. */
-		if (indev) dev_put(indev);
-		if (outdev) dev_put(outdev);
+		if (indev)
+			dev_put(indev);
+		if (outdev)
+			dev_put(outdev);
 #ifdef CONFIG_BRIDGE_NETFILTER
-		if (physindev) dev_put(physindev);
-		if (physoutdev) dev_put(physoutdev);
+		if (physindev)
+			dev_put(physindev);
+		if (physoutdev)
+			dev_put(physoutdev);
 #endif
 		module_put(info->elem->owner);
 		kfree(info);
@@ -222,8 +229,10 @@ void nf_reinject(struct sk_buff *skb, struct nf_info *info,
 	rcu_read_lock();
 
 	/* Release those devices we held, or Alexey will kill me. */
-	if (info->indev) dev_put(info->indev);
-	if (info->outdev) dev_put(info->outdev);
+	if (info->indev)
+		dev_put(info->indev);
+	if (info->outdev)
+		dev_put(info->outdev);
 #ifdef CONFIG_BRIDGE_NETFILTER
 	if (skb->nf_bridge) {
 		if (skb->nf_bridge->physindev)
