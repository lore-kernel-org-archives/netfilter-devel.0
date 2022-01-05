Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E84C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jan 2022 13:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240105AbiAENUK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jan 2022 08:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240089AbiAENUI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jan 2022 08:20:08 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73098C061785
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Jan 2022 05:20:08 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1n56D0-0002OP-0O; Wed, 05 Jan 2022 14:20:06 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     sbrivio@redhat.com, Florian Westphal <fw@strlen.de>,
        etkaar <lists.netfilter.org@prvy.eu>
Subject: [PATCH nf] netfilter: nft_set_pipapo: allocate pcpu scratch maps on clone
Date:   Wed,  5 Jan 2022 14:19:54 +0100
Message-Id: <20220105131954.23666-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is needed in case a new transaction is made that doesn't insert any
new elements into an already existing set.

Else, after second 'nft -f ruleset.txt', lookups in such a set will fail
because ->lookup() encounters raw_cpu_ptr(m->scratch) == NULL.

For the initial rule load, insertion of elements takes care of the
allocation, but for rule reloads this isn't guaranteed: we might not
have additions to the set.

Fixes: 3c4287f62044a90e ("nf_tables: Add set type for arbitrary concatenation of ranges")
Reported-by: etkaar <lists.netfilter.org@prvy.eu>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Change since test patch:
 handle 'out_scratch_realloc' error handling to free scratch maps
 on errors.

 net/netfilter/nft_set_pipapo.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index dce866d93fee..2c8051d8cca6 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1290,6 +1290,11 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 	if (!new->scratch_aligned)
 		goto out_scratch;
 #endif
+	for_each_possible_cpu(i)
+		*per_cpu_ptr(new->scratch, i) = NULL;
+
+	if (pipapo_realloc_scratch(new, old->bsize_max))
+		goto out_scratch_realloc;
 
 	rcu_head_init(&new->rcu);
 
@@ -1334,6 +1339,9 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		kvfree(dst->lt);
 		dst--;
 	}
+out_scratch_realloc:
+	for_each_possible_cpu(i)
+		kfree(*per_cpu_ptr(new->scratch, i));
 #ifdef NFT_PIPAPO_ALIGN
 	free_percpu(new->scratch_aligned);
 #endif
-- 
2.34.1

