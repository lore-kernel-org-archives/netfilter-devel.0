Return-Path: <SRS0=U5wk=2I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B64BC43603
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 11:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BF5E21D7D
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 11:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfLRLF7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Dec 2019 06:05:59 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:35998 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726591AbfLRLF7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 06:05:59 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ihX9R-00078Y-Jh; Wed, 18 Dec 2019 12:05:57 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 7/9] netfilter: nft_meta: place prandom handling in a helper
Date:   Wed, 18 Dec 2019 12:05:19 +0100
Message-Id: <20191218110521.14048-8-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218110521.14048-1-fw@strlen.de>
References: <20191218110521.14048-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move this out of the main eval loop, the numgen expression
provides a better alternative to meta random.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_meta.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 022f1473ddd1..ac6fc95387dc 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -266,6 +266,13 @@ static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
 	return true;
 }
 
+static noinline u32 nft_prandom_u32(void)
+{
+	struct rnd_state *state = this_cpu_ptr(&nft_prandom_state);
+
+	return prandom_u32_state(state);
+}
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -344,11 +351,9 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			goto err;
 		break;
 #endif
-	case NFT_META_PRANDOM: {
-		struct rnd_state *state = this_cpu_ptr(&nft_prandom_state);
-		*dest = prandom_u32_state(state);
+	case NFT_META_PRANDOM:
+		*dest = nft_prandom_u32();
 		break;
-	}
 #ifdef CONFIG_XFRM
 	case NFT_META_SECPATH:
 		nft_reg_store8(dest, secpath_exists(skb));
-- 
2.24.1

