From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/13]: nfnetlink_log: fix module reference counting
Date: Wed,  7 Mar 2007 22:34:37 +0100 (MET)
Message-ID: <20070307213358.22306.28903.sendpatchset@localhost.localdomain>
References: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
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
commit 59dc071181765f340b028e07594e04c4bb26a040
tree 12c2b836df299a4551c5c78bee94504ee7c806f2
parent 5e1bb4837b82a6d474ee123030d90de7d51fb2cc
author Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:31:55 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:31:55 +0100

 net/netfilter/nfnetlink_log.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 2e773c5..a765902 100644
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
