Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1818AC43219
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jan 2022 12:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244339AbiATMwY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jan 2022 07:52:24 -0500
Received: from mail.netfilter.org ([217.70.188.207]:38746 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244311AbiATMwV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jan 2022 07:52:21 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id AE4926079C;
        Thu, 20 Jan 2022 13:49:21 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 5/5] netfilter: conntrack: don't increment invalid counter on NF_REPEAT
Date:   Thu, 20 Jan 2022 13:52:12 +0100
Message-Id: <20220120125212.991271-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120125212.991271-1-pablo@netfilter.org>
References: <20220120125212.991271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The packet isn't invalid, REPEAT means we're trying again after cleaning
out a stale connection, e.g. via tcp tracker.

This caused increases of invalid stat counter in a test case involving
frequent connection reuse, even though no packet is actually invalid.

Fixes: 56a62e2218f5 ("netfilter: conntrack: fix NF_REPEAT handling")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

