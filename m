Return-Path: <SRS0=p03Y=VS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7601C76186
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 00:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B01BF206DD
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 00:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfGUASM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jul 2019 20:18:12 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:48896 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725972AbfGUASM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jul 2019 20:18:12 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hozYI-0001ip-Qj; Sun, 21 Jul 2019 02:18:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] src: evaluate: return immediately if no op was requested
Date:   Sun, 21 Jul 2019 02:14:07 +0200
Message-Id: <20190721001406.23785-4-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190721001406.23785-1-fw@strlen.de>
References: <20190721001406.23785-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This makes nft behave like 0.9.0 -- the ruleset

flush ruleset
table inet filter {
}
table inet filter {
      chain test {
        counter
    }
}

loads again without generating an error message.
I've added a test case for this, without this it will create an error,
and with a checkout of the 'fixes' tag we get crash.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1351
Fixes: e5382c0d08e3c ("src: Support intra-transaction rule references")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                  |  3 +++
 tests/shell/testcases/cache/0003_cache_update_0 | 12 ++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index b56932ccabcc..8c1c82abed4e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3258,6 +3258,9 @@ static int rule_cache_update(struct eval_ctx *ctx, enum cmd_ops op)
 	struct table *table;
 	struct chain *chain;
 
+	if (op == CMD_INVALID)
+		return 0;
+
 	table = table_lookup(&rule->handle, &ctx->nft->cache);
 	if (!table)
 		return table_not_found(ctx);
diff --git a/tests/shell/testcases/cache/0003_cache_update_0 b/tests/shell/testcases/cache/0003_cache_update_0
index 05edc9c7c33e..fb4b0e24c790 100755
--- a/tests/shell/testcases/cache/0003_cache_update_0
+++ b/tests/shell/testcases/cache/0003_cache_update_0
@@ -48,3 +48,15 @@ $NFT -f - >/dev/null <<EOF
 add rule ip t4 c meta l4proto igmp accept
 add rule ip t4 c index 2 drop
 EOF
+
+# Trigger a crash or rule restore error with nft 0.9.1
+$NFT -f - >/dev/null <<EOF
+flush ruleset
+table inet testfilter {
+}
+table inet testfilter {
+      chain test {
+        counter
+    }
+}
+EOF
-- 
2.21.0

