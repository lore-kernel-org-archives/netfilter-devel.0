Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04FAC5ACD7
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 00:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76A1220663
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 00:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbgCRAlL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Mar 2020 20:41:11 -0400
Received: from correo.us.es ([193.147.175.20]:45646 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727281AbgCRAkR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9495A27F8B7
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 01:39:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8632DDA3A3
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 01:39:46 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7ADB9DA39F; Wed, 18 Mar 2020 01:39:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7E54DA3A0;
        Wed, 18 Mar 2020 01:39:44 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:44 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 926FF426CCB9;
        Wed, 18 Mar 2020 01:39:44 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 11/29] netfilter: flowtable: add nf_flow_table_block_offload_init()
Date:   Wed, 18 Mar 2020 01:39:38 +0100
Message-Id: <20200318003956.73573-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add nf_flow_table_block_offload_init prepare for the indr block
offload patch

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 88695ff44e76..c4cb03555315 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -812,6 +812,21 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 	return err;
 }
 
+static void nf_flow_table_block_offload_init(struct flow_block_offload *bo,
+					     struct net *net,
+					     enum flow_block_command cmd,
+					     struct nf_flowtable *flowtable,
+					     struct netlink_ext_ack *extack)
+{
+	memset(bo, 0, sizeof(*bo));
+	bo->net		= net;
+	bo->block	= &flowtable->flow_block;
+	bo->command	= cmd;
+	bo->binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
+	bo->extack	= extack;
+	INIT_LIST_HEAD(&bo->cb_list);
+}
+
 static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 				     struct nf_flowtable *flowtable,
 				     struct net_device *dev,
@@ -823,14 +838,8 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 	if (!dev->netdev_ops->ndo_setup_tc)
 		return -EOPNOTSUPP;
 
-	memset(bo, 0, sizeof(*bo));
-	bo->net		= dev_net(dev);
-	bo->block	= &flowtable->flow_block;
-	bo->command	= cmd;
-	bo->binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
-	bo->extack	= extack;
-	INIT_LIST_HEAD(&bo->cb_list);
-
+	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
+					 extack);
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, bo);
 	if (err < 0)
 		return err;
-- 
2.11.0

