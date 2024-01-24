Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2F1B12AADA;
	Wed, 24 Jan 2024 19:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706123578; cv=none; b=Bz6MDRAE1YVbSnhoiPhCcY/F6aiiPppju2mPCnCfKntNJ3am1IvAkwrVO/+ociJD0eX23tSeOPmknS+V2XPGACzDf2+ujEUmLKJXYBpZJKZczKD4xfPZP5CVthPtkaMJBo1+4IXmr9LTLfAMzAU4cFOeHBzGPx0HPhvsQ+Ry+s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706123578; c=relaxed/simple;
	bh=0qwGptHC95pvptAhPhLvIc8MknwxfCfibrU7oQEdZhU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=beB9Nl8uVrREk3PfFzCuB4nNNWDQ+2KxPUTJNBJCmLORjkRvQ6pxpwKh5WCD3a27eGyuLgNRJPHLkVdGRDQMKsikCJVGTUDm0+LGwyo64gZwoRSr2xvUDvF3uns7+5A2xxjCdJTqqFNaRMVPz6pq0I+DdfdMTaiwc68vNLHN9hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 2/6] netfilter: nft_chain_filter: handle NETDEV_UNREGISTER for inet/ingress basechain
Date: Wed, 24 Jan 2024 20:12:44 +0100
Message-Id: <20240124191248.75463-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240124191248.75463-1-pablo@netfilter.org>
References: <20240124191248.75463-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove netdevice from inet/ingress basechain in case NETDEV_UNREGISTER
event is reported, otherwise a stale reference to netdevice remains in
the hook list.

Fixes: 60a3815da702 ("netfilter: add inet ingress support")
Cc: stable@vger.kernel.org
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_chain_filter.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 680fe557686e..274b6f7e6bb5 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -357,9 +357,10 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 				  unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct nft_base_chain *basechain;
 	struct nftables_pernet *nft_net;
-	struct nft_table *table;
 	struct nft_chain *chain, *nr;
+	struct nft_table *table;
 	struct nft_ctx ctx = {
 		.net	= dev_net(dev),
 	};
@@ -371,7 +372,8 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	nft_net = nft_pernet(ctx.net);
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
-		if (table->family != NFPROTO_NETDEV)
+		if (table->family != NFPROTO_NETDEV &&
+		    table->family != NFPROTO_INET)
 			continue;
 
 		ctx.family = table->family;
@@ -380,6 +382,11 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 			if (!nft_is_base_chain(chain))
 				continue;
 
+			basechain = nft_base_chain(chain);
+			if (table->family == NFPROTO_INET &&
+			    basechain->ops.hooknum != NF_INET_INGRESS)
+				continue;
+
 			ctx.chain = chain;
 			nft_netdev_event(event, dev, &ctx);
 		}
-- 
2.30.2

