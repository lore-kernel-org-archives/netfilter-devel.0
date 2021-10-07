Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD30C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 20:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64F1661152
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 20:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhJGUSI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbhJGUSH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Oct 2021 16:18:07 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB9AC061762
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Oct 2021 13:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NOYI16mwpUDe2BEb6dPA5s3hUXvmdyzi8a3frNA+2qA=; b=dGlC6Pq25BTzV0WyNo6p2q6OOw
        3W54ylUnaCI1HByi1eS7rF34AZ1HZYcTjoriFcKcz+G3URtnL1e3HnB+hpzxKhXH6EIegX4x8rAcl
        3Ogj0E6UHCedg5Rqje3maAGil02EGhbkuTNYmYf8TiTR/ciXss35juyJL7hBExyOthroa/8rEHnAA
        pE8RdnS9HczmAMxhowTXeJ40Oztq3jBS8cDsaY/HEqo1b4MTF5a9m05jvyLjWgXpY88XnUybwm1fx
        I5Wh6IUTbwOOQ1y/ax3hlThFv4q5OcDNvl9UfqX3HTV+FGH4Rbtcy2iIeDmPsKsrlFC0SanE/x4hu
        btfJCuvg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mYZoJ-009Xrv-Cp
        for netfilter-devel@vger.kernel.org; Thu, 07 Oct 2021 21:16:11 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH v3 3/3] rule: replace three conditionals with one
Date:   Thu,  7 Oct 2021 21:12:22 +0100
Message-Id: <20211007201222.2613750-4-jeremy@azazel.net>
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

When outputting set definitions, merge three consecutive
`if (!list_empty(&set->stmt_list))` conditionals.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/rule.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index b566adf07b1f..7c048fcc1eee 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -366,12 +366,11 @@ static void set_print_declaration(const struct set *set,
 		nft_print(octx, "%s", opts->stmt_separator);
 	}
 
-	if (!list_empty(&set->stmt_list))
-		nft_print(octx, "%s%s", opts->tab, opts->tab);
-
 	if (!list_empty(&set->stmt_list)) {
 		unsigned int flags = octx->flags;
 
+		nft_print(octx, "%s%s", opts->tab, opts->tab);
+
 		octx->flags |= NFT_CTX_OUTPUT_STATELESS;
 		list_for_each_entry(stmt, &set->stmt_list, list) {
 			stmt_print(stmt, octx);
@@ -379,10 +378,9 @@ static void set_print_declaration(const struct set *set,
 				nft_print(octx, " ");
 		}
 		octx->flags = flags;
-	}
 
-	if (!list_empty(&set->stmt_list))
 		nft_print(octx, "%s", opts->stmt_separator);
+	}
 
 	if (set->automerge)
 		nft_print(octx, "%s%sauto-merge%s", opts->tab, opts->tab,
-- 
2.33.0

