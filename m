From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/2] netfilter: fix possible removal of wrong hook
Date: Mon, 20 Jul 2015 13:55:01 +0200
Message-ID: <1437393302-18899-1-git-send-email-pablo@netfilter.org>
Cc: ebiederm@xmission.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35471 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbbGTLtW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2015 07:49:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_unregister_net_hook() uses the nf_hook_ops fields as tuple to look up for
the corresponding hook in the list. However, we may have two hooks with exactly
the same configuration.

This shouldn't be a problem for nftables since every new chain has an unique
priv field set, but this may still cause us problems in the future, so better
address this problem now by keeping a reference to the original nf_hook_ops
structure to make sure we delete the right hook from nf_unregister_net_hook().

Fixes: 085db2c04557 ("netfilter: Per network namespace netfilter hooks.")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c |   39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 87d237d..a834181 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -78,26 +78,27 @@ static struct list_head *find_nf_hook_list(struct net *net,
 	return nf_hook_list;
 }
 
+struct nf_hook_entry {
+	const struct nf_hook_ops	*orig_ops;
+	struct nf_hook_ops		ops;
+};
+
 int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 {
 	struct list_head *nf_hook_list;
-	struct nf_hook_ops *elem, *new;
+	struct nf_hook_entry *entry;
+	struct nf_hook_ops *elem;
 
-	new = kzalloc(sizeof(*new), GFP_KERNEL);
-	if (!new)
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
 		return -ENOMEM;
 
-	new->hook     = reg->hook;
-	new->dev      = reg->dev;
-	new->owner    = reg->owner;
-	new->priv     = reg->priv;
-	new->pf       = reg->pf;
-	new->hooknum  = reg->hooknum;
-	new->priority = reg->priority;
+	entry->orig_ops	= reg;
+	entry->ops	= *reg;
 
 	nf_hook_list = find_nf_hook_list(net, reg);
 	if (!nf_hook_list) {
-		kfree(new);
+		kfree(entry);
 		return -ENOENT;
 	}
 
@@ -106,7 +107,7 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 		if (reg->priority < elem->priority)
 			break;
 	}
-	list_add_rcu(&new->list, elem->list.prev);
+	list_add_rcu(&entry->ops.list, elem->list.prev);
 	mutex_unlock(&nf_hook_mutex);
 #ifdef CONFIG_NETFILTER_INGRESS
 	if (reg->pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
@@ -122,6 +123,7 @@ EXPORT_SYMBOL(nf_register_net_hook);
 void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 {
 	struct list_head *nf_hook_list;
+	struct nf_hook_entry *entry;
 	struct nf_hook_ops *elem;
 
 	nf_hook_list = find_nf_hook_list(net, reg);
@@ -130,14 +132,9 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 
 	mutex_lock(&nf_hook_mutex);
 	list_for_each_entry(elem, nf_hook_list, list) {
-		if ((reg->hook     == elem->hook) &&
-		    (reg->dev      == elem->dev) &&
-		    (reg->owner    == elem->owner) &&
-		    (reg->priv     == elem->priv) &&
-		    (reg->pf       == elem->pf) &&
-		    (reg->hooknum  == elem->hooknum) &&
-		    (reg->priority == elem->priority)) {
-			list_del_rcu(&elem->list);
+		entry = container_of(elem, struct nf_hook_entry, ops);
+		if (entry->orig_ops == reg) {
+			list_del_rcu(&entry->ops.list);
 			break;
 		}
 	}
@@ -154,7 +151,7 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 	static_key_slow_dec(&nf_hooks_needed[reg->pf][reg->hooknum]);
 #endif
 	synchronize_net();
-	nf_queue_nf_hook_drop(elem);
+	nf_queue_nf_hook_drop(&entry->ops);
 	kfree(elem);
 }
 EXPORT_SYMBOL(nf_unregister_net_hook);
-- 
1.7.10.4

