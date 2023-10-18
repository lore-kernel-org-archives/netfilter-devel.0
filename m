Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271C3C41513
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 12:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbjJRM4a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 08:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbjJRM43 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 08:56:29 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB81B112;
        Wed, 18 Oct 2023 05:56:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qt662-0008DO-UW; Wed, 18 Oct 2023 14:56:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net 3/4] netfilter: nft_set_rbtree: .deactivate fails if element has expired
Date:   Wed, 18 Oct 2023 14:55:59 +0200
Message-ID: <20231018125605.27299-4-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018125605.27299-1-fw@strlen.de>
References: <20231018125605.27299-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

This allows to remove an expired element which is not possible in other
existing set backends, this is more noticeable if gc-interval is high so
expired elements remain in the tree. On-demand gc also does not help in
this case, because this is delete element path. Return NULL if element
has expired.

Fixes: 8d8540c4f5e0 ("netfilter: nft_set_rbtree: add timeout support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_rbtree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 2660ceab3759..e34662f4a71e 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -568,6 +568,8 @@ static void *nft_rbtree_deactivate(const struct net *net,
 				   nft_rbtree_interval_end(this)) {
 				parent = parent->rb_right;
 				continue;
+			} else if (nft_set_elem_expired(&rbe->ext)) {
+				break;
 			} else if (!nft_set_elem_active(&rbe->ext, genmask)) {
 				parent = parent->rb_left;
 				continue;
-- 
2.41.0

