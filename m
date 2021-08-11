Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21359C43216
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 20:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05F6C61058
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 20:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhHKUOu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 16:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbhHKUOt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 16:14:49 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3979EC061765
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Aug 2021 13:14:25 -0700 (PDT)
Received: from localhost ([::1]:55978 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mDucH-0003zb-4x; Wed, 11 Aug 2021 22:14:21 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] iptables-test: Make netns spawning more robust
Date:   Wed, 11 Aug 2021 22:14:20 +0200
Message-Id: <20210811201420.5996-1-phil@nwl.cc>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On systems without unshare Python module, try to call unshare binary
with oneself as parameters.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index ca5efb1b6670b..90e07feed3658 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -304,6 +304,31 @@ def show_missing():
 
     print('\n'.join(missing))
 
+def spawn_netns():
+    # prefer unshare module
+    try:
+        import unshare
+        unshare.unshare(unshare.CLONE_NEWNET)
+        return True
+    except:
+        pass
+
+    # sledgehammer style:
+    # - call ourselves prefixed by 'unshare -n' if found
+    # - pass extra --no-netns parameter to avoid another recursion
+    try:
+        import shutil
+
+        unshare = shutil.which("unshare")
+        if unshare is None:
+            return False
+
+        sys.argv.append("--no-netns")
+        os.execv(unshare, [unshare, "-n", sys.executable] + sys.argv)
+    except:
+        pass
+
+    return False
 
 #
 # main
@@ -323,6 +348,8 @@ def main():
                         help='Test iptables-over-nftables')
     parser.add_argument('-N', '--netns', action='store_true',
                         help='Test netnamespace path')
+    parser.add_argument('--no-netns', action='store_true',
+                        help='Do not run testsuite in own network namespace')
     args = parser.parse_args()
 
     #
@@ -341,6 +368,9 @@ def main():
         print("You need to be root to run this, sorry")
         return
 
+    if not args.netns and not args.no_netns and not spawn_netns():
+        print("Cannot run in own namespace, connectivity might break")
+
     if not args.host:
         os.putenv("XTABLES_LIBDIR", os.path.abspath(EXTENSIONS_PATH))
         os.putenv("PATH", "%s/iptables:%s" % (os.path.abspath(os.path.curdir),
@@ -366,13 +396,6 @@ def main():
                      if i.endswith('.t')]
         file_list.sort()
 
-    if not args.netns:
-        try:
-            import unshare
-            unshare.unshare(unshare.CLONE_NEWNET)
-        except:
-            print("Cannot run in own namespace, connectivity might break")
-
     for filename in file_list:
         file_tests, file_passed = run_test_file(filename, args.netns)
         if file_tests:
-- 
2.32.0

