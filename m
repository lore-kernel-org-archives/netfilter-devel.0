Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BE01ABEDD
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344622; cv=none; b=oTT5JsWnha9ryCCSjLmdA6HrJF6nzrRFkE6inJU3JXynOcuS592sasaCTC32lHofQ4SUo4e7rcJiAEfJuLatTPiIiuRmaidSsgyeMhEUurjEr2Goc4VSyaLQjHhvh17t5b2Xj5o2EVOswGKbkpSMW0nVAAcoUaXVkcD/0/JJDqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344622; c=relaxed/simple;
	bh=tSrOG1gvwhStvLvNbGNi0McYWSZgY1lNpvAntK1JKdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRwoaB7526KiqUszlnnI68VgyBoOV4uJdJoCI4WRyavS5DU3kqCu6RAJzbLGF2fzD4s1YiLLukt6wcokuV3BJ5C6Efb7pSDiixYkv5N1YLFQRNeU5uxyIGeZsLaq0Y1aoHMPlEXn34DlEI3bIZelO5qefASoxyBcKVt8r7W4mCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bKA2jtmH; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bKA2jtmH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Hp0a6PTjwsx8zC4II4aN9IsxsJg6WSdeG9rSCYNoHiI=; b=bKA2jtmHfEFQXW29CSBGB6J4QV
	0Ud+puFYiDTqVczhaXnQq4LLmXWOSV9qf2rjC5vMQR/RXFTR6soZS3DAQu0isbo+f0ELutroNJzY4
	FxudyYc98aenLpPg4/Nw/9MQIJvZm7mGYaOozT2OOd2JdC7jGqBtfseubEhR/drLaMbHnPi9W8OlV
	YrdJuCocR5v1z3OW2/rZ8kUSE0v9thQ+mE6Nf/03JtY3LGkZf/mwB3I0bRlqkZHukonbyZrjrYfqi
	yS4A453NfG1pQDHSXPUyFlz51P8OOBd99nT5fbdtilxue/Q4R8/JQI0gzeFz+Tg7KfXX2OVp/H6ra
	qs+v+GXw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stlF5-000000006HM-1bQJ;
	Thu, 26 Sep 2024 11:56:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v5 14/18] netfilter: nf_tables: Wrap netdev notifiers
Date: Thu, 26 Sep 2024 11:56:39 +0200
Message-ID: <20240926095643.8801-15-phil@nwl.cc>
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

Handling NETDEV_CHANGENAME events has to traverse all chains/flowtables
twice, prepare for this. No functional change intended.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v4:
- New patch.
---
 net/netfilter/nf_tables_api.c    | 34 ++++++++++++++++++----------
 net/netfilter/nft_chain_filter.c | 38 ++++++++++++++++++++------------
 2 files changed, 46 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 74df6048a892..77d0efbad641 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9363,13 +9363,28 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 	return 0;
 }
 
+static int __nf_tables_flowtable_event(unsigned long event,
+				       struct net_device *dev)
+{
+	struct nftables_pernet *nft_net = nft_pernet(dev_net(dev));
+	struct nft_flowtable *flowtable;
+	struct nft_table *table;
+
+	list_for_each_entry(table, &nft_net->tables, list) {
+		list_for_each_entry(flowtable, &table->flowtables, list) {
+			if (nft_flowtable_event(event, dev, flowtable))
+				return 1;
+		}
+	}
+	return 0;
+}
+
 static int nf_tables_flowtable_event(struct notifier_block *this,
 				     unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct nft_flowtable *flowtable;
 	struct nftables_pernet *nft_net;
-	struct nft_table *table;
+	int ret = NOTIFY_DONE;
 	struct net *net;
 
 	if (event != NETDEV_REGISTER &&
@@ -9379,17 +9394,12 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	net = dev_net(dev);
 	nft_net = nft_pernet(net);
 	mutex_lock(&nft_net->commit_mutex);
-	list_for_each_entry(table, &nft_net->tables, list) {
-		list_for_each_entry(flowtable, &table->flowtables, list) {
-			if (nft_flowtable_event(event, dev, flowtable)) {
-				mutex_unlock(&nft_net->commit_mutex);
-				return NOTIFY_BAD;
-			}
-		}
-	}
-	mutex_unlock(&nft_net->commit_mutex);
 
-	return NOTIFY_DONE;
+	if (__nf_tables_flowtable_event(event, dev))
+		ret = NOTIFY_BAD;
+
+	mutex_unlock(&nft_net->commit_mutex);
+	return ret;
 }
 
 static struct notifier_block nf_tables_flowtable_notifier = {
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index b1aa2d469776..073bafdf56c0 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -361,21 +361,14 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 	return 0;
 }
 
-static int nf_tables_netdev_event(struct notifier_block *this,
-				  unsigned long event, void *ptr)
+static int __nf_tables_netdev_event(unsigned long event, struct net_device *dev)
 {
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct nft_base_chain *basechain;
 	struct nftables_pernet *nft_net;
 	struct nft_chain *chain;
 	struct nft_table *table;
 
-	if (event != NETDEV_REGISTER &&
-	    event != NETDEV_UNREGISTER)
-		return NOTIFY_DONE;
-
 	nft_net = nft_pernet(dev_net(dev));
-	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (table->family != NFPROTO_NETDEV &&
 		    table->family != NFPROTO_INET)
@@ -390,15 +383,32 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 			    basechain->ops.hooknum != NF_INET_INGRESS)
 				continue;
 
-			if (nft_netdev_event(event, dev, basechain)) {
-				mutex_unlock(&nft_net->commit_mutex);
-				return NOTIFY_BAD;
-			}
+			if (nft_netdev_event(event, dev, basechain))
+				return 1;
 		}
 	}
-	mutex_unlock(&nft_net->commit_mutex);
+	return 0;
+}
+
+static int nf_tables_netdev_event(struct notifier_block *this,
+				  unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct nftables_pernet *nft_net;
+	int ret = NOTIFY_DONE;
+
+	if (event != NETDEV_REGISTER &&
+	    event != NETDEV_UNREGISTER)
+		return NOTIFY_DONE;
 
-	return NOTIFY_DONE;
+	nft_net = nft_pernet(dev_net(dev));
+	mutex_lock(&nft_net->commit_mutex);
+
+	if (__nf_tables_netdev_event(event, dev))
+		ret = NOTIFY_BAD;
+
+	mutex_unlock(&nft_net->commit_mutex);
+	return ret;
 }
 
 static struct notifier_block nf_tables_netdev_notifier = {
-- 
2.43.0

