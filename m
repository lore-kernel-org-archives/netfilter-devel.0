From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf 3/3] netfilter: nf_tables: fix flowtable free
Date: Tue,  6 Feb 2018 02:22:27 +0100
Message-ID: <20180206012227.13716-3-pablo@netfilter.org>
References: <20180206012227.13716-1-pablo@netfilter.org>
Cc: nbd@nbd.name
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41784 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752154AbeBFBWj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Feb 2018 20:22:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4AB081EC2CB
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2018 02:22:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28169DA241
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2018 02:22:38 +0100 (CET)
In-Reply-To: <20180206012227.13716-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Every flow_offload entry is added into the table twice. Because of this,
rhashtable_free_and_destroy can't be used, since it would call kfree for
each flow_offload object twice.

This patch adds a call to nf_flow_table_iterate_cleanup() to schedule
removal of entries, then there is an explicitly invocation of the
garbage collector to clean up resources.

Based on patch from Felix Fietkau.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Felix: This is an alternate path to fix what you're reporting, it's based
	on your patch 1/2, but sets on the DYING flag, then there's an explicit
	call to the garbage collector. The reason for this is that rule of thumb
	is that entries should be always removed by the garbage collector,
	either by calling explicitly or implicitly. I think this simplifies the
	upcoming hardware offload support and it will allow us to introduce
	batching support from the garbage collector. Given adding/removing
	entries to hardware can be slow, we can amortize the cost by batching
	several add/delete commands.

 include/net/netfilter/nf_flow_table.h   |  2 ++
 net/ipv4/netfilter/nf_flow_table_ipv4.c |  1 +
 net/ipv6/netfilter/nf_flow_table_ipv6.c |  1 +
 net/netfilter/nf_flow_table.c           | 25 +++++++++++++++++++------
 net/netfilter/nf_flow_table_inet.c      |  1 +
 net/netfilter/nf_tables_api.c           |  9 ++-------
 6 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index ed49cd169ecf..020ae903066f 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -14,6 +14,7 @@ struct nf_flowtable_type {
 	struct list_head		list;
 	int				family;
 	void				(*gc)(struct work_struct *work);
+	void				(*free)(struct nf_flowtable *ft);
 	const struct rhashtable_params	*params;
 	nf_hookfn			*hook;
 	struct module			*owner;
@@ -98,6 +99,7 @@ int nf_flow_table_iterate(struct nf_flowtable *flow_table,
 
 void nf_flow_table_cleanup(struct net *net, struct net_device *dev);
 
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
index 04c08f6b9015..c17f1af42daa 100644
--- a/net/netfilter/nf_flow_table.c
+++ b/net/netfilter/nf_flow_table.c
@@ -232,19 +232,16 @@ static inline bool nf_flow_is_dying(const struct flow_offload *flow)
 	return flow->flags & FLOW_OFFLOAD_DYING;
 }
 
-void nf_flow_offload_work_gc(struct work_struct *work)
+static int nf_flow_offload_gc_step(struct nf_flowtable *flow_table)
 {
 	struct flow_offload_tuple_rhash *tuplehash;
-	struct nf_flowtable *flow_table;
 	struct rhashtable_iter hti;
 	struct flow_offload *flow;
 	int err;
 
-	flow_table = container_of(work, struct nf_flowtable, gc_work.work);
-
 	err = rhashtable_walk_init(&flow_table->rhashtable, &hti, GFP_KERNEL);
 	if (err)
-		goto schedule;
+		return 0;
 
 	rhashtable_walk_start(&hti);
 
@@ -270,7 +267,16 @@ void nf_flow_offload_work_gc(struct work_struct *work)
 out:
 	rhashtable_walk_stop(&hti);
 	rhashtable_walk_exit(&hti);
-schedule:
+
+	return 1;
+}
+
+void nf_flow_offload_work_gc(struct work_struct *work)
+{
+	struct nf_flowtable *flow_table;
+
+	flow_table = container_of(work, struct nf_flowtable, gc_work.work);
+	nf_flow_offload_gc_step(flow_table);
 	queue_delayed_work(system_power_efficient_wq, &flow_table->gc_work, HZ);
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_work_gc);
@@ -449,5 +455,12 @@ void nf_flow_table_cleanup(struct net *net, struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
 
+void nf_flow_table_free(struct nf_flowtable *flow_table)
+{
+	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
+	WARN_ON(!nf_flow_offload_gc_step(flow_table));
+}
+EXPORT_SYMBOL_GPL(nf_flow_table_free);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
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
index 07dd1fac78a8..8b9fe30de0cd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5399,17 +5399,12 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
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
+	rhashtable_destroy(&flowtable->data.rhashtable);
 	module_put(flowtable->data.type->owner);
 }
 
-- 
2.11.0

