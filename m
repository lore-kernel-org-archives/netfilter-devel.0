Return-Path: <SRS0=p5Wx=5L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DBDFC43331
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 15:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD84B20714
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 15:29:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aixah.de header.i=@aixah.de header.b="ydeu3MwO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgCZP3f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Mar 2020 11:29:35 -0400
Received: from mout-p-103.mailbox.org ([80.241.56.161]:49164 "EHLO
        mout-p-103.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727954AbgCZP3f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Mar 2020 11:29:35 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2020 11:29:33 EDT
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 48p7z342RHzKmVM;
        Thu, 26 Mar 2020 16:22:55 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aixah.de; s=MBO0001;
        t=1585236173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Wgqcm3bonXkjmH4QqYJtPW9+v/do56eMASIqPChHLyU=;
        b=ydeu3MwO/B7pKLnW5akgd3U1zydPwlgp2hSNPvGpCdZRg3O3Pw9/O2M2MQx+7UhQ21pVNW
        jcrLjZDDrVGeRYP4rLD2SqBYofEn/I9bi/sLG6FI5LokFwVnEzHDrqULLbLau6DuVG143J
        xyNzWqzBaePDOJPDUuerKyDdyBJ2s+iG1nCOFnsA6GJ/EA4GQd+Sn46Ur7UcLITC9awHTL
        qJ1NJiuU8sU5B+OR0qQPPWM6Ar2PrRXsZcAAAPBlRs4lirnKedShTzCuorBkjj9QTMM1iP
        l1f2yGKN84T2Rw8xqeYQre2OZs0GPt1VsNdDzdCKhJapW8hEcHfUH68R12WDOw==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id QBJek7G-52ZY; Thu, 26 Mar 2020 16:22:49 +0100 (CET)
From:   Luis Ressel <aranea@aixah.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Luis Ressel <aranea@aixah.de>
Subject: [PATCH nft] netlink: Show the handles of unknown rules in "nft monitor trace"
Date:   Thu, 26 Mar 2020 15:22:29 +0000
Message-Id: <20200326152229.5923-1-aranea@aixah.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When "nft monitor trace" doesn't know a rule (because it was only added
to the ruleset after nft was invoked), that rule is silently omitted in
the trace output, which can come as a surprise when debugging issues.

Instead, we can at least show the information we got via netlink, i.e.
the family, table and chain name, rule handle and verdict.

Signed-off-by: Luis Ressel <aranea@aixah.de>
---
 src/netlink.c | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index b254753f..0f6af73e 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1447,38 +1447,50 @@ static void trace_print_policy(const struct nftnl_trace *nlt,
 	expr_free(expr);
 }
 
-static void trace_print_rule(const struct nftnl_trace *nlt,
-			      struct output_ctx *octx, struct nft_cache *cache)
+static struct rule *trace_lookup_rule(const struct nftnl_trace *nlt,
+				      uint64_t rule_handle,
+				      struct nft_cache *cache)
 {
-	const struct table *table;
-	uint64_t rule_handle;
 	struct chain *chain;
-	struct rule *rule;
+	struct table *table;
 	struct handle h;
 
 	h.family = nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY);
-	h.table.name  = nftnl_trace_get_str(nlt, NFTNL_TRACE_TABLE);
-	h.chain.name  = nftnl_trace_get_str(nlt, NFTNL_TRACE_CHAIN);
+	h.table.name = nftnl_trace_get_str(nlt, NFTNL_TRACE_TABLE);
+	h.chain.name = nftnl_trace_get_str(nlt, NFTNL_TRACE_CHAIN);
 
 	if (!h.table.name)
-		return;
+		return NULL;
 
 	table = table_lookup(&h, cache);
 	if (!table)
-		return;
+		return NULL;
 
 	chain = chain_lookup(table, &h);
 	if (!chain)
-		return;
+		return NULL;
+
+	return rule_lookup(chain, rule_handle);
+}
+
+static void trace_print_rule(const struct nftnl_trace *nlt,
+			      struct output_ctx *octx, struct nft_cache *cache)
+{
+	uint64_t rule_handle;
+	struct rule *rule;
 
 	rule_handle = nftnl_trace_get_u64(nlt, NFTNL_TRACE_RULE_HANDLE);
-	rule = rule_lookup(chain, rule_handle);
-	if (!rule)
-		return;
+	rule = trace_lookup_rule(nlt, rule_handle, cache);
 
 	trace_print_hdr(nlt, octx);
-	nft_print(octx, "rule ");
-	rule_print(rule, octx);
+
+	if (rule) {
+		nft_print(octx, "rule ");
+		rule_print(rule, octx);
+	} else {
+		nft_print(octx, "unknown rule handle %" PRIu64, rule_handle);
+	}
+
 	nft_print(octx, " (");
 	trace_print_verdict(nlt, octx);
 	nft_print(octx, ")\n");
-- 
2.25.0

