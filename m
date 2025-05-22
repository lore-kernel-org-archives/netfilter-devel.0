Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943D729ACE5;
	Thu, 22 May 2025 16:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932814; cv=none; b=gDoAYwnVDNqTl3HVUslsTlkQAV0g1vrHgZGcONTLUrC1LoXy8MINaCzk5CFswrc5DqRjGo/iMcYJt4HBhrQsFPYmEsL2T2+7wfDVEGy1fUM/sIxQ9kcasV5MgG/mtZ4shgvoyLgT7y4Xdaho7VGu9wyteo8z3nCtvmdrHwHIilE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932814; c=relaxed/simple;
	bh=7vBG8dRDoYYwSblM0ryIPwM+XiJskgKRXcA3RSGXnyk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i/Upo3vCAXY4lS0DxOJA/SFLsaUzX0aswolv2eupzGd9F0Mx/md57ZTvrJiSPJbT0cwFWvhW+GZ34pRFKUNmLMRqN3gJpReec9Cg3TojxAekyR35tZTu/Tfpuqfk2rKjHU/+HQ4k0OJkRNTgjU9SpisFlxhln0OCr3sHfGw2Ggg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lwwQCJjn; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KOlsoQbt; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lwwQCJjn";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KOlsoQbt"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 08430606BC; Thu, 22 May 2025 18:53:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932811;
	bh=uj1SY/8LCrrL3GFDQvMCjCNlPfb3mkwSg4Lclp476II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwwQCJjndtcRT6mMWge9L+DKiGgq7jVz3GYtJ24YFb7hSuhnNEkUensqFyJOQ2g3y
	 q6VJjMqFEd2K/2xODAy/GFr5HJxmEms4Q1uU0MQFdrnhxjgY8kPcUYSzKFXJgXvZno
	 w6ZLY2f+95GEMPW6+zCH6eG231leU997CDBxB1U8lJMkGpMjhvkeoQWvhotuO5uBKV
	 la5n5Nd90fICE+Lxa3JccSuHoYs0Vga77Ty55ljRjebLId0ejvfOnA57LLn7WdCqVB
	 O5DisRBS7R5+mn4+y4Uu15KQ7WoM+/iX+wY/pFUbAe0KKJPneTLaZq3S5jhi59ORlp
	 na1lChZz/5Nmg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 84FDC6073B;
	Thu, 22 May 2025 18:52:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932779;
	bh=uj1SY/8LCrrL3GFDQvMCjCNlPfb3mkwSg4Lclp476II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOlsoQbtv0i1sdGvSeUBJ80um+8CHNhE5xoc1w3Rxjzb4q23pRO28E3+KuoDTtync
	 adocs4quvWXZn5DND6wEjI8ntghLS1mRe6GV5MlvhAqI8DkBOFlgtlhhbyvkDYYPy4
	 F6g6NFqvgUFl3xIrvSK38ZljzVwIsBOztmQGW4i851/Y9k/q0C8Vrnq8o31kXZH3TU
	 OMJdpec+seqhnRQjtwyY1jH4tIFooJTkVcj2D/SQj0oRDRQWTYZEFvLEYtWfqU7vqr
	 OZxp2dwTv7h0epqkhD9Jjir/Foq+SgfmxgifJko6Iq4FkkqwhBpAEsV92xPpq/MBag
	 iF/9qQwMc61Ew==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 19/26] netfilter: nf_tables: Prepare for handling NETDEV_REGISTER events
Date: Thu, 22 May 2025 18:52:31 +0200
Message-Id: <20250522165238.378456-20-pablo@netfilter.org>
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

Put NETDEV_UNREGISTER handling code into a switch, no functional change
intended as the function is only called for that event yet.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

