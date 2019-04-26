Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE124C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 00:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD282206C1
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 00:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbfDZAeV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 20:34:21 -0400
Received: from mail.us.es ([193.147.175.20]:55210 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729987AbfDZAeF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 20:34:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 87E51B4978
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 02:34:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7891FDA70D
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 02:34:03 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6DD33DA707; Fri, 26 Apr 2019 02:34:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50D33DA705;
        Fri, 26 Apr 2019 02:34:00 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 02:34:00 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F12004265A31;
        Fri, 26 Apr 2019 02:33:59 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@mellanox.com,
        john.hurley@netronome.com, jakub.kicinski@netronome.com,
        ogerlitz@mellanox.com
Subject: [PATCH net-next,RFC 6/9] net: sched: add tcf_setup_block_offload()
Date:   Fri, 26 Apr 2019 02:33:43 +0200
Message-Id: <20190426003348.30745-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190426003348.30745-1-pablo@netfilter.org>
References: <20190426003348.30745-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Most drivers do the same thing to set up the block, add a helper
function to do this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 26 ++++------------
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c      | 28 ++++-------------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    | 26 ++++------------
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 26 ++++------------
 drivers/net/ethernet/intel/iavf/iavf_main.c        | 35 ++++------------------
 drivers/net/ethernet/intel/igb/igb_main.c          | 23 ++------------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      | 27 ++++-------------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 27 ++++-------------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 26 ++++------------
 drivers/net/ethernet/netronome/nfp/abm/cls.c       | 17 ++---------
 drivers/net/ethernet/netronome/nfp/bpf/main.c      | 29 ++++--------------
 .../net/ethernet/netronome/nfp/flower/offload.c    | 29 ++++--------------
 drivers/net/ethernet/qlogic/qede/qede_main.c       | 23 ++------------
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 22 ++------------
 drivers/net/netdevsim/netdev.c                     | 26 ++++------------
 include/net/pkt_cls.h                              |  3 ++
 net/sched/cls_api.c                                | 20 +++++++++++++
 17 files changed, 89 insertions(+), 324 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6528a597367b..0c2da8b87e7e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9726,32 +9726,16 @@ static int bnxt_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int bnxt_setup_tc_block(struct net_device *dev,
-			       struct tc_block_offload *f)
-{
-	struct bnxt *bp = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, bnxt_setup_tc_block_cb,
-					     bp, bp, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, bnxt_setup_tc_block_cb, bp);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int bnxt_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			 void *type_data)
 {
+	struct bnxt *bp = netdev_priv(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return bnxt_setup_tc_block(dev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       bnxt_setup_tc_block_cb, bp,
+					       true);
 	case TC_SETUP_QDISC_MQPRIO: {
 		struct tc_mqprio_qopt *mqprio = type_data;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index f760921389a3..172fabc62140 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -161,34 +161,16 @@ static int bnxt_vf_rep_setup_tc_block_cb(enum tc_setup_type type,
 	}
 }
 
-static int bnxt_vf_rep_setup_tc_block(struct net_device *dev,
-				      struct tc_block_offload *f)
-{
-	struct bnxt_vf_rep *vf_rep = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block,
-					     bnxt_vf_rep_setup_tc_block_cb,
-					     vf_rep, vf_rep, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block,
-					bnxt_vf_rep_setup_tc_block_cb, vf_rep);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int bnxt_vf_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 				void *type_data)
 {
+	struct bnxt_vf_rep *vf_rep = netdev_priv(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return bnxt_vf_rep_setup_tc_block(dev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       bnxt_vf_rep_setup_tc_block_cb,
+					       vf_rep, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 3339f1f4bcdd..293c4cbdfc0a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3098,32 +3098,16 @@ static int cxgb_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int cxgb_setup_tc_block(struct net_device *dev,
-			       struct tc_block_offload *f)
-{
-	struct port_info *pi = netdev2pinfo(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, cxgb_setup_tc_block_cb,
-					     pi, dev, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, cxgb_setup_tc_block_cb, pi);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int cxgb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			 void *type_data)
 {
+	struct port_info *pi = netdev2pinfo(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return cxgb_setup_tc_block(dev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       cxgb_setup_tc_block_cb, pi,
+					       true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b1c265012c8a..4449df0b883b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7607,34 +7607,18 @@ static int i40e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int i40e_setup_tc_block(struct net_device *dev,
-			       struct tc_block_offload *f)
-{
-	struct i40e_netdev_priv *np = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, i40e_setup_tc_block_cb,
-					     np, np, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, i40e_setup_tc_block_cb, np);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int __i40e_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 			   void *type_data)
 {
+	struct i40e_netdev_priv *np = netdev_priv(netdev);
+
 	switch (type) {
 	case TC_SETUP_QDISC_MQPRIO:
 		return i40e_setup_tc(netdev, type_data);
 	case TC_SETUP_BLOCK:
-		return i40e_setup_tc_block(netdev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       i40e_setup_tc_block_cb, np,
+					       true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 4569d69a2b55..872f3470f54c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2847,35 +2847,6 @@ static int iavf_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 }
 
 /**
- * iavf_setup_tc_block - register callbacks for tc
- * @netdev: network interface device structure
- * @f: tc offload data
- *
- * This function registers block callbacks for tc
- * offloads
- **/
-static int iavf_setup_tc_block(struct net_device *dev,
-			       struct tc_block_offload *f)
-{
-	struct iavf_adapter *adapter = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, iavf_setup_tc_block_cb,
-					     adapter, adapter, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, iavf_setup_tc_block_cb,
-					adapter);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-/**
  * iavf_setup_tc - configure multiple traffic classes
  * @netdev: network interface device structure
  * @type: type of offload
@@ -2889,11 +2860,15 @@ static int iavf_setup_tc_block(struct net_device *dev,
 static int iavf_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 			 void *type_data)
 {
+	struct iavf_adapter *adapter = netdev_priv(netdev);
+
 	switch (type) {
 	case TC_SETUP_QDISC_MQPRIO:
 		return __iavf_setup_tc(netdev, type_data);
 	case TC_SETUP_BLOCK:
-		return iavf_setup_tc_block(netdev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       iavf_setup_tc_block_cb, adapter,
+					       true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index acbb5b4f333d..1d63287bbc64 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2782,25 +2782,6 @@ static int igb_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int igb_setup_tc_block(struct igb_adapter *adapter,
-			      struct tc_block_offload *f)
-{
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, igb_setup_tc_block_cb,
-					     adapter, adapter, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, igb_setup_tc_block_cb,
-					adapter);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int igb_offload_txtime(struct igb_adapter *adapter,
 			      struct tc_etf_qopt_offload *qopt)
 {
@@ -2833,7 +2814,9 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	case TC_SETUP_QDISC_CBS:
 		return igb_offload_cbs(adapter, type_data);
 	case TC_SETUP_BLOCK:
-		return igb_setup_tc_block(adapter, type_data);
+		return tcf_setup_block_offload(type_data, igb_setup_tc_block_cb,
+					       adapter, true);
+
 	case TC_SETUP_QDISC_ETF:
 		return igb_offload_txtime(adapter, type_data);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 60cec3540dd7..125139c3796f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9608,27 +9608,6 @@ static int ixgbe_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int ixgbe_setup_tc_block(struct net_device *dev,
-				struct tc_block_offload *f)
-{
-	struct ixgbe_adapter *adapter = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, ixgbe_setup_tc_block_cb,
-					     adapter, adapter, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, ixgbe_setup_tc_block_cb,
-					adapter);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int ixgbe_setup_tc_mqprio(struct net_device *dev,
 				 struct tc_mqprio_qopt *mqprio)
 {
@@ -9639,9 +9618,13 @@ static int ixgbe_setup_tc_mqprio(struct net_device *dev,
 static int __ixgbe_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			    void *type_data)
 {
+	struct ixgbe_adapter *adapter = netdev_priv(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return ixgbe_setup_tc_block(dev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       ixgbe_setup_tc_block_cb,
+					       adapter, true);
 	case TC_SETUP_QDISC_MQPRIO:
 		return ixgbe_setup_tc_mqprio(dev, type_data);
 	default:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ba705392b46b..3bcfe895e613 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3416,36 +3416,19 @@ static int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 		return -EOPNOTSUPP;
 	}
 }
-
-static int mlx5e_setup_tc_block(struct net_device *dev,
-				struct tc_block_offload *f)
-{
-	struct mlx5e_priv *priv = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, mlx5e_setup_tc_block_cb,
-					     priv, priv, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, mlx5e_setup_tc_block_cb,
-					priv);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
 #endif
 
 static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			  void *type_data)
 {
+	struct mlx5e_priv *priv = netdev_priv(dev);
+
 	switch (type) {
 #ifdef CONFIG_MLX5_ESWITCH
 	case TC_SETUP_BLOCK:
-		return mlx5e_setup_tc_block(dev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       mlx5e_setup_tc_block_cb, priv,
+					       true);
 #endif
 	case TC_SETUP_QDISC_MQPRIO:
 		return mlx5e_setup_tc_mqprio(dev, type_data);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 6bfdefa8b9f4..ee63a902c261 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1181,32 +1181,16 @@ static int mlx5e_rep_setup_tc_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int mlx5e_rep_setup_tc_block(struct net_device *dev,
-				    struct tc_block_offload *f)
-{
-	struct mlx5e_priv *priv = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, mlx5e_rep_setup_tc_cb,
-					     priv, priv, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, mlx5e_rep_setup_tc_cb, priv);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			      void *type_data)
 {
+	struct mlx5e_priv *priv = netdev_priv(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return mlx5e_rep_setup_tc_block(dev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       mlx5e_rep_setup_tc_cb,
+					       priv, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
index 9852080cf454..e177cc64ef29 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
@@ -265,19 +265,6 @@ static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,
 int nfp_abm_setup_cls_block(struct net_device *netdev, struct nfp_repr *repr,
 			    struct tc_block_offload *f)
 {
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block,
-					     nfp_abm_setup_tc_block_cb,
-					     repr, repr, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, nfp_abm_setup_tc_block_cb,
-					repr);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
+	return tcf_setup_block_offload(f, nfp_abm_setup_tc_block_cb, repr,
+				       true);
 }
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
index 9c136da25221..5a3b9fde8e01 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
@@ -160,35 +160,16 @@ static int nfp_bpf_setup_tc_block_cb(enum tc_setup_type type,
 	return 0;
 }
 
-static int nfp_bpf_setup_tc_block(struct net_device *netdev,
-				  struct tc_block_offload *f)
-{
-	struct nfp_net *nn = netdev_priv(netdev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block,
-					     nfp_bpf_setup_tc_block_cb,
-					     nn, nn, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block,
-					nfp_bpf_setup_tc_block_cb,
-					nn);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int nfp_bpf_setup_tc(struct nfp_app *app, struct net_device *netdev,
 			    enum tc_setup_type type, void *type_data)
 {
+	struct nfp_net *nn = netdev_priv(netdev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return nfp_bpf_setup_tc_block(netdev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       nfp_bpf_setup_tc_block_cb,
+					       nn, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index aefe211da82c..ba41252b1c14 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1190,35 +1190,16 @@ static int nfp_flower_setup_tc_block_cb(enum tc_setup_type type,
 	}
 }
 
-static int nfp_flower_setup_tc_block(struct net_device *netdev,
-				     struct tc_block_offload *f)
-{
-	struct nfp_repr *repr = netdev_priv(netdev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block,
-					     nfp_flower_setup_tc_block_cb,
-					     repr, repr, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block,
-					nfp_flower_setup_tc_block_cb,
-					repr);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 int nfp_flower_setup_tc(struct nfp_app *app, struct net_device *netdev,
 			enum tc_setup_type type, void *type_data)
 {
+	struct nfp_repr *repr = netdev_priv(netdev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return nfp_flower_setup_tc_block(netdev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       nfp_flower_setup_tc_block_cb,
+					       repr, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 02a97c659e29..39efe7309f0a 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -578,25 +578,6 @@ static int qede_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int qede_setup_tc_block(struct qede_dev *edev,
-			       struct tc_block_offload *f)
-{
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block,
-					     qede_setup_tc_block_cb,
-					     edev, edev, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, qede_setup_tc_block_cb, edev);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int
 qede_setup_tc_offload(struct net_device *dev, enum tc_setup_type type,
 		      void *type_data)
@@ -606,7 +587,9 @@ qede_setup_tc_offload(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return qede_setup_tc_block(edev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       qede_setup_tc_block_cb, edev,
+					       true);
 	case TC_SETUP_QDISC_MQPRIO:
 		mqprio = type_data;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a26e36dbb5df..fd7f37942331 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3844,24 +3844,6 @@ static int stmmac_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	return ret;
 }
 
-static int stmmac_setup_tc_block(struct stmmac_priv *priv,
-				 struct tc_block_offload *f)
-{
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, stmmac_setup_tc_block_cb,
-				priv, priv, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, stmmac_setup_tc_block_cb, priv);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 			   void *type_data)
 {
@@ -3869,7 +3851,9 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return stmmac_setup_tc_block(priv, type_data);
+		return tcf_setup_block_offload(type_data,
+					       stmmac_setup_tc_block_cb,
+					       priv, true);
 	case TC_SETUP_QDISC_CBS:
 		return stmmac_tc_setup_cbs(priv, priv, type_data);
 	default:
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 7805fa840383..a3c45433b886 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -272,26 +272,6 @@ nsim_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
 	return nsim_bpf_setup_tc_block_cb(type, type_data, cb_priv);
 }
 
-static int
-nsim_setup_tc_block(struct net_device *dev, struct tc_block_offload *f)
-{
-	struct netdevsim *ns = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, nsim_setup_tc_block_cb,
-					     ns, ns, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, nsim_setup_tc_block_cb, ns);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int nsim_set_vf_mac(struct net_device *dev, int vf, u8 *mac)
 {
 	struct netdevsim *ns = netdev_priv(dev);
@@ -412,9 +392,13 @@ static int nsim_set_vf_link_state(struct net_device *dev, int vf, int state)
 static int
 nsim_setup_tc(struct net_device *dev, enum tc_setup_type type, void *type_data)
 {
+	struct netdevsim *ns = netdev_priv(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return nsim_setup_tc_block(dev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       nsim_setup_tc_block_cb, ns,
+					       true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 52a6484428ce..7a50f7bb6880 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -652,6 +652,9 @@ struct tc_block_offload {
 	struct netlink_ext_ack *extack;
 };
 
+int tcf_setup_block_offload(struct tc_block_offload *f, tc_setup_cb_t *cb,
+			    void *cb_priv, bool ingress_only);
+
 struct tc_cls_common_offload {
 	u32 chain_index;
 	__be16 protocol;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 963511ec758d..a00463c8cfa9 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -926,6 +926,26 @@ static int tcf_block_setup(struct tcf_block *block, struct tc_block_offload *bo)
 	return err;
 }
 
+int tcf_setup_block_offload(struct tc_block_offload *f, tc_setup_cb_t *cb,
+			    void *cb_priv, bool ingress_only)
+{
+	if (ingress_only &&
+	    f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		return -EOPNOTSUPP;
+
+	switch (f->command) {
+	case TC_BLOCK_BIND:
+		return tcf_block_cb_register(f->block, cb, cb_priv, cb_priv,
+					     f->extack);
+	case TC_BLOCK_UNBIND:
+		tcf_block_cb_unregister(f->block, cb, cb_priv);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL(tcf_setup_block_offload);
+
 static struct rhashtable indr_setup_block_ht;
 
 struct tc_indr_block_dev {
-- 
2.11.0

