Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07030CDB47E
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 12:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjJRM4d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 08:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbjJRM4c (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 08:56:32 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7C1119;
        Wed, 18 Oct 2023 05:56:31 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qt667-0008Du-7F; Wed, 18 Oct 2023 14:56:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net 4/4] netfilter: nf_tables: revert do not remove elements if set backend implements .abort
Date:   Wed, 18 Oct 2023 14:56:00 +0200
Message-ID: <20231018125605.27299-5-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018125605.27299-1-fw@strlen.de>
References: <20231018125605.27299-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

nf_tables_abort_release() path calls nft_set_elem_destroy() for
NFT_MSG_NEWSETELEM which releases the element, however, a reference to
the element still remains in the working copy.

Fixes: ebd032fa8818 ("netfilter: nf_tables: do not remove elements if set backend implements .abort")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7b77ff5985f6..29c651804cb2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10345,10 +10345,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				break;
 			}
 			te = (struct nft_trans_elem *)trans->data;
-			if (!te->set->ops->abort ||
-			    nft_setelem_is_catchall(te->set, &te->elem))
-				nft_setelem_remove(net, te->set, &te->elem);
-
+			nft_setelem_remove(net, te->set, &te->elem);
 			if (!nft_setelem_is_catchall(te->set, &te->elem))
 				atomic_dec(&te->set->nelems);
 
-- 
2.41.0

