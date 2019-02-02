From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/12 net-next,v7] flow_offload: add flow_rule and flow_match structures and use them
Date: Sat,  2 Feb 2019 12:50:43 +0100
Message-ID: <20190202115054.4880-2-pablo@netfilter.org>
References: <20190202115054.4880-1-pablo@netfilter.org>
Cc: davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        julia.lawall@lip6.fr, john.fastabend@gmail.com,
        netfilter-devel@vger.kernel.org, cphealy@gmail.co
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190202115054.4880-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch wraps the dissector key and mask - that flower uses to
represent the matching side - around the flow_match structure.

To avoid a follow up patch that would edit the same LoCs in the drivers,
this patch also wraps this new flow match structure around the flow rule
object. This new structure will also contain the flow actions in follow
up patches.

This introduces two new interfaces:

	bool flow_rule_match_key(rule, dissector_id)

that returns true if a given matching key is set on, and:

	flow_rule_match_XYZ(rule, &match);

To fetch the matching side XYZ into the match container structure, to
retrieve the key and the mask with one single call.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v7: rebase on top of net-next. Dropping previous Acked-by tags since
    this one is slightly large, and it would be good another look after
    this rebase.

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       | 174 ++++-----
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   | 194 ++++------
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 178 ++++-----
 drivers/net/ethernet/intel/iavf/iavf_main.c        | 195 ++++------
 drivers/net/ethernet/intel/igb/igb_main.c          |  64 ++--
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  68 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 376 ++++++++-----------
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  | 202 +++++-----
 drivers/net/ethernet/netronome/nfp/flower/action.c |  11 +-
 drivers/net/ethernet/netronome/nfp/flower/match.c  | 417 +++++++++++----------
 .../net/ethernet/netronome/nfp/flower/offload.c    | 149 +++-----
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |  85 ++---
 include/net/flow_offload.h                         | 115 ++++++
 include/net/pkt_cls.h                              |  11 +-
 net/core/Makefile                                  |   2 +-
 net/core/flow_offload.c                            | 143 +++++++
 net/sched/cls_flower.c                             |  47 ++-
 17 files changed, 1209 insertions(+), 1222 deletions(-)
 create mode 100644 include/net/flow_offload.h
 create mode 100644 net/core/flow_offload.c

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index c683b5e96b1d..90a2170c5138 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -177,18 +177,12 @@ static int bnxt_tc_parse_actions(struct bnxt *bp,
 	return 0;
 }
 
-#define GET_KEY(flow_cmd, key_type)					\
-		skb_flow_dissector_target((flow_cmd)->dissector, key_type,\
-					  (flow_cmd)->key)
-#define GET_MASK(flow_cmd, key_type)					\
-		skb_flow_dissector_target((flow_cmd)->dissector, key_type,\
-					  (flow_cmd)->mask)
-
 static int bnxt_tc_parse_flow(struct bnxt *bp,
 			      struct tc_cls_flower_offload *tc_flow_cmd,
 			      struct bnxt_tc_flow *flow)
 {
-	struct flow_dissector *dissector = tc_flow_cmd->dissector;
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(tc_flow_cmd);
+	struct flow_dissector *dissector = rule->match.dissector;
 
 	/* KEY_CONTROL and KEY_BASIC are needed for forming a meaningful key */
 	if ((dissector->used_keys & BIT(FLOW_DISSECTOR_KEY_CONTROL)) == 0 ||
@@ -198,140 +192,120 @@ static int bnxt_tc_parse_flow(struct bnxt *bp,
 		return -EOPNOTSUPP;
 	}
 
-	if (dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_BASIC)) {
-		struct flow_dissector_key_basic *key =
-			GET_KEY(tc_flow_cmd, FLOW_DISSECTOR_KEY_BASIC);
-		struct flow_dissector_key_basic *mask =
-			GET_MASK(tc_flow_cmd, FLOW_DISSECTOR_KEY_BASIC);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
 
-		flow->l2_key.ether_type = key->n_proto;
-		flow->l2_mask.ether_type = mask->n_proto;
+		flow_rule_match_basic(rule, &match);
+		flow->l2_key.ether_type = match.key->n_proto;
+		flow->l2_mask.ether_type = match.mask->n_proto;
 
-		if (key->n_proto == htons(ETH_P_IP) ||
-		    key->n_proto == htons(ETH_P_IPV6)) {
-			flow->l4_key.ip_proto = key->ip_proto;
-			flow->l4_mask.ip_proto = mask->ip_proto;
+		if (match.key->n_proto == htons(ETH_P_IP) ||
+		    match.key->n_proto == htons(ETH_P_IPV6)) {
+			flow->l4_key.ip_proto = match.key->ip_proto;
+			flow->l4_mask.ip_proto = match.mask->ip_proto;
 		}
 	}
 
-	if (dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
-		struct flow_dissector_key_eth_addrs *key =
-			GET_KEY(tc_flow_cmd, FLOW_DISSECTOR_KEY_ETH_ADDRS);
-		struct flow_dissector_key_eth_addrs *mask =
-			GET_MASK(tc_flow_cmd, FLOW_DISSECTOR_KEY_ETH_ADDRS);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		struct flow_match_eth_addrs match;
 
+		flow_rule_match_eth_addrs(rule, &match);
 		flow->flags |= BNXT_TC_FLOW_FLAGS_ETH_ADDRS;
-		ether_addr_copy(flow->l2_key.dmac, key->dst);
-		ether_addr_copy(flow->l2_mask.dmac, mask->dst);
-		ether_addr_copy(flow->l2_key.smac, key->src);
-		ether_addr_copy(flow->l2_mask.smac, mask->src);
+		ether_addr_copy(flow->l2_key.dmac, match.key->dst);
+		ether_addr_copy(flow->l2_mask.dmac, match.mask->dst);
+		ether_addr_copy(flow->l2_key.smac, match.key->src);
+		ether_addr_copy(flow->l2_mask.smac, match.mask->src);
 	}
 
-	if (dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_VLAN)) {
-		struct flow_dissector_key_vlan *key =
-			GET_KEY(tc_flow_cmd, FLOW_DISSECTOR_KEY_VLAN);
-		struct flow_dissector_key_vlan *mask =
-			GET_MASK(tc_flow_cmd, FLOW_DISSECTOR_KEY_VLAN);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
 
+		flow_rule_match_vlan(rule, &match);
 		flow->l2_key.inner_vlan_tci =
-		   cpu_to_be16(VLAN_TCI(key->vlan_id, key->vlan_priority));
+			cpu_to_be16(VLAN_TCI(match.key->vlan_id,
+					     match.key->vlan_priority));
 		flow->l2_mask.inner_vlan_tci =
-		   cpu_to_be16((VLAN_TCI(mask->vlan_id, mask->vlan_priority)));
+			cpu_to_be16((VLAN_TCI(match.mask->vlan_id,
+					      match.mask->vlan_priority)));
 		flow->l2_key.inner_vlan_tpid = htons(ETH_P_8021Q);
 		flow->l2_mask.inner_vlan_tpid = htons(0xffff);
 		flow->l2_key.num_vlans = 1;
 	}
 
-	if (dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
-		struct flow_dissector_key_ipv4_addrs *key =
-			GET_KEY(tc_flow_cmd, FLOW_DISSECTOR_KEY_IPV4_ADDRS);
-		struct flow_dissector_key_ipv4_addrs *mask =
-			GET_MASK(tc_flow_cmd, FLOW_DISSECTOR_KEY_IPV4_ADDRS);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
+		struct flow_match_ipv4_addrs match;
 
+		flow_rule_match_ipv4_addrs(rule, &match);
 		flow->flags |= BNXT_TC_FLOW_FLAGS_IPV4_ADDRS;
-		flow->l3_key.ipv4.daddr.s_addr = key->dst;
-		flow->l3_mask.ipv4.daddr.s_addr = mask->dst;
-		flow->l3_key.ipv4.saddr.s_addr = key->src;
-		flow->l3_mask.ipv4.saddr.s_addr = mask->src;
-	} else if (dissector_uses_key(dissector,
-				      FLOW_DISSECTOR_KEY_IPV6_ADDRS)) {
-		struct flow_dissector_key_ipv6_addrs *key =
-			GET_KEY(tc_flow_cmd, FLOW_DISSECTOR_KEY_IPV6_ADDRS);
-		struct flow_dissector_key_ipv6_addrs *mask =
-			GET_MASK(tc_flow_cmd, FLOW_DISSECTOR_KEY_IPV6_ADDRS);
-
+		flow->l3_key.ipv4.daddr.s_addr = match.key->dst;
+		flow->l3_mask.ipv4.daddr.s_addr = match.mask->dst;
+		flow->l3_key.ipv4.saddr.s_addr = match.key->src;
+		flow->l3_mask.ipv4.saddr.s_addr = match.mask->src;
+	} else if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS)) {
+		struct flow_match_ipv6_addrs match;
+
+		flow_rule_match_ipv6_addrs(rule, &match);
 		flow->flags |= BNXT_TC_FLOW_FLAGS_IPV6_ADDRS;
-		flow->l3_key.ipv6.daddr = key->dst;
-		flow->l3_mask.ipv6.daddr = mask->dst;
-		flow->l3_key.ipv6.saddr = key->src;
-		flow->l3_mask.ipv6.saddr = mask->src;
+		flow->l3_key.ipv6.daddr = match.key->dst;
+		flow->l3_mask.ipv6.daddr = match.mask->dst;
+		flow->l3_key.ipv6.saddr = match.key->src;
+		flow->l3_mask.ipv6.saddr = match.mask->src;
 	}
 
-	if (dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_PORTS)) {
-		struct flow_dissector_key_ports *key =
-			GET_KEY(tc_flow_cmd, FLOW_DISSECTOR_KEY_PORTS);
-		struct flow_dissector_key_ports *mask =
-			GET_MASK(tc_flow_cmd, FLOW_DISSECTOR_KEY_PORTS);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports match;
 
+		flow_rule_match_ports(rule, &match);
 		flow->flags |= BNXT_TC_FLOW_FLAGS_PORTS;
-		flow->l4_key.ports.dport = key->dst;
-		flow->l4_mask.ports.dport = mask->dst;
-		flow->l4_key.ports.sport = key->src;
-		flow->l4_mask.ports.sport = mask->src;
+		flow->l4_key.ports.dport = match.key->dst;
+		flow->l4_mask.ports.dport = match.mask->dst;
+		flow->l4_key.ports.sport = match.key->src;
+		flow->l4_mask.ports.sport = match.mask->src;
 	}
 
-	if (dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_ICMP)) {
-		struct flow_dissector_key_icmp *key =
-			GET_KEY(tc_flow_cmd, FLOW_DISSECTOR_KEY_ICMP);
-		struct flow_dissector_key_icmp *mask =
-			GET_MASK(tc_flow_cmd, FLOW_DISSECTOR_KEY_ICMP);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ICMP)) {
+		struct flow_match_icmp match;
 
+		flow_rule_match_icmp(rule, &match);
 		flow->flags |= BNXT_TC_FLOW_FLAGS_ICMP;
-		flow->l4_key.icmp.type = key->type;
-		flow->l4_key.icmp.code = key->code;
-		flow->l4_mask.icmp.type = mask->type;
-		flow->l4_mask.icmp.code = mask->code;
+		flow->l4_key.icmp.type = match.key->type;
+		flow->l4_key.icmp.code = match.key->code;
+		flow->l4_mask.icmp.type = match.mask->type;
+		flow->l4_mask.icmp.code = match.mask->code;
 	}
 
-	if (dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS)) {
-		struct flow_dissector_key_ipv4_addrs *key =
-			GET_KEY(tc_flow_cmd, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS);
-		struct flow_dissector_key_ipv4_addrs *mask =
-				GET_MASK(tc_flow_cmd,
-					 FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS)) {
+		struct flow_match_ipv4_addrs match;
 
+		flow_rule_match_enc_ipv4_addrs(rule, &match);
 		flow->flags |= BNXT_TC_FLOW_FLAGS_TUNL_IPV4_ADDRS;
-		flow->tun_key.u.ipv4.dst = key->dst;
-		flow->tun_mask.u.ipv4.dst = mask->dst;
-		flow->tun_key.u.ipv4.src = key->src;
-		flow->tun_mask.u.ipv4.src = mask->src;
-	} else if (dissector_uses_key(dissector,
+		flow->tun_key.u.ipv4.dst = match.key->dst;
+		flow->tun_mask.u.ipv4.dst = match.mask->dst;
+		flow->tun_key.u.ipv4.src = match.key->src;
+		flow->tun_mask.u.ipv4.src = match.mask->src;
+	} else if (flow_rule_match_key(rule,
 				      FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS)) {
 		return -EOPNOTSUPP;
 	}
 
-	if (dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
-		struct flow_dissector_key_keyid *key =
-			GET_KEY(tc_flow_cmd, FLOW_DISSECTOR_KEY_ENC_KEYID);
-		struct flow_dissector_key_keyid *mask =
-			GET_MASK(tc_flow_cmd, FLOW_DISSECTOR_KEY_ENC_KEYID);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
+		struct flow_match_enc_keyid match;
 
+		flow_rule_match_enc_keyid(rule, &match);
 		flow->flags |= BNXT_TC_FLOW_FLAGS_TUNL_ID;
-		flow->tun_key.tun_id = key32_to_tunnel_id(key->keyid);
-		flow->tun_mask.tun_id = key32_to_tunnel_id(mask->keyid);
+		flow->tun_key.tun_id = key32_to_tunnel_id(match.key->keyid);
+		flow->tun_mask.tun_id = key32_to_tunnel_id(match.mask->keyid);
 	}
 
-	if (dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_ENC_PORTS)) {
-		struct flow_dissector_key_ports *key =
-			GET_KEY(tc_flow_cmd, FLOW_DISSECTOR_KEY_ENC_PORTS);
-		struct flow_dissector_key_ports *mask =
-			GET_MASK(tc_flow_cmd, FLOW_DISSECTOR_KEY_ENC_PORTS);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_PORTS)) {
+		struct flow_match_ports match;
 
+		flow_rule_match_enc_ports(rule, &match);
 		flow->flags |= BNXT_TC_FLOW_FLAGS_TUNL_PORTS;
-		flow->tun_key.tp_dst = key->dst;
-		flow->tun_mask.tp_dst = mask->dst;
-		flow->tun_key.tp_src = key->src;
-		flow->tun_mask.tp_src = mask->src;
+		flow->tun_key.tp_dst = match.key->dst;
+		flow->tun_mask.tp_dst = match.mask->dst;
+		flow->tun_key.tp_src = match.key->src;
+		flow->tun_mask.tp_src = match.mask->src;
 	}
 
 	return bnxt_tc_parse_actions(bp, &flow->actions, tc_flow_cmd->exts);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index c116f96956fe..39c5af5dad3d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -83,28 +83,23 @@ static void cxgb4_process_flow_match(struct net_device *dev,
 				     struct tc_cls_flower_offload *cls,
 				     struct ch_filter_specification *fs)
 {
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(cls);
 	u16 addr_type = 0;
 
-	if (dissector_uses_key(cls->dissector, FLOW_DISSECTOR_KEY_CONTROL)) {
-		struct flow_dissector_key_control *key =
-			skb_flow_dissector_target(cls->dissector,
-						  FLOW_DISSECTOR_KEY_CONTROL,
-						  cls->key);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
+		struct flow_match_control match;
 
-		addr_type = key->addr_type;
+		flow_rule_match_control(rule, &match);
+		addr_type = match.key->addr_type;
 	}
 
-	if (dissector_uses_key(cls->dissector, FLOW_DISSECTOR_KEY_BASIC)) {
-		struct flow_dissector_key_basic *key =
-			skb_flow_dissector_target(cls->dissector,
-						  FLOW_DISSECTOR_KEY_BASIC,
-						  cls->key);
-		struct flow_dissector_key_basic *mask =
-			skb_flow_dissector_target(cls->dissector,
-						  FLOW_DISSECTOR_KEY_BASIC,
-						  cls->mask);
-		u16 ethtype_key = ntohs(key->n_proto);
-		u16 ethtype_mask = ntohs(mask->n_proto);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
+		u16 ethtype_key, ethtype_mask;
+
+		flow_rule_match_basic(rule, &match);
+		ethtype_key = ntohs(match.key->n_proto);
+		ethtype_mask = ntohs(match.mask->n_proto);
 
 		if (ethtype_key == ETH_P_ALL) {
 			ethtype_key = 0;
@@ -116,115 +111,89 @@ static void cxgb4_process_flow_match(struct net_device *dev,
 
 		fs->val.ethtype = ethtype_key;
 		fs->mask.ethtype = ethtype_mask;
-		fs->val.proto = key->ip_proto;
-		fs->mask.proto = mask->ip_proto;
+		fs->val.proto = match.key->ip_proto;
+		fs->mask.proto = match.mask->ip_proto;
 	}
 
 	if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
-		struct flow_dissector_key_ipv4_addrs *key =
-			skb_flow_dissector_target(cls->dissector,
-						  FLOW_DISSECTOR_KEY_IPV4_ADDRS,
-						  cls->key);
-		struct flow_dissector_key_ipv4_addrs *mask =
-			skb_flow_dissector_target(cls->dissector,
-						  FLOW_DISSECTOR_KEY_IPV4_ADDRS,
-						  cls->mask);
+		struct flow_match_ipv4_addrs match;
+
+		flow_rule_match_ipv4_addrs(rule, &match);
 		fs->type = 0;
-		memcpy(&fs->val.lip[0], &key->dst, sizeof(key->dst));
-		memcpy(&fs->val.fip[0], &key->src, sizeof(key->src));
-		memcpy(&fs->mask.lip[0], &mask->dst, sizeof(mask->dst));
-		memcpy(&fs->mask.fip[0], &mask->src, sizeof(mask->src));
+		memcpy(&fs->val.lip[0], &match.key->dst, sizeof(match.key->dst));
+		memcpy(&fs->val.fip[0], &match.key->src, sizeof(match.key->src));
+		memcpy(&fs->mask.lip[0], &match.mask->dst, sizeof(match.mask->dst));
+		memcpy(&fs->mask.fip[0], &match.mask->src, sizeof(match.mask->src));
 
 		/* also initialize nat_lip/fip to same values */
-		memcpy(&fs->nat_lip[0], &key->dst, sizeof(key->dst));
-		memcpy(&fs->nat_fip[0], &key->src, sizeof(key->src));
-
+		memcpy(&fs->nat_lip[0], &match.key->dst, sizeof(match.key->dst));
+		memcpy(&fs->nat_fip[0], &match.key->src, sizeof(match.key->src));
 	}
 
 	if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
-		struct flow_dissector_key_ipv6_addrs *key =
-			skb_flow_dissector_target(cls->dissector,
-						  FLOW_DISSECTOR_KEY_IPV6_ADDRS,
-						  cls->key);
-		struct flow_dissector_key_ipv6_addrs *mask =
-			skb_flow_dissector_target(cls->dissector,
-						  FLOW_DISSECTOR_KEY_IPV6_ADDRS,
-						  cls->mask);
+		struct flow_match_ipv6_addrs match;
 
+		flow_rule_match_ipv6_addrs(rule, &match);
 		fs->type = 1;
-		memcpy(&fs->val.lip[0], key->dst.s6_addr, sizeof(key->dst));
-		memcpy(&fs->val.fip[0], key->src.s6_addr, sizeof(key->src));
-		memcpy(&fs->mask.lip[0], mask->dst.s6_addr, sizeof(mask->dst));
-		memcpy(&fs->mask.fip[0], mask->src.s6_addr, sizeof(mask->src));
+		memcpy(&fs->val.lip[0], match.key->dst.s6_addr,
+		       sizeof(match.key->dst));
+		memcpy(&fs->val.fip[0], match.key->src.s6_addr,
+		       sizeof(match.key->src));
+		memcpy(&fs->mask.lip[0], match.mask->dst.s6_addr,
+		       sizeof(match.mask->dst));
+		memcpy(&fs->mask.fip[0], match.mask->src.s6_addr,
+		       sizeof(match.mask->src));
 
 		/* also initialize nat_lip/fip to same values */
-		memcpy(&fs->nat_lip[0], key->dst.s6_addr, sizeof(key->dst));
-		memcpy(&fs->nat_fip[0], key->src.s6_addr, sizeof(key->src));
+		memcpy(&fs->nat_lip[0], match.key->dst.s6_addr,
+		       sizeof(match.key->dst));
+		memcpy(&fs->nat_fip[0], match.key->src.s6_addr,
+		       sizeof(match.key->src));
 	}
 
-	if (dissector_uses_key(cls->dissector, FLOW_DISSECTOR_KEY_PORTS)) {
-		struct flow_dissector_key_ports *key, *mask;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports match;
 
-		key = skb_flow_dissector_target(cls->dissector,
-						FLOW_DISSECTOR_KEY_PORTS,
-						cls->key);
-		mask = skb_flow_dissector_target(cls->dissector,
-						 FLOW_DISSECTOR_KEY_PORTS,
-						 cls->mask);
-		fs->val.lport = cpu_to_be16(key->dst);
-		fs->mask.lport = cpu_to_be16(mask->dst);
-		fs->val.fport = cpu_to_be16(key->src);
-		fs->mask.fport = cpu_to_be16(mask->src);
+		flow_rule_match_ports(rule, &match);
+		fs->val.lport = cpu_to_be16(match.key->dst);
+		fs->mask.lport = cpu_to_be16(match.mask->dst);
+		fs->val.fport = cpu_to_be16(match.key->src);
+		fs->mask.fport = cpu_to_be16(match.mask->src);
 
 		/* also initialize nat_lport/fport to same values */
-		fs->nat_lport = cpu_to_be16(key->dst);
-		fs->nat_fport = cpu_to_be16(key->src);
+		fs->nat_lport = cpu_to_be16(match.key->dst);
+		fs->nat_fport = cpu_to_be16(match.key->src);
 	}
 
-	if (dissector_uses_key(cls->dissector, FLOW_DISSECTOR_KEY_IP)) {
-		struct flow_dissector_key_ip *key, *mask;
-
-		key = skb_flow_dissector_target(cls->dissector,
-						FLOW_DISSECTOR_KEY_IP,
-						cls->key);
-		mask = skb_flow_dissector_target(cls->dissector,
-						 FLOW_DISSECTOR_KEY_IP,
-						 cls->mask);
-		fs->val.tos = key->tos;
-		fs->mask.tos = mask->tos;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP)) {
+		struct flow_match_ip match;
+
+		flow_rule_match_ip(rule, &match);
+		fs->val.tos = match.key->tos;
+		fs->mask.tos = match.mask->tos;
 	}
 
-	if (dissector_uses_key(cls->dissector, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
-		struct flow_dissector_key_keyid *key, *mask;
-
-		key = skb_flow_dissector_target(cls->dissector,
-						FLOW_DISSECTOR_KEY_ENC_KEYID,
-						cls->key);
-		mask = skb_flow_dissector_target(cls->dissector,
-						 FLOW_DISSECTOR_KEY_ENC_KEYID,
-						 cls->mask);
-		fs->val.vni = be32_to_cpu(key->keyid);
-		fs->mask.vni = be32_to_cpu(mask->keyid);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
+		struct flow_match_enc_keyid match;
+
+		flow_rule_match_enc_keyid(rule, &match);
+		fs->val.vni = be32_to_cpu(match.key->keyid);
+		fs->mask.vni = be32_to_cpu(match.mask->keyid);
 		if (fs->mask.vni) {
 			fs->val.encap_vld = 1;
 			fs->mask.encap_vld = 1;
 		}
 	}
 
-	if (dissector_uses_key(cls->dissector, FLOW_DISSECTOR_KEY_VLAN)) {
-		struct flow_dissector_key_vlan *key, *mask;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
 		u16 vlan_tci, vlan_tci_mask;
 
-		key = skb_flow_dissector_target(cls->dissector,
-						FLOW_DISSECTOR_KEY_VLAN,
-						cls->key);
-		mask = skb_flow_dissector_target(cls->dissector,
-						 FLOW_DISSECTOR_KEY_VLAN,
-						 cls->mask);
-		vlan_tci = key->vlan_id | (key->vlan_priority <<
-					   VLAN_PRIO_SHIFT);
-		vlan_tci_mask = mask->vlan_id | (mask->vlan_priority <<
-						 VLAN_PRIO_SHIFT);
+		flow_rule_match_vlan(rule, &match);
+		vlan_tci = match.key->vlan_id | (match.key->vlan_priority <<
+					       VLAN_PRIO_SHIFT);
+		vlan_tci_mask = match.mask->vlan_id | (match.mask->vlan_priority <<
+						     VLAN_PRIO_SHIFT);
 		fs->val.ivlan = vlan_tci;
 		fs->mask.ivlan = vlan_tci_mask;
 
@@ -255,10 +224,12 @@ static void cxgb4_process_flow_match(struct net_device *dev,
 static int cxgb4_validate_flow_match(struct net_device *dev,
 				     struct tc_cls_flower_offload *cls)
 {
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(cls);
+	struct flow_dissector *dissector = rule->match.dissector;
 	u16 ethtype_mask = 0;
 	u16 ethtype_key = 0;
 
-	if (cls->dissector->used_keys &
+	if (dissector->used_keys &
 	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
 	      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
@@ -268,36 +239,29 @@ static int cxgb4_validate_flow_match(struct net_device *dev,
 	      BIT(FLOW_DISSECTOR_KEY_VLAN) |
 	      BIT(FLOW_DISSECTOR_KEY_IP))) {
 		netdev_warn(dev, "Unsupported key used: 0x%x\n",
-			    cls->dissector->used_keys);
+			    dissector->used_keys);
 		return -EOPNOTSUPP;
 	}
 
-	if (dissector_uses_key(cls->dissector, FLOW_DISSECTOR_KEY_BASIC)) {
-		struct flow_dissector_key_basic *key =
-			skb_flow_dissector_target(cls->dissector,
-						  FLOW_DISSECTOR_KEY_BASIC,
-						  cls->key);
-		struct flow_dissector_key_basic *mask =
-			skb_flow_dissector_target(cls->dissector,
-						  FLOW_DISSECTOR_KEY_BASIC,
-						  cls->mask);
-		ethtype_key = ntohs(key->n_proto);
-		ethtype_mask = ntohs(mask->n_proto);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
+
+		flow_rule_match_basic(rule, &match);
+		ethtype_key = ntohs(match.key->n_proto);
+		ethtype_mask = ntohs(match.mask->n_proto);
 	}
 
-	if (dissector_uses_key(cls->dissector, FLOW_DISSECTOR_KEY_IP)) {
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP)) {
 		u16 eth_ip_type = ethtype_key & ethtype_mask;
-		struct flow_dissector_key_ip *mask;
+		struct flow_match_ip match;
 
 		if (eth_ip_type != ETH_P_IP && eth_ip_type != ETH_P_IPV6) {
 			netdev_err(dev, "IP Key supported only with IPv4/v6");
 			return -EINVAL;
 		}
 
-		mask = skb_flow_dissector_target(cls->dissector,
-						 FLOW_DISSECTOR_KEY_IP,
-						 cls->mask);
-		if (mask->ttl) {
+		flow_rule_match_ip(rule, &match);
+		if (match.mask->ttl) {
 			netdev_warn(dev, "ttl match unsupported for offload");
 			return -EOPNOTSUPP;
 		}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5c6731b97059..44856a84738d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7169,11 +7169,13 @@ static int i40e_parse_cls_flower(struct i40e_vsi *vsi,
 				 struct tc_cls_flower_offload *f,
 				 struct i40e_cloud_filter *filter)
 {
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_dissector *dissector = rule->match.dissector;
 	u16 n_proto_mask = 0, n_proto_key = 0, addr_type = 0;
 	struct i40e_pf *pf = vsi->back;
 	u8 field_flags = 0;
 
-	if (f->dissector->used_keys &
+	if (dissector->used_keys &
 	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
 	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
@@ -7183,143 +7185,109 @@ static int i40e_parse_cls_flower(struct i40e_vsi *vsi,
 	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_KEYID))) {
 		dev_err(&pf->pdev->dev, "Unsupported key used: 0x%x\n",
-			f->dissector->used_keys);
+			dissector->used_keys);
 		return -EOPNOTSUPP;
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
-		struct flow_dissector_key_keyid *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ENC_KEYID,
-						  f->key);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
+		struct flow_match_enc_keyid match;
 
-		struct flow_dissector_key_keyid *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ENC_KEYID,
-						  f->mask);
-
-		if (mask->keyid != 0)
+		flow_rule_match_enc_keyid(rule, &match);
+		if (match.mask->keyid != 0)
 			field_flags |= I40E_CLOUD_FIELD_TEN_ID;
 
-		filter->tenant_id = be32_to_cpu(key->keyid);
+		filter->tenant_id = be32_to_cpu(match.key->keyid);
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_BASIC)) {
-		struct flow_dissector_key_basic *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_BASIC,
-						  f->key);
-
-		struct flow_dissector_key_basic *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_BASIC,
-						  f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
 
-		n_proto_key = ntohs(key->n_proto);
-		n_proto_mask = ntohs(mask->n_proto);
+		flow_rule_match_basic(rule, &match);
+		n_proto_key = ntohs(match.key->n_proto);
+		n_proto_mask = ntohs(match.mask->n_proto);
 
 		if (n_proto_key == ETH_P_ALL) {
 			n_proto_key = 0;
 			n_proto_mask = 0;
 		}
 		filter->n_proto = n_proto_key & n_proto_mask;
-		filter->ip_proto = key->ip_proto;
+		filter->ip_proto = match.key->ip_proto;
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
-		struct flow_dissector_key_eth_addrs *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ETH_ADDRS,
-						  f->key);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		struct flow_match_eth_addrs match;
 
-		struct flow_dissector_key_eth_addrs *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ETH_ADDRS,
-						  f->mask);
+		flow_rule_match_eth_addrs(rule, &match);
 
 		/* use is_broadcast and is_zero to check for all 0xf or 0 */
-		if (!is_zero_ether_addr(mask->dst)) {
-			if (is_broadcast_ether_addr(mask->dst)) {
+		if (!is_zero_ether_addr(match.mask->dst)) {
+			if (is_broadcast_ether_addr(match.mask->dst)) {
 				field_flags |= I40E_CLOUD_FIELD_OMAC;
 			} else {
 				dev_err(&pf->pdev->dev, "Bad ether dest mask %pM\n",
-					mask->dst);
+					match.mask->dst);
 				return I40E_ERR_CONFIG;
 			}
 		}
 
-		if (!is_zero_ether_addr(mask->src)) {
-			if (is_broadcast_ether_addr(mask->src)) {
+		if (!is_zero_ether_addr(match.mask->src)) {
+			if (is_broadcast_ether_addr(match.mask->src)) {
 				field_flags |= I40E_CLOUD_FIELD_IMAC;
 			} else {
 				dev_err(&pf->pdev->dev, "Bad ether src mask %pM\n",
-					mask->src);
+					match.mask->src);
 				return I40E_ERR_CONFIG;
 			}
 		}
-		ether_addr_copy(filter->dst_mac, key->dst);
-		ether_addr_copy(filter->src_mac, key->src);
+		ether_addr_copy(filter->dst_mac, match.key->dst);
+		ether_addr_copy(filter->src_mac, match.key->src);
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_VLAN)) {
-		struct flow_dissector_key_vlan *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_VLAN,
-						  f->key);
-		struct flow_dissector_key_vlan *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_VLAN,
-						  f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
 
-		if (mask->vlan_id) {
-			if (mask->vlan_id == VLAN_VID_MASK) {
+		flow_rule_match_vlan(rule, &match);
+		if (match.mask->vlan_id) {
+			if (match.mask->vlan_id == VLAN_VID_MASK) {
 				field_flags |= I40E_CLOUD_FIELD_IVLAN;
 
 			} else {
 				dev_err(&pf->pdev->dev, "Bad vlan mask 0x%04x\n",
-					mask->vlan_id);
+					match.mask->vlan_id);
 				return I40E_ERR_CONFIG;
 			}
 		}
 
-		filter->vlan_id = cpu_to_be16(key->vlan_id);
+		filter->vlan_id = cpu_to_be16(match.key->vlan_id);
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_CONTROL)) {
-		struct flow_dissector_key_control *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_CONTROL,
-						  f->key);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
+		struct flow_match_control match;
 
-		addr_type = key->addr_type;
+		flow_rule_match_control(rule, &match);
+		addr_type = match.key->addr_type;
 	}
 
 	if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
-		struct flow_dissector_key_ipv4_addrs *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_IPV4_ADDRS,
-						  f->key);
-		struct flow_dissector_key_ipv4_addrs *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_IPV4_ADDRS,
-						  f->mask);
-
-		if (mask->dst) {
-			if (mask->dst == cpu_to_be32(0xffffffff)) {
+		struct flow_match_ipv4_addrs match;
+
+		flow_rule_match_ipv4_addrs(rule, &match);
+		if (match.mask->dst) {
+			if (match.mask->dst == cpu_to_be32(0xffffffff)) {
 				field_flags |= I40E_CLOUD_FIELD_IIP;
 			} else {
 				dev_err(&pf->pdev->dev, "Bad ip dst mask %pI4b\n",
-					&mask->dst);
+					&match.mask->dst);
 				return I40E_ERR_CONFIG;
 			}
 		}
 
-		if (mask->src) {
-			if (mask->src == cpu_to_be32(0xffffffff)) {
+		if (match.mask->src) {
+			if (match.mask->src == cpu_to_be32(0xffffffff)) {
 				field_flags |= I40E_CLOUD_FIELD_IIP;
 			} else {
 				dev_err(&pf->pdev->dev, "Bad ip src mask %pI4b\n",
-					&mask->src);
+					&match.mask->src);
 				return I40E_ERR_CONFIG;
 			}
 		}
@@ -7328,70 +7296,60 @@ static int i40e_parse_cls_flower(struct i40e_vsi *vsi,
 			dev_err(&pf->pdev->dev, "Tenant id not allowed for ip filter\n");
 			return I40E_ERR_CONFIG;
 		}
-		filter->dst_ipv4 = key->dst;
-		filter->src_ipv4 = key->src;
+		filter->dst_ipv4 = match.key->dst;
+		filter->src_ipv4 = match.key->src;
 	}
 
 	if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
-		struct flow_dissector_key_ipv6_addrs *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_IPV6_ADDRS,
-						  f->key);
-		struct flow_dissector_key_ipv6_addrs *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_IPV6_ADDRS,
-						  f->mask);
+		struct flow_match_ipv6_addrs match;
+
+		flow_rule_match_ipv6_addrs(rule, &match);
 
 		/* src and dest IPV6 address should not be LOOPBACK
 		 * (0:0:0:0:0:0:0:1), which can be represented as ::1
 		 */
-		if (ipv6_addr_loopback(&key->dst) ||
-		    ipv6_addr_loopback(&key->src)) {
+		if (ipv6_addr_loopback(&match.key->dst) ||
+		    ipv6_addr_loopback(&match.key->src)) {
 			dev_err(&pf->pdev->dev,
 				"Bad ipv6, addr is LOOPBACK\n");
 			return I40E_ERR_CONFIG;
 		}
-		if (!ipv6_addr_any(&mask->dst) || !ipv6_addr_any(&mask->src))
+		if (!ipv6_addr_any(&match.mask->dst) ||
+		    !ipv6_addr_any(&match.mask->src))
 			field_flags |= I40E_CLOUD_FIELD_IIP;
 
-		memcpy(&filter->src_ipv6, &key->src.s6_addr32,
+		memcpy(&filter->src_ipv6, &match.key->src.s6_addr32,
 		       sizeof(filter->src_ipv6));
-		memcpy(&filter->dst_ipv6, &key->dst.s6_addr32,
+		memcpy(&filter->dst_ipv6, &match.key->dst.s6_addr32,
 		       sizeof(filter->dst_ipv6));
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_PORTS)) {
-		struct flow_dissector_key_ports *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_PORTS,
-						  f->key);
-		struct flow_dissector_key_ports *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_PORTS,
-						  f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports match;
 
-		if (mask->src) {
-			if (mask->src == cpu_to_be16(0xffff)) {
+		flow_rule_match_ports(rule, &match);
+		if (match.mask->src) {
+			if (match.mask->src == cpu_to_be16(0xffff)) {
 				field_flags |= I40E_CLOUD_FIELD_IIP;
 			} else {
 				dev_err(&pf->pdev->dev, "Bad src port mask 0x%04x\n",
-					be16_to_cpu(mask->src));
+					be16_to_cpu(match.mask->src));
 				return I40E_ERR_CONFIG;
 			}
 		}
 
-		if (mask->dst) {
-			if (mask->dst == cpu_to_be16(0xffff)) {
+		if (match.mask->dst) {
+			if (match.mask->dst == cpu_to_be16(0xffff)) {
 				field_flags |= I40E_CLOUD_FIELD_IIP;
 			} else {
 				dev_err(&pf->pdev->dev, "Bad dst port mask 0x%04x\n",
-					be16_to_cpu(mask->dst));
+					be16_to_cpu(match.mask->dst));
 				return I40E_ERR_CONFIG;
 			}
 		}
 
-		filter->dst_port = key->dst;
-		filter->src_port = key->src;
+		filter->dst_port = match.key->dst;
+		filter->src_port = match.key->src;
 
 		switch (filter->ip_proto) {
 		case IPPROTO_TCP:
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 9f2b7b7adf6b..4569d69a2b55 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2439,6 +2439,8 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 				 struct tc_cls_flower_offload *f,
 				 struct iavf_cloud_filter *filter)
 {
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_dissector *dissector = rule->match.dissector;
 	u16 n_proto_mask = 0;
 	u16 n_proto_key = 0;
 	u8 field_flags = 0;
@@ -2447,7 +2449,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 	int i = 0;
 	struct virtchnl_filter *vf = &filter->f;
 
-	if (f->dissector->used_keys &
+	if (dissector->used_keys &
 	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
 	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
@@ -2457,32 +2459,24 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_KEYID))) {
 		dev_err(&adapter->pdev->dev, "Unsupported key used: 0x%x\n",
-			f->dissector->used_keys);
+			dissector->used_keys);
 		return -EOPNOTSUPP;
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
-		struct flow_dissector_key_keyid *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ENC_KEYID,
-						  f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
+		struct flow_match_enc_keyid match;
 
-		if (mask->keyid != 0)
+		flow_rule_match_enc_keyid(rule, &match);
+		if (match.mask->keyid != 0)
 			field_flags |= IAVF_CLOUD_FIELD_TEN_ID;
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_BASIC)) {
-		struct flow_dissector_key_basic *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_BASIC,
-						  f->key);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
 
-		struct flow_dissector_key_basic *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_BASIC,
-						  f->mask);
-		n_proto_key = ntohs(key->n_proto);
-		n_proto_mask = ntohs(mask->n_proto);
+		flow_rule_match_basic(rule, &match);
+		n_proto_key = ntohs(match.key->n_proto);
+		n_proto_mask = ntohs(match.mask->n_proto);
 
 		if (n_proto_key == ETH_P_ALL) {
 			n_proto_key = 0;
@@ -2496,122 +2490,103 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			vf->flow_type = VIRTCHNL_TCP_V6_FLOW;
 		}
 
-		if (key->ip_proto != IPPROTO_TCP) {
+		if (match.key->ip_proto != IPPROTO_TCP) {
 			dev_info(&adapter->pdev->dev, "Only TCP transport is supported\n");
 			return -EINVAL;
 		}
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
-		struct flow_dissector_key_eth_addrs *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ETH_ADDRS,
-						  f->key);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		struct flow_match_eth_addrs match;
+
+		flow_rule_match_eth_addrs(rule, &match);
 
-		struct flow_dissector_key_eth_addrs *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ETH_ADDRS,
-						  f->mask);
 		/* use is_broadcast and is_zero to check for all 0xf or 0 */
-		if (!is_zero_ether_addr(mask->dst)) {
-			if (is_broadcast_ether_addr(mask->dst)) {
+		if (!is_zero_ether_addr(match.mask->dst)) {
+			if (is_broadcast_ether_addr(match.mask->dst)) {
 				field_flags |= IAVF_CLOUD_FIELD_OMAC;
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ether dest mask %pM\n",
-					mask->dst);
+					match.mask->dst);
 				return I40E_ERR_CONFIG;
 			}
 		}
 
-		if (!is_zero_ether_addr(mask->src)) {
-			if (is_broadcast_ether_addr(mask->src)) {
+		if (!is_zero_ether_addr(match.mask->src)) {
+			if (is_broadcast_ether_addr(match.mask->src)) {
 				field_flags |= IAVF_CLOUD_FIELD_IMAC;
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ether src mask %pM\n",
-					mask->src);
+					match.mask->src);
 				return I40E_ERR_CONFIG;
 			}
 		}
 
-		if (!is_zero_ether_addr(key->dst))
-			if (is_valid_ether_addr(key->dst) ||
-			    is_multicast_ether_addr(key->dst)) {
+		if (!is_zero_ether_addr(match.key->dst))
+			if (is_valid_ether_addr(match.key->dst) ||
+			    is_multicast_ether_addr(match.key->dst)) {
 				/* set the mask if a valid dst_mac address */
 				for (i = 0; i < ETH_ALEN; i++)
 					vf->mask.tcp_spec.dst_mac[i] |= 0xff;
 				ether_addr_copy(vf->data.tcp_spec.dst_mac,
-						key->dst);
+						match.key->dst);
 			}
 
-		if (!is_zero_ether_addr(key->src))
-			if (is_valid_ether_addr(key->src) ||
-			    is_multicast_ether_addr(key->src)) {
+		if (!is_zero_ether_addr(match.key->src))
+			if (is_valid_ether_addr(match.key->src) ||
+			    is_multicast_ether_addr(match.key->src)) {
 				/* set the mask if a valid dst_mac address */
 				for (i = 0; i < ETH_ALEN; i++)
 					vf->mask.tcp_spec.src_mac[i] |= 0xff;
 				ether_addr_copy(vf->data.tcp_spec.src_mac,
-						key->src);
+						match.key->src);
 		}
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_VLAN)) {
-		struct flow_dissector_key_vlan *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_VLAN,
-						  f->key);
-		struct flow_dissector_key_vlan *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_VLAN,
-						  f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
 
-		if (mask->vlan_id) {
-			if (mask->vlan_id == VLAN_VID_MASK) {
+		flow_rule_match_vlan(rule, &match);
+		if (match.mask->vlan_id) {
+			if (match.mask->vlan_id == VLAN_VID_MASK) {
 				field_flags |= IAVF_CLOUD_FIELD_IVLAN;
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad vlan mask %u\n",
-					mask->vlan_id);
+					match.mask->vlan_id);
 				return I40E_ERR_CONFIG;
 			}
 		}
 		vf->mask.tcp_spec.vlan_id |= cpu_to_be16(0xffff);
-		vf->data.tcp_spec.vlan_id = cpu_to_be16(key->vlan_id);
+		vf->data.tcp_spec.vlan_id = cpu_to_be16(match.key->vlan_id);
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_CONTROL)) {
-		struct flow_dissector_key_control *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_CONTROL,
-						  f->key);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
+		struct flow_match_control match;
 
-		addr_type = key->addr_type;
+		flow_rule_match_control(rule, &match);
+		addr_type = match.key->addr_type;
 	}
 
 	if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
-		struct flow_dissector_key_ipv4_addrs *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_IPV4_ADDRS,
-						  f->key);
-		struct flow_dissector_key_ipv4_addrs *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_IPV4_ADDRS,
-						  f->mask);
-
-		if (mask->dst) {
-			if (mask->dst == cpu_to_be32(0xffffffff)) {
+		struct flow_match_ipv4_addrs match;
+
+		flow_rule_match_ipv4_addrs(rule, &match);
+		if (match.mask->dst) {
+			if (match.mask->dst == cpu_to_be32(0xffffffff)) {
 				field_flags |= IAVF_CLOUD_FIELD_IIP;
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ip dst mask 0x%08x\n",
-					be32_to_cpu(mask->dst));
+					be32_to_cpu(match.mask->dst));
 				return I40E_ERR_CONFIG;
 			}
 		}
 
-		if (mask->src) {
-			if (mask->src == cpu_to_be32(0xffffffff)) {
+		if (match.mask->src) {
+			if (match.mask->src == cpu_to_be32(0xffffffff)) {
 				field_flags |= IAVF_CLOUD_FIELD_IIP;
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ip src mask 0x%08x\n",
-					be32_to_cpu(mask->dst));
+					be32_to_cpu(match.mask->dst));
 				return I40E_ERR_CONFIG;
 			}
 		}
@@ -2620,28 +2595,23 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			dev_info(&adapter->pdev->dev, "Tenant id not allowed for ip filter\n");
 			return I40E_ERR_CONFIG;
 		}
-		if (key->dst) {
+		if (match.key->dst) {
 			vf->mask.tcp_spec.dst_ip[0] |= cpu_to_be32(0xffffffff);
-			vf->data.tcp_spec.dst_ip[0] = key->dst;
+			vf->data.tcp_spec.dst_ip[0] = match.key->dst;
 		}
-		if (key->src) {
+		if (match.key->src) {
 			vf->mask.tcp_spec.src_ip[0] |= cpu_to_be32(0xffffffff);
-			vf->data.tcp_spec.src_ip[0] = key->src;
+			vf->data.tcp_spec.src_ip[0] = match.key->src;
 		}
 	}
 
 	if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
-		struct flow_dissector_key_ipv6_addrs *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_IPV6_ADDRS,
-						  f->key);
-		struct flow_dissector_key_ipv6_addrs *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_IPV6_ADDRS,
-						  f->mask);
+		struct flow_match_ipv6_addrs match;
+
+		flow_rule_match_ipv6_addrs(rule, &match);
 
 		/* validate mask, make sure it is not IPV6_ADDR_ANY */
-		if (ipv6_addr_any(&mask->dst)) {
+		if (ipv6_addr_any(&match.mask->dst)) {
 			dev_err(&adapter->pdev->dev, "Bad ipv6 dst mask 0x%02x\n",
 				IPV6_ADDR_ANY);
 			return I40E_ERR_CONFIG;
@@ -2650,61 +2620,56 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 		/* src and dest IPv6 address should not be LOOPBACK
 		 * (0:0:0:0:0:0:0:1) which can be represented as ::1
 		 */
-		if (ipv6_addr_loopback(&key->dst) ||
-		    ipv6_addr_loopback(&key->src)) {
+		if (ipv6_addr_loopback(&match.key->dst) ||
+		    ipv6_addr_loopback(&match.key->src)) {
 			dev_err(&adapter->pdev->dev,
 				"ipv6 addr should not be loopback\n");
 			return I40E_ERR_CONFIG;
 		}
-		if (!ipv6_addr_any(&mask->dst) || !ipv6_addr_any(&mask->src))
+		if (!ipv6_addr_any(&match.mask->dst) ||
+		    !ipv6_addr_any(&match.mask->src))
 			field_flags |= IAVF_CLOUD_FIELD_IIP;
 
 		for (i = 0; i < 4; i++)
 			vf->mask.tcp_spec.dst_ip[i] |= cpu_to_be32(0xffffffff);
-		memcpy(&vf->data.tcp_spec.dst_ip, &key->dst.s6_addr32,
+		memcpy(&vf->data.tcp_spec.dst_ip, &match.key->dst.s6_addr32,
 		       sizeof(vf->data.tcp_spec.dst_ip));
 		for (i = 0; i < 4; i++)
 			vf->mask.tcp_spec.src_ip[i] |= cpu_to_be32(0xffffffff);
-		memcpy(&vf->data.tcp_spec.src_ip, &key->src.s6_addr32,
+		memcpy(&vf->data.tcp_spec.src_ip, &match.key->src.s6_addr32,
 		       sizeof(vf->data.tcp_spec.src_ip));
 	}
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_PORTS)) {
-		struct flow_dissector_key_ports *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_PORTS,
-						  f->key);
-		struct flow_dissector_key_ports *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_PORTS,
-						  f->mask);
-
-		if (mask->src) {
-			if (mask->src == cpu_to_be16(0xffff)) {
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports match;
+
+		flow_rule_match_ports(rule, &match);
+		if (match.mask->src) {
+			if (match.mask->src == cpu_to_be16(0xffff)) {
 				field_flags |= IAVF_CLOUD_FIELD_IIP;
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad src port mask %u\n",
-					be16_to_cpu(mask->src));
+					be16_to_cpu(match.mask->src));
 				return I40E_ERR_CONFIG;
 			}
 		}
 
-		if (mask->dst) {
-			if (mask->dst == cpu_to_be16(0xffff)) {
+		if (match.mask->dst) {
+			if (match.mask->dst == cpu_to_be16(0xffff)) {
 				field_flags |= IAVF_CLOUD_FIELD_IIP;
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad dst port mask %u\n",
-					be16_to_cpu(mask->dst));
+					be16_to_cpu(match.mask->dst));
 				return I40E_ERR_CONFIG;
 			}
 		}
-		if (key->dst) {
+		if (match.key->dst) {
 			vf->mask.tcp_spec.dst_port |= cpu_to_be16(0xffff);
-			vf->data.tcp_spec.dst_port = key->dst;
+			vf->data.tcp_spec.dst_port = match.key->dst;
 		}
 
-		if (key->src) {
+		if (match.key->src) {
 			vf->mask.tcp_spec.src_port |= cpu_to_be16(0xffff);
-			vf->data.tcp_spec.src_port = key->src;
+			vf->data.tcp_spec.src_port = match.key->src;
 		}
 	}
 	vf->field_flags = field_flags;
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index dfa357b1a9d6..c6ae206b6892 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2581,9 +2581,11 @@ static int igb_parse_cls_flower(struct igb_adapter *adapter,
 				int traffic_class,
 				struct igb_nfc_filter *input)
 {
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_dissector *dissector = rule->match.dissector;
 	struct netlink_ext_ack *extack = f->common.extack;
 
-	if (f->dissector->used_keys &
+	if (dissector->used_keys &
 	    ~(BIT(FLOW_DISSECTOR_KEY_BASIC) |
 	      BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
@@ -2593,78 +2595,60 @@ static int igb_parse_cls_flower(struct igb_adapter *adapter,
 		return -EOPNOTSUPP;
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
-		struct flow_dissector_key_eth_addrs *key, *mask;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		struct flow_match_eth_addrs match;
 
-		key = skb_flow_dissector_target(f->dissector,
-						FLOW_DISSECTOR_KEY_ETH_ADDRS,
-						f->key);
-		mask = skb_flow_dissector_target(f->dissector,
-						 FLOW_DISSECTOR_KEY_ETH_ADDRS,
-						 f->mask);
-
-		if (!is_zero_ether_addr(mask->dst)) {
-			if (!is_broadcast_ether_addr(mask->dst)) {
+		flow_rule_match_eth_addrs(rule, &match);
+		if (!is_zero_ether_addr(match.mask->dst)) {
+			if (!is_broadcast_ether_addr(match.mask->dst)) {
 				NL_SET_ERR_MSG_MOD(extack, "Only full masks are supported for destination MAC address");
 				return -EINVAL;
 			}
 
 			input->filter.match_flags |=
 				IGB_FILTER_FLAG_DST_MAC_ADDR;
-			ether_addr_copy(input->filter.dst_addr, key->dst);
+			ether_addr_copy(input->filter.dst_addr, match.key->dst);
 		}
 
-		if (!is_zero_ether_addr(mask->src)) {
-			if (!is_broadcast_ether_addr(mask->src)) {
+		if (!is_zero_ether_addr(match.mask->src)) {
+			if (!is_broadcast_ether_addr(match.mask->src)) {
 				NL_SET_ERR_MSG_MOD(extack, "Only full masks are supported for source MAC address");
 				return -EINVAL;
 			}
 
 			input->filter.match_flags |=
 				IGB_FILTER_FLAG_SRC_MAC_ADDR;
-			ether_addr_copy(input->filter.src_addr, key->src);
+			ether_addr_copy(input->filter.src_addr, match.key->src);
 		}
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_BASIC)) {
-		struct flow_dissector_key_basic *key, *mask;
-
-		key = skb_flow_dissector_target(f->dissector,
-						FLOW_DISSECTOR_KEY_BASIC,
-						f->key);
-		mask = skb_flow_dissector_target(f->dissector,
-						 FLOW_DISSECTOR_KEY_BASIC,
-						 f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
 
-		if (mask->n_proto) {
-			if (mask->n_proto != ETHER_TYPE_FULL_MASK) {
+		flow_rule_match_basic(rule, &match);
+		if (match.mask->n_proto) {
+			if (match.mask->n_proto != ETHER_TYPE_FULL_MASK) {
 				NL_SET_ERR_MSG_MOD(extack, "Only full mask is supported for EtherType filter");
 				return -EINVAL;
 			}
 
 			input->filter.match_flags |= IGB_FILTER_FLAG_ETHER_TYPE;
-			input->filter.etype = key->n_proto;
+			input->filter.etype = match.key->n_proto;
 		}
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_VLAN)) {
-		struct flow_dissector_key_vlan *key, *mask;
-
-		key = skb_flow_dissector_target(f->dissector,
-						FLOW_DISSECTOR_KEY_VLAN,
-						f->key);
-		mask = skb_flow_dissector_target(f->dissector,
-						 FLOW_DISSECTOR_KEY_VLAN,
-						 f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
 
-		if (mask->vlan_priority) {
-			if (mask->vlan_priority != VLAN_PRIO_FULL_MASK) {
+		flow_rule_match_vlan(rule, &match);
+		if (match.mask->vlan_priority) {
+			if (match.mask->vlan_priority != VLAN_PRIO_FULL_MASK) {
 				NL_SET_ERR_MSG_MOD(extack, "Only full mask is supported for VLAN priority");
 				return -EINVAL;
 			}
 
 			input->filter.match_flags |= IGB_FILTER_FLAG_VLAN_TCI;
-			input->filter.vlan_tci = key->vlan_priority;
+			input->filter.vlan_tci = match.key->vlan_priority;
 		}
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 046948ead152..47bb4eb894c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -496,25 +496,21 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
 				    void *headers_c,
 				    void *headers_v)
 {
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
 	struct netlink_ext_ack *extack = f->common.extack;
-	struct flow_dissector_key_ports *key =
-		skb_flow_dissector_target(f->dissector,
-					  FLOW_DISSECTOR_KEY_ENC_PORTS,
-					  f->key);
-	struct flow_dissector_key_ports *mask =
-		skb_flow_dissector_target(f->dissector,
-					  FLOW_DISSECTOR_KEY_ENC_PORTS,
-					  f->mask);
 	void *misc_c = MLX5_ADDR_OF(fte_match_param,
 				    spec->match_criteria,
 				    misc_parameters);
 	void *misc_v = MLX5_ADDR_OF(fte_match_param,
 				    spec->match_value,
 				    misc_parameters);
+	struct flow_match_ports enc_ports;
+
+	flow_rule_match_enc_ports(rule, &enc_ports);
 
 	/* Full udp dst port must be given */
-	if (!dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_ENC_PORTS) ||
-	    memchr_inv(&mask->dst, 0xff, sizeof(mask->dst))) {
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_PORTS) ||
+	    memchr_inv(&enc_ports.mask->dst, 0xff, sizeof(enc_ports.mask->dst))) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "VXLAN decap filter must include enc_dst_port condition");
 		netdev_warn(priv->netdev,
@@ -523,12 +519,12 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
 	}
 
 	/* udp dst port must be knonwn as a VXLAN port */
-	if (!mlx5_vxlan_lookup_port(priv->mdev->vxlan, be16_to_cpu(key->dst))) {
+	if (!mlx5_vxlan_lookup_port(priv->mdev->vxlan, be16_to_cpu(enc_ports.key->dst))) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Matched UDP port is not registered as a VXLAN port");
 		netdev_warn(priv->netdev,
 			    "UDP port %d is not registered as a VXLAN port\n",
-			    be16_to_cpu(key->dst));
+			    be16_to_cpu(enc_ports.key->dst));
 		return -EOPNOTSUPP;
 	}
 
@@ -536,26 +532,26 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
 	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, ip_protocol);
 	MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_protocol, IPPROTO_UDP);
 
-	MLX5_SET(fte_match_set_lyr_2_4, headers_c, udp_dport, ntohs(mask->dst));
-	MLX5_SET(fte_match_set_lyr_2_4, headers_v, udp_dport, ntohs(key->dst));
+	MLX5_SET(fte_match_set_lyr_2_4, headers_c, udp_dport,
+		 ntohs(enc_ports.mask->dst));
+	MLX5_SET(fte_match_set_lyr_2_4, headers_v, udp_dport,
+		 ntohs(enc_ports.key->dst));
 
-	MLX5_SET(fte_match_set_lyr_2_4, headers_c, udp_sport, ntohs(mask->src));
-	MLX5_SET(fte_match_set_lyr_2_4, headers_v, udp_sport, ntohs(key->src));
+	MLX5_SET(fte_match_set_lyr_2_4, headers_c, udp_sport,
+		 ntohs(enc_ports.mask->src));
+	MLX5_SET(fte_match_set_lyr_2_4, headers_v, udp_sport,
+		 ntohs(enc_ports.key->src));
 
 	/* match on VNI */
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
-		struct flow_dissector_key_keyid *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ENC_KEYID,
-						  f->key);
-		struct flow_dissector_key_keyid *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ENC_KEYID,
-						  f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
+		struct flow_match_enc_keyid enc_keyid;
+
+		flow_rule_match_enc_keyid(rule, &enc_keyid);
+
 		MLX5_SET(fte_match_set_misc, misc_c, vxlan_vni,
-			 be32_to_cpu(mask->keyid));
+			 be32_to_cpu(enc_keyid.mask->keyid));
 		MLX5_SET(fte_match_set_misc, misc_v, vxlan_vni,
-			 be32_to_cpu(key->keyid));
+			 be32_to_cpu(enc_keyid.key->keyid));
 	}
 	return 0;
 }
@@ -570,6 +566,7 @@ static int mlx5e_tc_tun_parse_gretap(struct mlx5e_priv *priv,
 				    misc_parameters);
 	void *misc_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
 				    misc_parameters);
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
 
 	if (!MLX5_CAP_ESW(priv->mdev, nvgre_encap_decap)) {
 		NL_SET_ERR_MSG_MOD(f->common.extack,
@@ -587,21 +584,14 @@ static int mlx5e_tc_tun_parse_gretap(struct mlx5e_priv *priv,
 	MLX5_SET(fte_match_set_misc, misc_v, gre_protocol, ETH_P_TEB);
 
 	/* gre key */
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
-		struct flow_dissector_key_keyid *mask = NULL;
-		struct flow_dissector_key_keyid *key = NULL;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
+		struct flow_match_enc_keyid enc_keyid;
 
-		mask = skb_flow_dissector_target(f->dissector,
-						 FLOW_DISSECTOR_KEY_ENC_KEYID,
-						 f->mask);
+		flow_rule_match_enc_keyid(rule, &enc_keyid);
 		MLX5_SET(fte_match_set_misc, misc_c,
-			 gre_key.key, be32_to_cpu(mask->keyid));
-
-		key = skb_flow_dissector_target(f->dissector,
-						FLOW_DISSECTOR_KEY_ENC_KEYID,
-						f->key);
+			 gre_key.key, be32_to_cpu(enc_keyid.mask->keyid));
 		MLX5_SET(fte_match_set_misc, misc_v,
-			 gre_key.key, be32_to_cpu(key->keyid));
+			 gre_key.key, be32_to_cpu(enc_keyid.key->keyid));
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 74159d39dd66..cd289ce0582d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1309,12 +1309,9 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 				       outer_headers);
 	void *headers_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
 				       outer_headers);
-
-	struct flow_dissector_key_control *enc_control =
-		skb_flow_dissector_target(f->dissector,
-					  FLOW_DISSECTOR_KEY_ENC_CONTROL,
-					  f->key);
-	int err = 0;
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_match_control enc_control;
+	int err;
 
 	err = mlx5e_tc_tun_parse(filter_dev, priv, spec, f,
 				 headers_c, headers_v);
@@ -1324,79 +1321,70 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 		return err;
 	}
 
-	if (enc_control->addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
-		struct flow_dissector_key_ipv4_addrs *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS,
-						  f->key);
-		struct flow_dissector_key_ipv4_addrs *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS,
-						  f->mask);
+	flow_rule_match_enc_control(rule, &enc_control);
+
+	if (enc_control.key->addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+		struct flow_match_ipv4_addrs match;
+
+		flow_rule_match_enc_ipv4_addrs(rule, &match);
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c,
 			 src_ipv4_src_ipv6.ipv4_layout.ipv4,
-			 ntohl(mask->src));
+			 ntohl(match.mask->src));
 		MLX5_SET(fte_match_set_lyr_2_4, headers_v,
 			 src_ipv4_src_ipv6.ipv4_layout.ipv4,
-			 ntohl(key->src));
+			 ntohl(match.key->src));
 
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c,
 			 dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
-			 ntohl(mask->dst));
+			 ntohl(match.mask->dst));
 		MLX5_SET(fte_match_set_lyr_2_4, headers_v,
 			 dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
-			 ntohl(key->dst));
+			 ntohl(match.key->dst));
 
 		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, ethertype);
 		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype, ETH_P_IP);
-	} else if (enc_control->addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
-		struct flow_dissector_key_ipv6_addrs *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS,
-						  f->key);
-		struct flow_dissector_key_ipv6_addrs *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS,
-						  f->mask);
+	} else if (enc_control.key->addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+		struct flow_match_ipv6_addrs match;
 
+		flow_rule_match_enc_ipv6_addrs(rule, &match);
 		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
 				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
-		       &mask->src, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
+		       &match.mask->src, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
 		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
 				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
-		       &key->src, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
+		       &match.key->src, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
 
 		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
 				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       &mask->dst, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
+		       &match.mask->dst, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
 		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
 				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       &key->dst, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
+		       &match.key->dst, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
 
 		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, ethertype);
 		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype, ETH_P_IPV6);
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_ENC_IP)) {
-		struct flow_dissector_key_ip *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ENC_IP,
-						  f->key);
-		struct flow_dissector_key_ip *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ENC_IP,
-						  f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IP)) {
+		struct flow_match_ip match;
 
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_ecn, mask->tos & 0x3);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_ecn, key->tos & 0x3);
+		flow_rule_match_enc_ip(rule, &match);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_ecn,
+			 match.mask->tos & 0x3);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_ecn,
+			 match.key->tos & 0x3);
 
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_dscp, mask->tos >> 2);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_dscp, key->tos  >> 2);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_dscp,
+			 match.mask->tos >> 2);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_dscp,
+			 match.key->tos  >> 2);
 
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ttl_hoplimit, mask->ttl);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ttl_hoplimit, key->ttl);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ttl_hoplimit,
+			 match.mask->ttl);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ttl_hoplimit,
+			 match.key->ttl);
 
-		if (mask->ttl &&
+		if (match.mask->ttl &&
 		    !MLX5_CAP_ESW_FLOWTABLE_FDB
 			(priv->mdev,
 			 ft_field_support.outer_ipv4_ttl)) {
@@ -1437,12 +1425,14 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 				    misc_parameters);
 	void *misc_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
 				    misc_parameters);
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_dissector *dissector = rule->match.dissector;
 	u16 addr_type = 0;
 	u8 ip_proto = 0;
 
 	*match_level = MLX5_MATCH_NONE;
 
-	if (f->dissector->used_keys &
+	if (dissector->used_keys &
 	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
 	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
@@ -1461,20 +1451,18 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 	      BIT(FLOW_DISSECTOR_KEY_ENC_IP))) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported key");
 		netdev_warn(priv->netdev, "Unsupported key used: 0x%x\n",
-			    f->dissector->used_keys);
+			    dissector->used_keys);
 		return -EOPNOTSUPP;
 	}
 
-	if ((dissector_uses_key(f->dissector,
-				FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) ||
-	     dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_ENC_KEYID) ||
-	     dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_ENC_PORTS)) &&
-	    dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
-		struct flow_dissector_key_control *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ENC_CONTROL,
-						  f->key);
-		switch (key->addr_type) {
+	if ((flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) ||
+	     flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID) ||
+	     flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_PORTS)) &&
+	    flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
+		struct flow_match_control match;
+
+		flow_rule_match_enc_control(rule, &match);
+		switch (match.key->addr_type) {
 		case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
 		case FLOW_DISSECTOR_KEY_IPV6_ADDRS:
 			if (parse_tunnel_attr(priv, spec, f, filter_dev))
@@ -1493,35 +1481,27 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 					 inner_headers);
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_BASIC)) {
-		struct flow_dissector_key_basic *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_BASIC,
-						  f->key);
-		struct flow_dissector_key_basic *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_BASIC,
-						  f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
+
+		flow_rule_match_basic(rule, &match);
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ethertype,
-			 ntohs(mask->n_proto));
+			 ntohs(match.mask->n_proto));
 		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype,
-			 ntohs(key->n_proto));
+			 ntohs(match.key->n_proto));
 
-		if (mask->n_proto)
+		if (match.mask->n_proto)
 			*match_level = MLX5_MATCH_L2;
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_VLAN)) {
-		struct flow_dissector_key_vlan *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_VLAN,
-						  f->key);
-		struct flow_dissector_key_vlan *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_VLAN,
-						  f->mask);
-		if (mask->vlan_id || mask->vlan_priority || mask->vlan_tpid) {
-			if (key->vlan_tpid == htons(ETH_P_8021AD)) {
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
+
+		flow_rule_match_vlan(rule, &match);
+		if (match.mask->vlan_id ||
+		    match.mask->vlan_priority ||
+		    match.mask->vlan_tpid) {
+			if (match.key->vlan_tpid == htons(ETH_P_8021AD)) {
 				MLX5_SET(fte_match_set_lyr_2_4, headers_c,
 					 svlan_tag, 1);
 				MLX5_SET(fte_match_set_lyr_2_4, headers_v,
@@ -1533,11 +1513,15 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 					 cvlan_tag, 1);
 			}
 
-			MLX5_SET(fte_match_set_lyr_2_4, headers_c, first_vid, mask->vlan_id);
-			MLX5_SET(fte_match_set_lyr_2_4, headers_v, first_vid, key->vlan_id);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c, first_vid,
+				 match.mask->vlan_id);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v, first_vid,
+				 match.key->vlan_id);
 
-			MLX5_SET(fte_match_set_lyr_2_4, headers_c, first_prio, mask->vlan_priority);
-			MLX5_SET(fte_match_set_lyr_2_4, headers_v, first_prio, key->vlan_priority);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c, first_prio,
+				 match.mask->vlan_priority);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v, first_prio,
+				 match.key->vlan_priority);
 
 			*match_level = MLX5_MATCH_L2;
 		}
@@ -1547,17 +1531,14 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 		*match_level = MLX5_MATCH_L2;
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_CVLAN)) {
-		struct flow_dissector_key_vlan *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_CVLAN,
-						  f->key);
-		struct flow_dissector_key_vlan *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_CVLAN,
-						  f->mask);
-		if (mask->vlan_id || mask->vlan_priority || mask->vlan_tpid) {
-			if (key->vlan_tpid == htons(ETH_P_8021AD)) {
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CVLAN)) {
+		struct flow_match_vlan match;
+
+		flow_rule_match_vlan(rule, &match);
+		if (match.mask->vlan_id ||
+		    match.mask->vlan_priority ||
+		    match.mask->vlan_tpid) {
+			if (match.key->vlan_tpid == htons(ETH_P_8021AD)) {
 				MLX5_SET(fte_match_set_misc, misc_c,
 					 outer_second_svlan_tag, 1);
 				MLX5_SET(fte_match_set_misc, misc_v,
@@ -1570,69 +1551,58 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 			}
 
 			MLX5_SET(fte_match_set_misc, misc_c, outer_second_vid,
-				 mask->vlan_id);
+				 match.mask->vlan_id);
 			MLX5_SET(fte_match_set_misc, misc_v, outer_second_vid,
-				 key->vlan_id);
+				 match.key->vlan_id);
 			MLX5_SET(fte_match_set_misc, misc_c, outer_second_prio,
-				 mask->vlan_priority);
+				 match.mask->vlan_priority);
 			MLX5_SET(fte_match_set_misc, misc_v, outer_second_prio,
-				 key->vlan_priority);
+				 match.key->vlan_priority);
 
 			*match_level = MLX5_MATCH_L2;
 		}
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
-		struct flow_dissector_key_eth_addrs *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ETH_ADDRS,
-						  f->key);
-		struct flow_dissector_key_eth_addrs *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ETH_ADDRS,
-						  f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		struct flow_match_eth_addrs match;
 
+		flow_rule_match_eth_addrs(rule, &match);
 		ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
 					     dmac_47_16),
-				mask->dst);
+				match.mask->dst);
 		ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
 					     dmac_47_16),
-				key->dst);
+				match.key->dst);
 
 		ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
 					     smac_47_16),
-				mask->src);
+				match.mask->src);
 		ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
 					     smac_47_16),
-				key->src);
+				match.key->src);
 
-		if (!is_zero_ether_addr(mask->src) || !is_zero_ether_addr(mask->dst))
+		if (!is_zero_ether_addr(match.mask->src) ||
+		    !is_zero_ether_addr(match.mask->dst))
 			*match_level = MLX5_MATCH_L2;
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_CONTROL)) {
-		struct flow_dissector_key_control *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_CONTROL,
-						  f->key);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
+		struct flow_match_control match;
 
-		struct flow_dissector_key_control *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_CONTROL,
-						  f->mask);
-		addr_type = key->addr_type;
+		flow_rule_match_control(rule, &match);
+		addr_type = match.key->addr_type;
 
 		/* the HW doesn't support frag first/later */
-		if (mask->flags & FLOW_DIS_FIRST_FRAG)
+		if (match.mask->flags & FLOW_DIS_FIRST_FRAG)
 			return -EOPNOTSUPP;
 
-		if (mask->flags & FLOW_DIS_IS_FRAGMENT) {
+		if (match.mask->flags & FLOW_DIS_IS_FRAGMENT) {
 			MLX5_SET(fte_match_set_lyr_2_4, headers_c, frag, 1);
 			MLX5_SET(fte_match_set_lyr_2_4, headers_v, frag,
-				 key->flags & FLOW_DIS_IS_FRAGMENT);
+				 match.key->flags & FLOW_DIS_IS_FRAGMENT);
 
 			/* the HW doesn't need L3 inline to match on frag=no */
-			if (!(key->flags & FLOW_DIS_IS_FRAGMENT))
+			if (!(match.key->flags & FLOW_DIS_IS_FRAGMENT))
 				*match_level = MLX5_MATCH_L2;
 	/* ***  L2 attributes parsing up to here *** */
 			else
@@ -1640,102 +1610,85 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 		}
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_BASIC)) {
-		struct flow_dissector_key_basic *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_BASIC,
-						  f->key);
-		struct flow_dissector_key_basic *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_BASIC,
-						  f->mask);
-		ip_proto = key->ip_proto;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
+
+		flow_rule_match_basic(rule, &match);
+		ip_proto = match.key->ip_proto;
 
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_protocol,
-			 mask->ip_proto);
+			 match.mask->ip_proto);
 		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_protocol,
-			 key->ip_proto);
+			 match.key->ip_proto);
 
-		if (mask->ip_proto)
+		if (match.mask->ip_proto)
 			*match_level = MLX5_MATCH_L3;
 	}
 
 	if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
-		struct flow_dissector_key_ipv4_addrs *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_IPV4_ADDRS,
-						  f->key);
-		struct flow_dissector_key_ipv4_addrs *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_IPV4_ADDRS,
-						  f->mask);
+		struct flow_match_ipv4_addrs match;
 
+		flow_rule_match_ipv4_addrs(rule, &match);
 		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
 				    src_ipv4_src_ipv6.ipv4_layout.ipv4),
-		       &mask->src, sizeof(mask->src));
+		       &match.mask->src, sizeof(match.mask->src));
 		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
 				    src_ipv4_src_ipv6.ipv4_layout.ipv4),
-		       &key->src, sizeof(key->src));
+		       &match.key->src, sizeof(match.key->src));
 		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
 				    dst_ipv4_dst_ipv6.ipv4_layout.ipv4),
-		       &mask->dst, sizeof(mask->dst));
+		       &match.mask->dst, sizeof(match.mask->dst));
 		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
 				    dst_ipv4_dst_ipv6.ipv4_layout.ipv4),
-		       &key->dst, sizeof(key->dst));
+		       &match.key->dst, sizeof(match.key->dst));
 
-		if (mask->src || mask->dst)
+		if (match.mask->src || match.mask->dst)
 			*match_level = MLX5_MATCH_L3;
 	}
 
 	if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
-		struct flow_dissector_key_ipv6_addrs *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_IPV6_ADDRS,
-						  f->key);
-		struct flow_dissector_key_ipv6_addrs *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_IPV6_ADDRS,
-						  f->mask);
+		struct flow_match_ipv6_addrs match;
 
+		flow_rule_match_ipv6_addrs(rule, &match);
 		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
 				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
-		       &mask->src, sizeof(mask->src));
+		       &match.mask->src, sizeof(match.mask->src));
 		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
 				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
-		       &key->src, sizeof(key->src));
+		       &match.key->src, sizeof(match.key->src));
 
 		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
 				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       &mask->dst, sizeof(mask->dst));
+		       &match.mask->dst, sizeof(match.mask->dst));
 		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
 				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       &key->dst, sizeof(key->dst));
+		       &match.key->dst, sizeof(match.key->dst));
 
-		if (ipv6_addr_type(&mask->src) != IPV6_ADDR_ANY ||
-		    ipv6_addr_type(&mask->dst) != IPV6_ADDR_ANY)
+		if (ipv6_addr_type(&match.mask->src) != IPV6_ADDR_ANY ||
+		    ipv6_addr_type(&match.mask->dst) != IPV6_ADDR_ANY)
 			*match_level = MLX5_MATCH_L3;
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_IP)) {
-		struct flow_dissector_key_ip *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_IP,
-						  f->key);
-		struct flow_dissector_key_ip *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_IP,
-						  f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP)) {
+		struct flow_match_ip match;
 
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_ecn, mask->tos & 0x3);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_ecn, key->tos & 0x3);
+		flow_rule_match_ip(rule, &match);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_ecn,
+			 match.mask->tos & 0x3);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_ecn,
+			 match.key->tos & 0x3);
 
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_dscp, mask->tos >> 2);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_dscp, key->tos  >> 2);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_dscp,
+			 match.mask->tos >> 2);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_dscp,
+			 match.key->tos  >> 2);
 
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ttl_hoplimit, mask->ttl);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ttl_hoplimit, key->ttl);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ttl_hoplimit,
+			 match.mask->ttl);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ttl_hoplimit,
+			 match.key->ttl);
 
-		if (mask->ttl &&
+		if (match.mask->ttl &&
 		    !MLX5_CAP_ESW_FLOWTABLE_FDB(priv->mdev,
 						ft_field_support.outer_ipv4_ttl)) {
 			NL_SET_ERR_MSG_MOD(extack,
@@ -1743,44 +1696,39 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 			return -EOPNOTSUPP;
 		}
 
-		if (mask->tos || mask->ttl)
+		if (match.mask->tos || match.mask->ttl)
 			*match_level = MLX5_MATCH_L3;
 	}
 
 	/* ***  L3 attributes parsing up to here *** */
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_PORTS)) {
-		struct flow_dissector_key_ports *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_PORTS,
-						  f->key);
-		struct flow_dissector_key_ports *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_PORTS,
-						  f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports match;
+
+		flow_rule_match_ports(rule, &match);
 		switch (ip_proto) {
 		case IPPROTO_TCP:
 			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
-				 tcp_sport, ntohs(mask->src));
+				 tcp_sport, ntohs(match.mask->src));
 			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
-				 tcp_sport, ntohs(key->src));
+				 tcp_sport, ntohs(match.key->src));
 
 			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
-				 tcp_dport, ntohs(mask->dst));
+				 tcp_dport, ntohs(match.mask->dst));
 			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
-				 tcp_dport, ntohs(key->dst));
+				 tcp_dport, ntohs(match.key->dst));
 			break;
 
 		case IPPROTO_UDP:
 			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
-				 udp_sport, ntohs(mask->src));
+				 udp_sport, ntohs(match.mask->src));
 			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
-				 udp_sport, ntohs(key->src));
+				 udp_sport, ntohs(match.key->src));
 
 			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
-				 udp_dport, ntohs(mask->dst));
+				 udp_dport, ntohs(match.mask->dst));
 			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
-				 udp_dport, ntohs(key->dst));
+				 udp_dport, ntohs(match.key->dst));
 			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack,
@@ -1790,26 +1738,20 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 			return -EINVAL;
 		}
 
-		if (mask->src || mask->dst)
+		if (match.mask->src || match.mask->dst)
 			*match_level = MLX5_MATCH_L4;
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_TCP)) {
-		struct flow_dissector_key_tcp *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_TCP,
-						  f->key);
-		struct flow_dissector_key_tcp *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_TCP,
-						  f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_TCP)) {
+		struct flow_match_tcp match;
 
+		flow_rule_match_tcp(rule, &match);
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c, tcp_flags,
-			 ntohs(mask->flags));
+			 ntohs(match.mask->flags));
 		MLX5_SET(fte_match_set_lyr_2_4, headers_v, tcp_flags,
-			 ntohs(key->flags));
+			 ntohs(match.key->flags));
 
-		if (mask->flags)
+		if (match.mask->flags)
 			*match_level = MLX5_MATCH_L4;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index ff072358d950..a20379e29e02 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -113,59 +113,49 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 static void mlxsw_sp_flower_parse_ipv4(struct mlxsw_sp_acl_rule_info *rulei,
 				       struct tc_cls_flower_offload *f)
 {
-	struct flow_dissector_key_ipv4_addrs *key =
-		skb_flow_dissector_target(f->dissector,
-					  FLOW_DISSECTOR_KEY_IPV4_ADDRS,
-					  f->key);
-	struct flow_dissector_key_ipv4_addrs *mask =
-		skb_flow_dissector_target(f->dissector,
-					  FLOW_DISSECTOR_KEY_IPV4_ADDRS,
-					  f->mask);
+	struct flow_match_ipv4_addrs match;
+
+	flow_rule_match_ipv4_addrs(f->rule, &match);
 
 	mlxsw_sp_acl_rulei_keymask_buf(rulei, MLXSW_AFK_ELEMENT_SRC_IP_0_31,
-				       (char *) &key->src,
-				       (char *) &mask->src, 4);
+				       (char *) &match.key->src,
+				       (char *) &match.mask->src, 4);
 	mlxsw_sp_acl_rulei_keymask_buf(rulei, MLXSW_AFK_ELEMENT_DST_IP_0_31,
-				       (char *) &key->dst,
-				       (char *) &mask->dst, 4);
+				       (char *) &match.key->dst,
+				       (char *) &match.mask->dst, 4);
 }
 
 static void mlxsw_sp_flower_parse_ipv6(struct mlxsw_sp_acl_rule_info *rulei,
 				       struct tc_cls_flower_offload *f)
 {
-	struct flow_dissector_key_ipv6_addrs *key =
-		skb_flow_dissector_target(f->dissector,
-					  FLOW_DISSECTOR_KEY_IPV6_ADDRS,
-					  f->key);
-	struct flow_dissector_key_ipv6_addrs *mask =
-		skb_flow_dissector_target(f->dissector,
-					  FLOW_DISSECTOR_KEY_IPV6_ADDRS,
-					  f->mask);
+	struct flow_match_ipv6_addrs match;
+
+	flow_rule_match_ipv6_addrs(f->rule, &match);
 
 	mlxsw_sp_acl_rulei_keymask_buf(rulei, MLXSW_AFK_ELEMENT_SRC_IP_96_127,
-				       &key->src.s6_addr[0x0],
-				       &mask->src.s6_addr[0x0], 4);
+				       &match.key->src.s6_addr[0x0],
+				       &match.mask->src.s6_addr[0x0], 4);
 	mlxsw_sp_acl_rulei_keymask_buf(rulei, MLXSW_AFK_ELEMENT_SRC_IP_64_95,
-				       &key->src.s6_addr[0x4],
-				       &mask->src.s6_addr[0x4], 4);
+				       &match.key->src.s6_addr[0x4],
+				       &match.mask->src.s6_addr[0x4], 4);
 	mlxsw_sp_acl_rulei_keymask_buf(rulei, MLXSW_AFK_ELEMENT_SRC_IP_32_63,
-				       &key->src.s6_addr[0x8],
-				       &mask->src.s6_addr[0x8], 4);
+				       &match.key->src.s6_addr[0x8],
+				       &match.mask->src.s6_addr[0x8], 4);
 	mlxsw_sp_acl_rulei_keymask_buf(rulei, MLXSW_AFK_ELEMENT_SRC_IP_0_31,
-				       &key->src.s6_addr[0xC],
-				       &mask->src.s6_addr[0xC], 4);
+				       &match.key->src.s6_addr[0xC],
+				       &match.mask->src.s6_addr[0xC], 4);
 	mlxsw_sp_acl_rulei_keymask_buf(rulei, MLXSW_AFK_ELEMENT_DST_IP_96_127,
-				       &key->dst.s6_addr[0x0],
-				       &mask->dst.s6_addr[0x0], 4);
+				       &match.key->dst.s6_addr[0x0],
+				       &match.mask->dst.s6_addr[0x0], 4);
 	mlxsw_sp_acl_rulei_keymask_buf(rulei, MLXSW_AFK_ELEMENT_DST_IP_64_95,
-				       &key->dst.s6_addr[0x4],
-				       &mask->dst.s6_addr[0x4], 4);
+				       &match.key->dst.s6_addr[0x4],
+				       &match.mask->dst.s6_addr[0x4], 4);
 	mlxsw_sp_acl_rulei_keymask_buf(rulei, MLXSW_AFK_ELEMENT_DST_IP_32_63,
-				       &key->dst.s6_addr[0x8],
-				       &mask->dst.s6_addr[0x8], 4);
+				       &match.key->dst.s6_addr[0x8],
+				       &match.mask->dst.s6_addr[0x8], 4);
 	mlxsw_sp_acl_rulei_keymask_buf(rulei, MLXSW_AFK_ELEMENT_DST_IP_0_31,
-				       &key->dst.s6_addr[0xC],
-				       &mask->dst.s6_addr[0xC], 4);
+				       &match.key->dst.s6_addr[0xC],
+				       &match.mask->dst.s6_addr[0xC], 4);
 }
 
 static int mlxsw_sp_flower_parse_ports(struct mlxsw_sp *mlxsw_sp,
@@ -173,9 +163,10 @@ static int mlxsw_sp_flower_parse_ports(struct mlxsw_sp *mlxsw_sp,
 				       struct tc_cls_flower_offload *f,
 				       u8 ip_proto)
 {
-	struct flow_dissector_key_ports *key, *mask;
+	const struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_match_ports match;
 
-	if (!dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_PORTS))
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS))
 		return 0;
 
 	if (ip_proto != IPPROTO_TCP && ip_proto != IPPROTO_UDP) {
@@ -184,16 +175,13 @@ static int mlxsw_sp_flower_parse_ports(struct mlxsw_sp *mlxsw_sp,
 		return -EINVAL;
 	}
 
-	key = skb_flow_dissector_target(f->dissector,
-					FLOW_DISSECTOR_KEY_PORTS,
-					f->key);
-	mask = skb_flow_dissector_target(f->dissector,
-					 FLOW_DISSECTOR_KEY_PORTS,
-					 f->mask);
+	flow_rule_match_ports(rule, &match);
 	mlxsw_sp_acl_rulei_keymask_u32(rulei, MLXSW_AFK_ELEMENT_DST_L4_PORT,
-				       ntohs(key->dst), ntohs(mask->dst));
+				       ntohs(match.key->dst),
+				       ntohs(match.mask->dst));
 	mlxsw_sp_acl_rulei_keymask_u32(rulei, MLXSW_AFK_ELEMENT_SRC_L4_PORT,
-				       ntohs(key->src), ntohs(mask->src));
+				       ntohs(match.key->src),
+				       ntohs(match.mask->src));
 	return 0;
 }
 
@@ -202,9 +190,10 @@ static int mlxsw_sp_flower_parse_tcp(struct mlxsw_sp *mlxsw_sp,
 				     struct tc_cls_flower_offload *f,
 				     u8 ip_proto)
 {
-	struct flow_dissector_key_tcp *key, *mask;
+	const struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_match_tcp match;
 
-	if (!dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_TCP))
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_TCP))
 		return 0;
 
 	if (ip_proto != IPPROTO_TCP) {
@@ -213,14 +202,11 @@ static int mlxsw_sp_flower_parse_tcp(struct mlxsw_sp *mlxsw_sp,
 		return -EINVAL;
 	}
 
-	key = skb_flow_dissector_target(f->dissector,
-					FLOW_DISSECTOR_KEY_TCP,
-					f->key);
-	mask = skb_flow_dissector_target(f->dissector,
-					 FLOW_DISSECTOR_KEY_TCP,
-					 f->mask);
+	flow_rule_match_tcp(rule, &match);
+
 	mlxsw_sp_acl_rulei_keymask_u32(rulei, MLXSW_AFK_ELEMENT_TCP_FLAGS,
-				       ntohs(key->flags), ntohs(mask->flags));
+				       ntohs(match.key->flags),
+				       ntohs(match.mask->flags));
 	return 0;
 }
 
@@ -229,9 +215,10 @@ static int mlxsw_sp_flower_parse_ip(struct mlxsw_sp *mlxsw_sp,
 				    struct tc_cls_flower_offload *f,
 				    u16 n_proto)
 {
-	struct flow_dissector_key_ip *key, *mask;
+	const struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_match_ip match;
 
-	if (!dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_IP))
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP))
 		return 0;
 
 	if (n_proto != ETH_P_IP && n_proto != ETH_P_IPV6) {
@@ -240,20 +227,18 @@ static int mlxsw_sp_flower_parse_ip(struct mlxsw_sp *mlxsw_sp,
 		return -EINVAL;
 	}
 
-	key = skb_flow_dissector_target(f->dissector,
-					FLOW_DISSECTOR_KEY_IP,
-					f->key);
-	mask = skb_flow_dissector_target(f->dissector,
-					 FLOW_DISSECTOR_KEY_IP,
-					 f->mask);
+	flow_rule_match_ip(rule, &match);
+
 	mlxsw_sp_acl_rulei_keymask_u32(rulei, MLXSW_AFK_ELEMENT_IP_TTL_,
-				       key->ttl, mask->ttl);
+				       match.key->ttl, match.mask->ttl);
 
 	mlxsw_sp_acl_rulei_keymask_u32(rulei, MLXSW_AFK_ELEMENT_IP_ECN,
-				       key->tos & 0x3, mask->tos & 0x3);
+				       match.key->tos & 0x3,
+				       match.mask->tos & 0x3);
 
 	mlxsw_sp_acl_rulei_keymask_u32(rulei, MLXSW_AFK_ELEMENT_IP_DSCP,
-				       key->tos >> 6, mask->tos >> 6);
+				       match.key->tos >> 6,
+				       match.mask->tos >> 6);
 
 	return 0;
 }
@@ -263,13 +248,15 @@ static int mlxsw_sp_flower_parse(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_acl_rule_info *rulei,
 				 struct tc_cls_flower_offload *f)
 {
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_dissector *dissector = rule->match.dissector;
 	u16 n_proto_mask = 0;
 	u16 n_proto_key = 0;
 	u16 addr_type = 0;
 	u8 ip_proto = 0;
 	int err;
 
-	if (f->dissector->used_keys &
+	if (dissector->used_keys &
 	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
 	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
@@ -286,25 +273,19 @@ static int mlxsw_sp_flower_parse(struct mlxsw_sp *mlxsw_sp,
 
 	mlxsw_sp_acl_rulei_priority(rulei, f->common.prio);
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_CONTROL)) {
-		struct flow_dissector_key_control *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_CONTROL,
-						  f->key);
-		addr_type = key->addr_type;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
+		struct flow_match_control match;
+
+		flow_rule_match_control(rule, &match);
+		addr_type = match.key->addr_type;
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_BASIC)) {
-		struct flow_dissector_key_basic *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_BASIC,
-						  f->key);
-		struct flow_dissector_key_basic *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_BASIC,
-						  f->mask);
-		n_proto_key = ntohs(key->n_proto);
-		n_proto_mask = ntohs(mask->n_proto);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
+
+		flow_rule_match_basic(rule, &match);
+		n_proto_key = ntohs(match.key->n_proto);
+		n_proto_mask = ntohs(match.mask->n_proto);
 
 		if (n_proto_key == ETH_P_ALL) {
 			n_proto_key = 0;
@@ -314,60 +295,53 @@ static int mlxsw_sp_flower_parse(struct mlxsw_sp *mlxsw_sp,
 					       MLXSW_AFK_ELEMENT_ETHERTYPE,
 					       n_proto_key, n_proto_mask);
 
-		ip_proto = key->ip_proto;
+		ip_proto = match.key->ip_proto;
 		mlxsw_sp_acl_rulei_keymask_u32(rulei,
 					       MLXSW_AFK_ELEMENT_IP_PROTO,
-					       key->ip_proto, mask->ip_proto);
+					       match.key->ip_proto,
+					       match.mask->ip_proto);
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
-		struct flow_dissector_key_eth_addrs *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ETH_ADDRS,
-						  f->key);
-		struct flow_dissector_key_eth_addrs *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_ETH_ADDRS,
-						  f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		struct flow_match_eth_addrs match;
 
+		flow_rule_match_eth_addrs(rule, &match);
 		mlxsw_sp_acl_rulei_keymask_buf(rulei,
 					       MLXSW_AFK_ELEMENT_DMAC_32_47,
-					       key->dst, mask->dst, 2);
+					       match.key->dst,
+					       match.mask->dst, 2);
 		mlxsw_sp_acl_rulei_keymask_buf(rulei,
 					       MLXSW_AFK_ELEMENT_DMAC_0_31,
-					       key->dst + 2, mask->dst + 2, 4);
+					       match.key->dst + 2,
+					       match.mask->dst + 2, 4);
 		mlxsw_sp_acl_rulei_keymask_buf(rulei,
 					       MLXSW_AFK_ELEMENT_SMAC_32_47,
-					       key->src, mask->src, 2);
+					       match.key->src,
+					       match.mask->src, 2);
 		mlxsw_sp_acl_rulei_keymask_buf(rulei,
 					       MLXSW_AFK_ELEMENT_SMAC_0_31,
-					       key->src + 2, mask->src + 2, 4);
+					       match.key->src + 2,
+					       match.mask->src + 2, 4);
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_VLAN)) {
-		struct flow_dissector_key_vlan *key =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_VLAN,
-						  f->key);
-		struct flow_dissector_key_vlan *mask =
-			skb_flow_dissector_target(f->dissector,
-						  FLOW_DISSECTOR_KEY_VLAN,
-						  f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
 
+		flow_rule_match_vlan(rule, &match);
 		if (mlxsw_sp_acl_block_is_egress_bound(block)) {
 			NL_SET_ERR_MSG_MOD(f->common.extack, "vlan_id key is not supported on egress");
 			return -EOPNOTSUPP;
 		}
-		if (mask->vlan_id != 0)
+		if (match.mask->vlan_id != 0)
 			mlxsw_sp_acl_rulei_keymask_u32(rulei,
 						       MLXSW_AFK_ELEMENT_VID,
-						       key->vlan_id,
-						       mask->vlan_id);
-		if (mask->vlan_priority != 0)
+						       match.key->vlan_id,
+						       match.mask->vlan_id);
+		if (match.mask->vlan_priority != 0)
 			mlxsw_sp_acl_rulei_keymask_u32(rulei,
 						       MLXSW_AFK_ELEMENT_PCP,
-						       key->vlan_priority,
-						       mask->vlan_priority);
+						       match.key->vlan_priority,
+						       match.mask->vlan_priority);
 	}
 
 	if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS)
diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 8d54b36afee8..43192640bdd1 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -587,6 +587,7 @@ static int
 nfp_fl_pedit(const struct tc_action *action, struct tc_cls_flower_offload *flow,
 	     char *nfp_action, int *a_len, u32 *csum_updated)
 {
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
 	struct nfp_fl_set_ipv6_addr set_ip6_dst, set_ip6_src;
 	struct nfp_fl_set_ipv6_tc_hl_fl set_ip6_tc_hl_fl;
 	struct nfp_fl_set_ip4_ttl_tos set_ip_ttl_tos;
@@ -643,13 +644,11 @@ nfp_fl_pedit(const struct tc_action *action, struct tc_cls_flower_offload *flow,
 			return err;
 	}
 
-	if (dissector_uses_key(flow->dissector, FLOW_DISSECTOR_KEY_BASIC)) {
-		struct flow_dissector_key_basic *basic;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
 
-		basic = skb_flow_dissector_target(flow->dissector,
-						  FLOW_DISSECTOR_KEY_BASIC,
-						  flow->key);
-		ip_proto = basic->ip_proto;
+		flow_rule_match_basic(rule, &match);
+		ip_proto = match.key->ip_proto;
 	}
 
 	if (set_eth.head.len_lw) {
diff --git a/drivers/net/ethernet/netronome/nfp/flower/match.c b/drivers/net/ethernet/netronome/nfp/flower/match.c
index c04a0d6b0184..1279fa5da9e1 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/match.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/match.c
@@ -8,31 +8,41 @@
 #include "main.h"
 
 static void
-nfp_flower_compile_meta_tci(struct nfp_flower_meta_tci *frame,
-			    struct tc_cls_flower_offload *flow, u8 key_type,
-			    bool mask_version)
+nfp_flower_compile_meta_tci(struct nfp_flower_meta_tci *ext,
+			    struct nfp_flower_meta_tci *msk,
+			    struct tc_cls_flower_offload *flow, u8 key_type)
 {
-	struct fl_flow_key *target = mask_version ? flow->mask : flow->key;
-	struct flow_dissector_key_vlan *flow_vlan;
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
 	u16 tmp_tci;
 
-	memset(frame, 0, sizeof(struct nfp_flower_meta_tci));
+	memset(ext, 0, sizeof(struct nfp_flower_meta_tci));
+	memset(msk, 0, sizeof(struct nfp_flower_meta_tci));
+
 	/* Populate the metadata frame. */
-	frame->nfp_flow_key_layer = key_type;
-	frame->mask_id = ~0;
+	ext->nfp_flow_key_layer = key_type;
+	ext->mask_id = ~0;
+
+	msk->nfp_flow_key_layer = key_type;
+	msk->mask_id = ~0;
 
-	if (dissector_uses_key(flow->dissector, FLOW_DISSECTOR_KEY_VLAN)) {
-		flow_vlan = skb_flow_dissector_target(flow->dissector,
-						      FLOW_DISSECTOR_KEY_VLAN,
-						      target);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
+
+		flow_rule_match_vlan(rule, &match);
 		/* Populate the tci field. */
-		if (flow_vlan->vlan_id || flow_vlan->vlan_priority) {
+		if (match.key->vlan_id || match.key->vlan_priority) {
+			tmp_tci = FIELD_PREP(NFP_FLOWER_MASK_VLAN_PRIO,
+					     match.key->vlan_priority) |
+				  FIELD_PREP(NFP_FLOWER_MASK_VLAN_VID,
+					     match.key->vlan_id) |
+				  NFP_FLOWER_MASK_VLAN_CFI;
+			ext->tci = cpu_to_be16(tmp_tci);
 			tmp_tci = FIELD_PREP(NFP_FLOWER_MASK_VLAN_PRIO,
-					     flow_vlan->vlan_priority) |
+					     match.mask->vlan_priority) |
 				  FIELD_PREP(NFP_FLOWER_MASK_VLAN_VID,
-					     flow_vlan->vlan_id) |
+					     match.mask->vlan_id) |
 				  NFP_FLOWER_MASK_VLAN_CFI;
-			frame->tci = cpu_to_be16(tmp_tci);
+			msk->tci = cpu_to_be16(tmp_tci);
 		}
 	}
 }
@@ -64,231 +74,244 @@ nfp_flower_compile_port(struct nfp_flower_in_port *frame, u32 cmsg_port,
 }
 
 static void
-nfp_flower_compile_mac(struct nfp_flower_mac_mpls *frame,
-		       struct tc_cls_flower_offload *flow,
-		       bool mask_version)
+nfp_flower_compile_mac(struct nfp_flower_mac_mpls *ext,
+		       struct nfp_flower_mac_mpls *msk,
+		       struct tc_cls_flower_offload *flow)
 {
-	struct fl_flow_key *target = mask_version ? flow->mask : flow->key;
-	struct flow_dissector_key_eth_addrs *addr;
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
 
-	memset(frame, 0, sizeof(struct nfp_flower_mac_mpls));
+	memset(ext, 0, sizeof(struct nfp_flower_mac_mpls));
+	memset(msk, 0, sizeof(struct nfp_flower_mac_mpls));
 
-	if (dissector_uses_key(flow->dissector, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
-		addr = skb_flow_dissector_target(flow->dissector,
-						 FLOW_DISSECTOR_KEY_ETH_ADDRS,
-						 target);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		struct flow_match_eth_addrs match;
+
+		flow_rule_match_eth_addrs(rule, &match);
 		/* Populate mac frame. */
-		ether_addr_copy(frame->mac_dst, &addr->dst[0]);
-		ether_addr_copy(frame->mac_src, &addr->src[0]);
+		ether_addr_copy(ext->mac_dst, &match.key->dst[0]);
+		ether_addr_copy(ext->mac_src, &match.key->src[0]);
+		ether_addr_copy(msk->mac_dst, &match.mask->dst[0]);
+		ether_addr_copy(msk->mac_src, &match.mask->src[0]);
 	}
 
-	if (dissector_uses_key(flow->dissector, FLOW_DISSECTOR_KEY_MPLS)) {
-		struct flow_dissector_key_mpls *mpls;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_MPLS)) {
+		struct flow_match_mpls match;
 		u32 t_mpls;
 
-		mpls = skb_flow_dissector_target(flow->dissector,
-						 FLOW_DISSECTOR_KEY_MPLS,
-						 target);
-
-		t_mpls = FIELD_PREP(NFP_FLOWER_MASK_MPLS_LB, mpls->mpls_label) |
-			 FIELD_PREP(NFP_FLOWER_MASK_MPLS_TC, mpls->mpls_tc) |
-			 FIELD_PREP(NFP_FLOWER_MASK_MPLS_BOS, mpls->mpls_bos) |
+		flow_rule_match_mpls(rule, &match);
+		t_mpls = FIELD_PREP(NFP_FLOWER_MASK_MPLS_LB, match.key->mpls_label) |
+			 FIELD_PREP(NFP_FLOWER_MASK_MPLS_TC, match.key->mpls_tc) |
+			 FIELD_PREP(NFP_FLOWER_MASK_MPLS_BOS, match.key->mpls_bos) |
 			 NFP_FLOWER_MASK_MPLS_Q;
-
-		frame->mpls_lse = cpu_to_be32(t_mpls);
-	} else if (dissector_uses_key(flow->dissector,
-				      FLOW_DISSECTOR_KEY_BASIC)) {
+		ext->mpls_lse = cpu_to_be32(t_mpls);
+		t_mpls = FIELD_PREP(NFP_FLOWER_MASK_MPLS_LB, match.mask->mpls_label) |
+			 FIELD_PREP(NFP_FLOWER_MASK_MPLS_TC, match.mask->mpls_tc) |
+			 FIELD_PREP(NFP_FLOWER_MASK_MPLS_BOS, match.mask->mpls_bos) |
+			 NFP_FLOWER_MASK_MPLS_Q;
+		msk->mpls_lse = cpu_to_be32(t_mpls);
+	} else if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
 		/* Check for mpls ether type and set NFP_FLOWER_MASK_MPLS_Q
 		 * bit, which indicates an mpls ether type but without any
 		 * mpls fields.
 		 */
-		struct flow_dissector_key_basic *key_basic;
-
-		key_basic = skb_flow_dissector_target(flow->dissector,
-						      FLOW_DISSECTOR_KEY_BASIC,
-						      flow->key);
-		if (key_basic->n_proto == cpu_to_be16(ETH_P_MPLS_UC) ||
-		    key_basic->n_proto == cpu_to_be16(ETH_P_MPLS_MC))
-			frame->mpls_lse = cpu_to_be32(NFP_FLOWER_MASK_MPLS_Q);
+		struct flow_match_basic match;
+
+		flow_rule_match_basic(rule, &match);
+		if (match.key->n_proto == cpu_to_be16(ETH_P_MPLS_UC) ||
+		    match.key->n_proto == cpu_to_be16(ETH_P_MPLS_MC)) {
+			ext->mpls_lse = cpu_to_be32(NFP_FLOWER_MASK_MPLS_Q);
+			msk->mpls_lse = cpu_to_be32(NFP_FLOWER_MASK_MPLS_Q);
+		}
 	}
 }
 
 static void
-nfp_flower_compile_tport(struct nfp_flower_tp_ports *frame,
-			 struct tc_cls_flower_offload *flow,
-			 bool mask_version)
+nfp_flower_compile_tport(struct nfp_flower_tp_ports *ext,
+			 struct nfp_flower_tp_ports *msk,
+			 struct tc_cls_flower_offload *flow)
 {
-	struct fl_flow_key *target = mask_version ? flow->mask : flow->key;
-	struct flow_dissector_key_ports *tp;
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
 
-	memset(frame, 0, sizeof(struct nfp_flower_tp_ports));
+	memset(ext, 0, sizeof(struct nfp_flower_tp_ports));
+	memset(msk, 0, sizeof(struct nfp_flower_tp_ports));
 
-	if (dissector_uses_key(flow->dissector, FLOW_DISSECTOR_KEY_PORTS)) {
-		tp = skb_flow_dissector_target(flow->dissector,
-					       FLOW_DISSECTOR_KEY_PORTS,
-					       target);
-		frame->port_src = tp->src;
-		frame->port_dst = tp->dst;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports match;
+
+		flow_rule_match_ports(rule, &match);
+		ext->port_src = match.key->src;
+		ext->port_dst = match.key->dst;
+		msk->port_src = match.mask->src;
+		msk->port_dst = match.mask->dst;
 	}
 }
 
 static void
-nfp_flower_compile_ip_ext(struct nfp_flower_ip_ext *frame,
-			  struct tc_cls_flower_offload *flow,
-			  bool mask_version)
+nfp_flower_compile_ip_ext(struct nfp_flower_ip_ext *ext,
+			  struct nfp_flower_ip_ext *msk,
+			  struct tc_cls_flower_offload *flow)
 {
-	struct fl_flow_key *target = mask_version ? flow->mask : flow->key;
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
 
-	if (dissector_uses_key(flow->dissector, FLOW_DISSECTOR_KEY_BASIC)) {
-		struct flow_dissector_key_basic *basic;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
 
-		basic = skb_flow_dissector_target(flow->dissector,
-						  FLOW_DISSECTOR_KEY_BASIC,
-						  target);
-		frame->proto = basic->ip_proto;
+		flow_rule_match_basic(rule, &match);
+		ext->proto = match.key->ip_proto;
+		msk->proto = match.mask->ip_proto;
 	}
 
-	if (dissector_uses_key(flow->dissector, FLOW_DISSECTOR_KEY_IP)) {
-		struct flow_dissector_key_ip *flow_ip;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP)) {
+		struct flow_match_ip match;
 
-		flow_ip = skb_flow_dissector_target(flow->dissector,
-						    FLOW_DISSECTOR_KEY_IP,
-						    target);
-		frame->tos = flow_ip->tos;
-		frame->ttl = flow_ip->ttl;
+		flow_rule_match_ip(rule, &match);
+		ext->tos = match.key->tos;
+		ext->ttl = match.key->ttl;
+		msk->tos = match.mask->tos;
+		msk->ttl = match.mask->ttl;
 	}
 
-	if (dissector_uses_key(flow->dissector, FLOW_DISSECTOR_KEY_TCP)) {
-		struct flow_dissector_key_tcp *tcp;
-		u32 tcp_flags;
-
-		tcp = skb_flow_dissector_target(flow->dissector,
-						FLOW_DISSECTOR_KEY_TCP, target);
-		tcp_flags = be16_to_cpu(tcp->flags);
-
-		if (tcp_flags & TCPHDR_FIN)
-			frame->flags |= NFP_FL_TCP_FLAG_FIN;
-		if (tcp_flags & TCPHDR_SYN)
-			frame->flags |= NFP_FL_TCP_FLAG_SYN;
-		if (tcp_flags & TCPHDR_RST)
-			frame->flags |= NFP_FL_TCP_FLAG_RST;
-		if (tcp_flags & TCPHDR_PSH)
-			frame->flags |= NFP_FL_TCP_FLAG_PSH;
-		if (tcp_flags & TCPHDR_URG)
-			frame->flags |= NFP_FL_TCP_FLAG_URG;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_TCP)) {
+		struct flow_match_tcp match;
+		u16 tcp_flags;
+
+		flow_rule_match_tcp(rule, &match);
+		tcp_flags = be16_to_cpu(match.key->flags);
+
+		if (tcp_flags & TCPHDR_FIN) {
+			ext->flags |= NFP_FL_TCP_FLAG_FIN;
+			msk->flags |= NFP_FL_TCP_FLAG_FIN;
+		}
+		if (tcp_flags & TCPHDR_SYN) {
+			ext->flags |= NFP_FL_TCP_FLAG_SYN;
+			msk->flags |= NFP_FL_TCP_FLAG_SYN;
+		}
+		if (tcp_flags & TCPHDR_RST) {
+			ext->flags |= NFP_FL_TCP_FLAG_RST;
+			msk->flags |= NFP_FL_TCP_FLAG_RST;
+		}
+		if (tcp_flags & TCPHDR_PSH) {
+			ext->flags |= NFP_FL_TCP_FLAG_PSH;
+			msk->flags |= NFP_FL_TCP_FLAG_PSH;
+		}
+		if (tcp_flags & TCPHDR_URG) {
+			ext->flags |= NFP_FL_TCP_FLAG_URG;
+			msk->flags |= NFP_FL_TCP_FLAG_URG;
+		}
 	}
 
-	if (dissector_uses_key(flow->dissector, FLOW_DISSECTOR_KEY_CONTROL)) {
-		struct flow_dissector_key_control *key;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
+		struct flow_match_control match;
 
-		key = skb_flow_dissector_target(flow->dissector,
-						FLOW_DISSECTOR_KEY_CONTROL,
-						target);
-		if (key->flags & FLOW_DIS_IS_FRAGMENT)
-			frame->flags |= NFP_FL_IP_FRAGMENTED;
-		if (key->flags & FLOW_DIS_FIRST_FRAG)
-			frame->flags |= NFP_FL_IP_FRAG_FIRST;
+		flow_rule_match_control(rule, &match);
+		if (match.key->flags & FLOW_DIS_IS_FRAGMENT) {
+			ext->flags |= NFP_FL_IP_FRAGMENTED;
+			msk->flags |= NFP_FL_IP_FRAGMENTED;
+		}
+		if (match.key->flags & FLOW_DIS_FIRST_FRAG) {
+			ext->flags |= NFP_FL_IP_FRAG_FIRST;
+			msk->flags |= NFP_FL_IP_FRAG_FIRST;
+		}
 	}
 }
 
 static void
-nfp_flower_compile_ipv4(struct nfp_flower_ipv4 *frame,
-			struct tc_cls_flower_offload *flow,
-			bool mask_version)
+nfp_flower_compile_ipv4(struct nfp_flower_ipv4 *ext,
+			struct nfp_flower_ipv4 *msk,
+			struct tc_cls_flower_offload *flow)
 {
-	struct fl_flow_key *target = mask_version ? flow->mask : flow->key;
-	struct flow_dissector_key_ipv4_addrs *addr;
-
-	memset(frame, 0, sizeof(struct nfp_flower_ipv4));
-
-	if (dissector_uses_key(flow->dissector,
-			       FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
-		addr = skb_flow_dissector_target(flow->dissector,
-						 FLOW_DISSECTOR_KEY_IPV4_ADDRS,
-						 target);
-		frame->ipv4_src = addr->src;
-		frame->ipv4_dst = addr->dst;
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+	struct flow_match_ipv4_addrs match;
+
+	memset(ext, 0, sizeof(struct nfp_flower_ipv4));
+	memset(msk, 0, sizeof(struct nfp_flower_ipv4));
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
+		flow_rule_match_ipv4_addrs(rule, &match);
+		ext->ipv4_src = match.key->src;
+		ext->ipv4_dst = match.key->dst;
+		msk->ipv4_src = match.mask->src;
+		msk->ipv4_dst = match.mask->dst;
 	}
 
-	nfp_flower_compile_ip_ext(&frame->ip_ext, flow, mask_version);
+	nfp_flower_compile_ip_ext(&ext->ip_ext, &msk->ip_ext, flow);
 }
 
 static void
-nfp_flower_compile_ipv6(struct nfp_flower_ipv6 *frame,
-			struct tc_cls_flower_offload *flow,
-			bool mask_version)
+nfp_flower_compile_ipv6(struct nfp_flower_ipv6 *ext,
+			struct nfp_flower_ipv6 *msk,
+			struct tc_cls_flower_offload *flow)
 {
-	struct fl_flow_key *target = mask_version ? flow->mask : flow->key;
-	struct flow_dissector_key_ipv6_addrs *addr;
-
-	memset(frame, 0, sizeof(struct nfp_flower_ipv6));
-
-	if (dissector_uses_key(flow->dissector,
-			       FLOW_DISSECTOR_KEY_IPV6_ADDRS)) {
-		addr = skb_flow_dissector_target(flow->dissector,
-						 FLOW_DISSECTOR_KEY_IPV6_ADDRS,
-						 target);
-		frame->ipv6_src = addr->src;
-		frame->ipv6_dst = addr->dst;
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+
+	memset(ext, 0, sizeof(struct nfp_flower_ipv6));
+	memset(msk, 0, sizeof(struct nfp_flower_ipv6));
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS)) {
+		struct flow_match_ipv6_addrs match;
+
+		flow_rule_match_ipv6_addrs(rule, &match);
+		ext->ipv6_src = match.key->src;
+		ext->ipv6_dst = match.key->dst;
+		msk->ipv6_src = match.mask->src;
+		msk->ipv6_dst = match.mask->dst;
 	}
 
-	nfp_flower_compile_ip_ext(&frame->ip_ext, flow, mask_version);
+	nfp_flower_compile_ip_ext(&ext->ip_ext, &msk->ip_ext, flow);
 }
 
 static int
-nfp_flower_compile_geneve_opt(void *key_buf, struct tc_cls_flower_offload *flow,
-			      bool mask_version)
+nfp_flower_compile_geneve_opt(void *ext, void *msk,
+			      struct tc_cls_flower_offload *flow)
 {
-	struct fl_flow_key *target = mask_version ? flow->mask : flow->key;
-	struct flow_dissector_key_enc_opts *opts;
+	struct flow_match_enc_opts match;
 
-	opts = skb_flow_dissector_target(flow->dissector,
-					 FLOW_DISSECTOR_KEY_ENC_OPTS,
-					 target);
-	memcpy(key_buf, opts->data, opts->len);
+	flow_rule_match_enc_opts(flow->rule, &match);
+	memcpy(ext, match.key->data, match.key->len);
+	memcpy(msk, match.mask->data, match.mask->len);
 
 	return 0;
 }
 
 static void
-nfp_flower_compile_ipv4_udp_tun(struct nfp_flower_ipv4_udp_tun *frame,
-				struct tc_cls_flower_offload *flow,
-				bool mask_version)
+nfp_flower_compile_ipv4_udp_tun(struct nfp_flower_ipv4_udp_tun *ext,
+				struct nfp_flower_ipv4_udp_tun *msk,
+				struct tc_cls_flower_offload *flow)
 {
-	struct fl_flow_key *target = mask_version ? flow->mask : flow->key;
-	struct flow_dissector_key_ipv4_addrs *tun_ips;
-	struct flow_dissector_key_keyid *vni;
-	struct flow_dissector_key_ip *ip;
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
 
-	memset(frame, 0, sizeof(struct nfp_flower_ipv4_udp_tun));
+	memset(ext, 0, sizeof(struct nfp_flower_ipv4_udp_tun));
+	memset(msk, 0, sizeof(struct nfp_flower_ipv4_udp_tun));
 
-	if (dissector_uses_key(flow->dissector,
-			       FLOW_DISSECTOR_KEY_ENC_KEYID)) {
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
+		struct flow_match_enc_keyid match;
 		u32 temp_vni;
 
-		vni = skb_flow_dissector_target(flow->dissector,
-						FLOW_DISSECTOR_KEY_ENC_KEYID,
-						target);
-		temp_vni = be32_to_cpu(vni->keyid) << NFP_FL_TUN_VNI_OFFSET;
-		frame->tun_id = cpu_to_be32(temp_vni);
+		flow_rule_match_enc_keyid(rule, &match);
+		temp_vni = be32_to_cpu(match.key->keyid) << NFP_FL_TUN_VNI_OFFSET;
+		ext->tun_id = cpu_to_be32(temp_vni);
+		temp_vni = be32_to_cpu(match.mask->keyid) << NFP_FL_TUN_VNI_OFFSET;
+		msk->tun_id = cpu_to_be32(temp_vni);
 	}
 
-	if (dissector_uses_key(flow->dissector,
-			       FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS)) {
-		tun_ips =
-		   skb_flow_dissector_target(flow->dissector,
-					     FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS,
-					     target);
-		frame->ip_src = tun_ips->src;
-		frame->ip_dst = tun_ips->dst;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS)) {
+		struct flow_match_ipv4_addrs match;
+
+		flow_rule_match_enc_ipv4_addrs(rule, &match);
+		ext->ip_src = match.key->src;
+		ext->ip_dst = match.key->dst;
+		msk->ip_src = match.mask->src;
+		msk->ip_dst = match.mask->dst;
 	}
 
-	if (dissector_uses_key(flow->dissector, FLOW_DISSECTOR_KEY_ENC_IP)) {
-		ip = skb_flow_dissector_target(flow->dissector,
-					       FLOW_DISSECTOR_KEY_ENC_IP,
-					       target);
-		frame->tos = ip->tos;
-		frame->ttl = ip->ttl;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IP)) {
+		struct flow_match_ip match;
+
+		flow_rule_match_enc_ip(rule, &match);
+		ext->tos = match.key->tos;
+		ext->ttl = match.key->ttl;
+		msk->tos = match.mask->tos;
+		msk->ttl = match.mask->ttl;
 	}
 }
 
@@ -313,12 +336,9 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 	ext = nfp_flow->unmasked_data;
 	msk = nfp_flow->mask_data;
 
-	/* Populate Exact Metadata. */
 	nfp_flower_compile_meta_tci((struct nfp_flower_meta_tci *)ext,
-				    flow, key_ls->key_layer, false);
-	/* Populate Mask Metadata. */
-	nfp_flower_compile_meta_tci((struct nfp_flower_meta_tci *)msk,
-				    flow, key_ls->key_layer, true);
+				    (struct nfp_flower_meta_tci *)msk,
+				    flow, key_ls->key_layer);
 	ext += sizeof(struct nfp_flower_meta_tci);
 	msk += sizeof(struct nfp_flower_meta_tci);
 
@@ -348,45 +368,33 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 	msk += sizeof(struct nfp_flower_in_port);
 
 	if (NFP_FLOWER_LAYER_MAC & key_ls->key_layer) {
-		/* Populate Exact MAC Data. */
 		nfp_flower_compile_mac((struct nfp_flower_mac_mpls *)ext,
-				       flow, false);
-		/* Populate Mask MAC Data. */
-		nfp_flower_compile_mac((struct nfp_flower_mac_mpls *)msk,
-				       flow, true);
+				       (struct nfp_flower_mac_mpls *)msk,
+				       flow);
 		ext += sizeof(struct nfp_flower_mac_mpls);
 		msk += sizeof(struct nfp_flower_mac_mpls);
 	}
 
 	if (NFP_FLOWER_LAYER_TP & key_ls->key_layer) {
-		/* Populate Exact TP Data. */
 		nfp_flower_compile_tport((struct nfp_flower_tp_ports *)ext,
-					 flow, false);
-		/* Populate Mask TP Data. */
-		nfp_flower_compile_tport((struct nfp_flower_tp_ports *)msk,
-					 flow, true);
+					 (struct nfp_flower_tp_ports *)msk,
+					 flow);
 		ext += sizeof(struct nfp_flower_tp_ports);
 		msk += sizeof(struct nfp_flower_tp_ports);
 	}
 
 	if (NFP_FLOWER_LAYER_IPV4 & key_ls->key_layer) {
-		/* Populate Exact IPv4 Data. */
 		nfp_flower_compile_ipv4((struct nfp_flower_ipv4 *)ext,
-					flow, false);
-		/* Populate Mask IPv4 Data. */
-		nfp_flower_compile_ipv4((struct nfp_flower_ipv4 *)msk,
-					flow, true);
+					(struct nfp_flower_ipv4 *)msk,
+					flow);
 		ext += sizeof(struct nfp_flower_ipv4);
 		msk += sizeof(struct nfp_flower_ipv4);
 	}
 
 	if (NFP_FLOWER_LAYER_IPV6 & key_ls->key_layer) {
-		/* Populate Exact IPv4 Data. */
 		nfp_flower_compile_ipv6((struct nfp_flower_ipv6 *)ext,
-					flow, false);
-		/* Populate Mask IPv4 Data. */
-		nfp_flower_compile_ipv6((struct nfp_flower_ipv6 *)msk,
-					flow, true);
+					(struct nfp_flower_ipv6 *)msk,
+					flow);
 		ext += sizeof(struct nfp_flower_ipv6);
 		msk += sizeof(struct nfp_flower_ipv6);
 	}
@@ -395,10 +403,7 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 	    key_ls->key_layer_two & NFP_FLOWER_LAYER2_GENEVE) {
 		__be32 tun_dst;
 
-		/* Populate Exact VXLAN Data. */
-		nfp_flower_compile_ipv4_udp_tun((void *)ext, flow, false);
-		/* Populate Mask VXLAN Data. */
-		nfp_flower_compile_ipv4_udp_tun((void *)msk, flow, true);
+		nfp_flower_compile_ipv4_udp_tun((void *)ext, (void *)msk, flow);
 		tun_dst = ((struct nfp_flower_ipv4_udp_tun *)ext)->ip_dst;
 		ext += sizeof(struct nfp_flower_ipv4_udp_tun);
 		msk += sizeof(struct nfp_flower_ipv4_udp_tun);
@@ -410,11 +415,7 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 		nfp_tunnel_add_ipv4_off(app, tun_dst);
 
 		if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_GENEVE_OP) {
-			err = nfp_flower_compile_geneve_opt(ext, flow, false);
-			if (err)
-				return err;
-
-			err = nfp_flower_compile_geneve_opt(msk, flow, true);
+			err = nfp_flower_compile_geneve_opt(ext, msk, flow);
 			if (err)
 				return err;
 		}
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 2cdbf29ecbe7..74f7ff292052 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -102,23 +102,22 @@ nfp_flower_xmit_flow(struct nfp_app *app, struct nfp_fl_payload *nfp_flow,
 
 static bool nfp_flower_check_higher_than_mac(struct tc_cls_flower_offload *f)
 {
-	return dissector_uses_key(f->dissector,
-				  FLOW_DISSECTOR_KEY_IPV4_ADDRS) ||
-		dissector_uses_key(f->dissector,
-				   FLOW_DISSECTOR_KEY_IPV6_ADDRS) ||
-		dissector_uses_key(f->dissector,
-				   FLOW_DISSECTOR_KEY_PORTS) ||
-		dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_ICMP);
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+
+	return flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS) ||
+	       flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS) ||
+	       flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS) ||
+	       flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ICMP);
 }
 
 static int
-nfp_flower_calc_opt_layer(struct flow_dissector_key_enc_opts *enc_opts,
+nfp_flower_calc_opt_layer(struct flow_match_enc_opts *enc_opts,
 			  u32 *key_layer_two, int *key_size)
 {
-	if (enc_opts->len > NFP_FL_MAX_GENEVE_OPT_KEY)
+	if (enc_opts->key->len > NFP_FL_MAX_GENEVE_OPT_KEY)
 		return -EOPNOTSUPP;
 
-	if (enc_opts->len > 0) {
+	if (enc_opts->key->len > 0) {
 		*key_layer_two |= NFP_FLOWER_LAYER2_GENEVE_OP;
 		*key_size += sizeof(struct nfp_flower_geneve_options);
 	}
@@ -133,20 +132,21 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 				struct tc_cls_flower_offload *flow,
 				enum nfp_flower_tun_type *tun_type)
 {
-	struct flow_dissector_key_basic *mask_basic = NULL;
-	struct flow_dissector_key_basic *key_basic = NULL;
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+	struct flow_dissector *dissector = rule->match.dissector;
+	struct flow_match_basic basic = { NULL, NULL};
 	struct nfp_flower_priv *priv = app->priv;
 	u32 key_layer_two;
 	u8 key_layer;
 	int key_size;
 	int err;
 
-	if (flow->dissector->used_keys & ~NFP_FLOWER_WHITELIST_DISSECTOR)
+	if (dissector->used_keys & ~NFP_FLOWER_WHITELIST_DISSECTOR)
 		return -EOPNOTSUPP;
 
 	/* If any tun dissector is used then the required set must be used. */
-	if (flow->dissector->used_keys & NFP_FLOWER_WHITELIST_TUN_DISSECTOR &&
-	    (flow->dissector->used_keys & NFP_FLOWER_WHITELIST_TUN_DISSECTOR_R)
+	if (dissector->used_keys & NFP_FLOWER_WHITELIST_TUN_DISSECTOR &&
+	    (dissector->used_keys & NFP_FLOWER_WHITELIST_TUN_DISSECTOR_R)
 	    != NFP_FLOWER_WHITELIST_TUN_DISSECTOR_R)
 		return -EOPNOTSUPP;
 
@@ -155,76 +155,53 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 	key_size = sizeof(struct nfp_flower_meta_tci) +
 		   sizeof(struct nfp_flower_in_port);
 
-	if (dissector_uses_key(flow->dissector, FLOW_DISSECTOR_KEY_ETH_ADDRS) ||
-	    dissector_uses_key(flow->dissector, FLOW_DISSECTOR_KEY_MPLS)) {
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS) ||
+	    flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_MPLS)) {
 		key_layer |= NFP_FLOWER_LAYER_MAC;
 		key_size += sizeof(struct nfp_flower_mac_mpls);
 	}
 
-	if (dissector_uses_key(flow->dissector, FLOW_DISSECTOR_KEY_VLAN)) {
-		struct flow_dissector_key_vlan *flow_vlan;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan vlan;
 
-		flow_vlan = skb_flow_dissector_target(flow->dissector,
-						      FLOW_DISSECTOR_KEY_VLAN,
-						      flow->mask);
+		flow_rule_match_vlan(rule, &vlan);
 		if (!(priv->flower_ext_feats & NFP_FL_FEATS_VLAN_PCP) &&
-		    flow_vlan->vlan_priority)
+		    vlan.key->vlan_priority)
 			return -EOPNOTSUPP;
 	}
 
-	if (dissector_uses_key(flow->dissector,
-			       FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
-		struct flow_dissector_key_ipv4_addrs *mask_ipv4 = NULL;
-		struct flow_dissector_key_ports *mask_enc_ports = NULL;
-		struct flow_dissector_key_enc_opts *enc_op = NULL;
-		struct flow_dissector_key_ports *enc_ports = NULL;
-		struct flow_dissector_key_control *mask_enc_ctl =
-			skb_flow_dissector_target(flow->dissector,
-						  FLOW_DISSECTOR_KEY_ENC_CONTROL,
-						  flow->mask);
-		struct flow_dissector_key_control *enc_ctl =
-			skb_flow_dissector_target(flow->dissector,
-						  FLOW_DISSECTOR_KEY_ENC_CONTROL,
-						  flow->key);
-
-		if (mask_enc_ctl->addr_type != 0xffff ||
-		    enc_ctl->addr_type != FLOW_DISSECTOR_KEY_IPV4_ADDRS)
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
+		struct flow_match_enc_opts enc_op = { NULL, NULL };
+		struct flow_match_ipv4_addrs ipv4_addrs;
+		struct flow_match_control enc_ctl;
+		struct flow_match_ports enc_ports;
+
+		flow_rule_match_enc_control(rule, &enc_ctl);
+
+		if (enc_ctl.mask->addr_type != 0xffff ||
+		    enc_ctl.key->addr_type != FLOW_DISSECTOR_KEY_IPV4_ADDRS)
 			return -EOPNOTSUPP;
 
 		/* These fields are already verified as used. */
-		mask_ipv4 =
-			skb_flow_dissector_target(flow->dissector,
-						  FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS,
-						  flow->mask);
-		if (mask_ipv4->dst != cpu_to_be32(~0))
+		flow_rule_match_enc_ipv4_addrs(rule, &ipv4_addrs);
+		if (ipv4_addrs.mask->dst != cpu_to_be32(~0))
 			return -EOPNOTSUPP;
 
-		mask_enc_ports =
-			skb_flow_dissector_target(flow->dissector,
-						  FLOW_DISSECTOR_KEY_ENC_PORTS,
-						  flow->mask);
-		enc_ports =
-			skb_flow_dissector_target(flow->dissector,
-						  FLOW_DISSECTOR_KEY_ENC_PORTS,
-						  flow->key);
 
-		if (mask_enc_ports->dst != cpu_to_be16(~0))
+		flow_rule_match_enc_ports(rule, &enc_ports);
+		if (enc_ports.mask->dst != cpu_to_be16(~0))
 			return -EOPNOTSUPP;
 
-		if (dissector_uses_key(flow->dissector,
-				       FLOW_DISSECTOR_KEY_ENC_OPTS)) {
-			enc_op = skb_flow_dissector_target(flow->dissector,
-							   FLOW_DISSECTOR_KEY_ENC_OPTS,
-							   flow->key);
-		}
+		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_OPTS))
+			flow_rule_match_enc_opts(rule, &enc_op);
 
-		switch (enc_ports->dst) {
+		switch (enc_ports.key->dst) {
 		case htons(NFP_FL_VXLAN_PORT):
 			*tun_type = NFP_FL_TUNNEL_VXLAN;
 			key_layer |= NFP_FLOWER_LAYER_VXLAN;
 			key_size += sizeof(struct nfp_flower_ipv4_udp_tun);
 
-			if (enc_op)
+			if (enc_op.key)
 				return -EOPNOTSUPP;
 			break;
 		case htons(NFP_FL_GENEVE_PORT):
@@ -236,11 +213,11 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 			key_layer_two |= NFP_FLOWER_LAYER2_GENEVE;
 			key_size += sizeof(struct nfp_flower_ipv4_udp_tun);
 
-			if (!enc_op)
+			if (!enc_op.key)
 				break;
 			if (!(priv->flower_ext_feats & NFP_FL_FEATS_GENEVE_OPT))
 				return -EOPNOTSUPP;
-			err = nfp_flower_calc_opt_layer(enc_op, &key_layer_two,
+			err = nfp_flower_calc_opt_layer(&enc_op, &key_layer_two,
 							&key_size);
 			if (err)
 				return err;
@@ -254,19 +231,12 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 			return -EOPNOTSUPP;
 	}
 
-	if (dissector_uses_key(flow->dissector, FLOW_DISSECTOR_KEY_BASIC)) {
-		mask_basic = skb_flow_dissector_target(flow->dissector,
-						       FLOW_DISSECTOR_KEY_BASIC,
-						       flow->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC))
+		flow_rule_match_basic(rule, &basic);
 
-		key_basic = skb_flow_dissector_target(flow->dissector,
-						      FLOW_DISSECTOR_KEY_BASIC,
-						      flow->key);
-	}
-
-	if (mask_basic && mask_basic->n_proto) {
+	if (basic.mask && basic.mask->n_proto) {
 		/* Ethernet type is present in the key. */
-		switch (key_basic->n_proto) {
+		switch (basic.key->n_proto) {
 		case cpu_to_be16(ETH_P_IP):
 			key_layer |= NFP_FLOWER_LAYER_IPV4;
 			key_size += sizeof(struct nfp_flower_ipv4);
@@ -305,9 +275,9 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 		}
 	}
 
-	if (mask_basic && mask_basic->ip_proto) {
+	if (basic.mask && basic.mask->ip_proto) {
 		/* Ethernet type is present in the key. */
-		switch (key_basic->ip_proto) {
+		switch (basic.key->ip_proto) {
 		case IPPROTO_TCP:
 		case IPPROTO_UDP:
 		case IPPROTO_SCTP:
@@ -324,14 +294,12 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 		}
 	}
 
-	if (dissector_uses_key(flow->dissector, FLOW_DISSECTOR_KEY_TCP)) {
-		struct flow_dissector_key_tcp *tcp;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_TCP)) {
+		struct flow_match_tcp tcp;
 		u32 tcp_flags;
 
-		tcp = skb_flow_dissector_target(flow->dissector,
-						FLOW_DISSECTOR_KEY_TCP,
-						flow->key);
-		tcp_flags = be16_to_cpu(tcp->flags);
+		flow_rule_match_tcp(rule, &tcp);
+		tcp_flags = be16_to_cpu(tcp.key->flags);
 
 		if (tcp_flags & ~NFP_FLOWER_SUPPORTED_TCPFLAGS)
 			return -EOPNOTSUPP;
@@ -347,12 +315,12 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 		 * space, thus we need to ensure we include a IPv4/IPv6 key
 		 * layer if we have not done so already.
 		 */
-		if (!key_basic)
+		if (!basic.key)
 			return -EOPNOTSUPP;
 
 		if (!(key_layer & NFP_FLOWER_LAYER_IPV4) &&
 		    !(key_layer & NFP_FLOWER_LAYER_IPV6)) {
-			switch (key_basic->n_proto) {
+			switch (basic.key->n_proto) {
 			case cpu_to_be16(ETH_P_IP):
 				key_layer |= NFP_FLOWER_LAYER_IPV4;
 				key_size += sizeof(struct nfp_flower_ipv4);
@@ -369,14 +337,11 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 		}
 	}
 
-	if (dissector_uses_key(flow->dissector, FLOW_DISSECTOR_KEY_CONTROL)) {
-		struct flow_dissector_key_control *key_ctl;
-
-		key_ctl = skb_flow_dissector_target(flow->dissector,
-						    FLOW_DISSECTOR_KEY_CONTROL,
-						    flow->key);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
+		struct flow_match_control ctl;
 
-		if (key_ctl->flags & ~NFP_FLOWER_SUPPORTED_CTLFLAGS)
+		flow_rule_match_control(rule, &ctl);
+		if (ctl.key->flags & ~NFP_FLOWER_SUPPORTED_CTLFLAGS)
 			return -EOPNOTSUPP;
 	}
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index b16ce7d93caf..81d5b9304229 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -2033,24 +2033,20 @@ qede_tc_parse_ports(struct qede_dev *edev,
 		    struct tc_cls_flower_offload *f,
 		    struct qede_arfs_tuple *t)
 {
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_PORTS)) {
-		struct flow_dissector_key_ports *key, *mask;
-
-		key = skb_flow_dissector_target(f->dissector,
-						FLOW_DISSECTOR_KEY_PORTS,
-						f->key);
-		mask = skb_flow_dissector_target(f->dissector,
-						 FLOW_DISSECTOR_KEY_PORTS,
-						 f->mask);
-
-		if ((key->src && mask->src != U16_MAX) ||
-		    (key->dst && mask->dst != U16_MAX)) {
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports match;
+
+		flow_rule_match_ports(rule, &match);
+		if ((match.key->src && match.mask->src != U16_MAX) ||
+		    (match.key->dst && match.mask->dst != U16_MAX)) {
 			DP_NOTICE(edev, "Do not support ports masks\n");
 			return -EINVAL;
 		}
 
-		t->src_port = key->src;
-		t->dst_port = key->dst;
+		t->src_port = match.key->src;
+		t->dst_port = match.key->dst;
 	}
 
 	return 0;
@@ -2061,32 +2057,27 @@ qede_tc_parse_v6_common(struct qede_dev *edev,
 			struct tc_cls_flower_offload *f,
 			struct qede_arfs_tuple *t)
 {
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
 	struct in6_addr zero_addr, addr;
 
 	memset(&zero_addr, 0, sizeof(addr));
 	memset(&addr, 0xff, sizeof(addr));
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_IPV6_ADDRS)) {
-		struct flow_dissector_key_ipv6_addrs *key, *mask;
-
-		key = skb_flow_dissector_target(f->dissector,
-						FLOW_DISSECTOR_KEY_IPV6_ADDRS,
-						f->key);
-		mask = skb_flow_dissector_target(f->dissector,
-						 FLOW_DISSECTOR_KEY_IPV6_ADDRS,
-						 f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS)) {
+		struct flow_match_ipv6_addrs match;
 
-		if ((memcmp(&key->src, &zero_addr, sizeof(addr)) &&
-		     memcmp(&mask->src, &addr, sizeof(addr))) ||
-		    (memcmp(&key->dst, &zero_addr, sizeof(addr)) &&
-		     memcmp(&mask->dst, &addr, sizeof(addr)))) {
+		flow_rule_match_ipv6_addrs(rule, &match);
+		if ((memcmp(&match.key->src, &zero_addr, sizeof(addr)) &&
+		     memcmp(&match.mask->src, &addr, sizeof(addr))) ||
+		    (memcmp(&match.key->dst, &zero_addr, sizeof(addr)) &&
+		     memcmp(&match.mask->dst, &addr, sizeof(addr)))) {
 			DP_NOTICE(edev,
 				  "Do not support IPv6 address prefix/mask\n");
 			return -EINVAL;
 		}
 
-		memcpy(&t->src_ipv6, &key->src, sizeof(addr));
-		memcpy(&t->dst_ipv6, &key->dst, sizeof(addr));
+		memcpy(&t->src_ipv6, &match.key->src, sizeof(addr));
+		memcpy(&t->dst_ipv6, &match.key->dst, sizeof(addr));
 	}
 
 	if (qede_tc_parse_ports(edev, f, t))
@@ -2100,24 +2091,20 @@ qede_tc_parse_v4_common(struct qede_dev *edev,
 			struct tc_cls_flower_offload *f,
 			struct qede_arfs_tuple *t)
 {
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
-		struct flow_dissector_key_ipv4_addrs *key, *mask;
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
 
-		key = skb_flow_dissector_target(f->dissector,
-						FLOW_DISSECTOR_KEY_IPV4_ADDRS,
-						f->key);
-		mask = skb_flow_dissector_target(f->dissector,
-						 FLOW_DISSECTOR_KEY_IPV4_ADDRS,
-						 f->mask);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
+		struct flow_match_ipv4_addrs match;
 
-		if ((key->src && mask->src != U32_MAX) ||
-		    (key->dst && mask->dst != U32_MAX)) {
+		flow_rule_match_ipv4_addrs(rule, &match);
+		if ((match.key->src && match.mask->src != U32_MAX) ||
+		    (match.key->dst && match.mask->dst != U32_MAX)) {
 			DP_NOTICE(edev, "Do not support ipv4 prefix/masks\n");
 			return -EINVAL;
 		}
 
-		t->src_ipv4 = key->src;
-		t->dst_ipv4 = key->dst;
+		t->src_ipv4 = match.key->src;
+		t->dst_ipv4 = match.key->dst;
 	}
 
 	if (qede_tc_parse_ports(edev, f, t))
@@ -2175,19 +2162,21 @@ qede_parse_flower_attr(struct qede_dev *edev, __be16 proto,
 		       struct tc_cls_flower_offload *f,
 		       struct qede_arfs_tuple *tuple)
 {
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_dissector *dissector = rule->match.dissector;
 	int rc = -EINVAL;
 	u8 ip_proto = 0;
 
 	memset(tuple, 0, sizeof(*tuple));
 
-	if (f->dissector->used_keys &
+	if (dissector->used_keys &
 	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 	      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
 	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
 	      BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS) |
 	      BIT(FLOW_DISSECTOR_KEY_PORTS))) {
 		DP_NOTICE(edev, "Unsupported key set:0x%x\n",
-			  f->dissector->used_keys);
+			  dissector->used_keys);
 		return -EOPNOTSUPP;
 	}
 
@@ -2197,13 +2186,11 @@ qede_parse_flower_attr(struct qede_dev *edev, __be16 proto,
 		return -EPROTONOSUPPORT;
 	}
 
-	if (dissector_uses_key(f->dissector, FLOW_DISSECTOR_KEY_BASIC)) {
-		struct flow_dissector_key_basic *key;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
 
-		key = skb_flow_dissector_target(f->dissector,
-						FLOW_DISSECTOR_KEY_BASIC,
-						f->key);
-		ip_proto = key->ip_proto;
+		flow_rule_match_basic(rule, &match);
+		ip_proto = match.key->ip_proto;
 	}
 
 	if (ip_proto == IPPROTO_TCP && proto == htons(ETH_P_IP))
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
new file mode 100644
index 000000000000..461c66595763
--- /dev/null
+++ b/include/net/flow_offload.h
@@ -0,0 +1,115 @@
+#ifndef _NET_FLOW_OFFLOAD_H
+#define _NET_FLOW_OFFLOAD_H
+
+#include <net/flow_dissector.h>
+
+struct flow_match {
+	struct flow_dissector	*dissector;
+	void			*mask;
+	void			*key;
+};
+
+struct flow_match_basic {
+	struct flow_dissector_key_basic *key, *mask;
+};
+
+struct flow_match_control {
+	struct flow_dissector_key_control *key, *mask;
+};
+
+struct flow_match_eth_addrs {
+	struct flow_dissector_key_eth_addrs *key, *mask;
+};
+
+struct flow_match_vlan {
+	struct flow_dissector_key_vlan *key, *mask;
+};
+
+struct flow_match_ipv4_addrs {
+	struct flow_dissector_key_ipv4_addrs *key, *mask;
+};
+
+struct flow_match_ipv6_addrs {
+	struct flow_dissector_key_ipv6_addrs *key, *mask;
+};
+
+struct flow_match_ip {
+	struct flow_dissector_key_ip *key, *mask;
+};
+
+struct flow_match_ports {
+	struct flow_dissector_key_ports *key, *mask;
+};
+
+struct flow_match_icmp {
+	struct flow_dissector_key_icmp *key, *mask;
+};
+
+struct flow_match_tcp {
+	struct flow_dissector_key_tcp *key, *mask;
+};
+
+struct flow_match_mpls {
+	struct flow_dissector_key_mpls *key, *mask;
+};
+
+struct flow_match_enc_keyid {
+	struct flow_dissector_key_keyid *key, *mask;
+};
+
+struct flow_match_enc_opts {
+	struct flow_dissector_key_enc_opts *key, *mask;
+};
+
+struct flow_rule;
+
+void flow_rule_match_basic(const struct flow_rule *rule,
+			   struct flow_match_basic *out);
+void flow_rule_match_control(const struct flow_rule *rule,
+			     struct flow_match_control *out);
+void flow_rule_match_eth_addrs(const struct flow_rule *rule,
+			       struct flow_match_eth_addrs *out);
+void flow_rule_match_vlan(const struct flow_rule *rule,
+			  struct flow_match_vlan *out);
+void flow_rule_match_ipv4_addrs(const struct flow_rule *rule,
+				struct flow_match_ipv4_addrs *out);
+void flow_rule_match_ipv6_addrs(const struct flow_rule *rule,
+				struct flow_match_ipv6_addrs *out);
+void flow_rule_match_ip(const struct flow_rule *rule,
+			struct flow_match_ip *out);
+void flow_rule_match_ports(const struct flow_rule *rule,
+			   struct flow_match_ports *out);
+void flow_rule_match_tcp(const struct flow_rule *rule,
+			 struct flow_match_tcp *out);
+void flow_rule_match_icmp(const struct flow_rule *rule,
+			  struct flow_match_icmp *out);
+void flow_rule_match_mpls(const struct flow_rule *rule,
+			  struct flow_match_mpls *out);
+void flow_rule_match_enc_control(const struct flow_rule *rule,
+				 struct flow_match_control *out);
+void flow_rule_match_enc_ipv4_addrs(const struct flow_rule *rule,
+				    struct flow_match_ipv4_addrs *out);
+void flow_rule_match_enc_ipv6_addrs(const struct flow_rule *rule,
+				    struct flow_match_ipv6_addrs *out);
+void flow_rule_match_enc_ip(const struct flow_rule *rule,
+			    struct flow_match_ip *out);
+void flow_rule_match_enc_ports(const struct flow_rule *rule,
+			       struct flow_match_ports *out);
+void flow_rule_match_enc_keyid(const struct flow_rule *rule,
+			       struct flow_match_enc_keyid *out);
+void flow_rule_match_enc_opts(const struct flow_rule *rule,
+			      struct flow_match_enc_opts *out);
+
+struct flow_rule {
+	struct flow_match	match;
+};
+
+struct flow_rule *flow_rule_alloc(void);
+
+static inline bool flow_rule_match_key(const struct flow_rule *rule,
+				       enum flow_dissector_key_id key)
+{
+	return dissector_uses_key(rule->match.dissector, key);
+}
+
+#endif /* _NET_FLOW_OFFLOAD_H */
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 40965fbbcd31..04b64523cc32 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -6,6 +6,7 @@
 #include <linux/workqueue.h>
 #include <net/sch_generic.h>
 #include <net/act_api.h>
+#include <net/flow_offload.h>
 
 /* TC action not accessible from user space */
 #define TC_ACT_REINSERT		(TC_ACT_VALUE_MAX + 1)
@@ -760,13 +761,17 @@ struct tc_cls_flower_offload {
 	struct tc_cls_common_offload common;
 	enum tc_fl_command command;
 	unsigned long cookie;
-	struct flow_dissector *dissector;
-	struct fl_flow_key *mask;
-	struct fl_flow_key *key;
+	struct flow_rule *rule;
 	struct tcf_exts *exts;
 	u32 classid;
 };
 
+static inline struct flow_rule *
+tc_cls_flower_offload_flow_rule(struct tc_cls_flower_offload *tc_flow_cmd)
+{
+	return tc_flow_cmd->rule;
+}
+
 enum tc_matchall_command {
 	TC_CLSMATCHALL_REPLACE,
 	TC_CLSMATCHALL_DESTROY,
diff --git a/net/core/Makefile b/net/core/Makefile
index fccd31e0e7f7..f97d6254e564 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_SYSCTL) += sysctl_net_core.o
 obj-y		     += dev.o ethtool.o dev_addr_lists.o dst.o netevent.o \
 			neighbour.o rtnetlink.o utils.o link_watch.o filter.o \
 			sock_diag.o dev_ioctl.o tso.o sock_reuseport.o \
-			fib_notifier.o xdp.o
+			fib_notifier.o xdp.o flow_offload.o
 
 obj-y += net-sysfs.o
 obj-$(CONFIG_PAGE_POOL) += page_pool.o
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
new file mode 100644
index 000000000000..2fbf6903d2f6
--- /dev/null
+++ b/net/core/flow_offload.c
@@ -0,0 +1,143 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <net/flow_offload.h>
+
+struct flow_rule *flow_rule_alloc(void)
+{
+	return kzalloc(sizeof(struct flow_rule), GFP_KERNEL);
+}
+EXPORT_SYMBOL(flow_rule_alloc);
+
+#define FLOW_DISSECTOR_MATCH(__rule, __type, __out)				\
+	const struct flow_match *__m = &(__rule)->match;			\
+	struct flow_dissector *__d = (__m)->dissector;				\
+										\
+	(__out)->key = skb_flow_dissector_target(__d, __type, (__m)->key);	\
+	(__out)->mask = skb_flow_dissector_target(__d, __type, (__m)->mask);	\
+
+void flow_rule_match_basic(const struct flow_rule *rule,
+			   struct flow_match_basic *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_BASIC, out);
+}
+EXPORT_SYMBOL(flow_rule_match_basic);
+
+void flow_rule_match_control(const struct flow_rule *rule,
+			     struct flow_match_control *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_CONTROL, out);
+}
+EXPORT_SYMBOL(flow_rule_match_control);
+
+void flow_rule_match_eth_addrs(const struct flow_rule *rule,
+			       struct flow_match_eth_addrs *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS, out);
+}
+EXPORT_SYMBOL(flow_rule_match_eth_addrs);
+
+void flow_rule_match_vlan(const struct flow_rule *rule,
+			  struct flow_match_vlan *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_VLAN, out);
+}
+EXPORT_SYMBOL(flow_rule_match_vlan);
+
+void flow_rule_match_ipv4_addrs(const struct flow_rule *rule,
+				struct flow_match_ipv4_addrs *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS, out);
+}
+EXPORT_SYMBOL(flow_rule_match_ipv4_addrs);
+
+void flow_rule_match_ipv6_addrs(const struct flow_rule *rule,
+				struct flow_match_ipv6_addrs *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS, out);
+}
+EXPORT_SYMBOL(flow_rule_match_ipv6_addrs);
+
+void flow_rule_match_ip(const struct flow_rule *rule,
+			struct flow_match_ip *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_IP, out);
+}
+EXPORT_SYMBOL(flow_rule_match_ip);
+
+void flow_rule_match_ports(const struct flow_rule *rule,
+			   struct flow_match_ports *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_PORTS, out);
+}
+EXPORT_SYMBOL(flow_rule_match_ports);
+
+void flow_rule_match_tcp(const struct flow_rule *rule,
+			 struct flow_match_tcp *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_TCP, out);
+}
+EXPORT_SYMBOL(flow_rule_match_tcp);
+
+void flow_rule_match_icmp(const struct flow_rule *rule,
+			  struct flow_match_icmp *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ICMP, out);
+}
+EXPORT_SYMBOL(flow_rule_match_icmp);
+
+void flow_rule_match_mpls(const struct flow_rule *rule,
+			  struct flow_match_mpls *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_MPLS, out);
+}
+EXPORT_SYMBOL(flow_rule_match_mpls);
+
+void flow_rule_match_enc_control(const struct flow_rule *rule,
+				 struct flow_match_control *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL, out);
+}
+EXPORT_SYMBOL(flow_rule_match_enc_control);
+
+void flow_rule_match_enc_ipv4_addrs(const struct flow_rule *rule,
+				    struct flow_match_ipv4_addrs *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS, out);
+}
+EXPORT_SYMBOL(flow_rule_match_enc_ipv4_addrs);
+
+void flow_rule_match_enc_ipv6_addrs(const struct flow_rule *rule,
+				    struct flow_match_ipv6_addrs *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS, out);
+}
+EXPORT_SYMBOL(flow_rule_match_enc_ipv6_addrs);
+
+void flow_rule_match_enc_ip(const struct flow_rule *rule,
+			    struct flow_match_ip *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_IP, out);
+}
+EXPORT_SYMBOL(flow_rule_match_enc_ip);
+
+void flow_rule_match_enc_ports(const struct flow_rule *rule,
+			       struct flow_match_ports *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_PORTS, out);
+}
+EXPORT_SYMBOL(flow_rule_match_enc_ports);
+
+void flow_rule_match_enc_keyid(const struct flow_rule *rule,
+			       struct flow_match_enc_keyid *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_KEYID, out);
+}
+EXPORT_SYMBOL(flow_rule_match_enc_keyid);
+
+void flow_rule_match_enc_opts(const struct flow_rule *rule,
+			      struct flow_match_enc_opts *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_OPTS, out);
+}
+EXPORT_SYMBOL(flow_rule_match_enc_opts);
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index f6aa57fbbbaf..aaffea0b66e9 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -381,16 +381,22 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 	bool skip_sw = tc_skip_sw(f->flags);
 	int err;
 
+	cls_flower.rule = flow_rule_alloc();
+	if (!cls_flower.rule)
+		return -ENOMEM;
+
 	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, extack);
 	cls_flower.command = TC_CLSFLOWER_REPLACE;
 	cls_flower.cookie = (unsigned long) f;
-	cls_flower.dissector = &f->mask->dissector;
-	cls_flower.mask = &f->mask->key;
-	cls_flower.key = &f->mkey;
+	cls_flower.rule->match.dissector = &f->mask->dissector;
+	cls_flower.rule->match.mask = &f->mask->key;
+	cls_flower.rule->match.key = &f->mkey;
 	cls_flower.exts = &f->exts;
 	cls_flower.classid = f->res.classid;
 
 	err = tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, skip_sw);
+	kfree(cls_flower.rule);
+
 	if (err < 0) {
 		fl_hw_destroy_filter(tp, f, NULL);
 		return err;
@@ -1463,18 +1469,24 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 			if (tc_skip_hw(f->flags))
 				continue;
 
+			cls_flower.rule = flow_rule_alloc();
+			if (!cls_flower.rule)
+				return -ENOMEM;
+
 			tc_cls_common_offload_init(&cls_flower.common, tp,
 						   f->flags, extack);
 			cls_flower.command = add ?
 				TC_CLSFLOWER_REPLACE : TC_CLSFLOWER_DESTROY;
 			cls_flower.cookie = (unsigned long)f;
-			cls_flower.dissector = &mask->dissector;
-			cls_flower.mask = &mask->key;
-			cls_flower.key = &f->mkey;
+			cls_flower.rule->match.dissector = &mask->dissector;
+			cls_flower.rule->match.mask = &mask->key;
+			cls_flower.rule->match.key = &f->mkey;
 			cls_flower.exts = &f->exts;
 			cls_flower.classid = f->res.classid;
 
 			err = cb(TC_SETUP_CLSFLOWER, &cls_flower, cb_priv);
+			kfree(cls_flower.rule);
+
 			if (err) {
 				if (add && tc_skip_sw(f->flags))
 					return err;
@@ -1489,25 +1501,32 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 	return 0;
 }
 
-static void fl_hw_create_tmplt(struct tcf_chain *chain,
-			       struct fl_flow_tmplt *tmplt)
+static int fl_hw_create_tmplt(struct tcf_chain *chain,
+			      struct fl_flow_tmplt *tmplt)
 {
 	struct tc_cls_flower_offload cls_flower = {};
 	struct tcf_block *block = chain->block;
 	struct tcf_exts dummy_exts = { 0, };
 
+	cls_flower.rule = flow_rule_alloc();
+	if (!cls_flower.rule)
+		return -ENOMEM;
+
 	cls_flower.common.chain_index = chain->index;
 	cls_flower.command = TC_CLSFLOWER_TMPLT_CREATE;
 	cls_flower.cookie = (unsigned long) tmplt;
-	cls_flower.dissector = &tmplt->dissector;
-	cls_flower.mask = &tmplt->mask;
-	cls_flower.key = &tmplt->dummy_key;
+	cls_flower.rule->match.dissector = &tmplt->dissector;
+	cls_flower.rule->match.mask = &tmplt->mask;
+	cls_flower.rule->match.key = &tmplt->dummy_key;
 	cls_flower.exts = &dummy_exts;
 
 	/* We don't care if driver (any of them) fails to handle this
 	 * call. It serves just as a hint for it.
 	 */
 	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false);
+	kfree(cls_flower.rule);
+
+	return 0;
 }
 
 static void fl_hw_destroy_tmplt(struct tcf_chain *chain,
@@ -1551,12 +1570,14 @@ static void *fl_tmplt_create(struct net *net, struct tcf_chain *chain,
 	err = fl_set_key(net, tb, &tmplt->dummy_key, &tmplt->mask, extack);
 	if (err)
 		goto errout_tmplt;
-	kfree(tb);
 
 	fl_init_dissector(&tmplt->dissector, &tmplt->mask);
 
-	fl_hw_create_tmplt(chain, tmplt);
+	err = fl_hw_create_tmplt(chain, tmplt);
+	if (err)
+		goto errout_tmplt;
 
+	kfree(tb);
 	return tmplt;
 
 errout_tmplt:
-- 
2.11.0
