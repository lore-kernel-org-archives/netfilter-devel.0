Return-Path: <SRS0=NFxu=6Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E15C47255
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 13:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9161720708
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 13:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbgEKNbv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 May 2020 09:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729264AbgEKNbv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 May 2020 09:31:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2523EC061A0C
        for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2020 06:31:51 -0700 (PDT)
Received: from localhost ([::1]:42668 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jY8X7-0001zj-Um; Mon, 11 May 2020 15:31:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf PATCH v2] netfilter: nft_set_rbtree: Add missing expired checks
Date:   Mon, 11 May 2020 15:31:41 +0200
Message-Id: <20200511133141.10201-1-phil@nwl.cc>
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
Changes since v1:
- Return false immediately if matching with an expired element in
  __nft_rbtree_lookup() and __nft_rbtree_get().
---
 net/netfilter/nft_set_rbtree.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 3ffef454d4699..62f416bc05796 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -79,6 +79,10 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 				parent = rcu_dereference_raw(parent->rb_left);
 				continue;
 			}
+
+			if (nft_set_elem_expired(&rbe->ext))
+				return false;
+
 			if (nft_rbtree_interval_end(rbe)) {
 				if (nft_set_is_anonymous(set))
 					return false;
@@ -94,6 +98,7 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
+	    !nft_set_elem_expired(&interval->ext) &&
 	    nft_rbtree_interval_start(interval)) {
 		*ext = &interval->ext;
 		return true;
@@ -154,6 +159,9 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 				continue;
 			}
 
+			if (nft_set_elem_expired(&rbe->ext))
+				return false;
+
 			if (!nft_set_ext_exists(&rbe->ext, NFT_SET_EXT_FLAGS) ||
 			    (*nft_set_ext_flags(&rbe->ext) & NFT_SET_ELEM_INTERVAL_END) ==
 			    (flags & NFT_SET_ELEM_INTERVAL_END)) {
@@ -170,6 +178,7 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
+	    !nft_set_elem_expired(&interval->ext) &&
 	    ((!nft_rbtree_interval_end(interval) &&
 	      !(flags & NFT_SET_ELEM_INTERVAL_END)) ||
 	     (nft_rbtree_interval_end(interval) &&
@@ -418,6 +427,8 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 
 		if (iter->count < iter->skip)
 			goto cont;
+		if (nft_set_elem_expired(&rbe->ext))
+			goto cont;
 		if (!nft_set_elem_active(&rbe->ext, iter->genmask))
 			goto cont;
 
-- 
2.25.1

