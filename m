Return-Path: <SRS0=Lm+H=63=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 594F8C433E1
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 16:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6B6520690
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 16:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389696AbgEMQl7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 May 2020 12:41:59 -0400
Received: from correo.us.es ([193.147.175.20]:54020 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389405AbgEMQl6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 May 2020 12:41:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4831527F8B9
        for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2020 18:41:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3A07B1158ED
        for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2020 18:41:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 27E281158F5; Wed, 13 May 2020 18:41:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 09E1B11540C;
        Wed, 13 May 2020 18:41:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 13 May 2020 18:41:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id ABF8642EF4E1;
        Wed, 13 May 2020 18:41:54 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, vladbu@mellanox.com, jiri@resnulli.us,
        kuba@kernel.org, saeedm@mellanox.com, michael.chan@broadcom.com
Subject: [PATCH 7/8 net] bnxt_tc: update indirect block support
Date:   Wed, 13 May 2020 18:41:39 +0200
Message-Id: <20200513164140.7956-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200513164140.7956-1-pablo@netfilter.org>
References: <20200513164140.7956-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Register ndo callback via flow_indr_dev_register() and
flow_indr_dev_unregister().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h    |  1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 51 +++++---------------
 2 files changed, 12 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index f6a3250ef1c5..e7d1c12673bd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1857,7 +1857,6 @@ struct bnxt {
 	u8			dsn[8];
 	struct bnxt_tc_info	*tc_info;
 	struct list_head	tc_indr_block_list;
-	struct notifier_block	tc_netdev_nb;
 	struct dentry		*debugfs_pdev;
 	struct device		*hwmon_dev;
 };
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 782ea0771221..0eef4f5e4a46 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1939,53 +1939,25 @@ static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
 	return 0;
 }
 
-static int bnxt_tc_setup_indr_cb(struct net_device *netdev, void *cb_priv,
-				 enum tc_setup_type type, void *type_data)
-{
-	switch (type) {
-	case TC_SETUP_BLOCK:
-		return bnxt_tc_setup_indr_block(netdev, cb_priv, type_data);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static bool bnxt_is_netdev_indr_offload(struct net_device *netdev)
 {
 	return netif_is_vxlan(netdev);
 }
 
-static int bnxt_tc_indr_block_event(struct notifier_block *nb,
-				    unsigned long event, void *ptr)
+static int bnxt_tc_setup_indr_cb(struct net_device *netdev, void *cb_priv,
+				 enum tc_setup_type type, void *type_data)
 {
-	struct net_device *netdev;
-	struct bnxt *bp;
-	int rc;
-
-	netdev = netdev_notifier_info_to_dev(ptr);
 	if (!bnxt_is_netdev_indr_offload(netdev))
-		return NOTIFY_OK;
-
-	bp = container_of(nb, struct bnxt, tc_netdev_nb);
+		return -EOPNOTSUPP;
 
-	switch (event) {
-	case NETDEV_REGISTER:
-		rc = __flow_indr_block_cb_register(netdev, bp,
-						   bnxt_tc_setup_indr_cb,
-						   bp);
-		if (rc)
-			netdev_info(bp->dev,
-				    "Failed to register indirect blk: dev: %s\n",
-				    netdev->name);
-		break;
-	case NETDEV_UNREGISTER:
-		__flow_indr_block_cb_unregister(netdev,
-						bnxt_tc_setup_indr_cb,
-						bp);
+	switch (type) {
+	case TC_SETUP_BLOCK:
+		return bnxt_tc_setup_indr_block(netdev, cb_priv, type_data);
+	default:
 		break;
 	}
 
-	return NOTIFY_DONE;
+	return -EOPNOTSUPP;
 }
 
 static const struct rhashtable_params bnxt_tc_flow_ht_params = {
@@ -2074,8 +2046,8 @@ int bnxt_init_tc(struct bnxt *bp)
 
 	/* init indirect block notifications */
 	INIT_LIST_HEAD(&bp->tc_indr_block_list);
-	bp->tc_netdev_nb.notifier_call = bnxt_tc_indr_block_event;
-	rc = register_netdevice_notifier(&bp->tc_netdev_nb);
+
+	rc = flow_indr_dev_register(bnxt_tc_setup_indr_cb, bp);
 	if (!rc)
 		return 0;
 
@@ -2101,7 +2073,8 @@ void bnxt_shutdown_tc(struct bnxt *bp)
 	if (!bnxt_tc_flower_enabled(bp))
 		return;
 
-	unregister_netdevice_notifier(&bp->tc_netdev_nb);
+	flow_indr_dev_unregister(bnxt_tc_setup_indr_cb, bp,
+				 bnxt_tc_setup_indr_block_cb);
 	rhashtable_destroy(&tc_info->flow_table);
 	rhashtable_destroy(&tc_info->l2_table);
 	rhashtable_destroy(&tc_info->decap_l2_table);
-- 
2.20.1

