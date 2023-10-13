Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 360EBCDB482
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Oct 2023 12:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjJMMSe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Oct 2023 08:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbjJMMSe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Oct 2023 08:18:34 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C86BD
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Oct 2023 05:18:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qrH7f-0007eK-7m; Fri, 13 Oct 2023 14:18:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/3] netfilter: nf_tables: de-constify set commit ops function argument
Date:   Fri, 13 Oct 2023 14:18:14 +0200
Message-ID: <20231013121821.31322-2-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231013121821.31322-1-fw@strlen.de>
References: <20231013121821.31322-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The set backend using this already has to work around this via ugly
cast, don't spread this pattern.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h | 2 +-
 net/netfilter/nft_set_pipapo.c    | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9fb16485d08f..8de040d2d2cf 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -462,7 +462,7 @@ struct nft_set_ops {
 					       const struct nft_set *set,
 					       const struct nft_set_elem *elem,
 					       unsigned int flags);
-	void				(*commit)(const struct nft_set *set);
+	void				(*commit)(struct nft_set *set);
 	void				(*abort)(const struct nft_set *set);
 	u64				(*privsize)(const struct nlattr * const nla[],
 						    const struct nft_set_desc *desc);
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index c0dcc40de358..75a9dee353e2 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1549,12 +1549,11 @@ static void nft_pipapo_gc_deactivate(struct net *net, struct nft_set *set,
 
 /**
  * pipapo_gc() - Drop expired entries from set, destroy start and end elements
- * @_set:	nftables API set representation
+ * @set:	nftables API set representation
  * @m:		Matching data
  */
-static void pipapo_gc(const struct nft_set *_set, struct nft_pipapo_match *m)
+static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 {
-	struct nft_set *set = (struct nft_set *) _set;
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct net *net = read_pnet(&set->net);
 	int rules_f0, first_rule = 0;
@@ -1672,7 +1671,7 @@ static void pipapo_reclaim_match(struct rcu_head *rcu)
  * We also need to create a new working copy for subsequent insertions and
  * deletions.
  */
-static void nft_pipapo_commit(const struct nft_set *set)
+static void nft_pipapo_commit(struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *new_clone, *old;
-- 
2.41.0

