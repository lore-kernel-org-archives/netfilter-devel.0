Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162B013A265;
	Mon, 23 Jun 2025 13:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684572; cv=none; b=fEMQeeMrfw39L+IJj3z17yLzm622imQ49MguAvQAkekRNGtP5dtXfuIEQUzMYFdCX+tOf2vulliDaXSJjBt476awemeeGSxuUAll8GyZZYI5DqHKn7iBXOUek3OdJu7iWyLec2PDS9l+fMTNDYvsMIe2xuRu0ayCFFBSaryq5wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684572; c=relaxed/simple;
	bh=P0kBJZV+0S7POdsIt4dLldqUrkMBHnZrw+Z8iFs4xRM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=mLaM/L7zHN/4Do3vx8fH8Gr1CPnyVlSlClIIBirlhNEYwhKO9/L/xuAWMdqRxQon2RmfwTOZcWcsX2mnbAE/nKc1IpptnTMt8Dgxo7QPA84dU5weZbg8chZVilulAWERruIVNlkQgsQGFPk/QTgxPWCEzdVv2iZdMRuTXNl51Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZigHBaR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZigHBaR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C3BC4CEEA;
	Mon, 23 Jun 2025 13:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750684571;
	bh=P0kBJZV+0S7POdsIt4dLldqUrkMBHnZrw+Z8iFs4xRM=;
	h=From:Date:Subject:To:Cc:From;
	b=ZigHBaR7GI4ak1xzPyAZZDSuLJXUManjjRBvoRQoy2NDqaS+4/HAY12xb7xSaGpVp
	 K3oR2D7VOxVTFZp5KijkIYbbwvALrNb4Hgwtt355B58ivq6zYNo1NGVFhz9XhtTugR
	 upf1AuGjvDLViNmk/wCUNJTcuC76d9eovyYMkqjht7l0fuBmrpQEojMdSZ8OfIoKAY
	 aflHB67TnlEPYMYygnawAUebC2vBCdlF+1jF1LaM7Ed/hfCzVjEz7t6VbZkknGeRsc
	 eUj1WVvZnwUpMYTdGKp8JJcRFKzGy5/JrgRRVdgPoFEhejZvsOA+n9TKdx1WfyDKvX
	 HBgwpZoyQ5HaA==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Mon, 23 Jun 2025 15:15:51 +0200
Subject: [PATCH net-next] net: netfilter: Add IPIP flowtable SW
 acceleration
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250623-nf-flowtable-ipip-v1-1-2853596e3941@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIZTWWgC/x2MWwqAIBAArxL7nWBKD7pK9KG51oKYaFQg3j3pc
 xhmMiSMhAnmJkPEmxKdvkLXNrAdyu/IyFQGwUXPByGZt8y687mUdtUFCqzT0oyaT4YPI9QuRLT
 0/s9lLeUDUz+pRWMAAAA=
X-Change-ID: 20250623-nf-flowtable-ipip-1b3d7b08d067
To: "David S. Miller" <davem@davemloft.net>, 
 David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, Lorenzo Bianconi <lorenzo@kernel.org>
X-Mailer: b4 0.14.2

Introduce SW acceleration for IPIP tunnels in the netfilter flowtable
infrastructure.
IPIP SW acceleration can be tested running the following scenario where
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

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/ipv4/ipip.c                  | 21 +++++++++++++++++++++
 net/netfilter/nf_flow_table_ip.c | 35 +++++++++++++++++++++++++++++++++--
 2 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 3e03af073a1ccc3d7597a998a515b6cfdded40b5..05fb1c859170d74009d693bc8513183bdec3ff90 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -353,6 +353,26 @@ ipip_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm_kern *p, int cmd)
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
+	path->type = DEV_PATH_ETHERNET;
+	path->dev = ctx->dev;
+	ctx->dev = rt->dst.dev;
+	ip_rt_put(rt);
+
+	return 0;
+}
+
 static const struct net_device_ops ipip_netdev_ops = {
 	.ndo_init       = ipip_tunnel_init,
 	.ndo_uninit     = ip_tunnel_uninit,
@@ -362,6 +382,7 @@ static const struct net_device_ops ipip_netdev_ops = {
 	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_get_iflink = ip_tunnel_get_iflink,
 	.ndo_tunnel_ctl	= ipip_tunnel_ctl,
+	.ndo_fill_forward_path = ipip_fill_forward_path,
 };
 
 #define IPIP_FEATURES (NETIF_F_SG |		\
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 8cd4cf7ae21120f1057c4fce5aaca4e3152ae76d..bee9f233723985f6567c3fc9840cd2f7698b590b 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -277,6 +277,29 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
+static bool nf_flow_ipip_proto(struct sk_buff *skb)
+{
+	struct iphdr *iph;
+
+	if (!pskb_may_pull(skb, sizeof(*iph)))
+		return false;
+
+	iph = (struct iphdr *)skb_network_header(skb);
+	return iph->protocol == IPPROTO_IPIP;
+}
+
+static u16 nf_flow_ip_get_hdr_size(struct sk_buff *skb)
+{
+	struct iphdr *iph;
+
+	if (pskb_may_pull(skb, sizeof(*iph))) {
+		iph = (struct iphdr *)skb_network_header(skb);
+		return iph->ihl << 2;
+	}
+
+	return 0;
+}
+
 static bool nf_flow_skb_encap_protocol(struct sk_buff *skb, __be16 proto,
 				       u32 *offset)
 {
@@ -284,6 +307,10 @@ static bool nf_flow_skb_encap_protocol(struct sk_buff *skb, __be16 proto,
 	__be16 inner_proto;
 
 	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		if (nf_flow_ipip_proto(skb))
+			*offset += nf_flow_ip_get_hdr_size(skb);
+		return true;
 	case htons(ETH_P_8021Q):
 		if (!pskb_may_pull(skb, skb_mac_offset(skb) + sizeof(*veth)))
 			return false;
@@ -331,6 +358,11 @@ static void nf_flow_encap_pop(struct sk_buff *skb,
 			break;
 		}
 	}
+
+	if (skb->protocol == htons(ETH_P_IP) && nf_flow_ipip_proto(skb)) {
+		skb_pull(skb, nf_flow_ip_get_hdr_size(skb));
+		skb_reset_network_header(skb);
+	}
 }
 
 static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
@@ -357,8 +389,7 @@ nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
 {
 	struct flow_offload_tuple tuple = {};
 
-	if (skb->protocol != htons(ETH_P_IP) &&
-	    !nf_flow_skb_encap_protocol(skb, htons(ETH_P_IP), &ctx->offset))
+	if (!nf_flow_skb_encap_protocol(skb, htons(ETH_P_IP), &ctx->offset))
 		return NULL;
 
 	if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0)

---
base-commit: 5e95c0a3a55aea490420bd6994805edb050cc86b
change-id: 20250623-nf-flowtable-ipip-1b3d7b08d067

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

