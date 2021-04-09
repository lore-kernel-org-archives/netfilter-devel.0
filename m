Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2F5C433ED
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Apr 2021 05:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6842361181
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Apr 2021 05:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhDIFEG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 01:04:06 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:24152 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhDIFEG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 01:04:06 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id EC664E02A8A;
        Fri,  9 Apr 2021 13:03:49 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf v2] netfilter: nft_payload: fix the h_vlan_encapsulated_proto flow_dissector vlaue
Date:   Fri,  9 Apr 2021 13:03:49 +0800
Message-Id: <1617944629-10338-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZThlLSklKS0lDTUMdVkpNSkxCT09NSUJCQkhVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PRA6GBw4FT0xMUkWNh4IPjUw
        LxpPFDFVSlVKTUpMQk9PTUhLSklLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlKTkw3Bg++
X-HM-Tid: 0a78b503d2da20bdkuqyec664e02a8a
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

For the vlan packet the h_vlan_encapsulated_proto should be set
on the flow_dissector_key_basic->n_porto flow_dissector.

Fixes: a82055af5959 ("netfilter: nft_payload: add VLAN offload support")
Fixes: 89d8fd44abfb ("netfilter: nft_payload: add C-VLAN offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nft_payload.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index cb1c8c2..84c5ecc 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -233,8 +233,8 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
-		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_VLAN, vlan,
-				  vlan_tpid, sizeof(__be16), reg);
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic,
+				  n_proto, sizeof(__be16), reg);
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_NETWORK);
 		break;
 	case offsetof(struct vlan_ethhdr, h_vlan_TCI) + sizeof(struct vlan_hdr):
@@ -249,8 +249,8 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
-		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, vlan,
-				  vlan_tpid, sizeof(__be16), reg);
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic,
+				  n_proto, sizeof(__be16), reg);
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
1.8.3.1

