Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A7BCD98FA
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Oct 2023 08:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjJKIAF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Oct 2023 04:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjJKIAF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2023 04:00:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E4398
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2023 01:00:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qqU8Q-0006uO-Hu; Wed, 11 Oct 2023 10:00:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/6] netfilter: nf_tables:  mask out non-verdict bits when checking return value
Date:   Wed, 11 Oct 2023 09:59:35 +0200
Message-ID: <20231011075944.2301-3-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231011075944.2301-1-fw@strlen.de>
References: <20231011075944.2301-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nftables trace infra must mask out the non-verdict bit parts of the
return value, else followup changes that 'return errno << 8 | NF_STOLEN'
will cause breakage.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_core.c  | 2 +-
 net/netfilter/nf_tables_trace.c | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 4d0ce12221f6..6009b423f60a 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -115,7 +115,7 @@ static noinline void __nft_trace_verdict(const struct nft_pktinfo *pkt,
 {
 	enum nft_trace_types type;
 
-	switch (regs->verdict.code) {
+	switch (regs->verdict.code & NF_VERDICT_MASK) {
 	case NFT_CONTINUE:
 	case NFT_RETURN:
 		type = NFT_TRACETYPE_RETURN;
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index 6d41c0bd3d78..a83637e3f455 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -258,17 +258,21 @@ void nft_trace_notify(const struct nft_pktinfo *pkt,
 	case __NFT_TRACETYPE_MAX:
 		break;
 	case NFT_TRACETYPE_RETURN:
-	case NFT_TRACETYPE_RULE:
+	case NFT_TRACETYPE_RULE: {
+		unsigned int v;
+
 		if (nft_verdict_dump(skb, NFTA_TRACE_VERDICT, verdict))
 			goto nla_put_failure;
 
 		/* pkt->skb undefined iff NF_STOLEN, disable dump */
-		if (verdict->code == NF_STOLEN)
+		v = verdict->code & NF_VERDICT_MASK;
+		if (v == NF_STOLEN)
 			info->packet_dumped = true;
 		else
 			mark = pkt->skb->mark;
 
 		break;
+	}
 	case NFT_TRACETYPE_POLICY:
 		mark = pkt->skb->mark;
 
-- 
2.41.0

