Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817812920BB;
	Fri, 23 May 2025 13:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006900; cv=none; b=iBH5wAKxv1UTzMKYaFK4zy9mM4uEOG0edzk3VakLpN/9EAxFApExw2FvtOnHXA5fVsHt2J44O2xSm3NFgIiyHsZwiI/asGIizKGvkZeUrj9inB3YkLVESOPrWzxaI/64MY9Egda+asvrQQk83QhDGUe8/hs7QsBf4aCrD0Jt/JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006900; c=relaxed/simple;
	bh=mnvVosvyaJhzQSfUWy6ca0bQi7Sh2nxm9AYKkr5Lv44=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PjFEH6HeoMsRpb78McmL6sVSF7M0uD0xFhz+l7IHKahijQSohH/RBhqSY0Q1C+mWgIfGARGpUOuijPSpmQag+dHSeolzzHppLWTcdV6B6qIw2dSN3T/xOQvWeJT4eOaGkYzbqqSlyD3NTc/xaCbwHt8cy1vIC6c0TcSErB5tFTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VtroNjYC; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Iuuvw39E; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VtroNjYC";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Iuuvw39E"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 61CC4606F6; Fri, 23 May 2025 15:28:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006896;
	bh=00M7Ucr8uuUfUY8Dg5DIR4h7vkC8RsNEZ/HLsR31sSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtroNjYC6wRxPmBhw9mDdMIADG0DMz0bzODaDXmxvk8FGGYAGqGF87WhG2MoLPzei
	 NO81kiUsjw6U34lZe9pKFfYqqkU79l6M2JJzRUK6oCpnjIUuaRknTRrPvCYo2pXnyI
	 yaIPSvI1AhcoEBhUzc6nmWQCMo8zQsD8cpQrWzF4t0GgYpkIX8MR5ZsHvzFnHMd8CX
	 /P/iNg4Sng9cwIPIWdEVUx9qt9/9O/kGcBsmMUfQMpIiHNkGq0IHJLt3ZwY7IBtmI9
	 5nq4u/VGtIpWFP+pbeHs5uCg9QckatE0289LNYKcLycbJ3zgCiVm6QdZlgBBffKt8F
	 yUvyYtummBOXQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9F6A060761;
	Fri, 23 May 2025 15:27:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006854;
	bh=00M7Ucr8uuUfUY8Dg5DIR4h7vkC8RsNEZ/HLsR31sSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iuuvw39Eqf0ynNq2WjzcJRWsZbrp8XDmjE7EO0lunTLVqO3xmAl0N8+VwFf3UN24s
	 UoNXqtc2kVFohaafHa1KPaHhm1vk8QG9wXsExE4hBIp+wTA54IbYjlvgCSWn2RFwpM
	 1Bb4I4FZfk2uA9bqVIs2V+tApBct66mMGpaeO/6RrHZVu4OVvcC1Hu+7wM80Ndb/H4
	 4ZoqKVNkJUFbeqTxxVjScQPw8UCvF50uk/I9W0LsKVEFpko37XS76f7h2zmcVeVpju
	 fFQ0d8HWVBxM+p2Ci9+j2lkusH/zg4bos/vXrI0GH2uhY/HMfBRLb/xnCWlbBzoqsa
	 KROqvPTrtIkzw==
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
Date: Fri, 23 May 2025 15:27:08 +0200
Message-Id: <20250523132712.458507-23-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250523132712.458507-1-pablo@netfilter.org>
References: <20250523132712.458507-1-pablo@netfilter.org>
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

