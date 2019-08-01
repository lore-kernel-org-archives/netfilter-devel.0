Return-Path: <SRS0=uSEi=V5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A1DC32751
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 03:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8B20206B8
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 03:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbfHADEA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Jul 2019 23:04:00 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:39633 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728326AbfHADD7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Jul 2019 23:03:59 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 8C15941917;
        Thu,  1 Aug 2019 11:03:48 +0800 (CST)
From:   wenxu@ucloud.cn
To:     jiri@resnulli.us, pablo@netfilter.org, fw@strlen.de,
        jakub.kicinski@netronome.com
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v5 2/6] cls_api: replace block with flow_block in tc_indr_block_dev
Date:   Thu,  1 Aug 2019 11:03:43 +0800
Message-Id: <1564628627-10021-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564628627-10021-1-git-send-email-wenxu@ucloud.cn>
References: <1564628627-10021-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUtOS0tLS09JQkpOSE9ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MzI6Ixw6TTg1GEg1HTdIEB4#
        OilPCzBVSlVKTk1PTUlDTUlCSklIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9MSkM3Bg++
X-HM-Tid: 0a6c4b2236322086kuqy8c15941917
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch make tc_indr_block_dev can separate from tc subsystem

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v5: new patch

 net/sched/cls_api.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2e3b58d..f9643fa 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -574,7 +574,7 @@ struct tc_indr_block_dev {
 	struct net_device *dev;
 	unsigned int refcnt;
 	struct list_head cb_list;
-	struct tcf_block *block;
+	struct flow_block *flow_block;
 };
 
 struct tc_indr_block_cb {
@@ -597,6 +597,14 @@ struct tc_indr_block_cb {
 				      tc_indr_setup_block_ht_params);
 }
 
+static void tc_indr_get_default_block(struct tc_indr_block_dev *indr_dev)
+{
+	struct tcf_block *block = tc_dev_ingress_block(indr_dev->dev);
+
+	if (block)
+		indr_dev->flow_block = &block->flow_block;
+}
+
 static struct tc_indr_block_dev *tc_indr_block_dev_get(struct net_device *dev)
 {
 	struct tc_indr_block_dev *indr_dev;
@@ -611,7 +619,7 @@ static struct tc_indr_block_dev *tc_indr_block_dev_get(struct net_device *dev)
 
 	INIT_LIST_HEAD(&indr_dev->cb_list);
 	indr_dev->dev = dev;
-	indr_dev->block = tc_dev_ingress_block(dev);
+	tc_indr_get_default_block(indr_dev);
 	if (rhashtable_insert_fast(&indr_setup_block_ht, &indr_dev->ht_node,
 				   tc_indr_setup_block_ht_params)) {
 		kfree(indr_dev);
@@ -678,11 +686,14 @@ static int tcf_block_setup(struct tcf_block *block,
 			   struct flow_block_offload *bo);
 
 static void tc_indr_block_ing_cmd(struct net_device *dev,
-				  struct tcf_block *block,
+				  struct flow_block *flow_block,
 				  tc_indr_block_bind_cb_t *cb,
 				  void *cb_priv,
 				  enum flow_block_command command)
 {
+	struct tcf_block *block = flow_block ? container_of(flow_block,
+							    struct tcf_block,
+							    flow_block) : NULL;
 	struct flow_block_offload bo = {
 		.command	= command,
 		.binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
@@ -694,7 +705,7 @@ static void tc_indr_block_ing_cmd(struct net_device *dev,
 	if (!block)
 		return;
 
-	bo.block = &block->flow_block;
+	bo.block = flow_block;
 
 	cb(dev, cb_priv, TC_SETUP_BLOCK, &bo);
 
@@ -717,7 +728,7 @@ int __tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 	if (err)
 		goto err_dev_put;
 
-	tc_indr_block_ing_cmd(dev, indr_dev->block, cb, cb_priv,
+	tc_indr_block_ing_cmd(dev, indr_dev->flow_block, cb, cb_priv,
 			      FLOW_BLOCK_BIND);
 	return 0;
 
@@ -750,13 +761,14 @@ void __tc_indr_block_cb_unregister(struct net_device *dev,
 	if (!indr_dev)
 		return;
 
-	indr_block_cb = tc_indr_block_cb_lookup(indr_dev, cb, cb_ident);
+	indr_block_cb = tc_indr_block_cb_lookup(indr_dev, indr_block_cb->cb,
+						indr_block_cb->cb_ident);
 	if (!indr_block_cb)
 		return;
 
 	/* Send unbind message if required to free any block cbs. */
-	tc_indr_block_ing_cmd(dev, indr_dev->block, cb, indr_block_cb->cb_priv,
-			      FLOW_BLOCK_UNBIND);
+	tc_indr_block_ing_cmd(dev, indr_dev->flow_block, indr_block_cb->cb,
+			      indr_block_cb->cb_priv, FLOW_BLOCK_UNBIND);
 	tc_indr_block_cb_del(indr_block_cb);
 	tc_indr_block_dev_put(indr_dev);
 }
@@ -792,7 +804,8 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 	if (!indr_dev)
 		return;
 
-	indr_dev->block = command == FLOW_BLOCK_BIND ? block : NULL;
+	indr_dev->flow_block = command == FLOW_BLOCK_BIND ?
+					  &block->flow_block : NULL;
 
 	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
 		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
-- 
1.8.3.1

