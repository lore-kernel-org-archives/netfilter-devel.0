Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C67BC4708E
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 May 2021 16:51:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 015BB610CC
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 May 2021 16:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhE2Qwr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 May 2021 12:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbhE2Qwq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 May 2021 12:52:46 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFD5C061574
        for <netfilter-devel@vger.kernel.org>; Sat, 29 May 2021 09:51:10 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ln2B2-0000n7-OI; Sat, 29 May 2021 18:51:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nft_set_pipapo_avx2: fix up description warnings
Date:   Sat, 29 May 2021 18:50:45 +0200
Message-Id: <20210529165045.146575-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

W=1:
net/netfilter/nft_set_pipapo_avx2.c:159: warning: Excess function parameter 'len' description in 'nft_pipapo_avx2_refill'
net/netfilter/nft_set_pipapo_avx2.c:1124: warning: Function parameter or member 'key' not described in 'nft_pipapo_avx2_lookup'
net/netfilter/nft_set_pipapo_avx2.c:1124: warning: Excess function parameter 'elem' description in 'nft_pipapo_avx2_lookup'

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo_avx2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 1c2620923a61..e517663e0cd1 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -142,7 +142,6 @@ static void nft_pipapo_avx2_fill(unsigned long *data, int start, int len)
  * @map:	Bitmap to be scanned for set bits
  * @dst:	Destination bitmap
  * @mt:		Mapping table containing bit set specifiers
- * @len:	Length of bitmap in longs
  * @last:	Return index of first set bit, if this is the last field
  *
  * This is an alternative implementation of pipapo_refill() suitable for usage
@@ -1109,7 +1108,7 @@ bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 features,
  * nft_pipapo_avx2_lookup() - Lookup function for AVX2 implementation
  * @net:	Network namespace
  * @set:	nftables API set representation
- * @elem:	nftables API element representation containing key data
+ * @key:	nftables API element representation containing key data
  * @ext:	nftables API extension pointer, filled with matching reference
  *
  * For more details, see DOC: Theory of Operation in nft_set_pipapo.c.
-- 
2.31.1

