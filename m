Return-Path: <SRS0=1PIt=XE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0252EC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Sep 2019 06:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D802420828
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Sep 2019 06:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfIIGWO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Sep 2019 02:22:14 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:4749 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728005AbfIIGWO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Sep 2019 02:22:14 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 35F4B41A3D;
        Mon,  9 Sep 2019 14:22:07 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v5 3/4] netfilter: nf_offload: refactor the nft_flow_offload_rule function
Date:   Mon,  9 Sep 2019 14:22:05 +0800
Message-Id: <1568010126-3173-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568010126-3173-1-git-send-email-wenxu@ucloud.cn>
References: <1568010126-3173-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVQk1JS0tLSkhKTUtMS01ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OQg6Pww4MDgzSDVRIxk#Lk43
        HRhPFAhVSlVKTk1DS0pLSklMSElOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhISk03Bg++
X-HM-Tid: 0a6d14afc7952086kuqy35f4b41a3d
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Refactor nft_flow_offload_rule and make it more common

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v5: no change

 net/netfilter/nf_tables_offload.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index c49bd1a..78b95e1 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -140,20 +140,20 @@ int nft_chain_offload_priority(struct nft_base_chain *basechain)
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
@@ -168,6 +168,16 @@ static int nft_flow_offload_rule(struct nft_trans *trans,
 	return nft_setup_cb_call(basechain, TC_SETUP_CLSFLOWER, &cls_flow);
 }
 
+static int nft_flow_offload_rule_commit(struct nft_trans *trans,
+					enum flow_cls_command command)
+{
+	struct nft_flow_rule *flow = nft_trans_flow_rule(trans);
+	struct nft_rule *rule = nft_trans_rule(trans);
+	struct nft_chain *chain = trans->ctx.chain;
+
+	return nft_flow_offload_rule(chain, rule, flow, command);
+}
+
 static int nft_flow_offload_bind(struct flow_block_offload *bo,
 				 struct nft_base_chain *basechain)
 {
@@ -343,14 +353,14 @@ int nft_flow_rule_offload_commit(struct net *net)
 			    !(trans->ctx.flags & NLM_F_APPEND))
 				return -EOPNOTSUPP;
 
-			err = nft_flow_offload_rule(trans, FLOW_CLS_REPLACE);
+			err = nft_flow_offload_rule_commit(trans, FLOW_CLS_REPLACE);
 			nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_DELRULE:
 			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
-			err = nft_flow_offload_rule(trans, FLOW_CLS_DESTROY);
+			err = nft_flow_offload_rule_commit(trans, FLOW_CLS_DESTROY);
 			break;
 		}
 
-- 
1.8.3.1

