Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB1AC432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 09:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9DD12067D
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 09:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfKUJyV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 04:54:21 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:49240 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfKUJyV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 04:54:21 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 7607541CBA;
        Thu, 21 Nov 2019 17:54:17 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v2 1/4] netfilter: nf_flow_table_offload: refactor nf_flow_table_offload_setup to support indir setup
Date:   Thu, 21 Nov 2019 17:54:13 +0800
Message-Id: <1574330056-5377-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574330056-5377-1-git-send-email-wenxu@ucloud.cn>
References: <1574330056-5377-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSk9KS0tLS0hJT0lPQkhZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NT46LBw6TDg4LQ8#S0hMCTMT
        KCsaFDZVSlVKTkxPSEhLS05MTENCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhOSUM3Bg++
X-HM-Tid: 0a6e8d6243152086kuqy7607541cba
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Refactor nf_flow_table_offload_setup to support indir setup in
the next patch

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2: no change

 net/netfilter/nf_flow_table_offload.c | 54 ++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index c00bb76..2d92043 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -801,26 +801,31 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 	return err;
 }
 
-int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
-				struct net_device *dev,
-				enum flow_block_command cmd)
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
+static int nf_flow_table_offload_cmd(struct nf_flowtable *flowtable,
+				     struct net_device *dev,
+				     enum flow_block_command cmd)
 {
 	struct netlink_ext_ack extack = {};
-	struct flow_block_offload bo = {};
+	struct flow_block_offload bo;
 	int err;
 
-	if (!(flowtable->flags & NF_FLOWTABLE_HW_OFFLOAD))
-		return 0;
-
-	if (!dev->netdev_ops->ndo_setup_tc)
-		return -EOPNOTSUPP;
-
-	bo.net		= dev_net(dev);
-	bo.block	= &flowtable->flow_block;
-	bo.command	= cmd;
-	bo.binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
-	bo.extack	= &extack;
-	INIT_LIST_HEAD(&bo.cb_list);
+	nf_flow_table_block_offload_init(&bo, dev_net(dev), cmd, flowtable,
+					 &extack);
 
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
 	if (err < 0)
@@ -828,6 +833,23 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 
 	return nf_flow_table_block_setup(flowtable, &bo, cmd);
 }
+
+int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
+				struct net_device *dev,
+				enum flow_block_command cmd)
+{
+	int err;
+
+	if (!(flowtable->flags & NF_FLOWTABLE_HW_OFFLOAD))
+		return 0;
+
+	if (dev->netdev_ops->ndo_setup_tc)
+		err = nf_flow_table_offload_cmd(flowtable, dev, cmd);
+	else
+		err = -EOPNOTSUPP;
+
+	return err;
+}
 EXPORT_SYMBOL_GPL(nf_flow_table_offload_setup);
 
 int nf_flow_table_offload_init(void)
-- 
1.8.3.1

