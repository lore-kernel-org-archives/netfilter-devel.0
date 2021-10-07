Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 480D8C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 20:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2834061139
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 20:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhJGUSI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbhJGUSH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Oct 2021 16:18:07 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE654C061760
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Oct 2021 13:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vyiBAZx0LqboQfLrr1ogeV3r0sLEg2qo484pslpthnw=; b=FqTYDSb3udCtddfSeKpqDY8hiu
        Ixt03Pel7EXSd6VvSRQ6pZ3EjX+mvkbAEXLsp9VVc0MmrZub+dfuKo2HDwZDFC0f7m6gpkyd3y989
        GMEYqfl+/gJDnukKk0H088o/BxzUSWJzoWEVltHgxU/OALhuyemp234LAkPk2545zBCLbMEbJdi9K
        gzzLM2cf2IjRiMPfQBiO4WXn6s66Ib/0rbZiG0IhoriR3taEwnuepb0GG4VwQN9BqG6Aapy2iWAqX
        Wl5ZHnsQ+t37w28bv3DBw3AP7/oeggwy35BJQYMJvX6aPJUeKuImED6hG6IOLwfzQog0uXmNKfk1b
        sjNXmc2A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mYZoJ-009Xrv-8B
        for netfilter-devel@vger.kernel.org; Thu, 07 Oct 2021 21:16:11 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH v3 2/3] rule: fix stateless output after listing sets containing counters
Date:   Thu,  7 Oct 2021 21:12:21 +0100
Message-Id: <20211007201222.2613750-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007201222.2613750-1-jeremy@azazel.net>
References: <20211007201222.2613750-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Before outputting counters in set definitions the
`NFT_CTX_OUTPUT_STATELESS` flag was set to suppress output of the
counter state and unconditionally cleared afterwards, regardless of
whether it had been originally set.  Record the original set of flags
and restore it.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=994273
Fixes: 6d80e0f15492 ("src: support for counter in set definition")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/rule.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 50e16cf9e028..b566adf07b1f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -370,13 +370,15 @@ static void set_print_declaration(const struct set *set,
 		nft_print(octx, "%s%s", opts->tab, opts->tab);
 
 	if (!list_empty(&set->stmt_list)) {
+		unsigned int flags = octx->flags;
+
 		octx->flags |= NFT_CTX_OUTPUT_STATELESS;
 		list_for_each_entry(stmt, &set->stmt_list, list) {
 			stmt_print(stmt, octx);
 			if (!list_is_last(&stmt->list, &set->stmt_list))
 				nft_print(octx, " ");
 		}
-		octx->flags &= ~NFT_CTX_OUTPUT_STATELESS;
+		octx->flags = flags;
 	}
 
 	if (!list_empty(&set->stmt_list))
-- 
2.33.0

