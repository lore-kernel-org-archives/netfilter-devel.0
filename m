Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C342C38A2A
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 11:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E2B32070B
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 11:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgEFLLV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 07:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728335AbgEFLLU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 07:11:20 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814B1C061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 04:11:20 -0700 (PDT)
Received: from localhost ([::1]:58054 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jWHxM-0003Ss-Cy; Wed, 06 May 2020 13:11:16 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf PATCH] netfilter: nft_set_rbtree: Add missing expired checks
Date:   Wed,  6 May 2020 13:11:07 +0200
Message-Id: <20200506111107.29778-1-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Expired intervals would still match and be dumped to user space until
garbage collection wiped them out. Make sure they stop matching and
disappear (from users' perspective) as soon as they expire.

Fixes: 8d8540c4f5e03 ("netfilter: nft_set_rbtree: add timeout support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nft_set_rbtree.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 3ffef454d4699..8efcea03a4cbb 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -75,7 +75,8 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 		} else if (d > 0)
 			parent = rcu_dereference_raw(parent->rb_right);
 		else {
-			if (!nft_set_elem_active(&rbe->ext, genmask)) {
+			if (!nft_set_elem_active(&rbe->ext, genmask) ||
+			    nft_set_elem_expired(&rbe->ext)) {
 				parent = rcu_dereference_raw(parent->rb_left);
 				continue;
 			}
@@ -94,6 +95,7 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
+	    !nft_set_elem_expired(&interval->ext) &&
 	    nft_rbtree_interval_start(interval)) {
 		*ext = &interval->ext;
 		return true;
@@ -149,7 +151,8 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 			if (flags & NFT_SET_ELEM_INTERVAL_END)
 				interval = rbe;
 		} else {
-			if (!nft_set_elem_active(&rbe->ext, genmask)) {
+			if (!nft_set_elem_active(&rbe->ext, genmask) ||
+			    nft_set_elem_expired(&rbe->ext)) {
 				parent = rcu_dereference_raw(parent->rb_left);
 				continue;
 			}
@@ -170,6 +173,7 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
+	    !nft_set_elem_expired(&interval->ext) &&
 	    ((!nft_rbtree_interval_end(interval) &&
 	      !(flags & NFT_SET_ELEM_INTERVAL_END)) ||
 	     (nft_rbtree_interval_end(interval) &&
@@ -418,6 +422,8 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 
 		if (iter->count < iter->skip)
 			goto cont;
+		if (nft_set_elem_expired(&rbe->ext))
+			goto cont;
 		if (!nft_set_elem_active(&rbe->ext, iter->genmask))
 			goto cont;
 
-- 
2.25.1

