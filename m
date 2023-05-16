Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21D0C7EE2D
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 May 2023 15:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbjEPPGu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 May 2023 11:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbjEPPGs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2023 11:06:48 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 778CC5B91;
        Tue, 16 May 2023 08:06:43 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,4.19 8/9] netfilter: nf_tables: validate NFTA_SET_ELEM_OBJREF based on NFT_SET_OBJECT flag
Date:   Tue, 16 May 2023 17:06:12 +0200
Message-Id: <20230516150613.4566-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230516150613.4566-1-pablo@netfilter.org>
References: <20230516150613.4566-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[ 5a2f3dc31811e93be15522d9eb13ed61460b76c8 ]

If the NFTA_SET_ELEM_OBJREF netlink attribute is present and
NFT_SET_OBJECT flag is set on, report EINVAL.

Move existing sanity check earlier to validate that NFT_SET_OBJECT
requires NFTA_SET_ELEM_OBJREF.

Fixes: 8aeff920dcc9 ("netfilter: nf_tables: add stateful object reference to set elements")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 875ebdd8ddc8..9fe1c2e192e2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4428,6 +4428,15 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return -EINVAL;
 	}
 
+	if (set->flags & NFT_SET_OBJECT) {
+		if (!nla[NFTA_SET_ELEM_OBJREF] &&
+		    !(flags & NFT_SET_ELEM_INTERVAL_END))
+			return -EINVAL;
+	} else {
+		if (nla[NFTA_SET_ELEM_OBJREF])
+			return -EINVAL;
+	}
+
 	if ((flags & NFT_SET_ELEM_INTERVAL_END) &&
 	     (nla[NFTA_SET_ELEM_DATA] ||
 	      nla[NFTA_SET_ELEM_OBJREF] ||
@@ -4462,10 +4471,6 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	if (nla[NFTA_SET_ELEM_OBJREF] != NULL) {
-		if (!(set->flags & NFT_SET_OBJECT)) {
-			err = -EINVAL;
-			goto err2;
-		}
 		obj = nft_obj_lookup(ctx->table, nla[NFTA_SET_ELEM_OBJREF],
 				     set->objtype, genmask);
 		if (IS_ERR(obj)) {
-- 
2.30.2

