From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/12 net-next,v7] flow_offload: add wake-up-on-lan and queue to flow_action
Date: Sat,  2 Feb 2019 12:50:50 +0100
Message-ID: <20190202115054.4880-9-pablo@netfilter.org>
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

These actions need to be added to support the ethtool_rx_flow interface.
The queue action includes a field to specify the RSS context, that is
set via FLOW_RSS flow type flag and the rss_context field in struct
ethtool_rxnfc, plus the corresponding queue index. FLOW_RSS implies that
rss_context is non-zero, therefore, queue.ctx == 0 means that FLOW_RSS
was not set. Also add a field to store the vf index which is stored in
the ethtool_rxnfc ring_cookie field.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
v7: rebase on top of net-next.

 include/net/flow_offload.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index f9ce39992dbd..23166caa0da5 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -116,6 +116,8 @@ enum flow_action_id {
 	FLOW_ACTION_ADD,
 	FLOW_ACTION_CSUM,
 	FLOW_ACTION_MARK,
+	FLOW_ACTION_WAKE,
+	FLOW_ACTION_QUEUE,
 };
 
 /* This is mirroring enum pedit_header_type definition for easy mapping between
@@ -150,6 +152,11 @@ struct flow_action_entry {
 		const struct ip_tunnel_info *tunnel;	/* FLOW_ACTION_TUNNEL_ENCAP */
 		u32			csum_flags;	/* FLOW_ACTION_CSUM */
 		u32			mark;		/* FLOW_ACTION_MARK */
+		struct {				/* FLOW_ACTION_QUEUE */
+			u32		ctx;
+			u32		index;
+			u8		vf;
+		} queue;
 	};
 };
 
-- 
2.11.0
