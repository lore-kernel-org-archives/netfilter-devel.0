Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9AAC61DA7
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbjKUMN7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbjKUMN6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:13:58 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8BC912C;
        Tue, 21 Nov 2023 04:13:53 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,5.4 22/26] netfilter: nf_tables: double hook unregistration in netns path
Date:   Tue, 21 Nov 2023 13:13:29 +0100
Message-Id: <20231121121333.294238-23-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231121121333.294238-1-pablo@netfilter.org>
References: <20231121121333.294238-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

commit f9a43007d3f7ba76d5e7f9421094f00f2ef202f8 upstream.

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
 net/netfilter/nf_tables_api.c    | 34 +++++++++++++++++++++++++-------
 net/netfilter/nft_chain_filter.c |  3 +++
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cdb1862d6588..afa7aebf75ef 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -219,9 +219,10 @@ static int nf_tables_register_hook(struct net *net,
 	return nf_register_net_hook(net, ops);
 }
 
-static void nf_tables_unregister_hook(struct net *net,
-				      const struct nft_table *table,
-				      struct nft_chain *chain)
+static void __nf_tables_unregister_hook(struct net *net,
+					const struct nft_table *table,
+					struct nft_chain *chain,
+					bool release_netdev)
 {
 	const struct nft_base_chain *basechain;
 	const struct nf_hook_ops *ops;
@@ -236,6 +237,16 @@ static void nf_tables_unregister_hook(struct net *net,
 		return basechain->type->ops_unregister(net, ops);
 
 	nf_unregister_net_hook(net, ops);
+	if (release_netdev &&
+	    table->family == NFPROTO_NETDEV)
+		nft_base_chain(chain)->ops.dev = NULL;
+}
+
+static void nf_tables_unregister_hook(struct net *net,
+				      const struct nft_table *table,
+				      struct nft_chain *chain)
+{
+	__nf_tables_unregister_hook(net, table, chain, false);
 }
 
 static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
@@ -5997,8 +6008,9 @@ nft_flowtable_type_get(struct net *net, u8 family)
 	return ERR_PTR(-ENOENT);
 }
 
-static void nft_unregister_flowtable_net_hooks(struct net *net,
-					       struct nft_flowtable *flowtable)
+static void __nft_unregister_flowtable_net_hooks(struct net *net,
+						 struct nft_flowtable *flowtable,
+						 bool release_netdev)
 {
 	int i;
 
@@ -6007,9 +6019,17 @@ static void nft_unregister_flowtable_net_hooks(struct net *net,
 			continue;
 
 		nf_unregister_net_hook(net, &flowtable->ops[i]);
+		if (release_netdev)
+			flowtable->ops[i].dev = NULL;
 	}
 }
 
+static void nft_unregister_flowtable_net_hooks(struct net *net,
+					       struct nft_flowtable *flowtable)
+{
+	__nft_unregister_flowtable_net_hooks(net, flowtable, false);
+}
+
 static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 				  struct sk_buff *skb,
 				  const struct nlmsghdr *nlh,
@@ -8192,9 +8212,9 @@ static void __nft_release_hook(struct net *net, struct nft_table *table)
 	struct nft_chain *chain;
 
 	list_for_each_entry(chain, &table->chains, list)
-		nf_tables_unregister_hook(net, table, chain);
+		__nf_tables_unregister_hook(net, table, chain, true);
 	list_for_each_entry(flowtable, &table->flowtables, list)
-		nft_unregister_flowtable_net_hooks(net, flowtable);
+		__nft_unregister_flowtable_net_hooks(net, flowtable, true);
 }
 
 static void __nft_release_hooks(struct net *net)
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 04824d7dcc22..916195dba6f7 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -296,6 +296,9 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 		if (strcmp(basechain->dev_name, dev->name) != 0)
 			return;
 
+		if (!basechain->ops.dev)
+			return;
+
 		/* UNREGISTER events are also happpening on netns exit.
 		 *
 		 * Altough nf_tables core releases all tables/chains, only
-- 
2.30.2

