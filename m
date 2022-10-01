Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58685C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Oct 2022 09:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiJAJnt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Oct 2022 05:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiJAJni (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Oct 2022 05:43:38 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD2A3AE6C
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Oct 2022 02:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PpAi7T3b/eDmJA+kFuCkKL6ArAQU+YhtqlpGCX2AcDs=; b=FIBlYqjlHP8HBpPxgwfRcsyPNi
        XYoXeSiO1iHq8XbgPBFdroDE95eHx6f+vrBPB3OwN3jxGNSjsAyL3CUFqK0/zZCDB8vfJTm+9ENWv
        5xjZsJskOj8sFm120DKclAub3VmDCi3ljeAvA0/WJBR9cHb77LRdxNnvxuMQMzS2i0k1dKQjhWXx5
        6cdGY2Z0lYb5n6BA9sXRQagw/RBjBbJQVuIzZFBR8S5kt3YTVuHHXn5JEcAC76fkXDwNze+iZS7zh
        eSVV4HuIX+Wmmkzp5LvZ9qK/nn/ERiC+Te3Zfm0W6jA7fbxyTmWpMjW66vpyBgAM3QqTL1HnIMjUA
        N0HOLsfw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oeZ1z-0006RZ-5i
        for netfilter-devel@vger.kernel.org; Sat, 01 Oct 2022 11:43:35 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/4] tests: iptables-test: Simplify '-N' option a bit
Date:   Sat,  1 Oct 2022 11:43:07 +0200
Message-Id: <20221001094310.29452-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221001094310.29452-1-phil@nwl.cc>
References: <20221001094310.29452-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of hard-coding, store the netns name in args.netns if the flag
was given. The value defaults to None, so existing 'if netns' checks are
still valid.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 6acaa82228fa3..69c96b79927b5 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -79,12 +79,13 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
     :param res: expected result of the rule. Valid values: "OK", "FAIL"
     :param filename: name of the file tested (used for print_error purposes)
     :param lineno: line number being tested (used for print_error purposes)
+    :param netns: network namespace to call commands in (or None)
     '''
     ret = 0
 
     cmd = iptables + " -A " + rule
     if netns:
-            cmd = "ip netns exec ____iptables-container-test " + EXECUTABLE + " " + cmd
+            cmd = "ip netns exec " + netns + " " + EXECUTABLE + " " + cmd
 
     ret = execute_cmd(cmd, filename, lineno)
 
@@ -126,7 +127,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
     command = EXECUTABLE + " " + command
 
     if netns:
-            command = "ip netns exec ____iptables-container-test " + command
+            command = "ip netns exec " + netns + " " + command
 
     args = tokens[1:]
     proc = subprocess.Popen(command, shell=True,
@@ -226,6 +227,7 @@ def run_test_file(filename, netns):
     Runs a test file
 
     :param filename: name of the file with the test rules
+    :param netns: network namespace to perform test run in
     '''
     #
     # if this is not a test file, skip.
@@ -262,7 +264,7 @@ def run_test_file(filename, netns):
     total_test_passed = True
 
     if netns:
-        execute_cmd("ip netns add ____iptables-container-test", filename, 0)
+        execute_cmd("ip netns add " + netns, filename, 0)
 
     for lineno, line in enumerate(f):
         if line[0] == "#" or len(line.strip()) == 0:
@@ -276,7 +278,7 @@ def run_test_file(filename, netns):
         if line[0] == "@":
             external_cmd = line.rstrip()[1:]
             if netns:
-                external_cmd = "ip netns exec ____iptables-container-test " + external_cmd
+                external_cmd = "ip netns exec " + netns + " " + external_cmd
             execute_cmd(external_cmd, filename, lineno)
             continue
 
@@ -284,7 +286,7 @@ def run_test_file(filename, netns):
         if line[0] == "%":
             external_cmd = line.rstrip()[1:]
             if netns:
-                external_cmd = "ip netns exec ____iptables-container-test " + EXECUTABLE + " " + external_cmd
+                external_cmd = "ip netns exec " + netns + " " + EXECUTABLE + " " + external_cmd
             execute_cmd(external_cmd, filename, lineno)
             continue
 
@@ -334,7 +336,7 @@ def run_test_file(filename, netns):
             passed += 1
 
     if netns:
-        execute_cmd("ip netns del ____iptables-container-test", filename, 0)
+        execute_cmd("ip netns del " + netns, filename, 0)
     if total_test_passed:
         print(filename + ": " + maybe_colored('green', "OK", STDOUT_IS_TTY))
 
@@ -400,7 +402,8 @@ def main():
                         help='Check for missing tests')
     parser.add_argument('-n', '--nftables', action='store_true',
                         help='Test iptables-over-nftables')
-    parser.add_argument('-N', '--netns', action='store_true',
+    parser.add_argument('-N', '--netns', action='store_const',
+                        const='____iptables-container-test',
                         help='Test netnamespace path')
     parser.add_argument('--no-netns', action='store_true',
                         help='Do not run testsuite in own network namespace')
-- 
2.34.1

