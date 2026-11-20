Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795136128;
	b=TIw8keBcBwdVf+L1Xf7pFP69qzSvi0OUEEXPdklvCTJqVe7ljbHM/yJY/+IyIY2kgSUw
	 8OWABm+qeFJIf0vuu0Zmu9bd1/IOdItyjCvr+9yf1xGoQXBpp4tTAsKvOaK3pcI/0FvIS
	 X/xMwEAvsxI5hteLhxphB6lIS77U8iyntCFHaiTEAhfP7cap44Dwe3XVLR02IUocH1lhp
	 6eI0sdSmT5bahdFTWgbupDMj3OPWpftySKqYUYZ47dZ3aZZESH3J8O0G9Vh7oJlwchZUS
	 jjVqSkyvCzNuMDPpEgzc9lXkkZTQjn7nyoMBDZZOBs0YRsY71s+KGyhTYvCBUku41Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795136128;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=W/UzEk+ml7iKw5WQHRKXXmlormzxaUDY1axUiX6FEsA=;
	b=P4V0D76A5VlxoO1SEblkplOGh/K9OV9f00mKBN/Ow7raDhoSAv+MILBTPMw82MOw/Mys
	 z2jnV+4ZkPyw66Arl3TfKw86dsxtW6l2UI9ic0XanG2DHteQ2LquRi6TIg6IV0BCtAHzG
	 +mWGqarTOYHkfU6/V0ZpGD8Iz3PUACGPSSkWkdI1oBfNzJuq/Hsh3Az+HYwvz22/E0qA/
	 B7cPgJow5gmpSWapZP5WSux8BTY9+NV2HcQ5rs/gBXAebqI7k7UlBIFxyYHZYZd1FvDQZ
	 vB41kB2LNL/pJrvboyJFGf377LnqT7cpgs52QDagy9O09H9A6sjXzRXMNlJkzlCOfwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="T/RPlLfy";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02445606A325
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 00:55:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02445606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=T/RPlLfy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795136125;
	bh=W/UzEk+ml7iKw5WQHRKXXmlormzxaUDY1axUiX6FEsA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=T/RPlLfy02NkLmVUEiajQs3w3t7tSJbl3HiRpDnop2xAEtLQl2JCduIbMzLyljUIT
	 lT3KsFj1eg46Dy8LiDgsnVQG9zX3lC5EcxiYJYPDhjIqut5HLSuhebTtQl+fPpeqZU
	 IzjVumwsu52NCyJ9ANqNNe/mM1XrHF1dd5oCxJjOm2f+p96EjPpW3j++99OTj4faih
	 tVGYxZL9OrgB7euJ92592rxbKBELWlreuYH/H2GAIS+s0IL93bdhlhC8BE2GbCHel6
	 XRKl+MtQa5sVfFSRqJ9qAu48sSAl+PJD7/cSrv6v8sod6lpXUpQe1Jn3hQPKCkhMHu
	 KFCzS39dN+yFw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 720B360051
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 01:55:25 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v5 3/3] netfilter: nf_tables: unbind flowtable on hook release
Date: Fri, 20 Nov 2026 01:55:18 +0100
Message-ID: <20261120005518.3446074-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120005518.3446074-1-pablo@netfilter.org>
References: <20261120005518.3446074-1-pablo@netfilter.org>
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
v5: unconditionally unbind flow_block from nft_flowtable_event()

 net/netfilter/nf_tables_api.c | 65 +++++++++++++++++++++++++----------
 1 file changed, 47 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 24db948b851b..83af1e148754 100644
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
@@ -9830,10 +9856,11 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 				continue;
 
 			/* flow_offload_netdev_event() cleans up entries for us. */
-			if (!(hook->flags & NFT_HOOK_UNREGISTERED)) {
-				nft_unregister_flowtable_ops(dev_net(dev),
-							     flowtable, ops);
-			}
+			if (!(hook->flags & NFT_HOOK_UNREGISTERED))
+				nft_unregister_flowtable_ops(dev_net(dev), ops);
+
+			flowtable->data.type->setup(&flowtable->data, ops->dev,
+						    FLOW_BLOCK_UNBIND);
 			list_del_rcu(&ops->list);
 			kfree_rcu(ops, rcu);
 			break;
@@ -11313,10 +11340,12 @@ static void nf_tables_abort_release(struct nft_trans *trans)
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

