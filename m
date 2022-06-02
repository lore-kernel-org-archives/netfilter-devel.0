Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C4AFC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Jun 2022 13:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbiFBNcv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Jun 2022 09:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbiFBNcv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Jun 2022 09:32:51 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B17366593
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2022 06:32:47 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     kuba@kernel.org
Subject: [PATCH nf] netfilter: nf_tables: bail out early if hardware offload is not supported
Date:   Thu,  2 Jun 2022 15:32:40 +0200
Message-Id: <20220602133240.1463-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If user requests for NFT_CHAIN_HW_OFFLOAD, then check if either device
provides the .ndo_setup_tc interface or there is an indirect flow block
that has been registered. Otherwise, bail out early from the preparation
phase.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/flow_offload.h                |  1 +
 include/net/netfilter/nf_tables_offload.h |  2 +-
 net/core/flow_offload.c                   |  6 ++++++
 net/netfilter/nf_tables_api.c             |  2 +-
 net/netfilter/nf_tables_offload.c         | 20 +++++++++++++++++++-
 5 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 021778a7e1af..6484095a8c01 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -612,5 +612,6 @@ int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
 				enum tc_setup_type type, void *data,
 				struct flow_block_offload *bo,
 				void (*cleanup)(struct flow_block_cb *block_cb));
+bool flow_indr_dev_exists(void);
 
 #endif /* _NET_FLOW_OFFLOAD_H */
diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 797147843958..3568b6a2f5f0 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -92,7 +92,7 @@ int nft_flow_rule_offload_commit(struct net *net);
 	NFT_OFFLOAD_MATCH(__key, __base, __field, __len, __reg)		\
 	memset(&(__reg)->mask, 0xff, (__reg)->len);
 
-int nft_chain_offload_priority(struct nft_base_chain *basechain);
+bool nft_chain_offload_support(const struct nft_base_chain *basechain);
 
 int nft_offload_init(void);
 void nft_offload_exit(void);
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 73f68d4625f3..929f6379a279 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -595,3 +595,9 @@ int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
 	return (bo && list_empty(&bo->cb_list)) ? -EOPNOTSUPP : count;
 }
 EXPORT_SYMBOL(flow_indr_dev_setup_offload);
+
+bool flow_indr_dev_exists(void)
+{
+	return !list_empty(&flow_block_indr_dev_list);
+}
+EXPORT_SYMBOL(flow_indr_dev_exists);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1b971692be95..6df99330f9dd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2166,7 +2166,7 @@ static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
 	chain->flags |= NFT_CHAIN_BASE | flags;
 	basechain->policy = NF_ACCEPT;
 	if (chain->flags & NFT_CHAIN_HW_OFFLOAD &&
-	    nft_chain_offload_priority(basechain) < 0)
+	    !nft_chain_offload_support(basechain))
 		return -EOPNOTSUPP;
 
 	flow_block_init(&basechain->flow_block);
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 2d36952b1392..5efbfa2d79bf 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -208,7 +208,7 @@ static int nft_setup_cb_call(enum tc_setup_type type, void *type_data,
 	return 0;
 }
 
-int nft_chain_offload_priority(struct nft_base_chain *basechain)
+static int nft_chain_offload_priority(const struct nft_base_chain *basechain)
 {
 	if (basechain->ops.priority <= 0 ||
 	    basechain->ops.priority > USHRT_MAX)
@@ -217,6 +217,24 @@ int nft_chain_offload_priority(struct nft_base_chain *basechain)
 	return 0;
 }
 
+bool nft_chain_offload_support(const struct nft_base_chain *basechain)
+{
+	struct net_device *dev;
+	struct nft_hook *hook;
+
+	list_for_each_entry(hook, &basechain->hook_list, list) {
+		dev = hook->ops.dev;
+
+		if (!dev->netdev_ops->ndo_setup_tc && !flow_indr_dev_exists())
+			return false;
+
+		if (nft_chain_offload_priority(basechain) < 0)
+			return false;
+	}
+
+	return true;
+}
+
 static void nft_flow_cls_offload_setup(struct flow_cls_offload *cls_flow,
 				       const struct nft_base_chain *basechain,
 				       const struct nft_rule *rule,
-- 
2.30.2

