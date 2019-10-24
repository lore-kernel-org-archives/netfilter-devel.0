Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E30BCA9EAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 16:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AE6A21929
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 16:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503482AbfJXQhn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 12:37:43 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:58924 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503426AbfJXQhn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 12:37:43 -0400
Received: from localhost ([::1]:43782 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iNg7J-0005DL-U5; Thu, 24 Oct 2019 18:37:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 6/7] xtables-restore: Improve performance of --noflush operation
Date:   Thu, 24 Oct 2019 18:37:11 +0200
Message-Id: <20191024163712.22405-7-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191024163712.22405-1-phil@nwl.cc>
References: <20191024163712.22405-1-phil@nwl.cc>
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
 iptables/xtables-restore.c | 88 +++++++++++++++++++++++++++++++++++---
 1 file changed, 81 insertions(+), 7 deletions(-)

diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 5a534ca227379..120b444f4b8a5 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -248,22 +248,96 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 	}
 }
 
+/* Return true if given iptables-restore line will require a full cache.
+ * Typically these are commands referring to an existing rule
+ * (either by number or content) or commands listing the ruleset. */
+static bool cmd_needs_full_cache(char *cmd)
+{
+	char c, chain[32];
+	int rulenum, mcount;
+
+	mcount = sscanf(cmd, "-%c %31s %d", &c, chain, &rulenum);
+
+	if (mcount == 3)
+		return true;
+	if (mcount < 1)
+		return false;
+
+	switch (c) {
+	case 'D':
+	case 'C':
+	case 'S':
+	case 'L':
+		return true;
+	}
+
+	return false;
+}
+
+#define PREBUFSIZ	65536
+
 void xtables_restore_parse(struct nft_handle *h,
 			   const struct nft_xt_restore_parse *p)
 {
 	struct nft_xt_restore_state state = {};
-	char buffer[10240];
+	char preload_buffer[PREBUFSIZ] = {}, buffer[10240], *ptr;
 
-	line = 0;
-
-	if (!h->noflush)
+	if (!h->noflush) {
 		nft_fake_cache(h);
-	else
-		nft_build_cache(h, NULL);
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
+
+			pblen -= blen;
+			if (pblen <= 0) {
+				/* buffer exhausted */
+				do_cache = true;
+				break;
+			}
 
-	/* Grab standard input. */
+			if (cmd_needs_full_cache(buffer)) {
+				do_cache = true;
+				break;
+			}
+
+			/* copy string including terminating nul-char */
+			memcpy(ptr, buffer, blen);
+			ptr += blen;
+			buffer[0] = '\0';
+		}
+
+		if (do_cache)
+			nft_build_cache(h, NULL);
+	}
+
+	line = 0;
+	ptr = preload_buffer;
+	while (*ptr) {
+		h->error.lineno = ++line;
+		DEBUGP("%s: buffered line %d: '%s'\n", __func__, line, ptr);
+		xtables_restore_parse_line(h, p, &state, ptr);
+		ptr += strlen(ptr) + 1;
+	}
+	if (*buffer) {
+		h->error.lineno = ++line;
+		DEBUGP("%s: overrun line %d: '%s'\n", __func__, line, buffer);
+		xtables_restore_parse_line(h, p, &state, buffer);
+	}
 	while (fgets(buffer, sizeof(buffer), p->in)) {
 		h->error.lineno = ++line;
+		DEBUGP("%s: input line %d: '%s'\n", __func__, line, buffer);
 		xtables_restore_parse_line(h, p, &state, buffer);
 	}
 	if (state.in_table && p->commit) {
-- 
2.23.0

