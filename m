Return-Path: <SRS0=5T/O=C3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2EC0C43463
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Sep 2020 13:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A171920872
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Sep 2020 13:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgIRNSM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Sep 2020 09:18:12 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54202 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726174AbgIRNSM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Sep 2020 09:18:12 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F3088A03C82F3ABC76FB;
        Fri, 18 Sep 2020 21:18:09 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 21:18:03 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] netfilter: nf_tables_offload: Remove unused macro FLOW_SETUP_BLOCK
Date:   Fri, 18 Sep 2020 21:17:29 +0800
Message-ID: <20200918131729.38652-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

commit 9a32669fecfb ("netfilter: nf_tables_offload: support indr block call")
left behind this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/netfilter/nf_tables_offload.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 9ef37c1b7b3b..7c7e06624dc3 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -323,8 +323,6 @@ static int nft_indr_block_offload_cmd(struct nft_base_chain *basechain,
 	return nft_block_setup(basechain, &bo, cmd);
 }
 
-#define FLOW_SETUP_BLOCK TC_SETUP_BLOCK
-
 static int nft_chain_offload_cmd(struct nft_base_chain *basechain,
 				 struct net_device *dev,
 				 enum flow_block_command cmd)
-- 
2.17.1

