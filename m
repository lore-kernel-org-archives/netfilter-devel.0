From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/12 net-next,v7] drivers: net: use flow action infrastructure
Date: Sat,  2 Feb 2019 12:50:48 +0100
Message-ID: <20190202115054.4880-7-pablo@netfilter.org>
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

This patch updates drivers to use the new flow action infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v7: rebase on top of net-next. Dropping previous Acked-by tags since
    this one is slightly large, and it would be good another look after
    this rebase.

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       |  74 +++---
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   | 250 +++++++++----------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 265 ++++++++++-----------
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |  54 +++--
 drivers/net/ethernet/netronome/nfp/flower/action.c | 187 ++++++++-------
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |  12 +-
 7 files changed, 418 insertions(+), 426 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 6a87434b7173..7a1fdad1aea6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -61,9 +61,9 @@ static u16 bnxt_flow_get_dst_fid(struct bnxt *pf_bp, struct net_device *dev)
 
 static int bnxt_tc_parse_redir(struct bnxt *bp,
 			       struct bnxt_tc_actions *actions,
-			       const struct tc_action *tc_act)
+			       const struct flow_action_entry *act)
 {
-	struct net_device *dev = tcf_mirred_dev(tc_act);
+	struct net_device *dev = act->dev;
 
 	if (!dev) {
 		netdev_info(bp->dev, "no dev in mirred action");
@@ -77,16 +77,16 @@ static int bnxt_tc_parse_redir(struct bnxt *bp,
 
 static int bnxt_tc_parse_vlan(struct bnxt *bp,
 			      struct bnxt_tc_actions *actions,
-			      const struct tc_action *tc_act)
+			      const struct flow_action_entry *act)
 {
-	switch (tcf_vlan_action(tc_act)) {
-	case TCA_VLAN_ACT_POP:
+	switch (act->id) {
+	case FLOW_ACTION_VLAN_POP:
 		actions->flags |= BNXT_TC_ACTION_FLAG_POP_VLAN;
 		break;
-	case TCA_VLAN_ACT_PUSH:
+	case FLOW_ACTION_VLAN_PUSH:
 		actions->flags |= BNXT_TC_ACTION_FLAG_PUSH_VLAN;
-		actions->push_vlan_tci = htons(tcf_vlan_push_vid(tc_act));
-		actions->push_vlan_tpid = tcf_vlan_push_proto(tc_act);
+		actions->push_vlan_tci = htons(act->vlan.vid);
+		actions->push_vlan_tpid = act->vlan.proto;
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -96,10 +96,10 @@ static int bnxt_tc_parse_vlan(struct bnxt *bp,
 
 static int bnxt_tc_parse_tunnel_set(struct bnxt *bp,
 				    struct bnxt_tc_actions *actions,
-				    const struct tc_action *tc_act)
+				    const struct flow_action_entry *act)
 {
-	struct ip_tunnel_info *tun_info = tcf_tunnel_info(tc_act);
-	struct ip_tunnel_key *tun_key = &tun_info->key;
+	const struct ip_tunnel_info *tun_info = act->tunnel;
+	const struct ip_tunnel_key *tun_key = &tun_info->key;
 
 	if (ip_tunnel_info_af(tun_info) != AF_INET) {
 		netdev_info(bp->dev, "only IPv4 tunnel-encap is supported");
@@ -113,51 +113,43 @@ static int bnxt_tc_parse_tunnel_set(struct bnxt *bp,
 
 static int bnxt_tc_parse_actions(struct bnxt *bp,
 				 struct bnxt_tc_actions *actions,
-				 struct tcf_exts *tc_exts)
+				 struct flow_action *flow_action)
 {
-	const struct tc_action *tc_act;
+	struct flow_action_entry *act;
 	int i, rc;
 
-	if (!tcf_exts_has_actions(tc_exts)) {
+	if (!flow_action_has_entries(flow_action)) {
 		netdev_info(bp->dev, "no actions");
 		return -EINVAL;
 	}
 
-	tcf_exts_for_each_action(i, tc_act, tc_exts) {
-		/* Drop action */
-		if (is_tcf_gact_shot(tc_act)) {
+	flow_action_for_each(i, act, flow_action) {
+		switch (act->id) {
+		case FLOW_ACTION_DROP:
 			actions->flags |= BNXT_TC_ACTION_FLAG_DROP;
 			return 0; /* don't bother with other actions */
-		}
-
-		/* Redirect action */
-		if (is_tcf_mirred_egress_redirect(tc_act)) {
-			rc = bnxt_tc_parse_redir(bp, actions, tc_act);
+		case FLOW_ACTION_REDIRECT:
+			rc = bnxt_tc_parse_redir(bp, actions, act);
 			if (rc)
 				return rc;
-			continue;
-		}
-
-		/* Push/pop VLAN */
-		if (is_tcf_vlan(tc_act)) {
-			rc = bnxt_tc_parse_vlan(bp, actions, tc_act);
+			break;
+		case FLOW_ACTION_VLAN_POP:
+		case FLOW_ACTION_VLAN_PUSH:
+		case FLOW_ACTION_VLAN_MANGLE:
+			rc = bnxt_tc_parse_vlan(bp, actions, act);
 			if (rc)
 				return rc;
-			continue;
-		}
-
-		/* Tunnel encap */
-		if (is_tcf_tunnel_set(tc_act)) {
-			rc = bnxt_tc_parse_tunnel_set(bp, actions, tc_act);
+			break;
+		case FLOW_ACTION_TUNNEL_ENCAP:
+			rc = bnxt_tc_parse_tunnel_set(bp, actions, act);
 			if (rc)
 				return rc;
-			continue;
-		}
-
-		/* Tunnel decap */
-		if (is_tcf_tunnel_release(tc_act)) {
+			break;
+		case FLOW_ACTION_TUNNEL_DECAP:
 			actions->flags |= BNXT_TC_ACTION_FLAG_TUNNEL_DECAP;
-			continue;
+			break;
+		default:
+			break;
 		}
 	}
 
@@ -308,7 +300,7 @@ static int bnxt_tc_parse_flow(struct bnxt *bp,
 		flow->tun_mask.tp_src = match.mask->src;
 	}
 
-	return bnxt_tc_parse_actions(bp, &flow->actions, tc_flow_cmd->exts);
+	return bnxt_tc_parse_actions(bp, &flow->actions, &rule->action);
 }
 
 static int bnxt_hwrm_cfa_flow_free(struct bnxt *bp,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 8a2d66ee1d7b..82a8d1970060 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -292,7 +292,7 @@ static void process_pedit_field(struct ch_filter_specification *fs, u32 val,
 				u32 mask, u32 offset, u8 htype)
 {
 	switch (htype) {
-	case TCA_PEDIT_KEY_EX_HDR_TYPE_ETH:
+	case FLOW_ACT_MANGLE_HDR_TYPE_ETH:
 		switch (offset) {
 		case PEDIT_ETH_DMAC_31_0:
 			fs->newdmac = 1;
@@ -310,7 +310,7 @@ static void process_pedit_field(struct ch_filter_specification *fs, u32 val,
 			offload_pedit(fs, val, mask, ETH_SMAC_47_16);
 		}
 		break;
-	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP4:
+	case FLOW_ACT_MANGLE_HDR_TYPE_IP4:
 		switch (offset) {
 		case PEDIT_IP4_SRC:
 			offload_pedit(fs, val, mask, IP4_SRC);
@@ -320,7 +320,7 @@ static void process_pedit_field(struct ch_filter_specification *fs, u32 val,
 		}
 		fs->nat_mode = NAT_MODE_ALL;
 		break;
-	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP6:
+	case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
 		switch (offset) {
 		case PEDIT_IP6_SRC_31_0:
 			offload_pedit(fs, val, mask, IP6_SRC_31_0);
@@ -348,7 +348,7 @@ static void process_pedit_field(struct ch_filter_specification *fs, u32 val,
 		}
 		fs->nat_mode = NAT_MODE_ALL;
 		break;
-	case TCA_PEDIT_KEY_EX_HDR_TYPE_TCP:
+	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
 		switch (offset) {
 		case PEDIT_TCP_SPORT_DPORT:
 			if (~mask & PEDIT_TCP_UDP_SPORT_MASK)
@@ -361,7 +361,7 @@ static void process_pedit_field(struct ch_filter_specification *fs, u32 val,
 		}
 		fs->nat_mode = NAT_MODE_ALL;
 		break;
-	case TCA_PEDIT_KEY_EX_HDR_TYPE_UDP:
+	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
 		switch (offset) {
 		case PEDIT_UDP_SPORT_DPORT:
 			if (~mask & PEDIT_TCP_UDP_SPORT_MASK)
@@ -380,56 +380,63 @@ static void cxgb4_process_flow_actions(struct net_device *in,
 				       struct tc_cls_flower_offload *cls,
 				       struct ch_filter_specification *fs)
 {
-	const struct tc_action *a;
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(cls);
+	struct flow_action_entry *act;
 	int i;
 
-	tcf_exts_for_each_action(i, a, cls->exts) {
-		if (is_tcf_gact_ok(a)) {
+	flow_action_for_each(i, act, &rule->action) {
+		switch (act->id) {
+		case FLOW_ACTION_ACCEPT:
 			fs->action = FILTER_PASS;
-		} else if (is_tcf_gact_shot(a)) {
+			break;
+		case FLOW_ACTION_DROP:
 			fs->action = FILTER_DROP;
-		} else if (is_tcf_mirred_egress_redirect(a)) {
-			struct net_device *out = tcf_mirred_dev(a);
+			break;
+		case FLOW_ACTION_REDIRECT: {
+			struct net_device *out = act->dev;
 			struct port_info *pi = netdev_priv(out);
 
 			fs->action = FILTER_SWITCH;
 			fs->eport = pi->port_id;
-		} else if (is_tcf_vlan(a)) {
-			u32 vlan_action = tcf_vlan_action(a);
-			u8 prio = tcf_vlan_push_prio(a);
-			u16 vid = tcf_vlan_push_vid(a);
+			}
+			break;
+		case FLOW_ACTION_VLAN_POP:
+		case FLOW_ACTION_VLAN_PUSH:
+		case FLOW_ACTION_VLAN_MANGLE: {
+			u8 prio = act->vlan.prio;
+			u16 vid = act->vlan.vid;
 			u16 vlan_tci = (prio << VLAN_PRIO_SHIFT) | vid;
-
-			switch (vlan_action) {
-			case TCA_VLAN_ACT_POP:
+			switch (act->id) {
+			case FLOW_ACTION_VLAN_POP:
 				fs->newvlan |= VLAN_REMOVE;
 				break;
-			case TCA_VLAN_ACT_PUSH:
+			case FLOW_ACTION_VLAN_PUSH:
 				fs->newvlan |= VLAN_INSERT;
 				fs->vlan = vlan_tci;
 				break;
-			case TCA_VLAN_ACT_MODIFY:
+			case FLOW_ACTION_VLAN_MANGLE:
 				fs->newvlan |= VLAN_REWRITE;
 				fs->vlan = vlan_tci;
 				break;
 			default:
 				break;
 			}
-		} else if (is_tcf_pedit(a)) {
+			}
+			break;
+		case FLOW_ACTION_MANGLE: {
 			u32 mask, val, offset;
-			int nkeys, i;
 			u8 htype;
 
-			nkeys = tcf_pedit_nkeys(a);
-			for (i = 0; i < nkeys; i++) {
-				htype = tcf_pedit_htype(a, i);
-				mask = tcf_pedit_mask(a, i);
-				val = tcf_pedit_val(a, i);
-				offset = tcf_pedit_offset(a, i);
+			htype = act->mangle.htype;
+			mask = act->mangle.mask;
+			val = act->mangle.val;
+			offset = act->mangle.offset;
 
-				process_pedit_field(fs, val, mask, offset,
-						    htype);
+			process_pedit_field(fs, val, mask, offset, htype);
 			}
+			break;
+		default:
+			break;
 		}
 	}
 }
@@ -448,101 +455,89 @@ static bool valid_l4_mask(u32 mask)
 }
 
 static bool valid_pedit_action(struct net_device *dev,
-			       const struct tc_action *a)
+			       const struct flow_action_entry *act)
 {
 	u32 mask, offset;
-	u8 cmd, htype;
-	int nkeys, i;
-
-	nkeys = tcf_pedit_nkeys(a);
-	for (i = 0; i < nkeys; i++) {
-		htype = tcf_pedit_htype(a, i);
-		cmd = tcf_pedit_cmd(a, i);
-		mask = tcf_pedit_mask(a, i);
-		offset = tcf_pedit_offset(a, i);
-
-		if (cmd != TCA_PEDIT_KEY_EX_CMD_SET) {
-			netdev_err(dev, "%s: Unsupported pedit cmd\n",
+	u8 htype;
+
+	htype = act->mangle.htype;
+	mask = act->mangle.mask;
+	offset = act->mangle.offset;
+
+	switch (htype) {
+	case FLOW_ACT_MANGLE_HDR_TYPE_ETH:
+		switch (offset) {
+		case PEDIT_ETH_DMAC_31_0:
+		case PEDIT_ETH_DMAC_47_32_SMAC_15_0:
+		case PEDIT_ETH_SMAC_47_16:
+			break;
+		default:
+			netdev_err(dev, "%s: Unsupported pedit field\n",
 				   __func__);
 			return false;
 		}
-
-		switch (htype) {
-		case TCA_PEDIT_KEY_EX_HDR_TYPE_ETH:
-			switch (offset) {
-			case PEDIT_ETH_DMAC_31_0:
-			case PEDIT_ETH_DMAC_47_32_SMAC_15_0:
-			case PEDIT_ETH_SMAC_47_16:
-				break;
-			default:
-				netdev_err(dev, "%s: Unsupported pedit field\n",
-					   __func__);
-				return false;
-			}
-			break;
-		case TCA_PEDIT_KEY_EX_HDR_TYPE_IP4:
-			switch (offset) {
-			case PEDIT_IP4_SRC:
-			case PEDIT_IP4_DST:
-				break;
-			default:
-				netdev_err(dev, "%s: Unsupported pedit field\n",
-					   __func__);
-				return false;
-			}
+		break;
+	case FLOW_ACT_MANGLE_HDR_TYPE_IP4:
+		switch (offset) {
+		case PEDIT_IP4_SRC:
+		case PEDIT_IP4_DST:
 			break;
-		case TCA_PEDIT_KEY_EX_HDR_TYPE_IP6:
-			switch (offset) {
-			case PEDIT_IP6_SRC_31_0:
-			case PEDIT_IP6_SRC_63_32:
-			case PEDIT_IP6_SRC_95_64:
-			case PEDIT_IP6_SRC_127_96:
-			case PEDIT_IP6_DST_31_0:
-			case PEDIT_IP6_DST_63_32:
-			case PEDIT_IP6_DST_95_64:
-			case PEDIT_IP6_DST_127_96:
-				break;
-			default:
-				netdev_err(dev, "%s: Unsupported pedit field\n",
-					   __func__);
-				return false;
-			}
+		default:
+			netdev_err(dev, "%s: Unsupported pedit field\n",
+				   __func__);
+			return false;
+		}
+		break;
+	case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
+		switch (offset) {
+		case PEDIT_IP6_SRC_31_0:
+		case PEDIT_IP6_SRC_63_32:
+		case PEDIT_IP6_SRC_95_64:
+		case PEDIT_IP6_SRC_127_96:
+		case PEDIT_IP6_DST_31_0:
+		case PEDIT_IP6_DST_63_32:
+		case PEDIT_IP6_DST_95_64:
+		case PEDIT_IP6_DST_127_96:
 			break;
-		case TCA_PEDIT_KEY_EX_HDR_TYPE_TCP:
-			switch (offset) {
-			case PEDIT_TCP_SPORT_DPORT:
-				if (!valid_l4_mask(~mask)) {
-					netdev_err(dev, "%s: Unsupported mask for TCP L4 ports\n",
-						   __func__);
-					return false;
-				}
-				break;
-			default:
-				netdev_err(dev, "%s: Unsupported pedit field\n",
+		default:
+			netdev_err(dev, "%s: Unsupported pedit field\n",
+				   __func__);
+			return false;
+		}
+		break;
+	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
+		switch (offset) {
+		case PEDIT_TCP_SPORT_DPORT:
+			if (!valid_l4_mask(~mask)) {
+				netdev_err(dev, "%s: Unsupported mask for TCP L4 ports\n",
 					   __func__);
 				return false;
 			}
 			break;
-		case TCA_PEDIT_KEY_EX_HDR_TYPE_UDP:
-			switch (offset) {
-			case PEDIT_UDP_SPORT_DPORT:
-				if (!valid_l4_mask(~mask)) {
-					netdev_err(dev, "%s: Unsupported mask for UDP L4 ports\n",
-						   __func__);
-					return false;
-				}
-				break;
-			default:
-				netdev_err(dev, "%s: Unsupported pedit field\n",
+		default:
+			netdev_err(dev, "%s: Unsupported pedit field\n",
+				   __func__);
+			return false;
+		}
+		break;
+	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
+		switch (offset) {
+		case PEDIT_UDP_SPORT_DPORT:
+			if (!valid_l4_mask(~mask)) {
+				netdev_err(dev, "%s: Unsupported mask for UDP L4 ports\n",
 					   __func__);
 				return false;
 			}
 			break;
 		default:
-			netdev_err(dev, "%s: Unsupported pedit type\n",
+			netdev_err(dev, "%s: Unsupported pedit field\n",
 				   __func__);
 			return false;
 		}
+		break;
+	default:
+		netdev_err(dev, "%s: Unsupported pedit type\n", __func__);
+		return false;
 	}
 	return true;
 }
@@ -550,24 +545,26 @@ static bool valid_pedit_action(struct net_device *dev,
 static int cxgb4_validate_flow_actions(struct net_device *dev,
 				       struct tc_cls_flower_offload *cls)
 {
-	const struct tc_action *a;
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(cls);
+	struct flow_action_entry *act;
 	bool act_redir = false;
 	bool act_pedit = false;
 	bool act_vlan = false;
 	int i;
 
-	tcf_exts_for_each_action(i, a, cls->exts) {
-		if (is_tcf_gact_ok(a)) {
-			/* Do nothing */
-		} else if (is_tcf_gact_shot(a)) {
+	flow_action_for_each(i, act, &rule->action) {
+		switch (act->id) {
+		case FLOW_ACTION_ACCEPT:
+		case FLOW_ACTION_DROP:
 			/* Do nothing */
-		} else if (is_tcf_mirred_egress_redirect(a)) {
+			break;
+		case FLOW_ACTION_REDIRECT: {
 			struct adapter *adap = netdev2adap(dev);
 			struct net_device *n_dev, *target_dev;
 			unsigned int i;
 			bool found = false;
 
-			target_dev = tcf_mirred_dev(a);
+			target_dev = act->dev;
 			for_each_port(adap, i) {
 				n_dev = adap->port[i];
 				if (target_dev == n_dev) {
@@ -585,15 +582,18 @@ static int cxgb4_validate_flow_actions(struct net_device *dev,
 				return -EINVAL;
 			}
 			act_redir = true;
-		} else if (is_tcf_vlan(a)) {
-			u16 proto = be16_to_cpu(tcf_vlan_push_proto(a));
-			u32 vlan_action = tcf_vlan_action(a);
+			}
+			break;
+		case FLOW_ACTION_VLAN_POP:
+		case FLOW_ACTION_VLAN_PUSH:
+		case FLOW_ACTION_VLAN_MANGLE: {
+			u16 proto = be16_to_cpu(act->vlan.proto);
 
-			switch (vlan_action) {
-			case TCA_VLAN_ACT_POP:
+			switch (act->id) {
+			case FLOW_ACTION_VLAN_POP:
 				break;
-			case TCA_VLAN_ACT_PUSH:
-			case TCA_VLAN_ACT_MODIFY:
+			case FLOW_ACTION_VLAN_PUSH:
+			case FLOW_ACTION_VLAN_MANGLE:
 				if (proto != ETH_P_8021Q) {
 					netdev_err(dev, "%s: Unsupported vlan proto\n",
 						   __func__);
@@ -606,13 +606,17 @@ static int cxgb4_validate_flow_actions(struct net_device *dev,
 				return -EOPNOTSUPP;
 			}
 			act_vlan = true;
-		} else if (is_tcf_pedit(a)) {
-			bool pedit_valid = valid_pedit_action(dev, a);
+			}
+			break;
+		case FLOW_ACTION_MANGLE: {
+			bool pedit_valid = valid_pedit_action(dev, act);
 
 			if (!pedit_valid)
 				return -EOPNOTSUPP;
 			act_pedit = true;
-		} else {
+			}
+			break;
+		default:
 			netdev_err(dev, "%s: Unsupported action\n", __func__);
 			return -EOPNOTSUPP;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index c4c6bbcafc68..83522c926d7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1811,11 +1811,11 @@ struct pedit_headers_action {
 };
 
 static int pedit_header_offsets[] = {
-	[TCA_PEDIT_KEY_EX_HDR_TYPE_ETH] = offsetof(struct pedit_headers, eth),
-	[TCA_PEDIT_KEY_EX_HDR_TYPE_IP4] = offsetof(struct pedit_headers, ip4),
-	[TCA_PEDIT_KEY_EX_HDR_TYPE_IP6] = offsetof(struct pedit_headers, ip6),
-	[TCA_PEDIT_KEY_EX_HDR_TYPE_TCP] = offsetof(struct pedit_headers, tcp),
-	[TCA_PEDIT_KEY_EX_HDR_TYPE_UDP] = offsetof(struct pedit_headers, udp),
+	[FLOW_ACT_MANGLE_HDR_TYPE_ETH] = offsetof(struct pedit_headers, eth),
+	[FLOW_ACT_MANGLE_HDR_TYPE_IP4] = offsetof(struct pedit_headers, ip4),
+	[FLOW_ACT_MANGLE_HDR_TYPE_IP6] = offsetof(struct pedit_headers, ip6),
+	[FLOW_ACT_MANGLE_HDR_TYPE_TCP] = offsetof(struct pedit_headers, tcp),
+	[FLOW_ACT_MANGLE_HDR_TYPE_UDP] = offsetof(struct pedit_headers, udp),
 };
 
 #define pedit_header(_ph, _htype) ((void *)(_ph) + pedit_header_offsets[_htype])
@@ -1825,7 +1825,7 @@ static int set_pedit_val(u8 hdr_type, u32 mask, u32 val, u32 offset,
 {
 	u32 *curr_pmask, *curr_pval;
 
-	if (hdr_type >= __PEDIT_HDR_TYPE_MAX)
+	if (hdr_type >= 2)
 		goto out_err;
 
 	curr_pmask = (u32 *)(pedit_header(&hdrs->masks, hdr_type) + offset);
@@ -1900,10 +1900,10 @@ static int offload_pedit_fields(struct pedit_headers_action *hdrs,
 	__be16 mask_be16;
 	void *action;
 
-	set_masks = &hdrs[TCA_PEDIT_KEY_EX_CMD_SET].masks;
-	add_masks = &hdrs[TCA_PEDIT_KEY_EX_CMD_ADD].masks;
-	set_vals = &hdrs[TCA_PEDIT_KEY_EX_CMD_SET].vals;
-	add_vals = &hdrs[TCA_PEDIT_KEY_EX_CMD_ADD].vals;
+	set_masks = &hdrs[0].masks;
+	add_masks = &hdrs[1].masks;
+	set_vals = &hdrs[0].vals;
+	add_vals = &hdrs[1].vals;
 
 	action_size = MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto);
 	action = parse_attr->mod_hdr_actions;
@@ -2028,43 +2028,33 @@ static int alloc_mod_hdr_actions(struct mlx5e_priv *priv,
 static const struct pedit_headers zero_masks = {};
 
 static int parse_tc_pedit_action(struct mlx5e_priv *priv,
-				 const struct tc_action *a, int namespace,
+				 const struct flow_action_entry *act, int namespace,
 				 struct mlx5e_tc_flow_parse_attr *parse_attr,
 				 struct pedit_headers_action *hdrs,
 				 struct netlink_ext_ack *extack)
 {
-	int nkeys, i, err = -EOPNOTSUPP;
+	u8 cmd = (act->id == FLOW_ACTION_MANGLE) ? 0 : 1;
+	int err = -EOPNOTSUPP;
 	u32 mask, val, offset;
-	u8 cmd, htype;
+	u8 htype;
 
-	nkeys = tcf_pedit_nkeys(a);
+	htype = act->mangle.htype;
+	err = -EOPNOTSUPP; /* can't be all optimistic */
 
-	for (i = 0; i < nkeys; i++) {
-		htype = tcf_pedit_htype(a, i);
-		cmd = tcf_pedit_cmd(a, i);
-		err = -EOPNOTSUPP; /* can't be all optimistic */
-
-		if (htype == TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "legacy pedit isn't offloaded");
-			goto out_err;
-		}
-
-		if (cmd != TCA_PEDIT_KEY_EX_CMD_SET && cmd != TCA_PEDIT_KEY_EX_CMD_ADD) {
-			NL_SET_ERR_MSG_MOD(extack, "pedit cmd isn't offloaded");
-			goto out_err;
-		}
+	if (htype == FLOW_ACT_MANGLE_UNSPEC) {
+		NL_SET_ERR_MSG_MOD(extack, "legacy pedit isn't offloaded");
+		goto out_err;
+	}
 
-		mask = tcf_pedit_mask(a, i);
-		val = tcf_pedit_val(a, i);
-		offset = tcf_pedit_offset(a, i);
+	mask = act->mangle.mask;
+	val = act->mangle.val;
+	offset = act->mangle.offset;
 
-		err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd]);
-		if (err)
-			goto out_err;
+	err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd]);
+	if (err)
+		goto out_err;
 
-		hdrs[cmd].pedits++;
-	}
+	hdrs[cmd].pedits++;
 
 	return 0;
 out_err:
@@ -2139,15 +2129,15 @@ static bool csum_offload_supported(struct mlx5e_priv *priv,
 }
 
 static bool modify_header_match_supported(struct mlx5_flow_spec *spec,
-					  struct tcf_exts *exts,
+					  struct flow_action *flow_action,
 					  struct netlink_ext_ack *extack)
 {
-	const struct tc_action *a;
+	const struct flow_action_entry *act;
 	bool modify_ip_header;
 	u8 htype, ip_proto;
 	void *headers_v;
 	u16 ethertype;
-	int nkeys, i;
+	int i;
 
 	headers_v = MLX5_ADDR_OF(fte_match_param, spec->match_value, outer_headers);
 	ethertype = MLX5_GET(fte_match_set_lyr_2_4, headers_v, ethertype);
@@ -2157,20 +2147,16 @@ static bool modify_header_match_supported(struct mlx5_flow_spec *spec,
 		goto out_ok;
 
 	modify_ip_header = false;
-	tcf_exts_for_each_action(i, a, exts) {
-		int k;
-
-		if (!is_tcf_pedit(a))
+	flow_action_for_each(i, act, flow_action) {
+		if (act->id != FLOW_ACTION_MANGLE &&
+		    act->id != FLOW_ACTION_ADD)
 			continue;
 
-		nkeys = tcf_pedit_nkeys(a);
-		for (k = 0; k < nkeys; k++) {
-			htype = tcf_pedit_htype(a, k);
-			if (htype == TCA_PEDIT_KEY_EX_HDR_TYPE_IP4 ||
-			    htype == TCA_PEDIT_KEY_EX_HDR_TYPE_IP6) {
-				modify_ip_header = true;
-				break;
-			}
+		htype = act->mangle.htype;
+		if (htype == FLOW_ACT_MANGLE_HDR_TYPE_IP4 ||
+		    htype == FLOW_ACT_MANGLE_HDR_TYPE_IP6) {
+			modify_ip_header = true;
+			break;
 		}
 	}
 
@@ -2188,7 +2174,7 @@ static bool modify_header_match_supported(struct mlx5_flow_spec *spec,
 }
 
 static bool actions_match_supported(struct mlx5e_priv *priv,
-				    struct tcf_exts *exts,
+				    struct flow_action *flow_action,
 				    struct mlx5e_tc_flow_parse_attr *parse_attr,
 				    struct mlx5e_tc_flow *flow,
 				    struct netlink_ext_ack *extack)
@@ -2205,7 +2191,8 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 		return false;
 
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
-		return modify_header_match_supported(&parse_attr->spec, exts,
+		return modify_header_match_supported(&parse_attr->spec,
+						     flow_action,
 						     extack);
 
 	return true;
@@ -2225,53 +2212,50 @@ static bool same_hw_devs(struct mlx5e_priv *priv, struct mlx5e_priv *peer_priv)
 	return (fsystem_guid == psystem_guid);
 }
 
-static int parse_tc_nic_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
+static int parse_tc_nic_actions(struct mlx5e_priv *priv,
+				struct flow_action *flow_action,
 				struct mlx5e_tc_flow_parse_attr *parse_attr,
 				struct mlx5e_tc_flow *flow,
 				struct netlink_ext_ack *extack)
 {
-	struct pedit_headers_action hdrs[__PEDIT_CMD_MAX] = {};
 	struct mlx5_nic_flow_attr *attr = flow->nic_attr;
-	const struct tc_action *a;
+	struct pedit_headers_action hdrs[2] = {};
+	const struct flow_action_entry *act;
 	u32 action = 0;
 	int err, i;
 
-	if (!tcf_exts_has_actions(exts))
+	if (!flow_action_has_entries(flow_action))
 		return -EINVAL;
 
 	attr->flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
 
-	tcf_exts_for_each_action(i, a, exts) {
-		if (is_tcf_gact_shot(a)) {
+	flow_action_for_each(i, act, flow_action) {
+		switch (act->id) {
+		case FLOW_ACTION_DROP:
 			action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
 			if (MLX5_CAP_FLOWTABLE(priv->mdev,
 					       flow_table_properties_nic_receive.flow_counter))
 				action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
-			continue;
-		}
-
-		if (is_tcf_pedit(a)) {
-			err = parse_tc_pedit_action(priv, a, MLX5_FLOW_NAMESPACE_KERNEL,
+			break;
+		case FLOW_ACTION_MANGLE:
+		case FLOW_ACTION_ADD:
+			err = parse_tc_pedit_action(priv, act, MLX5_FLOW_NAMESPACE_KERNEL,
 						    parse_attr, hdrs, extack);
 			if (err)
 				return err;
 
 			action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR |
 				  MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-			continue;
-		}
-
-		if (is_tcf_csum(a)) {
+			break;
+		case FLOW_ACTION_CSUM:
 			if (csum_offload_supported(priv, action,
-						   tcf_csum_update_flags(a),
+						   act->csum_flags,
 						   extack))
-				continue;
+				break;
 
 			return -EOPNOTSUPP;
-		}
-
-		if (is_tcf_mirred_egress_redirect(a)) {
-			struct net_device *peer_dev = tcf_mirred_dev(a);
+		case FLOW_ACTION_REDIRECT: {
+			struct net_device *peer_dev = act->dev;
 
 			if (priv->netdev->netdev_ops == peer_dev->netdev_ops &&
 			    same_hw_devs(priv, netdev_priv(peer_dev))) {
@@ -2286,11 +2270,10 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 					    peer_dev->name);
 				return -EINVAL;
 			}
-			continue;
-		}
-
-		if (is_tcf_skbedit_mark(a)) {
-			u32 mark = tcf_skbedit_mark(a);
+			}
+			break;
+		case FLOW_ACTION_MARK: {
+			u32 mark = act->mark;
 
 			if (mark & ~MLX5E_TC_FLOW_ID_MASK) {
 				NL_SET_ERR_MSG_MOD(extack,
@@ -2300,10 +2283,11 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 
 			attr->flow_tag = mark;
 			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-			continue;
+			}
+			break;
+		default:
+			return -EINVAL;
 		}
-
-		return -EINVAL;
 	}
 
 	if (hdrs[TCA_PEDIT_KEY_EX_CMD_SET].pedits ||
@@ -2315,7 +2299,7 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 	}
 
 	attr->action = action;
-	if (!actions_match_supported(priv, exts, parse_attr, flow, extack))
+	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
 		return -EOPNOTSUPP;
 
 	return 0;
@@ -2420,7 +2404,7 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv,
 }
 
 static int parse_tc_vlan_action(struct mlx5e_priv *priv,
-				const struct tc_action *a,
+				const struct flow_action_entry *act,
 				struct mlx5_esw_flow_attr *attr,
 				u32 *action)
 {
@@ -2429,7 +2413,8 @@ static int parse_tc_vlan_action(struct mlx5e_priv *priv,
 	if (vlan_idx >= MLX5_FS_VLAN_DEPTH)
 		return -EOPNOTSUPP;
 
-	if (tcf_vlan_action(a) == TCA_VLAN_ACT_POP) {
+	switch (act->id) {
+	case FLOW_ACTION_VLAN_POP:
 		if (vlan_idx) {
 			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev,
 								 MLX5_FS_VLAN_DEPTH))
@@ -2439,10 +2424,11 @@ static int parse_tc_vlan_action(struct mlx5e_priv *priv,
 		} else {
 			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
 		}
-	} else if (tcf_vlan_action(a) == TCA_VLAN_ACT_PUSH) {
-		attr->vlan_vid[vlan_idx] = tcf_vlan_push_vid(a);
-		attr->vlan_prio[vlan_idx] = tcf_vlan_push_prio(a);
-		attr->vlan_proto[vlan_idx] = tcf_vlan_push_proto(a);
+		break;
+	case FLOW_ACTION_VLAN_PUSH:
+		attr->vlan_vid[vlan_idx] = act->vlan.vid;
+		attr->vlan_prio[vlan_idx] = act->vlan.prio;
+		attr->vlan_proto[vlan_idx] = act->vlan.proto;
 		if (!attr->vlan_proto[vlan_idx])
 			attr->vlan_proto[vlan_idx] = htons(ETH_P_8021Q);
 
@@ -2454,13 +2440,15 @@ static int parse_tc_vlan_action(struct mlx5e_priv *priv,
 			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2;
 		} else {
 			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev, 1) &&
-			    (tcf_vlan_push_proto(a) != htons(ETH_P_8021Q) ||
-			     tcf_vlan_push_prio(a)))
+			    (act->vlan.proto != htons(ETH_P_8021Q) ||
+			     act->vlan.prio))
 				return -EOPNOTSUPP;
 
 			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH;
 		}
-	} else { /* action is TCA_VLAN_ACT_MODIFY */
+		break;
+	default:
+		/* action is FLOW_ACT_VLAN_MANGLE */
 		return -EOPNOTSUPP;
 	}
 
@@ -2469,59 +2457,56 @@ static int parse_tc_vlan_action(struct mlx5e_priv *priv,
 	return 0;
 }
 
-static int parse_tc_fdb_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
+static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
+				struct flow_action *flow_action,
 				struct mlx5e_tc_flow_parse_attr *parse_attr,
 				struct mlx5e_tc_flow *flow,
 				struct netlink_ext_ack *extack)
 {
-	struct pedit_headers_action hdrs[__PEDIT_CMD_MAX] = {};
+	struct pedit_headers_action hdrs[2] = {};
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
-	struct ip_tunnel_info *info = NULL;
-	const struct tc_action *a;
+	const struct ip_tunnel_info *info = NULL;
+	const struct flow_action_entry *act;
 	bool encap = false;
 	u32 action = 0;
 	int err, i;
 
-	if (!tcf_exts_has_actions(exts))
+	if (!flow_action_has_entries(flow_action))
 		return -EINVAL;
 
 	attr->in_rep = rpriv->rep;
 	attr->in_mdev = priv->mdev;
 
-	tcf_exts_for_each_action(i, a, exts) {
-		if (is_tcf_gact_shot(a)) {
+	flow_action_for_each(i, act, flow_action) {
+		switch (act->id) {
+		case FLOW_ACTION_DROP:
 			action |= MLX5_FLOW_CONTEXT_ACTION_DROP |
 				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
-			continue;
-		}
-
-		if (is_tcf_pedit(a)) {
-			err = parse_tc_pedit_action(priv, a, MLX5_FLOW_NAMESPACE_FDB,
+			break;
+		case FLOW_ACTION_MANGLE:
+		case FLOW_ACTION_ADD:
+			err = parse_tc_pedit_action(priv, act, MLX5_FLOW_NAMESPACE_FDB,
 						    parse_attr, hdrs, extack);
 			if (err)
 				return err;
 
 			action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 			attr->split_count = attr->out_count;
-			continue;
-		}
-
-		if (is_tcf_csum(a)) {
+			break;
+		case FLOW_ACTION_CSUM:
 			if (csum_offload_supported(priv, action,
-						   tcf_csum_update_flags(a),
-						   extack))
-				continue;
+						   act->csum_flags, extack))
+				break;
 
 			return -EOPNOTSUPP;
-		}
-
-		if (is_tcf_mirred_egress_redirect(a) || is_tcf_mirred_egress_mirror(a)) {
+		case FLOW_ACTION_REDIRECT:
+		case FLOW_ACTION_MIRRED: {
 			struct mlx5e_priv *out_priv;
 			struct net_device *out_dev;
 
-			out_dev = tcf_mirred_dev(a);
+			out_dev = act->dev;
 			if (!out_dev) {
 				/* out_dev is NULL when filters with
 				 * non-existing mirred device are replayed to
@@ -2586,35 +2571,29 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 				       priv->netdev->name, out_dev->name);
 				return -EINVAL;
 			}
-			continue;
-		}
-
-		if (is_tcf_tunnel_set(a)) {
-			info = tcf_tunnel_info(a);
+			}
+			break;
+		case FLOW_ACTION_TUNNEL_ENCAP:
+			info = act->tunnel;
 			if (info)
 				encap = true;
 			else
 				return -EOPNOTSUPP;
-			continue;
-		}
-
-		if (is_tcf_vlan(a)) {
-			err = parse_tc_vlan_action(priv, a, attr, &action);
 
+			break;
+		case FLOW_ACTION_VLAN_PUSH:
+		case FLOW_ACTION_VLAN_POP:
+			err = parse_tc_vlan_action(priv, act, attr, &action);
 			if (err)
 				return err;
 
 			attr->split_count = attr->out_count;
-			continue;
-		}
-
-		if (is_tcf_tunnel_release(a)) {
+			break;
+		case FLOW_ACTION_TUNNEL_DECAP:
 			action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
-			continue;
-		}
-
-		if (is_tcf_gact_goto_chain(a)) {
-			u32 dest_chain = tcf_gact_goto_chain_index(a);
+			break;
+		case FLOW_ACTION_GOTO: {
+			u32 dest_chain = act->chain_index;
 			u32 max_chain = mlx5_eswitch_get_chain_range(esw);
 
 			if (dest_chain <= attr->chain) {
@@ -2627,11 +2606,11 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 			}
 			action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			attr->dest_chain = dest_chain;
-
-			continue;
+			break;
+			}
+		default:
+			return -EINVAL;
 		}
-
-		return -EINVAL;
 	}
 
 	if (hdrs[TCA_PEDIT_KEY_EX_CMD_SET].pedits ||
@@ -2643,7 +2622,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 	}
 
 	attr->action = action;
-	if (!actions_match_supported(priv, exts, parse_attr, flow, extack))
+	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
 		return -EOPNOTSUPP;
 
 	if (attr->dest_chain) {
@@ -2754,6 +2733,7 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 		     struct mlx5_eswitch_rep *in_rep,
 		     struct mlx5_core_dev *in_mdev)
 {
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
@@ -2775,7 +2755,7 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 
 	flow->esw_attr->chain = f->common.chain_index;
 	flow->esw_attr->prio = TC_H_MAJ(f->common.prio) >> 16;
-	err = parse_tc_fdb_actions(priv, f->exts, parse_attr, flow, extack);
+	err = parse_tc_fdb_actions(priv, &rule->action, parse_attr, flow, extack);
 	if (err)
 		goto err_free;
 
@@ -2891,6 +2871,7 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 		   struct net_device *filter_dev,
 		   struct mlx5e_tc_flow **__flow)
 {
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5e_tc_flow *flow;
@@ -2913,7 +2894,7 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 	if (err)
 		goto err_free;
 
-	err = parse_tc_nic_actions(priv, f->exts, parse_attr, flow, extack);
+	err = parse_tc_nic_actions(priv, &rule->action, parse_attr, flow, extack);
 	if (err)
 		goto err_free;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index a69e3462b65e..2649d128a57c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -588,7 +588,7 @@ int mlxsw_sp_acl_rulei_act_vlan(struct mlxsw_sp *mlxsw_sp,
 {
 	u8 ethertype;
 
-	if (action == TCA_VLAN_ACT_MODIFY) {
+	if (action == FLOW_ACTION_VLAN_MANGLE) {
 		switch (proto) {
 		case ETH_P_8021Q:
 			ethertype = 0;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index c090ecb62041..9af9f5c1b25c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -17,13 +17,13 @@
 static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 					 struct mlxsw_sp_acl_block *block,
 					 struct mlxsw_sp_acl_rule_info *rulei,
-					 struct tcf_exts *exts,
+					 struct flow_action *flow_action,
 					 struct netlink_ext_ack *extack)
 {
-	const struct tc_action *a;
+	const struct flow_action_entry *act;
 	int err, i;
 
-	if (!tcf_exts_has_actions(exts))
+	if (!flow_action_has_entries(flow_action))
 		return 0;
 
 	/* Count action is inserted first */
@@ -31,27 +31,31 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		return err;
 
-	tcf_exts_for_each_action(i, a, exts) {
-		if (is_tcf_gact_ok(a)) {
+	flow_action_for_each(i, act, flow_action) {
+		switch (act->id) {
+		case FLOW_ACTION_ACCEPT:
 			err = mlxsw_sp_acl_rulei_act_terminate(rulei);
 			if (err) {
 				NL_SET_ERR_MSG_MOD(extack, "Cannot append terminate action");
 				return err;
 			}
-		} else if (is_tcf_gact_shot(a)) {
+			break;
+		case FLOW_ACTION_DROP:
 			err = mlxsw_sp_acl_rulei_act_drop(rulei);
 			if (err) {
 				NL_SET_ERR_MSG_MOD(extack, "Cannot append drop action");
 				return err;
 			}
-		} else if (is_tcf_gact_trap(a)) {
+			break;
+		case FLOW_ACTION_TRAP:
 			err = mlxsw_sp_acl_rulei_act_trap(rulei);
 			if (err) {
 				NL_SET_ERR_MSG_MOD(extack, "Cannot append trap action");
 				return err;
 			}
-		} else if (is_tcf_gact_goto_chain(a)) {
-			u32 chain_index = tcf_gact_goto_chain_index(a);
+			break;
+		case FLOW_ACTION_GOTO: {
+			u32 chain_index = act->chain_index;
 			struct mlxsw_sp_acl_ruleset *ruleset;
 			u16 group_id;
 
@@ -67,7 +71,9 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 				NL_SET_ERR_MSG_MOD(extack, "Cannot append jump action");
 				return err;
 			}
-		} else if (is_tcf_mirred_egress_redirect(a)) {
+			}
+			break;
+		case FLOW_ACTION_REDIRECT: {
 			struct net_device *out_dev;
 			struct mlxsw_sp_fid *fid;
 			u16 fid_index;
@@ -79,29 +85,34 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 			if (err)
 				return err;
 
-			out_dev = tcf_mirred_dev(a);
+			out_dev = act->dev;
 			err = mlxsw_sp_acl_rulei_act_fwd(mlxsw_sp, rulei,
 							 out_dev, extack);
 			if (err)
 				return err;
-		} else if (is_tcf_mirred_egress_mirror(a)) {
-			struct net_device *out_dev = tcf_mirred_dev(a);
+			}
+			break;
+		case FLOW_ACTION_MIRRED: {
+			struct net_device *out_dev = act->dev;
 
 			err = mlxsw_sp_acl_rulei_act_mirror(mlxsw_sp, rulei,
 							    block, out_dev,
 							    extack);
 			if (err)
 				return err;
-		} else if (is_tcf_vlan(a)) {
-			u16 proto = be16_to_cpu(tcf_vlan_push_proto(a));
-			u32 action = tcf_vlan_action(a);
-			u8 prio = tcf_vlan_push_prio(a);
-			u16 vid = tcf_vlan_push_vid(a);
+			}
+			break;
+		case FLOW_ACTION_VLAN_PUSH:
+		case FLOW_ACTION_VLAN_POP: {
+			u16 proto = be16_to_cpu(act->vlan.proto);
+			u8 prio = act->vlan.prio;
+			u16 vid = act->vlan.vid;
 
 			return mlxsw_sp_acl_rulei_act_vlan(mlxsw_sp, rulei,
-							   action, vid,
+							   act->id, vid,
 							   proto, prio, extack);
-		} else {
+			}
+		default:
 			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
 			dev_err(mlxsw_sp->bus_info->dev, "Unsupported action\n");
 			return -EOPNOTSUPP;
@@ -361,7 +372,8 @@ static int mlxsw_sp_flower_parse(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		return err;
 
-	return mlxsw_sp_flower_parse_actions(mlxsw_sp, block, rulei, f->exts,
+	return mlxsw_sp_flower_parse_actions(mlxsw_sp, block, rulei,
+					     &f->rule->action,
 					     f->common.extack);
 }
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 43192640bdd1..6b1d56b021ac 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -37,7 +37,7 @@ static void nfp_fl_pop_vlan(struct nfp_fl_pop_vlan *pop_vlan)
 
 static void
 nfp_fl_push_vlan(struct nfp_fl_push_vlan *push_vlan,
-		 const struct tc_action *action)
+		 const struct flow_action_entry *act)
 {
 	size_t act_size = sizeof(struct nfp_fl_push_vlan);
 	u16 tmp_push_vlan_tci;
@@ -45,17 +45,17 @@ nfp_fl_push_vlan(struct nfp_fl_push_vlan *push_vlan,
 	push_vlan->head.jump_id = NFP_FL_ACTION_OPCODE_PUSH_VLAN;
 	push_vlan->head.len_lw = act_size >> NFP_FL_LW_SIZ;
 	push_vlan->reserved = 0;
-	push_vlan->vlan_tpid = tcf_vlan_push_proto(action);
+	push_vlan->vlan_tpid = act->vlan.proto;
 
 	tmp_push_vlan_tci =
-		FIELD_PREP(NFP_FL_PUSH_VLAN_PRIO, tcf_vlan_push_prio(action)) |
-		FIELD_PREP(NFP_FL_PUSH_VLAN_VID, tcf_vlan_push_vid(action)) |
+		FIELD_PREP(NFP_FL_PUSH_VLAN_PRIO, act->vlan.prio) |
+		FIELD_PREP(NFP_FL_PUSH_VLAN_VID, act->vlan.vid) |
 		NFP_FL_PUSH_VLAN_CFI;
 	push_vlan->vlan_tci = cpu_to_be16(tmp_push_vlan_tci);
 }
 
 static int
-nfp_fl_pre_lag(struct nfp_app *app, const struct tc_action *action,
+nfp_fl_pre_lag(struct nfp_app *app, const struct flow_action_entry *act,
 	       struct nfp_fl_payload *nfp_flow, int act_len)
 {
 	size_t act_size = sizeof(struct nfp_fl_pre_lag);
@@ -63,7 +63,7 @@ nfp_fl_pre_lag(struct nfp_app *app, const struct tc_action *action,
 	struct net_device *out_dev;
 	int err;
 
-	out_dev = tcf_mirred_dev(action);
+	out_dev = act->dev;
 	if (!out_dev || !netif_is_lag_master(out_dev))
 		return 0;
 
@@ -92,7 +92,8 @@ nfp_fl_pre_lag(struct nfp_app *app, const struct tc_action *action,
 
 static int
 nfp_fl_output(struct nfp_app *app, struct nfp_fl_output *output,
-	      const struct tc_action *action, struct nfp_fl_payload *nfp_flow,
+	      const struct flow_action_entry *act,
+	      struct nfp_fl_payload *nfp_flow,
 	      bool last, struct net_device *in_dev,
 	      enum nfp_flower_tun_type tun_type, int *tun_out_cnt)
 {
@@ -104,7 +105,7 @@ nfp_fl_output(struct nfp_app *app, struct nfp_fl_output *output,
 	output->head.jump_id = NFP_FL_ACTION_OPCODE_OUTPUT;
 	output->head.len_lw = act_size >> NFP_FL_LW_SIZ;
 
-	out_dev = tcf_mirred_dev(action);
+	out_dev = act->dev;
 	if (!out_dev)
 		return -EOPNOTSUPP;
 
@@ -155,9 +156,9 @@ nfp_fl_output(struct nfp_app *app, struct nfp_fl_output *output,
 
 static enum nfp_flower_tun_type
 nfp_fl_get_tun_from_act_l4_port(struct nfp_app *app,
-				const struct tc_action *action)
+				const struct flow_action_entry *act)
 {
-	struct ip_tunnel_info *tun = tcf_tunnel_info(action);
+	const struct ip_tunnel_info *tun = act->tunnel;
 	struct nfp_flower_priv *priv = app->priv;
 
 	switch (tun->key.tp_dst) {
@@ -195,9 +196,9 @@ static struct nfp_fl_pre_tunnel *nfp_fl_pre_tunnel(char *act_data, int act_len)
 
 static int
 nfp_fl_push_geneve_options(struct nfp_fl_payload *nfp_fl, int *list_len,
-			   const struct tc_action *action)
+			   const struct flow_action_entry *act)
 {
-	struct ip_tunnel_info *ip_tun = tcf_tunnel_info(action);
+	struct ip_tunnel_info *ip_tun = (struct ip_tunnel_info *)act->tunnel;
 	int opt_len, opt_cnt, act_start, tot_push_len;
 	u8 *src = ip_tunnel_info_opts(ip_tun);
 
@@ -259,13 +260,13 @@ nfp_fl_push_geneve_options(struct nfp_fl_payload *nfp_fl, int *list_len,
 static int
 nfp_fl_set_ipv4_udp_tun(struct nfp_app *app,
 			struct nfp_fl_set_ipv4_udp_tun *set_tun,
-			const struct tc_action *action,
+			const struct flow_action_entry *act,
 			struct nfp_fl_pre_tunnel *pre_tun,
 			enum nfp_flower_tun_type tun_type,
 			struct net_device *netdev)
 {
 	size_t act_size = sizeof(struct nfp_fl_set_ipv4_udp_tun);
-	struct ip_tunnel_info *ip_tun = tcf_tunnel_info(action);
+	const struct ip_tunnel_info *ip_tun = act->tunnel;
 	struct nfp_flower_priv *priv = app->priv;
 	u32 tmp_set_ip_tun_type_index = 0;
 	/* Currently support one pre-tunnel so index is always 0. */
@@ -345,7 +346,7 @@ static void nfp_fl_set_helper32(u32 value, u32 mask, u8 *p_exact, u8 *p_mask)
 }
 
 static int
-nfp_fl_set_eth(const struct tc_action *action, int idx, u32 off,
+nfp_fl_set_eth(const struct flow_action_entry *act, int idx, u32 off,
 	       struct nfp_fl_set_eth *set_eth)
 {
 	u32 exact, mask;
@@ -353,8 +354,8 @@ nfp_fl_set_eth(const struct tc_action *action, int idx, u32 off,
 	if (off + 4 > ETH_ALEN * 2)
 		return -EOPNOTSUPP;
 
-	mask = ~tcf_pedit_mask(action, idx);
-	exact = tcf_pedit_val(action, idx);
+	mask = ~act->mangle.mask;
+	exact = act->mangle.val;
 
 	if (exact & ~mask)
 		return -EOPNOTSUPP;
@@ -376,7 +377,7 @@ struct ipv4_ttl_word {
 };
 
 static int
-nfp_fl_set_ip4(const struct tc_action *action, int idx, u32 off,
+nfp_fl_set_ip4(const struct flow_action_entry *act, int idx, u32 off,
 	       struct nfp_fl_set_ip4_addrs *set_ip_addr,
 	       struct nfp_fl_set_ip4_ttl_tos *set_ip_ttl_tos)
 {
@@ -387,8 +388,8 @@ nfp_fl_set_ip4(const struct tc_action *action, int idx, u32 off,
 	__be32 exact, mask;
 
 	/* We are expecting tcf_pedit to return a big endian value */
-	mask = (__force __be32)~tcf_pedit_mask(action, idx);
-	exact = (__force __be32)tcf_pedit_val(action, idx);
+	mask = (__force __be32)~act->mangle.mask;
+	exact = (__force __be32)act->mangle.val;
 
 	if (exact & ~mask)
 		return -EOPNOTSUPP;
@@ -505,7 +506,7 @@ nfp_fl_set_ip6_hop_limit_flow_label(u32 off, __be32 exact, __be32 mask,
 }
 
 static int
-nfp_fl_set_ip6(const struct tc_action *action, int idx, u32 off,
+nfp_fl_set_ip6(const struct flow_action_entry *act, int idx, u32 off,
 	       struct nfp_fl_set_ipv6_addr *ip_dst,
 	       struct nfp_fl_set_ipv6_addr *ip_src,
 	       struct nfp_fl_set_ipv6_tc_hl_fl *ip_hl_fl)
@@ -515,8 +516,8 @@ nfp_fl_set_ip6(const struct tc_action *action, int idx, u32 off,
 	u8 word;
 
 	/* We are expecting tcf_pedit to return a big endian value */
-	mask = (__force __be32)~tcf_pedit_mask(action, idx);
-	exact = (__force __be32)tcf_pedit_val(action, idx);
+	mask = (__force __be32)~act->mangle.mask;
+	exact = (__force __be32)act->mangle.val;
 
 	if (exact & ~mask)
 		return -EOPNOTSUPP;
@@ -541,7 +542,7 @@ nfp_fl_set_ip6(const struct tc_action *action, int idx, u32 off,
 }
 
 static int
-nfp_fl_set_tport(const struct tc_action *action, int idx, u32 off,
+nfp_fl_set_tport(const struct flow_action_entry *act, int idx, u32 off,
 		 struct nfp_fl_set_tport *set_tport, int opcode)
 {
 	u32 exact, mask;
@@ -549,8 +550,8 @@ nfp_fl_set_tport(const struct tc_action *action, int idx, u32 off,
 	if (off)
 		return -EOPNOTSUPP;
 
-	mask = ~tcf_pedit_mask(action, idx);
-	exact = tcf_pedit_val(action, idx);
+	mask = ~act->mangle.mask;
+	exact = act->mangle.val;
 
 	if (exact & ~mask)
 		return -EOPNOTSUPP;
@@ -584,7 +585,8 @@ static u32 nfp_fl_csum_l4_to_flag(u8 ip_proto)
 }
 
 static int
-nfp_fl_pedit(const struct tc_action *action, struct tc_cls_flower_offload *flow,
+nfp_fl_pedit(const struct flow_action_entry *act,
+	     struct tc_cls_flower_offload *flow,
 	     char *nfp_action, int *a_len, u32 *csum_updated)
 {
 	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
@@ -592,13 +594,13 @@ nfp_fl_pedit(const struct tc_action *action, struct tc_cls_flower_offload *flow,
 	struct nfp_fl_set_ipv6_tc_hl_fl set_ip6_tc_hl_fl;
 	struct nfp_fl_set_ip4_ttl_tos set_ip_ttl_tos;
 	struct nfp_fl_set_ip4_addrs set_ip_addr;
+	enum flow_action_mangle_base htype;
 	struct nfp_fl_set_tport set_tport;
 	struct nfp_fl_set_eth set_eth;
-	enum pedit_header_type htype;
-	int idx, nkeys, err;
 	size_t act_size = 0;
-	u32 offset, cmd;
 	u8 ip_proto = 0;
+	int idx, err;
+	u32 offset;
 
 	memset(&set_ip6_tc_hl_fl, 0, sizeof(set_ip6_tc_hl_fl));
 	memset(&set_ip_ttl_tos, 0, sizeof(set_ip_ttl_tos));
@@ -607,42 +609,35 @@ nfp_fl_pedit(const struct tc_action *action, struct tc_cls_flower_offload *flow,
 	memset(&set_ip_addr, 0, sizeof(set_ip_addr));
 	memset(&set_tport, 0, sizeof(set_tport));
 	memset(&set_eth, 0, sizeof(set_eth));
-	nkeys = tcf_pedit_nkeys(action);
 
-	for (idx = 0; idx < nkeys; idx++) {
-		cmd = tcf_pedit_cmd(action, idx);
-		htype = tcf_pedit_htype(action, idx);
-		offset = tcf_pedit_offset(action, idx);
+	htype = act->mangle.htype;
+	offset = act->mangle.offset;
 
-		if (cmd != TCA_PEDIT_KEY_EX_CMD_SET)
-			return -EOPNOTSUPP;
-
-		switch (htype) {
-		case TCA_PEDIT_KEY_EX_HDR_TYPE_ETH:
-			err = nfp_fl_set_eth(action, idx, offset, &set_eth);
-			break;
-		case TCA_PEDIT_KEY_EX_HDR_TYPE_IP4:
-			err = nfp_fl_set_ip4(action, idx, offset, &set_ip_addr,
-					     &set_ip_ttl_tos);
-			break;
-		case TCA_PEDIT_KEY_EX_HDR_TYPE_IP6:
-			err = nfp_fl_set_ip6(action, idx, offset, &set_ip6_dst,
-					     &set_ip6_src, &set_ip6_tc_hl_fl);
-			break;
-		case TCA_PEDIT_KEY_EX_HDR_TYPE_TCP:
-			err = nfp_fl_set_tport(action, idx, offset, &set_tport,
-					       NFP_FL_ACTION_OPCODE_SET_TCP);
-			break;
-		case TCA_PEDIT_KEY_EX_HDR_TYPE_UDP:
-			err = nfp_fl_set_tport(action, idx, offset, &set_tport,
-					       NFP_FL_ACTION_OPCODE_SET_UDP);
-			break;
-		default:
-			return -EOPNOTSUPP;
-		}
-		if (err)
-			return err;
+	switch (htype) {
+	case TCA_PEDIT_KEY_EX_HDR_TYPE_ETH:
+		err = nfp_fl_set_eth(act, idx, offset, &set_eth);
+		break;
+	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP4:
+		err = nfp_fl_set_ip4(act, idx, offset, &set_ip_addr,
+				     &set_ip_ttl_tos);
+		break;
+	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP6:
+		err = nfp_fl_set_ip6(act, idx, offset, &set_ip6_dst,
+				     &set_ip6_src, &set_ip6_tc_hl_fl);
+		break;
+	case TCA_PEDIT_KEY_EX_HDR_TYPE_TCP:
+		err = nfp_fl_set_tport(act, idx, offset, &set_tport,
+				       NFP_FL_ACTION_OPCODE_SET_TCP);
+		break;
+	case TCA_PEDIT_KEY_EX_HDR_TYPE_UDP:
+		err = nfp_fl_set_tport(act, idx, offset, &set_tport,
+				       NFP_FL_ACTION_OPCODE_SET_UDP);
+		break;
+	default:
+		return -EOPNOTSUPP;
 	}
+	if (err)
+		return err;
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
 		struct flow_match_basic match;
@@ -732,7 +727,7 @@ nfp_fl_pedit(const struct tc_action *action, struct tc_cls_flower_offload *flow,
 }
 
 static int
-nfp_flower_output_action(struct nfp_app *app, const struct tc_action *a,
+nfp_flower_output_action(struct nfp_app *app, const struct flow_action_entry *act,
 			 struct nfp_fl_payload *nfp_fl, int *a_len,
 			 struct net_device *netdev, bool last,
 			 enum nfp_flower_tun_type *tun_type, int *tun_out_cnt,
@@ -752,7 +747,7 @@ nfp_flower_output_action(struct nfp_app *app, const struct tc_action *a,
 		return -EOPNOTSUPP;
 
 	output = (struct nfp_fl_output *)&nfp_fl->action_data[*a_len];
-	err = nfp_fl_output(app, output, a, nfp_fl, last, netdev, *tun_type,
+	err = nfp_fl_output(app, output, act, nfp_fl, last, netdev, *tun_type,
 			    tun_out_cnt);
 	if (err)
 		return err;
@@ -763,7 +758,7 @@ nfp_flower_output_action(struct nfp_app *app, const struct tc_action *a,
 		/* nfp_fl_pre_lag returns -err or size of prelag action added.
 		 * This will be 0 if it is not egressing to a lag dev.
 		 */
-		prelag_size = nfp_fl_pre_lag(app, a, nfp_fl, *a_len);
+		prelag_size = nfp_fl_pre_lag(app, act, nfp_fl, *a_len);
 		if (prelag_size < 0)
 			return prelag_size;
 		else if (prelag_size > 0 && (!last || *out_cnt))
@@ -777,7 +772,7 @@ nfp_flower_output_action(struct nfp_app *app, const struct tc_action *a,
 }
 
 static int
-nfp_flower_loop_action(struct nfp_app *app, const struct tc_action *a,
+nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		       struct tc_cls_flower_offload *flow,
 		       struct nfp_fl_payload *nfp_fl, int *a_len,
 		       struct net_device *netdev,
@@ -790,23 +785,25 @@ nfp_flower_loop_action(struct nfp_app *app, const struct tc_action *a,
 	struct nfp_fl_pop_vlan *pop_v;
 	int err;
 
-	if (is_tcf_gact_shot(a)) {
+	switch (act->id) {
+	case FLOW_ACTION_DROP:
 		nfp_fl->meta.shortcut = cpu_to_be32(NFP_FL_SC_ACT_DROP);
-	} else if (is_tcf_mirred_egress_redirect(a)) {
-		err = nfp_flower_output_action(app, a, nfp_fl, a_len, netdev,
+		break;
+	case FLOW_ACTION_REDIRECT:
+		err = nfp_flower_output_action(app, act, nfp_fl, a_len, netdev,
 					       true, tun_type, tun_out_cnt,
 					       out_cnt, csum_updated);
 		if (err)
 			return err;
-
-	} else if (is_tcf_mirred_egress_mirror(a)) {
-		err = nfp_flower_output_action(app, a, nfp_fl, a_len, netdev,
+		break;
+	case FLOW_ACTION_MIRRED:
+		err = nfp_flower_output_action(app, act, nfp_fl, a_len, netdev,
 					       false, tun_type, tun_out_cnt,
 					       out_cnt, csum_updated);
 		if (err)
 			return err;
-
-	} else if (is_tcf_vlan(a) && tcf_vlan_action(a) == TCA_VLAN_ACT_POP) {
+		break;
+	case FLOW_ACTION_VLAN_POP:
 		if (*a_len + sizeof(struct nfp_fl_pop_vlan) > NFP_FL_MAX_A_SIZ)
 			return -EOPNOTSUPP;
 
@@ -815,19 +812,21 @@ nfp_flower_loop_action(struct nfp_app *app, const struct tc_action *a,
 
 		nfp_fl_pop_vlan(pop_v);
 		*a_len += sizeof(struct nfp_fl_pop_vlan);
-	} else if (is_tcf_vlan(a) && tcf_vlan_action(a) == TCA_VLAN_ACT_PUSH) {
+		break;
+	case FLOW_ACTION_VLAN_PUSH:
 		if (*a_len + sizeof(struct nfp_fl_push_vlan) > NFP_FL_MAX_A_SIZ)
 			return -EOPNOTSUPP;
 
 		psh_v = (struct nfp_fl_push_vlan *)&nfp_fl->action_data[*a_len];
 		nfp_fl->meta.shortcut = cpu_to_be32(NFP_FL_SC_ACT_NULL);
 
-		nfp_fl_push_vlan(psh_v, a);
+		nfp_fl_push_vlan(psh_v, act);
 		*a_len += sizeof(struct nfp_fl_push_vlan);
-	} else if (is_tcf_tunnel_set(a)) {
-		struct ip_tunnel_info *ip_tun = tcf_tunnel_info(a);
+		break;
+	case FLOW_ACTION_TUNNEL_ENCAP: {
+		const struct ip_tunnel_info *ip_tun = act->tunnel;
 
-		*tun_type = nfp_fl_get_tun_from_act_l4_port(app, a);
+		*tun_type = nfp_fl_get_tun_from_act_l4_port(app, act);
 		if (*tun_type == NFP_FL_TUNNEL_NONE)
 			return -EOPNOTSUPP;
 
@@ -846,32 +845,36 @@ nfp_flower_loop_action(struct nfp_app *app, const struct tc_action *a,
 		nfp_fl->meta.shortcut = cpu_to_be32(NFP_FL_SC_ACT_NULL);
 		*a_len += sizeof(struct nfp_fl_pre_tunnel);
 
-		err = nfp_fl_push_geneve_options(nfp_fl, a_len, a);
+		err = nfp_fl_push_geneve_options(nfp_fl, a_len, act);
 		if (err)
 			return err;
 
 		set_tun = (void *)&nfp_fl->action_data[*a_len];
-		err = nfp_fl_set_ipv4_udp_tun(app, set_tun, a, pre_tun,
+		err = nfp_fl_set_ipv4_udp_tun(app, set_tun, act, pre_tun,
 					      *tun_type, netdev);
 		if (err)
 			return err;
 		*a_len += sizeof(struct nfp_fl_set_ipv4_udp_tun);
-	} else if (is_tcf_tunnel_release(a)) {
+		}
+		break;
+	case FLOW_ACTION_TUNNEL_DECAP:
 		/* Tunnel decap is handled by default so accept action. */
 		return 0;
-	} else if (is_tcf_pedit(a)) {
-		if (nfp_fl_pedit(a, flow, &nfp_fl->action_data[*a_len],
+	case FLOW_ACTION_MANGLE:
+		if (nfp_fl_pedit(act, flow, &nfp_fl->action_data[*a_len],
 				 a_len, csum_updated))
 			return -EOPNOTSUPP;
-	} else if (is_tcf_csum(a)) {
+		break;
+	case FLOW_ACTION_CSUM:
 		/* csum action requests recalc of something we have not fixed */
-		if (tcf_csum_update_flags(a) & ~*csum_updated)
+		if (act->csum_flags & ~*csum_updated)
 			return -EOPNOTSUPP;
 		/* If we will correctly fix the csum we can remove it from the
 		 * csum update list. Which will later be used to check support.
 		 */
-		*csum_updated &= ~tcf_csum_update_flags(a);
-	} else {
+		*csum_updated &= ~act->csum_flags;
+		break;
+	default:
 		/* Currently we do not handle any other actions. */
 		return -EOPNOTSUPP;
 	}
@@ -886,7 +889,7 @@ int nfp_flower_compile_action(struct nfp_app *app,
 {
 	int act_len, act_cnt, err, tun_out_cnt, out_cnt, i;
 	enum nfp_flower_tun_type tun_type;
-	const struct tc_action *a;
+	struct flow_action_entry *act;
 	u32 csum_updated = 0;
 
 	memset(nfp_flow->action_data, 0, NFP_FL_MAX_A_SIZ);
@@ -897,8 +900,8 @@ int nfp_flower_compile_action(struct nfp_app *app,
 	tun_out_cnt = 0;
 	out_cnt = 0;
 
-	tcf_exts_for_each_action(i, a, flow->exts) {
-		err = nfp_flower_loop_action(app, a, flow, nfp_flow, &act_len,
+	flow_action_for_each(i, act, &flow->rule->action) {
+		err = nfp_flower_loop_action(app, act, flow, nfp_flow, &act_len,
 					     netdev, &tun_type, &tun_out_cnt,
 					     &out_cnt, &csum_updated);
 		if (err)
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 81d5b9304229..833c9ec58a6e 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -2004,21 +2004,21 @@ int qede_get_arfs_filter_count(struct qede_dev *edev)
 }
 
 static int qede_parse_actions(struct qede_dev *edev,
-			      struct tcf_exts *exts)
+			      struct flow_action *flow_action)
 {
+	const struct flow_action_entry *act;
 	int rc = -EINVAL, num_act = 0, i;
-	const struct tc_action *a;
 	bool is_drop = false;
 
-	if (!tcf_exts_has_actions(exts)) {
+	if (!flow_action_has_entries(flow_action)) {
 		DP_NOTICE(edev, "No tc actions received\n");
 		return rc;
 	}
 
-	tcf_exts_for_each_action(i, a, exts) {
+	flow_action_for_each(i, act, flow_action) {
 		num_act++;
 
-		if (is_tcf_gact_shot(a))
+		if (act->id == FLOW_ACTION_DROP)
 			is_drop = true;
 	}
 
@@ -2235,7 +2235,7 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
 	}
 
 	/* parse tc actions and get the vf_id */
-	if (qede_parse_actions(edev, f->exts))
+	if (qede_parse_actions(edev, &f->rule->action))
 		goto unlock;
 
 	if (qede_flow_find_fltr(edev, &t)) {
-- 
2.11.0
