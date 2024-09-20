Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FAF17BB11
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2024 20:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726863843; cv=none; b=aaJiDfyKTPRG0JRXdg4TWwJs1U/Oca2dDNDxqa305ooQ32R5BvwthDsoJE+KHxgxwC9KnbLhCFR0yS0r8vJbJWeF/v+66PMigEL+MELJJOISj6TmLwjX1LIF5a4uSaMIxxDF4UD/2NSUHIfD7ggkPKDr05mPkVq0AhjUQK9kxLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726863843; c=relaxed/simple;
	bh=7veRuSJhe1fYInwF0NO0mpbSufvJq6vDoNFfMcKnMHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5TwKARMImXiaMNRyQ2PvOzOOcS7k7dkXDZYGpl2xaKo4M1jzzffMZ248UlOy6Vf3eIjvjZHCAnLrn7ZlP6Uqlnv1M5ybcddvY+tTpZylfsq8TYjLYBmnK7hcAa7kstdLgxsu45T3eVOkWihpIGUiKircviMOgBgj2/shK9WbpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=d4TrXYcY; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="d4TrXYcY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zG10H4o/+fiEGf3I0H60FYFnnUXdm/rq1yKC8SA3+pM=; b=d4TrXYcYHhavMlIPveHdhLCg5V
	V7LHKPoROkUpzLqlv5gmkRocS1uHl3Z+j1/6dY9B4nMBMnlD/0fBMUb/a4xgMej+HeOUr9tWrUqGv
	+gGSnSMxgvxwmaSoKxhjVIkJUTMVpNhUD83U4HofEa79OirrvlmwQ/onWaMnBDpIckToMA+BdQFwP
	GfKtgIcGM8dJAdEvhOrDll1YpfoWw5W2Mv0gJ8FlsDy0B6OFqq9g1BrAHxfP4NwCBJs6ElzQ6Ihzf
	SNT9sLw+OOBOkATsaz/WEK1bJkY9uJgcY2FPKZ+McFoMt5HWE2y/6MQMeNLHHnPS8yyBt17BA6z6e
	L6E47bug==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1srkAR-000000006I0-2NPH;
	Fri, 20 Sep 2024 22:23:51 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v4 12/16] netfilter: nf_tables: flowtable: Respect NETDEV_REGISTER events
Date: Fri, 20 Sep 2024 22:23:43 +0200
Message-ID: <20240920202347.28616-13-phil@nwl.cc>
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
- Return NOTIFY_BAD upon error instead of printing an error message as
  per Florian.
---
 net/netfilter/nf_tables_api.c | 56 +++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f3b0bc2fe0e3..2684990dd3dc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9317,23 +9317,49 @@ struct nf_hook_ops *nft_hook_find_ops(const struct nft_hook *hook,
 }
 EXPORT_SYMBOL_GPL(nft_hook_find_ops);
 
-static void nft_flowtable_event(unsigned long event, struct net_device *dev,
-				struct nft_flowtable *flowtable)
+static int nft_flowtable_event(unsigned long event, struct net_device *dev,
+			       struct nft_flowtable *flowtable)
 {
 	struct nf_hook_ops *ops;
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, &flowtable->hook_list, list) {
-		ops = nft_hook_find_ops(hook, dev);
-		if (!ops)
-			continue;
+		switch (event) {
+		case NETDEV_UNREGISTER:
+			ops = nft_hook_find_ops(hook, dev);
+			if (!ops)
+				continue;
 
-		/* flow_offload_netdev_event() cleans up entries for us. */
-		nft_unregister_flowtable_ops(dev_net(dev), flowtable, ops);
-		list_del_rcu(&ops->list);
-		kfree_rcu(ops, rcu);
-		break;
+			/* flow_offload_netdev_event() cleans up entries for us. */
+			nft_unregister_flowtable_ops(dev_net(dev),
+						     flowtable, ops);
+			list_del_rcu(&ops->list);
+			kfree_rcu(ops, rcu);
+			break;
+		case NETDEV_REGISTER:
+			if (strcmp(hook->ifname, dev->name))
+				continue;
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
+		}
 	}
+	return 0;
 }
 
 static int nf_tables_flowtable_event(struct notifier_block *this,
@@ -9345,15 +9371,19 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
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
-- 
2.43.0

