Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B03C61D92
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234682AbjKUM2e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjKUM2e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:28:34 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6051D126;
        Tue, 21 Nov 2023 04:28:30 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1r5Prh-0005BP-2E; Tue, 21 Nov 2023 13:28:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     lorenzo@kernel.org, <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/8] netfilter: nf_flowtable: replace init callback with a create one
Date:   Tue, 21 Nov 2023 13:27:45 +0100
Message-ID: <20231121122800.13521-3-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231121122800.13521-1-fw@strlen.de>
References: <20231121122800.13521-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Let the flowtable core allocate the nf_flowtable structure itself.
While at it, move the net and type assignment into the flowtable core.

The returned nf_flowtable pointer can still be released with plain kfree(),
this will be changed in a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_flow_table.h |  5 +++--
 net/netfilter/nf_flow_table_core.c    | 19 ++++++++++++++-----
 net/netfilter/nf_flow_table_inet.c    |  6 +++---
 net/netfilter/nf_tables_api.c         |  8 +-------
 net/sched/act_ct.c                    | 12 ++++--------
 5 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 36351e441316..d365eabd4a3c 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -52,7 +52,8 @@ struct nf_flow_rule {
 struct nf_flowtable_type {
 	struct list_head		list;
 	int				family;
-	int				(*init)(struct nf_flowtable *ft);
+	struct nf_flowtable *		(*create)(struct net *net,
+						  const struct nf_flowtable_type *type);
 	bool				(*gc)(const struct flow_offload *flow);
 	int				(*setup)(struct nf_flowtable *ft,
 						 struct net_device *dev,
@@ -279,7 +280,7 @@ void nf_flow_table_gc_cleanup(struct nf_flowtable *flowtable,
 			      struct net_device *dev);
 void nf_flow_table_cleanup(struct net_device *dev);
 
-int nf_flow_table_init(struct nf_flowtable *flow_table);
+struct nf_flowtable *nf_flow_table_create(struct net *net, const struct nf_flowtable_type *type);
 void nf_flow_table_free(struct nf_flowtable *flow_table);
 
 void flow_offload_teardown(struct flow_offload *flow);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 920a5a29ae1d..375fc9c24149 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -531,29 +531,38 @@ void nf_flow_dnat_port(const struct flow_offload *flow, struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(nf_flow_dnat_port);
 
-int nf_flow_table_init(struct nf_flowtable *flowtable)
+struct nf_flowtable *nf_flow_table_create(struct net *net, const struct nf_flowtable_type *type)
 {
+	struct nf_flowtable *flowtable = kzalloc(sizeof(*flowtable), GFP_KERNEL_ACCOUNT);
 	int err;
 
+	if (!flowtable)
+		return NULL;
+
 	INIT_DELAYED_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
 	flow_block_init(&flowtable->flow_block);
 	init_rwsem(&flowtable->flow_block_lock);
 
 	err = rhashtable_init(&flowtable->rhashtable,
 			      &nf_flow_offload_rhash_params);
-	if (err < 0)
-		return err;
+	if (err < 0) {
+		kfree(flowtable);
+		return NULL;
+	}
 
 	queue_delayed_work(system_power_efficient_wq,
 			   &flowtable->gc_work, HZ);
 
+	write_pnet(&flowtable->net, net);
+	flowtable->type = type;
+
 	mutex_lock(&flowtable_lock);
 	list_add(&flowtable->list, &flowtables);
 	mutex_unlock(&flowtable_lock);
 
-	return 0;
+	return flowtable;
 }
-EXPORT_SYMBOL_GPL(nf_flow_table_init);
+EXPORT_SYMBOL_GPL(nf_flow_table_create);
 
 static void nf_flow_table_do_cleanup(struct nf_flowtable *flow_table,
 				     struct flow_offload *flow, void *data)
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 9505f9d188ff..7b20a073573d 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -63,7 +63,7 @@ static int nf_flow_rule_route_inet(struct net *net,
 
 static struct nf_flowtable_type flowtable_inet = {
 	.family		= NFPROTO_INET,
-	.init		= nf_flow_table_init,
+	.create		= nf_flow_table_create,
 	.setup		= nf_flow_table_offload_setup,
 	.action		= nf_flow_rule_route_inet,
 	.free		= nf_flow_table_free,
@@ -73,7 +73,7 @@ static struct nf_flowtable_type flowtable_inet = {
 
 static struct nf_flowtable_type flowtable_ipv4 = {
 	.family		= NFPROTO_IPV4,
-	.init		= nf_flow_table_init,
+	.create		= nf_flow_table_create,
 	.setup		= nf_flow_table_offload_setup,
 	.action		= nf_flow_rule_route_ipv4,
 	.free		= nf_flow_table_free,
@@ -83,7 +83,7 @@ static struct nf_flowtable_type flowtable_ipv4 = {
 
 static struct nf_flowtable_type flowtable_ipv6 = {
 	.family		= NFPROTO_IPV6,
-	.init		= nf_flow_table_init,
+	.create		= nf_flow_table_create,
 	.setup		= nf_flow_table_offload_setup,
 	.action		= nf_flow_rule_route_ipv6,
 	.free		= nf_flow_table_free,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ee0de8d9b49c..cce82fef4488 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8400,7 +8400,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 		goto err2;
 	}
 
-	flowtable->ft = kzalloc(sizeof(*flowtable->ft), GFP_KERNEL_ACCOUNT);
+	flowtable->ft = type->create(net, type);
 	if (!flowtable->ft) {
 		err = -ENOMEM;
 		goto err3;
@@ -8415,12 +8415,6 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 		}
 	}
 
-	write_pnet(&flowtable->ft->net, net);
-	flowtable->ft->type = type;
-	err = type->init(flowtable->ft);
-	if (err < 0)
-		goto err3;
-
 	err = nft_flowtable_parse_hook(&ctx, nla, &flowtable_hook, flowtable,
 				       extack, true);
 	if (err < 0)
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 2a6362becd71..80869cc52348 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -313,17 +313,13 @@ static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
 	if (err)
 		goto err_insert;
 
-	ct_ft->nf_ft = kzalloc(sizeof(*ct_ft->nf_ft), GFP_KERNEL);
+	ct_ft->nf_ft->type = &flowtable_ct;
+	ct_ft->nf_ft = nf_flow_table_create(net, &flowtable_ct);
 	if (!ct_ft->nf_ft)
-		goto err_alloc;
+		goto err_create;
 
-	ct_ft->nf_ft->type = &flowtable_ct;
 	ct_ft->nf_ft->flags |= NF_FLOWTABLE_HW_OFFLOAD |
 			       NF_FLOWTABLE_COUNTER;
-	err = nf_flow_table_init(ct_ft->nf_ft);
-	if (err)
-		goto err_init;
-	write_pnet(&ct_ft->nf_ft->net, net);
 
 	__module_get(THIS_MODULE);
 out_unlock:
@@ -333,7 +329,7 @@ static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
 
 	return 0;
 
-err_init:
+err_create:
 	rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
 	kfree(ct_ft->nf_ft);
 err_insert:
-- 
2.41.0

