From: Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 1/2] netfilter: nf_tables: fix flowtable free
Date: Mon,  5 Feb 2018 19:02:33 +0100
Message-ID: <20180205180234.26487-1-nbd@nbd.name>
Cc: netdev@vger.kernel.org, davem@davemloft.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50490 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753028AbeBESCj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Feb 2018 13:02:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Every flow_offload entry is added into the table twice. Because of this,
rhashtable_free_and_destroy can't be used, since it would call kfree for
each flow_offload object twice.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/netfilter/nf_flow_table.h   |  2 ++
 net/ipv4/netfilter/nf_flow_table_ipv4.c |  1 +
 net/ipv6/netfilter/nf_flow_table_ipv6.c |  1 +
 net/netfilter/nf_flow_table.c           | 15 +++++++++++++++
 net/netfilter/nf_flow_table_inet.c      |  1 +
 net/netfilter/nf_tables_api.c           |  8 +-------
 6 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index b22b22082733..67c61bda6a46 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -14,6 +14,7 @@ struct nf_flowtable_type {
 	struct list_head		list;
 	int				family;
 	void				(*gc)(struct work_struct *work);
+	void				(*free)(struct nf_flowtable *table);
 	const struct rhashtable_params	*params;
 	nf_hookfn			*hook;
 	struct module			*owner;
@@ -95,6 +96,7 @@ struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_t
 int nf_flow_table_iterate(struct nf_flowtable *flow_table,
 			  void (*iter)(struct flow_offload *flow, void *data),
 			  void *data);
+void nf_flow_table_free(struct nf_flowtable *flow_table);
 void nf_flow_offload_work_gc(struct work_struct *work);
 extern const struct rhashtable_params nf_flow_offload_rhash_params;
 
diff --git a/net/ipv4/netfilter/nf_flow_table_ipv4.c b/net/ipv4/netfilter/nf_flow_table_ipv4.c
index b2d01eb25f2c..25d2975da156 100644
--- a/net/ipv4/netfilter/nf_flow_table_ipv4.c
+++ b/net/ipv4/netfilter/nf_flow_table_ipv4.c
@@ -260,6 +260,7 @@ static struct nf_flowtable_type flowtable_ipv4 = {
 	.family		= NFPROTO_IPV4,
 	.params		= &nf_flow_offload_rhash_params,
 	.gc		= nf_flow_offload_work_gc,
+	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_ip_hook,
 	.owner		= THIS_MODULE,
 };
diff --git a/net/ipv6/netfilter/nf_flow_table_ipv6.c b/net/ipv6/netfilter/nf_flow_table_ipv6.c
index fff21602875a..d346705d6ee6 100644
--- a/net/ipv6/netfilter/nf_flow_table_ipv6.c
+++ b/net/ipv6/netfilter/nf_flow_table_ipv6.c
@@ -253,6 +253,7 @@ static struct nf_flowtable_type flowtable_ipv6 = {
 	.family		= NFPROTO_IPV6,
 	.params		= &nf_flow_offload_rhash_params,
 	.gc		= nf_flow_offload_work_gc,
+	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_ipv6_hook,
 	.owner		= THIS_MODULE,
 };
diff --git a/net/netfilter/nf_flow_table.c b/net/netfilter/nf_flow_table.c
index 2f5099cb85b8..20f86091ab98 100644
--- a/net/netfilter/nf_flow_table.c
+++ b/net/netfilter/nf_flow_table.c
@@ -221,6 +221,21 @@ int nf_flow_table_iterate(struct nf_flowtable *flow_table,
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_iterate);
 
+static void
+__nf_flow_offload_free(struct flow_offload *flow, void *data)
+{
+	struct nf_flowtable *flow_table = data;
+
+	flow_offload_del(flow_table, flow);
+}
+
+void nf_flow_table_free(struct nf_flowtable *flow_table)
+{
+	nf_flow_table_iterate(flow_table, __nf_flow_offload_free, flow_table);
+	rhashtable_destroy(&flow_table->rhashtable);
+}
+EXPORT_SYMBOL_GPL(nf_flow_table_free);
+
 static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 {
 	return (__s32)(flow->timeout - (u32)jiffies) <= 0;
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 281209aeba8f..375a1881d93d 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -24,6 +24,7 @@ static struct nf_flowtable_type flowtable_inet = {
 	.family		= NFPROTO_INET,
 	.params		= &nf_flow_offload_rhash_params,
 	.gc		= nf_flow_offload_work_gc,
+	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_inet_hook,
 	.owner		= THIS_MODULE,
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0791813a1e7d..a6c4747c7d5d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5399,17 +5399,11 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 
-static void nft_flowtable_destroy(void *ptr, void *arg)
-{
-	kfree(ptr);
-}
-
 static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 {
 	cancel_delayed_work_sync(&flowtable->data.gc_work);
 	kfree(flowtable->name);
-	rhashtable_free_and_destroy(&flowtable->data.rhashtable,
-				    nft_flowtable_destroy, NULL);
+	flowtable->data.type->free(&flowtable->data);
 	module_put(flowtable->data.type->owner);
 }
 
-- 
2.14.2

