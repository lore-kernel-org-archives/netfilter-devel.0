Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC023FE367
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 11:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785153592; cv=none; b=LDz2MYN24Ea7G3z1PJE03pRqtH630XDc/le4dXHNR2ZsacBzaa3dOJ2P7azHJhIK6mkC9rK8E3MF6oABZNeYrGYg/21uj0WiZqLFlN4EAtKcCFeneXubln/f0kFyjq6MQeWsCiv8CddYkrdbKTRhGWvA1vi8ZA7bGsPa723NDco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785153592; c=relaxed/simple;
	bh=+oed9DtvLvqpdaJHKZOFIpxtgx3UjnJLcqhX/haazCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/2J5n/0eIyZ9zD0lhtHJ5Gzq9vbu1Orwean3Ncax5eD6VxuFDbcCU8OalZVHuQJDRNdwMvUxX/y8dYBZ0LWZATAqPyxALGRMqaAQCHkmf/2C0o7o17f5X9LMUVnSuOVFXUdNA+183RDdr5mH2wFw/GOjrGZdOCzJD9HA92NEas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pDGa18qq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pDGa18qq"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EC9D4601A6;
	Mon, 27 Jul 2026 13:59:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785153584;
	bh=KDVYXoh2omt9SsigWt8IH8cdWFOoTgFcKt5wKgkKBHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDGa18qqDPzLX9Oj5DZKWmNnDy22SDJYBZPgNhoxQ3EjwZySv3x92ldSKcvX1w8iI
	 TwMLoBCyRfoI0ZE03usSxKTxaDXuBAbb+ctfRZEM1Usl6+9H2hXmWYwcO3KHkBIfpG
	 phxLVIw7jZyhgShtfmN86dXw65wslA4HUnbGkV45XxJpajHNYsCl2JE8RlQtJP//w0
	 9SJRmDJ2WTGm/8EkWBSidcs3dV7F4o0Pl3WuYpjD2y6xK+t+WB2xeHuMtTX9Oer6YL
	 5hDqpG11uJ9n78gKYhabfpc+Mm/DDnPv55ehB3HjQb3dSXXguqq6sAHDNDW6tfdMPK
	 xXrqDEeYTrMOg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org
Subject: [PATCH nf-next,v2 5/5] netfilter: flowtable: release tunnel route on error when building forward path
Date: Mon, 27 Jul 2026 13:59:32 +0200
Message-ID: <20260727115932.88335-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727115932.88335-1-pablo@netfilter.org>
References: <20260727115932.88335-1-pablo@netfilter.org>
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
v2: - fix missing dst_release() call in v6.
    - use dev_fill_forward_path_release() in err_out path.

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
--	ip_rt_put(rt);
 
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

