Return-Path: <SRS0=8p/T=ZF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE20C43331
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 04:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 557CC222D0
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 04:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfKMEVL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 23:21:11 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:41029 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbfKMEVL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 23:21:11 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 2AD415C188C;
        Wed, 13 Nov 2019 12:21:08 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: [PATCH nf] netfilter: nf_tables_offload: Fix check the NETDEV_UNREGISTER in netdev event
Date:   Wed, 13 Nov 2019 12:21:07 +0800
Message-Id: <1573618867-9755-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ0lCQkJCQklITEtNSllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MBA6DRw4Lzg0CxQRCA4YIw5R
        HS1PCy5VSlVKTkxITUpDQ01DSU5PVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpPSk83Bg++
X-HM-Tid: 0a6e62fe5fd92087kuqy2ad415c188c
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

It should check the NETDEV_UNREGISTER in  nft_offload_netdev_event

Fixes: 06d392cbe3db ("netfilter: nf_tables_offload: remove rules when the device unregisters")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_tables_offload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index e25dab8..b002832 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -446,6 +446,9 @@ static int nft_offload_netdev_event(struct notifier_block *this,
 	struct net *net = dev_net(dev);
 	struct nft_chain *chain;
 
+	if (event != NETDEV_UNREGISTER)
+		return 0;
+
 	mutex_lock(&net->nft.commit_mutex);
 	chain = __nft_offload_get_chain(dev);
 	if (chain)
-- 
1.8.3.1

