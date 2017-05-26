From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] tests: py: flush stdout on each test run
Date: Fri, 26 May 2017 14:36:46 +0200
Message-ID: <1495802206-28856-2-git-send-email-pablo@netfilter.org>
References: <1495802206-28856-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48210 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965263AbdEZMhF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 May 2017 08:37:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0122C1DF5A1
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2017 14:36:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6248FB38B
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2017 14:36:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 623ECFB38B
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2017 14:36:54 +0200 (CEST)
In-Reply-To: <1495802206-28856-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Useful when redirecting output to file and tail -f it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/nft-test.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 8d1df3bc517a..c1da71aaf827 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -955,6 +955,8 @@ def run_test_file(filename, force_all_family_option, specific_file):
     tests = passed = total_unit_run = total_warning = total_error = 0
 
     for lineno, line in enumerate(f):
+        sys.stdout.flush()
+
         if signal_received == 1:
             print "\nSignal received. Cleaning up and Exitting..."
             cleanup_on_exit()
-- 
2.1.4

