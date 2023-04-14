Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FC4C77B6E
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Apr 2023 13:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjDNNBp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Apr 2023 09:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjDNNBp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Apr 2023 09:01:45 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CCA1BFD
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2023 06:01:44 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pnJ3e-0001qZ-Tn; Fri, 14 Apr 2023 15:01:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/4] netfilter: nf_tables: remove unneeded conditional
Date:   Fri, 14 Apr 2023 15:01:31 +0200
Message-Id: <20230414130134.29040-2-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414130134.29040-1-fw@strlen.de>
References: <20230414130134.29040-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This helper is inlined, so keep it as small as possible.

If the static key is true, there is only a very small chance
that info->trace is false:

1. tracing was enabled at this very moment, the static key was
   updated to active right after nft_do_table was called.

2. tracing was disabled at this very moment.
   trace->info is already false, the static key is about to
   be patched to false soon.

In both cases, no event will be sent because info->trace
is false (checked in noinline slowpath). info->nf_trace is irrelevant.

The nf_trace update is redunant in this case, but this will only
happen for short duration, when static key flips.

       text  data   bss   dec   hex filename
old:   2980   192    32  3204   c84 nf_tables_core.o
new:   2964   192    32  3188   c74i nf_tables_core.o

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 89c05b64c2a2..bed855638050 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -67,10 +67,8 @@ static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
 static inline void nft_trace_copy_nftrace(const struct nft_pktinfo *pkt,
 					  struct nft_traceinfo *info)
 {
-	if (static_branch_unlikely(&nft_trace_enabled)) {
-		if (info->trace)
-			info->nf_trace = pkt->skb->nf_trace;
-	}
+	if (static_branch_unlikely(&nft_trace_enabled))
+		info->nf_trace = pkt->skb->nf_trace;
 }
 
 static void nft_bitwise_fast_eval(const struct nft_expr *expr,
-- 
2.39.2

