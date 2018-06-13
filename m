From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/9] netfilter: nf_tables: close race between netns exit and rmmod
Date: Wed, 13 Jun 2018 12:56:56 +0200
Message-ID: <20180613105700.12894-6-pablo@netfilter.org>
References: <20180613105700.12894-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180613105700.12894-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

If net namespace is exiting while nf_tables module is being removed
we can oops:

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
 IP: nf_tables_flowtable_event+0x43/0xf0 [nf_tables]
 PGD 0 P4D 0
 Oops: 0000 [#1] SMP PTI
 Modules linked in: nf_tables(-) nfnetlink [..]
  unregister_netdevice_notifier+0xdd/0x130
  nf_tables_module_exit+0x24/0x3a [nf_tables]
  SyS_delete_module+0x1c5/0x240
  do_syscall_64+0x74/0x190

Avoid this by attempting to take reference on the net namespace from
the notifiers.  If it fails the namespace is exiting already, and nft
core is taking care of cleanup work.

We also need to make sure the netdev hook type gets removed
before netns ops removal, else notifier might be invoked with device
event for a netns where net->nft was never initialised (because
pernet ops was removed beforehand).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c    | 13 ++++++++++---
 net/netfilter/nft_chain_filter.c |  5 +++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ae312b31db28..d23a5c269c44 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5837,18 +5837,23 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct nft_flowtable *flowtable;
 	struct nft_table *table;
+	struct net *net;
 
 	if (event != NETDEV_UNREGISTER)
 		return 0;
 
+	net = maybe_get_net(dev_net(dev));
+	if (!net)
+		return 0;
+
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
-	list_for_each_entry(table, &dev_net(dev)->nft.tables, list) {
+	list_for_each_entry(table, &net->nft.tables, list) {
 		list_for_each_entry(flowtable, &table->flowtables, list) {
 			nft_flowtable_event(event, dev, flowtable);
 		}
 	}
 	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
-
+	put_net(net);
 	return NOTIFY_DONE;
 }
 
@@ -7154,9 +7159,11 @@ static int __net_init nf_tables_init_net(struct net *net)
 
 static void __net_exit nf_tables_exit_net(struct net *net)
 {
+	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	if (!list_empty(&net->nft.commit_list))
 		__nf_tables_abort(net);
 	__nft_release_tables(net);
+	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 	WARN_ON_ONCE(!list_empty(&net->nft.tables));
 }
 
@@ -7201,11 +7208,11 @@ static void __exit nf_tables_module_exit(void)
 {
 	nfnetlink_subsys_unregister(&nf_tables_subsys);
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
+	nft_chain_filter_fini();
 	unregister_pernet_subsys(&nf_tables_net_ops);
 	rcu_barrier();
 	nf_tables_core_module_exit();
 	kfree(info);
-	nft_chain_filter_fini();
 }
 
 module_init(nf_tables_module_init);
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 84c902477a91..d21834bed805 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -318,6 +318,10 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	    event != NETDEV_CHANGENAME)
 		return NOTIFY_DONE;
 
+	ctx.net = maybe_get_net(ctx.net);
+	if (!ctx.net)
+		return NOTIFY_DONE;
+
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	list_for_each_entry(table, &ctx.net->nft.tables, list) {
 		if (table->family != NFPROTO_NETDEV)
@@ -334,6 +338,7 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 		}
 	}
 	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
+	put_net(ctx.net);
 
 	return NOTIFY_DONE;
 }
-- 
2.11.0
