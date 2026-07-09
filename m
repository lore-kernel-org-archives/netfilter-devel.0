Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41837402BB6;
	Thu,  9 Jul 2026 08:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783587155; cv=none; b=RnXo71t9TQAebB1gWKsdS048iI4NeVbqxTgZ+NllngSzbvPVV0xqAK2Pavq+gP0AxFIMiaTCuNDLKhXcySA6xN4/N4+Uk1WgbwdEPUHqFy+NWimsbtcLb8GKpytOCaYPQIlWL5GjgwbhNeifojUv/aUaVv3xO6/+Jp6Zzfrvlvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783587155; c=relaxed/simple;
	bh=7UkJtURQE0sJ1w9rPMT4X/+XpfimzkFZ2vVRjgWkpXY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rdESSXpqVStYJDY4jKhFwYrO76OwxZeeyX6V6ad/E1YHgN3ccLRfLKdXtsioP//dSeyXgH+RbQAB2k+spgI6s0Ndrogi0AlEjkP6mzIJNjgJdqQjTx2CazAHuh9kD9A8ZQJ6YD9fi3cqKysPxq+8eM9PtGaERmDOQ6RxCrv63IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=odcsK8za; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="odcsK8za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679181F000E9;
	Thu,  9 Jul 2026 08:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783587153;
	bh=1N+zQCH0A9q9dzH/bvqLvSAQ5/Ea/cC6su+kc1dzM5I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=odcsK8za/ih1OmRM+AmRkDjRYOHmiEcpy5+sqrxy5LwngXJ5ggPfmTAAKMNt3/pss
	 3Y4wexQEeOIeIwEGbnYBV+Z9QovHvH5OWrbxRnL9FZC1WcYGFKbwjE2Y7ssq+40lg9
	 +kpAQSdp02dQR02vodsm7mJptytYnzZEN5sieorwwD76fPhwWt61lnPrq+rf7gQap6
	 e7GHkyyiMtv8OURxKC//sj832tWHwJkBSAonydL5mFXbydOPD5K9Y6ZshsaY4KIsVL
	 MZHTfhcks7meHBu6hfoHMvCAvecklurosssR+p8eYdG91ad5BCCNqy1LJX4oOY0vyG
	 cDx86qCNoFLjQ==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Thu, 09 Jul 2026 10:52:08 +0200
Subject: [PATCH nf-next v5 1/6] net: netfilter: add ether_type to
 net_device_path_ctx
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-b4-flowtable-sw-accel-ip6ip-v5-1-828ceaf85bab@kernel.org>
References: <20260709-b4-flowtable-sw-accel-ip6ip-v5-0-828ceaf85bab@kernel.org>
In-Reply-To: <20260709-b4-flowtable-sw-accel-ip6ip-v5-0-828ceaf85bab@kernel.org>
To: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Felix Fietkau <nbd@nbd.name>, Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Simon Horman <horms@kernel.org>, David Ahern <dsahern@kernel.org>, 
 Ido Schimmel <idosch@nvidia.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 Shuah Khan <shuah@kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, netdev@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.14.3

Add an ether_type field to struct net_device_path_ctx to allow IPv6
tunnel drivers to select the appropriate L3 protocol based on the
encapsulated traffic.
Update the airoha and mtk Ethernet drivers to use the new
dev_fill_forward_path() signature.
This is a preliminary patch to enable sw flowtable acceleration for
IPv4 over IPv6 tunnels.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_ppe.c        | 13 ++++++++-----
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 13 ++++++++-----
 include/linux/netdevice.h                       |  4 +++-
 net/core/dev.c                                  |  6 ++++--
 net/ipv6/ip6_tunnel.c                           |  5 ++++-
 net/netfilter/nf_flow_table_path.c              |  8 +++++---
 6 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index e7c78293002a..06d128c67c8c 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -276,7 +276,8 @@ static int airoha_ppe_flow_mangle_ipv4(const struct flow_action_entry *act,
 	return 0;
 }
 
-static int airoha_ppe_get_wdma_info(struct net_device *dev, const u8 *addr,
+static int airoha_ppe_get_wdma_info(struct net_device *dev,
+				    const u8 *addr, __be16 ether_type,
 				    struct airoha_wdma_info *info)
 {
 	struct net_device_path_stack stack;
@@ -287,7 +288,7 @@ static int airoha_ppe_get_wdma_info(struct net_device *dev, const u8 *addr,
 		return -ENODEV;
 
 	rcu_read_lock();
-	err = dev_fill_forward_path(dev, addr, &stack);
+	err = dev_fill_forward_path(dev, addr, ether_type, &stack);
 	rcu_read_unlock();
 	if (err)
 		return err;
@@ -331,7 +332,7 @@ static int airoha_ppe_foe_entry_prepare(struct airoha_eth *eth,
 					struct airoha_foe_entry *hwe,
 					struct net_device *netdev, int type,
 					struct airoha_flow_data *data,
-					int l4proto)
+					__be16 ether_type, int l4proto)
 {
 	u32 qdata = FIELD_PREP(AIROHA_FOE_SHAPER_ID, 0x7f), ports_pad, val;
 	int wlan_etype = -EINVAL, dsa_port = airoha_get_dsa_port(&netdev);
@@ -354,7 +355,7 @@ static int airoha_ppe_foe_entry_prepare(struct airoha_eth *eth,
 		struct airoha_wdma_info info = {};
 
 		if (!airoha_ppe_get_wdma_info(netdev, data->eth.h_dest,
-					      &info)) {
+					      ether_type, &info)) {
 			val |= FIELD_PREP(AIROHA_FOE_IB2_NBQ, info.idx) |
 			       FIELD_PREP(AIROHA_FOE_IB2_PSE_PORT,
 					  FE_PSE_PORT_CDM4);
@@ -1081,6 +1082,7 @@ static int airoha_ppe_flow_offload_replace(struct airoha_eth *eth,
 	struct flow_action_entry *act;
 	struct airoha_foe_entry hwe;
 	int err, i, offload_type;
+	__be16 ether_type = 0;
 	u16 addr_type = 0;
 	u8 l4proto = 0;
 
@@ -1107,6 +1109,7 @@ static int airoha_ppe_flow_offload_replace(struct airoha_eth *eth,
 		struct flow_match_basic match;
 
 		flow_rule_match_basic(rule, &match);
+		ether_type = match.key->n_proto;
 		l4proto = match.key->ip_proto;
 	} else {
 		return -EOPNOTSUPP;
@@ -1177,7 +1180,7 @@ static int airoha_ppe_flow_offload_replace(struct airoha_eth *eth,
 		return -EINVAL;
 
 	err = airoha_ppe_foe_entry_prepare(eth, &hwe, odev, offload_type,
-					   &data, l4proto);
+					   &data, ether_type, l4proto);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index cc8c4ef8038f..2601c17b29c8 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -89,7 +89,8 @@ mtk_flow_offload_mangle_eth(const struct flow_action_entry *act, void *eth)
 }
 
 static int
-mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr, struct mtk_wdma_info *info)
+mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr,
+		       __be16 ether_type, struct mtk_wdma_info *info)
 {
 	struct net_device_path_stack stack;
 	struct net_device_path *path;
@@ -102,7 +103,7 @@ mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr, struct mtk_wdma_i
 		return -1;
 
 	rcu_read_lock();
-	err = dev_fill_forward_path(dev, addr, &stack);
+	err = dev_fill_forward_path(dev, addr, ether_type, &stack);
 	rcu_read_unlock();
 	if (err)
 		return err;
@@ -190,12 +191,12 @@ mtk_flow_get_dsa_port(struct net_device **dev)
 static int
 mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
 			   struct net_device *dev, const u8 *dest_mac,
-			   int *wed_index)
+			   __be16 ether_type, int *wed_index)
 {
 	struct mtk_wdma_info info = {};
 	int pse_port, dsa_port, queue;
 
-	if (mtk_flow_get_wdma_info(dev, dest_mac, &info) == 0) {
+	if (mtk_flow_get_wdma_info(dev, dest_mac, ether_type, &info) == 0) {
 		mtk_foe_entry_set_wdma(eth, foe, info.wdma_idx, info.queue,
 				       info.bss, info.wcid, info.amsdu);
 		if (mtk_is_netsys_v2_or_greater(eth)) {
@@ -273,6 +274,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f,
 	struct mtk_flow_data data = {};
 	struct mtk_foe_entry foe;
 	struct mtk_flow_entry *entry;
+	__be16 ether_type = 0;
 	int offload_type = 0;
 	int wed_index = -1;
 	u16 addr_type = 0;
@@ -319,6 +321,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f,
 		struct flow_match_basic match;
 
 		flow_rule_match_basic(rule, &match);
+		ether_type = match.key->n_proto;
 		l4proto = match.key->ip_proto;
 	} else {
 		return -EOPNOTSUPP;
@@ -481,7 +484,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f,
 		mtk_foe_entry_set_pppoe(eth, &foe, data.pppoe.sid);
 
 	err = mtk_flow_set_output_device(eth, &foe, odev, data.eth.h_dest,
-					 &wed_index);
+					 ether_type, &wed_index);
 	if (err)
 		return err;
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9981d637f8b5..a97aee0e49b2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -938,6 +938,7 @@ struct net_device_path_stack {
 struct net_device_path_ctx {
 	const struct net_device *dev;
 	u8			daddr[ETH_ALEN];
+	__be16			ether_type;
 
 	int			num_vlans;
 	struct {
@@ -3420,7 +3421,8 @@ void dev_remove_offload(struct packet_offload *po);
 
 int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
-int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
+int dev_fill_forward_path(const struct net_device *dev,
+			  const u8 *daddr, __be16 ether_type,
 			  struct net_device_path_stack *stack);
 struct net_device *dev_get_by_name(struct net *net, const char *name);
 struct net_device *dev_get_by_name_rcu(struct net *net, const char *name);
diff --git a/net/core/dev.c b/net/core/dev.c
index 714d05283500..b0e2de0e95f8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -750,12 +750,14 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 	return &stack->path[k];
 }
 
-int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
+int dev_fill_forward_path(const struct net_device *dev,
+			  const u8 *daddr, __be16 ether_type,
 			  struct net_device_path_stack *stack)
 {
 	const struct net_device *last_dev;
 	struct net_device_path_ctx ctx = {
-		.dev	= dev,
+		.dev		= dev,
+		.ether_type	= ether_type,
 	};
 	struct net_device_path *path;
 	int ret = 0;
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index bf8e40af60b0..38da07101601 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1863,7 +1863,10 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 		path->type = DEV_PATH_TUN;
 		path->tun.src_v6 = t->parms.laddr;
 		path->tun.dst_v6 = t->parms.raddr;
-		path->tun.l3_proto = IPPROTO_IPV6;
+		if (ctx->ether_type == cpu_to_be16(ETH_P_IP))
+			path->tun.l3_proto = IPPROTO_IPIP;
+		else
+			path->tun.l3_proto = IPPROTO_IPV6;
 		path->dev = ctx->dev;
 		ctx->dev = dst->dev;
 	}
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 98c03b487f52..c8011ec36532 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -45,7 +45,8 @@ static bool nft_is_valid_ether_device(const struct net_device *dev)
 static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 				     const struct dst_entry *dst_cache,
 				     const struct nf_conn *ct,
-				     enum ip_conntrack_dir dir, u8 *ha,
+				     enum ip_conntrack_dir dir,
+				     u8 *ha, __be16 ether_type,
 				     struct net_device_path_stack *stack)
 {
 	const void *daddr = &ct->tuplehash[!dir].tuple.src.u3;
@@ -72,7 +73,7 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 		return -1;
 
 out:
-	return dev_fill_forward_path(dev, ha, stack);
+	return dev_fill_forward_path(dev, ha, ether_type, stack);
 }
 
 struct nft_forward_info {
@@ -255,7 +256,8 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	unsigned char ha[ETH_ALEN];
 	int i;
 
-	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) < 0 ||
+	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, pkt->ethertype,
+				      &stack) < 0 ||
 	    nft_dev_path_info(&stack, &info, ha, &ft->data) < 0)
 		return -ENOENT;
 

-- 
2.55.0

