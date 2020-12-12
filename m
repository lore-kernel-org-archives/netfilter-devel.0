Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A1E4C4167B
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Dec 2020 15:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF340222BB
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Dec 2020 15:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439232AbgLLPQd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Dec 2020 10:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727395AbgLLPQc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Dec 2020 10:16:32 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAADC0613D6
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Dec 2020 07:15:52 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ko6cg-0005zk-UG; Sat, 12 Dec 2020 16:15:51 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH xtables-nft 2/3] xtables-monitor: fix packet family protocol
Date:   Sat, 12 Dec 2020 16:15:33 +0100
Message-Id: <20201212151534.54336-3-fw@strlen.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201212151534.54336-1-fw@strlen.de>
References: <20201212151534.54336-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This prints the family passed on the command line (which might be 0).
Print the table family instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/xtables-monitor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index 364e600e1b38..8850a12032d2 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -273,14 +273,14 @@ static void trace_print_packet(const struct nftnl_trace *nlt, struct cb_arg *arg
 	uint32_t mark;
 	char name[IFNAMSIZ];
 
-	printf("PACKET: %d %08x ", args->nfproto, nftnl_trace_get_u32(nlt, NFTNL_TRACE_ID));
+	family = nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY);
+	printf("PACKET: %d %08x ", family, nftnl_trace_get_u32(nlt, NFTNL_TRACE_ID));
 
 	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_IIF))
 		printf("IN=%s ", if_indextoname(nftnl_trace_get_u32(nlt, NFTNL_TRACE_IIF), name));
 	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_OIF))
 		printf("OUT=%s ", if_indextoname(nftnl_trace_get_u32(nlt, NFTNL_TRACE_OIF), name));
 
-	family = nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY);
 	nfproto = family;
 	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_NFPROTO)) {
 		nfproto = nftnl_trace_get_u32(nlt, NFTNL_TRACE_NFPROTO);
-- 
2.28.0

