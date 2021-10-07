Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9332C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 19:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A58DB60F6E
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 19:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbhJGTyv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Oct 2021 15:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhJGTyu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Oct 2021 15:54:50 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2654FC061570
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Oct 2021 12:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vyiBAZx0LqboQfLrr1ogeV3r0sLEg2qo484pslpthnw=; b=NqiCCo/5H2EYkD4DLZi8USuVOW
        j9KQjV8LqJhvOZYcyGHXDzC8qS2AOJkBsbr8RsLHa9B/8DhOZdTmzQEBYN7aFGjW/7fAcdh5htuk8
        WyQ3f4PMtao7bA4ukMjjLK/GhayQAhb/aHTSBem75cWTRVJIdHtKY/JL+ULMSh2lf5uLPr7e/ekvH
        pWg2HfddAuUofqw2qo0tdSl/LhNdT1z95k2zQVUI5wR5hDh7LJoVhfk56CLRb2sQgQ1L9wbDm38i/
        KmUJYYHtePtyMStrZKbqF54YL2yQCbZv6gKf7vgwVShB8K4/jrbZTkxe7i/Il1B8aM9qj7TpWipbk
        PmTegcIQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mYZRj-009WeN-Av
        for netfilter-devel@vger.kernel.org; Thu, 07 Oct 2021 20:52:51 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH v2 2/3] rule: fix stateless output after listing sets containing counters.
Date:   Thu,  7 Oct 2021 20:49:01 +0100
Message-Id: <20211007194902.2613579-3-jeremy@azazel.net>
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

