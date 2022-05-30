Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD07C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 May 2022 16:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbiE3QJO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 May 2022 12:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241568AbiE3QJJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 May 2022 12:09:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 226C46B00B
        for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2022 09:09:06 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/2] netfilter: nf_tables: double hook unregistration in netns path
Date:   Mon, 30 May 2022 18:09:00 +0200
Message-Id: <20220530160901.3731-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

__nft_release_hooks() is called from pre_netns exit path which
unregisters the hooks, then the NETDEV_UNREGISTER event is triggered
which unregisters the hooks again.

[  565.221461] WARNING: CPU: 18 PID: 193 at net/netfilter/core.c:495 __nf_unregister_net_hook+0x247/0x270
[...]
[  565.246890] CPU: 18 PID: 193 Comm: kworker/u64:1 Tainted: G            E     5.18.0-rc7+ #27
[  565.253682] Workqueue: netns cleanup_net
[  565.257059] RIP: 0010:__nf_unregister_net_hook+0x247/0x270
[...]
[  565.297120] Call Trace:
[  565.300900]  <TASK>
[  565.304683]  nf_tables_flowtable_event+0x16a/0x220 [nf_tables]
[  565.308518]  raw_notifier_call_chain+0x63/0x80
[  565.312386]  unregister_netdevice_many+0x54f/0xb50

Unregister and destroy netdev hook from netns pre_exit via kfree_rcu
so the NETDEV_UNREGISTER path see unregistered hooks.

Fixes: 767d1216bff8 ("netfilter: nftables: fix possible UAF over chains from packet path in netns")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 54 ++++++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2c6c956c7bbc..7c9eb8e42ea6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -222,12 +222,18 @@ static int nft_netdev_register_hooks(struct net *net,
 }
 
 static void nft_netdev_unregister_hooks(struct net *net,
-					struct list_head *hook_list)
+					struct list_head *hook_list,
+					bool release_netdev)
 {
-	struct nft_hook *hook;
+	struct nft_hook *hook, *next;
 
-	list_for_each_entry(hook, hook_list, list)
+	list_for_each_entry_safe(hook, next, hook_list, list) {
 		nf_unregister_net_hook(net, &hook->ops);
+		if (release_netdev) {
+			list_del(&hook->list);
+			kfree_rcu(hook, rcu);
+		}
+	}
 }
 
 static int nf_tables_register_hook(struct net *net,
@@ -253,9 +259,10 @@ static int nf_tables_register_hook(struct net *net,
 	return nf_register_net_hook(net, &basechain->ops);
 }
 
-static void nf_tables_unregister_hook(struct net *net,
-				      const struct nft_table *table,
-				      struct nft_chain *chain)
+static void __nf_tables_unregister_hook(struct net *net,
+					const struct nft_table *table,
+					struct nft_chain *chain,
+					bool release_netdev)
 {
 	struct nft_base_chain *basechain;
 	const struct nf_hook_ops *ops;
@@ -270,11 +277,19 @@ static void nf_tables_unregister_hook(struct net *net,
 		return basechain->type->ops_unregister(net, ops);
 
 	if (nft_base_chain_netdev(table->family, basechain->ops.hooknum))
-		nft_netdev_unregister_hooks(net, &basechain->hook_list);
+		nft_netdev_unregister_hooks(net, &basechain->hook_list,
+					    release_netdev);
 	else
 		nf_unregister_net_hook(net, &basechain->ops);
 }
 
+static void nf_tables_unregister_hook(struct net *net,
+				      const struct nft_table *table,
+				      struct nft_chain *chain)
+{
+	return __nf_tables_unregister_hook(net, table, chain, false);
+}
+
 static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *trans)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -7291,13 +7306,25 @@ static void nft_unregister_flowtable_hook(struct net *net,
 				    FLOW_BLOCK_UNBIND);
 }
 
-static void nft_unregister_flowtable_net_hooks(struct net *net,
-					       struct list_head *hook_list)
+static void __nft_unregister_flowtable_net_hooks(struct net *net,
+						 struct list_head *hook_list,
+					         bool release_netdev)
 {
-	struct nft_hook *hook;
+	struct nft_hook *hook, *next;
 
-	list_for_each_entry(hook, hook_list, list)
+	list_for_each_entry_safe(hook, next, hook_list, list) {
 		nf_unregister_net_hook(net, &hook->ops);
+		if (release_netdev) {
+			list_del(&hook->list);
+			kfree_rcu(hook);
+		}
+	}
+}
+
+static void nft_unregister_flowtable_net_hooks(struct net *net,
+					       struct list_head *hook_list)
+{
+	__nft_unregister_flowtable_net_hooks(net, hook_list, false);
 }
 
 static int nft_register_flowtable_net_hooks(struct net *net,
@@ -9741,9 +9768,10 @@ static void __nft_release_hook(struct net *net, struct nft_table *table)
 	struct nft_chain *chain;
 
 	list_for_each_entry(chain, &table->chains, list)
-		nf_tables_unregister_hook(net, table, chain);
+		__nf_tables_unregister_hook(net, table, chain, true);
 	list_for_each_entry(flowtable, &table->flowtables, list)
-		nft_unregister_flowtable_net_hooks(net, &flowtable->hook_list);
+		__nft_unregister_flowtable_net_hooks(net, &flowtable->hook_list,
+						     true);
 }
 
 static void __nft_release_hooks(struct net *net)
-- 
2.30.2

