Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A93E23C50F
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 13:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749735266; cv=none; b=uqZv3lZvyVW84DxvpjRGptxITluDA/u36yNYLPlWp9zytiz7xXS7q1YSxYk6dnOyVTEG2zBQrNlA6tL7S5sW+btYTvw1dyFyCtfJsJSbdDezxMZOHfC89gyop0q783lb3PoHpcI2jfZSnFj/ah08r1RdlQUyLaB2JXwZMXnFoUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749735266; c=relaxed/simple;
	bh=JY0cRsSff3GNFZbKXHnk1KXj9shBQBzVw3qc8nA7gJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZ73GGVCLklpnSDsnD+eMaq1Ribv2qWd4iSOH33nUTsC48CP74YhaVO3dyt52o0CSFD/YZcIrNb96ftYK+qvmO61eHtTG768WlKC01EIMFF6gTNDaarCnHRAuInFpDhell38XeAvd52bDfN4U/ve26SBGd5YYg1+QVmcRRDbzDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Xf8ychiv; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Xf8ychiv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EZKjksz3yEjAHlwsn0KtfA8W6b1aQi85oXKKU3o7XxU=; b=Xf8ychivTfzF5J/noNq5qo1Eqm
	9pYQFHAPY9tW4dlVEcVKjtDL8J7igdx2G74lNGKmi1NKCRNY+8j3rkrrpnClGSm6f8EJgQxjgtu81
	CKHhwy292QO/NYn9TCOyoPCD03PwX1gQxzT5z4CWjNJ4SEo9aSyK6JW0pNP6M+GLrQBx8qwccM6S4
	g2GR+vwbH97Kc8pf8GJ/4qvfq7dSUkgXqdf6MtfovDsiu08MNYMBQt8ehZfpCFcqZb5n2zLCHObo9
	6iFBc//le3A7tx36UYBqe+87tsAorQHeMv11cZOb69go4zYkMnyJrk+CCiB2f9n60z0A26DllW/HC
	5fHGCBaA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPi4U-000000000s9-3qCJ;
	Thu, 12 Jun 2025 15:34:22 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 3/3] netfilter: nf_tables: Extend chain/flowtable notifications
Date: Thu, 12 Jun 2025 15:34:16 +0200
Message-ID: <20250612133416.18133-4-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250612133416.18133-1-phil@nwl.cc>
References: <20250612133416.18133-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When creating a flowtable (or netdev-family chain), matching interfaces
are searched for given hook specs. Send newdev notifications for those.
Same with deldev notifications when deleting a flowtable or chain.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 100 ++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 635332bad1b1..8952b50b0224 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9752,6 +9752,48 @@ nf_tables_chain_device_notify(const struct nft_chain *chain,
 				report, notify_list);
 }
 
+static void
+nf_tables_chain_devices_notify(struct nft_ctx *ctx, int event,
+			       const struct list_head *hook_list)
+{
+	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
+	const struct nft_base_chain *basechain;
+	struct nf_hook_ops *ops;
+	struct nft_hook *hook;
+	int nd_event;
+
+	if (!ctx->report &&
+	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFT_DEV))
+		return;
+
+	if (!nft_is_base_chain(ctx->chain))
+		return;
+
+	basechain = nft_base_chain(ctx->chain);
+
+	if (!nft_base_chain_netdev(ctx->chain->table->family,
+				   basechain->ops.hooknum))
+		return;
+
+	if (!hook_list)
+		hook_list = &basechain->hook_list;
+
+	if (event == NFT_MSG_NEWCHAIN)
+		nd_event = NETDEV_REGISTER;
+	else
+		nd_event = NETDEV_UNREGISTER;
+
+	list_for_each_entry_rcu(hook, hook_list, list,
+				lockdep_commit_lock_is_held(ctx->net)) {
+		list_for_each_entry(ops, &hook->ops_list, list) {
+			nf_tables_chain_device_notify(ctx->chain, hook,
+						      ops->dev, nd_event,
+						      ctx->report,
+						      &nft_net->notify_list);
+		}
+	}
+}
+
 static void
 nf_tables_flowtable_device_notify(const struct nft_flowtable *ft,
 				  const struct nft_hook *hook,
@@ -9763,6 +9805,40 @@ nf_tables_flowtable_device_notify(const struct nft_flowtable *ft,
 				report, notify_list);
 }
 
+static void
+nft_flowtable_devices_notify(struct nft_ctx *ctx,
+			     struct nft_flowtable *flowtable,
+			     struct list_head *hook_list,
+			     int event)
+{
+	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
+	struct nf_hook_ops *ops;
+	struct nft_hook *hook;
+	int nd_event;
+
+	if (!ctx->report &&
+	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFT_DEV))
+		return;
+
+	if (!hook_list)
+		hook_list = &flowtable->hook_list;
+
+	if (event == NFT_MSG_NEWFLOWTABLE)
+		nd_event = NETDEV_REGISTER;
+	else
+		nd_event = NETDEV_UNREGISTER;
+
+	list_for_each_entry_rcu(hook, hook_list, list,
+				lockdep_commit_lock_is_held(ctx->net)) {
+		list_for_each_entry(ops, &hook->ops_list, list) {
+			nf_tables_flowtable_device_notify(flowtable, hook,
+							  ops->dev, nd_event,
+							  ctx->report,
+							  &nft_net->notify_list);
+		}
+	}
+}
+
 static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			       struct nft_flowtable *flowtable, bool changename)
 {
@@ -11033,6 +11109,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nft_chain_commit_update(nft_trans_container_chain(trans));
 				nf_tables_chain_notify(&ctx, NFT_MSG_NEWCHAIN,
 						       &nft_trans_chain_hooks(trans));
+				nf_tables_chain_devices_notify(&ctx, NFT_MSG_NEWCHAIN,
+							       &nft_trans_chain_hooks(trans));
 				list_splice(&nft_trans_chain_hooks(trans),
 					    &nft_trans_basechain(trans)->hook_list);
 				/* trans destroyed after rcu grace period */
@@ -11040,12 +11118,16 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nft_chain_commit_drop_policy(nft_trans_container_chain(trans));
 				nft_clear(net, nft_trans_chain(trans));
 				nf_tables_chain_notify(&ctx, NFT_MSG_NEWCHAIN, NULL);
+				nf_tables_chain_devices_notify(&ctx, NFT_MSG_NEWCHAIN,
+							       NULL);
 				nft_trans_destroy(trans);
 			}
 			break;
 		case NFT_MSG_DELCHAIN:
 		case NFT_MSG_DESTROYCHAIN:
 			if (nft_trans_chain_update(trans)) {
+				nf_tables_chain_devices_notify(&ctx, NFT_MSG_DELCHAIN,
+							       &nft_trans_chain_hooks(trans));
 				nf_tables_chain_notify(&ctx, NFT_MSG_DELCHAIN,
 						       &nft_trans_chain_hooks(trans));
 				if (!(table->flags & NFT_TABLE_F_DORMANT)) {
@@ -11055,6 +11137,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				}
 			} else {
 				nft_chain_del(nft_trans_chain(trans));
+				nf_tables_chain_devices_notify(&ctx, NFT_MSG_DELCHAIN,
+							       NULL);
 				nf_tables_chain_notify(&ctx, NFT_MSG_DELCHAIN,
 						       NULL);
 				nf_tables_unregister_hook(ctx.net, ctx.table,
@@ -11163,6 +11247,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
 							   NFT_MSG_NEWFLOWTABLE);
+				nft_flowtable_devices_notify(&ctx,
+							     nft_trans_flowtable(trans),
+							     &nft_trans_flowtable_hooks(trans),
+							     NFT_MSG_NEWFLOWTABLE);
 				list_splice(&nft_trans_flowtable_hooks(trans),
 					    &nft_trans_flowtable(trans)->hook_list);
 			} else {
@@ -11171,12 +11259,20 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 							   nft_trans_flowtable(trans),
 							   NULL,
 							   NFT_MSG_NEWFLOWTABLE);
+				nft_flowtable_devices_notify(&ctx,
+							     nft_trans_flowtable(trans),
+							     NULL,
+							     NFT_MSG_NEWFLOWTABLE);
 			}
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELFLOWTABLE:
 		case NFT_MSG_DESTROYFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
+				nft_flowtable_devices_notify(&ctx,
+							     nft_trans_flowtable(trans),
+							     &nft_trans_flowtable_hooks(trans),
+							     trans->msg_type);
 				nf_tables_flowtable_notify(&ctx,
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
@@ -11186,6 +11282,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 								   &nft_trans_flowtable_hooks(trans));
 			} else {
 				list_del_rcu(&nft_trans_flowtable(trans)->list);
+				nft_flowtable_devices_notify(&ctx,
+							     nft_trans_flowtable(trans),
+							     NULL,
+							     trans->msg_type);
 				nf_tables_flowtable_notify(&ctx,
 							   nft_trans_flowtable(trans),
 							   NULL,
-- 
2.49.0

