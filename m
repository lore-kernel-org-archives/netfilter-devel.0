From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/12 net-next,v7] flow_offload: add statistics retrieval infrastructure and use it
Date: Sat,  2 Feb 2019 12:50:47 +0100
Message-ID: <20190202115054.4880-6-pablo@netfilter.org>
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

This patch provides the flow_stats structure that acts as container for
tc_cls_flower_offload, then we can use to restore the statistics on the
existing TC actions. Hence, tcf_exts_stats_update() is not used from
drivers anymore.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
v7: rebase on top of net-next.

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c          |  4 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c       |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c |  2 +-
 drivers/net/ethernet/netronome/nfp/flower/offload.c   |  5 ++---
 include/net/flow_offload.h                            | 14 ++++++++++++++
 include/net/pkt_cls.h                                 |  1 +
 net/sched/cls_flower.c                                |  4 ++++
 8 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 90a2170c5138..6a87434b7173 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1396,8 +1396,8 @@ static int bnxt_tc_get_flow_stats(struct bnxt *bp,
 	lastused = flow->lastused;
 	spin_unlock(&flow->stats_lock);
 
-	tcf_exts_stats_update(tc_flow_cmd->exts, stats.bytes, stats.packets,
-			      lastused);
+	flow_stats_update(&tc_flow_cmd->stats, stats.bytes, stats.packets,
+			  lastused);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 39c5af5dad3d..8a2d66ee1d7b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -807,9 +807,9 @@ int cxgb4_tc_flower_stats(struct net_device *dev,
 	if (ofld_stats->packet_count != packets) {
 		if (ofld_stats->prev_packet_count != packets)
 			ofld_stats->last_used = jiffies;
-		tcf_exts_stats_update(cls->exts, bytes - ofld_stats->byte_count,
-				      packets - ofld_stats->packet_count,
-				      ofld_stats->last_used);
+		flow_stats_update(&cls->stats, bytes - ofld_stats->byte_count,
+				  packets - ofld_stats->packet_count,
+				  ofld_stats->last_used);
 
 		ofld_stats->packet_count = packets;
 		ofld_stats->byte_count = bytes;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1c8e8da166bd..c4c6bbcafc68 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3071,7 +3071,7 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 
 out:
-	tcf_exts_stats_update(f->exts, bytes, packets, lastuse);
+	flow_stats_update(&f->stats, bytes, packets, lastuse);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index a20379e29e02..c090ecb62041 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -460,7 +460,7 @@ int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_rule_get_stats;
 
-	tcf_exts_stats_update(f->exts, bytes, packets, lastuse);
+	flow_stats_update(&f->stats, bytes, packets, lastuse);
 
 	mlxsw_sp_acl_ruleset_put(mlxsw_sp, ruleset);
 	return 0;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 74f7ff292052..fe1469d201af 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -554,9 +554,8 @@ nfp_flower_get_stats(struct nfp_app *app, struct net_device *netdev,
 	ctx_id = be32_to_cpu(nfp_flow->meta.host_ctx_id);
 
 	spin_lock_bh(&priv->stats_lock);
-	tcf_exts_stats_update(flow->exts, priv->stats[ctx_id].bytes,
-			      priv->stats[ctx_id].pkts,
-			      priv->stats[ctx_id].used);
+	flow_stats_update(&flow->stats, priv->stats[ctx_id].bytes,
+			  priv->stats[ctx_id].pkts, priv->stats[ctx_id].used);
 
 	priv->stats[ctx_id].pkts = 0;
 	priv->stats[ctx_id].bytes = 0;
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index dabc819b6cc9..f9ce39992dbd 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -179,4 +179,18 @@ static inline bool flow_rule_match_key(const struct flow_rule *rule,
 	return dissector_uses_key(rule->match.dissector, key);
 }
 
+struct flow_stats {
+	u64	pkts;
+	u64	bytes;
+	u64	lastused;
+};
+
+static inline void flow_stats_update(struct flow_stats *flow_stats,
+				     u64 bytes, u64 pkts, u64 lastused)
+{
+	flow_stats->pkts	= pkts;
+	flow_stats->bytes	= bytes;
+	flow_stats->lastused	= lastused;
+}
+
 #endif /* _NET_FLOW_OFFLOAD_H */
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index c470c100b926..bea1b1c3ea9b 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -765,6 +765,7 @@ struct tc_cls_flower_offload {
 	enum tc_fl_command command;
 	unsigned long cookie;
 	struct flow_rule *rule;
+	struct flow_stats stats;
 	struct tcf_exts *exts;
 	u32 classid;
 };
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 48c54ef52a98..8ec85056aa0d 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -429,6 +429,10 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f)
 	cls_flower.classid = f->res.classid;
 
 	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false);
+
+	tcf_exts_stats_update(&f->exts, cls_flower.stats.bytes,
+			      cls_flower.stats.pkts,
+			      cls_flower.stats.lastused);
 }
 
 static bool __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
-- 
2.11.0
