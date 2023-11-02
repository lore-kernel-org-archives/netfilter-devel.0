Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C10C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 14:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjKBOeY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 10:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjKBOeY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 10:34:24 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D3C12F
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 07:34:21 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qyYm4-000861-2H; Thu, 02 Nov 2023 15:34:20 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: meta: test hour decoding wrap
Date:   Thu,  2 Nov 2023 15:34:13 +0100
Message-ID: <20231102143416.179305-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a test case for
"meta: fix hour decoding when timezone offset is negative".

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/listing/dumps/meta_time.nodump  |  0
 tests/shell/testcases/listing/meta_time       | 52 +++++++++++++++++++
 2 files changed, 52 insertions(+)
 create mode 100644 tests/shell/testcases/listing/dumps/meta_time.nodump
 create mode 100755 tests/shell/testcases/listing/meta_time

diff --git a/tests/shell/testcases/listing/dumps/meta_time.nodump b/tests/shell/testcases/listing/dumps/meta_time.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/listing/meta_time b/tests/shell/testcases/listing/meta_time
new file mode 100755
index 000000000000..a97619989986
--- /dev/null
+++ b/tests/shell/testcases/listing/meta_time
@@ -0,0 +1,52 @@
+#!/bin/bash
+
+set -e
+
+TMP1=$(mktemp)
+TMP2=$(mktemp)
+
+cleanup()
+{
+	rm -f "$TMP1"
+	rm -f "$TMP2"
+}
+
+check_decode()
+{
+	TZ=$1 $NFT list chain t c | grep meta > "$TMP2"
+	diff -u "$TMP1" "$TMP2"
+}
+
+trap cleanup EXIT
+
+$NFT -f - <<EOF
+table t {
+	chain c {
+	}
+}
+EOF
+
+for i in $(seq -w 0 23); do
+	TZ=UTC $NFT add rule t c meta hour "$i:00"-"$i:59"
+done
+
+# Check decoding in UTC, this mirrors 1:1 what should have been added.
+for i in $(seq 0 23); do
+	printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" $i 0 $i 59 >> "$TMP1"
+done
+
+check_decode UTC
+
+printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" 23 0 23 59 > "$TMP1"
+for i in $(seq 0 22); do
+	printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" $i 0 $i 59 >> "$TMP1"
+done
+check_decode UTC+1
+
+printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" 1 0 1 59 > "$TMP1"
+for i in $(seq 2 23); do
+	printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" $i 0 $i 59 >> "$TMP1"
+done
+printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" 0 0 0 59 >> "$TMP1"
+
+check_decode UTC-1
-- 
2.41.0

