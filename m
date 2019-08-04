Return-Path: <SRS0=e+Zs=WA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C3BDC41514
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Aug 2019 13:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62C362075C
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Aug 2019 13:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfHDNYM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 4 Aug 2019 09:24:12 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:8247 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfHDNYM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Aug 2019 09:24:12 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 6330E415EF;
        Sun,  4 Aug 2019 21:24:02 +0800 (CST)
From:   wenxu@ucloud.cn
To:     jakub.kicinski@netronome.com, jiri@resnulli.us
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v6 3/6] cls_api: add flow_indr_block_call function
Date:   Sun,  4 Aug 2019 21:23:58 +0800
Message-Id: <1564925041-23530-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564925041-23530-1-git-send-email-wenxu@ucloud.cn>
References: <1564925041-23530-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0xMQkJCQk9CT05OSU1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MDY6Cyo*Ojg9CE4jPhpMKy41
        PA9PCRlVSlVKTk1PQklOS09JT05CVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlMQ0o3Bg++
X-HM-Tid: 0a6c5ccd1efa2086kuqy6330e415ef
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch make indr_block_call don't access struct tc_indr_block_cb
and tc_indr_block_dev directly

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v6: no change

 net/sched/cls_api.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 654da8c..ebbc1e0 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -773,13 +773,27 @@ void tc_indr_block_cb_unregister(struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(tc_indr_block_cb_unregister);
 
+static void flow_indr_block_call(struct net_device *dev,
+				 struct flow_block_offload *bo,
+				 enum flow_block_command command)
+{
+	struct tc_indr_block_cb *indr_block_cb;
+	struct tc_indr_block_dev *indr_dev;
+
+	indr_dev = tc_indr_block_dev_lookup(dev);
+	if (!indr_dev)
+		return;
+
+	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
+		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
+				  bo);
+}
+
 static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 			       struct tcf_block_ext_info *ei,
 			       enum flow_block_command command,
 			       struct netlink_ext_ack *extack)
 {
-	struct tc_indr_block_cb *indr_block_cb;
-	struct tc_indr_block_dev *indr_dev;
 	struct flow_block_offload bo = {
 		.command	= command,
 		.binder_type	= ei->binder_type,
@@ -790,14 +804,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 	};
 	INIT_LIST_HEAD(&bo.cb_list);
 
-	indr_dev = tc_indr_block_dev_lookup(dev);
-	if (!indr_dev)
-		return;
-
-	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
-		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
-				  &bo);
-
+	flow_indr_block_call(dev, &bo, command);
 	tcf_block_setup(block, &bo);
 }
 
-- 
1.8.3.1

