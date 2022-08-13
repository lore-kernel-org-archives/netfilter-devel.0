Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C581C19F2D
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Aug 2022 14:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239672AbiHMOhK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Aug 2022 10:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239673AbiHMOhJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Aug 2022 10:37:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99ACF32BBB
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Aug 2022 07:37:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3 2/2] netfilter: nf_tables: NFTA_SET_ELEM_KEY_END requires concat and interval flags
Date:   Sat, 13 Aug 2022 16:37:01 +0200
Message-Id: <20220813143701.584379-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the NFT_SET_CONCAT|NFT_SET_INTERVAL flags are set on, then the
netlink attribute NFTA_SET_ELEM_KEY_END must be specified. Otherwise,
NFTA_SET_ELEM_KEY_END should not be present.

For catch-all element, NFTA_SET_ELEM_KEY_END should not be present.
The NFT_SET_ELEM_INTERVAL_END is never used with this set flags
combination.

Fixes: 7b225d0b5c6d ("netfilter: nf_tables: add NFTA_SET_ELEM_KEY_END attribute")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: NFT_SET_ELEM_INTERVAL_END is invalid with concat and interval flags.

 net/netfilter/nf_tables_api.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bcfe8120e014..d45cd6008467 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5903,6 +5903,18 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return -EINVAL;
 	}
 
+	if ((set->flags & (NFT_SET_CONCAT | NFT_SET_INTERVAL)) ==
+			  (NFT_SET_CONCAT | NFT_SET_INTERVAL)) {
+		if (flags & NFT_SET_ELEM_INTERVAL_END)
+			return -EINVAL;
+		if (!nla[NFTA_SET_ELEM_KEY_END] &&
+		    !(flags & NFT_SET_ELEM_CATCHALL))
+			return -EINVAL;
+	} else {
+		if (nla[NFTA_SET_ELEM_KEY_END])
+			return -EINVAL;
+	}
+
 	if ((flags & NFT_SET_ELEM_INTERVAL_END) &&
 	     (nla[NFTA_SET_ELEM_DATA] ||
 	      nla[NFTA_SET_ELEM_OBJREF] ||
-- 
2.30.2

