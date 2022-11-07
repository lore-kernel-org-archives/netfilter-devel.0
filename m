Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD837C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Nov 2022 13:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiKGNJO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Nov 2022 08:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiKGNJN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Nov 2022 08:09:13 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B843D193C6
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Nov 2022 05:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6pvFJdiNWT1RBP0ZQ/eMLP8tWbKSaWksdr/0Iy0oGAk=; b=ms2xeYU5Gzhpe8iKz2QbpnHSFk
        nHUWL15kJgCNC0f/Ty9MxdFvUqzW48lJ1vD/4jBYseuGpYTgVmkgH2G1YjC7j3T+43JkifuSneOAB
        BG58xhxPZvJS8OkczDlIjRiSs3FmCGNjIyrlK+sqSB+xi/1/sASjd97kQd6PifLmH2cAR1Fx02M9X
        mAHq2znHs8vT6wT4YYmudp4Ci3e3FnmGOhLO+PpoEgtDLJHgfsk23OGyVMAuStfe2kSOBLzDcFb3O
        72VQ9yTWs5dDOpJMf5OfSrNU4tByXPlBOZftP4MvYKm10PUf0ZhDCb7qz8uoBEv6/+2lLG0MAHnuA
        SCK0BByA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1os1sD-0002i6-Ai
        for netfilter-devel@vger.kernel.org; Mon, 07 Nov 2022 14:09:09 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/3] tests: xlate-test: Cleanup file reading loop
Date:   Mon,  7 Nov 2022 14:08:41 +0100
Message-Id: <20221107130843.8024-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221107130843.8024-1-phil@nwl.cc>
References: <20221107130843.8024-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Put the actual translation test into a function to call from the loop
and clean it up a bit. Preparation work for running a second test on the
same data.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 xlate-test.py | 67 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 30 deletions(-)

diff --git a/xlate-test.py b/xlate-test.py
index 03bef7e2e5934..ee393349da50d 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -33,6 +33,24 @@ xtables_nft_multi = 'xtables-nft-multi'
     return colors["green"] + string + colors["end"]
 
 
+def test_one_xlate(name, sourceline, expected, result):
+    process = Popen([ xtables_nft_multi ] + shlex.split(sourceline), stdout=PIPE, stderr=PIPE)
+    (output, error) = process.communicate()
+    if process.returncode != 0:
+        result.append(name + ": " + red("Error: ") + "iptables-translate failure")
+        result.append(error.decode("utf-8"))
+        return False
+
+    translation = output.decode("utf-8").rstrip(" \n")
+    if translation != expected:
+        result.append(name + ": " + red("Fail"))
+        result.append(magenta("src: ") + sourceline.rstrip(" \n"))
+        result.append(magenta("exp: ") + expected)
+        result.append(magenta("res: ") + translation + "\n")
+        return False
+
+    return True
+
 def run_test(name, payload):
     global xtables_nft_multi
     test_passed = True
@@ -41,37 +59,26 @@ xtables_nft_multi = 'xtables-nft-multi'
 
     line = payload.readline()
     while line:
-        if line.startswith(keywords):
-            sourceline = line
-            tests += 1
-            process = Popen([ xtables_nft_multi ] + shlex.split(line), stdout=PIPE, stderr=PIPE)
-            (output, error) = process.communicate()
-            if process.returncode == 0:
-                translation = output.decode("utf-8").rstrip(" \n")
-                expected = payload.readline().rstrip(" \n")
-                next_expected = payload.readline()
-                if next_expected.startswith("nft"):
-                    expected += "\n" + next_expected.rstrip(" \n")
-                    line = payload.readline()
-                else:
-                    line = next_expected
-                if translation != expected:
-                    test_passed = False
-                    failed += 1
-                    result.append(name + ": " + red("Fail"))
-                    result.append(magenta("src: ") + sourceline.rstrip(" \n"))
-                    result.append(magenta("exp: ") + expected)
-                    result.append(magenta("res: ") + translation + "\n")
-                else:
-                    passed += 1
-            else:
-                test_passed = False
-                errors += 1
-                result.append(name + ": " + red("Error: ") + "iptables-translate failure")
-                result.append(error.decode("utf-8"))
-                line = payload.readline()
+        if not line.startswith(keywords):
+            line = payload.readline()
+            continue
+
+        sourceline = line
+        expected = payload.readline().rstrip(" \n")
+        next_expected = payload.readline()
+        if next_expected.startswith("nft"):
+            expected += "\n" + next_expected.rstrip(" \n")
+            line = payload.readline()
+        else:
+            line = next_expected
+
+        tests += 1
+        if test_one_xlate(name, sourceline, expected, result):
+            passed += 1
         else:
-                line = payload.readline()
+            errors += 1
+            test_passed = False
+
     if (passed == tests) and not args.test:
         print(name + ": " + green("OK"))
     if not test_passed:
-- 
2.38.0

