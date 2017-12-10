From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v2 4/7] netfilter: core: support for NFPROTO_INET hook registration
Date: Sun, 10 Dec 2017 21:34:52 +0100
Message-ID: <20171210203455.11651-5-pablo@netfilter.org>
References: <20171210203455.11651-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45874 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752405AbdLJUfH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Dec 2017 15:35:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0BAAE1C4423
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:35:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0050DA807
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:35:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24146DA812
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:35:02 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E6E7A426CC80
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:35:01 +0100 (CET)
In-Reply-To: <20171210203455.11651-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Expand NFPROTO_INET in two hook registrations, one for NFPROTO_IPV4 and
another for NFPROTO_IPV6. Hence, we handle NFPROTO_INET from the core.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c | 53 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 6c9874c8b10a..606efc9b14e1 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -316,12 +316,13 @@ nf_hook_entry_head(struct net *net, int pf, unsigned int hooknum,
 	return NULL;
 }
 
-int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
+static int __nf_register_net_hook(struct net *net, int pf,
+				  const struct nf_hook_ops *reg)
 {
 	struct nf_hook_entries *p, *new_hooks;
 	struct nf_hook_entries __rcu **pp;
 
-	if (reg->pf == NFPROTO_NETDEV) {
+	if (pf == NFPROTO_NETDEV) {
 #ifndef CONFIG_NETFILTER_INGRESS
 		if (reg->hooknum == NF_NETDEV_INGRESS)
 			return -EOPNOTSUPP;
@@ -331,7 +332,7 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 			return -EINVAL;
 	}
 
-	pp = nf_hook_entry_head(net, reg->pf, reg->hooknum, reg->dev);
+	pp = nf_hook_entry_head(net, pf, reg->hooknum, reg->dev);
 	if (!pp)
 		return -EINVAL;
 
@@ -349,17 +350,16 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 
 	hooks_validate(new_hooks);
 #ifdef CONFIG_NETFILTER_INGRESS
-	if (reg->pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
+	if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
 		net_inc_ingress_queue();
 #endif
 #ifdef HAVE_JUMP_LABEL
-	static_key_slow_inc(&nf_hooks_needed[reg->pf][reg->hooknum]);
+	static_key_slow_inc(&nf_hooks_needed[pf][reg->hooknum]);
 #endif
 	BUG_ON(p == new_hooks);
 	nf_hook_entries_free(p);
 	return 0;
 }
-EXPORT_SYMBOL(nf_register_net_hook);
 
 /*
  * nf_remove_net_hook - remove a hook from blob
@@ -400,12 +400,13 @@ static void nf_remove_net_hook(struct nf_hook_entries *old,
 	}
 }
 
-void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
+void __nf_unregister_net_hook(struct net *net, int pf,
+			      const struct nf_hook_ops *reg)
 {
 	struct nf_hook_entries __rcu **pp;
 	struct nf_hook_entries *p;
 
-	pp = nf_hook_entry_head(net, reg->pf, reg->hooknum, reg->dev);
+	pp = nf_hook_entry_head(net, pf, reg->hooknum, reg->dev);
 	if (!pp)
 		return;
 
@@ -417,7 +418,7 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 		return;
 	}
 
-	nf_remove_net_hook(p, reg, reg->pf);
+	nf_remove_net_hook(p, reg, pf);
 
 	p = __nf_hook_entries_try_shrink(pp);
 	mutex_unlock(&nf_hook_mutex);
@@ -427,8 +428,42 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 	nf_queue_nf_hook_drop(net);
 	nf_hook_entries_free(p);
 }
+
+void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
+{
+	if (reg->pf == NFPROTO_INET) {
+		__nf_unregister_net_hook(net, NFPROTO_IPV4, reg);
+		__nf_unregister_net_hook(net, NFPROTO_IPV6, reg);
+	} else {
+		__nf_unregister_net_hook(net, reg->pf, reg);
+	}
+}
 EXPORT_SYMBOL(nf_unregister_net_hook);
 
+int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
+{
+	int err;
+
+	if (reg->pf == NFPROTO_INET) {
+		err = __nf_register_net_hook(net, NFPROTO_IPV4, reg);
+		if (err < 0)
+			return err;
+
+		err = __nf_register_net_hook(net, NFPROTO_IPV6, reg);
+		if (err < 0) {
+			__nf_unregister_net_hook(net, NFPROTO_IPV4, reg);
+			return err;
+		}
+	} else {
+		err = __nf_register_net_hook(net, reg->pf, reg);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(nf_register_net_hook);
+
 int nf_register_net_hooks(struct net *net, const struct nf_hook_ops *reg,
 			  unsigned int n)
 {
-- 
2.11.0

