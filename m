From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft 2/2] tests: regression: allow to run tests from anywhere
Date: Thu, 19 Nov 2015 19:51:49 +0100
Message-ID: <1447959109-17295-2-git-send-email-pablombg@gmail.com>
References: <1447959109-17295-1-git-send-email-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35396 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933081AbbKSSwL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Nov 2015 13:52:11 -0500
Received: by wmdw130 with SMTP id w130so252662767wmd.0
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2015 10:52:10 -0800 (PST)
In-Reply-To: <1447959109-17295-1-git-send-email-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since 357d8cf "tests: use the src/nft binary instead of $PATH one", the
tests script needs to be executed from nftables repository root. Now
the script can be run from any location and also checks the binary
existence.

To run a single test file, the path must be relative from the directory
where you launch the script.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 tests/regression/nft-test.py | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tests/regression/nft-test.py b/tests/regression/nft-test.py
index ed9653d..0b0be5d 100755
--- a/tests/regression/nft-test.py
+++ b/tests/regression/nft-test.py
@@ -20,7 +20,7 @@ import argparse
 import signal
 
 TERMINAL_PATH = os.getcwd()
-NFT_BIN = TERMINAL_PATH + "/src/nft"
+NFT_BIN = "src/nft"
 TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
 TESTS_DIRECTORY = ["any", "arp", "bridge", "inet", "ip", "ip6"]
 LOGFILE = "/tmp/nftables-test.log"
@@ -908,9 +908,11 @@ def main():
         print "You need to be root to run this, sorry"
         return
 
-    if not os.path.isdir("tests/regression/"):
-        print "You have to run nft-test.py from the repository root directory, eg.\n\n" + \
-            "    nftables# python tests/regression/nft-test.py\n"
+    # Change working directory to repository root
+    os.chdir(TESTS_PATH + "/../..")
+
+    if not os.path.isfile(NFT_BIN):
+        print "The nft binary does not exist. You need to build the project."
         return
 
     test_files = files_ok = run_total = 0
-- 
2.6.2

