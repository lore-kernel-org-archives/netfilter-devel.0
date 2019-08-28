Return-Path: <SRS0=hqFW=WY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B538C3A5A1
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Aug 2019 15:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDF9B2189D
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Aug 2019 15:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfH1PCu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 11:02:50 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:26450 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbfH1PCu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 11:02:50 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 9C0AC411AB;
        Wed, 28 Aug 2019 23:02:37 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_meta_bridge: Fix get NFT_META_BRI_IIFVPROTO in network byteorder
Date:   Wed, 28 Aug 2019 23:02:33 +0800
Message-Id: <1567004553-15231-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVNS0hCQkJDTkhKSE9KTVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Oio6MRw6Czg*AzNLPDk#NzY8
        DD0aCRZVSlVKTk1MS0tPTk5MTEtDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpIQk03Bg++
X-HM-Tid: 0a6cd8c0014f2086kuqy9c0ac411ab
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Get the vlan_proto of ingress bridge in network byteorder

Fixes: 2a3a93ef0ba5 ("netfilter: nft_meta_bridge: Add NFT_META_BRI_IIFVPROTO support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/bridge/netfilter/nft_meta_bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 1804e86..7c9e92b2 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -53,7 +53,7 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 			goto err;
 
 		br_vlan_get_proto(br_dev, &p_proto);
-		nft_reg_store16(dest, p_proto);
+		nft_reg_store16(dest, htons(p_proto));
 		return;
 	}
 	default:
-- 
1.8.3.1

