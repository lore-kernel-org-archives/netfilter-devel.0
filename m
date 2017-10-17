From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH v2] tests: xlate: print tests passed and error for testfile argument
Date: Tue, 17 Oct 2017 14:54:58 +0530
Message-ID: <20171017092458.18672-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:57080 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753154AbdJQJ1O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 05:27:14 -0400
Received: by mail-pf0-f195.google.com with SMTP id b85so917794pfj.13
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 02:27:14 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Print tests passed with errors and warnings when run with only specified
test file.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
Changes in v2:
 -Change subject
 -print the errors if no argument is passed

 xlate-test.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/xlate-test.py b/xlate-test.py
index 43c4be19..0a582af1 100755
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
+    if not test_passed or args.all or args.test:
         print("\n".join(result))
 
 
-- 
2.11.0

