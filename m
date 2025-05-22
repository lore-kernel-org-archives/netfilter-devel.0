Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D76A29ACD7;
	Thu, 22 May 2025 16:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932808; cv=none; b=gPKfI9SDX4zIuUVXAyuMuc2CIaoV7XOX/TjRSL4bevACvyqgC0bakLwtDv2uo+J42zPyaC9H/6R89oP1X2BkNs86qQG82oyqXNjmbUG4IS7bGEnYnaCcCBSpbvkwUxAoCEaNiSeo2vAyd39xUFzLR17VH9Y7JAUsXXPr5rKBhGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932808; c=relaxed/simple;
	bh=A5IaOhfvIxaoWAcngCfVxPJmikm7KiwH68NVVjp1nTA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SNKB8R4N5cM94PG3hHpBMa+W92vPu9zvEb6KZ4areL5tLAw3wOX/j09/PfEH0LQ6xvOgiNZds4oklGHso0LMR6Fl4H51jJvKfpdkvzqNCDXdwG5JkVkw9IpU59VT2JHiQfDhPPzn8arsY5L76PJu+Ya0WXa/fPxdmfRPWgm8KXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=q4wAT44h; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KtiFV4hc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="q4wAT44h";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KtiFV4hc"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1A423606ED; Thu, 22 May 2025 18:53:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932805;
	bh=MIgF2Nnm2RZPkIlD0WLTUgqZEVgz1gLlJcJU6k0nKmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4wAT44hftwpxDJbCSyxHQDkNmwQ6lkiWIAj+XfevMMjZ5Mb28DJvDlnJa22UXmuq
	 J7vDepmN33P5qieqWOL+KUlTPQKBVv9/bkDS2cAVLpNYgpy711NRsA/hCgnEjQkX9h
	 oTex1NRvgTPE1Bi4FpVO7X9qc7bQWcew7XKxFVr6ix06qm85QdUCIuH4wlidP/TPGW
	 Uqbu5YxGzUkXe7AD2BTz7au/NgqXKbau+r+ANiGf9aOgPQBiDC+Qq5vR+WTXXGTBbD
	 CQkcpV6eu8aNQRurHJZn7PRU8lrtPkQRhesRWfOlXcv95ilF8cq5hcv7BYWxLz9HQQ
	 PEESvPjn6H65w==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CAD3460740;
	Thu, 22 May 2025 18:52:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932779;
	bh=MIgF2Nnm2RZPkIlD0WLTUgqZEVgz1gLlJcJU6k0nKmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtiFV4hcEZo/WPid86T2W/dkQ8dn228SGM3aN4JXKe01F8wwfBAW8sL45LUqb83Oi
	 sjn/+DcGGmJ19iNAEjYvcbGS6TwsfIE+OiCyDqsMYDEYmaPB2yl5+yW4Ajyaz6Wgy/
	 LKkhHauwoxWCrpa8gitDLbqaZIQpoJ8UcaZtbHmA+8RdmhQ2MhbZFvSyAOtKUCtbPR
	 P3vDGzj5ZO7TNYctKgveqKk59bv1xS6a9KA9pZeyi3oPOQi4CmQdzgmQ5/hYK2koiZ
	 gA1uIhi5GobrS9+tjwAcuhkg4pnl5OMP+fk3hqEJieMarxNYd1DtSK5mvq6tTRDEc3
	 ey0SbPaanzkNw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 18/26] netfilter: nf_tables: Have a list of nf_hook_ops in nft_hook
Date: Thu, 22 May 2025 18:52:30 +0200
Message-Id: <20250522165238.378456-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250522165238.378456-1-pablo@netfilter.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

Supporting a 1:n relationship between nft_hook and nf_hook_ops is
convenient since a chain's or flowtable's nft_hooks may remain in place
despite matching interfaces disappearing. This stabilizes ruleset dumps
in that regard and opens the possibility to claim newly added interfaces
which match the spec. Also it prepares for wildcard interface specs
since these will potentially match multiple interfaces.

All spots dealing with hook registration are updated to handle a list of
multiple nf_hook_ops, but nft_netdev_hook_alloc() only adds a single
item for now to retain the old behaviour. The only expected functional
change here is how vanishing interfaces are handled: Instead of dropping
the respective nft_hook, only the matching nf_hook_ops are dropped.

To safely remove individual ops from the list in netdev handlers, an
rcu_head is added to struct nf_hook_ops so kfree_rcu() may be used.
There is at least nft_flowtable_find_dev() which may be iterating
through the list at the same time.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h         |   3 +
 include/net/netfilter/nf_tables.h |   2 +-
 net/netfilter/nf_tables_api.c     | 142 ++++++++++++++++++++++--------
 net/netfilter/nf_tables_offload.c |  49 ++++++-----
 net/netfilter/nft_chain_filter.c  |   4 +-
 5 files changed, 137 insertions(+), 63 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 20947f2c685b..5f896fcc074d 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -95,6 +95,9 @@ enum nf_hook_ops_type {
 };
 
 struct nf_hook_ops {
+	struct list_head	list;
+	struct rcu_head		rcu;
+
 	/* User fills in from here down. */
 	nf_hookfn		*hook;
 	struct net_device	*dev;
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index df0b151743a2..5e49619ae49c 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1199,7 +1199,7 @@ struct nft_stats {
 
 struct nft_hook {
 	struct list_head	list;
-	struct nf_hook_ops	ops;
+	struct list_head	ops_list;
 	struct rcu_head		rcu;
 	char			ifname[IFNAMSIZ];
 	u8			ifnamelen;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8fb8bcdfdcb2..62bf498d1ec9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -300,37 +300,60 @@ void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain)
 static int nft_netdev_register_hooks(struct net *net,
 				     struct list_head *hook_list)
 {
+	struct nf_hook_ops *ops;
 	struct nft_hook *hook;
 	int err, j;
 
 	j = 0;
 	list_for_each_entry(hook, hook_list, list) {
-		err = nf_register_net_hook(net, &hook->ops);
-		if (err < 0)
-			goto err_register;
+		list_for_each_entry(ops, &hook->ops_list, list) {
+			err = nf_register_net_hook(net, ops);
+			if (err < 0)
+				goto err_register;
 
-		j++;
+			j++;
+		}
 	}
 	return 0;
 
 err_register:
 	list_for_each_entry(hook, hook_list, list) {
-		if (j-- <= 0)
-			break;
+		list_for_each_entry(ops, &hook->ops_list, list) {
+			if (j-- <= 0)
+				break;
 
-		nf_unregister_net_hook(net, &hook->ops);
+			nf_unregister_net_hook(net, ops);
+		}
 	}
 	return err;
 }
 
+static void nft_netdev_hook_free_ops(struct nft_hook *hook)
+{
+	struct nf_hook_ops *ops, *next;
+
+	list_for_each_entry_safe(ops, next, &hook->ops_list, list) {
+		list_del(&ops->list);
+		kfree(ops);
+	}
+}
+
 static void nft_netdev_hook_free(struct nft_hook *hook)
 {
+	nft_netdev_hook_free_ops(hook);
 	kfree(hook);
 }
 
+static void __nft_netdev_hook_free_rcu(struct rcu_head *rcu)
+{
+	struct nft_hook *hook = container_of(rcu, struct nft_hook, rcu);
+
+	nft_netdev_hook_free(hook);
+}
+
 static void nft_netdev_hook_free_rcu(struct nft_hook *hook)
 {
-	kfree_rcu(hook, rcu);
+	call_rcu(&hook->rcu, __nft_netdev_hook_free_rcu);
 }
 
 static void nft_netdev_unregister_hooks(struct net *net,
@@ -338,9 +361,11 @@ static void nft_netdev_unregister_hooks(struct net *net,
 					bool release_netdev)
 {
 	struct nft_hook *hook, *next;
+	struct nf_hook_ops *ops;
 
 	list_for_each_entry_safe(hook, next, hook_list, list) {
-		nf_unregister_net_hook(net, &hook->ops);
+		list_for_each_entry(ops, &hook->ops_list, list)
+			nf_unregister_net_hook(net, ops);
 		if (release_netdev) {
 			list_del(&hook->list);
 			nft_netdev_hook_free_rcu(hook);
@@ -2284,6 +2309,7 @@ void nf_tables_chain_destroy(struct nft_chain *chain)
 static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 					      const struct nlattr *attr)
 {
+	struct nf_hook_ops *ops;
 	struct net_device *dev;
 	struct nft_hook *hook;
 	int err;
@@ -2293,6 +2319,7 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 		err = -ENOMEM;
 		goto err_hook_alloc;
 	}
+	INIT_LIST_HEAD(&hook->ops_list);
 
 	err = nla_strscpy(hook->ifname, attr, IFNAMSIZ);
 	if (err < 0)
@@ -2309,7 +2336,14 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 		err = -ENOENT;
 		goto err_hook_dev;
 	}
-	hook->ops.dev = dev;
+
+	ops = kzalloc(sizeof(struct nf_hook_ops), GFP_KERNEL_ACCOUNT);
+	if (!ops) {
+		err = -ENOMEM;
+		goto err_hook_dev;
+	}
+	ops->dev = dev;
+	list_add_tail(&ops->list, &hook->ops_list);
 
 	return hook;
 
@@ -2569,6 +2603,7 @@ static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
 			      struct nft_chain_hook *hook, u32 flags)
 {
 	struct nft_chain *chain;
+	struct nf_hook_ops *ops;
 	struct nft_hook *h;
 
 	basechain->type = hook->type;
@@ -2577,8 +2612,10 @@ static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
 
 	if (nft_base_chain_netdev(family, hook->num)) {
 		list_splice_init(&hook->list, &basechain->hook_list);
-		list_for_each_entry(h, &basechain->hook_list, list)
-			nft_basechain_hook_init(&h->ops, family, hook, chain);
+		list_for_each_entry(h, &basechain->hook_list, list) {
+			list_for_each_entry(ops, &h->ops_list, list)
+				nft_basechain_hook_init(ops, family, hook, chain);
+		}
 	}
 	nft_basechain_hook_init(&basechain->ops, family, hook, chain);
 
@@ -2797,11 +2834,13 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 		if (nft_base_chain_netdev(ctx->family, basechain->ops.hooknum)) {
 			list_for_each_entry_safe(h, next, &hook.list, list) {
-				h->ops.pf	= basechain->ops.pf;
-				h->ops.hooknum	= basechain->ops.hooknum;
-				h->ops.priority	= basechain->ops.priority;
-				h->ops.priv	= basechain->ops.priv;
-				h->ops.hook	= basechain->ops.hook;
+				list_for_each_entry(ops, &h->ops_list, list) {
+					ops->pf		= basechain->ops.pf;
+					ops->hooknum	= basechain->ops.hooknum;
+					ops->priority	= basechain->ops.priority;
+					ops->priv	= basechain->ops.priv;
+					ops->hook	= basechain->ops.hook;
+				}
 
 				if (nft_hook_list_find(&basechain->hook_list, h)) {
 					list_del(&h->list);
@@ -2923,8 +2962,10 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 err_hooks:
 	if (nla[NFTA_CHAIN_HOOK]) {
 		list_for_each_entry_safe(h, next, &hook.list, list) {
-			if (unregister)
-				nf_unregister_net_hook(ctx->net, &h->ops);
+			if (unregister) {
+				list_for_each_entry(ops, &h->ops_list, list)
+					nf_unregister_net_hook(ctx->net, ops);
+			}
 			list_del(&h->list);
 			nft_netdev_hook_free_rcu(h);
 		}
@@ -8795,6 +8836,7 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 				    struct netlink_ext_ack *extack, bool add)
 {
 	struct nlattr *tb[NFTA_FLOWTABLE_HOOK_MAX + 1];
+	struct nf_hook_ops *ops;
 	struct nft_hook *hook;
 	int hooknum, priority;
 	int err;
@@ -8849,11 +8891,13 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 	}
 
 	list_for_each_entry(hook, &flowtable_hook->list, list) {
-		hook->ops.pf		= NFPROTO_NETDEV;
-		hook->ops.hooknum	= flowtable_hook->num;
-		hook->ops.priority	= flowtable_hook->priority;
-		hook->ops.priv		= &flowtable->data;
-		hook->ops.hook		= flowtable->data.type->hook;
+		list_for_each_entry(ops, &hook->ops_list, list) {
+			ops->pf		= NFPROTO_NETDEV;
+			ops->hooknum	= flowtable_hook->num;
+			ops->priority	= flowtable_hook->priority;
+			ops->priv	= &flowtable->data;
+			ops->hook	= flowtable->data.type->hook;
+		}
 	}
 
 	return err;
@@ -8910,9 +8954,11 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 					         bool release_netdev)
 {
 	struct nft_hook *hook, *next;
+	struct nf_hook_ops *ops;
 
 	list_for_each_entry_safe(hook, next, hook_list, list) {
-		nft_unregister_flowtable_ops(net, flowtable, &hook->ops);
+		list_for_each_entry(ops, &hook->ops_list, list)
+			nft_unregister_flowtable_ops(net, flowtable, ops);
 		if (release_netdev) {
 			list_del(&hook->list);
 			nft_netdev_hook_free_rcu(hook);
@@ -8954,6 +9000,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 {
 	struct nft_hook *hook, *next;
 	struct nft_flowtable *ft;
+	struct nf_hook_ops *ops;
 	int err, i = 0;
 
 	list_for_each_entry(hook, hook_list, list) {
@@ -8967,21 +9014,25 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			}
 		}
 
-		err = nft_register_flowtable_ops(net, flowtable, &hook->ops);
-		if (err < 0)
-			goto err_unregister_net_hooks;
+		list_for_each_entry(ops, &hook->ops_list, list) {
+			err = nft_register_flowtable_ops(net, flowtable, ops);
+			if (err < 0)
+				goto err_unregister_net_hooks;
 
-		i++;
+			i++;
+		}
 	}
 
 	return 0;
 
 err_unregister_net_hooks:
 	list_for_each_entry_safe(hook, next, hook_list, list) {
-		if (i-- <= 0)
-			break;
+		list_for_each_entry(ops, &hook->ops_list, list) {
+			if (i-- <= 0)
+				break;
 
-		nft_unregister_flowtable_ops(net, flowtable, &hook->ops);
+			nft_unregister_flowtable_ops(net, flowtable, ops);
+		}
 		list_del_rcu(&hook->list);
 		nft_netdev_hook_free_rcu(hook);
 	}
@@ -9006,6 +9057,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
 	struct nft_hook *hook, *next;
+	struct nf_hook_ops *ops;
 	struct nft_trans *trans;
 	bool unregister = false;
 	u32 flags;
@@ -9063,8 +9115,11 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 
 err_flowtable_update_hook:
 	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
-		if (unregister)
-			nft_unregister_flowtable_ops(ctx->net, flowtable, &hook->ops);
+		if (unregister) {
+			list_for_each_entry(ops, &hook->ops_list, list)
+				nft_unregister_flowtable_ops(ctx->net,
+							     flowtable, ops);
+		}
 		list_del_rcu(&hook->list);
 		nft_netdev_hook_free_rcu(hook);
 	}
@@ -9611,9 +9666,12 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 struct nf_hook_ops *nft_hook_find_ops(const struct nft_hook *hook,
 				      const struct net_device *dev)
 {
-	if (hook->ops.dev == dev)
-		return (struct nf_hook_ops *)&hook->ops;
+	struct nf_hook_ops *ops;
 
+	list_for_each_entry(ops, &hook->ops_list, list) {
+		if (ops->dev == dev)
+			return ops;
+	}
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(nft_hook_find_ops);
@@ -9621,7 +9679,13 @@ EXPORT_SYMBOL_GPL(nft_hook_find_ops);
 struct nf_hook_ops *nft_hook_find_ops_rcu(const struct nft_hook *hook,
 					  const struct net_device *dev)
 {
-	return nft_hook_find_ops(hook, dev);
+	struct nf_hook_ops *ops;
+
+	list_for_each_entry_rcu(ops, &hook->ops_list, list) {
+		if (ops->dev == dev)
+			return ops;
+	}
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(nft_hook_find_ops_rcu);
 
@@ -9638,8 +9702,8 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
 
 		/* flow_offload_netdev_event() cleans up entries for us. */
 		nft_unregister_flowtable_ops(dev_net(dev), flowtable, ops);
-		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		list_del_rcu(&ops->list);
+		kfree_rcu(ops, rcu);
 		break;
 	}
 }
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 75b756f0b9f0..fd30e205de84 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -220,6 +220,7 @@ static int nft_chain_offload_priority(const struct nft_base_chain *basechain)
 
 bool nft_chain_offload_support(const struct nft_base_chain *basechain)
 {
+	struct nf_hook_ops *ops;
 	struct net_device *dev;
 	struct nft_hook *hook;
 
@@ -227,13 +228,16 @@ bool nft_chain_offload_support(const struct nft_base_chain *basechain)
 		return false;
 
 	list_for_each_entry(hook, &basechain->hook_list, list) {
-		if (hook->ops.pf != NFPROTO_NETDEV ||
-		    hook->ops.hooknum != NF_NETDEV_INGRESS)
-			return false;
-
-		dev = hook->ops.dev;
-		if (!dev->netdev_ops->ndo_setup_tc && !flow_indr_dev_exists())
-			return false;
+		list_for_each_entry(ops, &hook->ops_list, list) {
+			if (ops->pf != NFPROTO_NETDEV ||
+			    ops->hooknum != NF_NETDEV_INGRESS)
+				return false;
+
+			dev = ops->dev;
+			if (!dev->netdev_ops->ndo_setup_tc &&
+			    !flow_indr_dev_exists())
+				return false;
+		}
 	}
 
 	return true;
@@ -455,34 +459,37 @@ static int nft_flow_block_chain(struct nft_base_chain *basechain,
 				const struct net_device *this_dev,
 				enum flow_block_command cmd)
 {
-	struct net_device *dev;
+	struct nf_hook_ops *ops;
 	struct nft_hook *hook;
 	int err, i = 0;
 
 	list_for_each_entry(hook, &basechain->hook_list, list) {
-		dev = hook->ops.dev;
-		if (this_dev && this_dev != dev)
-			continue;
+		list_for_each_entry(ops, &hook->ops_list, list) {
+			if (this_dev && this_dev != ops->dev)
+				continue;
 
-		err = nft_chain_offload_cmd(basechain, dev, cmd);
-		if (err < 0 && cmd == FLOW_BLOCK_BIND) {
-			if (!this_dev)
-				goto err_flow_block;
+			err = nft_chain_offload_cmd(basechain, ops->dev, cmd);
+			if (err < 0 && cmd == FLOW_BLOCK_BIND) {
+				if (!this_dev)
+					goto err_flow_block;
 
-			return err;
+				return err;
+			}
+			i++;
 		}
-		i++;
 	}
 
 	return 0;
 
 err_flow_block:
 	list_for_each_entry(hook, &basechain->hook_list, list) {
-		if (i-- <= 0)
-			break;
+		list_for_each_entry(ops, &hook->ops_list, list) {
+			if (i-- <= 0)
+				break;
 
-		dev = hook->ops.dev;
-		nft_chain_offload_cmd(basechain, dev, FLOW_BLOCK_UNBIND);
+			nft_chain_offload_cmd(basechain, ops->dev,
+					      FLOW_BLOCK_UNBIND);
+		}
 	}
 	return err;
 }
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 783e4b5ef3e0..862eab45851a 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -332,8 +332,8 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 		if (!(basechain->chain.table->flags & NFT_TABLE_F_DORMANT))
 			nf_unregister_net_hook(dev_net(dev), ops);
 
-		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		list_del_rcu(&ops->list);
+		kfree_rcu(ops, rcu);
 		break;
 	}
 }
-- 
2.30.2

