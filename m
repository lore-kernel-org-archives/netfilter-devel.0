Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45485C2BB3F
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Nov 2023 16:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjKTQCD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Nov 2023 11:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbjKTQCD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Nov 2023 11:02:03 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08333A7
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2023 08:01:55 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1r56if-00076j-QA; Mon, 20 Nov 2023 17:01:53 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nft_set_pipapo: prefer gfp_kernel allocation
Date:   Mon, 20 Nov 2023 17:01:45 +0100
Message-ID: <20231120160148.1510-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to use GFP_ATOMIC here.

Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 701977af3ee8..197dd6911f8a 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1597,7 +1597,7 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 		if (nft_set_elem_expired(&e->ext)) {
 			priv->dirty = true;
 
-			gc = nft_trans_gc_queue_sync(gc, GFP_ATOMIC);
+			gc = nft_trans_gc_queue_sync(gc, GFP_KERNEL);
 			if (!gc)
 				return;
 
-- 
2.41.0

