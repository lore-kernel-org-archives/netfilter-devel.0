From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v2 3/7] netfilter: core: pass family as parameter to nf_remove_net_hook()
Date: Sun, 10 Dec 2017 21:34:51 +0100
Message-ID: <20171210203455.11651-4-pablo@netfilter.org>
References: <20171210203455.11651-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45858 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752407AbdLJUfF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Dec 2017 15:35:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A7DBF1C4427
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:35:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97654DA794
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:35:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70950DA7F7
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:35:01 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3EF06426CC81
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:35:01 +0100 (CET)
In-Reply-To: <20171210203455.11651-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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

