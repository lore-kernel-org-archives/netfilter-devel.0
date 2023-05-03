Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3134C77B78
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 May 2023 20:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjECUNO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 May 2023 16:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjECUNN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2023 16:13:13 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B4EE8A62;
        Wed,  3 May 2023 13:12:32 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 1/1] netfilter: nf_tables: fix ct untracked match breakage
Date:   Wed,  3 May 2023 22:11:43 +0200
Message-Id: <20230503201143.12310-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230503201143.12310-1-pablo@netfilter.org>
References: <20230503201143.12310-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

"ct untracked" no longer works properly due to erroneous NFT_BREAK.
We have to check ctinfo enum first.

Fixes: d9e789147605 ("netfilter: nf_tables: avoid retpoline overhead for some ct expression calls")
Reported-by: Rvfg <i@rvf6.com>
Link: https://marc.info/?l=netfilter&m=168294996212038&w=2
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct_fast.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_ct_fast.c b/net/netfilter/nft_ct_fast.c
index 89983b0613fa..e684c8a91848 100644
--- a/net/netfilter/nft_ct_fast.c
+++ b/net/netfilter/nft_ct_fast.c
@@ -15,10 +15,6 @@ void nft_ct_get_fast_eval(const struct nft_expr *expr,
 	unsigned int state;
 
 	ct = nf_ct_get(pkt->skb, &ctinfo);
-	if (!ct) {
-		regs->verdict.code = NFT_BREAK;
-		return;
-	}
 
 	switch (priv->key) {
 	case NFT_CT_STATE:
@@ -30,6 +26,16 @@ void nft_ct_get_fast_eval(const struct nft_expr *expr,
 			state = NF_CT_STATE_INVALID_BIT;
 		*dest = state;
 		return;
+	default:
+		break;
+	}
+
+	if (!ct) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
+	switch (priv->key) {
 	case NFT_CT_DIRECTION:
 		nft_reg_store8(dest, CTINFO2DIR(ctinfo));
 		return;
-- 
2.30.2

