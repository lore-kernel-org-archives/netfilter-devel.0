Return-Path: <SRS0=dC0K=W7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B99C3A5A9
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 07:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFCC12087E
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 07:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbfIDHHi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 03:07:38 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:45447 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfIDHHi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 03:07:38 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 4C8EB4160A;
        Wed,  4 Sep 2019 15:07:32 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v2 1/3] netfilter: nf_offload: refactor the nft_flow_offload_chain function
Date:   Wed,  4 Sep 2019 15:07:29 +0800
Message-Id: <1567580851-15042-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567580851-15042-1-git-send-email-wenxu@ucloud.cn>
References: <1567580851-15042-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkhNQkJCQk1PTEpPS05ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OUk6DTo4CTg3OTBMNx4JGSIr
        Fj0wCQlVSlVKTk1MTkNLQ05JT0xKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhJTk03Bg++
X-HM-Tid: 0a6cfb1990602086kuqy4c8eb4160a
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Refactor nft_flow_offload_chain and make it more common

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_tables_offload.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 3f49fe8..9419486 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -273,10 +273,9 @@ static int nft_indr_block_offload_cmd(struct nft_base_chain *chain,
 
 #define FLOW_SETUP_BLOCK TC_SETUP_BLOCK
 
-static int nft_flow_offload_chain(struct nft_trans *trans,
+static int nft_flow_offload_chain(struct nft_chain *chain,
 				  enum flow_block_command cmd)
 {
-	struct nft_chain *chain = trans->ctx.chain;
 	struct nft_base_chain *basechain;
 	struct net_device *dev;
 
@@ -288,16 +287,24 @@ static int nft_flow_offload_chain(struct nft_trans *trans,
 	if (!dev)
 		return -EOPNOTSUPP;
 
+	if (dev->netdev_ops->ndo_setup_tc)
+		return nft_block_offload_cmd(basechain, dev, cmd);
+	else
+		return nft_indr_block_offload_cmd(basechain, dev, cmd);
+}
+
+static int nft_flow_offload_chain_commit(struct nft_trans *trans,
+					 enum flow_block_command cmd)
+{
+	struct nft_chain *chain = trans->ctx.chain;
+
 	/* Only default policy to accept is supported for now. */
 	if (cmd == FLOW_BLOCK_BIND &&
 	    nft_trans_chain_policy(trans) != -1 &&
 	    nft_trans_chain_policy(trans) != NF_ACCEPT)
 		return -EOPNOTSUPP;
 
-	if (dev->netdev_ops->ndo_setup_tc)
-		return nft_block_offload_cmd(basechain, dev, cmd);
-	else
-		return nft_indr_block_offload_cmd(basechain, dev, cmd);
+	return nft_flow_offload_chain(chain, cmd);
 }
 
 int nft_flow_rule_offload_commit(struct net *net)
@@ -314,13 +321,13 @@ int nft_flow_rule_offload_commit(struct net *net)
 			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
-			err = nft_flow_offload_chain(trans, FLOW_BLOCK_BIND);
+			err = nft_flow_offload_chain_commit(trans, FLOW_BLOCK_BIND);
 			break;
 		case NFT_MSG_DELCHAIN:
 			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
-			err = nft_flow_offload_chain(trans, FLOW_BLOCK_UNBIND);
+			err = nft_flow_offload_chain_commit(trans, FLOW_BLOCK_UNBIND);
 			break;
 		case NFT_MSG_NEWRULE:
 			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
-- 
1.8.3.1

