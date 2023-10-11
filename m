Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF2C9CD98F9
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Oct 2023 08:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjJKIAO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Oct 2023 04:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjJKIAN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2023 04:00:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0493392
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2023 01:00:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qqU8Y-0006ux-MG; Wed, 11 Oct 2023 10:00:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/6] netfilter: nf_nat: mask out non-verdict bits when checking return value
Date:   Wed, 11 Oct 2023 09:59:37 +0200
Message-ID: <20231011075944.2301-5-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231011075944.2301-1-fw@strlen.de>
References: <20231011075944.2301-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Same as previous change: we need to mask out the non-verdict bits, as
upcoming patches may embed an errno value in NF_STOLEN verdicts too.

NF_DROP could already do this, but not all called functions do this.

Checks that only test ret vs NF_ACCEPT are fine, the 'errno parts'
are always 0 for those.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_proto.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 5a049740758f..6d969468c779 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -999,11 +999,12 @@ static unsigned int
 nf_nat_ipv6_in(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state)
 {
-	unsigned int ret;
+	unsigned int ret, verdict;
 	struct in6_addr daddr = ipv6_hdr(skb)->daddr;
 
 	ret = nf_nat_ipv6_fn(priv, skb, state);
-	if (ret != NF_DROP && ret != NF_STOLEN &&
+	verdict = ret & NF_VERDICT_MASK;
+	if (verdict != NF_DROP && verdict != NF_STOLEN &&
 	    ipv6_addr_cmp(&daddr, &ipv6_hdr(skb)->daddr))
 		skb_dst_drop(skb);
 
-- 
2.41.0

