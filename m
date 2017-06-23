From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH 1/2] tests: shell: Add test for incomplete set add set command
Date: Fri, 23 Jun 2017 17:35:55 +0530
Message-ID: <1498219556-25179-1-git-send-email-mayhs11saini@gmail.com>
Cc: Shyam Saini <mayhs11saini@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34730 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751230AbdFWMGY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Jun 2017 08:06:24 -0400
Received: by mail-pf0-f194.google.com with SMTP id d5so7072850pfe.1
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jun 2017 05:06:23 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Before the [Test] commit if we run nft with incomplete "add set"
command it caused segmentation fault and exit with error code 139 and
further it didn't throw any error message.

  For example:
    $ sudo nft add set t s

But after the [Test] commit it throws syntax error message and exits with
return value 1.

  For example:
    $ sudo nft add set t s
    <cmdline>:1:12-12: Error: syntax error, unexpected newline, expecting '{'
    add set t s
               ^

This commit tests changes made in the [Test] commit.

Test:c6cd7c22548a ( "src: fix crash when inputting an incomplete set add
command" )
Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 .../testcases/sets/0023incomplete_add_set_command_0      | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0023incomplete_add_set_command_0

diff --git a/tests/shell/testcases/sets/0023incomplete_add_set_command_0 b/tests/shell/testcases/sets/0023incomplete_add_set_command_0
new file mode 100755
index 000000000000..b7535f7059db
--- /dev/null
+++ b/tests/shell/testcases/sets/0023incomplete_add_set_command_0
@@ -0,0 +1,16 @@
+#!/bin/bash
+
+# This testscase checks bug identified and fixed in the commit Id "c6cd7c22548a"
+# Before the commit c6cd7c22548a, nft returns 139 (i.e, segmentation fault) which
+# indicates the bug but after the commit it returns 1.
+
+$NFT add table t
+$NFT add set t c
+
+ret=$?
+if [ $ret -ne 1 ] ;
+then
+	echo "E: returned $ret instead of 1" >&2
+	exit 1
+fi
+
-- 
1.9.1

