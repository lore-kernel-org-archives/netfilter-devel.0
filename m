From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/18] netfilter: nft_compat: check match/targetinfo attr size
Date: Tue, 15 Mar 2016 02:27:52 +0100
Message-ID: <1458005282-24665-9-git-send-email-pablo@netfilter.org>
References: <1458005282-24665-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33221 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289AbcCOB2b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 21:28:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0EF35114F48
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:28:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EC19DDA396
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:28:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F16A4DA8FA
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:28:25 +0100 (CET)
In-Reply-To: <1458005282-24665-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

We copy according to ->target|matchsize, so check that the netlink attribute
(which can include padding and might be larger) contains enough data.

Reported-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.1.4

