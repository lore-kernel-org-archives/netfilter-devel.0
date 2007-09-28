From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/19]: nfnetlink_log: kill duplicate code
Date: Fri, 28 Sep 2007 18:30:55 +0200 (MEST)
Message-ID: <20070928163055.8394.61117.sendpatchset@localhost.localdomain>
References: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55958 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbXI1Qa4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:30:56 -0400
In-Reply-To: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nfnetlink_log: kill duplicate code

Kill some cut'n'paste effect.
Just after __nfulnl_send() returning, inst->skb is always NULL.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7b32724f5d944727be7dcf23b50feb233d11be3f
tree 47f0e3720d7b26d4b6ead95aab155880e19e71de
parent b7ee1904c7e1e916c8a5f3cae94ef302ed59daf2
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Fri, 28 Sep 2007 18:09:17 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:17 +0200

 net/netfilter/nfnetlink_log.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index a90a26b..512741a 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -188,7 +188,7 @@ out_unlock:
 	return NULL;
 }
 
-static int __nfulnl_send(struct nfulnl_instance *inst);
+static void __nfulnl_flush(struct nfulnl_instance *inst);
 
 static void
 __instance_destroy(struct nfulnl_instance *inst)
@@ -202,17 +202,8 @@ __instance_destroy(struct nfulnl_instance *inst)
 	/* then flush all pending packets from skb */
 
 	spin_lock_bh(&inst->lock);
-	if (inst->skb) {
-		/* timer "holds" one reference (we have one more) */
-		if (del_timer(&inst->timer))
-			instance_put(inst);
-		if (inst->qlen)
-			__nfulnl_send(inst);
-		if (inst->skb) {
-			kfree_skb(inst->skb);
-			inst->skb = NULL;
-		}
-	}
+	if (inst->skb)
+		__nfulnl_flush(inst);
 	spin_unlock_bh(&inst->lock);
 
 	/* and finally put the refcount */
@@ -364,6 +355,16 @@ nlmsg_failure:
 	return status;
 }
 
+static void
+__nfulnl_flush(struct nfulnl_instance *inst)
+{
+	/* timer holds a reference */
+	if (del_timer(&inst->timer))
+		instance_put(inst);
+	if (inst->skb)
+		__nfulnl_send(inst);
+}
+
 static void nfulnl_timer(unsigned long data)
 {
 	struct nfulnl_instance *inst = (struct nfulnl_instance *)data;
@@ -650,10 +651,7 @@ nfulnl_log_packet(unsigned int pf,
 		 * enough room in the skb left. flush to userspace. */
 		UDEBUG("flushing old skb\n");
 
-		/* timer "holds" one reference (we have another one) */
-		if (del_timer(&inst->timer))
-			instance_put(inst);
-		__nfulnl_send(inst);
+		__nfulnl_flush(inst);
 	}
 
 	if (!inst->skb) {
