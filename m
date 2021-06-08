Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CE3C47082
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 21:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A655611BD
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 21:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbhFHVIK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Jun 2021 17:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbhFHVII (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Jun 2021 17:08:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37936C061574
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Jun 2021 14:06:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lqivN-0004rU-ON; Tue, 08 Jun 2021 23:06:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        coverity-bot <keescook+coverity-bot@chromium.org>
Subject: [PATCH nf-next] netfilter: move nf_tables base hook annotation to init helper
Date:   Tue,  8 Jun 2021 23:06:07 +0200
Message-Id: <20210608210607.13325-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

coverity scanner says:
2187  if (nft_is_base_chain(chain)) {
vvv   CID 1505166:  Memory - corruptions  (UNINIT)
vvv   Using uninitialized value "basechain".
2188  basechain->ops.hook_ops_type = NF_HOOK_OP_NF_TABLES;

... I don't see how nft_is_base_chain() can evaluate to true
while basechain pointer is garbage.

However, it seems better to place the NF_HOOK_OP_NF_TABLES annotation
in nft_basechain_hook_init() instead.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1505166 ("Memory - corruptions")
Fixes: 65b8b7bfc5284f ("netfilter: annotate nf_tables base hook ops")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3fe052710381..6a350b38d85d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2001,11 +2001,12 @@ static void nft_basechain_hook_init(struct nf_hook_ops *ops, u8 family,
 				    const struct nft_chain_hook *hook,
 				    struct nft_chain *chain)
 {
-	ops->pf		= family;
-	ops->hooknum	= hook->num;
-	ops->priority	= hook->priority;
-	ops->priv	= chain;
-	ops->hook	= hook->type->hooks[ops->hooknum];
+	ops->pf			= family;
+	ops->hooknum		= hook->num;
+	ops->priority		= hook->priority;
+	ops->priv		= chain;
+	ops->hook		= hook->type->hooks[ops->hooknum];
+	ops->hook_ops_type	= NF_HOOK_OP_NF_TABLES;
 }
 
 static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
@@ -2172,10 +2173,8 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	}
 
 	nft_trans_chain_policy(trans) = NFT_CHAIN_POLICY_UNSET;
-	if (nft_is_base_chain(chain)) {
-		basechain->ops.hook_ops_type = NF_HOOK_OP_NF_TABLES;
+	if (nft_is_base_chain(chain))
 		nft_trans_chain_policy(trans) = policy;
-	}
 
 	err = nft_chain_add(table, chain);
 	if (err < 0) {
-- 
2.31.1

