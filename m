Return-Path: <SRS0=wrU5=37=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F440C352A3
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Feb 2020 17:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6563120578
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Feb 2020 17:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgBKRJS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Feb 2020 12:09:18 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:33676 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbgBKRJR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Feb 2020 12:09:17 -0500
Received: from localhost ([::1]:46764 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1j1Z2C-0004Ee-A3; Tue, 11 Feb 2020 18:09:16 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: [iptables PATCH] xtables-restore: fix for --noflush and empty lines
Date:   Tue, 11 Feb 2020 18:09:13 +0100
Message-Id: <20200211170913.2374-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Lookahead buffer used for cache requirements estimate in restore
--noflush separates individual lines with nul-chars. Two consecutive
nul-chars are interpreted as end of buffer and remaining buffer content
is skipped.

Sadly, reading an empty line (i.e., one containing a newline character
only) caused double nul-chars to appear in buffer as well, leading to
premature stop when reading cached lines from buffer.

To fix that, make use of xtables_restore_parse_line() skipping empty
lines without calling strtok() and just leave the newline character in
place. A more intuitive approach, namely skipping empty lines while
buffering, is deliberately not chosen as that would cause wrong values
in 'line' variable.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1400
Fixes: 09cb517949e69 ("xtables-restore: Improve performance of --noflush operation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../ipt-restore/0011-noflush-empty-line_0        | 16 ++++++++++++++++
 iptables/xtables-restore.c                       |  8 +++++---
 2 files changed, 21 insertions(+), 3 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/ipt-restore/0011-noflush-empty-line_0

diff --git a/iptables/tests/shell/testcases/ipt-restore/0011-noflush-empty-line_0 b/iptables/tests/shell/testcases/ipt-restore/0011-noflush-empty-line_0
new file mode 100755
index 0000000000000..bea1a690bb624
--- /dev/null
+++ b/iptables/tests/shell/testcases/ipt-restore/0011-noflush-empty-line_0
@@ -0,0 +1,16 @@
+#!/bin/bash -e
+
+# make sure empty lines won't break --noflush
+
+cat <<EOF | $XT_MULTI iptables-restore --noflush
+# just a comment followed by innocent empty line
+
+*filter
+-A FORWARD -j ACCEPT
+COMMIT
+EOF
+
+EXPECT='Chain FORWARD (policy ACCEPT)
+target     prot opt source               destination         
+ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           '
+diff -u <(echo "$EXPECT") <($XT_MULTI iptables -n -L FORWARD)
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 63cc15cee9621..fb2ac8b5c12a3 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -293,11 +293,13 @@ void xtables_restore_parse(struct nft_handle *h,
 		while (fgets(buffer, sizeof(buffer), p->in)) {
 			size_t blen = strlen(buffer);
 
-			/* drop trailing newline; xtables_restore_parse_line()
+			/* Drop trailing newline; xtables_restore_parse_line()
 			 * uses strtok() which replaces them by nul-characters,
 			 * causing unpredictable string delimiting in
-			 * preload_buffer */
-			if (buffer[blen - 1] == '\n')
+			 * preload_buffer.
+			 * Unless this is an empty line which would fold into a
+			 * spurious EoB indicator (double nul-char). */
+			if (buffer[blen - 1] == '\n' && blen > 1)
 				buffer[blen - 1] = '\0';
 			else
 				blen++;
-- 
2.24.1

