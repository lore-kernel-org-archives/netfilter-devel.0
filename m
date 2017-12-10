From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v2 1/7] netfilter: core: add nf_remove_net_hook
Date: Sun, 10 Dec 2017 21:34:49 +0100
Message-ID: <20171210203455.11651-2-pablo@netfilter.org>
References: <20171210203455.11651-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45856 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752405AbdLJUfE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Dec 2017 15:35:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 58A2B1C4423
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:35:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 47886DA78E
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:35:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE15DDA804
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:34:59 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id AEDA5426CC80
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:34:59 +0100 (CET)
In-Reply-To: <20171210203455.11651-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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

