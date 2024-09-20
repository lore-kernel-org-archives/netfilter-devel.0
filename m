Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079A2185B6E
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2024 20:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726863844; cv=none; b=iellq5Y/GrABPlME1fV7Epu+qbAe7n7XEreRBDrfh1fme63i9RkzBvlZ+5rHhSsjRouwbhiGunJojHyhrLnisiEwZbtWq+rtFVK4c1wV01y4r5QA8oKgSIW0t45ZzRCMmi7CwfDXBfse434tBck2cde6nXobIR16j9t88m364NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726863844; c=relaxed/simple;
	bh=O1IyLPi7Djvd9u33majP/RTurTtXwB7J/PEz4XVqzDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gq66L8qXFleb/cddBbqLlpsautN8deN3ugdSkjmeonvpavcjzlKeLka653JCrfEhh/obFIHKYDSdtMPIpFS24N9LR8bRWUVIIas9Yfe9dXSz6yUbYwedCVSfTxKb8EyxUlRHnR4VNRFpLDUpql8oGzESfKhmBkaY4HdSGqjxfq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=OGB/dswo; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="OGB/dswo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dLf0GZJQVAP/kMwlKXPmWvbRjSy72lPYP3a1mPaodvA=; b=OGB/dswokVfpnwcEL7D9UQiAkH
	jUM0NLJndXvJKdrKmnt3LlcnMsfaoMdvKhw07fcHgFi6wx7+3upyOSwHhNtRUHMHOkk4MNSC0In3A
	FRHdnqp9TXGKv53TAGCxTjbQvfIOqaEhr3maGF1cxHbwUUGF1xX5Ac80ejTS43nAXrdAfn2QlAJHE
	CVZmtyGamgTbHwZVt94jouKa4p+yaIHhhq0K9cga0kVdbRJUJVo0P7a5BNu0CQZZmzYJ4xcMST40N
	4PM4wHJ2ubO8bgDj43SpU/gw6lFxNlx5isoi9r+MFn37ZddkydF33it0KN881vDklDHP9yUlPJbTp
	X0FpSZZw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1srkAW-000000006Is-1dep;
	Fri, 20 Sep 2024 22:23:56 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v4 11/16] netfilter: nf_tables: chain: Respect NETDEV_REGISTER events
Date: Fri, 20 Sep 2024 22:23:42 +0200
Message-ID: <20240920202347.28616-12-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240920202347.28616-1-phil@nwl.cc>
References: <20240920202347.28616-1-phil@nwl.cc>
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
Changes since v3:
- Use list_add_tail_rcu() to avoid breaking readers.
- Use kmemdup() instead of kzalloc() && memcpy() as per Florian.
- Return NOTIFY_BAD upon error instead of printing an error message,
  also suggested by Florian.
---
 net/netfilter/nft_chain_filter.c | 50 +++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index f8c69d28d656..562af2773a66 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -318,23 +318,47 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
 	},
 };
 
-static void nft_netdev_event(unsigned long event, struct net_device *dev,
-			     struct nft_ctx *ctx)
+static int nft_netdev_event(unsigned long event, struct net_device *dev,
+			    struct nft_ctx *ctx)
 {
 	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
 	struct nf_hook_ops *ops;
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
+
+			if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
+				nf_unregister_net_hook(ctx->net, ops);
+			list_del_rcu(&ops->list);
+			kfree_rcu(ops, rcu);
+			break;
+		case NETDEV_REGISTER:
+			if (strcmp(hook->ifname, dev->name))
+				continue;
 
-		if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
-			nf_unregister_net_hook(ctx->net, ops);
-		list_del_rcu(&ops->list);
-		kfree_rcu(ops, rcu);
+			ops = kmemdup(&basechain->ops,
+				      sizeof(struct nf_hook_ops),
+				      GFP_KERNEL_ACCOUNT);
+			if (!ops)
+				return 1;
+
+			ops->dev = dev;
+
+			if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT) &&
+			    nf_register_net_hook(dev_net(dev), ops)) {
+				kfree(ops);
+				return 1;
+			}
+			list_add_tail_rcu(&ops->list, &hook->ops_list);
+			break;
+		}
 	}
+	return 0;
 }
 
 static int nf_tables_netdev_event(struct notifier_block *this,
@@ -349,7 +373,8 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 		.net	= dev_net(dev),
 	};
 
-	if (event != NETDEV_UNREGISTER)
+	if (event != NETDEV_REGISTER &&
+	    event != NETDEV_UNREGISTER)
 		return NOTIFY_DONE;
 
 	nft_net = nft_pernet(ctx.net);
@@ -371,7 +396,10 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 				continue;
 
 			ctx.chain = chain;
-			nft_netdev_event(event, dev, &ctx);
+			if (nft_netdev_event(event, dev, &ctx)) {
+				mutex_unlock(&nft_net->commit_mutex);
+				return NOTIFY_BAD;
+			}
 		}
 	}
 	mutex_unlock(&nft_net->commit_mutex);
-- 
2.43.0

