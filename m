Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F150C43215
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 05:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5A832245B
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 05:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfKTFMZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 00:12:25 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:27787 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfKTFMZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 00:12:25 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id BD8FA41735;
        Wed, 20 Nov 2019 13:12:22 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_flow_table_offload: Fix block_cb tc_setup_type as TC_SETUP_CLSFLOWER
Date:   Wed, 20 Nov 2019 13:12:22 +0800
Message-Id: <1574226742-18328-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVOTU5LS0tLTkxJSUtPTVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OBQ6NBw*GTg0MQgWMTMfVi8S
        DAFPFB5VSlVKTkxPSUlNTE9JQ01KVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlITEw3Bg++
X-HM-Tid: 0a6e8739cdff2086kuqybd8fa41735
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

when add/del/stats flows through block_cb call,
It should set the tc_setup_type as TC_SETUP_CLSFLOWER

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_offload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 6067268..b3ad285 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -574,7 +574,7 @@ static int flow_offload_tuple_add(struct flow_offload_work *offload,
 	cls_flow.rule = flow_rule->rule;
 
 	list_for_each_entry(block_cb, &flowtable->flow_block.cb_list, list) {
-		err = block_cb->cb(TC_SETUP_FT, &cls_flow,
+		err = block_cb->cb(TC_SETUP_CLSFLOWER, &cls_flow,
 				   block_cb->cb_priv);
 		if (err < 0)
 			continue;
@@ -599,7 +599,7 @@ static void flow_offload_tuple_del(struct flow_offload_work *offload,
 			     &offload->flow->tuplehash[dir].tuple, &extack);
 
 	list_for_each_entry(block_cb, &flowtable->flow_block.cb_list, list)
-		block_cb->cb(TC_SETUP_FT, &cls_flow, block_cb->cb_priv);
+		block_cb->cb(TC_SETUP_CLSFLOWER, &cls_flow, block_cb->cb_priv);
 
 	offload->flow->flags |= FLOW_OFFLOAD_HW_DEAD;
 }
@@ -656,7 +656,7 @@ static void flow_offload_tuple_stats(struct flow_offload_work *offload,
 			     &offload->flow->tuplehash[dir].tuple, &extack);
 
 	list_for_each_entry(block_cb, &flowtable->flow_block.cb_list, list)
-		block_cb->cb(TC_SETUP_FT, &cls_flow, block_cb->cb_priv);
+		block_cb->cb(TC_SETUP_CLSFLOWER, &cls_flow, block_cb->cb_priv);
 	memcpy(stats, &cls_flow.stats, sizeof(*stats));
 }
 
-- 
1.8.3.1

