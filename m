Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B650429CB3A
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 20:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747860287; cv=none; b=GtZ6l+XOa7xP7Cp6ogmq7EfTp5NbtpBef15gENX+6i06Hw8YE7xX4sAM2FVaWSglQdVykYAi1ONEWr2ZsJzBUqgkbr/sRp420kIJPmWxWHDvD+oZG8FjOqBDAr/iPIKaVlbbf2mO84/K4OEU/OxlZHrYs9Q4ttlo01Z4IK168f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747860287; c=relaxed/simple;
	bh=bNbEIR1b7jfO9OrmDf26lLLESZJve/MTdgVmszSH3zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGFk0I+wqChkq2oKwjzFlX8vJLKUbNb6H20B3Mtj5NAPTsJIkryEvN4J0Y1kBaegUj+ZYrCQcaFKz92ZrrR+RUHewwNBscIQxLtB7GylquqzhfYLsnJbiSK1AuBQlLSwPG313FzF7YPvGcd3ISyrq/dxUxzKbY1ramqQQNUDrpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Do4W4bw3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Do4W4bw3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GuDVJPIRFPxd95VCFBFYtw6GXxRPgTJrqliDew+z++A=; b=Do4W4bw3+PMVdcr64EwiNv20pQ
	teD22iLok95OMqX1SjxgH1t1vsQO2nR4vM3vMLMxGB0U8mNet7oA2xhO57W1vmHl8MjiR925iTVH2
	aTV375KPYiyAJ8QKAcuh+ADLcAEsWm5sysjcCIICz55W4SdsB3eMUIDOfIH7PHMCaDLF9B7XSaezI
	1olYlWZecupIv9G6g3mXA2j3uJjyQz8k8f5RH1M16gQ1z6KSZfvQ/A54PHf5OvFcthTvgw+DHS4qR
	jNMNJNd+HPufuxDLSqmCyEEFEhtlbPMJLBPZGNUF9mtowB86Zm10n8IrzD6T13FpiFyPXPZXs+Blq
	2zt3QClw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHqIu-000000007RJ-0avR;
	Wed, 21 May 2025 22:44:44 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v7 06/13] netfilter: nf_tables: Prepare for handling NETDEV_REGISTER events
Date: Wed, 21 May 2025 22:44:27 +0200
Message-ID: <20250521204434.13210-7-phil@nwl.cc>
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

Put NETDEV_UNREGISTER handling code into a switch, no functional change
intended as the function is only called for that event yet.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c    | 19 ++++++++++++-------
 net/netfilter/nft_chain_filter.c | 19 ++++++++++++-------
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 62bf498d1ec9..95b43499f551 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9696,14 +9696,19 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
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
+			/* flow_offload_netdev_event() cleans up entries for us. */
+			nft_unregister_flowtable_ops(dev_net(dev),
+						     flowtable, ops);
+			list_del_rcu(&ops->list);
+			kfree_rcu(ops, rcu);
+			break;
+		}
 		break;
 	}
 }
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 862eab45851a..2eee78b58123 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -321,19 +321,24 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
 static void nft_netdev_event(unsigned long event, struct net_device *dev,
 			     struct nft_base_chain *basechain)
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
 
-		list_del_rcu(&ops->list);
-		kfree_rcu(ops, rcu);
+			list_del_rcu(&ops->list);
+			kfree_rcu(ops, rcu);
+			break;
+		}
 		break;
 	}
 }
-- 
2.49.0

