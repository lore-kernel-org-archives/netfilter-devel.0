Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62091AC8AC
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344614; cv=none; b=jKrxn/K2Bm/GR6JFrCnOL3FVBLQnPzLFNN0+tpujeD5TT2M746SImshv3GWekV9daU9CNcnJkKkT7QQ+/UqbIKSaZ8bV/DKWwbMcow8cL5sXRUtcs/DmEENpUxVeBmwy9Po3vXtYhL7lB+iw/Gng22T74enri9pqdo7QXaQTeHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344614; c=relaxed/simple;
	bh=UGlg9eQ9g5E9ajosPsV+CNx4XhF0IpN1AohXADxr3WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vj7Vev4Fn0sOhEloNPTeYNglMydhVajdNh87GLi7ZpsPyRTnBLlFFtyH2onrzDx5kNSJrQBUc9L+3kkX93yIWeZq5IsmJkI99FG3CHRj7wxa9DnaMtVnMNQD3H5PHRG3lGxvrhFFYzO0dc6NwlVqY24Ly/I29r4acQB06YlYvOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=eMAJg/do; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="eMAJg/do"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=b+5YWQaGky8Y+nT7ytAdfd/UnHx66JVPtPj+5RhgfF8=; b=eMAJg/dojHNAGlh0amhLuEseht
	N2M2ieiha3NYYYqxk2AfePNRFFEjwdPBdRLcxKb9zMY0ru5AlEVHxIf4Oyegzt005zC9GEQVu33jm
	NRS7RGOYTR5p7gthEXcBRAGpvS/jaNwKyMty1hfIFcg22QIxO1oyZLxfoo3pPMGww3hMrmUYNVVIR
	lw95yHLlD3DhowavfD3Mnfx/6IWmwYKtnQP4vtNpKsTt8jR76edz2vMXV7qcZokqatGZxxhT6ht93
	F+OXnCSJJMTIQMUnzXwuCt6ExVpvuyNySKFdmFyJ8tav9Rm+ddWD9z2NAcbHKMVXb7eejCVtIN9hC
	cV1Bvb5A==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stlEx-000000006Fh-1k9E;
	Thu, 26 Sep 2024 11:56:51 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v5 12/18] netfilter: nf_tables: chain: Respect NETDEV_REGISTER events
Date: Thu, 26 Sep 2024 11:56:37 +0200
Message-ID: <20240926095643.8801-13-phil@nwl.cc>
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

Hook into new devices if their name matches the hook spec.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v4:
- Introduce table pointer variable to reduce max line length.
---
 net/netfilter/nft_chain_filter.c | 50 +++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index bac5aa8970a4..b1aa2d469776 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -318,23 +318,47 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
 	},
 };
 
-static void nft_netdev_event(unsigned long event, struct net_device *dev,
-			     struct nft_base_chain *basechain)
+static int nft_netdev_event(unsigned long event, struct net_device *dev,
+			    struct nft_base_chain *basechain)
 {
+	struct nft_table *table = basechain->chain.table;
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
 
-		if (!(basechain->chain.table->flags & NFT_TABLE_F_DORMANT))
-			nf_unregister_net_hook(dev_net(dev), ops);
+			if (!(table->flags & NFT_TABLE_F_DORMANT))
+				nf_unregister_net_hook(dev_net(dev), ops);
+			list_del_rcu(&ops->list);
+			kfree_rcu(ops, rcu);
+			break;
+		case NETDEV_REGISTER:
+			if (strcmp(hook->ifname, dev->name))
+				continue;
 
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
+			if (!(table->flags & NFT_TABLE_F_DORMANT) &&
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
@@ -346,7 +370,8 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	struct nft_chain *chain;
 	struct nft_table *table;
 
-	if (event != NETDEV_UNREGISTER)
+	if (event != NETDEV_REGISTER &&
+	    event != NETDEV_UNREGISTER)
 		return NOTIFY_DONE;
 
 	nft_net = nft_pernet(dev_net(dev));
@@ -365,7 +390,10 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 			    basechain->ops.hooknum != NF_INET_INGRESS)
 				continue;
 
-			nft_netdev_event(event, dev, basechain);
+			if (nft_netdev_event(event, dev, basechain)) {
+				mutex_unlock(&nft_net->commit_mutex);
+				return NOTIFY_BAD;
+			}
 		}
 	}
 	mutex_unlock(&nft_net->commit_mutex);
-- 
2.43.0

