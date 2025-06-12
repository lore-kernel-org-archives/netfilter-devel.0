Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141B4252288
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 13:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749735266; cv=none; b=nh4JoQeOmYbKTak+eEaG4+IVgYB/jKgNb+AFSsKkcM/gmYEXONFZUlHTB+AL2zouSHlw60pMGN3qUnZ4PCJiyKrWLxVBd5+KUKpkPliew5Ul7LUuiYu5FUmM4yiT7uMer+LOO+Mxy9RN3EV1VhpV7iaeNq6ECa9r9Lkm+GLebJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749735266; c=relaxed/simple;
	bh=OJcdBGyyPZ8aKBTx9YfEtmblRR8BgKg5I4zlCbxd3SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxU7n182PBQfHJVgypy0NoRdTcvMsgDh9aU0xkGHIt+SKcT4QWc0tiUXH3AnDbpkGieZZOes/66hogVleQYkWGquRb7DR0ikb/08UoBqvFcg1t6XSkvnbg9yLSym1RKenTWOuJHoAJvjrZSw2O8KyoTNn0vwcA9S5qAT0Xw/CIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZwvLHZf1; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZwvLHZf1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jrmmLpk1i0MzgIQj/pwmeWwXUHIdwgPVjtQNc6CZra8=; b=ZwvLHZf1HqZs1sC7iis6Qr/yKX
	MJgzq6hnalC9SaGy7EMXs40B8sB3sxDuUVqIQXN/vMNOSPb5AePmxicFqF8f18ylfjqhJuIM4D1YF
	LSgIRbKqupUhcA2B8wSEX8cMDG6GbZNTN6Be14d/PXxgwLKo+gBH0kWd3fuUVkbyd3iDjq70TLQrf
	JCW6lzAq3qHDNOoKjEsU6Wr1x1J2+IoEGxiokQ+YYBXf7qZrymYU5C/UpaMPGcMCN2wWmeZWCTfQf
	jz0r2E7z5qiy3V+xSWxJ0usP4ze9sFuqNxaoFV3KnH+bHs4opDo9GH3FXrEN7j3h4M7DOiaRNqBbR
	r5zrPqog==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPi4U-000000000s0-1fIh;
	Thu, 12 Jun 2025 15:34:22 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 2/3] netfilter: nf_tables: Support enqueueing device notifications
Date: Thu, 12 Jun 2025 15:34:15 +0200
Message-ID: <20250612133416.18133-3-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250612133416.18133-1-phil@nwl.cc>
References: <20250612133416.18133-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used for generating notifications during commit in a
follow-up patch. No functional change intended.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h |  3 ++-
 net/netfilter/nf_tables_api.c     | 26 ++++++++++++++++++--------
 net/netfilter/nft_chain_filter.c  |  2 +-
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e4d8e451e935..9bff7fadcf33 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1145,7 +1145,8 @@ void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 struct nft_hook;
 void nf_tables_chain_device_notify(const struct nft_chain *chain,
 				   const struct nft_hook *hook,
-				   const struct net_device *dev, int event);
+				   const struct net_device *dev, int event,
+				   bool report, struct list_head *notify_list);
 
 enum nft_chain_types {
 	NFT_CHAIN_T_DEFAULT = 0,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index da12a5424e6d..635332bad1b1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9699,7 +9699,8 @@ EXPORT_SYMBOL_GPL(nft_hook_find_ops_rcu);
 static void
 nf_tables_device_notify(const struct nft_table *table, int attr,
 			const char *name, const struct nft_hook *hook,
-			const struct net_device *dev, int event)
+			const struct net_device *dev, int event,
+			bool report, struct list_head *notify_list)
 {
 	struct net *net = dev_net(dev);
 	struct nlmsghdr *nlh;
@@ -9727,8 +9728,12 @@ nf_tables_device_notify(const struct nft_table *table, int attr,
 		goto err;
 
 	nlmsg_end(skb, nlh);
-	nfnetlink_send(skb, net, 0, NFNLGRP_NFT_DEV,
-		       nlmsg_report(nlh), GFP_KERNEL);
+
+	if (notify_list)
+		nft_notify_enqueue(skb, report, NFNLGRP_NFT_DEV, notify_list);
+	else
+		nfnetlink_send(skb, net, 0, NFNLGRP_NFT_DEV,
+			       report, GFP_KERNEL);
 	return;
 err:
 	if (skb)
@@ -9739,19 +9744,23 @@ nf_tables_device_notify(const struct nft_table *table, int attr,
 void
 nf_tables_chain_device_notify(const struct nft_chain *chain,
 			      const struct nft_hook *hook,
-			      const struct net_device *dev, int event)
+			      const struct net_device *dev, int event,
+			      bool report, struct list_head *notify_list)
 {
 	nf_tables_device_notify(chain->table, NFTA_DEVICE_CHAIN,
-				chain->name, hook, dev, event);
+				chain->name, hook, dev, event,
+				report, notify_list);
 }
 
 static void
 nf_tables_flowtable_device_notify(const struct nft_flowtable *ft,
 				  const struct nft_hook *hook,
-				  const struct net_device *dev, int event)
+				  const struct net_device *dev, int event,
+				  bool report, struct list_head *notify_list)
 {
 	nf_tables_device_notify(ft->table, NFTA_DEVICE_FLOWTABLE,
-				ft->name, hook, dev, event);
+				ft->name, hook, dev, event,
+				report, notify_list);
 }
 
 static int nft_flowtable_event(unsigned long event, struct net_device *dev,
@@ -9801,7 +9810,8 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			list_add_tail_rcu(&ops->list, &hook->ops_list);
 			break;
 		}
-		nf_tables_flowtable_device_notify(flowtable, hook, dev, event);
+		nf_tables_flowtable_device_notify(flowtable, hook, dev, event,
+						  false, NULL);
 		break;
 	}
 	return 0;
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 846d48ba8965..17845cf24038 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -364,7 +364,7 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 			break;
 		}
 		nf_tables_chain_device_notify(&basechain->chain,
-					      hook, dev, event);
+					      hook, dev, event, false, NULL);
 		break;
 	}
 	return 0;
-- 
2.49.0

