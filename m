Return-Path: <SRS0=O/k4=YS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F45C47E49
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Oct 2019 07:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD98B2070B
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Oct 2019 07:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437135AbfJYHq3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Oct 2019 03:46:29 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:64884 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbfJYHq3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Oct 2019 03:46:29 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 859CC419F4;
        Fri, 25 Oct 2019 15:46:25 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables_offload: support offload iif types meta offload
Date:   Fri, 25 Oct 2019 15:46:24 +0800
Message-Id: <1571989584-940-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVMTEJCQkJMSElCTEpKQllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NDo6Hio4PDg8MR4tFkhRSTQS
        DzBPFDlVSlVKTkxKQkNCTkNOTElDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUxOSk03Bg++
X-HM-Tid: 0a6e01e17ebe2086kuqy859cc419f4
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The offload basechain is based on ingress devices. The netdev chain can
bypass offload the iif types meta in the rule build status

The ether header payload match rely on the iiftype meta

nft --debug=netlink add rule netdev firewall zones ether daddr fa:ff:ff:ff:ff:ff
netdev firewall zones
  [ meta load iiftype => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]
  [ payload load 6b @ link header + 0 => reg 1 ]
  [ cmp eq reg 1 0xfffffffa 0x0000ffff ]

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/netfilter/nf_tables_offload.h | 17 +++++++-
 net/netfilter/nf_tables_api.c             |  2 +-
 net/netfilter/nf_tables_offload.c         | 64 ++++++++++++++++++++++++++++++-
 net/netfilter/nft_cmp.c                   |  3 ++
 net/netfilter/nft_meta.c                  |  9 +++++
 5 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 03cf585..1dcce48 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -19,12 +19,21 @@ enum nft_offload_dep_type {
 	NFT_OFFLOAD_DEP_TRANSPORT,
 };
 
+enum nft_offload_idevice_type {
+	NFT_OFFLOAD_IDEVICE_UNSPEC = 0,
+	NFT_OFFLOAD_IDEVICE_IIF,
+	NFT_OFFLOAD_IDEVICE_IIFTYPE,
+	NFT_OFFLOAD_IDEVICE_IIFGROUP,
+};
+
 struct nft_offload_ctx {
 	struct {
 		enum nft_offload_dep_type	type;
 		__be16				l3num;
 		u8				protonum;
 	} dep;
+	enum nft_offload_idevice_type		idevice_type;
+	struct list_head			*hook_list;
 	unsigned int				num_actions;
 	struct net				*net;
 	struct nft_offload_reg			regs[NFT_REG32_15 + 1];
@@ -34,6 +43,10 @@ void nft_offload_set_dependency(struct nft_offload_ctx *ctx,
 				enum nft_offload_dep_type type);
 void nft_offload_update_dependency(struct nft_offload_ctx *ctx,
 				   const void *data, u32 len);
+void nft_offload_set_idevice(struct nft_offload_ctx *ctx,
+			     enum nft_offload_idevice_type type);
+int nft_offload_check_idevice(struct nft_offload_ctx *ctx,
+			       const void *data, u32 len);
 
 struct nft_flow_key {
 	struct flow_dissector_key_basic			basic;
@@ -62,7 +75,9 @@ struct nft_flow_rule {
 #define NFT_OFFLOAD_F_ACTION	(1 << 0)
 
 struct nft_rule;
-struct nft_flow_rule *nft_flow_rule_create(struct net *net, const struct nft_rule *rule);
+struct nft_flow_rule *nft_flow_rule_create(struct net *net,
+					   const struct nft_rule *rule,
+					   struct nft_chain *chain);
 void nft_flow_rule_destroy(struct nft_flow_rule *flow);
 int nft_flow_rule_offload_commit(struct net *net);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 13f0941..3990685 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3108,7 +3108,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 		return nft_table_validate(net, table);
 
 	if (chain->flags & NFT_CHAIN_HW_OFFLOAD) {
-		flow = nft_flow_rule_create(net, rule);
+		flow = nft_flow_rule_create(net, rule, chain);
 		if (IS_ERR(flow))
 			return PTR_ERR(flow);
 
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 4e0625c..bfa5ac5 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -29,8 +29,10 @@ static struct nft_flow_rule *nft_flow_rule_alloc(int num_actions)
 }
 
 struct nft_flow_rule *nft_flow_rule_create(struct net *net,
-					   const struct nft_rule *rule)
+					   const struct nft_rule *rule,
+					   struct nft_chain *chain)
 {
+	struct nft_base_chain *basechain;
 	struct nft_offload_ctx *ctx;
 	struct nft_flow_rule *flow;
 	int num_actions = 0, err;
@@ -58,6 +60,9 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 	ctx->net = net;
 	ctx->dep.type = NFT_OFFLOAD_DEP_UNSPEC;
 
+	basechain = nft_base_chain(chain);
+	ctx->hook_list = &basechain->hook_list;
+
 	while (expr->ops && expr != nft_expr_last(rule)) {
 		if (!expr->ops->offload) {
 			err = -EOPNOTSUPP;
@@ -123,6 +128,63 @@ void nft_offload_update_dependency(struct nft_offload_ctx *ctx,
 	ctx->dep.type = NFT_OFFLOAD_DEP_UNSPEC;
 }
 
+void nft_offload_set_idevice(struct nft_offload_ctx *ctx,
+			     enum nft_offload_idevice_type type)
+{
+	ctx->idevice_type = type;
+}
+
+int nft_offload_check_idevice(struct nft_offload_ctx *ctx,
+			      const void *data, u32 len)
+{
+	struct list_head *hook_list;
+	struct net_device *dev;
+	struct nft_hook *hook;
+	int ret = -EOPNOTSUPP;
+	__u32 data32;
+	__u16 data16;
+
+	hook_list = ctx->hook_list;
+	list_for_each_entry(hook, hook_list, list) {
+		dev = hook->ops.dev;
+
+		ret = 0;
+		switch (ctx->idevice_type) {
+		case NFT_OFFLOAD_IDEVICE_IIF:
+			WARN_ON(len != sizeof(__u32));
+			memcpy(&data32, data, sizeof(__u32));
+			if (data32 != dev->ifindex) {
+				ret = -EINVAL;
+				goto out;
+			}
+			break;
+		case NFT_OFFLOAD_IDEVICE_IIFTYPE:
+			WARN_ON(len != sizeof(__u16));
+			memcpy(&data16, data, sizeof(__u16));
+			if (data16 != dev->type) {
+				ret = -EINVAL;
+				goto out;
+			}
+			break;
+		case NFT_OFFLOAD_IDEVICE_IIFGROUP:
+			WARN_ON(len != sizeof(__u32));
+			memcpy(&data32, data, sizeof(__u32));
+			if (data32 != dev->group) {
+				ret = -EINVAL;
+				goto out;
+			}
+			break;
+		default:
+			ret = -EOPNOTSUPP;
+			goto out;
+		}
+	}
+
+out:
+	ctx->idevice_type = NFT_OFFLOAD_IDEVICE_UNSPEC;
+	return ret;
+}
+
 static void nft_flow_offload_common_init(struct flow_cls_common_offload *common,
 					 __be16 proto, int priority,
 					 struct netlink_ext_ack *extack)
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index bd173b1..25344bc 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -119,6 +119,9 @@ static int __nft_cmp_offload(struct nft_offload_ctx *ctx,
 	if (priv->op != NFT_CMP_EQ)
 		return -EOPNOTSUPP;
 
+	if (ctx->idevice_type != NFT_OFFLOAD_IDEVICE_UNSPEC)
+		return nft_offload_check_idevice(ctx, &priv->data, priv->len);
+
 	memcpy(key + reg->offset, &priv->data, priv->len);
 	memcpy(mask + reg->offset, &reg->mask, priv->len);
 
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 317e3a9..1038dc8 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -547,6 +547,15 @@ static int nft_meta_get_offload(struct nft_offload_ctx *ctx,
 				  sizeof(__u8), reg);
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_TRANSPORT);
 		break;
+	case NFT_META_IIF:
+		nft_offload_set_idevice(ctx, NFT_OFFLOAD_IDEVICE_IIF);
+		break;
+	case NFT_META_IIFTYPE:
+		nft_offload_set_idevice(ctx, NFT_OFFLOAD_IDEVICE_IIFTYPE);
+		break;
+	case NFT_META_IIFGROUP:
+		nft_offload_set_idevice(ctx, NFT_OFFLOAD_IDEVICE_IIFGROUP);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
1.8.3.1

