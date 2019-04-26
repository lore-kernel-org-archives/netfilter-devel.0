Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D02BAC4321B
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 00:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF086206C1
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 00:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730084AbfDZAeJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 20:34:09 -0400
Received: from mail.us.es ([193.147.175.20]:55300 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729993AbfDZAeJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 20:34:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9B00BB4990
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 02:34:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8CA5CDA70C
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 02:34:03 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8BB8BDA707; Fri, 26 Apr 2019 02:34:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0877FDA711;
        Fri, 26 Apr 2019 02:34:01 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 02:34:01 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A7D7B4265A31;
        Fri, 26 Apr 2019 02:34:00 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@mellanox.com,
        john.hurley@netronome.com, jakub.kicinski@netronome.com,
        ogerlitz@mellanox.com
Subject: [PATCH net-next,RFC 7/9] net: use tcf_block_setup() infrastructure
Date:   Fri, 26 Apr 2019 02:33:44 +0200
Message-Id: <20190426003348.30745-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190426003348.30745-1-pablo@netfilter.org>
References: <20190426003348.30745-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows us to register / unregister tcf_block_cb objects from the
core. The idea is to allocate the tcf_block_cb object from the driver,
attach it to the tc_block_offload->cb_list, then the core registers
them.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 33 +++++++----
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     | 64 +++++++++++++---------
 .../net/ethernet/netronome/nfp/flower/offload.c    | 33 +++++++----
 include/net/pkt_cls.h                              |  6 +-
 net/dsa/slave.c                                    | 15 ++++-
 net/sched/cls_api.c                                | 35 ++++++++----
 6 files changed, 124 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index ee63a902c261..f09135b7a605 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -697,13 +697,21 @@ static int mlx5e_rep_indr_setup_block_cb(enum tc_setup_type type,
 	}
 }
 
+static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
+{
+	struct mlx5e_rep_indr_block_priv *indr_priv = cb_priv;
+
+	list_del(&indr_priv->list);
+	kfree(indr_priv);
+}
+
 static int
 mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 			      struct mlx5e_rep_priv *rpriv,
 			      struct tc_block_offload *f)
 {
 	struct mlx5e_rep_indr_block_priv *indr_priv;
-	int err = 0;
+	struct tcf_block_cb *block_cb;
 
 	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
@@ -723,26 +731,29 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		list_add(&indr_priv->list,
 			 &rpriv->uplink_priv.tc_indr_block_priv_list);
 
-		err = tcf_block_cb_register(f->block,
-					    mlx5e_rep_indr_setup_block_cb,
-					    indr_priv, indr_priv, f->extack);
-		if (err) {
+		block_cb = tcf_block_cb_alloc(f->block->index,
+					      mlx5e_rep_indr_setup_block_cb,
+					      indr_priv, indr_priv,
+					      mlx5e_rep_indr_tc_block_unbind);
+		if (!block_cb) {
 			list_del(&indr_priv->list);
 			kfree(indr_priv);
 		}
+		tcf_block_cb_list_add(block_cb, &f->cb_list);
 
-		return err;
+		return 0;
 	case TC_BLOCK_UNBIND:
 		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev);
 		if (!indr_priv)
 			return -ENOENT;
 
-		tcf_block_cb_unregister(f->block,
-					mlx5e_rep_indr_setup_block_cb,
-					indr_priv);
-		list_del(&indr_priv->list);
-		kfree(indr_priv);
+		block_cb = tcf_block_cb_lookup(f->block->index,
+					       mlx5e_rep_indr_setup_block_cb,
+					       indr_priv);
+		if (!block_cb)
+			return -ENOENT;
 
+		tcf_block_cb_list_move(block_cb, &f->cb_list);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index fc325f1213fb..c07fa0487b39 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1514,25 +1514,34 @@ static int mlxsw_sp_setup_tc_block_cb_flower(enum tc_setup_type type,
 	}
 }
 
+static void mlxsw_sp_tc_block_flower_release(void *cb_priv)
+{
+	struct mlxsw_sp_acl_block *acl_block = cb_priv;
+
+	mlxsw_sp_acl_block_destroy(acl_block);
+}
+
 static int
 mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
-				    struct tcf_block *block, bool ingress,
-				    struct netlink_ext_ack *extack)
+			            struct tc_block_offload *f, bool ingress)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct net *net = dev_net(mlxsw_sp_port->dev);
 	struct mlxsw_sp_acl_block *acl_block;
 	struct tcf_block_cb *block_cb;
 	int err;
 
-	block_cb = tcf_block_cb_lookup(block, mlxsw_sp_setup_tc_block_cb_flower,
+	block_cb = tcf_block_cb_lookup(f->block->index,
+				       mlxsw_sp_setup_tc_block_cb_flower,
 				       mlxsw_sp);
 	if (!block_cb) {
-		acl_block = mlxsw_sp_acl_block_create(mlxsw_sp, block->net);
+		acl_block = mlxsw_sp_acl_block_create(mlxsw_sp, net);
 		if (!acl_block)
 			return -ENOMEM;
-		block_cb = __tcf_block_cb_register(block,
-						   mlxsw_sp_setup_tc_block_cb_flower,
-						   mlxsw_sp, acl_block, extack);
+		block_cb = tcf_block_cb_alloc(f->block->index,
+					      mlxsw_sp_setup_tc_block_cb_flower,
+					      mlxsw_sp, acl_block,
+					      mlxsw_sp_tc_block_flower_release);
 		if (IS_ERR(block_cb)) {
 			err = PTR_ERR(block_cb);
 			goto err_cb_register;
@@ -1551,27 +1560,28 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 	else
 		mlxsw_sp_port->eg_acl_block = acl_block;
 
+	tcf_block_cb_list_add(block_cb, &f->cb_list);
 	return 0;
 
 err_block_bind:
 	if (!tcf_block_cb_decref(block_cb)) {
-		__tcf_block_cb_unregister(block, block_cb);
 err_cb_register:
-		mlxsw_sp_acl_block_destroy(acl_block);
+		tcf_block_cb_free(block_cb);
 	}
 	return err;
 }
 
 static void
 mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
-				      struct tcf_block *block, bool ingress)
+				      struct tc_block_offload *f, bool ingress)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_acl_block *acl_block;
 	struct tcf_block_cb *block_cb;
 	int err;
 
-	block_cb = tcf_block_cb_lookup(block, mlxsw_sp_setup_tc_block_cb_flower,
+	block_cb = tcf_block_cb_lookup(f->block->index,
+				       mlxsw_sp_setup_tc_block_cb_flower,
 				       mlxsw_sp);
 	if (!block_cb)
 		return;
@@ -1584,15 +1594,14 @@ mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
 	acl_block = tcf_block_cb_priv(block_cb);
 	err = mlxsw_sp_acl_block_unbind(mlxsw_sp, acl_block,
 					mlxsw_sp_port, ingress);
-	if (!err && !tcf_block_cb_decref(block_cb)) {
-		__tcf_block_cb_unregister(block, block_cb);
-		mlxsw_sp_acl_block_destroy(acl_block);
-	}
+	if (!err && !tcf_block_cb_decref(block_cb))
+		tcf_block_cb_list_move(block_cb, &f->cb_list);
 }
 
 static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 				   struct tc_block_offload *f)
 {
+	struct tcf_block_cb *block_cb;
 	tc_setup_cb_t *cb;
 	bool ingress;
 	int err;
@@ -1609,22 +1618,27 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		err = tcf_block_cb_register(f->block, cb, mlxsw_sp_port,
-					    mlxsw_sp_port, f->extack);
-		if (err)
-			return err;
-		err = mlxsw_sp_setup_tc_block_flower_bind(mlxsw_sp_port,
-							  f->block, ingress,
-							  f->extack);
+		block_cb = tcf_block_cb_alloc(f->block->index, cb, mlxsw_sp_port,
+					 mlxsw_sp_port, NULL);
+		if (!block_cb)
+			return -ENOMEM;
+		err = mlxsw_sp_setup_tc_block_flower_bind(mlxsw_sp_port, f,
+							  ingress);
 		if (err) {
-			tcf_block_cb_unregister(f->block, cb, mlxsw_sp_port);
+			tcf_block_cb_free(block_cb);
 			return err;
 		}
+		tcf_block_cb_list_add(block_cb, &f->cb_list);
 		return 0;
 	case TC_BLOCK_UNBIND:
 		mlxsw_sp_setup_tc_block_flower_unbind(mlxsw_sp_port,
-						      f->block, ingress);
-		tcf_block_cb_unregister(f->block, cb, mlxsw_sp_port);
+						      f, ingress);
+		block_cb = tcf_block_cb_lookup(f->block->index, cb,
+					       mlxsw_sp_port);
+		if (!block_cb)
+			return -ENOENT;
+
+		tcf_block_cb_list_move(block_cb, &f->cb_list);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index ba41252b1c14..d2bc36859952 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1246,13 +1246,21 @@ static int nfp_flower_setup_indr_block_cb(enum tc_setup_type type,
 	}
 }
 
+static void nfp_flower_setup_indr_tc_release(void *cb_priv)
+{
+	struct nfp_flower_indr_block_cb_priv *priv = cb_priv;
+
+	list_del(&priv->list);
+	kfree(priv);
+}
+
 static int
 nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 			       struct tc_block_offload *f)
 {
 	struct nfp_flower_indr_block_cb_priv *cb_priv;
 	struct nfp_flower_priv *priv = app->priv;
-	int err;
+	struct tcf_block_cb *block_cb;
 
 	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
 	    !(f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS &&
@@ -1269,26 +1277,29 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 		cb_priv->app = app;
 		list_add(&cb_priv->list, &priv->indr_block_cb_priv);
 
-		err = tcf_block_cb_register(f->block,
-					    nfp_flower_setup_indr_block_cb,
-					    cb_priv, cb_priv, f->extack);
-		if (err) {
+		block_cb = tcf_block_cb_alloc(f->block->index,
+					      nfp_flower_setup_indr_block_cb,
+					      cb_priv, cb_priv,
+					      nfp_flower_setup_indr_tc_release);
+		if (!block_cb) {
 			list_del(&cb_priv->list);
 			kfree(cb_priv);
 		}
 
-		return err;
+		tcf_block_cb_list_add(block_cb, &f->cb_list);
+		return 0;
 	case TC_BLOCK_UNBIND:
 		cb_priv = nfp_flower_indr_block_cb_priv_lookup(app, netdev);
 		if (!cb_priv)
 			return -ENOENT;
 
-		tcf_block_cb_unregister(f->block,
-					nfp_flower_setup_indr_block_cb,
-					cb_priv);
-		list_del(&cb_priv->list);
-		kfree(cb_priv);
+		block_cb = tcf_block_cb_lookup(f->block->index,
+					       nfp_flower_setup_indr_block_cb,
+					       cb_priv);
+		if (!block_cb)
+			return -ENOENT;
 
+		tcf_block_cb_list_move(block_cb, &f->cb_list);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 7a50f7bb6880..8f0486a00d70 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -71,7 +71,7 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
 	return block->q;
 }
 
-struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
+struct tcf_block_cb *tcf_block_cb_alloc(u32 block_index, tc_setup_cb_t *cb,
 					void *cb_ident, void *cb_priv,
 					void (*release)(void *cb_priv));
 void tcf_block_cb_free(struct tcf_block_cb *block_cb);
@@ -79,8 +79,8 @@ void tcf_block_cb_list_add(struct tcf_block_cb *block_cb, struct list_head *cb_l
 void tcf_block_cb_list_move(struct tcf_block_cb *block_cb, struct list_head *cb_list);
 
 void *tcf_block_cb_priv(struct tcf_block_cb *block_cb);
-struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
-					 tc_setup_cb_t *cb, void *cb_ident);
+struct tcf_block_cb *tcf_block_cb_lookup(u32 block_index, tc_setup_cb_t *cb,
+					 void *cb_ident);
 void tcf_block_cb_incref(struct tcf_block_cb *block_cb);
 unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb);
 struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ce26dddc8270..7ef34cc2f574 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -902,6 +902,7 @@ static int dsa_slave_setup_tc_block_cb_eg(enum tc_setup_type type,
 static int dsa_slave_setup_tc_block(struct net_device *dev,
 				    struct tc_block_offload *f)
 {
+	struct tcf_block_cb *block_cb;
 	tc_setup_cb_t *cb;
 
 	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
@@ -913,9 +914,19 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, cb, dev, dev, f->extack);
+		block_cb = tcf_block_cb_alloc(f->block->index, cb, dev, dev,
+					      NULL);
+		if (!block_cb)
+			return -ENOMEM;
+
+		tcf_block_cb_list_add(block_cb, &f->cb_list);
+		return 0;
 	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, cb, dev);
+		block_cb = tcf_block_cb_lookup(f->block->index, cb, dev);
+		if (!block_cb)
+			return -ENOENT;
+
+		tcf_block_cb_list_move(block_cb, &f->cb_list);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index a00463c8cfa9..f7f6f42d58d1 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -714,6 +714,7 @@ struct tcf_block_cb {
 	void (*release)(void *cb_priv);
 	void *cb_ident;
 	void *cb_priv;
+	u32 block_index;
 	unsigned int refcnt;
 };
 
@@ -730,12 +731,14 @@ EXPORT_SYMBOL(tcf_block_cb_priv);
 
 static LIST_HEAD(tcf_block_cb_list);
 
-struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
-					 tc_setup_cb_t *cb, void *cb_ident)
+struct tcf_block_cb *tcf_block_cb_lookup(u32 block_index, tc_setup_cb_t *cb,
+					 void *cb_ident)
 {	struct tcf_block_cb *block_cb;
 
-	list_for_each_entry(block_cb, &block->cb_list, list)
-		if (block_cb->cb == cb && block_cb->cb_ident == cb_ident)
+	list_for_each_entry(block_cb, &tcf_block_cb_list, list)
+		if (block_cb->block_index == block_index &&
+		    block_cb->cb == cb &&
+		    block_cb->cb_ident == cb_ident)
 			return block_cb;
 	return NULL;
 }
@@ -753,7 +756,7 @@ unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb)
 }
 EXPORT_SYMBOL(tcf_block_cb_decref);
 
-struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
+struct tcf_block_cb *tcf_block_cb_alloc(u32 block_index, tc_setup_cb_t *cb,
 					void *cb_ident, void *cb_priv,
 					void (*release)(void *cb_priv))
 {
@@ -767,6 +770,7 @@ struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
 	block_cb->cb_ident = cb_ident;
 	block_cb->release = release;
 	block_cb->cb_priv = cb_priv;
+	block_cb->block_index = block_index;
 
 	return block_cb;
 }
@@ -810,7 +814,7 @@ struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
 	if (err)
 		return ERR_PTR(err);
 
-	block_cb = tcf_block_cb_alloc(cb, cb_ident, cb_priv, NULL);
+	block_cb = tcf_block_cb_alloc(block->index, cb, cb_ident, cb_priv, NULL);
 	if (!block_cb)
 		return ERR_PTR(-ENOMEM);
 
@@ -847,7 +851,7 @@ void tcf_block_cb_unregister(struct tcf_block *block,
 {
 	struct tcf_block_cb *block_cb;
 
-	block_cb = tcf_block_cb_lookup(block, cb, cb_ident);
+	block_cb = tcf_block_cb_lookup(block->index, cb, cb_ident);
 	if (!block_cb)
 		return;
 	__tcf_block_cb_unregister(block, block_cb);
@@ -929,16 +933,27 @@ static int tcf_block_setup(struct tcf_block *block, struct tc_block_offload *bo)
 int tcf_setup_block_offload(struct tc_block_offload *f, tc_setup_cb_t *cb,
 			    void *cb_priv, bool ingress_only)
 {
+	struct tcf_block_cb *block_cb;
+
 	if (ingress_only &&
 	    f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, cb, cb_priv, cb_priv,
-					     f->extack);
+		block_cb = tcf_block_cb_alloc(f->block->index, cb, cb_priv,
+					      cb_priv, NULL);
+		if (!block_cb)
+			return -ENOMEM;
+
+		tcf_block_cb_list_add(block_cb, &f->cb_list);
+		return 0;
 	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, cb, cb_priv);
+		block_cb = tcf_block_cb_lookup(f->block->index, cb, cb_priv);
+		if (!block_cb)
+			return -ENOENT;
+
+		tcf_block_cb_list_move(block_cb, &f->cb_list);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
-- 
2.11.0

