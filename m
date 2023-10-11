Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D80CD98F9
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Oct 2023 08:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjJKIAS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Oct 2023 04:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjJKIAS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2023 04:00:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E09A4
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2023 01:00:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qqU8c-0006vC-OP; Wed, 11 Oct 2023 10:00:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 5/6] netfilter: make nftables drops visible in net dropmonitor
Date:   Wed, 11 Oct 2023 09:59:38 +0200
Message-ID: <20231011075944.2301-6-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231011075944.2301-1-fw@strlen.de>
References: <20231011075944.2301-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

net_dropmonitor blames core.c:nf_hook_slow.
Add NF_DROP_REASON() helper and use it in nft_do_chain().

The helper releases the skb, so exact drop location becomes
available. Calling code will observe the NF_STOLEN verdict
instead.

Adjust nf_hook_slow so we can embed an erro value wih
NF_STOLEN verdicts, just like we do for NF_DROP.

After this, drop in nftables can be pinpointed to a drop due
to a rule or the chain policy.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h      | 10 ++++++++++
 net/netfilter/core.c           |  6 +++---
 net/netfilter/nf_tables_core.c |  6 +++++-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index d68644b7c299..80900d910992 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -22,6 +22,16 @@ static inline int NF_DROP_GETERR(int verdict)
 	return -(verdict >> NF_VERDICT_QBITS);
 }
 
+static __always_inline int
+NF_DROP_REASON(struct sk_buff *skb, enum skb_drop_reason reason, u32 err)
+{
+	BUILD_BUG_ON(err > 0xffff);
+
+	kfree_skb_reason(skb, reason);
+
+	return ((err << 16) | NF_STOLEN);
+}
+
 static inline int nf_inet_addr_cmp(const union nf_inet_addr *a1,
 				   const union nf_inet_addr *a2)
 {
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index ef4e76e5aef9..3126911f5042 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -639,10 +639,10 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 			if (ret == 1)
 				continue;
 			return ret;
+		case NF_STOLEN:
+			return NF_DROP_GETERR(verdict);
 		default:
-			/* Implicit handling for NF_STOLEN, as well as any other
-			 * non conventional verdicts.
-			 */
+			WARN_ON_ONCE(1);
 			return 0;
 		}
 	}
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 6009b423f60a..8b536d7ef6c2 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -308,10 +308,11 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 
 	switch (regs.verdict.code & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
-	case NF_DROP:
 	case NF_QUEUE:
 	case NF_STOLEN:
 		return regs.verdict.code;
+	case NF_DROP:
+		return NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 	}
 
 	switch (regs.verdict.code) {
@@ -342,6 +343,9 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	if (static_branch_unlikely(&nft_counters_enabled))
 		nft_update_chain_stats(basechain, pkt);
 
+	if (nft_base_chain(basechain)->policy == NF_DROP)
+		return NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
+
 	return nft_base_chain(basechain)->policy;
 }
 EXPORT_SYMBOL_GPL(nft_do_chain);
-- 
2.41.0

