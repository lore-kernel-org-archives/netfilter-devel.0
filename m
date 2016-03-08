From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: nft_compat: check match/targetinfo attr size
Date: Wed,  9 Mar 2016 00:04:21 +0100
Message-ID: <1457478261-11247-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39519 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298AbcCHXL3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 18:11:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We copy accoring to ->target|matchsize, so check that the netlink attribute
(which can include padding and might be larger) contains enough data.

Reported-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_compat.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 454841b..6228c42 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -660,6 +660,9 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	if (IS_ERR(match))
 		return ERR_PTR(-ENOENT);
 
+	if (match->matchsize > nla_len(tb[NFTA_MATCH_INFO]))
+		return ERR_PTR(-EINVAL);
+
 	/* This is the first time we use this match, allocate operations */
 	nft_match = kzalloc(sizeof(struct nft_xt), GFP_KERNEL);
 	if (nft_match == NULL)
@@ -740,6 +743,9 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	if (IS_ERR(target))
 		return ERR_PTR(-ENOENT);
 
+	if (target->targetsize > nla_len(tb[NFTA_TARGET_INFO]))
+		return ERR_PTR(-EINVAL);
+
 	/* This is the first time we use this target, allocate operations */
 	nft_target = kzalloc(sizeof(struct nft_xt), GFP_KERNEL);
 	if (nft_target == NULL)
-- 
2.4.10

