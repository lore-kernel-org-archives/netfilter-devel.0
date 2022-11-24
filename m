Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77967C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Nov 2022 12:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiKXMJk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 07:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKXMJk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 07:09:40 -0500
X-Greylist: delayed 278 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Nov 2022 04:09:34 PST
Received: from passt.top (passt.top [88.198.0.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE453623B5
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2022 04:09:34 -0800 (PST)
Received: by passt.top (Postfix, from userid 1000)
        id 2655E5A0268; Thu, 24 Nov 2022 13:04:37 +0100 (CET)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] nft_set_pipapo: Actually validate intervals in fields after the first one
Date:   Thu, 24 Nov 2022 13:04:37 +0100
Message-Id: <20221124120437.244114-1-sbrivio@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Embarrassingly, nft_pipapo_insert() checked for interval validity in
the first field only.

The start_p and end_p pointers were reset to key data from the first
field at every iteration of the loop which was supposed to go over
the set fields.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_pipapo.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 4f9299b9dcdd..06d46d182634 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1162,6 +1162,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	struct nft_pipapo_match *m = priv->clone;
 	u8 genmask = nft_genmask_next(net);
 	struct nft_pipapo_field *f;
+	const u8 *start_p, *end_p;
 	int i, bsize_max, err = 0;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
@@ -1202,9 +1203,9 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	}
 
 	/* Validate */
+	start_p = start;
+	end_p = end;
 	nft_pipapo_for_each_field(f, i, m) {
-		const u8 *start_p = start, *end_p = end;
-
 		if (f->rules >= (unsigned long)NFT_PIPAPO_RULE0_MAX)
 			return -ENOSPC;
 
-- 
2.35.1

