Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0CEC433ED
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 07:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E62D1610A5
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 07:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhDBHN6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 03:13:58 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:11100 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234161AbhDBHN4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 03:13:56 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id CE540E02914;
        Fri,  2 Apr 2021 15:13:53 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_payload: fix vlan_tpid get from h_vlan_proto
Date:   Fri,  2 Apr 2021 15:13:52 +0800
Message-Id: <1617347632-19283-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSE9MS0tDHUxMSEhIVkpNSkxIT0xNSEhCS0NVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MBg6Hzo4Mj09Fw40IT8fMglJ
        ECMwCwNVSlVKTUpMSE9MTUhPS0JMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpCQkg3Bg++
X-HM-Tid: 0a78916e62bf20bdkuqyce540e02914
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

vlan_tpid of flow_dissector_key_vlan should be set as h_vlan_proto
but not h_vlan_encapsulated_proto.

Fixes: a82055af5959 ("netfilter: nft_payload: add VLAN offload support")
Fixes: 89d8fd44abfb ("netfilter: nft_payload: add C-VLAN offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nft_payload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index cb1c8c2..4b582eb 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -229,7 +229,7 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_VLAN, vlan,
 				  vlan_tci, sizeof(__be16), reg);
 		break;
-	case offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto):
+	case offsetof(struct vlan_ethhdr, h_vlan_proto):
 		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
@@ -244,7 +244,7 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, vlan,
 				  vlan_tci, sizeof(__be16), reg);
 		break;
-	case offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto) +
+	case offsetof(struct vlan_ethhdr, h_vlan_proto) +
 							sizeof(struct vlan_hdr):
 		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
-- 
1.8.3.1

