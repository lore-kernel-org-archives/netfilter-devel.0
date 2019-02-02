From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/12 net-next,v7] qede: use ethtool_rx_flow_rule() to remove duplicated parser code
Date: Sat,  2 Feb 2019 12:50:54 +0100
Message-ID: <20190202115054.4880-13-pablo@netfilter.org>
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

The qede driver supports for ethtool_rx_flow_spec and flower, both
codebases look very similar.

This patch uses the ethtool_rx_flow_rule() infrastructure to remove the
duplicated ethtool_rx_flow_spec parser and consolidate ACL offload
support around the flow_rule infrastructure.

Furthermore, more code can be consolidated by merging
qede_add_cls_rule() and qede_add_tc_flower_fltr(), these two functions
also look very similar.

This driver currently provides simple ACL support, such as 5-tuple
matching, drop policy and queue to CPU.

Drivers that support more features can benefit from this infrastructure
to save even more redundant codebase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v7: rebase on top of net-next.

 drivers/net/ethernet/qlogic/qede/qede_filter.c | 279 +++++++------------------
 1 file changed, 76 insertions(+), 203 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index ed77950f6cf9..add922b93d2c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1665,132 +1665,6 @@ static int qede_set_v6_tuple_to_profile(struct qede_dev *edev,
 	return 0;
 }
 
-static int qede_flow_spec_to_tuple_ipv4_common(struct qede_dev *edev,
-					       struct qede_arfs_tuple *t,
-					       struct ethtool_rx_flow_spec *fs)
-{
-	if ((fs->h_u.tcp_ip4_spec.ip4src &
-	     fs->m_u.tcp_ip4_spec.ip4src) != fs->h_u.tcp_ip4_spec.ip4src) {
-		DP_INFO(edev, "Don't support IP-masks\n");
-		return -EOPNOTSUPP;
-	}
-
-	if ((fs->h_u.tcp_ip4_spec.ip4dst &
-	     fs->m_u.tcp_ip4_spec.ip4dst) != fs->h_u.tcp_ip4_spec.ip4dst) {
-		DP_INFO(edev, "Don't support IP-masks\n");
-		return -EOPNOTSUPP;
-	}
-
-	if ((fs->h_u.tcp_ip4_spec.psrc &
-	     fs->m_u.tcp_ip4_spec.psrc) != fs->h_u.tcp_ip4_spec.psrc) {
-		DP_INFO(edev, "Don't support port-masks\n");
-		return -EOPNOTSUPP;
-	}
-
-	if ((fs->h_u.tcp_ip4_spec.pdst &
-	     fs->m_u.tcp_ip4_spec.pdst) != fs->h_u.tcp_ip4_spec.pdst) {
-		DP_INFO(edev, "Don't support port-masks\n");
-		return -EOPNOTSUPP;
-	}
-
-	if (fs->h_u.tcp_ip4_spec.tos) {
-		DP_INFO(edev, "Don't support tos\n");
-		return -EOPNOTSUPP;
-	}
-
-	t->eth_proto = htons(ETH_P_IP);
-	t->src_ipv4 = fs->h_u.tcp_ip4_spec.ip4src;
-	t->dst_ipv4 = fs->h_u.tcp_ip4_spec.ip4dst;
-	t->src_port = fs->h_u.tcp_ip4_spec.psrc;
-	t->dst_port = fs->h_u.tcp_ip4_spec.pdst;
-
-	return qede_set_v4_tuple_to_profile(edev, t);
-}
-
-static int qede_flow_spec_to_tuple_tcpv4(struct qede_dev *edev,
-					 struct qede_arfs_tuple *t,
-					 struct ethtool_rx_flow_spec *fs)
-{
-	t->ip_proto = IPPROTO_TCP;
-
-	if (qede_flow_spec_to_tuple_ipv4_common(edev, t, fs))
-		return -EINVAL;
-
-	return 0;
-}
-
-static int qede_flow_spec_to_tuple_udpv4(struct qede_dev *edev,
-					 struct qede_arfs_tuple *t,
-					 struct ethtool_rx_flow_spec *fs)
-{
-	t->ip_proto = IPPROTO_UDP;
-
-	if (qede_flow_spec_to_tuple_ipv4_common(edev, t, fs))
-		return -EINVAL;
-
-	return 0;
-}
-
-static int qede_flow_spec_to_tuple_ipv6_common(struct qede_dev *edev,
-					       struct qede_arfs_tuple *t,
-					       struct ethtool_rx_flow_spec *fs)
-{
-	struct in6_addr zero_addr;
-
-	memset(&zero_addr, 0, sizeof(zero_addr));
-
-	if ((fs->h_u.tcp_ip6_spec.psrc &
-	     fs->m_u.tcp_ip6_spec.psrc) != fs->h_u.tcp_ip6_spec.psrc) {
-		DP_INFO(edev, "Don't support port-masks\n");
-		return -EOPNOTSUPP;
-	}
-
-	if ((fs->h_u.tcp_ip6_spec.pdst &
-	     fs->m_u.tcp_ip6_spec.pdst) != fs->h_u.tcp_ip6_spec.pdst) {
-		DP_INFO(edev, "Don't support port-masks\n");
-		return -EOPNOTSUPP;
-	}
-
-	if (fs->h_u.tcp_ip6_spec.tclass) {
-		DP_INFO(edev, "Don't support tclass\n");
-		return -EOPNOTSUPP;
-	}
-
-	t->eth_proto = htons(ETH_P_IPV6);
-	memcpy(&t->src_ipv6, &fs->h_u.tcp_ip6_spec.ip6src,
-	       sizeof(struct in6_addr));
-	memcpy(&t->dst_ipv6, &fs->h_u.tcp_ip6_spec.ip6dst,
-	       sizeof(struct in6_addr));
-	t->src_port = fs->h_u.tcp_ip6_spec.psrc;
-	t->dst_port = fs->h_u.tcp_ip6_spec.pdst;
-
-	return qede_set_v6_tuple_to_profile(edev, t, &zero_addr);
-}
-
-static int qede_flow_spec_to_tuple_tcpv6(struct qede_dev *edev,
-					 struct qede_arfs_tuple *t,
-					 struct ethtool_rx_flow_spec *fs)
-{
-	t->ip_proto = IPPROTO_TCP;
-
-	if (qede_flow_spec_to_tuple_ipv6_common(edev, t, fs))
-		return -EINVAL;
-
-	return 0;
-}
-
-static int qede_flow_spec_to_tuple_udpv6(struct qede_dev *edev,
-					 struct qede_arfs_tuple *t,
-					 struct ethtool_rx_flow_spec *fs)
-{
-	t->ip_proto = IPPROTO_UDP;
-
-	if (qede_flow_spec_to_tuple_ipv6_common(edev, t, fs))
-		return -EINVAL;
-
-	return 0;
-}
-
 /* Must be called while qede lock is held */
 static struct qede_arfs_fltr_node *
 qede_flow_find_fltr(struct qede_dev *edev, struct qede_arfs_tuple *t)
@@ -1875,34 +1749,38 @@ static int qede_parse_actions(struct qede_dev *edev,
 			      struct flow_action *flow_action)
 {
 	const struct flow_action_entry *act;
-	int rc = -EINVAL, num_act = 0, i;
-	bool is_drop = false;
+	int i;
 
 	if (!flow_action_has_entries(flow_action)) {
-		DP_NOTICE(edev, "No tc actions received\n");
-		return rc;
+		DP_NOTICE(edev, "No actions received\n");
+		return -EINVAL;
 	}
 
 	flow_action_for_each(i, act, flow_action) {
-		num_act++;
+		switch (act->id) {
+		case FLOW_ACTION_DROP:
+			break;
+		case FLOW_ACTION_QUEUE:
+			if (act->queue.vf)
+				break;
 
-		if (act->id == FLOW_ACTION_DROP)
-			is_drop = true;
+			if (act->queue.index >= QEDE_RSS_COUNT(edev)) {
+				DP_INFO(edev, "Queue out-of-bounds\n");
+				return -EINVAL;
+			}
+			break;
+		default:
+			return -EINVAL;
+		}
 	}
 
-	if (num_act == 1 && is_drop)
-		return 0;
-
-	return rc;
+	return 0;
 }
 
 static int
-qede_tc_parse_ports(struct qede_dev *edev,
-		    struct tc_cls_flower_offload *f,
-		    struct qede_arfs_tuple *t)
+qede_flow_parse_ports(struct qede_dev *edev, struct flow_rule *rule,
+		      struct qede_arfs_tuple *t)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
-
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
 		struct flow_match_ports match;
 
@@ -1921,11 +1799,9 @@ qede_tc_parse_ports(struct qede_dev *edev,
 }
 
 static int
-qede_tc_parse_v6_common(struct qede_dev *edev,
-			struct tc_cls_flower_offload *f,
-			struct qede_arfs_tuple *t)
+qede_flow_parse_v6_common(struct qede_dev *edev, struct flow_rule *rule,
+			  struct qede_arfs_tuple *t)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
 	struct in6_addr zero_addr, addr;
 
 	memset(&zero_addr, 0, sizeof(addr));
@@ -1948,19 +1824,16 @@ qede_tc_parse_v6_common(struct qede_dev *edev,
 		memcpy(&t->dst_ipv6, &match.key->dst, sizeof(addr));
 	}
 
-	if (qede_tc_parse_ports(edev, f, t))
+	if (qede_flow_parse_ports(edev, rule, t))
 		return -EINVAL;
 
 	return qede_set_v6_tuple_to_profile(edev, t, &zero_addr);
 }
 
 static int
-qede_tc_parse_v4_common(struct qede_dev *edev,
-			struct tc_cls_flower_offload *f,
+qede_flow_parse_v4_common(struct qede_dev *edev, struct flow_rule *rule,
 			struct qede_arfs_tuple *t)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
-
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
 		struct flow_match_ipv4_addrs match;
 
@@ -1975,62 +1848,56 @@ qede_tc_parse_v4_common(struct qede_dev *edev,
 		t->dst_ipv4 = match.key->dst;
 	}
 
-	if (qede_tc_parse_ports(edev, f, t))
+	if (qede_flow_parse_ports(edev, rule, t))
 		return -EINVAL;
 
 	return qede_set_v4_tuple_to_profile(edev, t);
 }
 
 static int
-qede_tc_parse_tcp_v6(struct qede_dev *edev,
-		     struct tc_cls_flower_offload *f,
+qede_flow_parse_tcp_v6(struct qede_dev *edev, struct flow_rule *rule,
 		     struct qede_arfs_tuple *tuple)
 {
 	tuple->ip_proto = IPPROTO_TCP;
 	tuple->eth_proto = htons(ETH_P_IPV6);
 
-	return qede_tc_parse_v6_common(edev, f, tuple);
+	return qede_flow_parse_v6_common(edev, rule, tuple);
 }
 
 static int
-qede_tc_parse_tcp_v4(struct qede_dev *edev,
-		     struct tc_cls_flower_offload *f,
+qede_flow_parse_tcp_v4(struct qede_dev *edev, struct flow_rule *rule,
 		     struct qede_arfs_tuple *tuple)
 {
 	tuple->ip_proto = IPPROTO_TCP;
 	tuple->eth_proto = htons(ETH_P_IP);
 
-	return qede_tc_parse_v4_common(edev, f, tuple);
+	return qede_flow_parse_v4_common(edev, rule, tuple);
 }
 
 static int
-qede_tc_parse_udp_v6(struct qede_dev *edev,
-		     struct tc_cls_flower_offload *f,
+qede_flow_parse_udp_v6(struct qede_dev *edev, struct flow_rule *rule,
 		     struct qede_arfs_tuple *tuple)
 {
 	tuple->ip_proto = IPPROTO_UDP;
 	tuple->eth_proto = htons(ETH_P_IPV6);
 
-	return qede_tc_parse_v6_common(edev, f, tuple);
+	return qede_flow_parse_v6_common(edev, rule, tuple);
 }
 
 static int
-qede_tc_parse_udp_v4(struct qede_dev *edev,
-		     struct tc_cls_flower_offload *f,
+qede_flow_parse_udp_v4(struct qede_dev *edev, struct flow_rule *rule,
 		     struct qede_arfs_tuple *tuple)
 {
 	tuple->ip_proto = IPPROTO_UDP;
 	tuple->eth_proto = htons(ETH_P_IP);
 
-	return qede_tc_parse_v4_common(edev, f, tuple);
+	return qede_flow_parse_v4_common(edev, rule, tuple);
 }
 
 static int
-qede_parse_flower_attr(struct qede_dev *edev, __be16 proto,
-		       struct tc_cls_flower_offload *f,
-		       struct qede_arfs_tuple *tuple)
+qede_parse_flow_attr(struct qede_dev *edev, __be16 proto,
+		     struct flow_rule *rule, struct qede_arfs_tuple *tuple)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
 	int rc = -EINVAL;
 	u8 ip_proto = 0;
@@ -2062,15 +1929,15 @@ qede_parse_flower_attr(struct qede_dev *edev, __be16 proto,
 	}
 
 	if (ip_proto == IPPROTO_TCP && proto == htons(ETH_P_IP))
-		rc = qede_tc_parse_tcp_v4(edev, f, tuple);
+		rc = qede_flow_parse_tcp_v4(edev, rule, tuple);
 	else if (ip_proto == IPPROTO_TCP && proto == htons(ETH_P_IPV6))
-		rc = qede_tc_parse_tcp_v6(edev, f, tuple);
+		rc = qede_flow_parse_tcp_v6(edev, rule, tuple);
 	else if (ip_proto == IPPROTO_UDP && proto == htons(ETH_P_IP))
-		rc = qede_tc_parse_udp_v4(edev, f, tuple);
+		rc = qede_flow_parse_udp_v4(edev, rule, tuple);
 	else if (ip_proto == IPPROTO_UDP && proto == htons(ETH_P_IPV6))
-		rc = qede_tc_parse_udp_v6(edev, f, tuple);
+		rc = qede_flow_parse_udp_v6(edev, rule, tuple);
 	else
-		DP_NOTICE(edev, "Invalid tc protocol request\n");
+		DP_NOTICE(edev, "Invalid protocol request\n");
 
 	return rc;
 }
@@ -2090,7 +1957,7 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
 	}
 
 	/* parse flower attribute and prepare filter */
-	if (qede_parse_flower_attr(edev, proto, f, &t))
+	if (qede_parse_flow_attr(edev, proto, f->rule, &t))
 		goto unlock;
 
 	/* Validate profile mode and number of filters */
@@ -2147,16 +2014,17 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
 }
 
 static int qede_flow_spec_validate(struct qede_dev *edev,
-				   struct ethtool_rx_flow_spec *fs,
-				   struct qede_arfs_tuple *t)
+				   struct flow_action *flow_action,
+				   struct qede_arfs_tuple *t,
+				   __u32 location)
 {
-	if (fs->location >= QEDE_RFS_MAX_FLTR) {
+	if (location >= QEDE_RFS_MAX_FLTR) {
 		DP_INFO(edev, "Location out-of-bounds\n");
 		return -EINVAL;
 	}
 
 	/* Check location isn't already in use */
-	if (test_bit(fs->location, edev->arfs->arfs_fltr_bmap)) {
+	if (test_bit(location, edev->arfs->arfs_fltr_bmap)) {
 		DP_INFO(edev, "Location already in use\n");
 		return -EINVAL;
 	}
@@ -2170,46 +2038,56 @@ static int qede_flow_spec_validate(struct qede_dev *edev,
 		return -EINVAL;
 	}
 
-	/* If drop requested then no need to validate other data */
-	if (fs->ring_cookie == RX_CLS_FLOW_DISC)
-		return 0;
-
-	if (ethtool_get_flow_spec_ring_vf(fs->ring_cookie))
-		return 0;
-
-	if (fs->ring_cookie >= QEDE_RSS_COUNT(edev)) {
-		DP_INFO(edev, "Queue out-of-bounds\n");
+	if (qede_parse_actions(edev, flow_action))
 		return -EINVAL;
-	}
 
 	return 0;
 }
 
-static int qede_flow_spec_to_tuple(struct qede_dev *edev,
-				   struct qede_arfs_tuple *t,
-				   struct ethtool_rx_flow_spec *fs)
+static int qede_flow_spec_to_rule(struct qede_dev *edev,
+				  struct qede_arfs_tuple *t,
+				  struct ethtool_rx_flow_spec *fs)
 {
-	memset(t, 0, sizeof(*t));
+	struct ethtool_rx_flow_spec_input input = {};
+	struct ethtool_rx_flow_rule *flow;
+	__be16 proto;
+	int err = 0;
 
 	if (qede_flow_spec_validate_unused(edev, fs))
 		return -EOPNOTSUPP;
 
 	switch ((fs->flow_type & ~FLOW_EXT)) {
 	case TCP_V4_FLOW:
-		return qede_flow_spec_to_tuple_tcpv4(edev, t, fs);
 	case UDP_V4_FLOW:
-		return qede_flow_spec_to_tuple_udpv4(edev, t, fs);
+		proto = htons(ETH_P_IP);
+		break;
 	case TCP_V6_FLOW:
-		return qede_flow_spec_to_tuple_tcpv6(edev, t, fs);
 	case UDP_V6_FLOW:
-		return qede_flow_spec_to_tuple_udpv6(edev, t, fs);
+		proto = htons(ETH_P_IPV6);
+		break;
 	default:
 		DP_VERBOSE(edev, NETIF_MSG_IFUP,
 			   "Can't support flow of type %08x\n", fs->flow_type);
 		return -EOPNOTSUPP;
 	}
 
-	return 0;
+	input.fs = fs;
+	flow = ethtool_rx_flow_rule_create(&input);
+	if (IS_ERR(flow))
+		return PTR_ERR(flow);
+
+	if (qede_parse_flow_attr(edev, proto, flow->rule, t)) {
+		err = -EINVAL;
+		goto err_out;
+	}
+
+	/* Make sure location is valid and filter isn't already set */
+	err = qede_flow_spec_validate(edev, &flow->rule->action, t,
+				      fs->location);
+err_out:
+	ethtool_rx_flow_rule_destroy(flow);
+	return err;
+
 }
 
 int qede_add_cls_rule(struct qede_dev *edev, struct ethtool_rxnfc *info)
@@ -2227,12 +2105,7 @@ int qede_add_cls_rule(struct qede_dev *edev, struct ethtool_rxnfc *info)
 	}
 
 	/* Translate the flow specification into something fittign our DB */
-	rc = qede_flow_spec_to_tuple(edev, &t, fsp);
-	if (rc)
-		goto unlock;
-
-	/* Make sure location is valid and filter isn't already set */
-	rc = qede_flow_spec_validate(edev, fsp, &t);
+	rc = qede_flow_spec_to_rule(edev, &t, fsp);
 	if (rc)
 		goto unlock;
 
-- 
2.11.0
