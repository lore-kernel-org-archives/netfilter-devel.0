Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614823932F0;
	Tue, 17 Mar 2026 11:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773746979; cv=none; b=r+GcwtWjOtqhOt8t0VMNcSnSaECPc7N9HkWTxS+MN9IVvbuWV2i5zW0QsYfQ1Wl88W+YgnXa+LxSSVHHmdw34BvnXEHVMORyjMieTpB8jk4Fs+ZolgToSX2PHLwfq4zZVvTIkTYuu5D+atsgXza5srjXfZt14d7+6Ca5i1kZX7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773746979; c=relaxed/simple;
	bh=Qm1ZLRf9UqivDnw3PSX5xUMC4TPm004fUaxJlC2E76A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bn8ELha0Cufr0xZ9hFoYUbQGSbg5tsMvpyTpZvMpu3bx2eU3i3Y+V8/WvwkqVvENP20kjhCmofk0S7K9lIrMQUPOlBiFgn5kmhKFIspXp52pN2UyqU4Gw1gBcEcJVlZWWpcpz9LCFAoTYl2+svViLIubEdPtlk6bkzcRHT0V5EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CFGSgulL; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CFGSgulL"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DE9BD60263;
	Tue, 17 Mar 2026 12:29:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773746975;
	bh=6tKSPC/Qeow2zVWRIRIvxqqrGSyDK9XzY7VdRkXQfZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFGSgulLtHxCF2P1gSeQgCY2ruTVo23Ld+EuP2CqpGcc4xAYq0GaDQ6W7GRbFWh41
	 Gg+ZgL14xB83OjdxK+UBiPqHY0mumWzHBC3ARXw1T8bCZioicdE9f1f+zis1zLbbUy
	 xkcL0Nbjf3xjSDlLMRoa8uhMNZKHA/6Ig0R+08rJG5i6bL4jPBdVJfPui5fzP8trvp
	 HdvgB22DWOQ0ePqYQD1klWlzM7DSVCKFQ4KliSFxOSIFE66ziAjB8suB7lByB2u7OV
	 D7Y5a5Now7aZpaJOFgCE6/8aAIM3Aq2OHy8i9Vh5LGJfQD1ro0v7xfi5nXZItgdmPJ
	 rCfzFnWUqK4yg==
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
Subject: [PATCH net-next,RFC 4/8] netfilter: nf_tables: add nft_set_pktinfo_ingress()
Date: Tue, 17 Mar 2026 12:29:13 +0100
Message-ID: <20260317112917.4170466-5-pablo@netfilter.org>
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

Add helper function to prepare for early ingress filtering support.

No functional changes are intended, this is a preparation patch.

Co-developed-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_chain_filter.c | 48 ++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index b16185e9a6dd..47a612bdd03e 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -161,32 +161,50 @@ static unsigned int nft_do_chain_inet(void *priv, struct sk_buff *skb,
 	return nft_do_chain(&pkt, priv);
 }
 
-static unsigned int nft_do_chain_inet_ingress(void *priv, struct sk_buff *skb,
-					      const struct nf_hook_state *state)
+static int nft_set_pktinfo_ingress(struct nft_pktinfo *pkt,
+				   struct sk_buff *skb,
+				   struct nf_hook_state *ingress_state)
 {
-	struct nf_hook_state ingress_state = *state;
-	struct nft_pktinfo pkt;
-
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
 		/* Original hook is NFPROTO_NETDEV and NF_NETDEV_INGRESS. */
-		ingress_state.pf = NFPROTO_IPV4;
-		ingress_state.hook = NF_INET_INGRESS;
-		nft_set_pktinfo(&pkt, skb, &ingress_state);
+		ingress_state->pf = NFPROTO_IPV4;
+		ingress_state->hook = NF_INET_INGRESS;
+		nft_set_pktinfo(pkt, skb, ingress_state);
 
-		if (nft_set_pktinfo_ipv4_ingress(&pkt) < 0)
-			return NF_DROP;
+		if (nft_set_pktinfo_ipv4_ingress(pkt) < 0)
+			return -1;
 		break;
 	case htons(ETH_P_IPV6):
-		ingress_state.pf = NFPROTO_IPV6;
-		ingress_state.hook = NF_INET_INGRESS;
-		nft_set_pktinfo(&pkt, skb, &ingress_state);
+		ingress_state->pf = NFPROTO_IPV6;
+		ingress_state->hook = NF_INET_INGRESS;
+		nft_set_pktinfo(pkt, skb, ingress_state);
 
-		if (nft_set_pktinfo_ipv6_ingress(&pkt) < 0)
-			return NF_DROP;
+		if (nft_set_pktinfo_ipv6_ingress(pkt) < 0)
+			return -1;
 		break;
 	default:
+		return 1;
+	}
+
+	return 0;
+}
+
+static unsigned int nft_do_chain_inet_ingress(void *priv, struct sk_buff *skb,
+					      const struct nf_hook_state *state)
+{
+	struct nf_hook_state ingress_state = *state;
+	struct nft_pktinfo pkt;
+	int ret;
+
+	ret = nft_set_pktinfo_ingress(&pkt, skb, &ingress_state);
+	switch (ret) {
+	case -1:
+		return NF_DROP;
+	case 1:
 		return NF_ACCEPT;
+	default:
+		break;
 	}
 
 	return nft_do_chain(&pkt, priv);
-- 
2.47.3

