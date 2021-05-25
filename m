Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E037C4707F
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 May 2021 20:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C36F6140B
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 May 2021 20:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbhEYUxr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 May 2021 16:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbhEYUxr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 May 2021 16:53:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BFFC061574
        for <netfilter-devel@vger.kernel.org>; Tue, 25 May 2021 13:52:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lle2B-0007UY-HA; Tue, 25 May 2021 22:52:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/4] netfilter: annotate nf_tables base hook ops
Date:   Tue, 25 May 2021 22:51:32 +0200
Message-Id: <20210525205133.5718-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210525205133.5718-1-fw@strlen.de>
References: <20210525205133.5718-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This will allow a followup patch to treat the 'ops->priv' pointer
as nft_chain argument without having to first walk to table/chains
for a match.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h     | 8 +++++++-
 net/netfilter/nf_tables_api.c | 4 +++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 63f77794f5ed..6c327689ff82 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -77,12 +77,18 @@ struct nf_hook_state {
 typedef unsigned int nf_hookfn(void *priv,
 			       struct sk_buff *skb,
 			       const struct nf_hook_state *state);
+enum nf_hook_ops_type {
+	NF_HOOK_OP_UNDEFINED,
+	NF_HOOK_OP_NF_TABLES,
+};
+
 struct nf_hook_ops {
 	/* User fills in from here down. */
 	nf_hookfn		*hook;
 	struct net_device	*dev;
 	void			*priv;
-	u_int8_t		pf;
+	u8			pf;
+	enum nf_hook_ops_type	hook_ops_type:8;
 	unsigned int		hooknum;
 	/* Hooks are ordered in ascending priority. */
 	int			priority;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 899a38615f46..e7e80c8ee123 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2172,8 +2172,10 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	}
 
 	nft_trans_chain_policy(trans) = NFT_CHAIN_POLICY_UNSET;
-	if (nft_is_base_chain(chain))
+	if (nft_is_base_chain(chain)) {
+		basechain->ops.hook_ops_type = NF_HOOK_OP_NF_TABLES;
 		nft_trans_chain_policy(trans) = policy;
+	}
 
 	err = nft_chain_add(table, chain);
 	if (err < 0) {
-- 
2.26.3

