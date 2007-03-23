From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/12]: nfnetlink_log: remove conditional locking
Date: Fri, 23 Mar 2007 15:05:10 +0100 (MET)
Message-ID: <20070323140444.22987.44402.sendpatchset@localhost.localdomain>
References: <20070323140433.22987.44867.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070323140433.22987.44867.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: remove conditional locking

This is gross, have the wrapper function take the lock.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6f67806947ea58fd8bdf2b44dd748bb3fb8752d7
tree bc21f4b37cc3170aaf5b8130af193c643d367c7b
parent d5e28a22dfd6b5a6b2d80565cb0347b093a1a85b
author Patrick McHardy <kaber@trash.net> Thu, 22 Mar 2007 23:02:52 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 23 Mar 2007 11:00:22 +0100

 net/netfilter/nfnetlink_log.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 34de3d8..0ae0656 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -195,20 +195,14 @@ out_unlock:
 static int __nfulnl_send(struct nfulnl_instance *inst);
 
 static void
-_instance_destroy2(struct nfulnl_instance *inst, int lock)
+__instance_destroy(struct nfulnl_instance *inst)
 {
 	/* first pull it out of the global list */
-	if (lock)
-		write_lock_bh(&instances_lock);
-
 	UDEBUG("removing instance %p (queuenum=%u) from hash\n",
 		inst, inst->group_num);
 
 	hlist_del(&inst->hlist);
 
-	if (lock)
-		write_unlock_bh(&instances_lock);
-
 	/* then flush all pending packets from skb */
 
 	spin_lock_bh(&inst->lock);
@@ -230,15 +224,11 @@ _instance_destroy2(struct nfulnl_instance *inst, int lock)
 }
 
 static inline void
-__instance_destroy(struct nfulnl_instance *inst)
-{
-	_instance_destroy2(inst, 0);
-}
-
-static inline void
 instance_destroy(struct nfulnl_instance *inst)
 {
-	_instance_destroy2(inst, 1);
+	write_lock_bh(&instances_lock);
+	__instance_destroy(inst);
+	write_unlock_bh(&instances_lock);
 }
 
 static int
