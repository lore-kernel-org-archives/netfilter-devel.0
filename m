Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC46C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 11:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9111664F69
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 11:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhCQLzI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 07:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbhCQLzB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 07:55:01 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 97AF9C06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 04:55:01 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9680063546
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 12:54:58 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 2/2,v2] netfilter: nftables: allow to update flowtable flags
Date:   Wed, 17 Mar 2021 12:54:57 +0100
Message-Id: <20210317115457.1891-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Honor flowtable flags from the control update path. Disallow disabling
to toggle hardware offload support though.

Fixes: 8bb69f3b2918 ("netfilter: nf_tables: add flowtable offload control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: if NFTA_FLOWTABLE_FLAGS is not specified, leave the existing flags in
    place.

 include/net/netfilter/nf_tables.h |  3 +++
 net/netfilter/nf_tables_api.c     | 15 +++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index fdec57d862b7..5aaced6bf13e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1536,6 +1536,7 @@ struct nft_trans_flowtable {
 	struct nft_flowtable		*flowtable;
 	bool				update;
 	struct list_head		hook_list;
+	u32				flags;
 };
 
 #define nft_trans_flowtable(trans)	\
@@ -1544,6 +1545,8 @@ struct nft_trans_flowtable {
 	(((struct nft_trans_flowtable *)trans->data)->update)
 #define nft_trans_flowtable_hooks(trans)	\
 	(((struct nft_trans_flowtable *)trans->data)->hook_list)
+#define nft_trans_flowtable_flags(trans)	\
+	(((struct nft_trans_flowtable *)trans->data)->flags)
 
 int __init nft_chain_filter_init(void);
 void nft_chain_filter_fini(void);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0d034f895b7b..4fcd07f1e925 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6842,6 +6842,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	struct nft_hook *hook, *next;
 	struct nft_trans *trans;
 	bool unregister = false;
+	u32 flags;
 	int err;
 
 	err = nft_flowtable_parse_hook(ctx, nla[NFTA_FLOWTABLE_HOOK],
@@ -6856,6 +6857,17 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		}
 	}
 
+	if (nla[NFTA_FLOWTABLE_FLAGS]) {
+		flags = ntohl(nla_get_be32(nla[NFTA_FLOWTABLE_FLAGS]));
+		if (flags & ~NFT_FLOWTABLE_MASK)
+			return -EOPNOTSUPP;
+		if ((flowtable->data.flags & NFT_FLOWTABLE_HW_OFFLOAD) ^
+		    (flags & NFT_FLOWTABLE_HW_OFFLOAD))
+			return -EOPNOTSUPP;
+	} else {
+		flags = flowtable->data.flags;
+	}
+
 	err = nft_register_flowtable_net_hooks(ctx->net, ctx->table,
 					       &flowtable_hook.list, flowtable);
 	if (err < 0)
@@ -6869,6 +6881,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		goto err_flowtable_update_hook;
 	}
 
+	nft_trans_flowtable_flags(trans) = flags;
 	nft_trans_flowtable(trans) = flowtable;
 	nft_trans_flowtable_update(trans) = true;
 	INIT_LIST_HEAD(&nft_trans_flowtable_hooks(trans));
@@ -8178,6 +8191,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_NEWFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
+				nft_trans_flowtable(trans)->data.flags =
+					nft_trans_flowtable_flags(trans);
 				nf_tables_flowtable_notify(&trans->ctx,
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
-- 
2.20.1

