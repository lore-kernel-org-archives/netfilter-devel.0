From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] tests: xlate: Change testfile to take "extensions/test_file" as argument
Date: Thu, 19 Oct 2017 18:18:29 +0530
Message-ID: <20171019124829.11557-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:46733 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbdJSMs5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2017 08:48:57 -0400
Received: by mail-pf0-f193.google.com with SMTP id p87so6524921pfj.3
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2017 05:48:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When executing xlate-test.py with specified test file, give
"extensions/test_file.txlate" as argument

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 xlate-test.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/xlate-test.py b/xlate-test.py
index 43c4be19..860d94d0 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -78,7 +78,7 @@ def main():
         if not args.test.endswith(".txlate"):
             args.test += ".txlate"
         try:
-            with open("extensions/" + args.test, "r") as payload:
+            with open(args.test, "r") as payload:
                 run_test(args.test, payload)
         except IOError:
             print(red("Error: ") + "test file does not exist")
-- 
2.11.0

