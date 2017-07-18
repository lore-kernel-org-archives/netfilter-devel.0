From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nft_compat: check extension hook mask only if set
Date: Tue, 18 Jul 2017 20:16:30 +0200
Message-ID: <1500401790-15328-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52498 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751408AbdGRSQi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2017 14:16:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4985D24927
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 20:16:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30EA8DA7F1
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 20:16:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B9469DA80E
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 20:16:22 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the x_tables extension comes with no hook mask, skip this validation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index f5a7cb68694e..b89f4f65b2a0 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -305,7 +305,7 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 		const struct nf_hook_ops *ops = &basechain->ops[0];
 
 		hook_mask = 1 << ops->hooknum;
-		if (!(hook_mask & target->hooks))
+		if (target->hooks && !(hook_mask & target->hooks))
 			return -EINVAL;
 
 		ret = nft_compat_chain_validate_dependency(target->table,
@@ -484,7 +484,7 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 		const struct nf_hook_ops *ops = &basechain->ops[0];
 
 		hook_mask = 1 << ops->hooknum;
-		if (!(hook_mask & match->hooks))
+		if (match->hooks && !(hook_mask & match->hooks))
 			return -EINVAL;
 
 		ret = nft_compat_chain_validate_dependency(match->table,
-- 
2.1.4

