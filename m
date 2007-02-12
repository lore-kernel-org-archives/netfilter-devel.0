From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/22]: Switch nf_register_hook/nf_unregister_hook to
	mutex
Date: Mon, 12 Feb 2007 11:36:26 +0100 (MET)
Message-ID: <20070212103626.661.94543.sendpatchset@localhost.localdomain>
References: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Switch nf_register_hook/nf_unregister_hook to mutex

The spinlock is only used in process context (register/unregister)
since RCU is used for the nf_hook lists, switch to a mutex.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4694a2599998f08af77aa1a1ee2c6d6bc2020913
tree b5d2752f7e5f66afd4b7d4bcd2402f1e1c9bfae9
parent ccead672bf5800d7418940aea9c0e6a231bc1f09
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:36:19 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:36:19 +0100

 net/netfilter/core.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 716603f..f61e0c2 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -61,28 +61,31 @@ EXPORT_SYMBOL_GPL(nf_unregister_afinfo);
  * packets come back: if the hook is gone, the packet is discarded. */
 struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS] __read_mostly;
 EXPORT_SYMBOL(nf_hooks);
-static DEFINE_SPINLOCK(nf_hook_lock);
+static DEFINE_MUTEX(nf_hook_mutex);
 
 int nf_register_hook(struct nf_hook_ops *reg)
 {
 	struct list_head *i;
+	int err;
 
-	spin_lock_bh(&nf_hook_lock);
+	err = mutex_lock_interruptible(&nf_hook_mutex);
+	if (err < 0)
+		return err;
 	list_for_each(i, &nf_hooks[reg->pf][reg->hooknum]) {
 		if (reg->priority < ((struct nf_hook_ops *)i)->priority)
 			break;
 	}
 	list_add_rcu(&reg->list, i->prev);
-	spin_unlock_bh(&nf_hook_lock);
+	mutex_unlock(&nf_hook_mutex);
 	return 0;
 }
 EXPORT_SYMBOL(nf_register_hook);
 
 void nf_unregister_hook(struct nf_hook_ops *reg)
 {
-	spin_lock_bh(&nf_hook_lock);
+	mutex_lock(&nf_hook_mutex);
 	list_del_rcu(&reg->list);
-	spin_unlock_bh(&nf_hook_lock);
+	mutex_unlock(&nf_hook_mutex);
 
 	synchronize_net();
 }
