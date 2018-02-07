From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/11] netfilter: nft_flow_offload: move flowtable cleanup routines to nf_flow_table
Date: Wed,  7 Feb 2018 18:42:26 +0100
Message-ID: <20180207174229.4098-9-pablo@netfilter.org>
References: <20180207174229.4098-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46996 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754268AbeBGRmo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 12:42:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EA7033066B2
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 18:42:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DB9FADA3A0
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 18:42:42 +0100 (CET)
In-Reply-To: <20180207174229.4098-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Move the flowtable cleanup routines to nf_flow_table and expose the
nf_flow_table_cleanup() helper function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  3 +++
 net/netfilter/nf_flow_table.c         | 24 ++++++++++++++++++++++++
 net/netfilter/nft_flow_offload.c      | 19 +------------------
 3 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index b22b22082733..ed49cd169ecf 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -95,6 +95,9 @@ struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_t
 int nf_flow_table_iterate(struct nf_flowtable *flow_table,
 			  void (*iter)(struct flow_offload *flow, void *data),
 			  void *data);
+
+void nf_flow_table_cleanup(struct net *net, struct net_device *dev);
+
 void nf_flow_offload_work_gc(struct work_struct *work);
 extern const struct rhashtable_params nf_flow_offload_rhash_params;
 
diff --git a/net/netfilter/nf_flow_table.c b/net/netfilter/nf_flow_table.c
index 2f5099cb85b8..04c08f6b9015 100644
--- a/net/netfilter/nf_flow_table.c
+++ b/net/netfilter/nf_flow_table.c
@@ -4,6 +4,7 @@
 #include <linux/netfilter.h>
 #include <linux/rhashtable.h>
 #include <linux/netdevice.h>
+#include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
@@ -425,5 +426,28 @@ int nf_flow_dnat_port(const struct flow_offload *flow,
 }
 EXPORT_SYMBOL_GPL(nf_flow_dnat_port);
 
+static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
+{
+	struct net_device *dev = data;
+
+	if (dev && flow->tuplehash[0].tuple.iifidx != dev->ifindex)
+		return;
+
+	flow_offload_dead(flow);
+}
+
+static void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
+					  void *data)
+{
+	nf_flow_table_iterate(flowtable, nf_flow_table_do_cleanup, data);
+	flush_delayed_work(&flowtable->gc_work);
+}
+
+void nf_flow_table_cleanup(struct net *net, struct net_device *dev)
+{
+	nft_flow_table_iterate(net, nf_flow_table_iterate_cleanup, dev);
+}
+EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index e5c45c7ac02a..b65829b2be22 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -194,23 +194,6 @@ static struct nft_expr_type nft_flow_offload_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
-static void flow_offload_iterate_cleanup(struct flow_offload *flow, void *data)
-{
-	struct net_device *dev = data;
-
-	if (dev && flow->tuplehash[0].tuple.iifidx != dev->ifindex)
-		return;
-
-	flow_offload_dead(flow);
-}
-
-static void nft_flow_offload_iterate_cleanup(struct nf_flowtable *flowtable,
-					     void *data)
-{
-	nf_flow_table_iterate(flowtable, flow_offload_iterate_cleanup, data);
-	flush_delayed_work(&flowtable->gc_work);
-}
-
 static int flow_offload_netdev_event(struct notifier_block *this,
 				     unsigned long event, void *ptr)
 {
@@ -219,7 +202,7 @@ static int flow_offload_netdev_event(struct notifier_block *this,
 	if (event != NETDEV_DOWN)
 		return NOTIFY_DONE;
 
-	nft_flow_table_iterate(dev_net(dev), nft_flow_offload_iterate_cleanup, dev);
+	nf_flow_table_cleanup(dev_net(dev), dev);
 
 	return NOTIFY_DONE;
 }
-- 
2.11.0

