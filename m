From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/10] netfilter: nf_flow_table: remove unnecessary parameter of nf_flow_table_cleanup()
Date: Sat, 20 Oct 2018 11:43:14 +0200
Message-ID: <20181020094317.16011-8-pablo@netfilter.org>
References: <20181020094317.16011-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181020094317.16011-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

parameter net of nf_flow_table_cleanup() is not used.
So that it can be removed.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 2 +-
 net/netfilter/nf_flow_table_core.c    | 2 +-
 net/netfilter/nft_flow_offload.c      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 0e355f4a3d76..77e2761d4f2f 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -99,7 +99,7 @@ int nf_flow_table_iterate(struct nf_flowtable *flow_table,
 			  void (*iter)(struct flow_offload *flow, void *data),
 			  void *data);
 
-void nf_flow_table_cleanup(struct net *net, struct net_device *dev);
+void nf_flow_table_cleanup(struct net_device *dev);
 
 int nf_flow_table_init(struct nf_flowtable *flow_table);
 void nf_flow_table_free(struct nf_flowtable *flow_table);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 185c633b6872..a3cc2ef8a48a 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -483,7 +483,7 @@ static void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
 	flush_delayed_work(&flowtable->gc_work);
 }
 
-void nf_flow_table_cleanup(struct net *net, struct net_device *dev)
+void nf_flow_table_cleanup(struct net_device *dev)
 {
 	struct nf_flowtable *flowtable;
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index d6bab8c3cbb0..e82d9a966c45 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -201,7 +201,7 @@ static int flow_offload_netdev_event(struct notifier_block *this,
 	if (event != NETDEV_DOWN)
 		return NOTIFY_DONE;
 
-	nf_flow_table_cleanup(dev_net(dev), dev);
+	nf_flow_table_cleanup(dev);
 
 	return NOTIFY_DONE;
 }
-- 
2.11.0
