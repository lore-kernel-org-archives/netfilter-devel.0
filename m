From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables 2/2] tests: xlate: check if it is being run as root
Date: Wed, 19 Apr 2017 01:19:09 +0200
Message-ID: <1492557549-578-2-git-send-email-pablombg@gmail.com>
References: <1492557549-578-1-git-send-email-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35397 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937138AbdDSQCE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 12:02:04 -0400
Received: by mail-wm0-f46.google.com with SMTP id w64so84124875wma.0
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 09:02:03 -0700 (PDT)
In-Reply-To: <1492557549-578-1-git-send-email-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 xlate-test.py | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/xlate-test.py b/xlate-test.py
index 37760e9..43c4be1 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -72,7 +72,9 @@ def load_test_files():
 
 
 def main():
-    if args.test:
+    if os.getuid() != 0:
+        print(red("Error: ") + "You need to be root to run this, sorry")
+    elif args.test:
         if not args.test.endswith(".txlate"):
             args.test += ".txlate"
         try:
-- 
2.1.4

