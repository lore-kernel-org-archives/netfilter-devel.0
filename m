Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5C24C9F
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 15:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744731920; cv=none; b=cM6sw3F25+wb0yaQmq7+AyX3k7oRGJH/TzfdBoXnszs5eRbz2ujV/CanrLFW6ezCE/bQGGTuTMUICJJfQdJZfn/E2NKI8C4aTMxwFQwzmfMVUCzL0HsF78Rpqvnq2B3Z1tifdk4W2QLi8CpDms8+W0LiVRS4JPdcp9+zO5CEOIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744731920; c=relaxed/simple;
	bh=J0whI/sFEoMTzm8Xo/cNjTyg+VVMlid8QFq3G5Ezx4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iodbvV5D+KoBpuaH2csBAUQcsGoqsNEF5ohlki+hYlrj9EN4y9h4EkYwSmJ8WUd6o5o8kG3O9QiFqG0n3yVtxFkrCPcdkQdd/JyudStaOZ3nP51Wu1WA1BimA4WedR0KiXLFMelGbPZuzrqR9yd8M+Gz5sN2o1tPQSOZ8OzK3WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kZEbegGg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kZEbegGg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zRcL1l2ls+ekAzisGjc2igErIHWU3hqq/7I3QVrvEKc=; b=kZEbegGg9y7P701ejC6Imv9Y0E
	exoqXulAF/d1SXYC7VPzpcchzkiNMuRqPkwQHrryfRpuUcEYUH6jBRoLc3WoQPxp+zwcUwyhHY6i/
	q1j6Kr6Fx980kVDp/7H5lB93gZnbbMGhakpHbvAhFnICaxhfdbjsOZaiuwNb9j6IC7LEWJ2aeyX6m
	7AFTgDEYDEd7I6xfR6gWFzGmQo2eNslO3T14b0zI7Zb1BrwQqoj4Uzm82neG9yCR2HhX4qTzXoKsS
	6dwZM/b+qNYA1YzkBFs9yR3HourTOUEoiTLHxBtTfW817Oiww5GAo3WKIQwcHJAVd+66nPpO3tVAJ
	hmqtqSqA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u4iTM-0000000050r-459D;
	Tue, 15 Apr 2025 17:45:17 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v6 07/12] netfilter: nf_tables: Respect NETDEV_REGISTER events
Date: Tue, 15 Apr 2025 17:44:35 +0200
Message-ID: <20250415154440.22371-8-phil@nwl.cc>
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
index 523dab9b8ef4..f72f6c68c3a3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9663,8 +9663,8 @@ struct nf_hook_ops *nft_hook_find_ops_rcu(const struct nft_hook *hook,
 }
 EXPORT_SYMBOL_GPL(nft_hook_find_ops_rcu);
 
-static void nft_flowtable_event(unsigned long event, struct net_device *dev,
-				struct nft_flowtable *flowtable)
+static int nft_flowtable_event(unsigned long event, struct net_device *dev,
+			       struct nft_flowtable *flowtable)
 {
 	struct nf_hook_ops *ops;
 	struct nft_hook *hook;
@@ -9682,9 +9682,32 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
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
@@ -9696,15 +9719,19 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
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
index d22a708e63c8..15a5757a4802 100644
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
@@ -338,8 +338,28 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
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
 	}
+	return 0;
 }
 
 static int nf_tables_netdev_event(struct notifier_block *this,
@@ -351,7 +371,8 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	struct nft_chain *chain;
 	struct nft_table *table;
 
-	if (event != NETDEV_UNREGISTER)
+	if (event != NETDEV_REGISTER &&
+	    event != NETDEV_UNREGISTER)
 		return NOTIFY_DONE;
 
 	nft_net = nft_pernet(dev_net(dev));
@@ -370,7 +391,10 @@ static int nf_tables_netdev_event(struct notifier_block *this,
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

