From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/12 net-next,v7] net/mlx5e: support for two independent packet edit actions
Date: Sat,  2 Feb 2019 12:50:44 +0100
Message-ID: <20190202115054.4880-3-pablo@netfilter.org>
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

This patch adds pedit_headers_action structure to store the result of
parsing tc pedit actions. Then, it calls alloc_tc_pedit_action() to
populate the mlx5e hardware intermediate representation once all actions
have been parsed.

This patch comes in preparation for the new flow_action infrastructure,
where each packet mangling comes in an separated action, ie. not packed
as in tc pedit.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
---
v7: rebase on top of net-next.

 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 81 ++++++++++++++++++-------
 1 file changed, 59 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index cd289ce0582d..1c8e8da166bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1804,6 +1804,12 @@ struct pedit_headers {
 	struct udphdr  udp;
 };
 
+struct pedit_headers_action {
+	struct pedit_headers	vals;
+	struct pedit_headers	masks;
+	u32			pedits;
+};
+
 static int pedit_header_offsets[] = {
 	[TCA_PEDIT_KEY_EX_HDR_TYPE_ETH] = offsetof(struct pedit_headers, eth),
 	[TCA_PEDIT_KEY_EX_HDR_TYPE_IP4] = offsetof(struct pedit_headers, ip4),
@@ -1815,16 +1821,15 @@ static int pedit_header_offsets[] = {
 #define pedit_header(_ph, _htype) ((void *)(_ph) + pedit_header_offsets[_htype])
 
 static int set_pedit_val(u8 hdr_type, u32 mask, u32 val, u32 offset,
-			 struct pedit_headers *masks,
-			 struct pedit_headers *vals)
+			 struct pedit_headers_action *hdrs)
 {
 	u32 *curr_pmask, *curr_pval;
 
 	if (hdr_type >= __PEDIT_HDR_TYPE_MAX)
 		goto out_err;
 
-	curr_pmask = (u32 *)(pedit_header(masks, hdr_type) + offset);
-	curr_pval  = (u32 *)(pedit_header(vals, hdr_type) + offset);
+	curr_pmask = (u32 *)(pedit_header(&hdrs->masks, hdr_type) + offset);
+	curr_pval  = (u32 *)(pedit_header(&hdrs->vals, hdr_type) + offset);
 
 	if (*curr_pmask & mask)  /* disallow acting twice on the same location */
 		goto out_err;
@@ -1880,8 +1885,7 @@ static struct mlx5_fields fields[] = {
  * max from the SW pedit action. On success, it says how many HW actions were
  * actually parsed.
  */
-static int offload_pedit_fields(struct pedit_headers *masks,
-				struct pedit_headers *vals,
+static int offload_pedit_fields(struct pedit_headers_action *hdrs,
 				struct mlx5e_tc_flow_parse_attr *parse_attr,
 				struct netlink_ext_ack *extack)
 {
@@ -1896,10 +1900,10 @@ static int offload_pedit_fields(struct pedit_headers *masks,
 	__be16 mask_be16;
 	void *action;
 
-	set_masks = &masks[TCA_PEDIT_KEY_EX_CMD_SET];
-	add_masks = &masks[TCA_PEDIT_KEY_EX_CMD_ADD];
-	set_vals = &vals[TCA_PEDIT_KEY_EX_CMD_SET];
-	add_vals = &vals[TCA_PEDIT_KEY_EX_CMD_ADD];
+	set_masks = &hdrs[TCA_PEDIT_KEY_EX_CMD_SET].masks;
+	add_masks = &hdrs[TCA_PEDIT_KEY_EX_CMD_ADD].masks;
+	set_vals = &hdrs[TCA_PEDIT_KEY_EX_CMD_SET].vals;
+	add_vals = &hdrs[TCA_PEDIT_KEY_EX_CMD_ADD].vals;
 
 	action_size = MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto);
 	action = parse_attr->mod_hdr_actions;
@@ -1995,12 +1999,14 @@ static int offload_pedit_fields(struct pedit_headers *masks,
 }
 
 static int alloc_mod_hdr_actions(struct mlx5e_priv *priv,
-				 const struct tc_action *a, int namespace,
+				 struct pedit_headers_action *hdrs,
+				 int namespace,
 				 struct mlx5e_tc_flow_parse_attr *parse_attr)
 {
 	int nkeys, action_size, max_actions;
 
-	nkeys = tcf_pedit_nkeys(a);
+	nkeys = hdrs[TCA_PEDIT_KEY_EX_CMD_SET].pedits +
+		hdrs[TCA_PEDIT_KEY_EX_CMD_ADD].pedits;
 	action_size = MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto);
 
 	if (namespace == MLX5_FLOW_NAMESPACE_FDB) /* FDB offloading */
@@ -2024,18 +2030,15 @@ static const struct pedit_headers zero_masks = {};
 static int parse_tc_pedit_action(struct mlx5e_priv *priv,
 				 const struct tc_action *a, int namespace,
 				 struct mlx5e_tc_flow_parse_attr *parse_attr,
+				 struct pedit_headers_action *hdrs,
 				 struct netlink_ext_ack *extack)
 {
-	struct pedit_headers masks[__PEDIT_CMD_MAX], vals[__PEDIT_CMD_MAX], *cmd_masks;
 	int nkeys, i, err = -EOPNOTSUPP;
 	u32 mask, val, offset;
 	u8 cmd, htype;
 
 	nkeys = tcf_pedit_nkeys(a);
 
-	memset(masks, 0, sizeof(struct pedit_headers) * __PEDIT_CMD_MAX);
-	memset(vals,  0, sizeof(struct pedit_headers) * __PEDIT_CMD_MAX);
-
 	for (i = 0; i < nkeys; i++) {
 		htype = tcf_pedit_htype(a, i);
 		cmd = tcf_pedit_cmd(a, i);
@@ -2056,21 +2059,37 @@ static int parse_tc_pedit_action(struct mlx5e_priv *priv,
 		val = tcf_pedit_val(a, i);
 		offset = tcf_pedit_offset(a, i);
 
-		err = set_pedit_val(htype, ~mask, val, offset, &masks[cmd], &vals[cmd]);
+		err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd]);
 		if (err)
 			goto out_err;
+
+		hdrs[cmd].pedits++;
 	}
 
-	err = alloc_mod_hdr_actions(priv, a, namespace, parse_attr);
+	return 0;
+out_err:
+	return err;
+}
+
+static int alloc_tc_pedit_action(struct mlx5e_priv *priv, int namespace,
+				 struct mlx5e_tc_flow_parse_attr *parse_attr,
+				 struct pedit_headers_action *hdrs,
+				 struct netlink_ext_ack *extack)
+{
+	struct pedit_headers *cmd_masks;
+	int err;
+	u8 cmd;
+
+	err = alloc_mod_hdr_actions(priv, hdrs, namespace, parse_attr);
 	if (err)
 		goto out_err;
 
-	err = offload_pedit_fields(masks, vals, parse_attr, extack);
+	err = offload_pedit_fields(hdrs, parse_attr, extack);
 	if (err < 0)
 		goto out_dealloc_parsed_actions;
 
 	for (cmd = 0; cmd < __PEDIT_CMD_MAX; cmd++) {
-		cmd_masks = &masks[cmd];
+		cmd_masks = &hdrs[cmd].masks;
 		if (memcmp(cmd_masks, &zero_masks, sizeof(zero_masks))) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "attempt to offload an unsupported field");
@@ -2211,6 +2230,7 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 				struct mlx5e_tc_flow *flow,
 				struct netlink_ext_ack *extack)
 {
+	struct pedit_headers_action hdrs[__PEDIT_CMD_MAX] = {};
 	struct mlx5_nic_flow_attr *attr = flow->nic_attr;
 	const struct tc_action *a;
 	u32 action = 0;
@@ -2232,7 +2252,7 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 
 		if (is_tcf_pedit(a)) {
 			err = parse_tc_pedit_action(priv, a, MLX5_FLOW_NAMESPACE_KERNEL,
-						    parse_attr, extack);
+						    parse_attr, hdrs, extack);
 			if (err)
 				return err;
 
@@ -2286,6 +2306,14 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 		return -EINVAL;
 	}
 
+	if (hdrs[TCA_PEDIT_KEY_EX_CMD_SET].pedits ||
+	    hdrs[TCA_PEDIT_KEY_EX_CMD_ADD].pedits) {
+		err = alloc_tc_pedit_action(priv, MLX5_FLOW_NAMESPACE_KERNEL,
+					    parse_attr, hdrs, extack);
+		if (err)
+			return err;
+	}
+
 	attr->action = action;
 	if (!actions_match_supported(priv, exts, parse_attr, flow, extack))
 		return -EOPNOTSUPP;
@@ -2446,6 +2474,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 				struct mlx5e_tc_flow *flow,
 				struct netlink_ext_ack *extack)
 {
+	struct pedit_headers_action hdrs[__PEDIT_CMD_MAX] = {};
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
@@ -2470,7 +2499,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 
 		if (is_tcf_pedit(a)) {
 			err = parse_tc_pedit_action(priv, a, MLX5_FLOW_NAMESPACE_FDB,
-						    parse_attr, extack);
+						    parse_attr, hdrs, extack);
 			if (err)
 				return err;
 
@@ -2605,6 +2634,14 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 		return -EINVAL;
 	}
 
+	if (hdrs[TCA_PEDIT_KEY_EX_CMD_SET].pedits ||
+	    hdrs[TCA_PEDIT_KEY_EX_CMD_ADD].pedits) {
+		err = alloc_tc_pedit_action(priv, MLX5_FLOW_NAMESPACE_KERNEL,
+					    parse_attr, hdrs, extack);
+		if (err)
+			return err;
+	}
+
 	attr->action = action;
 	if (!actions_match_supported(priv, exts, parse_attr, flow, extack))
 		return -EOPNOTSUPP;
-- 
2.11.0
