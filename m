Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F2AC7EE39
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 May 2023 15:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbjEPPQS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 May 2023 11:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbjEPPQP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2023 11:16:15 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0671659E;
        Tue, 16 May 2023 08:16:14 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,4.14 6/8] netfilter: nft_dynset: do not reject set updates with NFT_SET_EVAL
Date:   Tue, 16 May 2023 17:16:04 +0200
Message-Id: <20230516151606.4892-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230516151606.4892-1-pablo@netfilter.org>
References: <20230516151606.4892-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[ 215a31f19dedd4e92a67cf5a9717ee898d012b3a ]

NFT_SET_EVAL is signalling the kernel that this sets can be updated from
the evaluation path, even if there are no expressions attached to the
element. Otherwise, set updates with no expressions fail. Update
description to describe the right semantics.

Fixes: 22fe54d5fefc ("netfilter: nf_tables: add support for dynamic set updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 net/netfilter/nft_dynset.c               | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 49b6997c3255..c7bb18ea4962 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -258,7 +258,7 @@ enum nft_rule_compat_attributes {
  * @NFT_SET_INTERVAL: set contains intervals
  * @NFT_SET_MAP: set is used as a dictionary
  * @NFT_SET_TIMEOUT: set uses timeouts
- * @NFT_SET_EVAL: set contains expressions for evaluation
+ * @NFT_SET_EVAL: set can be updated from the evaluation path
  * @NFT_SET_OBJECT: set contains stateful objects
  */
 enum nft_set_flags {
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index f174a66bbc4b..d1dc5c8937a5 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -190,9 +190,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		priv->expr = nft_expr_init(ctx, tb[NFTA_DYNSET_EXPR]);
 		if (IS_ERR(priv->expr))
 			return PTR_ERR(priv->expr);
-
-	} else if (set->flags & NFT_SET_EVAL)
-		return -EINVAL;
+	}
 
 	nft_set_ext_prepare(&priv->tmpl);
 	nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_KEY, set->klen);
-- 
2.30.2

