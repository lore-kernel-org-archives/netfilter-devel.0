Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A24C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Oct 2021 19:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D22D61B3C
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Oct 2021 19:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhJBTzg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Oct 2021 15:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhJBTzf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Oct 2021 15:55:35 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A770BC061714
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Oct 2021 12:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Fb0JAiO7iteLxC5ARg3lmaojPvqRReZFJ4OnyHJ1qjU=; b=pdr29aw8Mnw9gjCsu2eybp5UqE
        vfsjrypZuMIIMMSUYV3YMFKcjwdfIwqoMzikE6+Yrhj7wv30JfYfrXb9JqeuiOwJc0qj/0Kt+govI
        qk1j8hqWIym3SHn3ilCCjmlXKRyJqu2PGeYNy7K+DX4GDD2nGJw1X2Nt42gnGHJo8CJGlGCwjJ2Me
        K+uohlaluDd1zrxjMwfO5ac62L+Dc5JbAWr+xD77EN9Prei0M4YfqdpnKIE4vDJnCb0D1wYUVVp4N
        mOM7ye4c2BqG794K19UMx/VFP/2LVNQ2t1pSOvwiQ7FOqsnydVXiGaPA6hvz1lHgadbM6bbUtaRpe
        pFoM+/LA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mWl4t-003eRY-UL
        for netfilter-devel@vger.kernel.org; Sat, 02 Oct 2021 20:53:47 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH] rule: remove fake stateless output of named counters
Date:   Sat,  2 Oct 2021 20:49:58 +0100
Message-Id: <20211002194958.1603504-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When `-s` is passed, no state is output for named quotas and counter and
quota rules, but fake zero state is output for named counters.  Remove
the output of named counters to match the remaining stateful objects.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/rule.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 6091067f608b..50e16cf9e028 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1811,13 +1811,12 @@ static void obj_print_data(const struct obj *obj,
 			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
 
 		obj_print_comment(obj, opts, octx);
-		nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
-		if (nft_output_stateless(octx)) {
-			nft_print(octx, "packets 0 bytes 0");
-			break;
-		}
-		nft_print(octx, "packets %" PRIu64 " bytes %" PRIu64 "%s",
-			  obj->counter.packets, obj->counter.bytes, opts->nl);
+		if (nft_output_stateless(octx))
+			nft_print(octx, "%s", opts->nl);
+		else
+			nft_print(octx, "%s%s%spackets %" PRIu64 " bytes %" PRIu64 "%s",
+				  opts->nl, opts->tab, opts->tab,
+				  obj->counter.packets, obj->counter.bytes, opts->nl);
 		break;
 	case NFT_OBJECT_QUOTA: {
 		const char *data_unit;
-- 
2.33.0

