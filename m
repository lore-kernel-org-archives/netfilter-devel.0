Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752C1338580;
	Tue, 25 Nov 2025 22:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764110012; cv=none; b=PSDM3b3KuaDxSo8tlXxs8YHpn6jDMQfUg9s7dUO4vkC3OvMNbRpb8YHWH3EyNPz0zHp0Mk5Hs7imIWspxz7LkM4jC42DQCHUWaVu/IExk60a30fQLV/nT5aViO5YJvj2nMYzNH9I9uFaO83nUb+B98vvPPmBrOeEs0/+D4LouYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764110012; c=relaxed/simple;
	bh=sCDM4M2Ri8rFfLbTJZhPih5cILnVwSM8rcFwt1KzygM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llVpzphBOEMO69KGSPh3ZcgRhtjSKkhILNDslC8BszvrtG1zBn+69BeIuCG2y1fDRWASEy8BxWKGCDuarmgW1+FfxOIhjeZeWVsj+8y84pqNk57rPvCNaQDZzYjzbE6F3IhFEjLkVhBu2v7ekslmmEvVZfr8++y+qYAfVn2ISsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=t36HKlpj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="t36HKlpj"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A798C602AB;
	Tue, 25 Nov 2025 23:33:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764110008;
	bh=9AT+WUKDaaBLQff0f5lUgoRsDdmTpYWo8c6Jrtehh0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t36HKlpjTg5rQQ691mcq3J5k24zo0vHDyuIIMSisauFtoyhEdYoKi9lxsACk82Fhd
	 wCLE0q065UnL9OdPGGx/9OEPLzv+H34xwE+aOnXhq0ER31U0iFmmtuCrFLpHXgaFhf
	 QAq1lfNaxEixRX8R5cMWw18ZxtRllrYjr4LGrSPLSE/1b2lmZQWOqiqL/mL3tkcKjg
	 rP8A74P5qdu+LoX5bGtUNHh5dnZJAqQy1GAIZjrRuAXWm9xori4kE1JxZcI1hfDITV
	 SSz3IKY/lRE2eUFB/TJ4UQ2LAUahAQpDXNfMr0mGI5NEZWhZYWeS+MCtXiHQMeDlSs
	 NIkN6ECiYTENw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 07/16] netfilter: flowtable: Add IPIP rx sw acceleration
Date: Tue, 25 Nov 2025 22:33:03 +0000
Message-ID: <20251125223312.1246891-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251125223312.1246891-1-pablo@netfilter.org>
References: <20251125223312.1246891-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

Introduce sw acceleration for rx path of IPIP tunnels relying on the
netfilter flowtable infrastructure. Subsequent patches will add sw
acceleration for IPIP tunnels tx path.
This series introduces basic infrastructure to accelerate other tunnel
types (e.g. IP6IP6).
IPIP rx sw acceleration can be tested running the following scenario where
the traffic is forwarded between two NICs (eth0 and eth1) and an IPIP
tunnel is used to access a remote site (using eth1 as the underlay device):

ETH0 -- TUN0 <==> ETH1 -- [IP network] -- TUN1 (192.168.100.2)

$ip addr show
6: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:00:22:33:11:55 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.2/24 scope global eth0
       valid_lft forever preferred_lft forever
7: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:11:22:33:11:55 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.1/24 scope global eth1
       valid_lft forever preferred_lft forever
8: tun0@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1480 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ipip 192.168.1.1 peer 192.168.1.2
    inet 192.168.100.1/24 scope global tun0
       valid_lft forever preferred_lft forever

$ip route show
default via 192.168.100.2 dev tun0
192.168.0.0/24 dev eth0 proto kernel scope link src 192.168.0.2
192.168.1.0/24 dev eth1 proto kernel scope link src 192.168.1.1
192.168.100.0/24 dev tun0 proto kernel scope link src 192.168.100.1

$nft list ruleset
table inet filter {
        flowtable ft {
                hook ingress priority filter
                devices = { eth0, eth1 }
        }

        chain forward {
                type filter hook forward priority filter; policy accept;
                meta l4proto { tcp, udp } flow add @ft
        }
}

Reproducing the scenario described above using veths I got the following
results:
- TCP stream received from the IPIP tunnel:
  - net-next: (baseline)		~ 71Gbps
  - net-next + IPIP flowtbale support:	~101Gbps

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h             | 13 +++++
 include/net/netfilter/nf_flow_table.h | 18 +++++++
 net/ipv4/ipip.c                       | 25 ++++++++++
 net/netfilter/nf_flow_table_core.c    |  3 ++
 net/netfilter/nf_flow_table_ip.c      | 69 ++++++++++++++++++++++++---
 net/netfilter/nf_flow_table_path.c    | 38 ++++++++++++---
 6 files changed, 153 insertions(+), 13 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e808071dbb7d..bf99fe8622da 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -877,6 +877,7 @@ enum net_device_path_type {
 	DEV_PATH_PPPOE,
 	DEV_PATH_DSA,
 	DEV_PATH_MTK_WDMA,
+	DEV_PATH_TUN,
 };
 
 struct net_device_path {
@@ -888,6 +889,18 @@ struct net_device_path {
 			__be16		proto;
 			u8		h_dest[ETH_ALEN];
 		} encap;
+		struct {
+			union {
+				struct in_addr	src_v4;
+				struct in6_addr	src_v6;
+			};
+			union {
+				struct in_addr	dst_v4;
+				struct in6_addr	dst_v6;
+			};
+
+			u8	l3_proto;
+		} tun;
 		struct {
 			enum {
 				DEV_PATH_BR_VLAN_KEEP,
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 89cfe7228398..497f5179b3da 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -107,6 +107,19 @@ enum flow_offload_xmit_type {
 
 #define NF_FLOW_TABLE_ENCAP_MAX		2
 
+struct flow_offload_tunnel {
+	union {
+		struct in_addr	src_v4;
+		struct in6_addr	src_v6;
+	};
+	union {
+		struct in_addr	dst_v4;
+		struct in6_addr	dst_v6;
+	};
+
+	u8	l3_proto;
+};
+
 struct flow_offload_tuple {
 	union {
 		struct in_addr		src_v4;
@@ -130,12 +143,15 @@ struct flow_offload_tuple {
 		__be16			proto;
 	} encap[NF_FLOW_TABLE_ENCAP_MAX];
 
+	struct flow_offload_tunnel	tun;
+
 	/* All members above are keys for lookups, see flow_offload_hash(). */
 	struct { }			__hash;
 
 	u8				dir:2,
 					xmit_type:3,
 					encap_num:2,
+					tun_num:2,
 					in_vlan_ingress:2;
 	u16				mtu;
 	union {
@@ -206,7 +222,9 @@ struct nf_flow_route {
 				u16		id;
 				__be16		proto;
 			} encap[NF_FLOW_TABLE_ENCAP_MAX];
+			struct flow_offload_tunnel tun;
 			u8			num_encaps:2,
+						num_tuns:2,
 						ingress_vlans:2;
 		} in;
 		struct {
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 3e03af073a1c..ff95b1b9908e 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -353,6 +353,30 @@ ipip_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm_kern *p, int cmd)
 	return ip_tunnel_ctl(dev, p, cmd);
 }
 
+static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
+				  struct net_device_path *path)
+{
+	struct ip_tunnel *tunnel = netdev_priv(ctx->dev);
+	const struct iphdr *tiph = &tunnel->parms.iph;
+	struct rtable *rt;
+
+	rt = ip_route_output(dev_net(ctx->dev), tiph->daddr, 0, 0, 0,
+			     RT_SCOPE_UNIVERSE);
+	if (IS_ERR(rt))
+		return PTR_ERR(rt);
+
+	path->type = DEV_PATH_TUN;
+	path->tun.src_v4.s_addr = tiph->saddr;
+	path->tun.dst_v4.s_addr = tiph->daddr;
+	path->tun.l3_proto = IPPROTO_IPIP;
+	path->dev = ctx->dev;
+
+	ctx->dev = rt->dst.dev;
+	ip_rt_put(rt);
+
+	return 0;
+}
+
 static const struct net_device_ops ipip_netdev_ops = {
 	.ndo_init       = ipip_tunnel_init,
 	.ndo_uninit     = ip_tunnel_uninit,
@@ -362,6 +386,7 @@ static const struct net_device_ops ipip_netdev_ops = {
 	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_get_iflink = ip_tunnel_get_iflink,
 	.ndo_tunnel_ctl	= ipip_tunnel_ctl,
+	.ndo_fill_forward_path = ipip_fill_forward_path,
 };
 
 #define IPIP_FEATURES (NETIF_F_SG |		\
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 6c6a5165f993..06e8251a6644 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -118,7 +118,10 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 			flow_tuple->in_vlan_ingress |= BIT(j);
 		j++;
 	}
+
+	flow_tuple->tun = route->tuple[dir].in.tun;
 	flow_tuple->encap_num = route->tuple[dir].in.num_encaps;
+	flow_tuple->tun_num = route->tuple[dir].in.num_tuns;
 
 	switch (route->tuple[dir].xmit_type) {
 	case FLOW_OFFLOAD_XMIT_DIRECT:
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index ac6641a866e0..2214e858e096 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -145,8 +145,11 @@ static bool ip_has_options(unsigned int thoff)
 static void nf_flow_tuple_encap(struct sk_buff *skb,
 				struct flow_offload_tuple *tuple)
 {
+	__be16 inner_proto = skb->protocol;
 	struct vlan_ethhdr *veth;
 	struct pppoe_hdr *phdr;
+	struct iphdr *iph;
+	u16 offset = 0;
 	int i = 0;
 
 	if (skb_vlan_tag_present(skb)) {
@@ -159,13 +162,26 @@ static void nf_flow_tuple_encap(struct sk_buff *skb,
 		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
 		tuple->encap[i].id = ntohs(veth->h_vlan_TCI);
 		tuple->encap[i].proto = skb->protocol;
+		inner_proto = veth->h_vlan_encapsulated_proto;
+		offset += VLAN_HLEN;
 		break;
 	case htons(ETH_P_PPP_SES):
 		phdr = (struct pppoe_hdr *)skb_network_header(skb);
 		tuple->encap[i].id = ntohs(phdr->sid);
 		tuple->encap[i].proto = skb->protocol;
+		inner_proto = *((__be16 *)(phdr + 1));
+		offset += PPPOE_SES_HLEN;
 		break;
 	}
+
+	if (inner_proto == htons(ETH_P_IP)) {
+		iph = (struct iphdr *)(skb_network_header(skb) + offset);
+		if (iph->protocol == IPPROTO_IPIP) {
+			tuple->tun.dst_v4.s_addr = iph->daddr;
+			tuple->tun.src_v4.s_addr = iph->saddr;
+			tuple->tun.l3_proto = IPPROTO_IPIP;
+		}
+	}
 }
 
 struct nf_flowtable_ctx {
@@ -277,11 +293,46 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
+static bool nf_flow_ip4_tunnel_proto(struct sk_buff *skb, u32 *psize)
+{
+	struct iphdr *iph;
+	u16 size;
+
+	if (!pskb_may_pull(skb, sizeof(*iph) + *psize))
+		return false;
+
+	iph = (struct iphdr *)(skb_network_header(skb) + *psize);
+	size = iph->ihl << 2;
+
+	if (ip_is_fragment(iph) || unlikely(ip_has_options(size)))
+		return false;
+
+	if (iph->ttl <= 1)
+		return false;
+
+	if (iph->protocol == IPPROTO_IPIP)
+		*psize += size;
+
+	return true;
+}
+
+static void nf_flow_ip4_tunnel_pop(struct sk_buff *skb)
+{
+	struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
+
+	if (iph->protocol != IPPROTO_IPIP)
+		return;
+
+	skb_pull(skb, iph->ihl << 2);
+	skb_reset_network_header(skb);
+}
+
 static bool nf_flow_skb_encap_protocol(struct sk_buff *skb, __be16 proto,
 				       u32 *offset)
 {
+	__be16 inner_proto = skb->protocol;
 	struct vlan_ethhdr *veth;
-	__be16 inner_proto;
+	bool ret = false;
 
 	switch (skb->protocol) {
 	case htons(ETH_P_8021Q):
@@ -291,19 +342,23 @@ static bool nf_flow_skb_encap_protocol(struct sk_buff *skb, __be16 proto,
 		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
 		if (veth->h_vlan_encapsulated_proto == proto) {
 			*offset += VLAN_HLEN;
-			return true;
+			inner_proto = proto;
+			ret = true;
 		}
 		break;
 	case htons(ETH_P_PPP_SES):
 		if (nf_flow_pppoe_proto(skb, &inner_proto) &&
 		    inner_proto == proto) {
 			*offset += PPPOE_SES_HLEN;
-			return true;
+			ret = true;
 		}
 		break;
 	}
 
-	return false;
+	if (inner_proto == htons(ETH_P_IP))
+		ret = nf_flow_ip4_tunnel_proto(skb, offset);
+
+	return ret;
 }
 
 static void nf_flow_encap_pop(struct sk_buff *skb,
@@ -331,6 +386,9 @@ static void nf_flow_encap_pop(struct sk_buff *skb,
 			break;
 		}
 	}
+
+	if (skb->protocol == htons(ETH_P_IP))
+		nf_flow_ip4_tunnel_pop(skb);
 }
 
 struct nf_flow_xmit {
@@ -356,8 +414,7 @@ nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
 {
 	struct flow_offload_tuple tuple = {};
 
-	if (skb->protocol != htons(ETH_P_IP) &&
-	    !nf_flow_skb_encap_protocol(skb, htons(ETH_P_IP), &ctx->offset))
+	if (!nf_flow_skb_encap_protocol(skb, htons(ETH_P_IP), &ctx->offset))
 		return NULL;
 
 	if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0)
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 50b2b7d0c579..64e2672a3c33 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -80,6 +80,8 @@ struct nft_forward_info {
 		__be16	proto;
 	} encap[NF_FLOW_TABLE_ENCAP_MAX];
 	u8 num_encaps;
+	struct flow_offload_tunnel tun;
+	u8 num_tuns;
 	u8 ingress_vlans;
 	u8 h_source[ETH_ALEN];
 	u8 h_dest[ETH_ALEN];
@@ -102,6 +104,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 		case DEV_PATH_DSA:
 		case DEV_PATH_VLAN:
 		case DEV_PATH_PPPOE:
+		case DEV_PATH_TUN:
 			info->indev = path->dev;
 			if (is_zero_ether_addr(info->h_source))
 				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
@@ -113,14 +116,27 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				break;
 			}
 
-			/* DEV_PATH_VLAN and DEV_PATH_PPPOE */
-			if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
-				info->indev = NULL;
-				break;
+			/* DEV_PATH_VLAN, DEV_PATH_PPPOE and DEV_PATH_TUN */
+			if (path->type == DEV_PATH_TUN) {
+				if (info->num_tuns) {
+					info->indev = NULL;
+					break;
+				}
+				info->tun.src_v6 = path->tun.src_v6;
+				info->tun.dst_v6 = path->tun.dst_v6;
+				info->tun.l3_proto = path->tun.l3_proto;
+				info->num_tuns++;
+			} else {
+				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
+					info->indev = NULL;
+					break;
+				}
+				info->encap[info->num_encaps].id =
+					path->encap.id;
+				info->encap[info->num_encaps].proto =
+					path->encap.proto;
+				info->num_encaps++;
 			}
-			info->encap[info->num_encaps].id = path->encap.id;
-			info->encap[info->num_encaps].proto = path->encap.proto;
-			info->num_encaps++;
 			if (path->type == DEV_PATH_PPPOE)
 				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
 			break;
@@ -196,6 +212,14 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 		route->tuple[!dir].in.encap[i].id = info.encap[i].id;
 		route->tuple[!dir].in.encap[i].proto = info.encap[i].proto;
 	}
+
+	if (info.num_tuns) {
+		route->tuple[!dir].in.tun.src_v6 = info.tun.dst_v6;
+		route->tuple[!dir].in.tun.dst_v6 = info.tun.src_v6;
+		route->tuple[!dir].in.tun.l3_proto = info.tun.l3_proto;
+		route->tuple[!dir].in.num_tuns = info.num_tuns;
+	}
+
 	route->tuple[!dir].in.num_encaps = info.num_encaps;
 	route->tuple[!dir].in.ingress_vlans = info.ingress_vlans;
 	route->tuple[dir].out.ifindex = info.outdev->ifindex;
-- 
2.47.3

