Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1171446D5
	for <netfilter-devel@vger.kernel.org>; Fri, 17 May 2024 13:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715951185; cv=none; b=rVJYSEtYyup982KOlfaBY7g4lvBskjTbqv5DIaI3Mjdx+ET0MXc5Z8a+ZCGt2UOmtSo83vvIgHTl8X0CdpmI9ctZhCpvWz69UPPR0gF4gYBgDvJ0Mfq2BoYbdpUYx9+VByldkg4jU7wNCZMaO8xqUaHWwKuqgub9KHiR8M4+430=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715951185; c=relaxed/simple;
	bh=j59nak0IDgdzpdMDF0bFPKxKu9v5/g0eSo/kTiP9lRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dw0ap8fT6J0ZkYSB7RE3Mv+tZxzE9thiXl5B8zTby9ei0gBW7cR1xDjODBxmM2xos0XvuXI7/o7zrbw9L/Trh8SZFi2adTAflrZeNQbF3mxCg2zxRGXkvHf/4xfOc0a1FMKfrcevkvivBrf28m0D4gIBGJK31FHjkbh4LqOxJ2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aHh1x0tM; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aHh1x0tM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dwwtMrczmJx1Ya/kKt00h/d4qBYOAz4MbxSC8Ci5pl8=; b=aHh1x0tMNwwmxF/mDbV7yma838
	I7+YOLMSIsnEyeqp82eG8TmpNOSu96wPGCfb9DKtOEFxUKEYeL4a1BE747nU/RS7I0qgl+TLsU+SR
	xUJtgyLkGwY3n74cZymsS9+/PDNiKMwgofnOce8DWNRMwSCzYVOC8/cBtdLq0w/1RPM8z5R2g2uPk
	KpDIxZEjqTXHXh4rsWTqwU4cd6xMjnuezgARcVGsB5GtMgsP+eMRo6xexNR+pkbP6sjX6sMoDdoeb
	7/CXDIlacreblAA3vODkeflugakjaspvEG2qSWSbK0U/wu4HuYeiTssHCgd+BghntkM6NP2RFuvLd
	TU1Y+v8w==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s7xHr-000000001cl-0GxL;
	Fri, 17 May 2024 15:06:15 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: [PATCH v2 4/7] netfilter: nf_tables: Dynamic hook interface binding
Date: Fri, 17 May 2024 15:06:12 +0200
Message-ID: <20240517130615.19979-5-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240517130615.19979-1-phil@nwl.cc>
References: <20240517130615.19979-1-phil@nwl.cc>
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

