From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 3/5] netfilter: handle NFPROTO_INET family hook registration from core
Date: Wed, 22 Nov 2017 15:02:48 +0100
Message-ID: <20171122140250.14798-4-pablo@netfilter.org>
References: <20171122140250.14798-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45794 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751280AbdKVODf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 09:03:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 93D521D94BC
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:03:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4510DDA87F
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:03:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4EC03BAC47
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:02:56 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0836D403DFA1
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:02:55 +0100 (CET)
In-Reply-To: <20171122140250.14798-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Expand NFPROTO_INET in two hook registrations, one for NFPROTO_IPV4 and
another for NFPROTO_IPV6. Hence, we handle NFPROTO_INET as a real family
from the core.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c | 61 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 53 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 8d9293a47731..46f60677858f 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -275,12 +275,13 @@ nf_hook_entry_head(struct net *net, int pf, unsigned int hooknum,
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
@@ -290,7 +291,7 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 			return -EINVAL;
 	}
 
-	pp = nf_hook_entry_head(net, reg->pf, reg->hooknum, reg->dev);
+	pp = nf_hook_entry_head(net, pf, reg->hooknum, reg->dev);
 	if (!pp)
 		return -EINVAL;
 
@@ -308,18 +309,17 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 
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
 	synchronize_net();
 	BUG_ON(p == new_hooks);
 	kvfree(p);
 	return 0;
 }
-EXPORT_SYMBOL(nf_register_net_hook);
 
 /*
  * nf_remove_net_hook - remove a hook from blob
@@ -360,13 +360,14 @@ static void nf_remove_net_hook(struct nf_hook_entries *old,
 	}
 }
 
-void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
+static void __nf_unregister_net_hook(struct net *net, int pf,
+				     const struct nf_hook_ops *reg)
 {
 	struct nf_hook_entries __rcu **pp;
 	struct nf_hook_entries *p;
 	unsigned int nfq;
 
-	pp = nf_hook_entry_head(net, reg->pf, reg->hooknum, reg->dev);
+	pp = nf_hook_entry_head(net, pf, reg->hooknum, reg->dev);
 	if (!pp)
 		return;
 
@@ -393,8 +394,52 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 		synchronize_net();
 	kvfree(p);
 }
+
+void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
+{
+	switch (reg->pf) {
+	case NFPROTO_INET:
+		__nf_unregister_net_hook(net, NFPROTO_IPV4, reg);
+		__nf_unregister_net_hook(net, NFPROTO_IPV6, reg);
+		break;
+	default:
+		__nf_unregister_net_hook(net, reg->pf, reg);
+		break;
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
+#ifdef CONFIG_NETFILTER_INGRESS
+	if (reg->pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
+		net_inc_ingress_queue();
+#endif
+#ifdef HAVE_JUMP_LABEL
+	static_key_slow_inc(&nf_hooks_needed[reg->pf][reg->hooknum]);
+#endif
+	return 0;
+}
+EXPORT_SYMBOL(nf_register_net_hook);
+
 int nf_register_net_hooks(struct net *net, const struct nf_hook_ops *reg,
 			  unsigned int n)
 {
-- 
2.11.0

