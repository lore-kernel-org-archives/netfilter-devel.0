Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC016C432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7BBD2054F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfIYV0n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:26:43 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45818 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbfIYV0n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 17:26:43 -0400
Received: from localhost ([::1]:58908 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDEo5-0005Df-HN; Wed, 25 Sep 2019 23:26:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 24/24] xtables-restore: Improve performance of --noflush operation
Date:   Wed, 25 Sep 2019 23:26:05 +0200
Message-Id: <20190925212605.1005-25-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925212605.1005-1-phil@nwl.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The reason for that full cache fetching when called with --noflush even
before looking at any input data was that there might be a command
requiring a rule cache following some rule add/insert ones which don't.
At that point one needs to fetch rules from kernel and try to insert the
local ones at the right spot which is non-trivial.

At the same time there is a performance-critical use-case for --noflush,
namely fast insertion of a bunch of rules in one go, avoiding the
process spawn overhead.

Optimize for this use-case by preloading input into a 64KB buffer to see
if it fits. If so, search for commands requiring a rule cache. If there
are none, skip initial full cache fetching.

The above algorithm may abort at any point, so actual input parsing must
happen in three stages:

1) parse all preloaded lines from 64KB buffer
2) parse any leftover line in line buffer (happens if input exceeds
   the preload buffer size)
3) parse remaining input from input file pointer

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-restore.c | 85 ++++++++++++++++++++++++++++++++++----
 1 file changed, 78 insertions(+), 7 deletions(-)

diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index d065e1a921be7..1b84f78070fa0 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -262,22 +262,93 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 	}
 }
 
+/* return true if given iptables-restore line references a rule */
+static bool is_ruleref_cmd(char *cmd)
+{
+	char c, chain[32];
+	int rulenum, mcount;
+
+	mcount = sscanf(cmd, "-%c %31s %d", &c, chain, &rulenum);
+
+	if (mcount == 3)
+		return true;
+
+	switch (c) {
+	case 'D':
+	case 'C':
+	case 'S':
+	case 'L':
+	case 'Z':
+		return true;
+	}
+
+	return false;
+}
+
+#define PREBUFSIZ	65536
+
 void xtables_restore_parse(struct nft_handle *h,
 			   struct nft_xt_restore_parse *p,
 			   struct nft_xt_restore_cb *cb)
 {
-	char buffer[10240];
-
-	line = 0;
+	char preload_buffer[PREBUFSIZ] = {}, buffer[10240], *ptr;
 
-	if (!h->noflush)
+	if (!h->noflush) {
 		nft_fake_cache(h);
-	else
-		nft_build_cache(h);
+	} else {
+		ssize_t pblen = sizeof(preload_buffer);
+		bool do_cache = false;
+
+		ptr = preload_buffer;
+		while (fgets(buffer, sizeof(buffer), p->in)) {
+			size_t blen = strlen(buffer);
+
+			/* drop trailing newline; add_param_to_argv() changes
+			 * it into nul, causing unpredictable string delimiting
+			 * in preload_buffer */
+			if (buffer[blen - 1] == '\n')
+				buffer[blen - 1] = '\0';
+			else
+				blen++;
 
-	/* Grab standard input. */
+			pblen -= blen;
+			if (pblen <= 0) {
+				/* buffer exhausted */
+				do_cache = true;
+				break;
+			}
+
+			if (is_ruleref_cmd(buffer)) {
+				do_cache = true;
+				break;
+			}
+
+			/* keep strings nul-terminated */
+			memcpy(ptr, buffer, blen);
+			ptr += blen;
+			buffer[0] = '\0';
+		}
+
+		if (do_cache)
+			nft_build_cache(h);
+	}
+
+	line = 0;
+	ptr = preload_buffer;
+	while (*ptr) {
+		h->error.lineno = ++line;
+		DEBUGP("%s: buffered line %d: '%s'\n", __func__, line, ptr);
+		xtables_restore_parse_line(h, p, cb, ptr);
+		ptr += strlen(ptr) + 1;
+	}
+	if (*buffer) {
+		h->error.lineno = ++line;
+		DEBUGP("%s: overrun line %d: '%s'\n", __func__, line, buffer);
+		xtables_restore_parse_line(h, p, cb, buffer);
+	}
 	while (fgets(buffer, sizeof(buffer), p->in)) {
 		h->error.lineno = ++line;
+		DEBUGP("%s: input line %d: '%s'\n", __func__, line, buffer);
 		xtables_restore_parse_line(h, p, cb, buffer);
 	}
 	if (p->in_table && p->commit) {
-- 
2.23.0

