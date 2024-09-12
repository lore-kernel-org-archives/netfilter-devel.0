Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563AE1A2657
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 12:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726143724; cv=none; b=bhOdcmHAk7cI3MazztcjFpW/X5XgxUGTIFhzyHyLVWZy4huVky/aYYyDvjz9Acn1znzZBXtTx58YSqqIPWDVTVGx4CWoWLnxRv5DoyiHV7u/8jNxJyQuhu5egn1OxxbvfzL3YFYr1KattimW9eOwrKXrc1ViZJG3VeL2skVmexY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726143724; c=relaxed/simple;
	bh=s6BHbbKgnYTtdaBq96ZYD3b+X8Wx9Dt9uwbQyk932C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACAP3uq5omYBihLsFvzMxK3xm/CWeltzjLMlOGZkaX0HHvlaDFZ72OMW9P5R2UEcgp22ZXkfV1NZNkKRIVcrs6eW67eHIthJIkcEkV3r9AN8CBzpQn8gVYaXh545+lU1AI/h+J5UhhDUoRbd0Mst12ilu1HW9pltJkvUKnTX0yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UcwZcc9B; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UcwZcc9B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=s+hdYPjHy51B83mynSlEIBjsIdD/JkM+tYg4cgrNF2g=; b=UcwZcc9BFEs+qGvqNI2K9akajm
	e8am4LbI6iTW51XH2DO2d78XLVcgHJVuluMHMRVRvrHIfozfGJV86A8GsLsC2aP6i1RQZp+oAnyzy
	/Doi99ykyGB0Ofas5eJkQu/zh6TKwsPWbbVRwji0qs9SpBo50gKcrSh9uDTgTSp7N1rH4Z6HEuU6Q
	NqnJiA+rQwZjNw5HhDAEwdhmwrJE37U4HmEqdxXcncrnkYZVwk9hci1OyQPZu3A0kRw6cZubfQDOc
	IHKhm3bQ4eyLDjACO8HNZZUUohz916AM44GuhJXpidYWtxPQXTzyOgPuW+BCANND+d5Z6VT/gs+C7
	hS7ZYbDg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1soipk-000000004Eh-2WIB;
	Thu, 12 Sep 2024 14:22:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v3 11/16] netfilter: nf_tables: chain: Respect NETDEV_REGISTER events
Date: Thu, 12 Sep 2024 14:21:43 +0200
Message-ID: <20240912122148.12159-12-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240912122148.12159-1-phil@nwl.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
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
 net/netfilter/nft_chain_filter.c | 40 +++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 2507e3beac5c..ec44c27a9d91 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -326,14 +326,37 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, &basechain->hook_list, list) {
-		ops = nft_hook_find_ops(hook, dev);
-		if (!ops)
-			continue;
+		switch (event) {
+		case NETDEV_UNREGISTER:
+			ops = nft_hook_find_ops(hook, dev);
+			if (!ops)
+				continue;
 
-		if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
-			nf_unregister_net_hook(ctx->net, ops);
-		list_del(&ops->list);
-		kfree(ops);
+			if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
+				nf_unregister_net_hook(ctx->net, ops);
+			list_del(&ops->list);
+			kfree(ops);
+			break;
+		case NETDEV_REGISTER:
+			if (strcmp(hook->ifname, dev->name))
+				continue;
+			ops = kzalloc(sizeof(struct nf_hook_ops),
+				      GFP_KERNEL_ACCOUNT);
+			if (ops) {
+				memcpy(ops, &basechain->ops, sizeof(*ops));
+				ops->dev = dev;
+			}
+			if (ops &&
+			    (ctx->chain->table->flags & NFT_TABLE_F_DORMANT ||
+			     !nf_register_net_hook(dev_net(dev), ops))) {
+				list_add_tail(&ops->list, &hook->ops_list);
+				break;
+			}
+			printk(KERN_ERR "chain %s: Can't hook into device %s\n",
+			       ctx->chain->name, dev->name);
+			kfree(ops);
+			continue;
+		}
 	}
 }
 
@@ -349,7 +372,8 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 		.net	= dev_net(dev),
 	};
 
-	if (event != NETDEV_UNREGISTER)
+	if (event != NETDEV_REGISTER &&
+	    event != NETDEV_UNREGISTER)
 		return NOTIFY_DONE;
 
 	nft_net = nft_pernet(ctx.net);
-- 
2.43.0

