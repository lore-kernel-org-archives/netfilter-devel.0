Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64C01A7AE3
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 12:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726145135; cv=none; b=bIsctk+n7ngdNnexFumGKbdo+15YI7EJLsAzoDDIij7VC02OVNqpgRAJX5t+tHW+3WO+hr6ZYWkkO5qRfILNEcPBuU9CkYGGcsv+VUiUeuqM26H3lLGZi4ivA3/lwfgEo0puv0kiS9YcW1xXbi7rRQEDsXSKI1Rpg2Hi/CuDRmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726145135; c=relaxed/simple;
	bh=DUOk1RWCR1dM92dz6T5vUR/t+lW97k4nBcr7DxMhnoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3+HJEF8jHn3ZTnesMXU1/4Le5ETzodS20fCiCD8GGukcNjmurwswhVrw7dzs9i3VTAdHG4wracjjn/u2Lid2y8bZsf54nkenA7jW+PPlJlxsRu44ICgzlskQmpe6OM7i6DBPZZ3GNbU11U3KUETbGxvZLt1/3MCzwGwpJ+CMoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=adXM3cYV; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="adXM3cYV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GpZhkHi6N5ILAMWiryIrKB5X9ZeL8cHnH5ws61DKj+I=; b=adXM3cYVNU+1oKE5HpPH2zhHuN
	TANiXwsfdevCUM3a87j8ZRDbW1OWqmwnuuNL/J28AnvIm43YOzJWmD2uCRuDEaOldQmvKW/dOyumW
	G3ve103ao+DD/ygnM3/j8YQN4wzgqOWt6Mhw1IpeFxnuxudM7RSLMlup3jIi1OyREYqNEaG7mVbbh
	5oDYCmlUw+YDfnLHEcf5uCISp/5aSwfZQxH+A5HJl+ntQeT8TjtgDobgK8fXnCIa3mvXg7quz73Wv
	Wp67jB4FEXHibEQ6mHl7I+FBR7oTQvBHJhhI8AL6OlygDvfEvxw+0vqSALBUN2YZRgWvEn7294mEX
	m51x9yMg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1soipf-000000004Di-2YbK;
	Thu, 12 Sep 2024 14:21:55 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v3 10/16] netfilter: nf_tables: Have a list of nf_hook_ops in nft_hook
Date: Thu, 12 Sep 2024 14:21:42 +0200
Message-ID: <20240912122148.12159-11-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240912122148.12159-1-phil@nwl.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Supporting a 1:n relationship between nft_hook and nf_hook_ops is
convenient since a chain's or flowtable's nft_hooks may remain in place
despite matching interfaces disappearing. This stabilizes ruleset dumps
in that regard and opens the possibility to claim newly added interfaces
which match the spec. Also it prepares for wildcard interface specs
since these will potentially match multiple interfaces.

All spots dealing with hook registration are updated to potentially
handle a list of multiple nf_hook_ops, but nft_netdev_hook_alloc()
only adds a single item for now to retain the old behaviour. The only
expected functional change here is how vanishing interfaces are handled:
Instead of dropping the respective nft_hook, only the matching
nf_hook_ops are dropped.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/linux/netfilter.h         |   2 +
 include/net/netfilter/nf_tables.h |   2 +-
 net/netfilter/nf_tables_api.c     | 155 +++++++++++++++++++++---------
 net/netfilter/nf_tables_offload.c |  49 ++++++----
 net/netfilter/nft_chain_filter.c  |   6 +-
 5 files changed, 143 insertions(+), 71 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 2683b2b77612..1318f18784ab 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -95,6 +95,8 @@ enum nf_hook_ops_type {
 };
 
 struct nf_hook_ops {
+	struct list_head	list;
+
 	/* User fills in from here down. */
 	nf_hookfn		*hook;
 	struct net_device	*dev;
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index be11518646a3..991b8d5e52f1 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1189,7 +1189,7 @@ struct nft_stats {
 
 struct nft_hook {
 	struct list_head	list;
-	struct nf_hook_ops	ops;
+	struct list_head	ops_list;
 	struct rcu_head		rcu;
 	char			ifname[IFNAMSIZ];
 	u8			ifnamelen;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dc30d2be09fb..64f8305189f1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -299,25 +299,30 @@ void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain)
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
@@ -326,10 +331,17 @@ static void nft_netdev_unregister_hooks(struct net *net,
 					struct list_head *hook_list,
 					bool release_netdev)
 {
+	struct nf_hook_ops *ops, *nextops;
 	struct nft_hook *hook, *next;
 
 	list_for_each_entry_safe(hook, next, hook_list, list) {
-		nf_unregister_net_hook(net, &hook->ops);
+		list_for_each_entry_safe(ops, nextops, &hook->ops_list, list) {
+			nf_unregister_net_hook(net, ops);
+			if (release_netdev) {
+				list_del(&ops->list);
+				kfree(ops);
+			}
+		}
 		if (release_netdev) {
 			list_del(&hook->list);
 			kfree_rcu(hook, rcu);
@@ -2134,13 +2146,25 @@ static void nf_tables_chain_free_chain_rules(struct nft_chain *chain)
 	kvfree(chain->blob_next);
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
 
 static void nft_netdev_hook_free_rcu(struct nft_hook *hook)
 {
+	nft_netdev_hook_free_ops(hook);
 	kfree_rcu(hook, rcu);
 }
 
@@ -2183,6 +2207,7 @@ void nf_tables_chain_destroy(struct nft_chain *chain)
 static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 					      const struct nlattr *attr)
 {
+	struct nf_hook_ops *ops;
 	struct net_device *dev;
 	struct nft_hook *hook;
 	int err;
@@ -2192,6 +2217,7 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 		err = -ENOMEM;
 		goto err_hook_alloc;
 	}
+	INIT_LIST_HEAD(&hook->ops_list);
 
 	nla_strscpy(hook->ifname, attr, IFNAMSIZ);
 	hook->ifnamelen = nla_len(attr);
@@ -2204,7 +2230,14 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
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
 
@@ -2464,6 +2497,7 @@ static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
 			      struct nft_chain_hook *hook, u32 flags)
 {
 	struct nft_chain *chain;
+	struct nf_hook_ops *ops;
 	struct nft_hook *h;
 
 	basechain->type = hook->type;
@@ -2472,8 +2506,10 @@ static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
 
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
 
@@ -2693,11 +2729,13 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
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
@@ -2819,8 +2857,10 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
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
@@ -8420,6 +8460,7 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 				    struct netlink_ext_ack *extack, bool add)
 {
 	struct nlattr *tb[NFTA_FLOWTABLE_HOOK_MAX + 1];
+	struct nf_hook_ops *ops;
 	struct nft_hook *hook;
 	int hooknum, priority;
 	int err;
@@ -8474,11 +8515,13 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
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
@@ -8520,12 +8563,12 @@ nft_flowtable_type_get(struct net *net, u8 family)
 }
 
 /* Only called from error and netdev event paths. */
-static void nft_unregister_flowtable_hook(struct net *net,
-					  struct nft_flowtable *flowtable,
-					  struct nft_hook *hook)
+static void nft_unregister_flowtable_ops(struct net *net,
+					 struct nft_flowtable *flowtable,
+					 struct nf_hook_ops *ops)
 {
-	nf_unregister_net_hook(net, &hook->ops);
-	flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
+	nf_unregister_net_hook(net, ops);
+	flowtable->data.type->setup(&flowtable->data, ops->dev,
 				    FLOW_BLOCK_UNBIND);
 }
 
@@ -8533,10 +8576,17 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 						 struct list_head *hook_list,
 					         bool release_netdev)
 {
+	struct nf_hook_ops *ops, *nextops;
 	struct nft_hook *hook, *next;
 
 	list_for_each_entry_safe(hook, next, hook_list, list) {
-		nf_unregister_net_hook(net, &hook->ops);
+		list_for_each_entry_safe(ops, nextops, &hook->ops_list, list) {
+			nf_unregister_net_hook(net, ops);
+			if (release_netdev) {
+				list_del(&ops->list);
+				kfree(ops);
+			}
+		}
 		if (release_netdev) {
 			list_del(&hook->list);
 			kfree_rcu(hook, rcu);
@@ -8577,6 +8627,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 {
 	struct nft_hook *hook, *next;
 	struct nft_flowtable *ft;
+	struct nf_hook_ops *ops;
 	int err, i = 0;
 
 	list_for_each_entry(hook, hook_list, list) {
@@ -8590,21 +8641,25 @@ static int nft_register_flowtable_net_hooks(struct net *net,
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
 
-		nft_unregister_flowtable_hook(net, flowtable, hook);
+			nft_unregister_flowtable_ops(net, flowtable, ops);
+		}
 		list_del_rcu(&hook->list);
 		nft_netdev_hook_free_rcu(hook);
 	}
@@ -8629,6 +8684,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
 	struct nft_hook *hook, *next;
+	struct nf_hook_ops *ops;
 	struct nft_trans *trans;
 	bool unregister = false;
 	u32 flags;
@@ -8686,8 +8742,11 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 
 err_flowtable_update_hook:
 	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
-		if (unregister)
-			nft_unregister_flowtable_hook(ctx->net, flowtable, hook);
+		if (unregister) {
+			list_for_each_entry(ops, &hook->ops_list, list)
+				nft_unregister_flowtable_ops(ctx->net,
+							     flowtable, ops);
+		}
 		list_del_rcu(&hook->list);
 		nft_netdev_hook_free_rcu(hook);
 	}
@@ -9193,11 +9252,14 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 {
 	struct nft_hook *hook, *next;
+	struct nf_hook_ops *ops;
 
 	flowtable->data.type->free(&flowtable->data);
 	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
-		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
-					    FLOW_BLOCK_UNBIND);
+		list_for_each_entry(ops, &hook->ops_list, list)
+			flowtable->data.type->setup(&flowtable->data,
+						    ops->dev,
+						    FLOW_BLOCK_UNBIND);
 		list_del_rcu(&hook->list);
 		nft_netdev_hook_free_rcu(hook);
 	}
@@ -9235,9 +9297,12 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
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
@@ -9254,9 +9319,9 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
 			continue;
 
 		/* flow_offload_netdev_event() cleans up entries for us. */
-		nft_unregister_flowtable_hook(dev_net(dev), flowtable, hook);
-		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		nft_unregister_flowtable_ops(dev_net(dev), flowtable, ops);
+		list_del(&ops->list);
+		kfree(ops);
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
index d34c6fe7ba72..2507e3beac5c 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -332,10 +332,8 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 
 		if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
 			nf_unregister_net_hook(ctx->net, ops);
-
-		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
-		break;
+		list_del(&ops->list);
+		kfree(ops);
 	}
 }
 
-- 
2.43.0

