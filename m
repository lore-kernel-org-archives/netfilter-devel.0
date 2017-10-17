From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] tests: xlate: print tests passed or error for testfile argument
Date: Tue, 17 Oct 2017 13:39:03 +0530
Message-ID: <20171017080903.15719-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:44083 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759243AbdJQIL3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 04:11:29 -0400
Received: by mail-pg0-f68.google.com with SMTP id j3so827947pga.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 01:11:29 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Print tests passed with errors and warnings when run with only specified
test file.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 xlate-test.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/xlate-test.py b/xlate-test.py
index 43c4be19..b7a053f9 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -51,7 +51,7 @@ def run_test(name, payload):
                     result.append(magenta("exp: ") + expected)
                     result.append(magenta("res: ") + translation + "\n")
                     test_passed = False
-                elif args.all:
+                elif args.all or args.test:
                     result.append(green("Ok"))
                     result.append(magenta("src: ") + line.rstrip(" \n"))
                     result.append(magenta("res: ") + translation + "\n")
@@ -60,7 +60,7 @@ def run_test(name, payload):
                 result.append(red("Error: ") + "iptables-translate failure")
                 result.append(error.decode("utf-8"))
 
-    if not test_passed or args.all:
+    if args.all or args.test:
         print("\n".join(result))
 
 
-- 
2.11.0

