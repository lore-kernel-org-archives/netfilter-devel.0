Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18A2EE6457
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Sep 2023 13:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbjIONUa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Sep 2023 09:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235214AbjIONUa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Sep 2023 09:20:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691571713
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Sep 2023 06:20:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qh8kC-0003bn-1k; Fri, 15 Sep 2023 15:20:24 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        "Lee, Cherie-Anne" <cherie.lee@starlabs.sg>,
        Bing-Jhong Billy Jheng <billy@starlabs.sg>, info@starlabs.sg
Subject: [PATCH nft] tests: add test for dormant on/off/on bug
Date:   Fri, 15 Sep 2023 15:20:05 +0200
Message-ID: <20230915132014.37025-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Disallow enabling/disabling a table in a single transaction.
Make sure we still allow one update, either to dormant, or
from active to dormant.

Reported-by: "Lee, Cherie-Anne" <cherie.lee@starlabs.sg>
Cc: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Cc: info@starlabs.sg
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../transactions/dumps/table_onoff.nft        |  8 ++++
 .../shell/testcases/transactions/table_onoff  | 44 +++++++++++++++++++
 2 files changed, 52 insertions(+)
 create mode 100644 tests/shell/testcases/transactions/dumps/table_onoff.nft
 create mode 100755 tests/shell/testcases/transactions/table_onoff

diff --git a/tests/shell/testcases/transactions/dumps/table_onoff.nft b/tests/shell/testcases/transactions/dumps/table_onoff.nft
new file mode 100644
index 000000000000..038be1c071ad
--- /dev/null
+++ b/tests/shell/testcases/transactions/dumps/table_onoff.nft
@@ -0,0 +1,8 @@
+table ip t {
+	flags dormant
+
+	chain c {
+		type filter hook input priority filter; policy accept;
+		ip daddr 127.0.0.42 counter packets 0 bytes 0
+	}
+}
diff --git a/tests/shell/testcases/transactions/table_onoff b/tests/shell/testcases/transactions/table_onoff
new file mode 100755
index 000000000000..831d4614c1f2
--- /dev/null
+++ b/tests/shell/testcases/transactions/table_onoff
@@ -0,0 +1,44 @@
+#!/bin/bash
+
+# attempt to re-awaken a table that is flagged dormant within
+# same transaction
+$NFT -f - <<EOF
+add table ip t
+add table ip t { flags dormant; }
+add chain ip t c { type filter hook input priority 0; }
+add table ip t
+delete table ip t
+EOF
+
+if [ $? -eq 0 ]; then
+	exit 1
+fi
+
+set -e
+
+ip link set lo up
+
+# add a dormant table, then wake it up in same
+# transaction.
+$NFT -f - <<EOF
+add table ip t { flags dormant; }
+add chain ip t c { type filter hook input priority 0; }
+add rule ip t c ip daddr 127.0.0.42 counter
+add table ip t
+EOF
+
+# check table is indeed active.
+ping -c 1 127.0.0.42
+$NFT list chain ip t c | grep "counter packets 1"
+$NFT delete table ip t
+
+# allow to flag table dormant.
+$NFT -f - <<EOF
+add table ip t
+add chain ip t c { type filter hook input priority 0; }
+add rule ip t c ip daddr 127.0.0.42 counter
+add table ip t { flags dormant; }
+EOF
+
+ping -c 1 127.0.0.42
+# expect run-tests.sh to complain if counter isn't 0.
-- 
2.41.0

