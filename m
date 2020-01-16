Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A1D3C33CB1
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 14:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 595CF2051A
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 14:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgAPO0C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 09:26:02 -0500
Received: from correo.us.es ([193.147.175.20]:44462 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbgAPO0C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 09:26:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4F6C5303D13
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 15:26:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 404A6DA72A
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 15:26:00 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 34C0ADA723; Thu, 16 Jan 2020 15:26:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 003FFDA720
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 15:25:57 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 15:25:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E173642EF9E2
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 15:25:57 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 9/9] netfilter: flowtable: add nf_flow_table_offload_cmd()
Date:   Thu, 16 Jan 2020 15:25:52 +0100
Message-Id: <20200116142552.25783-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200116142552.25783-1-pablo@netfilter.org>
References: <20200116142552.25783-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Split nf_flow_table_offload_setup() in two functions to make it more
maintainable.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: no changes, just rebased on top of version 3 of 8/9.

 net/netfilter/nf_flow_table_offload.c | 40 ++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 3cd8dc8714e3..c8b70ffeef0c 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -838,12 +838,12 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 	return err;
 }
 
-int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
-				struct net_device *dev,
-				enum flow_block_command cmd)
+static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
+				     struct nf_flowtable *flowtable,
+				     struct net_device *dev,
+				     enum flow_block_command cmd,
+				     struct netlink_ext_ack *extack)
 {
-	struct netlink_ext_ack extack = {};
-	struct flow_block_offload bo = {};
 	int err;
 
 	if (!nf_flowtable_hw_offload(flowtable))
@@ -852,14 +852,30 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 	if (!dev->netdev_ops->ndo_setup_tc)
 		return -EOPNOTSUPP;
 
-	bo.net		= dev_net(dev);
-	bo.block	= &flowtable->flow_block;
-	bo.command	= cmd;
-	bo.binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
-	bo.extack	= &extack;
-	INIT_LIST_HEAD(&bo.cb_list);
+	memset(bo, 0, sizeof(*bo));
+	bo->net		= dev_net(dev);
+	bo->block	= &flowtable->flow_block;
+	bo->command	= cmd;
+	bo->binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
+	bo->extack	= extack;
+	INIT_LIST_HEAD(&bo->cb_list);
+
+	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, bo);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
+				struct net_device *dev,
+				enum flow_block_command cmd)
+{
+	struct netlink_ext_ack extack = {};
+	struct flow_block_offload bo;
+	int err;
 
-	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, &bo);
+	err = nf_flow_table_offload_cmd(&bo, flowtable, dev, cmd, &extack);
 	if (err < 0)
 		return err;
 
-- 
2.11.0

