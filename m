Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66630C4708F
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Jun 2021 22:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 512B161396
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Jun 2021 22:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbhFAWIc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Jun 2021 18:08:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39566 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbhFAWIX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Jun 2021 18:08:23 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 555C464175;
        Wed,  2 Jun 2021 00:05:34 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 15/16] netfilter: nft_set_pipapo_avx2: fix up description warnings
Date:   Wed,  2 Jun 2021 00:06:28 +0200
Message-Id: <20210601220629.18307-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

W=1:
net/netfilter/nft_set_pipapo_avx2.c:159: warning: Excess function parameter 'len' description in 'nft_pipapo_avx2_refill'
net/netfilter/nft_set_pipapo_avx2.c:1124: warning: Function parameter or member 'key' not described in 'nft_pipapo_avx2_lookup'
net/netfilter/nft_set_pipapo_avx2.c:1124: warning: Excess function parameter 'elem' description in 'nft_pipapo_avx2_lookup'

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

