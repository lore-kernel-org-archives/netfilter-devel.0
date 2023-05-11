Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF11C7EE25
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 May 2023 20:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239206AbjEKUqL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 May 2023 16:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238452AbjEKUpm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 May 2023 16:45:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB4B1701
        for <netfilter-devel@vger.kernel.org>; Thu, 11 May 2023 13:45:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pxDAS-0003u1-7v; Thu, 11 May 2023 22:45:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_tables: always increment set element count
Date:   Thu, 11 May 2023 22:45:35 +0200
Message-Id: <20230511204535.6278-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

At this time, set->nelems counter only increments when the set has
a maximum size.

All set elements decrement the counter unconditionally, this is
confusing.

Increment the counter unconditionally to make this symmetrical.
This would also allow changing the set maximum size after set creation
in a later patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dc5675962de4..0396fd8f4e71 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6539,10 +6539,13 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (!(flags & NFT_SET_ELEM_CATCHALL) && set->size &&
-	    !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact)) {
-		err = -ENFILE;
-		goto err_set_full;
+	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
+		unsigned int max = set->size ? set->size + set->ndeact : UINT_MAX;
+
+		if (!atomic_add_unless(&set->nelems, 1, max)) {
+			err = -ENFILE;
+			goto err_set_full;
+		}
 	}
 
 	nft_trans_elem(trans) = elem;
-- 
2.39.3

