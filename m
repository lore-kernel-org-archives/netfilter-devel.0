Return-Path: <SRS0=cCuT=32=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C300CC35247
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Feb 2020 00:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9878120658
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Feb 2020 00:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgBFA7I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Feb 2020 19:59:08 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:47704 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbgBFA7I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Feb 2020 19:59:08 -0500
Received: from localhost ([::1]:60794 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1izVVb-0000mJ-6N; Thu, 06 Feb 2020 01:59:07 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/4] tests: json_echo: Support testing host binaries
Date:   Thu,  6 Feb 2020 01:58:49 +0100
Message-Id: <20200206005851.28962-3-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200206005851.28962-1-phil@nwl.cc>
References: <20200206005851.28962-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Support -H/--host option to use host's libnftables.so.1. Alternatively
users may specify a custom library path via -l/--library option.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/json_echo/run-test.py | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/tests/json_echo/run-test.py b/tests/json_echo/run-test.py
index fa7d69ab75645..36a377ac95eec 100755
--- a/tests/json_echo/run-test.py
+++ b/tests/json_echo/run-test.py
@@ -4,6 +4,7 @@ from __future__ import print_function
 import sys
 import os
 import json
+import argparse
 
 TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
 sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))
@@ -13,12 +14,26 @@ from nftables import Nftables
 # Change working directory to repository root
 os.chdir(TESTS_PATH + "/../..")
 
-if not os.path.exists('src/.libs/libnftables.so'):
-    print("The nftables library does not exist. "
-          "You need to build the project.")
+parser = argparse.ArgumentParser(description='Run JSON echo tests')
+parser.add_argument('-H', '--host', action='store_true',
+                    help='Run tests against installed libnftables.so.1')
+parser.add_argument('-l', '--library', default=None,
+                    help='Path to libntables.so, overrides --host')
+args = parser.parse_args()
+
+check_lib_path = True
+if args.library is None:
+    if args.host:
+        args.library = 'libnftables.so.1'
+        check_lib_path = False
+    else:
+        args.library = 'src/.libs/libnftables.so.1'
+
+if check_lib_path and not os.path.exists(args.library):
+    print("Library not found at '%s'." % args.library)
     sys.exit(1)
 
-nftables = Nftables(sofile = 'src/.libs/libnftables.so')
+nftables = Nftables(sofile = args.library)
 nftables.set_echo_output(True)
 
 # various commands to work with
-- 
2.24.1

