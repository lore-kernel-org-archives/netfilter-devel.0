Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA73C43217
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Feb 2022 16:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbiBLQ7C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Feb 2022 11:59:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236990AbiBLQ7B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Feb 2022 11:59:01 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D31240A2
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Feb 2022 08:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tSpSA2CSZZ2WS3w43JQsa9XjbAdnHzjIr7hquOnvs9k=; b=O1DReF4C+Fiy0whIYxX7D6DJEJ
        RindlK7gqq4O38m8E5Q8PUGR61VVYPG4yYzZl64Zrij62Pp9y6sAuXXiorRZmuzkcsI8iu9pguEYz
        GWZvge57nkcRLBdrYjHijoQnO2MpO5MmOVBdtxVDG5TptQdhz1sX5uSA/glRWk3JrJnoxe5F/nQcz
        hVNMgTgdAYkONoCldL9MusEi8kdUuGW2NZRCQQ60JSPEL2riwSODkcj/JDct+rpCyt8qrl7FJyGqV
        Ndkdz60nAD7DmTGCkf+dzukNhi6YGRwqpD9RQ/xWiyWKIGAZ2gUS8FPfVAYG1CUCVMyE3Fhrj63Vb
        quLTH/Sg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nIvjZ-001xVU-CP
        for netfilter-devel@vger.kernel.org; Sat, 12 Feb 2022 16:58:53 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [iptables PATCH 2/4] tests: add `NOMATCH` test result
Date:   Sat, 12 Feb 2022 16:58:30 +0000
Message-Id: <20220212165832.2452695-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220212165832.2452695-1-jeremy@azazel.net>
References: <20220212165832.2452695-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently, there are two supported test results: `OK` and `FAIL`.  It is
expected that either the iptables command fails, or it succeeds and
dumping the rule has the correct output.  However, it is possible that
the command may succeed but the output may not be correct.  Add a
`NOMATCH` result to cover this outcome.

Make a few white-space improvements at the same time.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables-test.py | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 91c77e3dc0e0..4a587a29c823 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -73,9 +73,9 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
     Executes an unit test. Returns the output of delete_rule().
 
     Parameters:
-    :param  iptables: string with the iptables command to execute
+    :param iptables: string with the iptables command to execute
     :param rule: string with iptables arguments for the rule to test
-    :param rule_save: string to find the rule in the output of iptables -save
+    :param rule_save: string to find the rule in the output of iptables-save
     :param res: expected result of the rule. Valid values: "OK", "FAIL"
     :param filename: name of the file tested (used for print_error purposes)
     :param lineno: line number being tested (used for print_error purposes)
@@ -92,7 +92,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
     # report failed test
     #
     if ret:
-        if res == "OK":
+        if res != "FAIL":
             reason = "cannot load: " + cmd
             print_error(reason, filename, lineno)
             return -1
@@ -146,10 +146,20 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
     # find the rule
     matching = out.find(rule_save.encode('utf-8'))
     if matching < 0:
-        reason = "cannot find: " + iptables + " -I " + rule
-        print_error(reason, filename, lineno)
-        delete_rule(iptables, rule, filename, lineno)
-        return -1
+        if res == "OK":
+            reason = "cannot find: " + iptables + " -I " + rule
+            print_error(reason, filename, lineno)
+            delete_rule(iptables, rule, filename, lineno)
+            return -1
+        else:
+            # do not report this error
+            return 0
+    else:
+        if res != "OK":
+            reason = "should not match: " + cmd
+            print_error(reason, filename, lineno)
+            delete_rule(iptables, rule, filename, lineno)
+            return -1
 
     # Test "ip netns del NETNS" path with rules in place
     if netns:
@@ -190,14 +200,18 @@ def variant_res(res, variant):
     result. Therefore map @res to itself if given variant is current, invert it
     otherwise.
 
-    :param res: expected result from test spec ("OK" or "FAIL")
+    :param res: expected result from test spec ("OK", "FAIL" or "NOMATCH")
     :param variant: variant @res is scoped to by test spec ("NFT" or "LEGACY")
     '''
     variant_executable = {
-            "NFT": "xtables-nft-multi",
-            "LEGACY": "xtables-legacy-multi"
+        "NFT": "xtables-nft-multi",
+        "LEGACY": "xtables-legacy-multi"
+    }
+    res_inverse = {
+        "OK": "FAIL",
+        "FAIL": "OK",
+        "NOMATCH": "OK"
     }
-    res_inverse = { "OK": "FAIL", "FAIL": "OK" }
 
     if variant_executable[variant] == EXECUTABLE:
         return res
-- 
2.34.1

