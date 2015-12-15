From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/5 nf,v3] netfilter: nf_tables: release objects on netns destruction
Date: Tue, 15 Dec 2015 19:39:32 +0100
Message-ID: <1450204772-5013-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46490 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965356AbbLOSjv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Dec 2015 13:39:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 79784129262
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2015 19:39:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4EC93DA57D
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2015 19:39:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2E164DA86B
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2015 19:39:43 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have to release the existing objects on netns removal otherwise we
leak them. Chains are unregistered in first place to make sure no
packets are walking on our rules and sets anymore.

The object release happens by when we unregister the family via
nft_release_afinfo() which is called from nft_unregister_afinfo() from
the corresponding __net_exit path in every family.

Reported-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: Release objects from nft_unregister_afinfo() path.

 include/net/netfilter/nf_tables.h       |  2 +-
 net/bridge/netfilter/nf_tables_bridge.c |  2 +-
 net/ipv4/netfilter/nf_tables_arp.c      |  2 +-
 net/ipv4/netfilter/nf_tables_ipv4.c     |  2 +-
 net/ipv6/netfilter/nf_tables_ipv6.c     |  2 +-
 net/netfilter/nf_tables_api.c           | 47 +++++++++++++++++++++++++++++++--
 net/netfilter/nf_tables_inet.c          |  2 +-
 net/netfilter/nf_tables_netdev.c        |  2 +-
 8 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4bd7508..432e8ed 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -882,7 +882,7 @@ struct nft_af_info {
 };
 
 int nft_register_afinfo(struct net *, struct nft_af_info *);
-void nft_unregister_afinfo(struct nft_af_info *);
+void nft_unregister_afinfo(struct net *, struct nft_af_info *);
 
 int nft_register_chain_type(const struct nf_chain_type *);
 void nft_unregister_chain_type(const struct nf_chain_type *);
diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index 62f6b1b..7fcdd72 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -141,7 +141,7 @@ err:
 
 static void nf_tables_bridge_exit_net(struct net *net)
 {
-	nft_unregister_afinfo(net->nft.bridge);
+	nft_unregister_afinfo(net, net->nft.bridge);
 	kfree(net->nft.bridge);
 }
 
diff --git a/net/ipv4/netfilter/nf_tables_arp.c b/net/ipv4/netfilter/nf_tables_arp.c
index 9d09d4f..cd84d42 100644
--- a/net/ipv4/netfilter/nf_tables_arp.c
+++ b/net/ipv4/netfilter/nf_tables_arp.c
@@ -57,7 +57,7 @@ err:
 
 static void nf_tables_arp_exit_net(struct net *net)
 {
-	nft_unregister_afinfo(net->nft.arp);
+	nft_unregister_afinfo(net, net->nft.arp);
 	kfree(net->nft.arp);
 }
 
diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
index ca9dc3c..e44ba3b 100644
--- a/net/ipv4/netfilter/nf_tables_ipv4.c
+++ b/net/ipv4/netfilter/nf_tables_ipv4.c
@@ -78,7 +78,7 @@ err:
 
 static void nf_tables_ipv4_exit_net(struct net *net)
 {
-	nft_unregister_afinfo(net->nft.ipv4);
+	nft_unregister_afinfo(net, net->nft.ipv4);
 	kfree(net->nft.ipv4);
 }
 
diff --git a/net/ipv6/netfilter/nf_tables_ipv6.c b/net/ipv6/netfilter/nf_tables_ipv6.c
index 120ea91..30b22f4 100644
--- a/net/ipv6/netfilter/nf_tables_ipv6.c
+++ b/net/ipv6/netfilter/nf_tables_ipv6.c
@@ -77,7 +77,7 @@ err:
 
 static void nf_tables_ipv6_exit_net(struct net *net)
 {
-	nft_unregister_afinfo(net->nft.ipv6);
+	nft_unregister_afinfo(net, net->nft.ipv6);
 	kfree(net->nft.ipv6);
 }
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2cb429d..4984602 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -41,6 +41,8 @@ int nft_register_afinfo(struct net *net, struct nft_af_info *afi)
 }
 EXPORT_SYMBOL_GPL(nft_register_afinfo);
 
+static void __nft_release_afinfo(struct net *net, struct nft_af_info *afi);
+
 /**
  *	nft_unregister_afinfo - unregister nf_tables address family info
  *
@@ -48,9 +50,10 @@ EXPORT_SYMBOL_GPL(nft_register_afinfo);
  *
  *	Unregister the address family for use with nf_tables.
  */
-void nft_unregister_afinfo(struct nft_af_info *afi)
+void nft_unregister_afinfo(struct net *net, struct nft_af_info *afi)
 {
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
+	__nft_release_afinfo(net, afi);
 	list_del_rcu(&afi->list);
 	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 }
@@ -4579,7 +4582,7 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 }
 EXPORT_SYMBOL_GPL(nft_data_dump);
 
-static int nf_tables_init_net(struct net *net)
+static int __net_init nf_tables_init_net(struct net *net)
 {
 	INIT_LIST_HEAD(&net->nft.af_info);
 	INIT_LIST_HEAD(&net->nft.commit_list);
@@ -4587,6 +4590,46 @@ static int nf_tables_init_net(struct net *net)
 	return 0;
 }
 
+/* Called by nft_unregister_afinfo() from __net_exit path, nfnl_lock is held. */
+static void __nft_release_afinfo(struct net *net, struct nft_af_info *afi)
+{
+	struct nft_table *table, *nt;
+	struct nft_chain *chain, *nc;
+	struct nft_rule *rule, *nr;
+	struct nft_set *set, *ns;
+	struct nft_ctx ctx = {
+		.net	= net,
+		.afi	= afi,
+	};
+
+	list_for_each_entry_safe(table, nt, &afi->tables, list) {
+		list_for_each_entry(chain, &table->chains, list)
+			nf_tables_unregister_hooks(table, chain, afi->nops);
+		/* No packets are walking on these chains anymore. */
+		ctx.table = table;
+		list_for_each_entry(chain, &table->chains, list) {
+			ctx.chain = chain;
+			list_for_each_entry_safe(rule, nr, &chain->rules, list) {
+				list_del(&rule->list);
+				chain->use--;
+				nf_tables_rule_destroy(&ctx, rule);
+			}
+		}
+		list_for_each_entry_safe(set, ns, &table->sets, list) {
+			list_del(&set->list);
+			table->use--;
+			nft_set_destroy(set);
+		}
+		list_for_each_entry_safe(chain, nc, &table->chains, list) {
+			list_del(&chain->list);
+			table->use--;
+			nf_tables_chain_destroy(chain);
+		}
+		list_del(&table->list);
+		nf_tables_table_destroy(&ctx);
+	}
+}
+
 static struct pernet_operations nf_tables_net_ops = {
 	.init	= nf_tables_init_net,
 };
diff --git a/net/netfilter/nf_tables_inet.c b/net/netfilter/nf_tables_inet.c
index 9dd2d21..6b5f762 100644
--- a/net/netfilter/nf_tables_inet.c
+++ b/net/netfilter/nf_tables_inet.c
@@ -57,7 +57,7 @@ err:
 
 static void __net_exit nf_tables_inet_exit_net(struct net *net)
 {
-	nft_unregister_afinfo(net->nft.inet);
+	nft_unregister_afinfo(net, net->nft.inet);
 	kfree(net->nft.inet);
 }
 
diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
index 7b9c053..2bfd1fb 100644
--- a/net/netfilter/nf_tables_netdev.c
+++ b/net/netfilter/nf_tables_netdev.c
@@ -139,7 +139,7 @@ err:
 
 static void nf_tables_netdev_exit_net(struct net *net)
 {
-	nft_unregister_afinfo(net->nft.netdev);
+	nft_unregister_afinfo(net, net->nft.netdev);
 	kfree(net->nft.netdev);
 }
 
-- 
2.1.4

