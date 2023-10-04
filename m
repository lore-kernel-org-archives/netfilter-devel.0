Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C71E7B5EE
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Oct 2023 11:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242231AbjJDLNL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Oct 2023 07:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242227AbjJDLNK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2023 07:13:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60141EA
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2023 04:13:05 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf] netfilter: nf_tables: do not remove elements if set backend implements .abort
Date:   Wed,  4 Oct 2023 13:12:58 +0200
Message-Id: <20231004111258.6732-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

pipapo set backend maintains two copies of the datastructure, removing
the elements from the copy that is going to be discarded slows down
the abort path significantly, from several minutes to few seconds after
this patch.

Fixes: 212ed75dc5fb ("netfilter: nf_tables: integrate pipapo into commit protocol")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
no crash, but very slow nft --check when adding a lot of elements in a batch.
Feel free to route to nf-next if you prefer slow path.

 net/netfilter/nf_tables_api.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4356189360fb..3bb5ea5d4eed 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10335,7 +10335,10 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				break;
 			}
 			te = (struct nft_trans_elem *)trans->data;
-			nft_setelem_remove(net, te->set, &te->elem);
+			if (!te->set->ops->abort ||
+			    nft_setelem_is_catchall(te->set, &te->elem))
+				nft_setelem_remove(net, te->set, &te->elem);
+
 			if (!nft_setelem_is_catchall(te->set, &te->elem))
 				atomic_dec(&te->set->nelems);
 
-- 
2.30.2

