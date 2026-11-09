Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794222171;
	b=1TEkeiIYnIhSBlNPO6oiDouCuhrX+TnW8I3XBXCZzoZicINg8xagrVesgNBrEFJd7TeR
	 h0JEJxahNSIR77Kun2WpVgFqosJTmA4xsvCwyJYJLHjxqgg54az7qPifrpgb6x/JDelKb
	 oaxNWdV0lU1hqvwX3SVfjq33V6nnp5K8iL2ysgxOqakIAhSphVVSettgelIMoTPQg2aHs
	 64RCo0Txa4spbH3Hfrcz3frpZu6hh/sKZfEcVrrZshV/TqQ/ciC4O44CubnLPmLEVljvH
	 7JT80zYeamLZFJgZxvnJ42QsEPWzWIWdTrloEIsOal2F2D5GsbbndeLMapqSwreRyFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794222171;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=uS7zngYGu52tla0GB1ur+GzC40CUKW3c4HDJCWDUomc=;
	b=UCuriHjtFQJf6tnfSrSbCBfHoV62HCfkju+RlCklB6uqqXFJbudafFqWS5azomiQoSZZ
	 dXuG4UieC18PURqUKc8gHOLDZrex1cHyM0Ixi+vNQ7HWEERhPqNugYqsT0bg6d9RdDZXR
	 7i5dJDyObjwuBHkIiJK4SzkgKQY6iVqjKY59oOI5hJtcpHWt16/WsweXgHh/Ww+zt2KsW
	 xhFiTzTzuAtX8x3+l2H67fHYbEgus6lWlp7y1eB3DXmXLUR9WNgewfain6VWhQOiczTbq
	 nMoYmNy0XI/dbeF4JiMIzsz3TE7pMSxts9gGqNRw30bc+7rQDaC7prFGECGEo6pt2Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=PetCxAj7;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6321B606A323
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2026 11:02:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6321B606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=PetCxAj7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794222168;
	bh=uS7zngYGu52tla0GB1ur+GzC40CUKW3c4HDJCWDUomc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=PetCxAj7pVzBMmEdcSPzlXpgG+44g5kepQ1slt17tM9Ml0OOVNdR1k4EfyGKcKIwO
	 J+HZ2maN1BCruayW27nmevC4Jdv9K6daRyrYS+TZa9dUTu1BjDyRrSuIO3LHjfE1MV
	 XzaJWFHnlYfwdG3kdec1wO+qXhrnOtAJIFZOO6gDZaDJVuDPOEvcqwuWjdO1C87e/S
	 pQ3RTvs+fVmgNqvoF+LZHhbbzlOsDDPlRoiJiU35lYUFnUbwKG5Mpt8lW8Es0T3x8e
	 yEfC3mmBrm5w23aKjkf5K0sJRH8x3fo8nWIIKHaOJwYt+/57yZrZQAWAkImOsT9weO
	 2xRPxC7b4RB2A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3E30060079
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2026 12:02:48 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/2] netfilter: nf_tables: perform unbind callback on hook release
Date: Mon,  9 Nov 2026 12:02:42 +0100
Message-ID: <20261109110242.1649817-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109110242.1649817-1-pablo@netfilter.org>
References: <20261109110242.1649817-1-pablo@netfilter.org>
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
by performing the flow_block unbind command from the destroy path, right
before the hook is released.

Fixes: 13210fc63f35 ("netfilter: nf_tables: imbalance in flowtable binding")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 63 +++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d3c04a71c924..0d50540fb04c 100644
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
@@ -9830,10 +9856,9 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 				continue;
 
 			/* flow_offload_netdev_event() cleans up entries for us. */
-			if (!(hook->flags & NFT_HOOK_UNREGISTERED)) {
-				nft_unregister_flowtable_ops(dev_net(dev),
-							     flowtable, ops);
-			}
+			if (!(hook->flags & NFT_HOOK_UNREGISTERED))
+				nft_unregister_flowtable_ops(dev_net(dev), ops);
+
 			list_del_rcu(&ops->list);
 			kfree_rcu(ops, rcu);
 			break;
@@ -11311,10 +11336,12 @@ static void nf_tables_abort_release(struct nft_trans *trans)
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

