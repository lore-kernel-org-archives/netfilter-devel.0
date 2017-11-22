From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/5] netfilter: pass hook number and family as parameter to nf_find_hook_list()
Date: Wed, 22 Nov 2017 15:02:47 +0100
Message-ID: <20171122140250.14798-3-pablo@netfilter.org>
References: <20171122140250.14798-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45788 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751360AbdKVODe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 09:03:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F0FFF1D94C2
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:03:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A0421DA812
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:03:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A89E6BAC39
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:02:55 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 689D8403DFA2
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:02:55 +0100 (CET)
In-Reply-To: <20171122140250.14798-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just a preparation change, this is needed by follow up patches to handle
NFPROTO_INET as a real family from the core.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index d5e0961fd9f3..8d9293a47731 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -237,26 +237,28 @@ static void *__nf_hook_entries_try_shrink(struct nf_hook_entries __rcu **pp)
 	return old;
 }
 
-static struct nf_hook_entries __rcu **nf_hook_entry_head(struct net *net, const struct nf_hook_ops *reg)
+static struct nf_hook_entries __rcu **
+nf_hook_entry_head(struct net *net, int pf, unsigned int hooknum,
+		   struct net_device *dev)
 {
-	switch (reg->pf) {
+	switch (pf) {
 	case NFPROTO_NETDEV:
 		break;
 #if IS_ENABLED(CONFIG_IP_NF_ARPTABLES)
 	case NFPROTO_ARP:
-		return net->nf.hooks_arp+reg->hooknum;
+		return net->nf.hooks_arp + hooknum;
 #endif
 #if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
 	case NFPROTO_BRIDGE:
-		return net->nf.hooks_bridge+reg->hooknum;
+		return net->nf.hooks_bridge + hooknum;
 #endif
 	case NFPROTO_IPV4:
-		return net->nf.hooks_ipv4+reg->hooknum;
+		return net->nf.hooks_ipv4 + hooknum;
 	case NFPROTO_IPV6:
-		return net->nf.hooks_ipv6+reg->hooknum;
+		return net->nf.hooks_ipv6 + hooknum;
 #if IS_ENABLED(CONFIG_DECNET)
 	case NFPROTO_DECNET:
-		return net->nf.hooks_decnet+reg->hooknum;
+		return net->nf.hooks_decnet + hooknum;
 #endif
 	default:
 		WARN_ON_ONCE(1);
@@ -264,9 +266,9 @@ static struct nf_hook_entries __rcu **nf_hook_entry_head(struct net *net, const
 	}
 
 #ifdef CONFIG_NETFILTER_INGRESS
-	if (reg->hooknum == NF_NETDEV_INGRESS) {
-		if (reg->dev && dev_net(reg->dev) == net)
-			return &reg->dev->nf_hooks_ingress;
+	if (hooknum == NF_NETDEV_INGRESS) {
+		if (dev && dev_net(dev) == net)
+			return &dev->nf_hooks_ingress;
 	}
 #endif
 	WARN_ON_ONCE(1);
@@ -288,7 +290,7 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 			return -EINVAL;
 	}
 
-	pp = nf_hook_entry_head(net, reg);
+	pp = nf_hook_entry_head(net, reg->pf, reg->hooknum, reg->dev);
 	if (!pp)
 		return -EINVAL;
 
@@ -364,7 +366,7 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 	struct nf_hook_entries *p;
 	unsigned int nfq;
 
-	pp = nf_hook_entry_head(net, reg);
+	pp = nf_hook_entry_head(net, reg->pf, reg->hooknum, reg->dev);
 	if (!pp)
 		return;
 
@@ -422,7 +424,8 @@ void nf_unregister_net_hooks(struct net *net, const struct nf_hook_ops *reg,
 
 	mutex_lock(&nf_hook_mutex);
 	for (i = 0; i < hookcount; i++) {
-		pp = nf_hook_entry_head(net, &reg[i]);
+		pp = nf_hook_entry_head(net, reg[i].pf, reg[i].hooknum,
+					reg[i].dev);
 		if (!pp)
 			continue;
 
@@ -439,7 +442,8 @@ void nf_unregister_net_hooks(struct net *net, const struct nf_hook_ops *reg,
 		mutex_lock(&nf_hook_mutex);
 
 		for (i = 0, j = 0; i < hookcount && j < n; i++) {
-			pp = nf_hook_entry_head(net, &reg[i]);
+			pp = nf_hook_entry_head(net, reg[i].pf, reg[i].hooknum,
+						reg->dev);
 			if (!pp)
 				continue;
 
-- 
2.11.0

