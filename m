Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CA42376E6
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Apr 2025 09:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744797287; cv=none; b=uOEF0VTo24fJheVtaCd7BcW8h40WzeEbGOsw2nn63lLeiJc7l+ToZNoJzt76bCMoI+/gRBjNhGIla5rkVJGhKu+5nxNFFWRH3xLwpB8bFk/Y8DlADzw8O6z1t9658MXtyjL5ROz4fh6xU5JqxkjouQFjerHaEjwcBgL9Sef3uAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744797287; c=relaxed/simple;
	bh=kduzWhTxvWOql+7rshr6aSaS2X1KJzpyZw69fxXn2k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwgkxzJ9k+1BOfvZkE2zZgS8LDWRWyAsxA5KT99d67PdzJci4vSKinnJkb2Hb5xGLG8x+LeW3kF8FtvXR6GuilUId2lKpy3HxFYlxE6fb9vWy1ROwlze23QRXBZDrleC2/i5hcbEMAPGFqINNdG5NTMpG1tbj/PXrfntL/Ywe20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aYMUp+3B; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aYMUp+3B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+XMCMMyk14cChuHhe43EICjEBxbi9+qx1nsmBCgtgpw=; b=aYMUp+3BO5EZOnRSkkfqkYlec0
	cnLZIeGptm2UurYrr0RuLhr1PP3MX7A/KYvY+g9h8evUYlA2jSFcogh5twLcYyVo/slePU2bs8h3+
	L9iP07gTm/2ypxjVAIP0VANmgdyT7AGeHIfDxrnrtUYUX8+L1e65IFS6XBPgSm8BmDZMNWHQ9sqVV
	x2pEVMFPpJRWdC60qhg/e/AVIzI9QEPKd+wVI8Kq6mPjxYPqimCAIN6fJw5nf9x+HrT/+zbrWqdqT
	orm/VGaF1iVjK0x3AJVn+9i5norJWuP0dR8qI+IMK01KZi2oxdVMVU6lIcorhgM1YtvC7adsVJeHV
	PVTUhN3Q==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u4zTe-000000006fZ-1FcJ;
	Wed, 16 Apr 2025 11:54:42 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v6 06/12] netfilter: nf_tables: Prepare for handling NETDEV_REGISTER events
Date: Tue, 15 Apr 2025 17:44:34 +0200
Message-ID: <20250415154440.22371-7-phil@nwl.cc>
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

Put NETDEV_UNREGISTER handling code into a switch, no functional change
intended as the function is only called for that event yet.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v5:
- New patch.
---
 net/netfilter/nf_tables_api.c    | 19 ++++++++++++-------
 net/netfilter/nft_chain_filter.c | 19 ++++++++++++-------
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fa439ecfca15..523dab9b8ef4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9670,14 +9670,19 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
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
index bac5aa8970a4..d22a708e63c8 100644
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
 	}
 }
 
-- 
2.49.0

