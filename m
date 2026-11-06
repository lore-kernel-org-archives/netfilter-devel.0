Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793973731;
	b=dEK9GKMfpWXMaG78UL6zY+fsfJFLlwpvVnpM7qT6haCSeGIOgs6yIMcDT6nwzLYs0iLf
	 +5xlw+E6UNG6BSf9FfE3FgVlwx6HJaXkeWD/cdUv9xra9D6LwziJ0T1XDmRwZpgJCzfD2
	 Ecs1zIZhKdgGH3NnyOUoaebUTKs0Py63B/yYho/0BkQM+CwmcLxbqp5s9X83aC4o/TzX0
	 7w5Xfj/oFcHwjdRTNYkWRKL0Ej9xw8QBHqUSjja8l7eo5PcvE6fOs3mAP8zHhEINdWcc8
	 P9QcKu8YIcNHg+qO9ZK6JoyUwD9VwpXBoJp7GZ5uJTHcl9cZ723TNpEwJxq16Xxq6kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793973731;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=GGw7qgCiVs4g/3TFeDD+QyFDg5vg6SQTVbdq0mgh2QE=;
	b=Tij1keQONjRBFNuODLG/JRNaNoWBH9V1T7op4/Ffhqn/c3pnQqwJsg9E84nCtKjaF45g
	 OTRxlT8nV/4mO718EhRB97GE2J68PXrVkSDCNoInMHqvnGJMaBiBMsZY+8FnCjUaem1pn
	 mnLqL5kpFJE1uF7FEL+fzwz0Yc4mYVHWV9NekTtPNaXicFKoS9tPqpXGjYbDjw7fOLp/f
	 LvUGdahxA0dKgbB0sZmEJI/GCUm2ZOuOZtOf2N1yMXhiBDWQbRMnRkRFcnB5JhyNV4we1
	 XOCzFoCpMj4UurHcGECUAK3jArpXmD25ktphEQrmXBTazmDPTPA+dDQT9THZAXGNk5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Jrc8N4hf;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FCE606EE8B
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 14:02:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69FCE606EE8B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Jrc8N4hf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793973728;
	bh=GGw7qgCiVs4g/3TFeDD+QyFDg5vg6SQTVbdq0mgh2QE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Jrc8N4hfwL6KatAkkklSaQh7EG48jUz9NfsnUFBDVRe+LmVHLPiwZoO+QFR9+ZA51
	 j5yUetcfX3FPOGLrkohBSOAgjhjxHOm6wez8lAHLqgXis7DndKJbKRIp12/g9y9mE7
	 nowCao4+MXzbXKvF14xw11DMZoHdW7s5tnlSHo3IeRW7J86CgmclttA8aVuvv1stPi
	 zujbRbACOhyErQ0003Tn49WLtu4V/6JcZhOITnSeERE5uM8DQ3GbA1QXtbauK1991p
	 CKQcKsNiFbijAdF2YoKT4gOKjzTm8Oh3gBFfwk8XiaBRK8FVVh/MkBayeuKVphJO/x
	 WezpRRN/prahQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8DD0A60076
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 15:02:08 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 2/2] netfilter: flowtable: perform unbind callback on hook release
Date: Fri,  6 Nov 2026 15:02:03 +0100
Message-ID: <20261106140203.1359749-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261106140203.1359749-1-pablo@netfilter.org>
References: <20261106140203.1359749-1-pablo@netfilter.org>
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
 net/netfilter/nf_tables_api.c | 82 +++++++++++++++++++++++------------
 1 file changed, 55 insertions(+), 27 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 34f766330838..f95f4da0f390 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -373,6 +373,23 @@ static void nft_netdev_hook_free_rcu(struct nft_hook *hook)
 	call_rcu(&hook->rcu, __nft_netdev_hook_free_rcu);
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
+	list_del_rcu(&hook->list);
+	nft_netdev_hook_free_rcu(hook);
+}
+
 static void nft_netdev_hook_unlink_free_rcu(struct nft_hook *hook)
 {
 	list_del_rcu(&hook->list);
@@ -9025,12 +9042,9 @@ nft_flowtable_type_get(struct net *net, u8 family)
 
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
@@ -9042,7 +9056,7 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		list_for_each_entry(ops, &hook->ops_list, list)
-			nft_unregister_flowtable_ops(net, flowtable, ops);
+			nft_unregister_flowtable_ops(net, ops);
 
 		hook->flags |= NFT_HOOK_UNREGISTERED;
 	}
@@ -9113,14 +9127,23 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			if (i-- <= 0)
 				break;
 
-			nft_unregister_flowtable_ops(net, flowtable, ops);
+			nft_unregister_flowtable_ops(net, ops);
 		}
-		nft_netdev_hook_unlink_free_rcu(hook);
+		nft_flowtable_hook_unlink_free_rcu(flowtable, hook);
 	}
 
 	return err;
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
 static void nft_hooks_destroy(struct list_head *hook_list)
 {
 	struct nft_hook *hook, *next;
@@ -9130,20 +9153,16 @@ static void nft_hooks_destroy(struct list_head *hook_list)
 }
 
 static void nft_flowtable_unregister_trans_hook(struct net *net,
-						struct nft_flowtable *flowtable,
 						struct list_head *hook_list)
 {
-	struct nft_trans_hook *trans_hook, *next;
+	struct nft_trans_hook *trans_hook;
 	struct nf_hook_ops *ops;
 	struct nft_hook *hook;
 
-	list_for_each_entry_safe(trans_hook, next, hook_list, list) {
+	list_for_each_entry(trans_hook, hook_list, list) {
 		hook = trans_hook->hook;
 		list_for_each_entry(ops, &hook->ops_list, list)
-			nft_unregister_flowtable_ops(net, flowtable, ops);
-
-		nft_netdev_hook_unlink_free_rcu(hook);
-		nft_trans_hook_destroy(trans_hook);
+			nft_unregister_flowtable_ops(net, ops);
 	}
 }
 
@@ -9229,10 +9248,9 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
 		if (unregister) {
 			list_for_each_entry(ops, &hook->ops_list, list)
-				nft_unregister_flowtable_ops(ctx->net,
-							     flowtable, ops);
+				nft_unregister_flowtable_ops(ctx->net, ops);
 		}
-		nft_netdev_hook_unlink_free_rcu(hook);
+		nft_flowtable_hook_unlink_free_rcu(flowtable, hook);
 	}
 
 	return err;
@@ -9358,7 +9376,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 	synchronize_rcu();
 	nft_trans_destroy(trans);
 err_flowtable_trans:
-	nft_hooks_destroy(&flowtable->hook_list);
+	nft_flowtable_hooks_destroy(flowtable, &flowtable->hook_list);
 err_flowtable_parse_hooks:
 	flowtable->data.type->free(&flowtable->data);
 err3:
@@ -9754,7 +9772,7 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 {
 	flowtable->data.type->free(&flowtable->data);
-	nft_hooks_destroy(&flowtable->hook_list);
+	nft_flowtable_hooks_destroy(flowtable, &flowtable->hook_list);
 	kfree(flowtable->name);
 	module_put(flowtable->data.type->owner);
 	kfree(flowtable);
@@ -9829,10 +9847,9 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
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
@@ -10296,8 +10313,18 @@ static void nft_commit_release(struct nft_trans *trans)
 		break;
 	case NFT_MSG_DELFLOWTABLE:
 	case NFT_MSG_DESTROYFLOWTABLE:
-		if (!nft_trans_flowtable_update(trans))
+		if (nft_trans_flowtable_update(trans)) {
+			struct nft_trans_hook *trans_hook, *next;
+
+			list_for_each_entry_safe(trans_hook, next,
+						 &nft_trans_flowtable_hooks(trans), list) {
+				nft_flowtable_hook_unlink_free_rcu(nft_trans_flowtable(trans),
+								   trans_hook->hook);
+				nft_trans_hook_destroy(trans_hook);
+			}
+		} else {
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
+		}
 		break;
 	}
 
@@ -11234,7 +11261,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 							   &nft_trans_flowtable_hooks(trans),
 							   trans->msg_type);
 				nft_flowtable_unregister_trans_hook(net,
-								    nft_trans_flowtable(trans),
 								    &nft_trans_flowtable_hooks(trans));
 			} else {
 				list_del_rcu(&nft_trans_flowtable(trans)->list);
@@ -11307,10 +11333,12 @@ static void nf_tables_abort_release(struct nft_trans *trans)
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

