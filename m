From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 25/52] netfilter: core: add nf_remove_net_hook
Date: Mon,  8 Jan 2018 21:19:33 +0100
Message-ID: <20180108202000.12989-26-pablo@netfilter.org>
References: <20180108202000.12989-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180108202000.12989-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Just a cleanup, __nf_unregister_net_hook() is used by a follow up patch
when handling NFPROTO_INET as a real family from the core.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 3508a5c8edbb..9153b6e03f6b 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -360,7 +360,7 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 EXPORT_SYMBOL(nf_register_net_hook);
 
 /*
- * __nf_unregister_net_hook - remove a hook from blob
+ * nf_remove_net_hook - remove a hook from blob
  *
  * @oldp: current address of hook blob
  * @unreg: hook to unregister
@@ -368,8 +368,8 @@ EXPORT_SYMBOL(nf_register_net_hook);
  * This cannot fail, hook unregistration must always succeed.
  * Therefore replace the to-be-removed hook with a dummy hook.
  */
-static void __nf_unregister_net_hook(struct nf_hook_entries *old,
-				     const struct nf_hook_ops *unreg)
+static void nf_remove_net_hook(struct nf_hook_entries *old,
+			       const struct nf_hook_ops *unreg)
 {
 	struct nf_hook_ops **orig_ops;
 	bool found = false;
@@ -415,7 +415,7 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 		return;
 	}
 
-	__nf_unregister_net_hook(p, reg);
+	nf_remove_net_hook(p, reg);
 
 	p = __nf_hook_entries_try_shrink(pp);
 	mutex_unlock(&nf_hook_mutex);
-- 
2.11.0
