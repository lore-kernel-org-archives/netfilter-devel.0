Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79674CDB46E
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Oct 2023 08:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbjJLI5k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Oct 2023 04:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbjJLI5i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Oct 2023 04:57:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657C191;
        Thu, 12 Oct 2023 01:57:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qqrVc-00075p-R5; Thu, 12 Oct 2023 10:57:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net 1/7] netfilter: nf_tables: do not remove elements if set backend implements .abort
Date:   Thu, 12 Oct 2023 10:57:04 +0200
Message-ID: <20231012085724.15155-2-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231012085724.15155-1-fw@strlen.de>
References: <20231012085724.15155-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

pipapo set backend maintains two copies of the datastructure, removing
the elements from the copy that is going to be discarded slows down
the abort path significantly, from several minutes to few seconds after
this patch.

Fixes: 212ed75dc5fb ("netfilter: nf_tables: integrate pipapo into commit protocol")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a72b6aeefb1b..c3de3791cabd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10347,7 +10347,10 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
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
2.41.0

