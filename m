Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B46C32771
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Sep 2022 17:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbiI1RS6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 13:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234565AbiI1RSy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 13:18:54 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD83764FA
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Sep 2022 10:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NNt2uAL/I9LGRauZkiLEyrxRmfrIbFDuImdj21QZTNo=; b=aaGpDSVelHasrez341reI2Y4zy
        9tMQPatvORSUTX8Y+dXmRdyHtZRSQ05gNJj89vLHFtyU0Anoo7xKlRlYxFLxLDzd2waLcdgHFU/xM
        2o97AVvyRN+cWQDEwPuf1c2nLFoGHHcNgMVaNd1pAxcFIG+hnYYMSZ829gEUCtu/c+izEVcvCt9Fu
        TVtfaDYoV2Ldg5K7UVwf61bIdBd1WiO8wYxHy2WR+ZMR54ciKdtwZComxmRGXqCO732MnHxvKMHQx
        d2TicX48djs9puf2338mLqJ8RGTzyomXMon7PRZQpHSzyST4BgvUxzAvF96sG5sanj1pXrOGhuZOh
        9TlQiAoQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1odahs-0002Bs-Ab; Wed, 28 Sep 2022 19:18:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fwestpha@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft-bridge: Drop 'sreg_count' variable
Date:   Wed, 28 Sep 2022 19:18:39 +0200
Message-Id: <20220928171839.23522-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It is not needed, one can just use 'reg' function parameter in its
place.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-bridge.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 596dfdf8991f1..d1385cc3593b9 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -324,7 +324,6 @@ static int lookup_analyze_payloads(struct nft_xt_ctx *ctx,
 				   bool *dst, bool *ip)
 {
 	const struct nft_xt_ctx_reg *reg;
-	uint32_t sreg_count;
 	int val, val2 = -1;
 
 	reg = nft_xt_ctx_get_sreg(ctx, sreg);
@@ -336,7 +335,6 @@ static int lookup_analyze_payloads(struct nft_xt_ctx *ctx,
 		return -1;
 	}
 
-	sreg_count = sreg;
 	switch (key_len) {
 	case 12: /* ether + ipv4addr */
 		val = lookup_check_ether_payload(reg->payload.base,
@@ -349,9 +347,9 @@ static int lookup_analyze_payloads(struct nft_xt_ctx *ctx,
 			return -1;
 		}
 
-		sreg_count = nft_get_next_reg(sreg_count, ETH_ALEN);
+		sreg = nft_get_next_reg(sreg, ETH_ALEN);
 
-		reg = nft_xt_ctx_get_sreg(ctx, sreg_count);
+		reg = nft_xt_ctx_get_sreg(ctx, sreg);
 		if (!reg) {
 			ctx->errmsg = "next lookup register is invalid";
 			return -1;
-- 
2.34.1

