Return-Path: <SRS0=hCoj=ZA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3574C5DF60
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Nov 2019 12:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B35C2085B
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Nov 2019 12:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573214563;
	bh=7e2XOAxRCZkEiFfovhqWgSe7n5iO8CPSFgffFPsUjWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Jf86cZ3M2uRSkCG4yJGXBNHmBBLLhOiV9gLdhFCo0oZgxZWjHQ1Z4qp6WrUTxo5Cx
	 8Q3mT/YvDSnVKh+u3+5R3/Qqg1dJNDlMYoSfiyEwtRNa8AtFTpYoF0Zr4kBXi08U9g
	 rU/nx+vNPzBda3JbOQtrtj+2VjT5QomdBOJfKn5A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390647AbfKHMCi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:02:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390266AbfKHLnA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Nov 2019 06:43:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2954920656;
        Fri,  8 Nov 2019 11:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213380;
        bh=7e2XOAxRCZkEiFfovhqWgSe7n5iO8CPSFgffFPsUjWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kog+ZbiNI4ursv0kVHZzFocvBN/XrSGpqb3J6OGnHwEhJ8n1qhNmf6y1ozP0LGfqq
         +JulJMgJXq/o95GrJnjQBEE9SR9bxbq3H/yUwnHr8wb8BogVZJrW5Np1/WXAz5YNUR
         JObK87Yuw0YCe/jEHIlCdBPAk6gA80G6d8fvvG0s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 203/205] netfilter: nf_tables: avoid BUG_ON usage
Date:   Fri,  8 Nov 2019 06:37:50 -0500
Message-Id: <20191108113752.12502-203-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit fa5950e498e7face21a1761f327e6c1152f778c3 ]

None of these spots really needs to crash the kernel.
In one two cases we can jsut report error to userspace, in the other
cases we can just use WARN_ON (and leak memory instead).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 9 ++++++---
 net/netfilter/nft_cmp.c       | 6 ++++--
 net/netfilter/nft_reject.c    | 6 ++++--
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 24fddf0322790..289d079008ee8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1031,7 +1031,8 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 
 static void nf_tables_table_destroy(struct nft_ctx *ctx)
 {
-	BUG_ON(ctx->table->use > 0);
+	if (WARN_ON(ctx->table->use > 0))
+		return;
 
 	rhltable_destroy(&ctx->table->chains_ht);
 	kfree(ctx->table->name);
@@ -1446,7 +1447,8 @@ static void nf_tables_chain_destroy(struct nft_ctx *ctx)
 {
 	struct nft_chain *chain = ctx->chain;
 
-	BUG_ON(chain->use > 0);
+	if (WARN_ON(chain->use > 0))
+		return;
 
 	/* no concurrent access possible anymore */
 	nf_tables_chain_free_chain_rules(chain);
@@ -7253,7 +7255,8 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 {
 	struct nft_rule *rule, *nr;
 
-	BUG_ON(!nft_is_base_chain(ctx->chain));
+	if (WARN_ON(!nft_is_base_chain(ctx->chain)))
+		return 0;
 
 	nf_tables_unregister_hook(ctx->net, ctx->chain->table, ctx->chain);
 	list_for_each_entry_safe(rule, nr, &ctx->chain->rules, list) {
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index fa90a8402845d..79d48c1d06f4d 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -79,7 +79,8 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	err = nft_data_init(NULL, &priv->data, sizeof(priv->data), &desc,
 			    tb[NFTA_CMP_DATA]);
-	BUG_ON(err < 0);
+	if (err < 0)
+		return err;
 
 	priv->sreg = nft_parse_register(tb[NFTA_CMP_SREG]);
 	err = nft_validate_register_load(priv->sreg, desc.len);
@@ -129,7 +130,8 @@ static int nft_cmp_fast_init(const struct nft_ctx *ctx,
 
 	err = nft_data_init(NULL, &data, sizeof(data), &desc,
 			    tb[NFTA_CMP_DATA]);
-	BUG_ON(err < 0);
+	if (err < 0)
+		return err;
 
 	priv->sreg = nft_parse_register(tb[NFTA_CMP_SREG]);
 	err = nft_validate_register_load(priv->sreg, desc.len);
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index 29f5bd2377b0d..b48e58cceeb72 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -94,7 +94,8 @@ static u8 icmp_code_v4[NFT_REJECT_ICMPX_MAX + 1] = {
 
 int nft_reject_icmp_code(u8 code)
 {
-	BUG_ON(code > NFT_REJECT_ICMPX_MAX);
+	if (WARN_ON_ONCE(code > NFT_REJECT_ICMPX_MAX))
+		return ICMP_NET_UNREACH;
 
 	return icmp_code_v4[code];
 }
@@ -111,7 +112,8 @@ static u8 icmp_code_v6[NFT_REJECT_ICMPX_MAX + 1] = {
 
 int nft_reject_icmpv6_code(u8 code)
 {
-	BUG_ON(code > NFT_REJECT_ICMPX_MAX);
+	if (WARN_ON_ONCE(code > NFT_REJECT_ICMPX_MAX))
+		return ICMPV6_NOROUTE;
 
 	return icmp_code_v6[code];
 }
-- 
2.20.1

