Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D91C43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 09:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 750BE2053B
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 09:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfLDJGV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 04:06:21 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:58038 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbfLDJGV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 04:06:21 -0500
Received: from localhost ([::1]:42896 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1icQc0-0005TH-2Y; Wed, 04 Dec 2019 10:06:20 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] xtables-restore: Fix parser feed from line buffer
Date:   Wed,  4 Dec 2019 10:06:06 +0100
Message-Id: <20191204090606.2088-2-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204090606.2088-1-phil@nwl.cc>
References: <20191204090606.2088-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When called with --noflush, xtables-restore would trip over chain lines:
Parser uses strtok() to separate chain name, policy and counters which
inserts nul-chars into the source string. Therefore strlen() can't be
used anymore to find end of line. Fix this by caching line length before
calling xtables_restore_parse_line().

Fixes: 09cb517949e69 ("xtables-restore: Improve performance of --noflush operation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../testcases/ipt-restore/0010-noflush-new-chain_0     | 10 ++++++++++
 iptables/xtables-restore.c                             |  4 +++-
 2 files changed, 13 insertions(+), 1 deletion(-)
 create mode 100755 iptables/tests/shell/testcases/ipt-restore/0010-noflush-new-chain_0

diff --git a/iptables/tests/shell/testcases/ipt-restore/0010-noflush-new-chain_0 b/iptables/tests/shell/testcases/ipt-restore/0010-noflush-new-chain_0
new file mode 100755
index 0000000000000..739e684a21183
--- /dev/null
+++ b/iptables/tests/shell/testcases/ipt-restore/0010-noflush-new-chain_0
@@ -0,0 +1,10 @@
+#!/bin/sh -e
+
+# assert input feed from buffer doesn't trip over
+# added nul-chars from parsing chain line.
+
+$XT_MULTI iptables-restore --noflush <<EOF
+*filter
+:foobar - [0:0]
+-A foobar -j ACCEPT
+COMMIT
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 2f0fe7d439d94..dd907e0b8ddd5 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -327,10 +327,12 @@ void xtables_restore_parse(struct nft_handle *h,
 	line = 0;
 	ptr = preload_buffer;
 	while (*ptr) {
+		size_t len = strlen(ptr);
+
 		h->error.lineno = ++line;
 		DEBUGP("%s: buffered line %d: '%s'\n", __func__, line, ptr);
 		xtables_restore_parse_line(h, p, &state, ptr);
-		ptr += strlen(ptr) + 1;
+		ptr += len + 1;
 	}
 	if (*buffer) {
 		h->error.lineno = ++line;
-- 
2.24.0

