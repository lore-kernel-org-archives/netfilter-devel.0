Return-Path: <SRS0=cUbz=XJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49068C49ED7
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Sep 2019 00:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2771920678
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Sep 2019 00:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388932AbfINAuy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 20:50:54 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:44786 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388072AbfINAuy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 20:50:54 -0400
Received: from localhost ([::1]:57876 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i8wH6-000604-SI; Sat, 14 Sep 2019 02:50:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] iptables-test: Support testing host binaries
Date:   Sat, 14 Sep 2019 02:50:45 +0200
Message-Id: <20190914005045.17421-1-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce --host parameter to run the testsuite against host's binaries
instead of built ones.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index dc5f0ead2f0eb..2aac8ef2256dc 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -314,6 +314,8 @@ def main():
     parser.add_argument('filename', nargs='?',
                         metavar='path/to/file.t',
                         help='Run only this test')
+    parser.add_argument('-H', '--host', action='store_true',
+                        help='Run tests against installed binaries')
     parser.add_argument('-l', '--legacy', action='store_true',
                         help='Test iptables-legacy')
     parser.add_argument('-m', '--missing', action='store_true',
@@ -340,8 +342,10 @@ def main():
         print("You need to be root to run this, sorry")
         return
 
-    os.putenv("XTABLES_LIBDIR", os.path.abspath(EXTENSIONS_PATH))
-    os.putenv("PATH", "%s/iptables:%s" % (os.path.abspath(os.path.curdir), os.getenv("PATH")))
+    if not args.host:
+        os.putenv("XTABLES_LIBDIR", os.path.abspath(EXTENSIONS_PATH))
+        os.putenv("PATH", "%s/iptables:%s" % (os.path.abspath(os.path.curdir),
+                                              os.getenv("PATH")))
 
     test_files = 0
     tests = 0
-- 
2.22.0

