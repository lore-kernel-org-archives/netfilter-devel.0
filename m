Return-Path: <SRS0=Ke5S=BM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FC9C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Aug 2020 01:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 590482076A
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Aug 2020 01:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgHBB1N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Aug 2020 21:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgHBB1M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Aug 2020 21:27:12 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4221C06174A
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Aug 2020 18:27:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k22mN-0000Pp-5S; Sun, 02 Aug 2020 03:27:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        "Demi M . Obenour" <demiobenour@gmail.com>
Subject: [PATCH nf] netfilter: nft_meta: fix iifgroup matching
Date:   Sun,  2 Aug 2020 03:27:03 +0200
Message-Id: <20200802012703.15135-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

iifgroup matching errounously checks the output interface.

Fixes: 8724e819cc9a ("netfilter: nft_meta: move all interface related keys to helper")
Reported-by: Demi M. Obenour <demiobenour@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_meta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 951b6e87ed5d..7bc6537f3ccb 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -253,7 +253,7 @@ static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
 			return false;
 		break;
 	case NFT_META_IIFGROUP:
-		if (!nft_meta_store_ifgroup(dest, nft_out(pkt)))
+		if (!nft_meta_store_ifgroup(dest, nft_in(pkt)))
 			return false;
 		break;
 	case NFT_META_OIFGROUP:
-- 
2.26.2

