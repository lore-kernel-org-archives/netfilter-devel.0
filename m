Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA698C76190
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 12:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83BCF2238E
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 12:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390016AbfGWMwu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 08:52:50 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:26619 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730891AbfGWMwt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 08:52:49 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id ED18041CBE;
        Tue, 23 Jul 2019 20:52:45 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 3/7] netfilter: nft_table_offload: Add rtnl for chain and rule operations
Date:   Tue, 23 Jul 2019 20:52:40 +0800
Message-Id: <1563886364-11164-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1563886364-11164-1-git-send-email-wenxu@ucloud.cn>
References: <1563886364-11164-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlOS0tLS0lIQ09KQ01ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NxA6Kyo6TDg0NlExMiwUTi4D
        QxQKCyFVSlVKTk1IQ0NNSE1NS0tDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlPSE43Bg++
X-HM-Tid: 0a6c1ee42d1d2086kuqyed18041cbe
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The nft_setup_cb_call and ndo_setup_tc callback should be under rtnl lock

or it will report:
kernel: RTNL: assertion failed at
drivers/net/ethernet/mellanox/mlx5/core/en_rep.c (635)

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_tables_offload.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 33543f5..3e1a1a8 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -115,14 +115,18 @@ static int nft_setup_cb_call(struct nft_base_chain *basechain,
 			     enum tc_setup_type type, void *type_data)
 {
 	struct flow_block_cb *block_cb;
-	int err;
+	int err = 0;
 
+	rtnl_lock();
 	list_for_each_entry(block_cb, &basechain->flow_block.cb_list, list) {
 		err = block_cb->cb(type, type_data, block_cb->cb_priv);
 		if (err < 0)
-			return err;
+			goto out;
 	}
-	return 0;
+
+out:
+	rtnl_unlock();
+	return err;
 }
 
 static int nft_flow_offload_rule(struct nft_trans *trans,
@@ -204,9 +208,11 @@ static int nft_flow_offload_chain(struct nft_trans *trans,
 	bo.extack = &extack;
 	INIT_LIST_HEAD(&bo.cb_list);
 
+	rtnl_lock();
+
 	err = dev->netdev_ops->ndo_setup_tc(dev, FLOW_SETUP_BLOCK, &bo);
 	if (err < 0)
-		return err;
+		goto out;
 
 	switch (cmd) {
 	case FLOW_BLOCK_BIND:
@@ -217,6 +223,8 @@ static int nft_flow_offload_chain(struct nft_trans *trans,
 		break;
 	}
 
+out:
+	rtnl_unlock();
 	return err;
 }
 
-- 
1.8.3.1

