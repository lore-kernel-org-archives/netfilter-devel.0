Return-Path: <SRS0=DEFU=WP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4FDC3A5A0
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 09:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A48C20989
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 09:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfHSJpM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Aug 2019 05:45:12 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:34540 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfHSJpM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Aug 2019 05:45:12 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 094DB41B8B;
        Mon, 19 Aug 2019 17:45:07 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/3] netfilter: nf_offload: Make nft_flow_offload_rule public
Date:   Mon, 19 Aug 2019 17:45:04 +0800
Message-Id: <1566207905-22203-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566207905-22203-1-git-send-email-wenxu@ucloud.cn>
References: <1566207905-22203-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJOQkJCQkxCQkxJQ09ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NBA6Khw*HDgxSDgTTyMjAjAc
        Tk8wFBZVSlVKTk1NSUtMQktMSklPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9LTUo3Bg++
X-HM-Tid: 0a6ca94414fc2086kuqy094db41b8b
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Refactor nft_flow_offload_rule and make it public in header

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/netfilter/nf_tables_offload.h |  4 ++++
 net/netfilter/nf_tables_offload.c         | 26 ++++++++++++++++++--------
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index a13aab1..6946db67 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -71,6 +71,10 @@ void nft_indr_block_get_and_ing_cmd(struct net_device *dev,
 
 int nft_flow_offload_chain(struct nft_chain *chain,
 			   enum flow_block_command cmd);
+int nft_flow_offload_rule(struct nft_chain *chain,
+			  struct nft_rule *rule,
+			  struct nft_flow_rule *flow,
+			  enum flow_cls_command command);
 
 #define NFT_OFFLOAD_MATCH(__key, __base, __field, __len, __reg)		\
 	(__reg)->base_offset	=					\
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 3ffe4bb..bcaafc8 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -124,20 +124,20 @@ static int nft_setup_cb_call(struct nft_base_chain *basechain,
 	return 0;
 }
 
-static int nft_flow_offload_rule(struct nft_trans *trans,
-				 enum flow_cls_command command)
+int nft_flow_offload_rule(struct nft_chain *chain,
+			  struct nft_rule *rule,
+			  struct nft_flow_rule *flow,
+			  enum flow_cls_command command)
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
@@ -151,6 +151,16 @@ static int nft_flow_offload_rule(struct nft_trans *trans,
 	return nft_setup_cb_call(basechain, TC_SETUP_CLSFLOWER, &cls_flow);
 }
 
+static int __nft_flow_offload_rule(struct nft_trans *trans,
+				   enum flow_cls_command command)
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
@@ -326,14 +336,14 @@ int nft_flow_rule_offload_commit(struct net *net)
 			    !(trans->ctx.flags & NLM_F_APPEND))
 				return -EOPNOTSUPP;
 
-			err = nft_flow_offload_rule(trans, FLOW_CLS_REPLACE);
+			err = __nft_flow_offload_rule(trans, FLOW_CLS_REPLACE);
 			nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_DELRULE:
 			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
-			err = nft_flow_offload_rule(trans, FLOW_CLS_DESTROY);
+			err = __nft_flow_offload_rule(trans, FLOW_CLS_DESTROY);
 			break;
 		}
 
-- 
1.8.3.1

