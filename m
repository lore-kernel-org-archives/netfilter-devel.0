Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55263ACEEE;
	Tue, 17 Mar 2026 11:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773746982; cv=none; b=eR/zfD5Iz+MUwyJPy5fXo2T4ZzyaOpnyQ1dc+3cCUCpt5q4BIB/wZ9/Wg7sz0iznm7pGtRKckLYl6DoagGqGuIQkdPOBdZkCUZvPEmUOmlBADKqalboTt8kvkNgiPIv1XSNShv/vfH1p5jhQQrzeNFKHsnChSKuHxkPYuFeCNPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773746982; c=relaxed/simple;
	bh=zjQ+HAPRaHRo1Oeu6TsS/Rqp3X4Af9pvCqxmMTMvlbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rslTrtb1ok8zbd4idiR3SI5rgKi5kJSOhDZ9vpEALAJV0HdoRygWpgDaIShWD2DG56oDGkfAeKMoaqVVSsWTn+GrJzoA5A0A5YOMXQKSMscTi0XW4Y/al7YjITUiG/F8+IwNENhgIvhPr4nkcFOL34eDAWmwl0XWJa2KU8KS5cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Hk66rkOk; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Hk66rkOk"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2ADF560264;
	Tue, 17 Mar 2026 12:29:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773746976;
	bh=1hurq3r+y7BWEXsJ2KfABuEy+xsHpHpgQsbYbcADmCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hk66rkOkd/y15tQx5hIvqaPRsw1xUcce7f9hDxTspI7l45XdNnpwXTyriGNfS2Njy
	 kXtuogj+P5qNS0HnghSJa0e26DdvIPll0rx6EeI6fbPmHCNK8uT9P0S9bK1mwRJ/Md
	 o0nBSSXf9EBB48v9eE4diR9arZSlrJ1S9xovUT8bfjZ46A65n5GeOV7pVPOc7QdOER
	 K5/zzoEp1JrmxYJT95Heo3v/Ir/oJeqnIkd0eWMsropv+AvthAdIg07krgg4m/a+he
	 S5l/5NUHLwC5Lj6qpWoo07mkq8TVrxnbmdiHdULanshu1ST43vHJqUp9OLeSJ4zAkX
	 Nxka7xuQwfH4w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org,
	steffen.klassert@secunet.com,
	antony.antony@secunet.com
Subject: [PATCH net-next,RFC 5/8] netfilter: nf_tables: add early ingress chain
Date: Tue, 17 Mar 2026 12:29:14 +0100
Message-ID: <20260317112917.4170466-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260317112917.4170466-1-pablo@netfilter.org>
References: <20260317112917.4170466-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new filter chain to filter out packets from the early_ingress hook.

This is the second user of this new hook, after the flowtable.

Co-developed-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_chain_filter.c | 116 ++++++++++++++++++++++++++++++-
 1 file changed, 114 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 47a612bdd03e..3467f7b7bd38 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -210,17 +210,75 @@ static unsigned int nft_do_chain_inet_ingress(void *priv, struct sk_buff *skb,
 	return nft_do_chain(&pkt, priv);
 }
 
+static unsigned int
+nft_do_chain_inet_early_ingress(void *priv, struct sk_buff *unused,
+				const struct nf_hook_state *state)
+{
+	struct nf_hook_state ingress_state = *state;
+	struct sk_buff *skb, *nskb;
+	struct nft_pktinfo pkt;
+	LIST_HEAD(accept_list);
+	int ret;
+
+	list_for_each_entry_safe(skb, nskb, state->skb_list, list) {
+		skb_list_del_init(skb);
+
+		skb_reset_network_header(skb);
+		if (!skb_transport_header_was_set(skb))
+			skb_reset_transport_header(skb);
+		skb_reset_mac_len(skb);
+
+		ret = nft_set_pktinfo_ingress(&pkt, skb, &ingress_state);
+		switch (ret) {
+		case 1:
+			list_add_tail(&skb->list, &accept_list);
+			continue;
+		case 0:
+			break;
+		case -1:
+			kfree_skb(skb);
+			continue;
+		default:
+			break;
+		}
+
+		ret = nft_do_chain(&pkt, priv);
+		switch (ret) {
+		case NF_ACCEPT:
+			list_add_tail(&skb->list, &accept_list);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			fallthrough;
+		case NF_DROP:
+			kfree_skb(skb);
+			break;
+		}
+	}
+
+	WARN_ON_ONCE(!list_empty(state->skb_list));
+
+	list_splice(&accept_list, state->skb_list);
+
+	if (list_empty(state->skb_list))
+		return NF_STOLEN;
+
+	return NF_ACCEPT;
+}
+
 static const struct nft_chain_type nft_chain_filter_inet = {
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
 	.family		= NFPROTO_INET,
-	.hook_mask	= (1 << NF_INET_INGRESS) |
+	.hook_mask	= (1 << NF_INET_EARLY_INGRESS) |
+			  (1 << NF_INET_INGRESS) |
 			  (1 << NF_INET_LOCAL_IN) |
 			  (1 << NF_INET_LOCAL_OUT) |
 			  (1 << NF_INET_FORWARD) |
 			  (1 << NF_INET_PRE_ROUTING) |
 			  (1 << NF_INET_POST_ROUTING),
 	.hooks		= {
+		[NF_INET_EARLY_INGRESS]	= nft_do_chain_inet_early_ingress,
 		[NF_INET_INGRESS]	= nft_do_chain_inet_ingress,
 		[NF_INET_LOCAL_IN]	= nft_do_chain_inet,
 		[NF_INET_LOCAL_OUT]	= nft_do_chain_inet,
@@ -324,15 +382,69 @@ static unsigned int nft_do_chain_netdev(void *priv, struct sk_buff *skb,
 	return nft_do_chain(&pkt, priv);
 }
 
+static unsigned int
+nft_do_chain_netdev_early_ingress(void *priv, struct sk_buff *unused,
+				  const struct nf_hook_state *state)
+{
+	struct nf_hook_state ingress_state = *state;
+	struct sk_buff *skb, *nskb;
+	struct nft_pktinfo pkt;
+	LIST_HEAD(accept_list);
+	int ret;
+
+	list_for_each_entry_safe(skb, nskb, state->skb_list, list) {
+		skb_list_del_init(skb);
+
+		skb_reset_network_header(skb);
+		if (!skb_transport_header_was_set(skb))
+			skb_reset_transport_header(skb);
+		skb_reset_mac_len(skb);
+
+		ret = nft_set_pktinfo_ingress(&pkt, skb, &ingress_state);
+		switch (ret) {
+		case 1:
+		case -1:
+			nft_set_pktinfo(&pkt, skb, &ingress_state);
+			break;
+		default:
+			break;
+		}
+
+		ret = nft_do_chain(&pkt, priv);
+		switch (ret) {
+		case NF_ACCEPT:
+			list_add_tail(&skb->list, &accept_list);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			fallthrough;
+		case NF_DROP:
+			kfree_skb(skb);
+			break;
+		}
+	}
+
+	WARN_ON_ONCE(!list_empty(state->skb_list));
+
+	list_splice(&accept_list, state->skb_list);
+
+	if (list_empty(state->skb_list))
+		return NF_STOLEN;
+
+	return NF_ACCEPT;
+}
+
 static const struct nft_chain_type nft_chain_filter_netdev = {
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
 	.family		= NFPROTO_NETDEV,
 	.hook_mask	= (1 << NF_NETDEV_INGRESS) |
-			  (1 << NF_NETDEV_EGRESS),
+			  (1 << NF_NETDEV_EGRESS) |
+			  (1 << NF_NETDEV_EARLY_INGRESS),
 	.hooks		= {
 		[NF_NETDEV_INGRESS]	= nft_do_chain_netdev,
 		[NF_NETDEV_EGRESS]	= nft_do_chain_netdev,
+		[NF_NETDEV_EARLY_INGRESS] = nft_do_chain_netdev_early_ingress,
 	},
 };
 
-- 
2.47.3

