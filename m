Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E49AC433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 00:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241345AbhLIAMd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 19:12:33 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41748 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241335AbhLIAMc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 19:12:32 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2F275605BA;
        Thu,  9 Dec 2021 01:06:35 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/7] nft_set_pipapo: Fix bucket load in AVX2 lookup routine for six 8-bit groups
Date:   Thu,  9 Dec 2021 01:08:43 +0100
Message-Id: <20211209000847.102598-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211209000847.102598-1-pablo@netfilter.org>
References: <20211209000847.102598-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

The sixth byte of packet data has to be looked up in the sixth group,
not in the seventh one, even if we load the bucket data into ymm6
(and not ymm5, for convenience of tracking stalls).

Without this fix, matching on a MAC address as first field of a set,
if 8-bit groups are selected (due to a small set size) would fail,
that is, the given MAC address would never match.

Reported-by: Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
Cc: <stable@vger.kernel.org> # 5.6.x
Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Tested-By: Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo_avx2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index e517663e0cd1..6f4116e72958 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -886,7 +886,7 @@ static int nft_pipapo_avx2_lookup_8b_6(unsigned long *map, unsigned long *fill,
 			NFT_PIPAPO_AVX2_BUCKET_LOAD8(4,  lt, 4, pkt[4], bsize);
 
 			NFT_PIPAPO_AVX2_AND(5, 0, 1);
-			NFT_PIPAPO_AVX2_BUCKET_LOAD8(6,  lt, 6, pkt[5], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(6,  lt, 5, pkt[5], bsize);
 			NFT_PIPAPO_AVX2_AND(7, 2, 3);
 
 			/* Stall */
-- 
2.30.2

