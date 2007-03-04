From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/10]: nfnetlink_log: fix module reference counting
Date: Sun,  4 Mar 2007 21:20:08 +0100 (MET)
Message-ID: <20070304201916.28582.84106.sendpatchset@localhost.localdomain>
References: <20070304201906.28582.51903.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070304201906.28582.51903.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: fix module reference counting

Count module references correctly: after instance_destroy() there
might be timer pending and holding a reference for this netlink instance.

Based on patch by Michal Miroslaw <mirq-linux@rere.qmqm.pl>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3aed666579e96dfe23eb1988faf4af09c33358bc
tree ebfeba440d7599dea20c6a35a4a6d840dfe06ff3
parent 79fb63ea8565212c9e8fde1e18a5598b438ced08
author Patrick McHardy <kaber@trash.net> Fri, 02 Mar 2007 13:21:31 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 02 Mar 2007 13:21:31 +0100

 net/netfilter/nfnetlink_log.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index b669db5..d0af8bc 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -133,6 +133,7 @@ instance_put(struct nfulnl_instance *ins
 	if (inst && atomic_dec_and_test(&inst->use)) {
 		UDEBUG("kfree(inst=%p)\n", inst);
 		kfree(inst);
+		module_put(THIS_MODULE);
 	}
 }
 
@@ -228,8 +229,6 @@ _instance_destroy2(struct nfulnl_instanc
 
 	/* and finally put the refcount */
 	instance_put(inst);
-
-	module_put(THIS_MODULE);
 }
 
 static inline void
