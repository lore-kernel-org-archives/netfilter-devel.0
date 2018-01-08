From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 27/52] netfilter: core: pass family as parameter to nf_remove_net_hook()
Date: Mon,  8 Jan 2018 21:19:35 +0100
Message-ID: <20180108202000.12989-28-pablo@netfilter.org>
References: <20180108202000.12989-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180108202000.12989-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

So static_key_slow_dec applies to the family behind NFPROTO_INET.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index bcbaa78ec374..6c9874c8b10a 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -371,7 +371,7 @@ EXPORT_SYMBOL(nf_register_net_hook);
  * Therefore replace the to-be-removed hook with a dummy hook.
  */
 static void nf_remove_net_hook(struct nf_hook_entries *old,
-			       const struct nf_hook_ops *unreg)
+			       const struct nf_hook_ops *unreg, int pf)
 {
 	struct nf_hook_ops **orig_ops;
 	bool found = false;
@@ -389,14 +389,14 @@ static void nf_remove_net_hook(struct nf_hook_entries *old,
 
 	if (found) {
 #ifdef CONFIG_NETFILTER_INGRESS
-		if (unreg->pf == NFPROTO_NETDEV && unreg->hooknum == NF_NETDEV_INGRESS)
+		if (pf == NFPROTO_NETDEV && unreg->hooknum == NF_NETDEV_INGRESS)
 			net_dec_ingress_queue();
 #endif
 #ifdef HAVE_JUMP_LABEL
-		static_key_slow_dec(&nf_hooks_needed[unreg->pf][unreg->hooknum]);
+		static_key_slow_dec(&nf_hooks_needed[pf][unreg->hooknum]);
 #endif
 	} else {
-		WARN_ONCE(1, "hook not found, pf %d num %d", unreg->pf, unreg->hooknum);
+		WARN_ONCE(1, "hook not found, pf %d num %d", pf, unreg->hooknum);
 	}
 }
 
@@ -417,7 +417,7 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 		return;
 	}
 
-	nf_remove_net_hook(p, reg);
+	nf_remove_net_hook(p, reg, reg->pf);
 
 	p = __nf_hook_entries_try_shrink(pp);
 	mutex_unlock(&nf_hook_mutex);
-- 
2.11.0
