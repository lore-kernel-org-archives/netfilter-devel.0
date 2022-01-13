Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC003C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Jan 2022 20:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbiAMUiG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Jan 2022 15:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234419AbiAMUiG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 15:38:06 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7057C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Jan 2022 12:38:05 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1n86rD-0004qq-K7; Thu, 13 Jan 2022 21:38:03 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: don't increment invalid counter on NF_REPEAT
Date:   Thu, 13 Jan 2022 21:37:58 +0100
Message-Id: <20220113203758.22685-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The packet isn't invalid, REPEAT means we're trying again after cleaning
out a stale connection, e.g. via tcp tracker.

This caused increases of invalid stat counter in a test case involving
frequent connection reuse, even though no packet is actually invalid.

Fixes: 56a62e2218f5 ("netfilter: conntrack: fix NF_REPEAT handling")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 894a325d39f2..d6aa5b47031e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1924,15 +1924,17 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 		pr_debug("nf_conntrack_in: Can't track with proto module\n");
 		nf_ct_put(ct);
 		skb->_nfct = 0;
-		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
-		if (ret == -NF_DROP)
-			NF_CT_STAT_INC_ATOMIC(state->net, drop);
 		/* Special case: TCP tracker reports an attempt to reopen a
 		 * closed/aborted connection. We have to go back and create a
 		 * fresh conntrack.
 		 */
 		if (ret == -NF_REPEAT)
 			goto repeat;
+
+		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
+		if (ret == -NF_DROP)
+			NF_CT_STAT_INC_ATOMIC(state->net, drop);
+
 		ret = -ret;
 		goto out;
 	}
-- 
2.34.1

