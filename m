Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A001AC33CB1
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 10:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72766207E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 10:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgANKAm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 05:00:42 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:56971 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgANKAm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 05:00:42 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 99A9B40F54;
        Tue, 14 Jan 2020 18:00:40 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v4 1/4] netfilter: flowtable: add nf_flow_table_block_offload_init()
Date:   Tue, 14 Jan 2020 18:00:37 +0800
Message-Id: <1578996040-6413-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1578996040-6413-1-git-send-email-wenxu@ucloud.cn>
References: <1578996040-6413-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJCS0tLS0tLQk5ITUxZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6P006MSo5Fzg#AjI*SzcqGAMa
        PjkaCUNVSlVKTkxDQkJNS09LTUNLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlNSU83Bg++
X-HM-Tid: 0a6fa37f83c12086kuqy99a9b40f54
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add nf_flow_table_block_offload_init prepare for the indr block
offload patch

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_offload.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 865ec5c..e869238 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -837,6 +837,21 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
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
@@ -851,14 +866,8 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
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
1.8.3.1

