Return-Path: <SRS0=hXfx=ZH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1837AC43215
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 12:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1E452073B
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 12:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfKOMDh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Nov 2019 07:03:37 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:42921 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbfKOMDh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Nov 2019 07:03:37 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id B005C416C2;
        Fri, 15 Nov 2019 20:03:31 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/4] netfilter: nf_flow_table_offload: refactor nf_flow_table_offload_setup to support indir setup
Date:   Fri, 15 Nov 2019 20:03:27 +0800
Message-Id: <1573819410-3685-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573819410-3685-1-git-send-email-wenxu@ucloud.cn>
References: <1573819410-3685-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSk9LS0tLSktPQktPSkxZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PzI6EQw5MzgySAo0Mw0tGk8v
        DhYKFCpVSlVKTkxIQ0pCT0pJS0hJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhOS043Bg++
X-HM-Tid: 0a6e6ef26d122086kuqyb005c416c2
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Refactor nf_flow_table_offload_setup to support indir setup in
the next patch

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_offload.c | 54 ++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index c54c9a6..6623f07 100644
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

