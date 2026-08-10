Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE29644210D;
	Mon, 10 Aug 2026 19:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786390845; cv=none; b=RFP5kcHHa0Lw7+JKPKiZQDxAgJpBYM9X4t8Q0J0lHhJxHI0x3jNUqFJbuSqIMvqCw8ypbdIGNx1KjxDUv0tTBRRfT2z91IixRvCNSy7w/xvv+vxNoW0NusfMF4HJnMr13i9Fe2MX5yCFiUeymGF6KYvJHNdokKpEz/6idkkDgZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786390845; c=relaxed/simple;
	bh=/GR1aA5NjVzHpnxnnr9DuT01NbxKvfI2TSyH9tXhw4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8MGoC5OKdc8/691VZ6Qn5iF6JWsgR9YWxeDR9lj32m0EtZlF7b+V7yDoUHFg/okAT6c9QWBSOgOhdvYUZIWgv6hNOpwQR+ahIVHYNX4+hhnFG1wKdWbsp5g1OfIdGycqVUh+9kQ/Ni39v/+ii/xDrlJaWysQO7F5rKjB/auQ0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aj8z8SBc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aj8z8SBc"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 25973601A6;
	Mon, 10 Aug 2026 21:40:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786390828;
	bh=6+n0SpBQz7Q4Ll+/CWUDnXwehltauK0f3CM/YD7sT8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aj8z8SBcM7g9isLTaN/3iFKzck2U3udsGg9WhbPlHfNa21vkofplFDPiFnkocCD0X
	 LqgVwlOzFUJEbFBy/Fctik/XzXN1WKYDYrLTEWmJqxdwv0iGwvlwNnvuKEUCjDWuDP
	 yvh1RLFtZykRrYDZVbR41pIu2Uu3hF+XBiG6bFhtCAL1iGHboaeEiF+lWY/lnfeePt
	 OJ4ig0+KVCasdledF3+pg09FQdA1vsJRx+ip+5VXaSCYHyuRU+wSF6Gi3x5l3fyNCv
	 0pwkQcb9rEeaFjKveAy6lwkp8eEfUn8MJ7WI1oya2OSpPD8vg4EmBGgKYkYuXmPAPa
	 EZbpWHU1YAPhQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 03/12] net: netfilter: add ether_type to net_device_path_ctx and use it
Date: Mon, 10 Aug 2026 21:40:06 +0200
Message-ID: <20260810194015.932627-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810194015.932627-1-pablo@netfilter.org>
References: <20260810194015.932627-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an ether_type field to struct net_device_path_ctx to reject IPv4
over IPv6 and vice-versa, this is currently not support. Otherwise,
incorrect dst_entry family can be reached from datapath.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h          | 1 +
 net/ipv4/ipip.c                    | 3 +++
 net/ipv6/ip6_tunnel.c              | 3 +++
 net/netfilter/nf_flow_table_path.c | 6 ++++--
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 17d28adb029b..2327a2703b83 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -941,6 +941,7 @@ struct net_device_path_stack {
 struct net_device_path_ctx {
 	const struct net_device *dev;
 	u8			daddr[ETH_ALEN];
+	__be16			ether_type;
 
 	int			num_vlans;
 	struct {
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index fb7d96f99b06..62a374079bfc 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -360,6 +360,9 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
 	const struct iphdr *tiph = &tunnel->parms.iph;
 	struct rtable *rt;
 
+	if (ctx->ether_type != cpu_to_be16(ETH_P_IP))
+		return -EOPNOTSUPP;
+
 	if (tunnel->collect_md)
 		return -EOPNOTSUPP;
 
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 042d743edb6c..d063add01f52 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1852,6 +1852,9 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 	struct flowi6 fl6;
 	int err;
 
+	if (ctx->ether_type != cpu_to_be16(ETH_P_IPV6))
+		return -EOPNOTSUPP;
+
 	if (t->parms.flags & (IP6_TNL_F_USE_ORIG_TCLASS |
 			      IP6_TNL_F_USE_ORIG_FLOWLABEL |
 			      IP6_TNL_F_USE_ORIG_FWMARK))
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 0cbde535b8ba..5f166da3b09b 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -44,13 +44,15 @@ static bool nft_is_valid_ether_device(const struct net_device *dev)
 
 static int nft_dev_fill_forward_path(const struct dst_entry *dst_cache,
 				     const struct nf_conn *ct,
-				     enum ip_conntrack_dir dir, u8 *ha,
+				     enum ip_conntrack_dir dir,
+				     u8 *ha, __be16 ether_type,
 				     struct net_device_path_stack *stack)
 {
 	const void *daddr = &ct->tuplehash[!dir].tuple.src.u3;
 	struct net_device *dev = dst_cache->dev;
 	struct net_device_path_ctx ctx = {
 		.dev = dev,
+		.ether_type = ether_type,
 	};
 	struct neighbour *n;
 	u8 nud_state;
@@ -228,7 +230,7 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	unsigned char ha[ETH_ALEN];
 	int i;
 
-	if (nft_dev_fill_forward_path(dst, ct, dir, ha, &stack) < 0 ||
+	if (nft_dev_fill_forward_path(dst, ct, dir, ha, pkt->ethertype, &stack) < 0 ||
 	    nft_dev_path_info(&stack, &info, ha, ft) < 0)
 		return -ENOENT;
 
-- 
2.47.3

