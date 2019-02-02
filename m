From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/12 net-next,v7] dsa: bcm_sf2: use flow_rule infrastructure
Date: Sat,  2 Feb 2019 12:50:52 +0100
Message-ID: <20190202115054.4880-11-pablo@netfilter.org>
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

Update this driver to use the flow_rule infrastructure, hence we can use
the same code to populate hardware IR from ethtool_rx_flow and the
cls_flower interfaces.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v7: rebase on top of net-next.

 drivers/net/dsa/bcm_sf2_cfp.c | 102 +++++++++++++++++++++++++++---------------
 1 file changed, 67 insertions(+), 35 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index e14663ab6dbc..6d8059dc77b7 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -16,6 +16,7 @@
 #include <linux/netdevice.h>
 #include <net/dsa.h>
 #include <linux/bitmap.h>
+#include <net/flow_offload.h>
 
 #include "bcm_sf2.h"
 #include "bcm_sf2_regs.h"
@@ -257,7 +258,8 @@ static int bcm_sf2_cfp_act_pol_set(struct bcm_sf2_priv *priv,
 }
 
 static void bcm_sf2_cfp_slice_ipv4(struct bcm_sf2_priv *priv,
-				   struct ethtool_tcpip4_spec *v4_spec,
+				   struct flow_dissector_key_ipv4_addrs *addrs,
+				   struct flow_dissector_key_ports *ports,
 				   unsigned int slice_num,
 				   bool mask)
 {
@@ -278,7 +280,7 @@ static void bcm_sf2_cfp_slice_ipv4(struct bcm_sf2_priv *priv,
 	 * UDF_n_A6		[23:8]
 	 * UDF_n_A5		[7:0]
 	 */
-	reg = be16_to_cpu(v4_spec->pdst) >> 8;
+	reg = be16_to_cpu(ports->dst) >> 8;
 	if (mask)
 		offset = CORE_CFP_MASK_PORT(3);
 	else
@@ -289,9 +291,9 @@ static void bcm_sf2_cfp_slice_ipv4(struct bcm_sf2_priv *priv,
 	 * UDF_n_A4		[23:8]
 	 * UDF_n_A3		[7:0]
 	 */
-	reg = (be16_to_cpu(v4_spec->pdst) & 0xff) << 24 |
-	      (u32)be16_to_cpu(v4_spec->psrc) << 8 |
-	      (be32_to_cpu(v4_spec->ip4dst) & 0x0000ff00) >> 8;
+	reg = (be16_to_cpu(ports->dst) & 0xff) << 24 |
+	      (u32)be16_to_cpu(ports->src) << 8 |
+	      (be32_to_cpu(addrs->dst) & 0x0000ff00) >> 8;
 	if (mask)
 		offset = CORE_CFP_MASK_PORT(2);
 	else
@@ -302,9 +304,9 @@ static void bcm_sf2_cfp_slice_ipv4(struct bcm_sf2_priv *priv,
 	 * UDF_n_A2		[23:8]
 	 * UDF_n_A1		[7:0]
 	 */
-	reg = (u32)(be32_to_cpu(v4_spec->ip4dst) & 0xff) << 24 |
-	      (u32)(be32_to_cpu(v4_spec->ip4dst) >> 16) << 8 |
-	      (be32_to_cpu(v4_spec->ip4src) & 0x0000ff00) >> 8;
+	reg = (u32)(be32_to_cpu(addrs->dst) & 0xff) << 24 |
+	      (u32)(be32_to_cpu(addrs->dst) >> 16) << 8 |
+	      (be32_to_cpu(addrs->src) & 0x0000ff00) >> 8;
 	if (mask)
 		offset = CORE_CFP_MASK_PORT(1);
 	else
@@ -317,8 +319,8 @@ static void bcm_sf2_cfp_slice_ipv4(struct bcm_sf2_priv *priv,
 	 * Slice ID		[3:2]
 	 * Slice valid		[1:0]
 	 */
-	reg = (u32)(be32_to_cpu(v4_spec->ip4src) & 0xff) << 24 |
-	      (u32)(be32_to_cpu(v4_spec->ip4src) >> 16) << 8 |
+	reg = (u32)(be32_to_cpu(addrs->src) & 0xff) << 24 |
+	      (u32)(be32_to_cpu(addrs->src) >> 16) << 8 |
 	      SLICE_NUM(slice_num) | SLICE_VALID;
 	if (mask)
 		offset = CORE_CFP_MASK_PORT(0);
@@ -332,9 +334,13 @@ static int bcm_sf2_cfp_ipv4_rule_set(struct bcm_sf2_priv *priv, int port,
 				     unsigned int queue_num,
 				     struct ethtool_rx_flow_spec *fs)
 {
-	struct ethtool_tcpip4_spec *v4_spec, *v4_m_spec;
+	struct ethtool_rx_flow_spec_input input = {};
 	const struct cfp_udf_layout *layout;
 	unsigned int slice_num, rule_index;
+	struct ethtool_rx_flow_rule *flow;
+	struct flow_match_ipv4_addrs ipv4;
+	struct flow_match_ports ports;
+	struct flow_match_ip ip;
 	u8 ip_proto, ip_frag;
 	u8 num_udf;
 	u32 reg;
@@ -343,13 +349,9 @@ static int bcm_sf2_cfp_ipv4_rule_set(struct bcm_sf2_priv *priv, int port,
 	switch (fs->flow_type & ~FLOW_EXT) {
 	case TCP_V4_FLOW:
 		ip_proto = IPPROTO_TCP;
-		v4_spec = &fs->h_u.tcp_ip4_spec;
-		v4_m_spec = &fs->m_u.tcp_ip4_spec;
 		break;
 	case UDP_V4_FLOW:
 		ip_proto = IPPROTO_UDP;
-		v4_spec = &fs->h_u.udp_ip4_spec;
-		v4_m_spec = &fs->m_u.udp_ip4_spec;
 		break;
 	default:
 		return -EINVAL;
@@ -367,11 +369,22 @@ static int bcm_sf2_cfp_ipv4_rule_set(struct bcm_sf2_priv *priv, int port,
 	if (rule_index > bcm_sf2_cfp_rule_size(priv))
 		return -ENOSPC;
 
+	input.fs = fs;
+	flow = ethtool_rx_flow_rule_create(&input);
+	if (IS_ERR(flow))
+		return PTR_ERR(flow);
+
+	flow_rule_match_ipv4_addrs(flow->rule, &ipv4);
+	flow_rule_match_ports(flow->rule, &ports);
+	flow_rule_match_ip(flow->rule, &ip);
+
 	layout = &udf_tcpip4_layout;
 	/* We only use one UDF slice for now */
 	slice_num = bcm_sf2_get_slice_number(layout, 0);
-	if (slice_num == UDF_NUM_SLICES)
-		return -EINVAL;
+	if (slice_num == UDF_NUM_SLICES) {
+		ret = -EINVAL;
+		goto out_err_flow_rule;
+	}
 
 	num_udf = bcm_sf2_get_num_udf_slices(layout->udfs[slice_num].slices);
 
@@ -398,7 +411,7 @@ static int bcm_sf2_cfp_ipv4_rule_set(struct bcm_sf2_priv *priv, int port,
 	 * Reserved		[1]
 	 * UDF_Valid[8]		[0]
 	 */
-	core_writel(priv, v4_spec->tos << IPTOS_SHIFT |
+	core_writel(priv, ip.key->tos << IPTOS_SHIFT |
 		    ip_proto << IPPROTO_SHIFT | ip_frag << IP_FRAG_SHIFT |
 		    udf_upper_bits(num_udf),
 		    CORE_CFP_DATA_PORT(6));
@@ -417,8 +430,8 @@ static int bcm_sf2_cfp_ipv4_rule_set(struct bcm_sf2_priv *priv, int port,
 	core_writel(priv, udf_lower_bits(num_udf) << 24, CORE_CFP_MASK_PORT(5));
 
 	/* Program the match and the mask */
-	bcm_sf2_cfp_slice_ipv4(priv, v4_spec, slice_num, false);
-	bcm_sf2_cfp_slice_ipv4(priv, v4_m_spec, SLICE_NUM_MASK, true);
+	bcm_sf2_cfp_slice_ipv4(priv, ipv4.key, ports.key, slice_num, false);
+	bcm_sf2_cfp_slice_ipv4(priv, ipv4.mask, ports.mask, SLICE_NUM_MASK, true);
 
 	/* Insert into TCAM now */
 	bcm_sf2_cfp_rule_addr_set(priv, rule_index);
@@ -426,14 +439,14 @@ static int bcm_sf2_cfp_ipv4_rule_set(struct bcm_sf2_priv *priv, int port,
 	ret = bcm_sf2_cfp_op(priv, OP_SEL_WRITE | TCAM_SEL);
 	if (ret) {
 		pr_err("TCAM entry at addr %d failed\n", rule_index);
-		return ret;
+		goto out_err_flow_rule;
 	}
 
 	/* Insert into Action and policer RAMs now */
 	ret = bcm_sf2_cfp_act_pol_set(priv, rule_index, port_num,
 				      queue_num, true);
 	if (ret)
-		return ret;
+		goto out_err_flow_rule;
 
 	/* Turn on CFP for this rule now */
 	reg = core_readl(priv, CORE_CFP_CTL_REG);
@@ -446,6 +459,10 @@ static int bcm_sf2_cfp_ipv4_rule_set(struct bcm_sf2_priv *priv, int port,
 	fs->location = rule_index;
 
 	return 0;
+
+out_err_flow_rule:
+	ethtool_rx_flow_rule_destroy(flow);
+	return ret;
 }
 
 static void bcm_sf2_cfp_slice_ipv6(struct bcm_sf2_priv *priv,
@@ -582,8 +599,12 @@ static int bcm_sf2_cfp_ipv6_rule_set(struct bcm_sf2_priv *priv, int port,
 				     struct ethtool_rx_flow_spec *fs)
 {
 	struct ethtool_tcpip6_spec *v6_spec, *v6_m_spec;
+	struct ethtool_rx_flow_spec_input input = {};
 	unsigned int slice_num, rule_index[2];
 	const struct cfp_udf_layout *layout;
+	struct ethtool_rx_flow_rule *flow;
+	struct flow_match_ipv6_addrs ipv6;
+	struct flow_match_ports ports;
 	u8 ip_proto, ip_frag;
 	int ret = 0;
 	u8 num_udf;
@@ -645,6 +666,15 @@ static int bcm_sf2_cfp_ipv6_rule_set(struct bcm_sf2_priv *priv, int port,
 		goto out_err;
 	}
 
+	input.fs = fs;
+	flow = ethtool_rx_flow_rule_create(&input);
+	if (IS_ERR(flow)) {
+		ret = PTR_ERR(flow);
+		goto out_err;
+	}
+	flow_rule_match_ipv6_addrs(flow->rule, &ipv6);
+	flow_rule_match_ports(flow->rule, &ports);
+
 	/* Apply the UDF layout for this filter */
 	bcm_sf2_cfp_udf_set(priv, layout, slice_num);
 
@@ -688,10 +718,10 @@ static int bcm_sf2_cfp_ipv6_rule_set(struct bcm_sf2_priv *priv, int port,
 	core_writel(priv, udf_lower_bits(num_udf) << 24, CORE_CFP_MASK_PORT(5));
 
 	/* Slice the IPv6 source address and port */
-	bcm_sf2_cfp_slice_ipv6(priv, v6_spec->ip6src, v6_spec->psrc,
-				slice_num, false);
-	bcm_sf2_cfp_slice_ipv6(priv, v6_m_spec->ip6src, v6_m_spec->psrc,
-				SLICE_NUM_MASK, true);
+	bcm_sf2_cfp_slice_ipv6(priv, ipv6.key->src.in6_u.u6_addr32,
+			       ports.key->src, slice_num, false);
+	bcm_sf2_cfp_slice_ipv6(priv, ipv6.mask->src.in6_u.u6_addr32,
+			       ports.mask->src, SLICE_NUM_MASK, true);
 
 	/* Insert into TCAM now because we need to insert a second rule */
 	bcm_sf2_cfp_rule_addr_set(priv, rule_index[0]);
@@ -699,20 +729,20 @@ static int bcm_sf2_cfp_ipv6_rule_set(struct bcm_sf2_priv *priv, int port,
 	ret = bcm_sf2_cfp_op(priv, OP_SEL_WRITE | TCAM_SEL);
 	if (ret) {
 		pr_err("TCAM entry at addr %d failed\n", rule_index[0]);
-		goto out_err;
+		goto out_err_flow_rule;
 	}
 
 	/* Insert into Action and policer RAMs now */
 	ret = bcm_sf2_cfp_act_pol_set(priv, rule_index[0], port_num,
 				      queue_num, false);
 	if (ret)
-		goto out_err;
+		goto out_err_flow_rule;
 
 	/* Now deal with the second slice to chain this rule */
 	slice_num = bcm_sf2_get_slice_number(layout, slice_num + 1);
 	if (slice_num == UDF_NUM_SLICES) {
 		ret = -EINVAL;
-		goto out_err;
+		goto out_err_flow_rule;
 	}
 
 	num_udf = bcm_sf2_get_num_udf_slices(layout->udfs[slice_num].slices);
@@ -748,10 +778,10 @@ static int bcm_sf2_cfp_ipv6_rule_set(struct bcm_sf2_priv *priv, int port,
 	/* Mask all */
 	core_writel(priv, 0, CORE_CFP_MASK_PORT(5));
 
-	bcm_sf2_cfp_slice_ipv6(priv, v6_spec->ip6dst, v6_spec->pdst, slice_num,
-			       false);
-	bcm_sf2_cfp_slice_ipv6(priv, v6_m_spec->ip6dst, v6_m_spec->pdst,
-			       SLICE_NUM_MASK, true);
+	bcm_sf2_cfp_slice_ipv6(priv, ipv6.key->dst.in6_u.u6_addr32,
+			       ports.key->dst, slice_num, false);
+	bcm_sf2_cfp_slice_ipv6(priv, ipv6.mask->dst.in6_u.u6_addr32,
+			       ports.key->dst, SLICE_NUM_MASK, true);
 
 	/* Insert into TCAM now */
 	bcm_sf2_cfp_rule_addr_set(priv, rule_index[1]);
@@ -759,7 +789,7 @@ static int bcm_sf2_cfp_ipv6_rule_set(struct bcm_sf2_priv *priv, int port,
 	ret = bcm_sf2_cfp_op(priv, OP_SEL_WRITE | TCAM_SEL);
 	if (ret) {
 		pr_err("TCAM entry at addr %d failed\n", rule_index[1]);
-		goto out_err;
+		goto out_err_flow_rule;
 	}
 
 	/* Insert into Action and policer RAMs now, set chain ID to
@@ -768,7 +798,7 @@ static int bcm_sf2_cfp_ipv6_rule_set(struct bcm_sf2_priv *priv, int port,
 	ret = bcm_sf2_cfp_act_pol_set(priv, rule_index[1], port_num,
 				      queue_num, true);
 	if (ret)
-		goto out_err;
+		goto out_err_flow_rule;
 
 	/* Turn on CFP for this rule now */
 	reg = core_readl(priv, CORE_CFP_CTL_REG);
@@ -784,6 +814,8 @@ static int bcm_sf2_cfp_ipv6_rule_set(struct bcm_sf2_priv *priv, int port,
 
 	return ret;
 
+out_err_flow_rule:
+	ethtool_rx_flow_rule_destroy(flow);
 out_err:
 	clear_bit(rule_index[1], priv->cfp.used);
 	return ret;
-- 
2.11.0
