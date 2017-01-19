From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft] tests: shell: Add test for set element leak bug
Date: Thu, 19 Jan 2017 14:29:47 -0200
Message-ID: <20170119162947.GA6924@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:35379 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751502AbdASQ3z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Jan 2017 11:29:55 -0500
Received: by mail-yw0-f195.google.com with SMTP id 17so4979422ywk.2
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jan 2017 08:29:54 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This tests for a bug where a repeated element is added and the set
elements counter is incorrectly increased.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 tests/shell/testcases/sets/0016element_leak_0 | 11 +++++++++++
 1 file changed, 11 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0016element_leak_0

diff --git a/tests/shell/testcases/sets/0016element_leak_0 b/tests/shell/testcases/sets/0016element_leak_0
new file mode 100755
index 0000000..5675db3
--- /dev/null
+++ b/tests/shell/testcases/sets/0016element_leak_0
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+# This tests for a bug where a repeated element is added and the set
+# elements counter is incorrectly increased.
+
+set -e
+$NFT add table x
+$NFT add set x s {type ipv4_addr\; size 2\;}
+$NFT add element x s {1.1.1.1}
+$NFT add element x s {1.1.1.1}
+$NFT add element x s {1.1.1.1}
-- 
2.7.4

