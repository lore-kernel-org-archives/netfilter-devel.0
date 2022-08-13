Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F500C19F2D
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Aug 2022 14:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239501AbiHMOZS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Aug 2022 10:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239464AbiHMOZR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Aug 2022 10:25:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 62383BCA
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Aug 2022 07:25:15 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 2/2] netfilter: nf_tables: NFTA_SET_ELEM_KEY_END requires concat and interval flags
Date:   Sat, 13 Aug 2022 16:25:08 +0200
Message-Id: <20220813142508.503421-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the NFT_SET_CONCAT flag is set on, then the netlink attribute
NFTA_SET_ELEM_KEY_END must be specified. Otherwise, NFTA_SET_ELEM_KEY_END
should not be present.

There are two special cases where NFTA_SET_ELEM_KEY_END is optional,
either if this is a closing interval element or this is a catch-all
element.

Fixes: 7b225d0b5c6d ("netfilter: nf_tables: add NFTA_SET_ELEM_KEY_END attribute")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: restrict to (NFT_SET_CONCAT | NFT_SET_INTERVAL)

 net/netfilter/nf_tables_api.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bcfe8120e014..29fe6fd41799 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5903,6 +5903,16 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return -EINVAL;
 	}
 
+	if ((set->flags & (NFT_SET_CONCAT | NFT_SET_INTERVAL)) ==
+			  (NFT_SET_CONCAT | NFT_SET_INTERVAL)) {
+		if (!nla[NFTA_SET_ELEM_KEY_END] &&
+		    !(flags & (NFT_SET_ELEM_INTERVAL_END | NFT_SET_ELEM_CATCHALL)))
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

