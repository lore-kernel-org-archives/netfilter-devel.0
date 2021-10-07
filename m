Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BACEC433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 19:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 264DC60F6E
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 19:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhJGTyw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Oct 2021 15:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbhJGTyv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Oct 2021 15:54:51 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA34C061755
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Oct 2021 12:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Fb0JAiO7iteLxC5ARg3lmaojPvqRReZFJ4OnyHJ1qjU=; b=Za9n0jXizcqNVdFPa5ro9wxwrA
        YgmneixHkBgIpguuH7XaxKyy/ZCGyx/8qbJkaCrJJA7+7KR1c83F4+xlwr/bOuZ7x0p6dOYtR44ll
        oSQzwVicVK2QZYjs9dcyrYiugVGlR2wh18OiyiA/3xeLMHbaLzEO9YDs/YCC7cPXNcxoPWiNFdBor
        hvkbs0s12vQQnkBrjyin9+vx17V3u308sQ/t0FYgChZGnWZnAyP07BrzIa0ZP6qp4xs6aXEUIGLVx
        UAibaZo4Og0feIEIUMHm/+dRf6DNC77wQoNunxj/O702+QCc2Ce+OaZ0Lu5Tb2xmo1auf3MbVClew
        Xw6MKILw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mYZRj-009WeN-3I
        for netfilter-devel@vger.kernel.org; Thu, 07 Oct 2021 20:52:51 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH v2 1/3] rule: remove fake stateless output of named counters
Date:   Thu,  7 Oct 2021 20:49:00 +0100
Message-Id: <20211007194902.2613579-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007194902.2613579-1-jeremy@azazel.net>
References: <20211007194902.2613579-1-jeremy@azazel.net>
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

