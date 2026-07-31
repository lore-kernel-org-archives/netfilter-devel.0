Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EDD402B8A;
	Fri, 31 Jul 2026 15:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512057; cv=none; b=Tna3VyXGYg4FFrOEQ3bCVhZBMJPffC8hZ/GU5uitsLtRktgIUAr5EuFfnO3fOAXJzuSZY+H0Eo4aAxPsby6WBZMEH5QuUXc5wvM1NjLF6QnPBg4rDbJdmiLptxGbq+4iLSPSin5XLZBnUmZq5wOr5GEOjRBmNPj+vZQ87hKbMPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512057; c=relaxed/simple;
	bh=sjrJxiOOyvdffsnuBDvkmq/nqd2OMUJtlobUf4fU4ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SaLwkYvNY5fIVhsej1zGgX73y+3ioAu1KR701H111D0iqG30T5REkDch3ss0WryiM7L0h/cNP4mq9j+UwS4P49xXKnnjtdvsK8snKlU7aD1O4yh7E9cFmp0QGrihO52BNMrBaTiXDO1jNdgZIwgWgEhbXTSjQTN9UAltMeQrswU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SGVkMEcZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SGVkMEcZ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4B202602B0;
	Fri, 31 Jul 2026 17:34:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785512054;
	bh=x2IG4GKAjLDJjb2lx6PgbEbVtObWnTAsAMsk8bmlw40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGVkMEcZQxgzYkMl81hfqEg1M6rl7Mp02xmvk0T94wiu5QB3JbBCFz16BB3S6FRLN
	 +2xdiZ+xB0hhb4sTn4cXhxuKRfxH4sks4f/New6sKe6KkyVRtWWKZ8d2Jp7bVHaMM5
	 UOMxAraaCehixJ7kJwv20nj5RwSLwMQ3XrEa3JuriW28IiqHtcj932Pk4fI4lw3sTE
	 ZwziWgjoskxCECskZzMjw0dthNYeI8ZAujcZSAY7ZYZ/b+xaSE2MMkWsGL78+WJXPr
	 p2L+Bb6oU+YOUDMLNLbUidbXAqJw+HnTBqkZrgk32C1QjYSzK6pYMkHlbAUkdFbfkU
	 XfQZgirtMDe4w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 2/9] netfilter: flowtable: consolidate net_device field in nft_forward_info struct
Date: Fri, 31 Jul 2026 17:33:55 +0200
Message-ID: <20260731153402.851224-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260731153402.851224-1-pablo@netfilter.org>
References: <20260731153402.851224-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

info->indev and info->outdev refer to the same device, a single
info->dev field is sufficient.

While at it, remove unused router parameter from the flowtable path
discovery function.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_path.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 98c03b487f52..261bb44d08eb 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -42,8 +42,7 @@ static bool nft_is_valid_ether_device(const struct net_device *dev)
 	return true;
 }
 
-static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
-				     const struct dst_entry *dst_cache,
+static int nft_dev_fill_forward_path(const struct dst_entry *dst_cache,
 				     const struct nf_conn *ct,
 				     enum ip_conntrack_dir dir, u8 *ha,
 				     struct net_device_path_stack *stack)
@@ -76,8 +75,7 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 }
 
 struct nft_forward_info {
-	const struct net_device *indev;
-	const struct net_device *outdev;
+	const struct net_device *dev;
 	struct id {
 		__u16	id;
 		__be16	proto;
@@ -109,7 +107,7 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 		case DEV_PATH_VLAN:
 		case DEV_PATH_PPPOE:
 		case DEV_PATH_TUN:
-			info->indev = path->dev;
+			info->dev = path->dev;
 			if (is_zero_ether_addr(info->h_source))
 				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
 
@@ -179,10 +177,9 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 			return -1;
 		}
 	}
-	info->outdev = info->indev;
 
 	if (nf_flowtable_hw_offload(flowtable) &&
-	    nft_is_valid_ether_device(info->indev))
+	    nft_is_valid_ether_device(info->dev))
 		info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 
 	return 0;
@@ -255,17 +252,16 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	unsigned char ha[ETH_ALEN];
 	int i;
 
-	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) < 0 ||
+	if (nft_dev_fill_forward_path(dst, ct, dir, ha, &stack) < 0 ||
 	    nft_dev_path_info(&stack, &info, ha, &ft->data) < 0)
 		return -ENOENT;
 
-	if (!nft_flowtable_find_dev(info.indev, ft))
+	if (!nft_flowtable_find_dev(info.dev, ft))
 		return -ENOENT;
 
-	if (info.outdev)
-		route->tuple[dir].out.ifindex = info.outdev->ifindex;
+	route->tuple[!dir].in.ifindex = info.dev->ifindex;
+	route->tuple[dir].out.ifindex = info.dev->ifindex;
 
-	route->tuple[!dir].in.ifindex = info.indev->ifindex;
 	for (i = 0; i < info.num_encaps; i++) {
 		route->tuple[!dir].in.encap[i].id = info.encap[i].id;
 		route->tuple[!dir].in.encap[i].proto = info.encap[i].proto;
-- 
2.47.3

