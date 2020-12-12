Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323E6C19425
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Dec 2020 15:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14EBC22C7C
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Dec 2020 15:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439234AbgLLPQh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Dec 2020 10:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727395AbgLLPQf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Dec 2020 10:16:35 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDD6C061793
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Dec 2020 07:15:55 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ko6ck-0005zr-5o; Sat, 12 Dec 2020 16:15:54 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH xtables-nft 3/3] xtables-monitor: print packet first
Date:   Sat, 12 Dec 2020 16:15:34 +0100
Message-Id: <20201212151534.54336-4-fw@strlen.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201212151534.54336-1-fw@strlen.de>
References: <20201212151534.54336-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The trace mode should first print the packet that was received and
then the rule/verdict.

Furthermore, the monitor did sometimes print an extra newline.

After this patch, output is more consistent with nft monitor.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/xtables-monitor.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index 8850a12032d2..45a0d6bf1343 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -106,6 +106,7 @@ static int rule_cb(const struct nlmsghdr *nlh, void *data)
 		printf("-0 ");
 		break;
 	default:
+		puts("");
 		goto err_free;
 	}
 
@@ -433,9 +434,18 @@ static void trace_print_packet(const struct nftnl_trace *nlt, struct cb_arg *arg
 	mark = nftnl_trace_get_u32(nlt, NFTNL_TRACE_MARK);
 	if (mark)
 		printf("MARK=0x%x ", mark);
+	puts("");
+}
+
+static void trace_print_hdr(const struct nftnl_trace *nlt)
+{
+	printf(" TRACE: %d %08x %s:%s", nftnl_trace_get_u32(nlt, NFTNL_TABLE_FAMILY),
+					nftnl_trace_get_u32(nlt, NFTNL_TRACE_ID),
+					nftnl_trace_get_str(nlt, NFTNL_TRACE_TABLE),
+					nftnl_trace_get_str(nlt, NFTNL_TRACE_CHAIN));
 }
 
-static void print_verdict(struct nftnl_trace *nlt, uint32_t verdict)
+static void print_verdict(const struct nftnl_trace *nlt, uint32_t verdict)
 {
 	const char *chain;
 
@@ -496,35 +506,37 @@ static int trace_cb(const struct nlmsghdr *nlh, struct cb_arg *arg)
 	    arg->nfproto != nftnl_trace_get_u32(nlt, NFTNL_TABLE_FAMILY))
 		goto err_free;
 
-	printf(" TRACE: %d %08x %s:%s", nftnl_trace_get_u32(nlt, NFTNL_TABLE_FAMILY),
-					nftnl_trace_get_u32(nlt, NFTNL_TRACE_ID),
-					nftnl_trace_get_str(nlt, NFTNL_TRACE_TABLE),
-					nftnl_trace_get_str(nlt, NFTNL_TRACE_CHAIN));
-
 	switch (nftnl_trace_get_u32(nlt, NFTNL_TRACE_TYPE)) {
 	case NFT_TRACETYPE_RULE:
 		verdict = nftnl_trace_get_u32(nlt, NFTNL_TRACE_VERDICT);
-		printf(":rule:0x%llx:", (unsigned long long)nftnl_trace_get_u64(nlt, NFTNL_TRACE_RULE_HANDLE));
-		print_verdict(nlt, verdict);
 
-		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_RULE_HANDLE))
-			trace_print_rule(nlt, arg);
 		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_LL_HEADER) ||
 		    nftnl_trace_is_set(nlt, NFTNL_TRACE_NETWORK_HEADER))
 			trace_print_packet(nlt, arg);
+
+		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_RULE_HANDLE)) {
+			trace_print_hdr(nlt);
+			printf(":rule:0x%llx:", (unsigned long long)nftnl_trace_get_u64(nlt, NFTNL_TRACE_RULE_HANDLE));
+			print_verdict(nlt, verdict);
+			printf(" ");
+			trace_print_rule(nlt, arg);
+		}
 		break;
 	case NFT_TRACETYPE_POLICY:
+		trace_print_hdr(nlt);
 		printf(":policy:");
 		verdict = nftnl_trace_get_u32(nlt, NFTNL_TRACE_POLICY);
 
 		print_verdict(nlt, verdict);
+		puts("");
 		break;
 	case NFT_TRACETYPE_RETURN:
+		trace_print_hdr(nlt);
 		printf(":return:");
 		trace_print_return(nlt);
+		puts("");
 		break;
 	}
-	puts("");
 err_free:
 	nftnl_trace_free(nlt);
 err:
-- 
2.28.0

