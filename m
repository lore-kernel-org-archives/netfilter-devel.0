Return-Path: <SRS0=xNQb=W6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5522C3A5A2
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Sep 2019 23:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91C0322CED
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Sep 2019 23:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfICXaE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Sep 2019 19:30:04 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:37227 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfICXaE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Sep 2019 19:30:04 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E7D3E4116A;
        Wed,  4 Sep 2019 07:30:01 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_table_offload: Fix check the offload flags in nft_indr_block_cb
Date:   Wed,  4 Sep 2019 07:30:01 +0800
Message-Id: <1567553401-8840-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVNTU9CQkJCTUpDTkhLSFlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6KzI6OTo4HTgxFzA9SixRETIU
        KSkaFDxVSlVKTk1MTk5IT0tJS0hKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpOSks3Bg++
X-HM-Tid: 0a6cf976b46d2086kuqye7d3e4116a
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

In the nft_indr_block_cb handle offload chain should check the offload flags
for the chain.

Fixes: 9a32669fecfb ("netfilter: nf_tables_offload: support indr block call")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_tables_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index ca9e0cb..3f49fe8 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -363,7 +363,8 @@ static void nft_indr_block_cb(struct net_device *dev,
 			continue;
 
 		list_for_each_entry(chain, &table->chains, list) {
-			if (!nft_is_base_chain(chain))
+			if (!nft_is_base_chain(chain) ||
+			    !(chain->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
 			basechain = nft_base_chain(chain);
-- 
1.8.3.1

