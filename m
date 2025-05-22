Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980F829ACE6;
	Thu, 22 May 2025 16:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932814; cv=none; b=sjSjbUVyweSoYzdk/W+f/R0yr1TYw/2mUVm7NpM1RSc89zg4pHxdxTioZ7OrP8BeJUwcuQjw9oEIjzjCLoIwVg20m0q04/EDsd8e1ljZmMJQ1+RLTkltuTNOIEhQb+cvxKqe9ZRe/BYms7RbcxDaasVyf/2prczB1jU0oyWu7e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932814; c=relaxed/simple;
	bh=Syiyilti+r0b2/kNmWa8pkHcnJImq95GunIqp9msQrc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YjRY81n8tM0kfNXJoBHsNo/V2zlohJtJCnFUZhQhyAvIJima2UHUSk93ilaieVRrnGgQbdPSGBFC6yLxbrMnBvfpG1WH1zAWQpnrM4qwQUx6E4xqU66xfEzyOA0AP7/g2oebpkSv2RU0KJREExW8mwXbgVlxWx0Bqr3AkcMjbG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=J8yR8b9I; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TRJVUDtk; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="J8yR8b9I";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TRJVUDtk"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8068460700; Thu, 22 May 2025 18:53:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932811;
	bh=Q0ngTBq4aZOnyh+MpW+hVYvOHp7xEm9M6amr/4euWW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8yR8b9I6SkBZpkKfteQ6TJPPvnA+85kYWyl05kFE65LodiTA9H4vUOn7wLZ2WQ7V
	 CyyBAHzJ7qujWQ4T9sudV5SGqH/s90HrpD42CCDWN4xV7pDlazn8apkWLMayY73Mxa
	 I8oWkLPqFYHB8/hyXh+gfKZc4Y0v9EVZn+sayUF1PRixjc+MeJrxLQDmCszR6s7isk
	 uyevyl2MNv8IbUmp4359AaiZRJQW41uA09qRx31WZ9gfQL5/CIBiRRD3Hz5KM3UEaD
	 x8PtCYxPnzoTzJ0dcSgo5jmnsQDbi2r9S+4kQtKpNPGuzJBMii2rjPCDwpxaNDKHXA
	 LE/WW5dBjppRg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 369A860722;
	Thu, 22 May 2025 18:53:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932780;
	bh=Q0ngTBq4aZOnyh+MpW+hVYvOHp7xEm9M6amr/4euWW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRJVUDtkdusnzx/MG17aZpoJHTL39jexqfvz3Ahcw15bNEYofimNl/Z26Y4Rtvx+d
	 KMau6WzMY+m2yOga8tmTyUhNtfikNtYig8gPqU59ZUzyfw6NWUqQcvyLdgky5nTiWy
	 TdlK/CA3DvOIPKim5kfZtL3Ef0TKdH+lt7u5dr8rrWrQErNS3IjhRSbTZ6b3Hykerb
	 FlxrK1dfxIoY3LLyv6l7JXYzZiMPtjSgXMLBbUlpiWyl8K11c6mnuE+AICkE5Uy0Ax
	 T3clHK6aTWkQAHrRM7fmBSs0ZJxkG+z2hL1tguhm6UTDYfwphrUxEfYII4kMnHSRbr
	 0jBPnDfRiKB3Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 20/26] netfilter: nf_tables: Respect NETDEV_REGISTER events
Date: Thu, 22 May 2025 18:52:32 +0200
Message-Id: <20250522165238.378456-21-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250522165238.378456-1-pablo@netfilter.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

Hook into new devices if their name matches the hook spec.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

