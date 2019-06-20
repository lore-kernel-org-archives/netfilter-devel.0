Return-Path: <SRS0=UCdS=UT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B9FC43613
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 19:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81632206BF
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 19:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfFTTty (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jun 2019 15:49:54 -0400
Received: from mail.us.es ([193.147.175.20]:54568 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726965AbfFTTtx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 15:49:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B071BFF2CC
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2019 21:49:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 98C79DA78D
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2019 21:49:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 77446DA710; Thu, 20 Jun 2019 21:49:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF68BDA712;
        Thu, 20 Jun 2019 21:49:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Jun 2019 21:49:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7FAFE4265A2F;
        Thu, 20 Jun 2019 21:49:44 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
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
        cphealy@gmail.com
Subject: [PATCH net-next 11/12] net: flow_offload: don't allow block sharing until drivers support this
Date:   Thu, 20 Jun 2019 21:49:16 +0200
Message-Id: <20190620194917.2298-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190620194917.2298-1-pablo@netfilter.org>
References: <20190620194917.2298-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c    |  4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c      |  8 ++++----
 drivers/net/ethernet/mscc/ocelot_flower.c           |  4 ++--
 drivers/net/ethernet/mscc/ocelot_tc.c               |  4 ++--
 drivers/net/ethernet/netronome/nfp/flower/offload.c |  8 ++++----
 net/core/flow_offload.c                             | 12 +++++++++---
 net/dsa/slave.c                                     |  4 ++--
 7 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 1e36f16cba00..b9a10a2a5ff5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -741,10 +741,10 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 					       mlx5e_rep_indr_setup_block_cb,
 					       indr_priv, indr_priv,
 					       mlx5e_rep_indr_tc_block_unbind);
-		if (!block_cb) {
+		if (IS_ERR(block_cb)) {
 			list_del(&indr_priv->list);
 			kfree(indr_priv);
-			return -ENOMEM;
+			return PTR_ERR(block_cb);
 		}
 		flow_block_cb_add(block_cb, f);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 0340717aab93..197c123acadf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1582,9 +1582,9 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 					       mlxsw_sp_setup_tc_block_cb_flower,
 					       mlxsw_sp, acl_block,
 					       mlxsw_sp_tc_block_flower_release);
-		if (!block_cb) {
+		if (IS_ERR(block_cb)) {
 			mlxsw_sp_acl_block_destroy(acl_block);
-			err = -ENOMEM;
+			err = PTR_ERR(block_cb);
 			goto err_cb_register;
 		}
 		register_block = true;
@@ -1664,8 +1664,8 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 	case TC_BLOCK_BIND:
 		block_cb = flow_block_cb_alloc(f->net, cb, mlxsw_sp_port,
 					       mlxsw_sp_port, NULL);
-		if (!block_cb)
-			return -ENOMEM;
+		if (IS_ERR(block_cb))
+			return PTR_ERR(block_cb);
 		err = mlxsw_sp_setup_tc_block_flower_bind(mlxsw_sp_port, f,
 							  ingress);
 		if (err) {
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index fa5a3bf22ede..3b9e4219ac7a 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -327,8 +327,8 @@ int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
 					       ocelot_setup_tc_block_cb_flower,
 					       port, port_block,
 					       ocelot_tc_block_unbind);
-		if (!block_cb) {
-			ret = -ENOMEM;
+		if (IS_ERR(block_cb)) {
+			ret = PTR_ERR(block_cb);
 			goto err_cb_register;
 		}
 		flow_block_cb_add(block_cb, f);
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index 2c6eccab6547..14a9e178c3b8 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -150,8 +150,8 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 	switch (f->command) {
 	case TC_BLOCK_BIND:
 		block_cb = flow_block_cb_alloc(f->net, cb, port, port, NULL);
-		if (!block_cb)
-			return -ENOMEM;
+		if (IS_ERR(block_cb))
+			return PTR_ERR(block_cb);
 
 		err = ocelot_setup_tc_block_flower_bind(port, f);
 		if (err < 0) {
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 89ea95a0d554..0f4442006075 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1277,8 +1277,8 @@ static int nfp_flower_setup_tc_block(struct net_device *netdev,
 		block_cb = flow_block_cb_alloc(f->net,
 					       nfp_flower_setup_tc_block_cb,
 					       repr, repr, NULL);
-		if (!block_cb)
-			return -ENOMEM;
+		if (IS_ERR(block_cb))
+			return PTR_ERR(block_cb);
 
 		flow_block_cb_add(block_cb, f);
 		return 0;
@@ -1384,10 +1384,10 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 					       nfp_flower_setup_indr_block_cb,
 					       cb_priv, cb_priv,
 					       nfp_flower_setup_indr_tc_release);
-		if (!block_cb) {
+		if (IS_ERR(block_cb)) {
 			list_del(&cb_priv->list);
 			kfree(cb_priv);
-			return -ENOMEM;
+			return PTR_ERR(block_cb);
 		}
 
 		flow_block_cb_add(block_cb, f);
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 1a585676ca79..6615a2196085 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -206,9 +206,15 @@ struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
 {
 	struct flow_block_cb *block_cb;
 
+	list_for_each_entry(block_cb, &flow_block_cb_list, global_list) {
+		if (block_cb->cb == cb &&
+		    block_cb->cb_ident == cb_ident)
+			return ERR_PTR(-EBUSY);
+	}
+
 	block_cb = kzalloc(sizeof(*block_cb), GFP_KERNEL);
 	if (!block_cb)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	block_cb->net = net;
 	block_cb->cb = cb;
@@ -262,8 +268,8 @@ int flow_block_setup_offload(struct flow_block_offload *f, tc_setup_cb_t *cb,
 	case TC_BLOCK_BIND:
 		block_cb = flow_block_cb_alloc(f->net, cb, cb_ident, cb_priv,
 					       NULL);
-		if (!block_cb)
-			return -ENOMEM;
+		if (IS_ERR(block_cb))
+			return PTR_ERR(block_cb);
 
 		flow_block_cb_add(block_cb, f);
 		return 0;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a7e80d4e10ef..0323091b5cef 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -958,8 +958,8 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 	switch (f->command) {
 	case TC_BLOCK_BIND:
 		block_cb = flow_block_cb_alloc(f->net, cb, dev, dev, NULL);
-		if (!block_cb)
-			return -ENOMEM;
+		if (IS_ERR(block_cb))
+			return PTR_ERR(block_cb);
 
 		flow_block_cb_add(block_cb, f);
 		return 0;
-- 
2.11.0

