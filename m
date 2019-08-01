Return-Path: <SRS0=uSEi=V5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0076C41514
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 14:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 913E8205F4
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 14:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731475AbfHAOBk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 10:01:40 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:22709 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731335AbfHAOBk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 10:01:40 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id A18ED41623;
        Thu,  1 Aug 2019 22:01:27 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v3 1/9] netfilter: nf_flow_offload: add net in offload_ctx
Date:   Thu,  1 Aug 2019 22:01:18 +0800
Message-Id: <1564668086-16260-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564668086-16260-1-git-send-email-wenxu@ucloud.cn>
References: <1564668086-16260-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS01MS0tLS0hKT0xKSU5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MxA6HTo*Czg#Nk8aFy89I0I0
        EDUaCQhVSlVKTk1PTU1DS0NMTE9PVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhKTEw3Bg++
X-HM-Tid: 0a6c4d7c4d7a2086kuqya18ed41623
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

In the offload_ctx, the net can be used for other actions
such as fwd netdev

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v3: no change

 include/net/netfilter/nf_tables_offload.h | 3 ++-
 net/netfilter/nf_tables_api.c             | 2 +-
 net/netfilter/nf_tables_offload.c         | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 3196663..ad61958 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -24,6 +24,7 @@ struct nft_offload_ctx {
 		__be16				l3num;
 		u8				protonum;
 	} dep;
+	struct net *net;
 	unsigned int				num_actions;
 	struct nft_offload_reg			regs[NFT_REG32_15 + 1];
 };
@@ -60,7 +61,7 @@ struct nft_flow_rule {
 #define NFT_OFFLOAD_F_ACTION	(1 << 0)
 
 struct nft_rule;
-struct nft_flow_rule *nft_flow_rule_create(const struct nft_rule *rule);
+struct nft_flow_rule *nft_flow_rule_create(struct net *net, const struct nft_rule *rule);
 void nft_flow_rule_destroy(struct nft_flow_rule *flow);
 int nft_flow_rule_offload_commit(struct net *net);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 605a7cf..c6dc173 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2844,7 +2844,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 		return nft_table_validate(net, table);
 
 	if (chain->flags & NFT_CHAIN_HW_OFFLOAD) {
-		flow = nft_flow_rule_create(rule);
+		flow = nft_flow_rule_create(net, rule);
 		if (IS_ERR(flow))
 			return PTR_ERR(flow);
 
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 64f5fd5..5c1fef7 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -28,12 +28,13 @@ static struct nft_flow_rule *nft_flow_rule_alloc(int num_actions)
 	return flow;
 }
 
-struct nft_flow_rule *nft_flow_rule_create(const struct nft_rule *rule)
+struct nft_flow_rule *nft_flow_rule_create(struct net *net, const struct nft_rule *rule)
 {
 	struct nft_offload_ctx ctx = {
 		.dep	= {
 			.type	= NFT_OFFLOAD_DEP_UNSPEC,
 		},
+		.net = net,
 	};
 	struct nft_flow_rule *flow;
 	int num_actions = 0, err;
-- 
1.8.3.1

