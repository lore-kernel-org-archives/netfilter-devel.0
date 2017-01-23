From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft] tests: shell: Add test for flush bug on sets with size
Date: Mon, 23 Jan 2017 20:42:00 -0200
Message-ID: <20170123224159.GA19546@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34971 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751183AbdAWWmH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2017 17:42:07 -0500
Received: by mail-qt0-f194.google.com with SMTP id f4so20641317qte.2
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2017 14:42:06 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This tests for a bug where elements can't be added after flushing a
full set with the flag NFTNL_SET_DESC_SIZE set.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 tests/shell/testcases/sets/0017add_after_flush_0 | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0017add_after_flush_0

diff --git a/tests/shell/testcases/sets/0017add_after_flush_0 b/tests/shell/testcases/sets/0017add_after_flush_0
new file mode 100755
index 0000000..0390b03
--- /dev/null
+++ b/tests/shell/testcases/sets/0017add_after_flush_0
@@ -0,0 +1,12 @@
+#!/bin/bash
+
+# This tests for a bug where elements can't be added after flushing a
+# full set with the flag NFTNL_SET_DESC_SIZE set
+
+set -e
+$NFT add table x
+$NFT add set x s {type ipv4_addr\; size 2\;}
+$NFT add element x s {1.1.1.1}
+$NFT add element x s {1.1.1.2}
+$NFT flush set x s
+$NFT add element x s {1.1.1.1}
-- 
2.7.4

