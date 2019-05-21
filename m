Return-Path: <SRS0=lkya=TV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BC5C04AB4
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 11:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23E9F216B7
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 11:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbfEULbW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 May 2019 07:31:22 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35504 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726296AbfEULbW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 May 2019 07:31:22 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hT2zI-0008U9-S6; Tue, 21 May 2019 13:31:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     marcmicalizzi@gmail.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 4/5] netfilter: nft_flow_offload: IPCB is only valid for ipv4 family
Date:   Tue, 21 May 2019 13:24:33 +0200
Message-Id: <20190521112434.11767-5-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190521112434.11767-1-fw@strlen.de>
References: <20190521112434.11767-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Guard this with a check vs. ipv4, IPCB isn't valid in ipv6 case.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_flow_offload.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index c97c03c3939a..d70742e95e14 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -48,15 +48,20 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
 	return 0;
 }
 
-static bool nft_flow_offload_skip(struct sk_buff *skb)
+static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
 {
-	struct ip_options *opt  = &(IPCB(skb)->opt);
-
-	if (unlikely(opt->optlen))
-		return true;
 	if (skb_sec_path(skb))
 		return true;
 
+	if (family == NFPROTO_IPV4) {
+		const struct ip_options *opt;
+
+		opt = &(IPCB(skb)->opt);
+
+		if (unlikely(opt->optlen))
+			return true;
+	}
+
 	return false;
 }
 
@@ -74,7 +79,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	struct nf_conn *ct;
 	int ret;
 
-	if (nft_flow_offload_skip(pkt->skb))
+	if (nft_flow_offload_skip(pkt->skb, nft_pf(pkt)))
 		goto out;
 
 	ct = nf_ct_get(pkt->skb, &ctinfo);
-- 
2.21.0

