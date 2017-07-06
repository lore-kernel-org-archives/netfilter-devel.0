From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: remove old pre-netns era hook api
Date: Thu,  6 Jul 2017 23:17:44 +0200
Message-ID: <20170706211744.17683-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39232 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751899AbdGFVR4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jul 2017 17:17:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

no more users in the tree, remove this.

The old api is racy wrt. module removal, all users have been converted
to the netns-aware api.

The old api pretended we still have global hooks but that has not been
true for a long time.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h |   9 ---
 net/netfilter/core.c      | 143 ----------------------------------------------
 2 files changed, 152 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index a4b97be..22f0810 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -61,8 +61,6 @@ typedef unsigned int nf_hookfn(void *priv,
 			       struct sk_buff *skb,
 			       const struct nf_hook_state *state);
 struct nf_hook_ops {
-	struct list_head	list;
-
 	/* User fills in from here down. */
 	nf_hookfn		*hook;
 	struct net_device	*dev;
@@ -160,13 +158,6 @@ int nf_register_net_hooks(struct net *net, const struct nf_hook_ops *reg,
 void nf_unregister_net_hooks(struct net *net, const struct nf_hook_ops *reg,
 			     unsigned int n);
 
-int nf_register_hook(struct nf_hook_ops *reg);
-void nf_unregister_hook(struct nf_hook_ops *reg);
-int nf_register_hooks(struct nf_hook_ops *reg, unsigned int n);
-void nf_unregister_hooks(struct nf_hook_ops *reg, unsigned int n);
-int _nf_register_hooks(struct nf_hook_ops *reg, unsigned int n);
-void _nf_unregister_hooks(struct nf_hook_ops *reg, unsigned int n);
-
 /* Functions to register get/setsockopt ranges (non-inclusive).  You
    need to check permissions yourself! */
 int nf_register_sockopt(struct nf_sockopt_ops *reg);
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 552d606..368610d 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -227,114 +227,6 @@ void nf_unregister_net_hooks(struct net *net, const struct nf_hook_ops *reg,
 }
 EXPORT_SYMBOL(nf_unregister_net_hooks);
 
-static LIST_HEAD(nf_hook_list);
-
-static int _nf_register_hook(struct nf_hook_ops *reg)
-{
-	struct net *net, *last;
-	int ret;
-
-	for_each_net(net) {
-		ret = nf_register_net_hook(net, reg);
-		if (ret && ret != -ENOENT)
-			goto rollback;
-	}
-	list_add_tail(&reg->list, &nf_hook_list);
-
-	return 0;
-rollback:
-	last = net;
-	for_each_net(net) {
-		if (net == last)
-			break;
-		nf_unregister_net_hook(net, reg);
-	}
-	return ret;
-}
-
-int nf_register_hook(struct nf_hook_ops *reg)
-{
-	int ret;
-
-	rtnl_lock();
-	ret = _nf_register_hook(reg);
-	rtnl_unlock();
-
-	return ret;
-}
-EXPORT_SYMBOL(nf_register_hook);
-
-static void _nf_unregister_hook(struct nf_hook_ops *reg)
-{
-	struct net *net;
-
-	list_del(&reg->list);
-	for_each_net(net)
-		nf_unregister_net_hook(net, reg);
-}
-
-void nf_unregister_hook(struct nf_hook_ops *reg)
-{
-	rtnl_lock();
-	_nf_unregister_hook(reg);
-	rtnl_unlock();
-}
-EXPORT_SYMBOL(nf_unregister_hook);
-
-int nf_register_hooks(struct nf_hook_ops *reg, unsigned int n)
-{
-	unsigned int i;
-	int err = 0;
-
-	for (i = 0; i < n; i++) {
-		err = nf_register_hook(&reg[i]);
-		if (err)
-			goto err;
-	}
-	return err;
-
-err:
-	if (i > 0)
-		nf_unregister_hooks(reg, i);
-	return err;
-}
-EXPORT_SYMBOL(nf_register_hooks);
-
-/* Caller MUST take rtnl_lock() */
-int _nf_register_hooks(struct nf_hook_ops *reg, unsigned int n)
-{
-	unsigned int i;
-	int err = 0;
-
-	for (i = 0; i < n; i++) {
-		err = _nf_register_hook(&reg[i]);
-		if (err)
-			goto err;
-	}
-	return err;
-
-err:
-	if (i > 0)
-		_nf_unregister_hooks(reg, i);
-	return err;
-}
-EXPORT_SYMBOL(_nf_register_hooks);
-
-void nf_unregister_hooks(struct nf_hook_ops *reg, unsigned int n)
-{
-	while (n-- > 0)
-		nf_unregister_hook(&reg[n]);
-}
-EXPORT_SYMBOL(nf_unregister_hooks);
-
-/* Caller MUST take rtnl_lock */
-void _nf_unregister_hooks(struct nf_hook_ops *reg, unsigned int n)
-{
-	while (n-- > 0)
-		_nf_unregister_hook(&reg[n]);
-}
-EXPORT_SYMBOL(_nf_unregister_hooks);
-
 /* Returns 1 if okfn() needs to be executed by the caller,
  * -EPERM for NF_DROP, 0 otherwise.  Caller must hold rcu_read_lock. */
 int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
@@ -450,37 +342,6 @@ void (*nf_nat_decode_session_hook)(struct sk_buff *, struct flowi *);
 EXPORT_SYMBOL(nf_nat_decode_session_hook);
 #endif
 
-static int nf_register_hook_list(struct net *net)
-{
-	struct nf_hook_ops *elem;
-	int ret;
-
-	rtnl_lock();
-	list_for_each_entry(elem, &nf_hook_list, list) {
-		ret = nf_register_net_hook(net, elem);
-		if (ret && ret != -ENOENT)
-			goto out_undo;
-	}
-	rtnl_unlock();
-	return 0;
-
-out_undo:
-	list_for_each_entry_continue_reverse(elem, &nf_hook_list, list)
-		nf_unregister_net_hook(net, elem);
-	rtnl_unlock();
-	return ret;
-}
-
-static void nf_unregister_hook_list(struct net *net)
-{
-	struct nf_hook_ops *elem;
-
-	rtnl_lock();
-	list_for_each_entry(elem, &nf_hook_list, list)
-		nf_unregister_net_hook(net, elem);
-	rtnl_unlock();
-}
-
 static int __net_init netfilter_net_init(struct net *net)
 {
 	int i, h, ret;
@@ -500,16 +361,12 @@ static int __net_init netfilter_net_init(struct net *net)
 		return -ENOMEM;
 	}
 #endif
-	ret = nf_register_hook_list(net);
-	if (ret)
-		remove_proc_entry("netfilter", net->proc_net);
 
 	return ret;
 }
 
 static void __net_exit netfilter_net_exit(struct net *net)
 {
-	nf_unregister_hook_list(net);
 	remove_proc_entry("netfilter", net->proc_net);
 }
 
-- 
2.9.4

