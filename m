Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34D929DB7B;
	Thu, 22 May 2025 16:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932816; cv=none; b=LNs750M2DYj7JKaWovjBa89T6NPQmKKkPP7bC1X3UTlDsf/0KWFKqgmh8rBFyeBC12tH7BhRLMrmYK4mYXecmjXnmNUis+AtpIyefEYK3xrPh4YD7tNmsBraWyZV+0Z/mgjXOidnsc8KUWW2SqJlzFak3SeGUwZv+tfl8bbIZrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932816; c=relaxed/simple;
	bh=mnvVosvyaJhzQSfUWy6ca0bQi7Sh2nxm9AYKkr5Lv44=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kUilv2PuHoFq5sk6MviEwjpx2FKP88xfgQjGlcqWveF06PZNsBMcnGQT6AafHVp6W4m3YYclhV5wLyl5AkQPaqzXlxkyoreqfir1hEiN2Unl0wfxbKtvXEou3CWKv2ZrDG8HE50OGFK8cn2bNHKKqkiDiXLLINYPMMq8Fuq1v2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TnxRCfIE; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=u9I6nKjz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TnxRCfIE";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="u9I6nKjz"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C42C06070B; Thu, 22 May 2025 18:53:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932813;
	bh=00M7Ucr8uuUfUY8Dg5DIR4h7vkC8RsNEZ/HLsR31sSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TnxRCfIETWI6K9xh35bmcYOTsa4H1eGu90kws1t8jHbezYllnbNlMcPv4T0T7NMn4
	 djOsm/Dy9LUHwPXkUVGdOYxOZbHMCdd4F4v9hy//LzfVVAkPAia97cfK/sDfUJuXgX
	 BTPOIVuWW/yFJucAFgs7+c4UANBwgClet1roMXmFAlBX3ooCGEttnad2aQyfNNsAqg
	 G3LFWzeamIuOpCV9UlEu+COvRXard/pG808+uuqeQ0J3ejno1tfVR4un83xYAJ2yjn
	 dyTaVRFIiTsVHSY7ENHBQOMUjWfYLvuTmw2NCn+R8mop7HKZNKB/HHo3l/IpZy2fLv
	 rffMrW2XegDTg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A3AD16072A;
	Thu, 22 May 2025 18:53:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932782;
	bh=00M7Ucr8uuUfUY8Dg5DIR4h7vkC8RsNEZ/HLsR31sSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9I6nKjzbCSzShwNZ1ePrzWiWA6gyvxNYIsrMPZmh/+tD3eecDQpeuvz1aSkeBdl4
	 uFKoNKRqFGro7CXweABebOM54y1WGYRZ2aiORJSErZmEKMUmHjsVmLP1heGBb0w060
	 Z5n7V3LXM0NWg0VM59pemV3h5g7+aCIGLOE8rSaxItZtss7oUW8sg8ipnFDDBGZpO7
	 g18Ihwk5EI8UfCZ2uPkhgX5QrjwZQ+vo2MOj/U47iI8JGvoagjZnMDPNbN6Ze3KjJB
	 eWsXi7QoU+e6TGDmM71agz61HEqhW2mqzVBc8vcxoPAuwNz9gTOcvCLuk/jSlJijZE
	 0ym1Y9LiULkDQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 22/26] netfilter: nf_tables: Handle NETDEV_CHANGENAME events
Date: Thu, 22 May 2025 18:52:34 +0200
Message-Id: <20250522165238.378456-23-pablo@netfilter.org>
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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

