Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10EE1C4708F
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 10:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED6B661406
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 10:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhFDK3F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Jun 2021 06:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhFDK3E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Jun 2021 06:29:04 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F83C06174A
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Jun 2021 03:27:18 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lp72r-0004a5-7T; Fri, 04 Jun 2021 12:27:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 1/2] netfilter: annotate nf_tables base hook ops
Date:   Fri,  4 Jun 2021 12:27:06 +0200
Message-Id: <20210604102707.799-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210604102707.799-1-fw@strlen.de>
References: <20210604102707.799-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This will allow a followup patch to treat the 'ops->priv' pointer
as nft_chain argument without having to first walk the table/chains
to check if there is a matching base chain pointer.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 no changes.

 include/linux/netfilter.h     | 8 +++++++-
 net/netfilter/nf_tables_api.c | 4 +++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index f161569fbe2f..3fda1a508733 100644
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
index d63d2d8f769c..3fe052710381 100644
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

