Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF203C43218
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 00:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A55FC206C1
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 00:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbfDZAeJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 20:34:09 -0400
Received: from mail.us.es ([193.147.175.20]:55228 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730039AbfDZAeI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 20:34:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EE180B497A
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 02:34:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD442DA709
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 02:34:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D2E0BDA703; Fri, 26 Apr 2019 02:34:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B31DDDA705;
        Fri, 26 Apr 2019 02:34:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 02:34:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6254B4265A31;
        Fri, 26 Apr 2019 02:34:03 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@mellanox.com,
        john.hurley@netronome.com, jakub.kicinski@netronome.com,
        ogerlitz@mellanox.com
Subject: [PATCH net-next,RFC 9/9] net: cls_api: do not expose tcf_block to drivers
Date:   Fri, 26 Apr 2019 02:33:47 +0200
Message-Id: <20190426003348.30745-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190426003348.30745-1-pablo@netfilter.org>
References: <20190426003348.30745-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead, expose the block index that is sufficient to look up for the
tcf_block_cb object.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c    |  4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c      | 10 +++++-----
 drivers/net/ethernet/netronome/nfp/flower/offload.c |  4 ++--
 include/net/pkt_cls.h                               |  2 +-
 net/dsa/slave.c                                     |  4 ++--
 net/sched/cls_api.c                                 | 10 +++++-----
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index f09135b7a605..f85f725fc0dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -731,7 +731,7 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		list_add(&indr_priv->list,
 			 &rpriv->uplink_priv.tc_indr_block_priv_list);
 
-		block_cb = tcf_block_cb_alloc(f->block->index,
+		block_cb = tcf_block_cb_alloc(f->block_index,
 					      mlx5e_rep_indr_setup_block_cb,
 					      indr_priv, indr_priv,
 					      mlx5e_rep_indr_tc_block_unbind);
@@ -747,7 +747,7 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		if (!indr_priv)
 			return -ENOENT;
 
-		block_cb = tcf_block_cb_lookup(f->block->index,
+		block_cb = tcf_block_cb_lookup(f->block_index,
 					       mlx5e_rep_indr_setup_block_cb,
 					       indr_priv);
 		if (!block_cb)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index c07fa0487b39..060a0de69638 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1531,14 +1531,14 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct tcf_block_cb *block_cb;
 	int err;
 
-	block_cb = tcf_block_cb_lookup(f->block->index,
+	block_cb = tcf_block_cb_lookup(f->block_index,
 				       mlxsw_sp_setup_tc_block_cb_flower,
 				       mlxsw_sp);
 	if (!block_cb) {
 		acl_block = mlxsw_sp_acl_block_create(mlxsw_sp, net);
 		if (!acl_block)
 			return -ENOMEM;
-		block_cb = tcf_block_cb_alloc(f->block->index,
+		block_cb = tcf_block_cb_alloc(f->block_index,
 					      mlxsw_sp_setup_tc_block_cb_flower,
 					      mlxsw_sp, acl_block,
 					      mlxsw_sp_tc_block_flower_release);
@@ -1580,7 +1580,7 @@ mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct tcf_block_cb *block_cb;
 	int err;
 
-	block_cb = tcf_block_cb_lookup(f->block->index,
+	block_cb = tcf_block_cb_lookup(f->block_index,
 				       mlxsw_sp_setup_tc_block_cb_flower,
 				       mlxsw_sp);
 	if (!block_cb)
@@ -1618,7 +1618,7 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		block_cb = tcf_block_cb_alloc(f->block->index, cb, mlxsw_sp_port,
+		block_cb = tcf_block_cb_alloc(f->block_index, cb, mlxsw_sp_port,
 					 mlxsw_sp_port, NULL);
 		if (!block_cb)
 			return -ENOMEM;
@@ -1633,7 +1633,7 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 	case TC_BLOCK_UNBIND:
 		mlxsw_sp_setup_tc_block_flower_unbind(mlxsw_sp_port,
 						      f, ingress);
-		block_cb = tcf_block_cb_lookup(f->block->index, cb,
+		block_cb = tcf_block_cb_lookup(f->block_index, cb,
 					       mlxsw_sp_port);
 		if (!block_cb)
 			return -ENOENT;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index d2bc36859952..1ad46cf2413f 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1277,7 +1277,7 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 		cb_priv->app = app;
 		list_add(&cb_priv->list, &priv->indr_block_cb_priv);
 
-		block_cb = tcf_block_cb_alloc(f->block->index,
+		block_cb = tcf_block_cb_alloc(f->block_index,
 					      nfp_flower_setup_indr_block_cb,
 					      cb_priv, cb_priv,
 					      nfp_flower_setup_indr_tc_release);
@@ -1293,7 +1293,7 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 		if (!cb_priv)
 			return -ENOENT;
 
-		block_cb = tcf_block_cb_lookup(f->block->index,
+		block_cb = tcf_block_cb_lookup(f->block_index,
 					       nfp_flower_setup_indr_block_cb,
 					       cb_priv);
 		if (!block_cb)
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index b61d0c89ba5b..f0540507a397 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -638,7 +638,7 @@ struct tc_block_offload {
 	enum tc_block_command command;
 	enum tcf_block_binder_type binder_type;
 	struct list_head cb_list;
-	struct tcf_block *block;
+	u32 block_index;
 	struct netlink_ext_ack *extack;
 };
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 7ef34cc2f574..4fe5386f2613 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -914,7 +914,7 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		block_cb = tcf_block_cb_alloc(f->block->index, cb, dev, dev,
+		block_cb = tcf_block_cb_alloc(f->block_index, cb, dev, dev,
 					      NULL);
 		if (!block_cb)
 			return -ENOMEM;
@@ -922,7 +922,7 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 		tcf_block_cb_list_add(block_cb, &f->cb_list);
 		return 0;
 	case TC_BLOCK_UNBIND:
-		block_cb = tcf_block_cb_lookup(f->block->index, cb, dev);
+		block_cb = tcf_block_cb_lookup(f->block_index, cb, dev);
 		if (!block_cb)
 			return -ENOENT;
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index bd8b08f158c0..2b23e07e9a75 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -882,7 +882,7 @@ int tcf_setup_block_offload(struct tc_block_offload *f, tc_setup_cb_t *cb,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		block_cb = tcf_block_cb_alloc(f->block->index, cb, cb_priv,
+		block_cb = tcf_block_cb_alloc(f->block_index, cb, cb_priv,
 					      cb_priv, NULL);
 		if (!block_cb)
 			return -ENOMEM;
@@ -890,7 +890,7 @@ int tcf_setup_block_offload(struct tc_block_offload *f, tc_setup_cb_t *cb,
 		tcf_block_cb_list_add(block_cb, &f->cb_list);
 		return 0;
 	case TC_BLOCK_UNBIND:
-		block_cb = tcf_block_cb_lookup(f->block->index, cb, cb_priv);
+		block_cb = tcf_block_cb_lookup(f->block_index, cb, cb_priv);
 		if (!block_cb)
 			return -ENOENT;
 
@@ -1016,7 +1016,7 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 	struct tc_block_offload bo = {
 		.command	= command,
 		.binder_type	= TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
-		.block		= indr_dev->block,
+		.block_index	= indr_dev->block->index,
 	};
 	INIT_LIST_HEAD(&bo.cb_list);
 
@@ -1106,7 +1106,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 	struct tc_block_offload bo = {
 		.command	= command,
 		.binder_type	= ei->binder_type,
-		.block		= block,
+		.block_index	= block->index,
 		.extack		= extack,
 	};
 	INIT_LIST_HEAD(&bo.cb_list);
@@ -1135,7 +1135,7 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 
 	bo.command = command;
 	bo.binder_type = ei->binder_type;
-	bo.block = block;
+	bo.block_index = block->index;
 	bo.extack = extack;
 	INIT_LIST_HEAD(&bo.cb_list);
 
-- 
2.11.0

