Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAC43CF03E;
	Thu,  9 Apr 2026 13:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740068; cv=none; b=Vl4D2+4jiVxH8c/o6GIcjAUszhlVddT6wIOo3miPcJRgyMiU9il+gYy1Zyb126WRuRiykVmi3wvQsjaEG4VbOj6YsqFbL8wwHvJtefk53bJFk+VzjfA2X3c+xa00UOJQXCMj+BYafWfwTDwPXnqWFFbrCVynzrQxREwJNmy9j90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740068; c=relaxed/simple;
	bh=V8yWgEIDw3Aej3VaRFD1FMwXyNe1Q8zT/fES3H1tciU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N/M7rrizYePDp/pOD2G1hLdYUEzd4vVqec4xn0nftZxFZjUTbvHjuOTD2a3/H1jUWRIlNQ506D28GoSpX35ZqoU7GfONV1r+SvQQ8KPzg4Qwi4SV8Yl2cwPD+Dl0b49UJI8A9v3208jKHfO5IYMQ0L7q83aCteMWbAtL2MahT6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wAp6j-000000001kZ-0rCL;
	Thu, 09 Apr 2026 13:07:41 +0000
Date: Thu, 9 Apr 2026 14:07:38 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH RFC net-next 2/4] nf_flow_table: track sub-interface and
 bridge ifindex in flow tuple
Message-ID: <f1964680a3b5e7daa81a07be18f9e91af199102f.1775739840.git.daniel@makrotopia.org>
References: <cover.1775739840.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1775739840.git.daniel@makrotopia.org>

Store the net_device ifindex alongside each encap entry and for
bridge devices during path discovery so the flow offload stats
path can later update sub-interface (VLAN, PPPoE, bridge)
counters for hw-offloaded flows.

The indices are placed below __hash so they do not affect flow
tuple lookups.

No functional change -- the indices are stored but not yet used.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 include/net/netfilter/nf_flow_table.h | 5 +++++
 net/netfilter/nf_flow_table_core.c    | 2 ++
 net/netfilter/nf_flow_table_path.c    | 8 ++++++++
 3 files changed, 15 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index b09c11c048d51..ec1a18cfd9621 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -148,6 +148,9 @@ struct flow_offload_tuple {
 	/* All members above are keys for lookups, see flow_offload_hash(). */
 	struct { }			__hash;
 
+	int				encap_ifidx[NF_FLOW_TABLE_ENCAP_MAX];
+	int				bridge_ifidx;
+
 	u8				dir:2,
 					xmit_type:3,
 					encap_num:2,
@@ -221,11 +224,13 @@ struct nf_flow_route {
 			struct {
 				u16		id;
 				__be16		proto;
+				int		ifindex;
 			} encap[NF_FLOW_TABLE_ENCAP_MAX];
 			struct flow_offload_tunnel tun;
 			u8			num_encaps:2,
 						num_tuns:2,
 						ingress_vlans:2;
+			int			bridge_ifindex;
 		} in;
 		struct {
 			u32			ifindex;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 2c4140e6f53c5..9bc8be177b392 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -115,6 +115,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 	for (i = route->tuple[dir].in.num_encaps - 1; i >= 0; i--) {
 		flow_tuple->encap[j].id = route->tuple[dir].in.encap[i].id;
 		flow_tuple->encap[j].proto = route->tuple[dir].in.encap[i].proto;
+		flow_tuple->encap_ifidx[j] = route->tuple[dir].in.encap[i].ifindex;
 		if (route->tuple[dir].in.ingress_vlans & BIT(i))
 			flow_tuple->in_vlan_ingress |= BIT(j);
 		j++;
@@ -123,6 +124,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 	flow_tuple->tun = route->tuple[dir].in.tun;
 	flow_tuple->encap_num = route->tuple[dir].in.num_encaps;
 	flow_tuple->tun_num = route->tuple[dir].in.num_tuns;
+	flow_tuple->bridge_ifidx = route->tuple[dir].in.bridge_ifindex;
 
 	switch (route->tuple[dir].xmit_type) {
 	case FLOW_OFFLOAD_XMIT_DIRECT:
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 6bb9579dcc2ab..c5817cb96a9f6 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -79,8 +79,10 @@ struct nft_forward_info {
 	struct id {
 		__u16	id;
 		__be16	proto;
+		int	ifindex;
 	} encap[NF_FLOW_TABLE_ENCAP_MAX];
 	u8 num_encaps;
+	int bridge_ifindex;
 	struct flow_offload_tunnel tun;
 	u8 num_tuns;
 	u8 ingress_vlans;
@@ -136,12 +138,15 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 					path->encap.id;
 				info->encap[info->num_encaps].proto =
 					path->encap.proto;
+				info->encap[info->num_encaps].ifindex =
+					path->dev->ifindex;
 				info->num_encaps++;
 			}
 			if (path->type == DEV_PATH_PPPOE)
 				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
 			break;
 		case DEV_PATH_BRIDGE:
+			info->bridge_ifindex = path->dev->ifindex;
 			if (is_zero_ether_addr(info->h_source))
 				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
 
@@ -156,6 +161,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				}
 				info->encap[info->num_encaps].id = path->bridge.vlan_id;
 				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
+				info->encap[info->num_encaps].ifindex = path->dev->ifindex;
 				info->num_encaps++;
 				break;
 			case DEV_PATH_BR_VLAN_UNTAG:
@@ -261,6 +267,7 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	for (i = 0; i < info.num_encaps; i++) {
 		route->tuple[!dir].in.encap[i].id = info.encap[i].id;
 		route->tuple[!dir].in.encap[i].proto = info.encap[i].proto;
+		route->tuple[!dir].in.encap[i].ifindex = info.encap[i].ifindex;
 	}
 
 	if (info.num_tuns &&
@@ -273,6 +280,7 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
 
 	route->tuple[!dir].in.num_encaps = info.num_encaps;
 	route->tuple[!dir].in.ingress_vlans = info.ingress_vlans;
+	route->tuple[!dir].in.bridge_ifindex = info.bridge_ifindex;
 
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
-- 
2.53.0
