Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B63C8300C
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Jun 2023 13:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjFLNOU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Jun 2023 09:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbjFLNOR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jun 2023 09:14:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8DB43B8
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jun 2023 06:14:15 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 2/7] netfilter: nf_tables: disallow element updates of bound anonymous sets
Date:   Mon, 12 Jun 2023 15:14:04 +0200
Message-Id: <20230612131409.63157-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230612131409.63157-1-pablo@netfilter.org>
References: <20230612131409.63157-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Anonymous sets come with NFT_SET_CONSTANT from userspace. Although API
allows to create anonymous sets without NFT_SET_CONSTANT, it makes no
sense to allow to add and to delete elements for bound anonymous sets.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 net/netfilter/nf_tables_api.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 467c2a20e16d..f008fdbe83e1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6644,7 +6644,8 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
-	if (!list_empty(&set->bindings) && set->flags & NFT_SET_CONSTANT)
+	if (!list_empty(&set->bindings) &&
+	    (set->flags & (NFT_SET_CONSTANT | NFT_SET_ANONYMOUS)))
 		return -EBUSY;
 
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
@@ -6918,7 +6919,9 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 	set = nft_set_lookup(table, nla[NFTA_SET_ELEM_LIST_SET], genmask);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
-	if (!list_empty(&set->bindings) && set->flags & NFT_SET_CONSTANT)
+
+	if (!list_empty(&set->bindings) &&
+	    (set->flags & (NFT_SET_CONSTANT | NFT_SET_ANONYMOUS)))
 		return -EBUSY;
 
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
-- 
2.30.2

