Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2748329A3F7
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 15:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744731904; cv=none; b=KJAxWmdHuHRvB0orOqWi3lP7xxv7veMkVHPstftL8aQ1pbl7lXjAZAwoxc8DZeK5NW/pSxJBcL7FzQboVnroMHwPCDAqGJEF0jBT2Y7G9+xcmkrolXV0+I7OF+W1nuraqOQ2xyURF95Z+GqzhGJUP5MLVLs4JQoTX14SylK0pKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744731904; c=relaxed/simple;
	bh=vjDQ4jmtU3qNII6JIN6e4q6sWpDDtRLLMo4f8G/DSmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcqIcfBIIAdUcRq6A1atgQyC7FkVbyRzqGyQflgddyMAoqbUHj3uoge44vkKbNSe4plq8zbcOCusolLkx3L2+jicmihvuKiNMqBm+xi+tmIOB6iTqsSUe1LdmR9nZHwoq7y3kYdJqKoKBmzgRdgeU20e/YPrTFDAApoX9h1RQm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hbit3Cz9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hbit3Cz9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZALd93Vm7HzhyCCYEOxWaxT8GBE6BVAfis9oKUhwEsE=; b=hbit3Cz9rZD1Qdnv6+bXPYurzw
	iGYW2VRoPPYHFZUdFFn+OeyMkT6L9NfYtnSGTdxqnv4O3rMdATwORlN3wYW5cjOFIAtH3uk6XwEn0
	bE7zTqfwPyWt+6f8ZR3PQGTeEwQLmtTDfaMOC+1OaWuzksUTrsm91cX4dW2NGw+Bizum+IRMtNiIK
	0SuxpwnAaRnUc2ZC6X5+fE1kk5RTU4ZjHqhbhzBxAhdGGpriAjBVo10fbAoHKtLBm2pWvrxil5m/I
	5esPQrj9KsGhGBujyulXB3CosVUzEbW/ZZ6tRCs0/IeoLSylNw9SIp8tNiFKwxAt3N+zx8+lyF3EO
	WmHcxEoQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u4iT7-000000004zj-1jeF;
	Tue, 15 Apr 2025 17:45:01 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v6 09/12] netfilter: nf_tables: Handle NETDEV_CHANGENAME events
Date: Tue, 15 Apr 2025 17:44:37 +0200
Message-ID: <20250415154440.22371-10-phil@nwl.cc>
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
index ef94b48316a1..1e6fde6d3a07 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9664,16 +9664,20 @@ struct nf_hook_ops *nft_hook_find_ops_rcu(const struct nft_hook *hook,
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
@@ -9683,7 +9687,8 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			kfree_rcu(ops, rcu);
 			break;
 		case NETDEV_REGISTER:
-			if (strcmp(hook->ifname, dev->name))
+			/* NOP if not matching or already registered */
+			if (!match || (changename && ops))
 				continue;
 
 			ops = kzalloc(sizeof(struct nf_hook_ops),
@@ -9711,7 +9716,8 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 }
 
 static int __nf_tables_flowtable_event(unsigned long event,
-				       struct net_device *dev)
+				       struct net_device *dev,
+				       bool changename)
 {
 	struct nftables_pernet *nft_net = nft_pernet(dev_net(dev));
 	struct nft_flowtable *flowtable;
@@ -9719,7 +9725,8 @@ static int __nf_tables_flowtable_event(unsigned long event,
 
 	list_for_each_entry(table, &nft_net->tables, list) {
 		list_for_each_entry(flowtable, &table->flowtables, list) {
-			if (nft_flowtable_event(event, dev, flowtable))
+			if (nft_flowtable_event(event, dev,
+						flowtable, changename))
 				return 1;
 		}
 	}
@@ -9735,16 +9742,24 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
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
index 77b4d363f11e..89a53b7459a1 100644
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
@@ -362,7 +367,9 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 	return 0;
 }
 
-static int __nf_tables_netdev_event(unsigned long event, struct net_device *dev)
+static int __nf_tables_netdev_event(unsigned long event,
+				    struct net_device *dev,
+				    bool changename)
 {
 	struct nft_base_chain *basechain;
 	struct nftables_pernet *nft_net;
@@ -384,7 +391,7 @@ static int __nf_tables_netdev_event(unsigned long event, struct net_device *dev)
 			    basechain->ops.hooknum != NF_INET_INGRESS)
 				continue;
 
-			if (nft_netdev_event(event, dev, basechain))
+			if (nft_netdev_event(event, dev, basechain, changename))
 				return 1;
 		}
 	}
@@ -399,15 +406,23 @@ static int nf_tables_netdev_event(struct notifier_block *this,
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

