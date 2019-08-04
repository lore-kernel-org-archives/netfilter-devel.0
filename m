Return-Path: <SRS0=e+Zs=WA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B40C32753
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Aug 2019 13:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 415B320844
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Aug 2019 13:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfHDNYM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 4 Aug 2019 09:24:12 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:8243 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbfHDNYM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Aug 2019 09:24:12 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 38734412A2;
        Sun,  4 Aug 2019 21:24:02 +0800 (CST)
From:   wenxu@ucloud.cn
To:     jakub.kicinski@netronome.com, jiri@resnulli.us
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v6 2/6] cls_api: remove the tcf_block cache
Date:   Sun,  4 Aug 2019 21:23:57 +0800
Message-Id: <1564925041-23530-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564925041-23530-1-git-send-email-wenxu@ucloud.cn>
References: <1564925041-23530-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0xMQkJCQk9CT05OSU1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OiI6MCo6DDg5UU4UPiIRKxgp
        PRpPFDFVSlVKTk1PQklOS09JSUNCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhOQ0I3Bg++
X-HM-Tid: 0a6c5ccd1e4b2086kuqy38734412a2
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Remove the tcf_block in the tc_indr_block_dev for muti-subsystem
support.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v6: new patch

 net/sched/cls_api.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2e3b58d..654da8c 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -574,7 +574,6 @@ struct tc_indr_block_dev {
 	struct net_device *dev;
 	unsigned int refcnt;
 	struct list_head cb_list;
-	struct tcf_block *block;
 };
 
 struct tc_indr_block_cb {
@@ -611,7 +610,6 @@ static struct tc_indr_block_dev *tc_indr_block_dev_get(struct net_device *dev)
 
 	INIT_LIST_HEAD(&indr_dev->cb_list);
 	indr_dev->dev = dev;
-	indr_dev->block = tc_dev_ingress_block(dev);
 	if (rhashtable_insert_fast(&indr_setup_block_ht, &indr_dev->ht_node,
 				   tc_indr_setup_block_ht_params)) {
 		kfree(indr_dev);
@@ -706,6 +704,7 @@ int __tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 {
 	struct tc_indr_block_cb *indr_block_cb;
 	struct tc_indr_block_dev *indr_dev;
+	struct tcf_block *block;
 	int err;
 
 	indr_dev = tc_indr_block_dev_get(dev);
@@ -717,8 +716,9 @@ int __tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 	if (err)
 		goto err_dev_put;
 
-	tc_indr_block_ing_cmd(dev, indr_dev->block, cb, cb_priv,
-			      FLOW_BLOCK_BIND);
+	block = tc_dev_ingress_block(dev);
+	tc_indr_block_ing_cmd(dev, block, indr_block_cb->cb,
+			      indr_block_cb->cb_priv, FLOW_BLOCK_BIND);
 	return 0;
 
 err_dev_put:
@@ -745,6 +745,7 @@ void __tc_indr_block_cb_unregister(struct net_device *dev,
 {
 	struct tc_indr_block_cb *indr_block_cb;
 	struct tc_indr_block_dev *indr_dev;
+	struct tcf_block *block;
 
 	indr_dev = tc_indr_block_dev_lookup(dev);
 	if (!indr_dev)
@@ -755,8 +756,9 @@ void __tc_indr_block_cb_unregister(struct net_device *dev,
 		return;
 
 	/* Send unbind message if required to free any block cbs. */
-	tc_indr_block_ing_cmd(dev, indr_dev->block, cb, indr_block_cb->cb_priv,
-			      FLOW_BLOCK_UNBIND);
+	block = tc_dev_ingress_block(dev);
+	tc_indr_block_ing_cmd(dev, block, indr_block_cb->cb,
+			      indr_block_cb->cb_priv, FLOW_BLOCK_UNBIND);
 	tc_indr_block_cb_del(indr_block_cb);
 	tc_indr_block_dev_put(indr_dev);
 }
@@ -792,8 +794,6 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 	if (!indr_dev)
 		return;
 
-	indr_dev->block = command == FLOW_BLOCK_BIND ? block : NULL;
-
 	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
 		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
 				  &bo);
-- 
1.8.3.1

