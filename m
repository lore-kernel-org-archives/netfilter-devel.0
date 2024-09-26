Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49F81ACDF5
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344617; cv=none; b=PRBtGSSwIsOcDBqMeYhwx1J0IduEoxCgUWwxKKoFe2tbiXKKGQVNofP19Nx230qaJnzEd/MxTFkqyZpR37IE3YDdOP6yE5lZp6c0SXqPsoQGSJ940i+6vFdwodw/VgbAXEpCdPeK6rItYMv7PqCr8HX6VOGUphCwXbNpukzR8qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344617; c=relaxed/simple;
	bh=1YqI6gudQTam+ahoQrquvuioXAifv8sO3nWhtd+JRvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2xqUFlhtXqG+JMuH8adwJa8HRXKEpbWFGj1uh8b74ZoHi89cKIbA1iFzHcKAfPidjnkUTsaMnj6OTmcrvyGmp9wCtHdREjPmDN9XdFPFmX9a8uGQ3Mm+XdpbQGHt03UWTQ17By+NDmWv0WIGXJdUcrBWQ8pv1GcCeE41T1hrWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dFdSNLld; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dFdSNLld"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uDhLD3ljiklRDp+tRfivppwyxGuN4N206ILBTCradMc=; b=dFdSNLldpkG+OYbDKrjFy7ZyJu
	kR0RqoJ7XmvabcYTIpx9j0BMiQmeAn0TkCQnCRtAFZYGYinPcMMEg+FX/E/X6YN52o+6JvD0YiQDg
	tnccGJ6j1jlii4iMth+rK0XCgBAQN6uMwQffPz+ePTvY9Xv3GCyD4rHOoUG1eiZHw2cnyYjwsXi4L
	FmOgDuEldJQuHqTjdx0RWqz8GqJwRdJnrooztGXWPkXryHo1QCqGnFjAUm0EB3D3khp7VnJ7zoV3W
	5l0uLzQThWscn0CH8As7/25j7/i32LZUwW72wrGC7pRpFf/Atr/yV6E2y7SsvE6kHLG3QfpKA87Ub
	P+vuOogQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stlF0-000000006GD-0hAP;
	Thu, 26 Sep 2024 11:56:54 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v5 15/18] netfilter: nf_tables: Handle NETDEV_CHANGENAME events
Date: Thu, 26 Sep 2024 11:56:40 +0200
Message-ID: <20240926095643.8801-16-phil@nwl.cc>
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
---
 net/netfilter/nf_tables_api.c    | 33 +++++++++++++++++++++++---------
 net/netfilter/nft_chain_filter.c | 33 +++++++++++++++++++++++---------
 2 files changed, 48 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 77d0efbad641..50221d4d747b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9318,16 +9318,20 @@ struct nf_hook_ops *nft_hook_find_ops(const struct nft_hook *hook,
 EXPORT_SYMBOL_GPL(nft_hook_find_ops);
 
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
@@ -9337,7 +9341,8 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			kfree_rcu(ops, rcu);
 			break;
 		case NETDEV_REGISTER:
-			if (strcmp(hook->ifname, dev->name))
+			/* NOP if not matching or already registered */
+			if (!match || (changename && ops))
 				continue;
 
 			ops = kzalloc(sizeof(struct nf_hook_ops),
@@ -9364,7 +9369,8 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 }
 
 static int __nf_tables_flowtable_event(unsigned long event,
-				       struct net_device *dev)
+				       struct net_device *dev,
+				       bool changename)
 {
 	struct nftables_pernet *nft_net = nft_pernet(dev_net(dev));
 	struct nft_flowtable *flowtable;
@@ -9372,7 +9378,8 @@ static int __nf_tables_flowtable_event(unsigned long event,
 
 	list_for_each_entry(table, &nft_net->tables, list) {
 		list_for_each_entry(flowtable, &table->flowtables, list) {
-			if (nft_flowtable_event(event, dev, flowtable))
+			if (nft_flowtable_event(event, dev,
+						flowtable, changename))
 				return 1;
 		}
 	}
@@ -9388,16 +9395,24 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
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
index 073bafdf56c0..ea07460d2bef 100644
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
@@ -338,7 +342,8 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 			kfree_rcu(ops, rcu);
 			break;
 		case NETDEV_REGISTER:
-			if (strcmp(hook->ifname, dev->name))
+			/* NOP if not matching or already registered */
+			if (!match || (changename && ops))
 				continue;
 
 			ops = kmemdup(&basechain->ops,
@@ -361,7 +366,9 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 	return 0;
 }
 
-static int __nf_tables_netdev_event(unsigned long event, struct net_device *dev)
+static int __nf_tables_netdev_event(unsigned long event,
+				    struct net_device *dev,
+				    bool changename)
 {
 	struct nft_base_chain *basechain;
 	struct nftables_pernet *nft_net;
@@ -383,7 +390,7 @@ static int __nf_tables_netdev_event(unsigned long event, struct net_device *dev)
 			    basechain->ops.hooknum != NF_INET_INGRESS)
 				continue;
 
-			if (nft_netdev_event(event, dev, basechain))
+			if (nft_netdev_event(event, dev, basechain, changename))
 				return 1;
 		}
 	}
@@ -398,15 +405,23 @@ static int nf_tables_netdev_event(struct notifier_block *this,
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
2.43.0

