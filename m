Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91849C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Jul 2022 08:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbiGHIo7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Jul 2022 04:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237239AbiGHIo7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Jul 2022 04:44:59 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D1F4814B6
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Jul 2022 01:44:58 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: release key if get element fails
Date:   Fri,  8 Jul 2022 10:44:53 +0200
Message-Id: <20220708084453.11066-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Call nft_data_release() to release the element keys otherwise this
might leak chain reference counter.

Fixes: ba0e4d9917b4 ("netfilter: nf_tables: get set elements via netlink")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 25713e763689..04dc6a349759 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5306,17 +5306,17 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		err = nft_setelem_parse_key(ctx, set, &elem.key_end.val,
 					    nla[NFTA_SET_ELEM_KEY_END]);
 		if (err < 0)
-			return err;
+			goto err_parse_key;
 	}
 
 	err = nft_setelem_get(ctx, set, &elem, flags);
 	if (err < 0)
-		return err;
+		goto err_parse_key_end;
 
 	err = -ENOMEM;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (skb == NULL)
-		return err;
+		goto err_parse_key_end;
 
 	err = nf_tables_fill_setelem_info(skb, ctx, ctx->seq, ctx->portid,
 					  NFT_MSG_NEWSETELEM, 0, set, &elem);
@@ -5327,6 +5327,11 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 err_fill_setelem:
 	kfree_skb(skb);
+err_parse_key:
+	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
+err_parse_key_end:
+	nft_data_release(&elem.key_end.val, NFT_DATA_VALUE);
+
 	return err;
 }
 
-- 
2.30.2

