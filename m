Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A2E158D8B
	for <netfilter-devel@vger.kernel.org>; Fri,  3 May 2024 19:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714765849; cv=none; b=LgXIz/0LvRV9h9DkFhjTF4PL2M4Fmo69JhqNmy0Qp/vJsKMhiC+fD+bWeGI0BlGW2cuX1yNWAyrXRFqIX3dqUJ1U9qOUJdP2KCvTQGHLjjNHLbaP1Z1GXr8u1yFeVxJ3bTI8tSHxR9Vg+rHmS6/8FApMCOq9o8XpP1PyrJWai8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714765849; c=relaxed/simple;
	bh=j59nak0IDgdzpdMDF0bFPKxKu9v5/g0eSo/kTiP9lRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoAmu/Ok5C6AYJ3YzMlJUu6dIHFf68R18w5OP3vqHEwWADiRLsnpD6PtwbM2PlgWD+cidkJ1l9JZiTCsjJxRaeWKJ+ZU6eXxxvBQzcKoygW7G2BcaLaw1FOtqaKpSh0QWv0cvEjUtABrr8frzqWrM5l4RkYJo5D4N4I2noHeO/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=JzWLZgal; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="JzWLZgal"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dwwtMrczmJx1Ya/kKt00h/d4qBYOAz4MbxSC8Ci5pl8=; b=JzWLZgalOc2P6f9HYoCWpQhWpo
	me2srD95pdzwy6zkQq6TIvyInCvsQKoIiM1GpD4t3ynIURvFUGnhrU1FZG9/F2STrSpHnJQhUH8G1
	baogE5XnE3z3lF6Xxzv6kMcvLHQ9IRwf28Z3DUWhaEF3aUcxjBUg/84pbPEi5PshlbLk8HMN4JxpR
	jGpp9XSCnHQDaZCZo0ZgbpWOJVQ1WSutHcYC2VjD6OBrDXsGbYnTgxjpAV/BD2J/1p0yrGSQrbe+E
	FWC/3DA8GDchk03ysser12zF0x+H24609FGSKrTrOS4yBZ1LirY9rUKw+roiHPElMg4aylnP2Eq5R
	rcByvTPw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s2yvb-000000007DY-0y69;
	Fri, 03 May 2024 21:50:43 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: [nf-next PATCH 4/5] netfilter: nf_tables: Dynamic hook interface binding
Date: Fri,  3 May 2024 21:50:44 +0200
Message-ID: <20240503195045.6934-5-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240503195045.6934-1-phil@nwl.cc>
References: <20240503195045.6934-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Upon NETDEV_REGISTER event, search existing flowtables and netdev-family
chains for a matching inactive hook and bind the device.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c    | 76 +++++++++++++++++++++++---------
 net/netfilter/nft_chain_filter.c | 40 +++++++++++++++--
 2 files changed, 91 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 87576accc2b2..b19f40874c48 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8460,6 +8460,27 @@ nft_flowtable_type_get(struct net *net, u8 family)
 	return ERR_PTR(-ENOENT);
 }
 
+static int nft_register_flowtable_hook(struct net *net,
+				       struct nft_flowtable *flowtable,
+				       struct nft_hook *hook)
+{
+	int err;
+
+	err = flowtable->data.type->setup(&flowtable->data,
+					  hook->ops.dev, FLOW_BLOCK_BIND);
+	if (err < 0)
+		return err;
+
+	err = nf_register_net_hook(net, &hook->ops);
+	if (err < 0) {
+		flowtable->data.type->setup(&flowtable->data,
+					    hook->ops.dev, FLOW_BLOCK_UNBIND);
+		return err;
+	}
+
+	return 0;
+}
+
 /* Only called from error and netdev event paths. */
 static void nft_unregister_flowtable_hook(struct net *net,
 					  struct nft_flowtable *flowtable,
@@ -8521,20 +8542,10 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			}
 		}
 
-		err = flowtable->data.type->setup(&flowtable->data,
-						  hook->ops.dev,
-						  FLOW_BLOCK_BIND);
+		err = nft_register_flowtable_hook(net, flowtable, hook);
 		if (err < 0)
 			goto err_unregister_net_hooks;
 
-		err = nf_register_net_hook(net, &hook->ops);
-		if (err < 0) {
-			flowtable->data.type->setup(&flowtable->data,
-						    hook->ops.dev,
-						    FLOW_BLOCK_UNBIND);
-			goto err_unregister_net_hooks;
-		}
-
 		i++;
 	}
 
@@ -9191,20 +9202,40 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 	return -EMSGSIZE;
 }
 
-static void nft_flowtable_event(unsigned long event, struct net_device *dev,
-				struct nft_flowtable *flowtable)
+static int nft_flowtable_event(unsigned long event, struct net_device *dev,
+			       struct nft_flowtable *flowtable)
 {
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, &flowtable->hook_list, list) {
-		if (hook->ops.dev != dev)
-			continue;
+		switch (event) {
+		case NETDEV_UNREGISTER:
+			if (hook->ops.dev != dev)
+				break;
 
-		/* flow_offload_netdev_event() cleans up entries for us. */
-		nft_unregister_flowtable_hook(dev_net(dev), flowtable, hook);
-		hook->ops.dev = NULL;
-		break;
+			/* flow_offload_netdev_event() cleans up entries for us. */
+			nft_unregister_flowtable_hook(dev_net(dev),
+						      flowtable, hook);
+			hook->ops.dev = NULL;
+			return 1;
+		case NETDEV_REGISTER:
+			if (hook->ops.dev ||
+			    strncmp(hook->ifname, dev->name, hook->ifnamelen))
+				break;
+
+			hook->ops.dev = dev;
+			if (!nft_register_flowtable_hook(dev_net(dev),
+							 flowtable, hook))
+				return 1;
+
+			printk(KERN_ERR
+			       "flowtable %s: Can't hook into device %s\n",
+			       flowtable->name, dev->name);
+			hook->ops.dev = NULL;
+			break;
+		}
 	}
+	return 0;
 }
 
 static int nf_tables_flowtable_event(struct notifier_block *this,
@@ -9216,7 +9247,8 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	struct nft_table *table;
 	struct net *net;
 
-	if (event != NETDEV_UNREGISTER)
+	if (event != NETDEV_UNREGISTER &&
+	    event != NETDEV_REGISTER)
 		return 0;
 
 	net = dev_net(dev);
@@ -9224,9 +9256,11 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
 		list_for_each_entry(flowtable, &table->flowtables, list) {
-			nft_flowtable_event(event, dev, flowtable);
+			if (nft_flowtable_event(event, dev, flowtable))
+				goto out_unlock;
 		}
 	}
+out_unlock:
 	mutex_unlock(&nft_net->commit_mutex);
 
 	return NOTIFY_DONE;
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index ddb438bc2afd..b2147f8be60c 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -318,19 +318,50 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
 	},
 };
 
+static int nft_netdev_hook_dev_update(struct nft_hook *hook,
+				      struct net_device *dev)
+{
+	int ret = 0;
+
+	if (hook->ops.dev)
+		nf_unregister_net_hook(dev_net(hook->ops.dev), &hook->ops);
+
+	hook->ops.dev = dev;
+
+	if (dev) {
+		ret = nf_register_net_hook(dev_net(dev), &hook->ops);
+		if (ret < 0)
+			hook->ops.dev = NULL;
+	}
+
+	return ret;
+}
+
 static void nft_netdev_event(unsigned long event, struct net_device *dev,
 			     struct nft_ctx *ctx)
 {
 	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
 	struct nft_hook *hook;
 
-	if (event != NETDEV_UNREGISTER)
+	if (event != NETDEV_UNREGISTER &&
+	    event != NETDEV_REGISTER)
 		return;
 
 	list_for_each_entry(hook, &basechain->hook_list, list) {
-		if (hook->ops.dev == dev) {
-			nf_unregister_net_hook(ctx->net, &hook->ops);
-			hook->ops.dev = NULL;
+		switch (event) {
+		case NETDEV_UNREGISTER:
+			if (hook->ops.dev == dev)
+				nft_netdev_hook_dev_update(hook, NULL);
+			break;
+		case NETDEV_REGISTER:
+			if (hook->ops.dev ||
+			    strncmp(hook->ifname, dev->name, hook->ifnamelen))
+				break;
+			if (!nft_netdev_hook_dev_update(hook, dev))
+				return;
+
+			printk(KERN_ERR "chain %s: Can't hook into device %s\n",
+			       ctx->chain->name, dev->name);
 			break;
 		}
 	}
@@ -349,6 +380,7 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	};
 
 	if (event != NETDEV_UNREGISTER &&
+	    event != NETDEV_REGISTER &&
 	    event != NETDEV_CHANGENAME)
 		return NOTIFY_DONE;
 
-- 
2.43.0

