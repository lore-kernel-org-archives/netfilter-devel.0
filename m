Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BDB44331D;
	Mon, 10 Aug 2026 19:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786390843; cv=none; b=AKaRarJhyQa4TAGYOertPrL/vE9dYgOS8a3Y7JqslIbehsHJ9j5cO6HzF0bVOGCGmCKV5D8zvjBhgWx/uVMNgDSNAjVwYutPkdy8FVvRo+XXcLPAw50GyvXxBiM4V1OOvAoKsUV06B0VBJu1oZATQGAjOmx/Ww7jJvTzsQ96Ams=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786390843; c=relaxed/simple;
	bh=gLJJwvOFPEc6Tggvw1a+wY4Ne/Nod1rpNkaffGJsmuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFaXdvkQTcKqZgSKPi9f8gfl2cYgmjUN9MaW/Q89cY+UMypbBveXXcggvLO6uJtsIENrGFOmx5a/5sX5EO40d8Qeb+qPxYMOEmEoz2BURfxolKZQGNwVWZ3+bA3NMCvT7ztq3ehtVOFtvKe4gZKPwoOvdaSynniGQuh0UPU8iMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CWlJPZ++; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CWlJPZ++"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6EE06601A7;
	Mon, 10 Aug 2026 21:40:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786390829;
	bh=0KNqnQtlnSywq2Xf/z7G244YSGVn0PNJDI00WQNCKZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWlJPZ++OkUbf4exIlzJ0mTEXrfCIGDOfrsQLTcA5C08cqh5/e5OXhFrRLa7gyMk9
	 714oMfpH9mh9f1ea2IHAXt0L6uNZ++s4nJpuFzvpVQ7ifW/WyPEizdmyJP75wU92+3
	 V11EdmD/m4Vu3zkP0FCgJy3T05twtiGYCti/hxdJS+GttoETvY9uulow86WZzCMSEU
	 aUzrLrPGAJMzbRBJn0OfyGYR1g2L2la8TjzI45mYz2QoTS+qIY4+Gznqh+z1Br2oyU
	 stNBkEzipIi0md9oyINGIUitGeja7o+PxCRA1X8WamUuxjeyTtASdGY9IL3zat3z9k
	 3e/NK4kxel6Ng==
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
Subject: [PATCH net-next 04/12] netfilter: flowtable: rename tun.l3_proto to tun.inner_proto
Date: Mon, 10 Aug 2026 21:40:07 +0200
Message-ID: <20260810194015.932627-5-pablo@netfilter.org>
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

This field refers to the inner protocol that is encapsulated by the
tunnel header, just a comestic change. No functional changes are
expected.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h             | 2 +-
 include/net/netfilter/nf_flow_table.h | 2 +-
 net/ipv4/ipip.c                       | 2 +-
 net/ipv6/ip6_tunnel.c                 | 2 +-
 net/netfilter/nf_flow_table_ip.c      | 6 +++---
 net/netfilter/nf_flow_table_path.c    | 4 ++--
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2327a2703b83..7f5c2323146d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -904,7 +904,7 @@ struct net_device_path {
 				struct in6_addr	dst_v6;
 			};
 
-			u8	l3_proto;
+			u8	inner_proto;
 		} tun;
 		struct {
 			enum {
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index a090ec3ffef2..f2e2771f188f 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -117,7 +117,7 @@ struct flow_offload_tunnel {
 		struct in6_addr	dst_v6;
 	};
 
-	u8	l3_proto;
+	u8	inner_proto;
 };
 
 struct flow_offload_tuple {
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 62a374079bfc..1630325c77d3 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -378,7 +378,7 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
 	path->type = DEV_PATH_TUN;
 	path->tun.src_v4.s_addr = tiph->saddr;
 	path->tun.dst_v4.s_addr = tiph->daddr;
-	path->tun.l3_proto = IPPROTO_IPIP;
+	path->tun.inner_proto = IPPROTO_IPIP;
 	path->tun.dst = &rt->dst;
 	path->dev = ctx->dev;
 
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index d063add01f52..143d061fb48c 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1875,7 +1875,7 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 		path->type = DEV_PATH_TUN;
 		path->tun.src_v6 = fl6.saddr;
 		path->tun.dst_v6 = fl6.daddr;
-		path->tun.l3_proto = IPPROTO_IPV6;
+		path->tun.inner_proto = IPPROTO_IPV6;
 		path->tun.dst = dst;
 		path->dev = ctx->dev;
 		ctx->dev = dst->dev;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 78d1862ce783..a03946a5c2e7 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -197,7 +197,7 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 		if (ctx->tun.proto == IPPROTO_IPIP) {
 			tuple->tun.dst_v4.s_addr = iph->daddr;
 			tuple->tun.src_v4.s_addr = iph->saddr;
-			tuple->tun.l3_proto = IPPROTO_IPIP;
+			tuple->tun.inner_proto = IPPROTO_IPIP;
 		}
 		break;
 	case htons(ETH_P_IPV6):
@@ -205,7 +205,7 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 		if (ctx->tun.proto == IPPROTO_IPV6) {
 			tuple->tun.dst_v6 = ip6h->daddr;
 			tuple->tun.src_v6 = ip6h->saddr;
-			tuple->tun.l3_proto = IPPROTO_IPV6;
+			tuple->tun.inner_proto = IPPROTO_IPV6;
 		}
 		break;
 	default:
@@ -612,7 +612,7 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
 	iph->version	= 4;
 	iph->ihl	= sizeof(*iph) >> 2;
 	iph->frag_off	= ip_mtu_locked(&rt->dst) ? 0 : frag_off;
-	iph->protocol	= tuple->tun.l3_proto;
+	iph->protocol	= tuple->tun.inner_proto;
 	iph->tos	= tos;
 	iph->daddr	= tuple->tun.src_v4.s_addr;
 	iph->saddr	= tuple->tun.dst_v4.s_addr;
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 5f166da3b09b..1e55644f2edb 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -133,7 +133,7 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 
 				info->tun.src_v6 = path->tun.src_v6;
 				info->tun.dst_v6 = path->tun.dst_v6;
-				info->tun.l3_proto = path->tun.l3_proto;
+				info->tun.inner_proto = path->tun.inner_proto;
 				info->tun_dst = path->tun.dst;
 				info->num_tuns++;
 			} else {
@@ -245,7 +245,7 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	if (info.num_tuns) {
 		route->tuple[!dir].in.tun.src_v6 = info.tun.dst_v6;
 		route->tuple[!dir].in.tun.dst_v6 = info.tun.src_v6;
-		route->tuple[!dir].in.tun.l3_proto = info.tun.l3_proto;
+		route->tuple[!dir].in.tun.inner_proto = info.tun.inner_proto;
 		route->tuple[!dir].in.num_tuns = info.num_tuns;
 		dst_release(route->tuple[dir].dst);
 		route->tuple[dir].dst = info.tun_dst;
-- 
2.47.3

