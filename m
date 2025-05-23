Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD0A234971;
	Fri, 23 May 2025 13:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006880; cv=none; b=dsFTicFboA0R5b50zpPxz8kfr0hx1xWRpTyINieLn+WEmsO2iK+ONxwUuPQfidnt0QSBZY8BDrWNgR5F7lsDpcjdJfiy1Ph+fFUIsSC6AW/IzMssrvtK1Bn5g67NRlh3J7t8OZZdoB0APy10BFBeGXjDoTSv5zOJS0bALxZmkXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006880; c=relaxed/simple;
	bh=t6g+CgRxilWcd0AXN6Iqyw8xr0bv7/JiIhOBl3dLIGw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sNaXt/MPrU7ZzfJDXoy9TXWhEqStGPqcGN2LX5JZUi2MCODHCNyrK244WqS9ooa4S4ecSWP7VhuZbpGdQ9lfDWUvzZDh2JTZlMqgJFnS5Y9kzffF1zAGT4X55K4o8B3yT9WggiV/a4Rw0J+W6V4BkgGaKpCPN8P1Sw7WDKJmCjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aAeN5Xhl; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iOGwJA5A; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aAeN5Xhl";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iOGwJA5A"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 38B35602C5; Fri, 23 May 2025 15:27:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006878;
	bh=Lsph7UlBuGSXKMmVHB2aHgx+3UmSyXBCBNZ7C64PjDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aAeN5XhlhE2iPdwqD5plZCOK6xbZ3fwxn6WIqrcL/OqH+QDyCmDD7tqszXXJXYtbL
	 vEi6AgNU0AIpN6PcIJfMGhMhVsVmhye5KqD1IROoyKrGxEUQ7zm0k5DbiSiPiCKtrg
	 iDTMpkr5BQTYo2aTKi3OUe5LNAXsvJVWzUabwTi5Zwz7W2PCQ7HxGvpLpl/WJjic1i
	 Sv472+17msn7f4fZ3ogRn74CZDBmzWR2L5Jule6lRhLZkKa7AAizw1Fgwe0/Y/qyE8
	 eTyRqKOmr0EwMBmZGZGo2k1GcrR+04FuxyQO4RT+jqts6lgb3TJwU41ipkBvIEk1HT
	 NQuLE7cr6y0Qw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C1E9D6077E;
	Fri, 23 May 2025 15:27:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006850;
	bh=Lsph7UlBuGSXKMmVHB2aHgx+3UmSyXBCBNZ7C64PjDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOGwJA5A5Ih9wEPwnDyo52roJgyEU6HybuQZcYtwpZ7tT7KicIlXSfxESCVyoLihT
	 h1oSCbTryuop2yu0ErIsmAr69zyzsNWnAU5hpZnIk1g+k8LAZnn5FkxTq7TZsoFEjH
	 Ueq4kJ/KrM/WIN+7JC4f9v1NZQhFf+c3Bsx2WUN8IbfeY0iEaTIQcNfGadUaSk1dbk
	 5oob1OMbE/aUNbZANNMKw4JmJACvMXx2al4BfIAf0+EXTCZiJkxSWVY4XNY53h2XZ4
	 c+p2WktkbQUD+ckptH/G4hrNXUtmjgFvqCphpawNWXaOqenK1xF7M7cPfGQp6Yt4k7
	 l4AlV44yYtaSg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 15/26] netfilter: nf_tables: Introduce nft_hook_find_ops{,_rcu}()
Date: Fri, 23 May 2025 15:27:01 +0200
Message-Id: <20250523132712.458507-16-pablo@netfilter.org>
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

Also a pretty dull wrapper around the hook->ops.dev comparison for now.
Will search the embedded nf_hook_ops list in future. The ugly cast to
eliminate the const qualifier will vanish then, too.

Since this future list will be RCU-protected, also introduce an _rcu()
variant here.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
index 9998fcf44a38..c5b7922ca5bf 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9600,13 +9600,32 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
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
2.30.2

