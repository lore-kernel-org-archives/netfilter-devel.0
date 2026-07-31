Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725F5439003;
	Fri, 31 Jul 2026 15:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512067; cv=none; b=PQniKs0qiQInIN8KKXvmE/pDPv5IiFL6O/jIuNDGLiKAG/HwoBxi+OmdXYpWHFvemzHKXocuCO9vYGh1HUIAHV3PveaDYDVccB1BgGiTkqkxcB5nlhdcvlIF3WkIZiSvPB4iatP6zlJc5xKmIO8+r6TA2iLOH/+n9m7sOBCl640=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512067; c=relaxed/simple;
	bh=XYmSFfGP1t3q9s7ieCjQNYIbDmio7nN71SjMS77/FAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+pg89n1eIEyfAhIhvUf6+Ga1x+flvyyMWPbArBo1w8YT1ZhDoIMSAntxxsEKLQDtVZ5RNUSoh3KO2zofGwa6qxlg5opqbs7u3O9oyXqg822V3smJXbSDsDvv3OGwY9vx5OP54pUabCzeou4i/TT9DrOTWuC7bM3oaeEmjiPVaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GVzz1mkZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GVzz1mkZ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 10272602A5;
	Fri, 31 Jul 2026 17:34:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785512061;
	bh=/CCM+klP925bJvCZRgvgbgMaXArbrCeVc+zCSEnYW2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVzz1mkZF4DA/1yUB+w2vb6MXIXnGLMsmHjyQ/7ov0UXANIeIH+fyNn7yEQy7uDcc
	 FRLlraAhWlkY1A8y+AvjIAOe3t5wjAX3Jdx5spyGywjMBYsW8mAnpVc2WHzbGDB4P+
	 xkDmVjHijZitrb0euurJ148AEbiPwG3Y0WkDcHuJocW3lwCvCV/he+FUQTdCaqS3by
	 +2AjnKR0oIG/v6KyY23/sOdBQMGJqvV5HPUeudcXiZE6pGs4fiGYeBT/JYQxdd8lUW
	 +ECXKRAEdS5LVaBcMgOjbhf7XoCI+m8LhgqRFej5x/6SLERtk5FkasZmhHSnf97Ojq
	 mJf6EexMJK/DA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 7/9] netfilter: flowtable: release tunnel route on error when building forward path
Date: Fri, 31 Jul 2026 17:34:00 +0200
Message-ID: <20260731153402.851224-8-pablo@netfilter.org>
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
 net/ipv4/ipip.c                    |  2 +-
 net/ipv6/ip6_tunnel.c              |  4 +-
 net/netfilter/nf_flow_table_path.c | 65 ++++++++----------------------
 3 files changed, 21 insertions(+), 50 deletions(-)

diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 0831f6b81717..fb7d96f99b06 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -376,10 +376,10 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
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
index 97c3f61d627b..d80020bc2620 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1870,12 +1870,14 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 		path->tun.src_v6 = fl6.saddr;
 		path->tun.dst_v6 = fl6.daddr;
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
index 004dc75ac357..56219b02e122 100644
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
@@ -121,15 +122,16 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
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
@@ -150,13 +152,13 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
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
@@ -164,7 +166,7 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 				break;
 			case DEV_PATH_BR_VLAN_UNTAG:
 				if (info->num_encaps == 0)
-					return -1;
+					goto err_out;
 
 				info->num_encaps--;
 				break;
@@ -174,7 +176,7 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
 		default:
-			return -1;
+			goto err_out;
 		}
 	}
 
@@ -183,9 +185,13 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
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
@@ -205,44 +211,6 @@ static bool nft_flowtable_find_dev(const struct net_device *dev,
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
@@ -267,12 +235,13 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
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

