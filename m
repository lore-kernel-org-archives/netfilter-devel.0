Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144622920BE;
	Fri, 23 May 2025 13:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006893; cv=none; b=MzkCp7UEm3V+y5YaLevOi/k1DwwxbXMd+qNhwq4xDcYEA90qLgr0WpOKqTicAT4INIZ/Yo6Y5xhe9gp2uralFWiWjmJ0N92bBaNdO1WcQ13nDEIpAY0/c7fYnUsT4Rxjvndt2a2SpuSmNGy5nU254CrPaVxgfk03vXmJVzua46M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006893; c=relaxed/simple;
	bh=7vBG8dRDoYYwSblM0ryIPwM+XiJskgKRXcA3RSGXnyk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QaSzn6Ch6RipvPPpbCmxz67Cm/DbCs8weWQ01+YUdFlJY6PNaTKp8J1qYPFijUIAj9YU3oyBKNtb9FcrT6P4wHPlf8VEv9bj1yoW4HYFcRUcAW6Js7NulpL47zY7XDJ8q5TzPBkHPuFfATtfvM5Vkv0fNR8Ch4o9uiF38p5B4nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QTSeWVGY; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IJ5JCZ1b; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QTSeWVGY";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IJ5JCZ1b"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 9BDF4606CC; Fri, 23 May 2025 15:28:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006890;
	bh=uj1SY/8LCrrL3GFDQvMCjCNlPfb3mkwSg4Lclp476II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTSeWVGYoXsnIsgbULKQwQZci2SYdV7vcYKyD5Z/SbLcw2x/QwRX5DI/HJ+YnUA69
	 i56HmMg9fCi5XwmrbaAceOeAe1b6/Ktmd7+ql8TY1Q2uK1W5YRQIVpVBhydwk2rQhK
	 wmyTXeWHqJL3n+n0jOS2zGsFtDdlDKz1fq1tK7oESzktefM9pTuYEjEM4UrJ9lqUbx
	 Vl9or5/Eq5aQUI8FNHIoi3aKfQAFNwEv7jIOLutnDwp0DXVdmM1SO2HlP5tiKO84JR
	 vpQCcrQR0LVMLG2FxP0svdHHaSvOUZSfAarMOqmjak7zVXmHJsDVbWUfDC8FhZ+OU3
	 fdUOUwoIoFYcw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A1FF460769;
	Fri, 23 May 2025 15:27:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006852;
	bh=uj1SY/8LCrrL3GFDQvMCjCNlPfb3mkwSg4Lclp476II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJ5JCZ1bTrg5drnItdr+o17Y/0/MFTU/dUtw1niQC/XhsBgEpC8MQe3pMI/t08Bgw
	 hBnF7BZ1K/2DWHVK8YYlNmkbcR35czE1TGxIc5cF1p1Ax9sjdHBbis37ge2SvdMKP+
	 H5qEbyXG2Bbxedw7zFZxVXBvqMppSyv9wA57NvVALRWPG9WvTdatux56fRqch5PNDc
	 ck2ACPi20d9H9wv2GJG5j5uo1fPLqAEMZd/9znLtF4btZQF6+ujIfj8gw6sPDCP7s/
	 cM3/I674xu0TsVCZ6UVJLIuYW/kbR/buTrOYj6OYWAHJn7H4+N/AJFYMaMk7OuHpws
	 H+uz0UJh7/RLA==
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
Date: Fri, 23 May 2025 15:27:05 +0200
Message-Id: <20250523132712.458507-20-pablo@netfilter.org>
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

