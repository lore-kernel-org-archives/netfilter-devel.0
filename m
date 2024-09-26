Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC701A42C7
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344612; cv=none; b=FVaPlo1gd420dr0sXEYO6MrHjz2+lBpyjPHI12tapNy5CFeK4uMcki7qketZuX11AfsPnMAdoz0slr/vyOH/yhC3iMlVnoy3DWsR629vIZ3KvOEDcG5HBuXoLfesCLo3TRc+EIdklpBueT+TbOgwuzIcdRYH1+axbl9u65PnQ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344612; c=relaxed/simple;
	bh=0VzE6lkQKy3x8iuMmvvt8HMZA/vHG6ffCkJug5UsrYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+K4fA5fHVk30z5Tp/UX8SZE4bw8rtkXFQEjgCnn1uitlMBH0Xe2hU/cw45rr/okVKvj3mM3beNmhuU5RyHralhgxrjMZUzNjM/nDhx0Qxtzmgigz4kfyGjldDbdVkizCGHSR+ev8b+FYb95nIu7d4wTIUaxk0D+ST6+2MxuF/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=VcRRrVBA; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VcRRrVBA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hNHzI1i+EOXGC2eVdg08qKlBw/CFzV2YedkMV+wPb98=; b=VcRRrVBAipQpIFcF8NdMB5SQbh
	QLPYqfwkPDpgM4Pk8T7kpRGzoBEodxcUiRmX7ocYGXyO5EzciInaEfF31r+TYBjNwgvfRIe5hn7fq
	c5U5sleVfngOzGJp4Y1GWu9cn9KvfyU4KwFzD++2oYYnExQxgmEk9oYvGY+7No+2VHqte7+a4WAbh
	2kBKFvGSdT2r2aVWZYRwRvQ1PIszsDdJ28RKc0ysFJ1n1JfLPh+5WG756wlQZzOTChokOHaCeKTcs
	I321h/F/f7pRYvAirN8kWipUCIIM9vCsHoG9jEj/nFZF7boEK2VJvliFsQN4Kin/+uxaakRRFje0y
	6z8fxOOA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stlEu-000000006FK-3wFu;
	Thu, 26 Sep 2024 11:56:48 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v5 13/18] netfilter: nf_tables: flowtable: Respect NETDEV_REGISTER events
Date: Thu, 26 Sep 2024 11:56:38 +0200
Message-ID: <20240926095643.8801-14-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240926095643.8801-1-phil@nwl.cc>
References: <20240926095643.8801-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hook into new devices if their name matches the hook spec.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 57 +++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f3b0bc2fe0e3..74df6048a892 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9317,23 +9317,50 @@ struct nf_hook_ops *nft_hook_find_ops(const struct nft_hook *hook,
 }
 EXPORT_SYMBOL_GPL(nft_hook_find_ops);
 
-static void nft_flowtable_event(unsigned long event, struct net_device *dev,
-				struct nft_flowtable *flowtable)
+static int nft_flowtable_event(unsigned long event, struct net_device *dev,
+			       struct nft_flowtable *flowtable)
 {
 	struct nf_hook_ops *ops;
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, &flowtable->hook_list, list) {
-		ops = nft_hook_find_ops(hook, dev);
-		if (!ops)
-			continue;
+		switch (event) {
+		case NETDEV_UNREGISTER:
+			ops = nft_hook_find_ops(hook, dev);
+			if (!ops)
+				continue;
 
-		/* flow_offload_netdev_event() cleans up entries for us. */
-		nft_unregister_flowtable_ops(dev_net(dev), flowtable, ops);
-		list_del_rcu(&ops->list);
-		kfree_rcu(ops, rcu);
-		break;
+			/* flow_offload_netdev_event() cleans up entries for us. */
+			nft_unregister_flowtable_ops(dev_net(dev),
+						     flowtable, ops);
+			list_del_rcu(&ops->list);
+			kfree_rcu(ops, rcu);
+			break;
+		case NETDEV_REGISTER:
+			if (strcmp(hook->ifname, dev->name))
+				continue;
+
+			ops = kzalloc(sizeof(struct nf_hook_ops),
+				      GFP_KERNEL_ACCOUNT);
+			if (!ops)
+				return 1;
+
+			ops->pf		= NFPROTO_NETDEV;
+			ops->hooknum	= flowtable->hooknum;
+			ops->priority	= flowtable->data.priority;
+			ops->priv	= &flowtable->data;
+			ops->hook	= flowtable->data.type->hook;
+			ops->dev	= dev;
+			if (nft_register_flowtable_ops(dev_net(dev),
+						       flowtable, ops)) {
+				kfree(ops);
+				return 1;
+			}
+			list_add_tail_rcu(&ops->list, &hook->ops_list);
+			break;
+		}
 	}
+	return 0;
 }
 
 static int nf_tables_flowtable_event(struct notifier_block *this,
@@ -9345,15 +9372,19 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	struct nft_table *table;
 	struct net *net;
 
-	if (event != NETDEV_UNREGISTER)
-		return 0;
+	if (event != NETDEV_REGISTER &&
+	    event != NETDEV_UNREGISTER)
+		return NOTIFY_DONE;
 
 	net = dev_net(dev);
 	nft_net = nft_pernet(net);
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
 		list_for_each_entry(flowtable, &table->flowtables, list) {
-			nft_flowtable_event(event, dev, flowtable);
+			if (nft_flowtable_event(event, dev, flowtable)) {
+				mutex_unlock(&nft_net->commit_mutex);
+				return NOTIFY_BAD;
+			}
 		}
 	}
 	mutex_unlock(&nft_net->commit_mutex);
-- 
2.43.0

