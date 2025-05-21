Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6390529CB5B
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 20:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747860290; cv=none; b=S2R7FCaAH71xxjYdb+vAAF/m7w8dnTelZ15i6SgI4TBcgLSNowAn/r8O0B3b/w79e53+Xkh5yqRYSk1AQzrUm7Ggr+ACiwCmd+hMtbkzYvzQmVznK2Yr05qmsacPV14MJ7thnTJ2b4DBP+PbNXyQy3eXNs5E8xkv+nZ8lEf/B3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747860290; c=relaxed/simple;
	bh=diKk2YVuFaVE2BhQj72YrpnPd7VHrXOyu7poIqCYnYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXk6nqU+bIA6bDQTjhF11AmYR522ObKPsQov5wZNQuVYaKnCoV8kUOUZ3ZBqjCSPTJDaZ7mlK01SiBxJSnrr9CCi3Se/5cdoYFMNDxTusGX7tEnULw++1WNleDGENf06UStXKft3s6UkPqICwfloe4vhogQerszCWf9JiOTFoFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=j0ekLqUF; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="j0ekLqUF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=O05k+pe1lmgy2DhzyMRLEF6sPWYHeMeFU+zr0w83HUg=; b=j0ekLqUF+k48yAM+7RIYmuoiy6
	1BLK2khfN9hG6CKKlIVUPyiM31LWrMni2UKtbeRQmUPkCyE26iYlSvgqAIlnWHP0AWCP5K+4YVzVA
	bBKcaYslMuFtYK9K3OpvKtQ7m8yxV27PuoW6BNpYwQgVDSBoet1mismG64caY6cvagHE2aYXfn61J
	X45YNT7NUoQ/svP4Pkx8DDMOHl92gjNWGFuWCvFo1u/sMorp6W63xGiNqV34QX0U0mgKmgbevy7Z2
	v1kN2vXGTZpPz141z5mmaJCWc60mRjcnJjYoatCpVI3rULZLd9X5ISG61dNQKe0CR/I636cFTEXj/
	P7GQ2m/g==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHqIw-000000007S5-2tNm;
	Wed, 21 May 2025 22:44:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v7 07/13] netfilter: nf_tables: Respect NETDEV_REGISTER events
Date: Wed, 21 May 2025 22:44:28 +0200
Message-ID: <20250521204434.13210-8-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521204434.13210-1-phil@nwl.cc>
References: <20250521204434.13210-1-phil@nwl.cc>
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
Changes since v5:
- Prep split into separate patch.
- Merged separate patches for netdev chains and flowtables.

Changes since v3:
- Use list_add_tail_rcu() to avoid breaking readers.
- Use kmemdup() instead of kzalloc() && memcpy() as per Florian.
- Return NOTIFY_BAD upon error instead of printing an error message,
  also suggested by Florian.
---
 net/netfilter/nf_tables_api.c    | 37 +++++++++++++++++++++++++++-----
 net/netfilter/nft_chain_filter.c | 32 +++++++++++++++++++++++----
 2 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 95b43499f551..f0f40aeccc0c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9689,8 +9689,8 @@ struct nf_hook_ops *nft_hook_find_ops_rcu(const struct nft_hook *hook,
 }
 EXPORT_SYMBOL_GPL(nft_hook_find_ops_rcu);
 
-static void nft_flowtable_event(unsigned long event, struct net_device *dev,
-				struct nft_flowtable *flowtable)
+static int nft_flowtable_event(unsigned long event, struct net_device *dev,
+			       struct nft_flowtable *flowtable)
 {
 	struct nf_hook_ops *ops;
 	struct nft_hook *hook;
@@ -9708,9 +9708,32 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
 			list_del_rcu(&ops->list);
 			kfree_rcu(ops, rcu);
 			break;
+		case NETDEV_REGISTER:
+			if (strcmp(hook->ifname, dev->name))
+				continue;
+
+			ops = kzalloc(sizeof(struct nf_hook_ops),
+				      GFP_KERNEL_ACCOUNT);
+			if (!ops)
+				return 1;
+
+			ops->pf		= NFPROTO_NETDEV;
+			ops->hooknum	= flowtable->hooknum;
+			ops->priority	= flowtable->data.priority;
+			ops->priv	= &flowtable->data;
+			ops->hook	= flowtable->data.type->hook;
+			ops->dev	= dev;
+			if (nft_register_flowtable_ops(dev_net(dev),
+						       flowtable, ops)) {
+				kfree(ops);
+				return 1;
+			}
+			list_add_tail_rcu(&ops->list, &hook->ops_list);
+			break;
 		}
 		break;
 	}
+	return 0;
 }
 
 static int nf_tables_flowtable_event(struct notifier_block *this,
@@ -9722,15 +9745,19 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	struct nft_table *table;
 	struct net *net;
 
-	if (event != NETDEV_UNREGISTER)
-		return 0;
+	if (event != NETDEV_REGISTER &&
+	    event != NETDEV_UNREGISTER)
+		return NOTIFY_DONE;
 
 	net = dev_net(dev);
 	nft_net = nft_pernet(net);
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
 		list_for_each_entry(flowtable, &table->flowtables, list) {
-			nft_flowtable_event(event, dev, flowtable);
+			if (nft_flowtable_event(event, dev, flowtable)) {
+				mutex_unlock(&nft_net->commit_mutex);
+				return NOTIFY_BAD;
+			}
 		}
 	}
 	mutex_unlock(&nft_net->commit_mutex);
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 2eee78b58123..58000b3893eb 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -318,8 +318,8 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
 	},
 };
 
-static void nft_netdev_event(unsigned long event, struct net_device *dev,
-			     struct nft_base_chain *basechain)
+static int nft_netdev_event(unsigned long event, struct net_device *dev,
+			    struct nft_base_chain *basechain)
 {
 	struct nft_table *table = basechain->chain.table;
 	struct nf_hook_ops *ops;
@@ -338,9 +338,29 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 			list_del_rcu(&ops->list);
 			kfree_rcu(ops, rcu);
 			break;
+		case NETDEV_REGISTER:
+			if (strcmp(hook->ifname, dev->name))
+				continue;
+
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
 		}
 		break;
 	}
+	return 0;
 }
 
 static int nf_tables_netdev_event(struct notifier_block *this,
@@ -352,7 +372,8 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	struct nft_chain *chain;
 	struct nft_table *table;
 
-	if (event != NETDEV_UNREGISTER)
+	if (event != NETDEV_REGISTER &&
+	    event != NETDEV_UNREGISTER)
 		return NOTIFY_DONE;
 
 	nft_net = nft_pernet(dev_net(dev));
@@ -371,7 +392,10 @@ static int nf_tables_netdev_event(struct notifier_block *this,
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
2.49.0

