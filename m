Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C78C47098
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 22:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3222A6140A
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 22:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhFCW76 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Jun 2021 18:59:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45826 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhFCW76 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 18:59:58 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3816E641FD
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Jun 2021 00:57:04 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables,v2 2/5] tests: xlate-test: support multiline expectation
Date:   Fri,  4 Jun 2021 00:58:03 +0200
Message-Id: <20210603225806.13625-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210603225806.13625-1-pablo@netfilter.org>
References: <20210603225806.13625-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend translation test to deal with multiline translation, e.g.

iptables-translate -A INPUT -m connlimit --connlimit-above 2
nft add set ip filter connlimit0 { type ipv4_addr; flags dynamic; }
nft add rule ip filter INPUT add @connlimit0 { ip saddr ct count over 2 } counter

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 xlate-test.py | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/xlate-test.py b/xlate-test.py
index 4c014f9bd269..cba98b6e8e49 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -39,14 +39,21 @@ def run_test(name, payload):
     tests = passed = failed = errors = 0
     result = []
 
-    for line in payload:
+    line = payload.readline()
+    while line:
         if line.startswith(keywords):
             tests += 1
             process = Popen([ xtables_nft_multi ] + shlex.split(line), stdout=PIPE, stderr=PIPE)
             (output, error) = process.communicate()
             if process.returncode == 0:
                 translation = output.decode("utf-8").rstrip(" \n")
-                expected = next(payload).rstrip(" \n")
+                expected = payload.readline().rstrip(" \n")
+                next_expected = payload.readline().rstrip(" \n")
+                if next_expected.startswith("nft"):
+                    expected += "\n" + next_expected
+                    line = payload.readline()
+                else:
+                    line = next_expected
                 if translation != expected:
                     test_passed = False
                     failed += 1
@@ -62,6 +69,9 @@ def run_test(name, payload):
                 errors += 1
                 result.append(name + ": " + red("Error: ") + "iptables-translate failure")
                 result.append(error.decode("utf-8"))
+                line = payload.readline()
+        else:
+                line = payload.readline()
     if (passed == tests) and not args.test:
         print(name + ": " + green("OK"))
     if not test_passed:
-- 
2.20.1

