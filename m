From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/5] netfilter: add nf_remove_net_hook
Date: Wed, 22 Nov 2017 15:02:46 +0100
Message-ID: <20171122140250.14798-2-pablo@netfilter.org>
References: <20171122140250.14798-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45782 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751316AbdKVODd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 09:03:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 37A0A1D94B5
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:03:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9575CDA87E
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:03:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E62D7BAC35
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:02:54 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id AA46E403DFA1
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:02:54 +0100 (CET)
In-Reply-To: <20171122140250.14798-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just a cleanup, __nf_unregister_net_hook() is used by a follow up patch
when handling NFPROTO_INET as a real family from the core.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index aeb7a4f8f080..d5e0961fd9f3 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -320,7 +320,7 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 EXPORT_SYMBOL(nf_register_net_hook);
 
 /*
- * __nf_unregister_net_hook - remove a hook from blob
+ * nf_remove_net_hook - remove a hook from blob
  *
  * @oldp: current address of hook blob
  * @unreg: hook to unregister
@@ -328,8 +328,8 @@ EXPORT_SYMBOL(nf_register_net_hook);
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
@@ -376,7 +376,7 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 		return;
 	}
 
-	__nf_unregister_net_hook(p, reg);
+	nf_remove_net_hook(p, reg);
 
 	p = __nf_hook_entries_try_shrink(pp);
 	mutex_unlock(&nf_hook_mutex);
@@ -429,7 +429,7 @@ void nf_unregister_net_hooks(struct net *net, const struct nf_hook_ops *reg,
 		p = nf_entry_dereference(*pp);
 		if (WARN_ON_ONCE(!p))
 			continue;
-		__nf_unregister_net_hook(p, &reg[i]);
+		nf_remove_net_hook(p, &reg[i]);
 	}
 	mutex_unlock(&nf_hook_mutex);
 
-- 
2.11.0

