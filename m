Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68408CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 03:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BC3320856
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 03:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392415AbfJXDz0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 23:55:26 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:52058 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390377AbfJXDzZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 23:55:25 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 5E0275C1B3A;
        Thu, 24 Oct 2019 11:55:22 +0800 (CST)
From:   wenxu@ucloud.cn
To:     fw@strlen.de, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables_offload: Fix unbind devices when subsequent device bind failed
Date:   Thu, 24 Oct 2019 11:55:22 +0800
Message-Id: <1571889322-26547-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVIS0hCQkJCS0tDSkxDTFlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OBw6FDo5DDg9MR8qHkgpCj8W
        K04aCwpVSlVKTkxKQ0NCSElJTk1PVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlJQ0k3Bg++
X-HM-Tid: 0a6dfbe799b72087kuqy5e0275c1b3a
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

In the nft_flow_block_chain some devices bind success, but the subsequent
device failed. It should unbind the successful devices.

Fixes: bbaef955af6e ("netfilter: nf_tables: support for multiple devices per netdev hook")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_tables_offload.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index beeb74f..037c6bd 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -322,8 +322,9 @@ static int nft_flow_block_chain(struct nft_base_chain *basechain,
 {
 	struct net_device *dev;
 	struct nft_hook *hook;
-	int err;
+	int err, i;
 
+	i = 0;
 	list_for_each_entry(hook, &basechain->hook_list, list) {
 		dev = hook->ops.dev;
 		if (this_dev && this_dev != dev)
@@ -333,12 +334,28 @@ static int nft_flow_block_chain(struct nft_base_chain *basechain,
 			err = nft_block_offload_cmd(basechain, dev, cmd);
 		else
 			err = nft_indr_block_offload_cmd(basechain, dev, cmd);
-
-		if (err < 0)
-			return err;
+
+		if (err < 0) {
+			if (this_dev)
+				return err;
+			else if (cmd == FLOW_BLOCK_BIND)
+				goto err_unbind;
+		}
+		i++;
 	}
 
 	return 0;
+
+err_unbind:
+	list_for_each_entry(hook, &basechain->hook_list, list) {
+		if (i-- <= 0)
+			break;
+
+		dev = hook->ops.dev;
+		nft_flow_block_chain(basechain, dev, FLOW_BLOCK_UNBIND);
+	}
+
+	return err;
 }
 
 static int nft_flow_offload_chain(struct nft_chain *chain, u8 *ppolicy,
-- 
1.8.3.1

