Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 690BEC77B7C
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 May 2023 12:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjEKMTj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 May 2023 08:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236865AbjEKMTi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 May 2023 08:19:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BF91B4
        for <netfilter-devel@vger.kernel.org>; Thu, 11 May 2023 05:19:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1px5Gg-0008RE-N4; Thu, 11 May 2023 14:19:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_tables: fix nft_trans type confusion
Date:   Thu, 11 May 2023 14:19:28 +0200
Message-Id: <20230511121928.10189-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_trans_FOO objects all share a common nft_trans structure, but
trailing fields might not ahve been allocated.

This means nft_trans can be treated as nft_trans_FOO only after
checking trans->msg_type.

The existing code isn't correct because it treats the object
as rule type before the check.

Found by code inspection.

Fixes: 1a94e38d254b ("netfilter: nf_tables: add NFTA_RULE_ID attribute")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 59fb8320ab4d..dc5675962de4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3865,12 +3865,10 @@ static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 	struct nft_trans *trans;
 
 	list_for_each_entry(trans, &nft_net->commit_list, list) {
-		struct nft_rule *rule = nft_trans_rule(trans);
-
 		if (trans->msg_type == NFT_MSG_NEWRULE &&
 		    trans->ctx.chain == chain &&
 		    id == nft_trans_rule_id(trans))
-			return rule;
+			return nft_trans_rule(trans);
 	}
 	return ERR_PTR(-ENOENT);
 }
-- 
2.39.3

