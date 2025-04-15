Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC7A20298D
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 15:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744731899; cv=none; b=VHnsP/JvmZwJecwodGAbqf5TWqgbnrx0KrcMe9uYgojRZ6dgt9tT7YoLT4EVqUyVEJycsc/4pMyWz7J6zvTAdIQhFWjEE5aDCBVGH8SzR1b2Vf6JV5jLZz9C8QM8xnO+s7oVSa9cbyw5Sce6vK9AscNYygujfUw/djXYF3ZGK04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744731899; c=relaxed/simple;
	bh=WX8bBa8c1XfwRSj5sgGJdRTufU/zsGcMYFANurQQGcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vj5tGrojxJQNpVLhDFy9IGCsjp051SgI0sfZI0grijxyfSxryMZIMcNFfR3wNKzf+kGuNa961xUwe0Kh7mQMb6/7/0zP+Il/kiIiwcXTHXgX+fN8CKV8VHvktr8bc45aD7BP9vpdyjm56+uGvjuyQbwz0m63SOswAMNnbsdCx5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WDnwE3wJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WDnwE3wJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/fi7918lbay0LOs027CosBqdy5Pq3TP37gzNp6VnO1M=; b=WDnwE3wJd7PSI9ZQDu3+AwJNpJ
	2PbpPXGot6DIKv7PoULh5Ml0UnOyI03BSSGpXZxhkH3G5acFEGitp4vLFr+Dk6pRM8HwvG3Nc4iN7
	6dWdBb6lr3X/WPjZqGLSr2NUJKnYcCnK5if16e8/7JVP65dlJZnRiQodWyKy7/bQlOc9h6f382xej
	FnJzf2kBJ3gxJ+RO8M3Cg9zJXdZ/A1JK9BYpsHNJu+TWtPEH3NXizY+VK/fRaVmShXF+s9dqqI81U
	Zb9y8OIQ8YH/2NnNf+yFj5I1atilBWqM8wzCyd0y2zIhecLqRuCKG0IGaSOMfcDpq4wswbaXHCQjq
	5+YsQjEg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u4iSu-000000004xp-0SFd;
	Tue, 15 Apr 2025 17:44:48 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v6 02/12] netfilter: nf_tables: Introduce nft_hook_find_ops{,_rcu}()
Date: Tue, 15 Apr 2025 17:44:30 +0200
Message-ID: <20250415154440.22371-3-phil@nwl.cc>
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

Also a pretty dull wrapper around the hook->ops.dev comparison for now.
Will search the embedded nf_hook_ops list in future. The ugly cast to
eliminate the const qualifier will vanish then, too.

Since this future list will be RCU-protected, also introduce an _rcu()
variant here.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v5:
- Add nft_hook_find_ops_rcu() now rather than later although it is
  merely a wrapper around nft_hook_find_ops() for now.
---
 include/net/netfilter/nf_tables.h |  5 +++++
 net/netfilter/nf_tables_api.c     | 21 ++++++++++++++++++++-
 net/netfilter/nf_tables_offload.c |  2 +-
 net/netfilter/nft_chain_filter.c  |  6 ++++--
 net/netfilter/nft_flow_offload.c  |  2 +-
 5 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 803d5f1601f9..df0b151743a2 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1205,6 +1205,11 @@ struct nft_hook {
 	u8			ifnamelen;
 };
 
+struct nf_hook_ops *nft_hook_find_ops(const struct nft_hook *hook,
+				      const struct net_device *dev);
+struct nf_hook_ops *nft_hook_find_ops_rcu(const struct nft_hook *hook,
+					  const struct net_device *dev);
+
 /**
  *	struct nft_base_chain - nf_tables base chain
  *
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0e7cfbd3cf60..3e7a6b65177f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9574,13 +9574,32 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 	return -EMSGSIZE;
 }
 
+struct nf_hook_ops *nft_hook_find_ops(const struct nft_hook *hook,
+				      const struct net_device *dev)
+{
+	if (hook->ops.dev == dev)
+		return (struct nf_hook_ops *)&hook->ops;
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(nft_hook_find_ops);
+
+struct nf_hook_ops *nft_hook_find_ops_rcu(const struct nft_hook *hook,
+					  const struct net_device *dev)
+{
+	return nft_hook_find_ops(hook, dev);
+}
+EXPORT_SYMBOL_GPL(nft_hook_find_ops_rcu);
+
 static void nft_flowtable_event(unsigned long event, struct net_device *dev,
 				struct nft_flowtable *flowtable)
 {
+	struct nf_hook_ops *ops;
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, &flowtable->hook_list, list) {
-		if (hook->ops.dev != dev)
+		ops = nft_hook_find_ops(hook, dev);
+		if (!ops)
 			continue;
 
 		/* flow_offload_netdev_event() cleans up entries for us. */
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 64675f1c7f29..75b756f0b9f0 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -638,7 +638,7 @@ static struct nft_chain *__nft_offload_get_chain(const struct nftables_pernet *n
 			found = NULL;
 			basechain = nft_base_chain(chain);
 			list_for_each_entry(hook, &basechain->hook_list, list) {
-				if (hook->ops.dev != dev)
+				if (!nft_hook_find_ops(hook, dev))
 					continue;
 
 				found = hook;
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 19a553550c76..783e4b5ef3e0 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -321,14 +321,16 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
 static void nft_netdev_event(unsigned long event, struct net_device *dev,
 			     struct nft_base_chain *basechain)
 {
+	struct nf_hook_ops *ops;
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, &basechain->hook_list, list) {
-		if (hook->ops.dev != dev)
+		ops = nft_hook_find_ops(hook, dev);
+		if (!ops)
 			continue;
 
 		if (!(basechain->chain.table->flags & NFT_TABLE_F_DORMANT))
-			nf_unregister_net_hook(dev_net(dev), &hook->ops);
+			nf_unregister_net_hook(dev_net(dev), ops);
 
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 221d50223018..225ff293cd50 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -175,7 +175,7 @@ static bool nft_flowtable_find_dev(const struct net_device *dev,
 	bool found = false;
 
 	list_for_each_entry_rcu(hook, &ft->hook_list, list) {
-		if (hook->ops.dev != dev)
+		if (!nft_hook_find_ops_rcu(hook, dev))
 			continue;
 
 		found = true;
-- 
2.49.0

