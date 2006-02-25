From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/6]: nf_queue: fix rerouting after packet mangling
Date: Sat, 25 Feb 2006 14:18:11 +0100 (MET)
Message-ID: <20060225131630.7400.98595.sendpatchset@localhost.localdomain>
References: <20060225131547.7400.12127.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060225131547.7400.12127.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_queue: fix rerouting after packet mangling

Packets should be rerouted when they come back from userspace, not before.
Also move the queue_rerouters to RCU to avoid taking the queue_handler_lock
for each reinjected packet.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5409613c1733e5162fb884865637d1607afcfbc9
tree 81e984ae53bd364b368ed77278ffda87202d20fc
parent 7ef7e9ed0e79dcb31560fc7d669a23ca2f230e09
author Patrick McHardy <kaber@trash.net> Sat, 25 Feb 2006 13:43:45 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 25 Feb 2006 13:43:45 +0100

 net/netfilter/nf_queue.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 1fc7152..c61f723 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -6,6 +6,7 @@
 #include <linux/skbuff.h>
 #include <linux/netfilter.h>
 #include <linux/seq_file.h>
+#include <linux/rcupdate.h>
 #include <net/protocol.h>
 
 #include "nf_internals.h"
@@ -64,7 +65,7 @@ int nf_register_queue_rerouter(int pf, s
 		return -EINVAL;
 
 	write_lock_bh(&queue_handler_lock);
-	queue_rerouter[pf] = rer;
+	rcu_assign_pointer(queue_rerouter[pf], rer);
 	write_unlock_bh(&queue_handler_lock);
 
 	return 0;
@@ -77,8 +78,9 @@ int nf_unregister_queue_rerouter(int pf)
 		return -EINVAL;
 
 	write_lock_bh(&queue_handler_lock);
-	queue_rerouter[pf] = NULL;
+	rcu_assign_pointer(queue_rerouter[pf], NULL);
 	write_unlock_bh(&queue_handler_lock);
+	synchronize_rcu();
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_unregister_queue_rerouter);
@@ -114,6 +116,7 @@ int nf_queue(struct sk_buff **skb, 
 	struct net_device *physindev = NULL;
 	struct net_device *physoutdev = NULL;
 #endif
+	struct nf_queue_rerouter *rerouter;
 
 	/* QUEUE == DROP if noone is waiting, to be safe. */
 	read_lock(&queue_handler_lock);
@@ -155,15 +158,13 @@ int nf_queue(struct sk_buff **skb, 
 		if (physoutdev) dev_hold(physoutdev);
 	}
 #endif
-	if (queue_rerouter[pf])
-		queue_rerouter[pf]->save(*skb, info);
+	rerouter = rcu_dereference(queue_rerouter[pf]);
+	if (rerouter)
+		rerouter->save(*skb, info);
 
 	status = queue_handler[pf]->outfn(*skb, info, queuenum,
 					  queue_handler[pf]->data);
 
-	if (status >= 0 && queue_rerouter[pf])
-		status = queue_rerouter[pf]->reroute(skb, info);
-
 	read_unlock(&queue_handler_lock);
 
 	if (status < 0) {
@@ -189,6 +190,7 @@ void nf_reinject(struct sk_buff *skb, st
 {
 	struct list_head *elem = &info->elem->list;
 	struct list_head *i;
+	struct nf_queue_rerouter *rerouter;
 
 	rcu_read_lock();
 
@@ -226,6 +228,12 @@ void nf_reinject(struct sk_buff *skb, st
 	}
 
 	if (verdict == NF_ACCEPT) {
+		rerouter = rcu_dereference(queue_rerouter[info->pf]);
+		if (rerouter && rerouter->reroute(&skb, info) < 0)
+			verdict = NF_DROP;
+	}
+
+	if (verdict == NF_ACCEPT) {
 	next_hook:
 		verdict = nf_iterate(&nf_hooks[info->pf][info->hook],
 				     &skb, info->hook, 
