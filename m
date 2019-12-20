Return-Path: <SRS0=tkBW=2K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91EF7C2D0D2
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 07:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71F92227BF
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 07:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfLTHAm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 02:00:42 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:32120 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfLTHAm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 02:00:42 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id AA00541949;
        Fri, 20 Dec 2019 15:00:33 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_flow_table: clean up entries in hardware
Date:   Fri, 20 Dec 2019 15:00:33 +0800
Message-Id: <1576825233-3041-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVNTElCQkJDTkNDTk1JWVdZKFlBSU
        I3V1ktWUFJV1kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MjI6Sjo*PjgzTEwIHgNDShVC
        Hw0aCjpVSlVKTkxNQ0lOSUhIQ0tPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU1CSkk3Bg++
X-HM-Tid: 0a6f221ba1272086kuqyaa00541949
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Flowtable delete will call the UNBIND setup before cleanup flows with
nf_flow_table_free. First it make UNBIND call after the free operation

But only UNBIND setup before flows cleanup can't guarantee the flows 
delete in the hardware. The real delete in another  nf_flow_offload_work. 
So This patch add a refcont for the flow_block to make sure the hardware
flows clean before UNBIND setup.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---

Test this patch work with mlx driver.

 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_core.c    |  4 ++++
 net/netfilter/nf_flow_table_offload.c |  3 +++
 net/netfilter/nf_tables_api.c         | 28 +++++++++++++++++-----------
 4 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f0897b3..bb66f13 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -44,6 +44,7 @@ struct nf_flowtable {
 	struct delayed_work		gc_work;
 	unsigned int			flags;
 	struct flow_block		flow_block;
+	refcount_t			block_ref;
 	possible_net_t			net;
 };
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9889d52..e5a92369 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -508,6 +508,8 @@ int nf_flow_table_init(struct nf_flowtable *flowtable)
 
 	queue_delayed_work(system_power_efficient_wq,
 			   &flowtable->gc_work, HZ);
+
+	refcount_set(&flowtable->block_ref, 1);
 
 	mutex_lock(&flowtable_lock);
 	list_add(&flowtable->list, &flowtables);
@@ -560,6 +562,8 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
 	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
 	rhashtable_destroy(&flow_table->rhashtable);
+	while (refcount_read(&flow_table->block_ref) > 1)
+		msleep(100);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 949345f..4b9f81d 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -839,6 +839,7 @@ static void flow_offload_work_handler(struct work_struct *work)
 		default:
 			WARN_ON_ONCE(1);
 		}
+		refcount_dec(&offload->flowtable->block_ref);
 		list_del(&offload->list);
 		kfree(offload);
 	}
@@ -846,6 +847,8 @@ static void flow_offload_work_handler(struct work_struct *work)
 
 static void flow_offload_queue_work(struct flow_offload_work *offload)
 {
+	refcount_inc(&offload->flowtable->block_ref);
+
 	spin_lock_bh(&flow_offload_pending_list_lock);
 	list_add_tail(&offload->list, &flow_offload_pending_list);
 	spin_unlock_bh(&flow_offload_pending_list_lock);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 944e454..b317e57 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5978,20 +5978,23 @@ static const struct nf_flowtable_type *__nft_flowtable_type_get(u8 family)
 
 static void nft_unregister_flowtable_hook(struct net *net,
 					  struct nft_flowtable *flowtable,
-					  struct nft_hook *hook)
+					  struct nft_hook *hook,
+					  bool unbind)
 {
 	nf_unregister_net_hook(net, &hook->ops);
-	flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
-				    FLOW_BLOCK_UNBIND);
+	if (unbind)
+		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
+					    FLOW_BLOCK_UNBIND);
 }
 
 static void nft_unregister_flowtable_net_hooks(struct net *net,
-					       struct nft_flowtable *flowtable)
+					       struct nft_flowtable *flowtable,
+					       bool unbind)
 {
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, &flowtable->hook_list, list)
-		nft_unregister_flowtable_hook(net, flowtable, hook);
+		nft_unregister_flowtable_hook(net, flowtable, hook, unbind);
 }
 
 static int nft_register_flowtable_net_hooks(struct net *net,
@@ -6037,7 +6040,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 		if (i-- <= 0)
 			break;
 
-		nft_unregister_flowtable_hook(net, flowtable, hook);
+		nft_unregister_flowtable_hook(net, flowtable, hook, true);
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
 	}
@@ -6145,7 +6148,7 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 	return 0;
 err5:
 	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
-		nft_unregister_flowtable_hook(net, flowtable, hook);
+		nft_unregister_flowtable_hook(net, flowtable, hook, true);
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
 	}
@@ -6441,12 +6444,14 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 {
 	struct nft_hook *hook, *next;
 
+	flowtable->data.type->free(&flowtable->data);
 	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
+		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
+					    FLOW_BLOCK_UNBIND);
 		list_del_rcu(&hook->list);
 		kfree(hook);
 	}
 	kfree(flowtable->name);
-	flowtable->data.type->free(&flowtable->data);
 	module_put(flowtable->data.type->owner);
 	kfree(flowtable);
 }
@@ -6490,7 +6495,8 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
 		if (hook->ops.dev != dev)
 			continue;
 
-		nft_unregister_flowtable_hook(dev_net(dev), flowtable, hook);
+		nft_unregister_flowtable_hook(dev_net(dev), flowtable, hook,
+					      true);
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
 		break;
@@ -7174,7 +7180,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 						   nft_trans_flowtable(trans),
 						   NFT_MSG_DELFLOWTABLE);
 			nft_unregister_flowtable_net_hooks(net,
-					nft_trans_flowtable(trans));
+					nft_trans_flowtable(trans), false);
 			break;
 		}
 	}
@@ -7318,7 +7324,7 @@ static int __nf_tables_abort(struct net *net)
 			trans->ctx.table->use--;
 			list_del_rcu(&nft_trans_flowtable(trans)->list);
 			nft_unregister_flowtable_net_hooks(net,
-					nft_trans_flowtable(trans));
+					nft_trans_flowtable(trans), true);
 			break;
 		case NFT_MSG_DELFLOWTABLE:
 			trans->ctx.table->use++;
-- 
1.8.3.1

