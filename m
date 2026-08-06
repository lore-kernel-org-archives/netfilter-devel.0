Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6355A2DCF57
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 22:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786055747; cv=none; b=fEV6v9FojsTOVnvwbwMGLryIyHPHtDqIXbWYwLKNqRhl+N03uZhSpMR1S4m+VKcFnPrz47ueMadqzNmGlnsd782sP+J2c6hLI6Yz/dzsbA4xHGUBVteQvmZ5ZqqzSAPVddSS/8p/Yisx6CLrwPMQDL1ZdjL/xHGsIzgZHdFPm7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786055747; c=relaxed/simple;
	bh=dwfYnxHOcClTVePKHhU6HMdjSwOxIGIg8SF67KZ8QI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fB5vDjNXxtx9VK/rbsgH+87EDH/z+fap97BpFXU1Kg9xLTqX88yfWV6Tb1VQ2pmFcZxj+G3i2pBGLojX4cgyxclrz3ZPy8mURTYDAScVLNDrmYj8BdCPVUqtNBmLxW28Iz9/ISZ72HHgrqltwfaiTFVzAFMZYPKT9SBVaZ3jLPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=suIWUhAV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="suIWUhAV"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D4127601A7;
	Fri,  7 Aug 2026 00:35:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786055742;
	bh=rTN73bEaYOyulf2UyAvODwa9Vv93FxTOupuBuRvwbmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suIWUhAVXFFrszsw2NsuV+QiXrtg9OyCVTHr7cpRTQTfcFXu1wFErAhnamuvbCDxq
	 HJzBWATYKv4nOX+SOXetXq57eu5r4Mdj3yQb4wlIw9hpgcqS47gvhuBIcsgqdRfgWH
	 /3VWGlKu0MuRKG7ApQifoX9hAX8zxbWtsjQWjNYeseq7tu6/4ld5ktb8AVSYFSneWI
	 Sdw2gZRk0n11GSTj3rjk8t9n2diWKrMOhBZzeFflxo8Svo/fk3VgKaNkJl1nc4Kuyy
	 dTP+rtYxU7jjXC8P2rSPT2pFuctTdax2FxJ5zgdoiftgDKGQwVk/UM4jJHdB6pHVtb
	 bmf7ikrxyLF9A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo.bianconi@oss.qualcomm.com,
	lorenzo@kernel.org
Subject: [PATCH nf-next 2/7] net: netfilter: add ether_type to net_device_path_ctx and use it
Date: Fri,  7 Aug 2026 00:35:30 +0200
Message-ID: <20260806223535.523098-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260806223535.523098-1-pablo@netfilter.org>
References: <20260806223535.523098-1-pablo@netfilter.org>
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

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h          | 1 +
 net/ipv4/ipip.c                    | 3 +++
 net/ipv6/ip6_tunnel.c              | 3 +++
 net/netfilter/nf_flow_table_path.c | 6 ++++--
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4319b949f405..d9962c50bd60 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -939,6 +939,7 @@ struct net_device_path_stack {
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
index d80020bc2620..3bfaa98e7f33 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1849,6 +1849,9 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
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

