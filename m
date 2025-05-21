Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B4A29C35D
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 20:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747860285; cv=none; b=OAD+Yd4dUJnWSeomudFuRRVbCgF0iOjJ7tK+Jmh1Rse5yA0SuRBU/hfVXzAFgBCxZXAOlxJHdDL2//dk30iy7vj/oCzU6PBDvvFWw9N3Usa+liHuRxWMk12bw57fGR/YpJ7H6U11MLK1VBbJiQoZXCrKE+7tzBAJmqKhOEN+29U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747860285; c=relaxed/simple;
	bh=SCyJ16/f+jH7gFXAksYyTfZrRvU3zjdY7cLO6qgeqdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eT030rSdz0EMpO9kDcaMcFkA3TfcQIPKualWqLQB2JB49QWDi/qSwPhKIVptHb/WoEmYvjVaFmJWBFLar3YdQbFWOQtB6ysQkAXRJ0TjRX3cn5zSRJqTT12e+EjBzdv6Qkuk4my7heL9Vync2SaIEd4dlkupNhK7LRAZ9xnA+zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=QSB0P916; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="QSB0P916"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CvIHb6ne8GUDpKoUJdnjBhtvzW/kSUQ2R9mk2B6B4ow=; b=QSB0P916ZlasCHfjKUrPj5MSeS
	BLE165VK3pdB5cTavIsIzdeQ/shK8XgCbtXDen2pEauGkRNX4hY9Fe5YjTwzSLnKRC6QvZuM7pI7x
	wSGn/7QL8IIxBX5rp0jFeE/MSvGTkg24U+7NJn4U54v3OpBH5ukFeG2RMQlmpYBSbI7C1vvLdwAkC
	HI8WnAoeQjIveCblWztTMjFagjTLLIh677w0P7qIIl5CdWjJMlAeKA/jrmCyW85UxeyNJIvHmbQB+
	fH6SzRolBcc78lK0b2kH/BzCZRV/eKx5EjiJQZWFAJ06ubyBP4l810JMZ6m9L872kK9g08/to6qQ1
	L3VAg+VQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHqIs-000000007Qy-2aY0;
	Wed, 21 May 2025 22:44:42 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v7 08/13] netfilter: nf_tables: Wrap netdev notifiers
Date: Wed, 21 May 2025 22:44:29 +0200
Message-ID: <20250521204434.13210-9-phil@nwl.cc>
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

Handling NETDEV_CHANGENAME events has to traverse all chains/flowtables
twice, prepare for this. No functional change intended.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c    | 34 ++++++++++++++++++----------
 net/netfilter/nft_chain_filter.c | 38 ++++++++++++++++++++------------
 2 files changed, 46 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f0f40aeccc0c..713ea0e48772 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9736,13 +9736,28 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
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
@@ -9752,17 +9767,12 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
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
index 58000b3893eb..7795dff13408 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -363,21 +363,14 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
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
@@ -392,15 +385,32 @@ static int nf_tables_netdev_event(struct notifier_block *this,
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
2.49.0

