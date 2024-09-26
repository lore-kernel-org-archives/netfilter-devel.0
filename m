Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A921ACDE2
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344620; cv=none; b=sZ6m74dv4r0EzlmESbW8thTKRIqedVGDXD9dyLLrrOibCiudpjQlcdassg0H5ljqlPR3txi9MNtXKxkhaVK8ewA/e+hYA7A6bR2ggGC0V2tuhqFC2EDo3bVxkqWJUYZEyD9x3G4WR3dupbHd7E/Tg3PpiAKgApwp2p6Gct/bQF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344620; c=relaxed/simple;
	bh=HNprAie9wJOpSmGxQ7lf53XlA4+R6N++oLrQl9qFvwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTEq6KT7FAQdDdFd3EbEueC4CMUv4ssOptwLE7KgiECLRJrineQ7DemAWCgYZip3gt63l+FKgToQfodREw0qTJ5hDV4/S4WQFVjQaT9D0K/3VDLF5WMGq39JBrcw1O//k5nfvg0l/KyBEvcOZl5AQLmInaTwSOmAZNVTA6/lLhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=eKw67xFU; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="eKw67xFU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=g8m6cmU/Yxk5XLQO3uVdjBMibX56rJ2pQJsXYtbf/eg=; b=eKw67xFUJcJh8Snc9ak1XsSx3Z
	VezWMvQVA376zBMx7Xq0sM5mzvZSr4QpEFBKttM8KC2uz22hPwO+2DLKiATShqiqri/+36yXdgclZ
	yazT/G5iCXmmZ5CuiqpbTsyCAFXK14doXaG74ZOupP7FXSimkDtYYeRMSpj8YhHuE127EdhK3xWBH
	onCX/P4IwmkoEcKzBnLy5Os5g2PSnSzVFhA9sk6EVwgmCn0nTfAO6R6qTb1R8iyvUtbjWqwXDLyKV
	aWzQ4fgkgkZ3cqh7DOoLzRZzXzXxZSOAWQ3FfUul5+Vy3fJ6hqjvk3xE9Ro8s/RqbDmZalvXZOlXu
	b6ncOStg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stlF4-000000006Gz-0xoX;
	Thu, 26 Sep 2024 11:56:58 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v5 08/18] netfilter: nf_tables: Introduce nft_hook_find_ops()
Date: Thu, 26 Sep 2024 11:56:33 +0200
Message-ID: <20240926095643.8801-9-phil@nwl.cc>
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

Also a pretty dull wrapper around the hook->ops.dev comparison for now.
Will search the embedded nf_hook_ops list in future. The ugly cast to
eliminate the const qualifier will vanish then, too.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h |  3 +++
 net/netfilter/nf_tables_api.c     | 14 +++++++++++++-
 net/netfilter/nf_tables_offload.c |  2 +-
 net/netfilter/nft_chain_filter.c  |  6 ++++--
 net/netfilter/nft_flow_offload.c  |  2 +-
 5 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 6aa39c4a8c3c..37d1110ccfd9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1196,6 +1196,9 @@ struct nft_hook {
 	u8			ifnamelen;
 };
 
+struct nf_hook_ops *nft_hook_find_ops(const struct nft_hook *hook,
+				      const struct net_device *dev);
+
 /**
  *	struct nft_base_chain - nf_tables base chain
  *
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a0482c7fc659..8326395c5752 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9253,13 +9253,25 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
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
index 2f732fae5a83..83415d7aadda 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -175,7 +175,7 @@ static bool nft_flowtable_find_dev(const struct net_device *dev,
 	bool found = false;
 
 	list_for_each_entry_rcu(hook, &ft->hook_list, list) {
-		if (hook->ops.dev != dev)
+		if (!nft_hook_find_ops(hook, dev))
 			continue;
 
 		found = true;
-- 
2.43.0

