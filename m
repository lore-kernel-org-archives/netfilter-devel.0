From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH] tests: py: Fail test forcefully when bug is not fixed
Date: Wed, 21 Jun 2017 14:17:45 +0530
Message-ID: <1498034865-11321-1-git-send-email-mayhs11saini@gmail.com>
Cc: Shyam Saini <mayhs11saini@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34799 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752413AbdFUIsl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2017 04:48:41 -0400
Received: by mail-pf0-f170.google.com with SMTP id s66so81840700pfs.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2017 01:48:40 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

when we have "fail" in the test cases then py test doesn't complain
anything, but the test should complain if the fix is not applied.

Before applying the [Test] commit, nft throws following error message
and exits with error code 134.
$ nft add rule x y tcp dport set { 0 , 1 }
    BUG: unknown expression type set reference
    nft: netlink_linearize.c:696: netlink_gen_expr: Assertion `0' failed.
    Aborted

This commit enforces nft-test.py to throw error message when the fix
is not applied.

Test:986dea8a4a9d ("evaluate: avoid reference to multiple src data in
statements which set values")
Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 tests/py/nft-test.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index c1da71aaf827..8d099a15aaf8 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -702,7 +702,7 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
             ret = execute_cmd(cmd, filename, lineno, payload_log)
 
             state = rule[1].rstrip()
-            if (ret == 0 and state == "fail") or (ret != 0 and state == "ok"):
+            if (ret in [0,134] and state == "fail") or (ret != 0 and state == "ok"):
                 if state == "fail":
                     test_state = "This rule should have failed."
                 else:
-- 
1.9.1

