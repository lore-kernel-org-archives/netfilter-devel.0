Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D575789D
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 15:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744731920; cv=none; b=D/ksjk07DbRuSp/Jp8RbXJG1m4R6lVDZ7TYE8dEXM8njUNOv5CLE4lNlrB5x+t4da09mBO9YOwY17XE+q0jVGn7FHX5C1Yxzo7rj9vbpFYF/CB4gaQGQ8hUPc12p0ktFylXUgd3R/H98wiCYL8J9x8RSTbSXHznkTV2rDy0fsto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744731920; c=relaxed/simple;
	bh=v4+bMU6fpMdRx76X+PI2R0M6gqWc4pGnQAcZg4fDn2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGF+EjNQ/KPjHuaXdhYiOU3rNV/5J9uYvx1StGo2SJu/63Hw9Eop43rb9MHOhj/Hdx/h+n7/RpByMW6/GLgXD/QQNlGYeWIRu82QfK1dRo8UzZA2AeJkjZEH4BQbgA0hqAUoPkQbjgnm2C/X8SFc+jzIOTc6fqdZU6SG20ONFQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=mYYvMlBp; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mYYvMlBp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YMnTP+i/Sc2nYj7NmxijwSaXc5nTq7+oHgaquesYgoA=; b=mYYvMlBpaxTqXCEUTro4zybyc+
	g/3bP/L9hHp1k1D86kSl79y6XVpEU/3K/546iRCnlAdrcJ0qHOaC0yfrf2fXP+awXyAU9yeDuloV6
	zU5rHXWVWcSU9MYaCwlepGemR51TMaAYTTIMN0HzPMtmPZFMGCgaMfTHO53aQ0hI90delmqtDriKc
	NGdrV9nCOLG6mP1VgNznoYVMam2Mwi+bESOfblfJu/gQ+/njPmzPgo5SaVK57gHL59km7sQMyH1Rn
	lXHg1kTQB+ThqNmemORCjh+YkimASw/VZHVjVFn8xPrr35Jr3CS1FfKProWqkbyrIhhYY9JFd8qdn
	K/dSX15g==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u4iTN-0000000050y-2Azi;
	Tue, 15 Apr 2025 17:45:17 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v6 08/12] netfilter: nf_tables: Wrap netdev notifiers
Date: Tue, 15 Apr 2025 17:44:36 +0200
Message-ID: <20250415154440.22371-9-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250415154440.22371-1-phil@nwl.cc>
References: <20250415154440.22371-1-phil@nwl.cc>
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
index f72f6c68c3a3..ef94b48316a1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9710,13 +9710,28 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
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
@@ -9726,17 +9741,12 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
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
index 15a5757a4802..77b4d363f11e 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -362,21 +362,14 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
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
@@ -391,15 +384,32 @@ static int nf_tables_netdev_event(struct notifier_block *this,
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

