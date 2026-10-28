Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793146750;
	b=sGFst/4X8i4S+L90L2sTRlTAI7Llm7H0evGwKILPYHiNN/ZbiEu/lY85EhjPOjmIFLLv
	 2r0ZGushWIxeBv3PEeQcUNnrIvH3utdUyTSiU1Zp5XC6V/6n27W3ELCJR9kvZRm82EQq4
	 kNFdVCJvQ2Ei5sdUGzz88xx2CmOMg4OpWq67/CPOk47v9PZoAft/Yo7B2Pv9hIn/3CUNB
	 EcP7kuQFBS1+7OFmt/QDXUqKl561YpG5WH/9Km/LNiYMmbrayIdsbNBGuFuKxALspNy3c
	 jnucreQYzR0+AK3gsLDlfurYtlMONO5Hlgh8Pr85vPimOqd5C/O1ZNs+ExwMPEm1a0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793146750;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=Whoucem/4rL+tljMF1uQQ/FKtlVTXSgiG2o1IOE4KBU=;
	b=bpkGAGZ4Juj/sQjiNmTys208L90uIwl8N6kTyBLL9TTCEjWBP8J1kfZ2/IrqWOXEnMJd
	 /EXRUVW5+gO85im70l562NGObfmcl1g1glEBao3PkHMytuJ9uhAezMlHk3lVc+j2N3O25
	 n3twJTkM8cTVIHH1NCVhooxNjs23LCs8+kYKXvGB1Zm3Mjt8UDfeTy7NTB0jjDxx336dp
	 ZyWksEQ+68wB7wkKNwuqTCw54M3LQabY7AszqjoIRAM5bqLzSX6CuAhqWQMw1Nh8RUYBJ
	 hReZsu0rTx7vyjabJfdoEKyXdn6f/7LkG/hOObOc6tm/upN0lM7+ameoPZYoSxGD98g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=uKYyz46T;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D24606A31A
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 00:19:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07D24606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=uKYyz46T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793146746;
	bh=Whoucem/4rL+tljMF1uQQ/FKtlVTXSgiG2o1IOE4KBU=;
	h=From:To:Subject:Date:From;
	b=uKYyz46TyaaQbd8zqL88u+K21ORpXT1yuctIhtmml6AlcKOHMtxJaRtOW/br+hFlk
	 28+l8jyHDHPWduGbSKRsr3HyrroNHVTmipAUaLcPgmPdryTHetvBdTh5u6rXU29LrI
	 Kugg5poYRn1+SC/iwLee8ghVXjRi5bL1HnSWjIY/6O3muROUXkwvFMPM6mODyKbrqa
	 sFqD3Wy+cJ+KpBeFc8PYBcdxLFfo+VHre0L+1OMeq/D2kuW0EP2MWnE1hyrIv2EVji
	 S8tt2jubp36nqUe55JQijnWyA77QmaGHn2GCzOJJOvGYDN8h4PMh+eD40lUZkH4mgW
	 jWEefiCW7rxyw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CE56D60078
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 01:19:05 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: flowtable: perform unbind callback on hook release
Date: Wed, 28 Oct 2026 01:19:01 +0100
Message-ID: <20261028001901.94251-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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
 net/netfilter/nf_tables_api.c | 80 +++++++++++++++++++++++------------
 1 file changed, 54 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b59628e6240c..1c7deca476fa 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -372,6 +372,23 @@ static void nft_netdev_hook_free_rcu(struct nft_hook *hook)
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
@@ -8997,12 +9014,9 @@ nft_flowtable_type_get(struct net *net, u8 family)
 
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
@@ -9015,9 +9029,9 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		list_for_each_entry(ops, &hook->ops_list, list)
-			nft_unregister_flowtable_ops(net, flowtable, ops);
+			nft_unregister_flowtable_ops(net, ops);
 		if (release_netdev)
-			nft_netdev_hook_unlink_free_rcu(hook);
+			nft_flowtable_hook_unlink_free_rcu(flowtable, hook);
 	}
 }
 
@@ -9086,14 +9100,23 @@ static int nft_register_flowtable_net_hooks(struct net *net,
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
@@ -9103,20 +9126,16 @@ static void nft_hooks_destroy(struct list_head *hook_list)
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
 
@@ -9202,10 +9221,9 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
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
@@ -9331,7 +9349,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 	synchronize_rcu();
 	nft_trans_destroy(trans);
 err_flowtable_trans:
-	nft_hooks_destroy(&flowtable->hook_list);
+	nft_flowtable_hooks_destroy(flowtable, &flowtable->hook_list);
 err_flowtable_parse_hooks:
 	flowtable->data.type->free(&flowtable->data);
 err3:
@@ -9727,7 +9745,7 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 {
 	flowtable->data.type->free(&flowtable->data);
-	nft_hooks_destroy(&flowtable->hook_list);
+	nft_flowtable_hooks_destroy(flowtable, &flowtable->hook_list);
 	kfree(flowtable->name);
 	module_put(flowtable->data.type->owner);
 	kfree(flowtable);
@@ -9802,8 +9820,7 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 				continue;
 
 			/* flow_offload_netdev_event() cleans up entries for us. */
-			nft_unregister_flowtable_ops(dev_net(dev),
-						     flowtable, ops);
+			nft_unregister_flowtable_ops(dev_net(dev), ops);
 			list_del_rcu(&ops->list);
 			kfree_rcu(ops, rcu);
 			break;
@@ -10267,8 +10284,18 @@ static void nft_commit_release(struct nft_trans *trans)
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
 
@@ -11205,7 +11232,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 							   &nft_trans_flowtable_hooks(trans),
 							   trans->msg_type);
 				nft_flowtable_unregister_trans_hook(net,
-								    nft_trans_flowtable(trans),
 								    &nft_trans_flowtable_hooks(trans));
 			} else {
 				list_del_rcu(&nft_trans_flowtable(trans)->list);
@@ -11278,10 +11304,12 @@ static void nf_tables_abort_release(struct nft_trans *trans)
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

