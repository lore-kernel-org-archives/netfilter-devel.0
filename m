Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5E8427FA3
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 11:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785236997; cv=none; b=KyqTk+1QEFJ5VZ7RbFLXYSjTgYXVyJ8mibryUgChf0Nr/2SAoLF+x07fJ42SINSdjv3uW9QqpxU7eXX9kWbcgvAZdaFBDQ3FKYOc2GQN/d9Lm6yhppEqhc9K0K/9E1dHGUt7UbMaGK0hfWOJ2btpK3ePXrC8cNvyIRySTCiov/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785236997; c=relaxed/simple;
	bh=/5CDAf8chLPh3LKjcoADBhWgJAHzRq5sFfpn6dsF8Po=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuuxeAWzazPPuLOd76Y8CyH+3DFn3JiyPYJTnVSTmHtqBZYZd6quZ/slJGwggiS6a3Q3korKbVU0fk/N7Aa0UqIgOzNgb4zseu/Q+FWICBfTv4R55bWLl7nPB8BqDcUCjMuj5PU0XbRfnJCZuL8n7fpNUwvikOWAaNSkq7SbGC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BbQgA/tQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BbQgA/tQ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BFC1360194
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 13:09:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785236994;
	bh=LG+L7Kv6x3mOOnaKcnouTm4m6qeG7bxgu/+KchhGnV8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BbQgA/tQB07DTCKppXvOVZjDsLnSElax1Hd4I+j2Y81hLlcCzIWbHykVXiO+UZb2U
	 GXNmO6h8UwFGMAA6BoWGzOJXXfHSEaeMkpGr35qu81QxRgw1uQBrPrR801bwMWyQJx
	 ugLemxhr1TRq9IFC5VlGzurtB0P+rnW0jVruwgGtdrre8RQDqAC7jmkMbz6m4ooeM/
	 8fjRKDxBhxA7Dt2FGh5jg1iMPboLKpI6cZl4nR0AOYUmHhdzwd8AzTDvemERvCAQn3
	 jWPv7fH1jV5U7qHIZkfcWOMl+I2tmE/IDXCWvqcppW+LiZLMZncVdh8oaL18JPunku
	 uB2MdrmbNdc0g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 5/5] netfilter: flowtable: release tunnel route on error when building forward path
Date: Tue, 28 Jul 2026 13:09:42 +0200
Message-ID: <20260728110943.124900-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728110943.124900-1-pablo@netfilter.org>
References: <20260728110943.124900-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_flow_tunnel_update_route() can lazy fail, leaving an incomplete
forward path set ip. The route lookup also happens twice, once from
dev_fill_forward_path() and again in this aforementioned function.

Update ipip and ip6ip6 not to release the dst_entry and pass it on
via the tunnel forward path information.

In case of failure when setting up the forwarding path, release the
tunnel dst that was provided via dev_fill_forward_path().

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: no changes

 net/ipv4/ipip.c                    |  2 +-
 net/ipv6/ip6_tunnel.c              |  4 +-
 net/netfilter/nf_flow_table_path.c | 65 ++++++++----------------------
 3 files changed, 21 insertions(+), 50 deletions(-)

diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index d1aa048a6099..0a4fa1351dd7 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -370,10 +370,10 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
 	path->tun.src_v4.s_addr = tiph->saddr;
 	path->tun.dst_v4.s_addr = tiph->daddr;
 	path->tun.l3_proto = IPPROTO_IPIP;
+	path->tun.dst = &rt->dst;
 	path->dev = ctx->dev;
 
 	ctx->dev = rt->dst.dev;
-	ip_rt_put(rt);
 
 	return 0;
 }
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index bf8e40af60b0..82eeed183001 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1864,12 +1864,14 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 		path->tun.src_v6 = t->parms.laddr;
 		path->tun.dst_v6 = t->parms.raddr;
 		path->tun.l3_proto = IPPROTO_IPV6;
+		path->tun.dst = dst;
 		path->dev = ctx->dev;
 		ctx->dev = dst->dev;
 	}
 
 	err = dst->error;
-	dst_release(dst);
+	if (err)
+		dst_release(dst);
 
 	return err;
 }
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 8f04a4487897..9a00fe99a50d 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -82,6 +82,7 @@ struct nft_forward_info {
 	} encap[NF_FLOW_TABLE_ENCAP_MAX];
 	u8 num_encaps;
 	struct flow_offload_tunnel tun;
+	struct dst_entry *tun_dst;
 	u8 num_tuns;
 	u8 ingress_vlans;
 	u8 h_source[ETH_ALEN];
@@ -93,7 +94,7 @@ struct nft_forward_info {
 static bool nft_flowtable_find_dev(const struct net_device *dev,
 				   struct nft_flowtable *ft);
 
-static int nft_dev_path_info(const struct net_device_path_stack *stack,
+static int nft_dev_path_info(struct net_device_path_stack *stack,
 			     struct nft_forward_info *info,
 			     unsigned char *ha, struct nft_flowtable *ft)
 {
@@ -124,15 +125,16 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 			/* DEV_PATH_VLAN, DEV_PATH_PPPOE and DEV_PATH_TUN */
 			if (path->type == DEV_PATH_TUN) {
 				if (info->num_tuns)
-					return -1;
+					goto err_out;
 
 				info->tun.src_v6 = path->tun.src_v6;
 				info->tun.dst_v6 = path->tun.dst_v6;
 				info->tun.l3_proto = path->tun.l3_proto;
+				info->tun_dst = path->tun.dst;
 				info->num_tuns++;
 			} else {
 				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX)
-					return -1;
+					goto err_out;
 
 				info->encap[info->num_encaps].id =
 					path->encap.id;
@@ -153,13 +155,13 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 			switch (path->bridge.vlan_mode) {
 			case DEV_PATH_BR_VLAN_UNTAG_HW:
 				if (info->num_encaps == 0)
-					return -1;
+					goto err_out;
 
 				info->ingress_vlans |= BIT(info->num_encaps - 1);
 				break;
 			case DEV_PATH_BR_VLAN_TAG:
 				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX)
-					return -1;
+					goto err_out;
 
 				info->encap[info->num_encaps].id = path->bridge.vlan_id;
 				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
@@ -167,7 +169,7 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 				break;
 			case DEV_PATH_BR_VLAN_UNTAG:
 				if (info->num_encaps == 0)
-					return -1;
+					goto err_out;
 
 				info->num_encaps--;
 				break;
@@ -177,7 +179,7 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
 		default:
-			return -1;
+			goto err_out;
 		}
 	}
 
@@ -186,9 +188,13 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 		info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 
 	if (!nft_flowtable_find_dev(info->dev, ft))
-		return -1;
+		goto err_out;
 
 	return 0;
+err_out:
+	dev_fill_forward_path_release(stack);
+
+	return -1;
 }
 
 static bool nft_flowtable_find_dev(const struct net_device *dev,
@@ -208,44 +214,6 @@ static bool nft_flowtable_find_dev(const struct net_device *dev,
 	return found;
 }
 
-static int nft_flow_tunnel_update_route(const struct nft_pktinfo *pkt,
-					struct flow_offload_tunnel *tun,
-					struct nf_flow_route *route,
-					enum ip_conntrack_dir dir)
-{
-	struct dst_entry *cur_dst = route->tuple[dir].dst;
-	struct dst_entry *tun_dst = NULL;
-	struct flowi fl = {};
-
-	switch (nft_pf(pkt)) {
-	case NFPROTO_IPV4:
-		fl.u.ip4.daddr = tun->dst_v4.s_addr;
-		fl.u.ip4.saddr = tun->src_v4.s_addr;
-		fl.u.ip4.flowi4_iif = nft_in(pkt)->ifindex;
-		fl.u.ip4.flowi4_dscp = ip4h_dscp(ip_hdr(pkt->skb));
-		fl.u.ip4.flowi4_mark = pkt->skb->mark;
-		fl.u.ip4.flowi4_flags = FLOWI_FLAG_ANYSRC;
-		break;
-	case NFPROTO_IPV6:
-		fl.u.ip6.daddr = tun->dst_v6;
-		fl.u.ip6.saddr = tun->src_v6;
-		fl.u.ip6.flowi6_iif = nft_in(pkt)->ifindex;
-		fl.u.ip6.flowlabel = ip6_flowinfo(ipv6_hdr(pkt->skb));
-		fl.u.ip6.flowi6_mark = pkt->skb->mark;
-		fl.u.ip6.flowi6_flags = FLOWI_FLAG_ANYSRC;
-		break;
-	}
-
-	nf_route(nft_net(pkt), &tun_dst, &fl, false, nft_pf(pkt));
-	if (!tun_dst)
-		return -ENOENT;
-
-	route->tuple[dir].dst = tun_dst;
-	dst_release(cur_dst);
-
-	return 0;
-}
-
 static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 				struct nf_flow_route *route,
 				const struct nf_conn *ct,
@@ -270,12 +238,13 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 		route->tuple[!dir].in.encap[i].proto = info.encap[i].proto;
 	}
 
-	if (info.num_tuns &&
-	    !nft_flow_tunnel_update_route(pkt, &info.tun, route, dir)) {
+	if (info.num_tuns) {
 		route->tuple[!dir].in.tun.src_v6 = info.tun.dst_v6;
 		route->tuple[!dir].in.tun.dst_v6 = info.tun.src_v6;
 		route->tuple[!dir].in.tun.l3_proto = info.tun.l3_proto;
 		route->tuple[!dir].in.num_tuns = info.num_tuns;
+		dst_release(route->tuple[dir].dst);
+		route->tuple[dir].dst = info.tun_dst;
 	}
 
 	route->tuple[!dir].in.num_encaps = info.num_encaps;
-- 
2.47.3

