Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8461DC001B0
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jul 2023 08:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbjGDIeB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Jul 2023 04:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbjGDIdX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Jul 2023 04:33:23 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1C84FC
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Jul 2023 01:33:22 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: refcount memleak in map rhs with timeouts
Date:   Tue,  4 Jul 2023 10:33:05 +0200
Message-Id: <20230704083305.6399-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230704083305.6399-1-pablo@netfilter.org>
References: <20230704083305.6399-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend coverage for refcount leaks on map element expiration.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../testcases/maps/0018map_leak_timeout_0     | 48 +++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100755 tests/shell/testcases/maps/0018map_leak_timeout_0

diff --git a/tests/shell/testcases/maps/0018map_leak_timeout_0 b/tests/shell/testcases/maps/0018map_leak_timeout_0
new file mode 100755
index 000000000000..5a07ec7477d9
--- /dev/null
+++ b/tests/shell/testcases/maps/0018map_leak_timeout_0
@@ -0,0 +1,48 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip t {
+        map sourcemap {
+                type ipv4_addr : verdict
+                timeout 3s
+                elements = { 100.123.10.2 : jump c }
+        }
+
+        chain c {
+        }
+}"
+
+$NFT -f - <<< "$RULESET"
+# again, since it is addition, not creation, it is successful
+$NFT -f - <<< "$RULESET"
+
+# wait for elements to expire
+sleep 5
+
+# flush it to check for refcount leak
+$NFT flush ruleset
+
+#
+# again with stateful objects
+#
+
+RULESET="table ip t {
+	counter c {}
+
+        map sourcemap {
+                type ipv4_addr : counter
+                timeout 3s
+                elements = { 100.123.10.2 : \"c\" }
+        }
+}"
+
+$NFT -f - <<< "$RULESET"
+# again, since it is addition, not creation, it is successful
+$NFT -f - <<< "$RULESET"
+# flush it to check for refcount leak
+
+# wait for elements to expire
+sleep 5
+
+$NFT flush ruleset
-- 
2.30.2

