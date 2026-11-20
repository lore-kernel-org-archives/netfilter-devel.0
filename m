Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795134626;
	b=oz4NS3SMH9UwwU854kjovU56pLOHlu+TDZGOLzcwcTzLsYXVT8kfcTwDUOdzMCHbnhEz
	 zCM/P7SjP573qzNQgWsFnDcP6n0qY036CmlLTuBQcg0ZT7U62u/z19kYBvG1bK7zG7TM+
	 ZnefSNuM9529KwE8H4ZHFFIpi+TcQEmhDK9VApQY0sAwvxUpTKpe1v37Oym5C6qytwg0B
	 2Q+jxpeVXiziiTBgpkORNj8hzYlSw91ZzQndIh390sOOL0iz1Cvs69tZqKRcKNxT/1UgB
	 fH09G81TyGydf9OnqyVj7cK4QgrsxuQJahHnwS+MXUO+bvl/zVgKfe0+sXDgvBjXLFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795134626;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=yD3LqA13igTgWhCk5BF69zeN2lO541b1eW4ajgTd5Mk=;
	b=NtQvZsjJNQUoRSBbPwQg6j0L0kBlsZhCNohUwsp2ti6Nwaa4MKNaDAHqJZ2DkWSsJm0c
	 Z2XxNqrfTF6aIYw/xS7+OgktltupZLqDc75MRNWpP9DfP+Gut25ODuc2xsWo8empH7QTC
	 qykBP5xe2vZcRga4iq9i7R/7dbbenza3dZx1uBrD8NkDdxiVHTOSP7BEhGUV2BXw8r1Kx
	 XHvh6Cv/lgB/9xtIVWR7Rtho+nKbZ1shGhgg6tnl25T408ljqz7AO9HNMrBcJ3z3h32+0
	 rSuM9gfbvxhQyZJaRVXbT/sPDqfBZ0LyYW+Z3UeRojskzQpezN9ru1fGG1KMHY+31Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=NKtijHu8;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37CC606A336
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 00:30:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E37CC606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=NKtijHu8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795134623;
	bh=yD3LqA13igTgWhCk5BF69zeN2lO541b1eW4ajgTd5Mk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NKtijHu8Plsv7HzYlKRLs8hgyAqhAkh2OB1dEmABKl7Nuh2J3CpwTgeO069vagvc7
	 pf7jYuhhee71wFbnma3EaANkQkGE/LhMcOzoaNcwaJG16/0K+jVBROtFlBqZs/urd5
	 gJyM4kIcCCAoSDOhAzgV6+C5LorMLkeYAO3M7GqkzMAvmHH4nOvkJy/5WIejdv6TZa
	 p7CafGTx7qwa4Rp7M/JxZOnOLEHM7IHSy6eOvM9r6dnt+s0JudJC4lIMJ0ta/0r0/r
	 pRUdmR7Xt0RNHT7/kYPlTdDlUUF/4bJXc2ZNqYHeGISTAvwqQdPNtr2TdTABc4S4k8
	 78JeA/lbOgOpw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EFBF26008A
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 01:30:22 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v4 3/3] netfilter: nf_tables: unbind flowtable on hook release
Date: Fri, 20 Nov 2026 01:30:13 +0100
Message-ID: <20261120003013.3441877-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120003013.3441877-1-pablo@netfilter.org>
References: <20261120003013.3441877-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 13210fc63f35 ("netfilter: nf_tables: imbalance in flowtable
binding") breaks hardware offload by unbinding the flow_block too early,
this results in leaving entries in the hardware. Any pending offload
work will be ignored because there is no flow_block anymore in place.

This patch restores the strategy followed by commit 5acab91458ce
("netfilter: nf_tables: unbind callbacks from flowtable destroy path")
by unregistering the hook first, then unbind the flow_block from the
error and destroy paths, right before the hook is released.

Fixes: 13210fc63f35 ("netfilter: nf_tables: imbalance in flowtable binding")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: - add missing FLOW_BLOCK_UNBIND in flowtable event handler
    - update patch subject and description

 net/netfilter/nf_tables_api.c | 62 ++++++++++++++++++++++++++---------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 24db948b851b..ecb23bb1df3b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -380,6 +380,22 @@ static void nft_netdev_hook_unlink_free_rcu(struct nft_hook *hook)
 	nft_netdev_hook_free_rcu(hook);
 }
 
+static void nft_flowtable_hook_unlink_free_rcu(struct nft_flowtable *flowtable,
+					       struct nft_hook *hook)
+{
+	struct nf_hook_ops *ops;
+
+	/* This unbind command needs to come this late, otherwise offload
+	 * worker finds no flow_block and entries are not cleaned up from
+	 * hardware.
+	 */
+	list_for_each_entry(ops, &hook->ops_list, list) {
+		flowtable->data.type->setup(&flowtable->data, ops->dev,
+					    FLOW_BLOCK_UNBIND);
+	}
+	nft_netdev_hook_unlink_free_rcu(hook);
+}
+
 static void nft_trans_hook_destroy(struct nft_trans_hook *trans_hook)
 {
 	list_del(&trans_hook->list);
@@ -9026,12 +9042,9 @@ nft_flowtable_type_get(struct net *net, u8 family)
 
 /* Only called from error and netdev event paths. */
 static void nft_unregister_flowtable_ops(struct net *net,
-					 struct nft_flowtable *flowtable,
 					 struct nf_hook_ops *ops)
 {
 	nf_unregister_net_hook(net, ops);
-	flowtable->data.type->setup(&flowtable->data, ops->dev,
-				    FLOW_BLOCK_UNBIND);
 }
 
 static void __nft_unregister_flowtable_net_hooks(struct net *net,
@@ -9043,7 +9056,7 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		list_for_each_entry(ops, &hook->ops_list, list)
-			nft_unregister_flowtable_ops(net, flowtable, ops);
+			nft_unregister_flowtable_ops(net, ops);
 
 		hook->flags |= NFT_HOOK_UNREGISTERED;
 	}
@@ -9114,7 +9127,9 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			if (i-- <= 0)
 				break;
 
-			nft_unregister_flowtable_ops(net, flowtable, ops);
+			nft_unregister_flowtable_ops(net, ops);
+			flowtable->data.type->setup(&flowtable->data, ops->dev,
+						    FLOW_BLOCK_UNBIND);
 		}
 		nft_netdev_hook_unlink_free_rcu(hook);
 	}
@@ -9141,9 +9156,9 @@ static void nft_flowtable_unregister_trans_hook(struct net *net,
 	list_for_each_entry_safe(trans_hook, next, hook_list, list) {
 		hook = trans_hook->hook;
 		list_for_each_entry(ops, &hook->ops_list, list)
-			nft_unregister_flowtable_ops(net, flowtable, ops);
+			nft_unregister_flowtable_ops(net, ops);
 
-		nft_netdev_hook_unlink_free_rcu(hook);
+		nft_flowtable_hook_unlink_free_rcu(flowtable, trans_hook->hook);
 		nft_trans_hook_destroy(trans_hook);
 	}
 }
@@ -9229,9 +9244,11 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 err_flowtable_update_hook:
 	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
 		if (unregister) {
-			list_for_each_entry(ops, &hook->ops_list, list)
-				nft_unregister_flowtable_ops(ctx->net,
-							     flowtable, ops);
+			list_for_each_entry(ops, &hook->ops_list, list) {
+				nft_unregister_flowtable_ops(ctx->net, ops);
+				flowtable->data.type->setup(&flowtable->data, ops->dev,
+							    FLOW_BLOCK_UNBIND);
+			}
 		}
 		nft_netdev_hook_unlink_free_rcu(hook);
 	}
@@ -9752,10 +9769,19 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 
+static void nft_flowtable_hooks_destroy(struct nft_flowtable *flowtable,
+					struct list_head *hook_list)
+{
+	struct nft_hook *hook, *next;
+
+	list_for_each_entry_safe(hook, next, hook_list, list)
+		nft_flowtable_hook_unlink_free_rcu(flowtable, hook);
+}
+
 static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 {
 	flowtable->data.type->free(&flowtable->data);
-	nft_hooks_destroy(&flowtable->hook_list);
+	nft_flowtable_hooks_destroy(flowtable, &flowtable->hook_list);
 	kfree(flowtable->name);
 	module_put(flowtable->data.type->owner);
 	kfree(flowtable);
@@ -9831,9 +9857,11 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 
 			/* flow_offload_netdev_event() cleans up entries for us. */
 			if (!(hook->flags & NFT_HOOK_UNREGISTERED)) {
-				nft_unregister_flowtable_ops(dev_net(dev),
-							     flowtable, ops);
+				nft_unregister_flowtable_ops(dev_net(dev), ops);
+				flowtable->data.type->setup(&flowtable->data, ops->dev,
+							    FLOW_BLOCK_UNBIND);
 			}
+
 			list_del_rcu(&ops->list);
 			kfree_rcu(ops, rcu);
 			break;
@@ -11313,10 +11341,12 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nft_obj_destroy(&ctx, nft_trans_obj(trans));
 		break;
 	case NFT_MSG_NEWFLOWTABLE:
-		if (nft_trans_flowtable_update(trans))
-			nft_hooks_destroy(&nft_trans_flowtable_hooks(trans));
-		else
+		if (nft_trans_flowtable_update(trans)) {
+			nft_flowtable_hooks_destroy(nft_trans_flowtable(trans),
+						    &nft_trans_flowtable_hooks(trans));
+		} else {
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
+		}
 		break;
 	}
 	kfree(trans);
-- 
2.47.3

