Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55B729CB20
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 20:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747860287; cv=none; b=Py5U0TZlRVWP5OnBM/DWvzzaGUqINfFjjQD5L/Pt2JfRUDDA5g6QXDNO9h0Bo5K0t+qyGzOcOg31YdNf1S8FulPYCk4pWvlelUe7yBc87YhsNc0dorDbkGQS41F5bvyoyB1TM59F9DCA2vfH3qWACxTivV/rmjvkZ9tkuyqZH4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747860287; c=relaxed/simple;
	bh=MLh4qPPAk9LCrw1Xxz5grC6n4cBYP4FT4sUFNiwb/vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uy8ZZxPdvX34ilOwXfGK+6/7gWP4MM7DNb5V57vCqAJ3MDg0NSz9+yup5aoD26Zl6UwOOoqmCIrHUy7A8pJAIYkpdjKeFeGladFqszNZv9Bp5VHkRyvQyx9m9gesDSiqzOX1qn3Yi69RGfYM0hUFXTc5q8Wy8hPRuJVNKcA3Qh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ST/9lGfv; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ST/9lGfv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fTuVm07SXfiubpRbICro2OCiT7wKVn0a/cjQ1I2KPMY=; b=ST/9lGfvNiEfYFasRaXcFZm4Vd
	lFV+UWUtcPdzYauzLAyxEpyN+7uTY4N3w4dZW3iZ3wIU5V0pEFttzVs/Jeu7JyLoLo8NY1xzJksrk
	dtIrRb/13EKnpN4MdQ1r3SgwoUvzCceYA5G6eYt9AgNnkJypYsQSVCZ+Y5xMb2TGDFu5fFlPv3eim
	7gPXVKL+aGzK/n+1FlzIk9VN6BjXL0DK/EYhOGd4ekCdiMvA/IDcEGoing4KxrIOD6Bbj/4wWgAMn
	2a40GBbtC/ohnXZsFfu1iB45+DiCVcCmfD7qvv/1Veys6MysPXUEucLEJBxuxiUb3CriwY2pjY4py
	P3agNz3A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHqIt-000000007R5-0R4n;
	Wed, 21 May 2025 22:44:43 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v7 09/13] netfilter: nf_tables: Handle NETDEV_CHANGENAME events
Date: Wed, 21 May 2025 22:44:30 +0200
Message-ID: <20250521204434.13210-10-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521204434.13210-1-phil@nwl.cc>
References: <20250521204434.13210-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the sake of simplicity, treat them like consecutive NETDEV_REGISTER
and NETDEV_UNREGISTER events. If the new name matches a hook spec and
registration fails, escalate the error and keep things as they are.

To avoid unregistering the newly registered hook again during the
following fake NETDEV_UNREGISTER event, leave hooks alone if their
interface spec matches the new name.

Note how this patch also skips for NETDEV_REGISTER if the device is
already registered. This is not yet possible as the new name would have
to match the old one. This will change with wildcard interface specs,
though.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v4:
- Avoid unregistering the new ops along with the old one(s) by accident.

Changes since v3:
- Register first and handle errors to avoid having unregistered the
  device but registration fails.
---
 net/netfilter/nf_tables_api.c    | 33 +++++++++++++++++++++++---------
 net/netfilter/nft_chain_filter.c | 33 +++++++++++++++++++++++---------
 2 files changed, 48 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 713ea0e48772..452f8a42d5e6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9690,16 +9690,20 @@ struct nf_hook_ops *nft_hook_find_ops_rcu(const struct nft_hook *hook,
 EXPORT_SYMBOL_GPL(nft_hook_find_ops_rcu);
 
 static int nft_flowtable_event(unsigned long event, struct net_device *dev,
-			       struct nft_flowtable *flowtable)
+			       struct nft_flowtable *flowtable, bool changename)
 {
 	struct nf_hook_ops *ops;
 	struct nft_hook *hook;
+	bool match;
 
 	list_for_each_entry(hook, &flowtable->hook_list, list) {
+		ops = nft_hook_find_ops(hook, dev);
+		match = !strcmp(hook->ifname, dev->name);
+
 		switch (event) {
 		case NETDEV_UNREGISTER:
-			ops = nft_hook_find_ops(hook, dev);
-			if (!ops)
+			/* NOP if not found or new name still matching */
+			if (!ops || (changename && match))
 				continue;
 
 			/* flow_offload_netdev_event() cleans up entries for us. */
@@ -9709,7 +9713,8 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			kfree_rcu(ops, rcu);
 			break;
 		case NETDEV_REGISTER:
-			if (strcmp(hook->ifname, dev->name))
+			/* NOP if not matching or already registered */
+			if (!match || (changename && ops))
 				continue;
 
 			ops = kzalloc(sizeof(struct nf_hook_ops),
@@ -9737,7 +9742,8 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 }
 
 static int __nf_tables_flowtable_event(unsigned long event,
-				       struct net_device *dev)
+				       struct net_device *dev,
+				       bool changename)
 {
 	struct nftables_pernet *nft_net = nft_pernet(dev_net(dev));
 	struct nft_flowtable *flowtable;
@@ -9745,7 +9751,8 @@ static int __nf_tables_flowtable_event(unsigned long event,
 
 	list_for_each_entry(table, &nft_net->tables, list) {
 		list_for_each_entry(flowtable, &table->flowtables, list) {
-			if (nft_flowtable_event(event, dev, flowtable))
+			if (nft_flowtable_event(event, dev,
+						flowtable, changename))
 				return 1;
 		}
 	}
@@ -9761,16 +9768,24 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	struct net *net;
 
 	if (event != NETDEV_REGISTER &&
-	    event != NETDEV_UNREGISTER)
+	    event != NETDEV_UNREGISTER &&
+	    event != NETDEV_CHANGENAME)
 		return NOTIFY_DONE;
 
 	net = dev_net(dev);
 	nft_net = nft_pernet(net);
 	mutex_lock(&nft_net->commit_mutex);
 
-	if (__nf_tables_flowtable_event(event, dev))
+	if (event == NETDEV_CHANGENAME) {
+		if (__nf_tables_flowtable_event(NETDEV_REGISTER, dev, true)) {
+			ret = NOTIFY_BAD;
+			goto out_unlock;
+		}
+		__nf_tables_flowtable_event(NETDEV_UNREGISTER, dev, true);
+	} else if (__nf_tables_flowtable_event(event, dev, false)) {
 		ret = NOTIFY_BAD;
-
+	}
+out_unlock:
 	mutex_unlock(&nft_net->commit_mutex);
 	return ret;
 }
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 7795dff13408..b59f8be6370e 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -319,17 +319,21 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
 };
 
 static int nft_netdev_event(unsigned long event, struct net_device *dev,
-			    struct nft_base_chain *basechain)
+			    struct nft_base_chain *basechain, bool changename)
 {
 	struct nft_table *table = basechain->chain.table;
 	struct nf_hook_ops *ops;
 	struct nft_hook *hook;
+	bool match;
 
 	list_for_each_entry(hook, &basechain->hook_list, list) {
+		ops = nft_hook_find_ops(hook, dev);
+		match = !strcmp(hook->ifname, dev->name);
+
 		switch (event) {
 		case NETDEV_UNREGISTER:
-			ops = nft_hook_find_ops(hook, dev);
-			if (!ops)
+			/* NOP if not found or new name still matching */
+			if (!ops || (changename && match))
 				continue;
 
 			if (!(table->flags & NFT_TABLE_F_DORMANT))
@@ -339,7 +343,8 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 			kfree_rcu(ops, rcu);
 			break;
 		case NETDEV_REGISTER:
-			if (strcmp(hook->ifname, dev->name))
+			/* NOP if not matching or already registered */
+			if (!match || (changename && ops))
 				continue;
 
 			ops = kmemdup(&basechain->ops,
@@ -363,7 +368,9 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 	return 0;
 }
 
-static int __nf_tables_netdev_event(unsigned long event, struct net_device *dev)
+static int __nf_tables_netdev_event(unsigned long event,
+				    struct net_device *dev,
+				    bool changename)
 {
 	struct nft_base_chain *basechain;
 	struct nftables_pernet *nft_net;
@@ -385,7 +392,7 @@ static int __nf_tables_netdev_event(unsigned long event, struct net_device *dev)
 			    basechain->ops.hooknum != NF_INET_INGRESS)
 				continue;
 
-			if (nft_netdev_event(event, dev, basechain))
+			if (nft_netdev_event(event, dev, basechain, changename))
 				return 1;
 		}
 	}
@@ -400,15 +407,23 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	int ret = NOTIFY_DONE;
 
 	if (event != NETDEV_REGISTER &&
-	    event != NETDEV_UNREGISTER)
+	    event != NETDEV_UNREGISTER &&
+	    event != NETDEV_CHANGENAME)
 		return NOTIFY_DONE;
 
 	nft_net = nft_pernet(dev_net(dev));
 	mutex_lock(&nft_net->commit_mutex);
 
-	if (__nf_tables_netdev_event(event, dev))
+	if (event == NETDEV_CHANGENAME) {
+		if (__nf_tables_netdev_event(NETDEV_REGISTER, dev, true)) {
+			ret = NOTIFY_BAD;
+			goto out_unlock;
+		}
+		__nf_tables_netdev_event(NETDEV_UNREGISTER, dev, true);
+	} else if (__nf_tables_netdev_event(event, dev, false)) {
 		ret = NOTIFY_BAD;
-
+	}
+out_unlock:
 	mutex_unlock(&nft_net->commit_mutex);
 	return ret;
 }
-- 
2.49.0

