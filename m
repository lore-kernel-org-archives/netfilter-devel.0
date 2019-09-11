Return-Path: <SRS0=w/jS=XG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E002C5AE59
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Sep 2019 04:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E58C21D79
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Sep 2019 04:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbfIKEx3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Sep 2019 00:53:29 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:59592 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbfIKEx2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Sep 2019 00:53:28 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 89FE8417F5;
        Wed, 11 Sep 2019 12:53:25 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v6 3/4] netfilter: nf_offload: refactor the nft_flow_offload_rule function
Date:   Wed, 11 Sep 2019 12:53:23 +0800
Message-Id: <1568177604-26989-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568177604-26989-1-git-send-email-wenxu@ucloud.cn>
References: <1568177604-26989-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJNS0tLSUpDSEJKT0lZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6KzY6Cyo5ETg*CzQ9FjBOMEpC
        TjgKCktVSlVKTk1DSkxMTUtOTUpMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlCSUs3Bg++
X-HM-Tid: 0a6d1eab4bc82086kuqy89fe8417f5
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Refactor nft_flow_offload_rule and make it more common

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v6: only refactor nft_flow_offload_rule

 net/netfilter/nf_tables_offload.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 367a7fa..739a79c 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -155,20 +155,20 @@ int nft_chain_offload_priority(struct nft_base_chain *basechain)
 	return 0;
 }
 
-static int nft_flow_offload_rule(struct nft_trans *trans,
+static int nft_flow_offload_rule(struct nft_chain *chain,
+				 struct nft_rule *rule,
+				 struct nft_flow_rule *flow,
 				 enum flow_cls_command command)
 {
-	struct nft_flow_rule *flow = nft_trans_flow_rule(trans);
-	struct nft_rule *rule = nft_trans_rule(trans);
 	struct flow_cls_offload cls_flow = {};
 	struct nft_base_chain *basechain;
 	struct netlink_ext_ack extack;
 	__be16 proto = ETH_P_ALL;
 
-	if (!nft_is_base_chain(trans->ctx.chain))
+	if (!nft_is_base_chain(chain))
 		return -EOPNOTSUPP;
 
-	basechain = nft_base_chain(trans->ctx.chain);
+	basechain = nft_base_chain(chain);
 
 	if (flow)
 		proto = flow->proto;
@@ -357,14 +357,20 @@ int nft_flow_rule_offload_commit(struct net *net)
 			    !(trans->ctx.flags & NLM_F_APPEND))
 				return -EOPNOTSUPP;
 
-			err = nft_flow_offload_rule(trans, FLOW_CLS_REPLACE);
+			err = nft_flow_offload_rule(trans->ctx.chain,
+						    nft_trans_rule(trans),
+						    nft_trans_flow_rule(trans),
+						    FLOW_CLS_REPLACE);
 			nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_DELRULE:
 			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
-			err = nft_flow_offload_rule(trans, FLOW_CLS_DESTROY);
+			err = nft_flow_offload_rule(trans->ctx.chain,
+						    nft_trans_rule(trans),
+						    nft_trans_flow_rule(trans),
+						    FLOW_CLS_DESTROY);
 			break;
 		}
 
-- 
1.8.3.1

