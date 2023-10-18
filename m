Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72643CDB484
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 08:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjJRIvs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 04:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjJRIvq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 04:51:46 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF8DF9;
        Wed, 18 Oct 2023 01:51:44 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qt2HD-0006L3-8M; Wed, 18 Oct 2023 10:51:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 4/7] netfilter: nf_nat: mask out non-verdict bits when checking return value
Date:   Wed, 18 Oct 2023 10:51:08 +0200
Message-ID: <20231018085118.10829-5-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018085118.10829-1-fw@strlen.de>
References: <20231018085118.10829-1-fw@strlen.de>
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

