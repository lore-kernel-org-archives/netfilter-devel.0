Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC44139D3D3
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2026 17:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784829005; cv=none; b=UvQl4uybqd6XDfBZ7GEwRreptM87um1etxwvx3+BjxSWnG5PvDTxP3tjm7662Q4lV4RjJKfgt1uFG6UrDvcdRbo+w1CIDCSbk3BtT9I51+FSBUrXgrwMbANG/vmlD6OZO9qZsIrKsAZAqTdgEnfstosW2k8cwo2EWWyEITeCKtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784829005; c=relaxed/simple;
	bh=WdiyTCUg21c89+ySYzeohYdlE3rz/q/gUtD4El8AyGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1hRzslgarO3ZoWuFXtsJh5B3FBpqHGovbWkS4PcEyOEpPm1Lv5xfmpGYxW3XjI1TDGadUFwKzJYlefyjBT6L1/1Sl32pC8MdoS1ycBvYmyH6G9aKga2R7HWTjs1vMSlwEgJ7G+vsWipM4ynh1z1J8Rh9hS/fh7wq1Ude4pt21E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WQ9T1wzX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WQ9T1wzX"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C28316019F;
	Thu, 23 Jul 2026 19:50:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784829000;
	bh=uuzlshdgbXvWHTS52COl0HXARCAgJzptK399APB6vS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQ9T1wzXIQIcSG3bMYGy3rT1C10tCqOKOreumXjfUzd4ZD76eXy1Z9eMXaPksmn8H
	 L9956CjhFnKN8OVaGV+KfqlUSHkj6y87IAw7alLYW2tIesmkY9NXciGJNxTaDeR3Sf
	 0FJH+2jCieic96St25H2w0HCw8CwpsMNL/26AHjyq0YR4iUH1Q1vLnMQX/sK3EnThq
	 AOcIxTGlimYy1lBxSmYwRjam7Nrrqq1Fo+eeldYAkl1iaoZ8jW8wmhyav+niId7L4D
	 9OMBc1sgLwLkJS3h3kMiYtNHMk7rl3haKZKCr+p9CIOcs5I6VR0ZDOndaywooYP9qn
	 ws1DuyJ9wa5vg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org
Subject: [PATCH nf-next 4/4] netfilter: flowtable: release tunnel route on error when building forward path
Date: Thu, 23 Jul 2026 19:49:52 +0200
Message-ID: <20260723174952.329650-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260723174952.329650-1-pablo@netfilter.org>
References: <20260723174952.329650-1-pablo@netfilter.org>
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

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/ipip.c                    |  2 +-
 net/ipv6/ip6_tunnel.c              |  2 +-
 net/netfilter/nf_flow_table_path.c | 62 ++++++++----------------------
 3 files changed, 18 insertions(+), 48 deletions(-)

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
index bf8e40af60b0..312de4a6e160 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1864,12 +1864,12 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 		path->tun.src_v6 = t->parms.laddr;
 		path->tun.dst_v6 = t->parms.raddr;
 		path->tun.l3_proto = IPPROTO_IPV6;
+		path->tun.dst = dst;
 		path->dev = ctx->dev;
 		ctx->dev = dst->dev;
 	}
 
 	err = dst->error;
-	dst_release(dst);
 
 	return err;
 }
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 8f04a4487897..9f6fc29c4e16 100644
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
 
@@ -189,6 +191,11 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 		return -1;
 
 	return 0;
+err_out:
+	if (info->num_tuns)
+		dst_release(info->tun_dst);
+
+	return -1;
 }
 
 static bool nft_flowtable_find_dev(const struct net_device *dev,
@@ -208,44 +215,6 @@ static bool nft_flowtable_find_dev(const struct net_device *dev,
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
@@ -270,12 +239,13 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
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

