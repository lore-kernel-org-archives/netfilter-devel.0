Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDE429345B;
	Fri, 23 May 2025 13:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006894; cv=none; b=j6lnSA3AXOMaO5jbMgpyIS+/NnsWDeJH0SEadcS37ykJ7WYmVxZOfDrONFj39DElKIHALSyJtKu0jMSZyjCsQitXKu/oIo0HTTtkcxuOQYr0EgjNgJpzOow3ZU1Pt0oOJ4GdWNdNquqFcM1kb75UAN/3vLDrLqWB/dhtARGjroU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006894; c=relaxed/simple;
	bh=Syiyilti+r0b2/kNmWa8pkHcnJImq95GunIqp9msQrc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pn3C3cznHNnLzGCzK8ZDQoThyV0aYr5GyQA28wi+URJTs5JGHMjPJDxxGNgzitxkKvUDdiGcqDtpGQw/huM3nPGjfZEmd2jMxuy2mIN38uxMsSnscWMr68wnWzjTnfAI69YMIaMDTzsybB3d/YGCfoCKvVS0gVh3r6BLkPEJNro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Okio7bXv; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JvgXByg2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Okio7bXv";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JvgXByg2"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5E4B4606CE; Fri, 23 May 2025 15:28:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006891;
	bh=Q0ngTBq4aZOnyh+MpW+hVYvOHp7xEm9M6amr/4euWW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Okio7bXvkROnI7Pfit4gq/Wu6WoM9pkPwNHu8pBkMEZAxCRMR0L2OtvRZptMnDR/4
	 9Kkplc5UHsZjYPIqk0C1Tj7yCvbWXsSrXXDPF8N8SwxfEG85quk+VDAw16RkaxyVYf
	 0DH0IwipWeZ5xJvCwUeUGzvHpR4+iPj5vsBEDoIRj2/uCecknYViXRLD8Z6ImRAkcZ
	 9qnjRZ1qhXRylkC/BOHPniG8l3a+KjwFFvZRlUS46dSQjq1r4Z7UtF0TQFky7VwNi/
	 FuUnS0cw5o45FofwMH2BeAUmhCOAfwQ9FFnbrR8pdN787XDMFkbv6s5MQl7mCyfAyz
	 F70V5uL1e8Sxg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 531796076E;
	Fri, 23 May 2025 15:27:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006853;
	bh=Q0ngTBq4aZOnyh+MpW+hVYvOHp7xEm9M6amr/4euWW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvgXByg2cr3q+5pNoxRVX4B0CPdSiHtVAexFcH2SgDdgj2g4snNVGVrx0DtYUOMSn
	 r1KapJ6zz4QNClcZXzBdD0ZpalAIBYWjVYnrYk4mBK4kRULuIWd1Iva2ZLsktk0Mkl
	 Kvz7gFdGBrUazXAKhQaLn/1lpfu06uXZQyjYwb5q642ekM7UZqvV27h0w4yGtKwr8+
	 G1dWdQivg3JHQspeLbqVmZbRm5iEZuzl0GcebHoHX0YiRXFo9MQE7N7or0Vrd1pUoo
	 ywBFH5WI3hi/mCVUJeWdgy5kflPVRQ7f8TRqBP/bbBifRH+D1O80GJ/xEEMqdyfsYf
	 5+03XCpeyMrRg==
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
Date: Fri, 23 May 2025 15:27:06 +0200
Message-Id: <20250523132712.458507-21-pablo@netfilter.org>
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

