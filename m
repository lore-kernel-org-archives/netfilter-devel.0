Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6999EC43219
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Oct 2022 09:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiJAJnu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Oct 2022 05:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiJAJnd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Oct 2022 05:43:33 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE56211C0A
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Oct 2022 02:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AqnHigiScyAjSCYU0NqfDrDbH7iIlXaUJgnDjrhjSJY=; b=CvkbmdFQaqq0xrfCXFp7gnOORF
        dGuihXnaq/GxZ4UOH4fK1jssgjOLjajrREcjR5oKu+XyusLyXmTTLgL7Hnpx2lMq28HuBZIaoTXxg
        eQrDHNBOhHAJBtckN5ail0n3QnwwaQeg3zi2iHGm9e+ClXR3ocA9ZiDPjDRTcio4XdcLNcm3QusIm
        TjPku4lvSC9tfATyNOndhi5xqyWv1FZwdj+NVhsLLqa7pgG7IubljWX1VxrDBNcjHRkS+hIZppPXK
        eO1Uplzjt1b88zCM24+QsgW0zkShW72fvXQ4aN9ZCd6/B27l0vtqcsGL73d94sySdreHJwLHqw1Rp
        rEZKWRNA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oeZ1t-0006RU-S5
        for netfilter-devel@vger.kernel.org; Sat, 01 Oct 2022 11:43:29 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/4] tests: iptables-test: Pass netns to execute_cmd()
Date:   Sat,  1 Oct 2022 11:43:09 +0200
Message-Id: <20221001094310.29452-4-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221001094310.29452-1-phil@nwl.cc>
References: <20221001094310.29452-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The command to run might have to be prefixed. Once if the command is
'iptables' (or related) to define the variant, once if '-N' was given to
run the command inside the netns. Doing both prefixing inside
execute_cmd() avoids a potential conflict and thus simplifies things:
The "external command" and "external iptables call" lines become
identical in handling, there is no need for a separate prefix char
anymore.

As a side-effect, this commit also fixes for delete_rule() calls in
error case ignoring the netns value.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 25561bc9ba971..6504b231666d1 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -54,12 +54,12 @@ def print_error(reason, filename=None, lineno=None):
         ": line %d (%s)" % (lineno, reason), file=sys.stderr)
 
 
-def delete_rule(iptables, rule, filename, lineno):
+def delete_rule(iptables, rule, filename, lineno, netns = None):
     '''
     Removes an iptables rule
     '''
     cmd = iptables + " -D " + rule
-    ret = execute_cmd(cmd, filename, lineno)
+    ret = execute_cmd(cmd, filename, lineno, netns)
     if ret == 1:
         reason = "cannot delete: " + iptables + " -I " + rule
         print_error(reason, filename, lineno)
@@ -84,10 +84,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
     ret = 0
 
     cmd = iptables + " -A " + rule
-    if netns:
-            cmd = "ip netns exec " + netns + " " + EXECUTABLE + " " + cmd
-
-    ret = execute_cmd(cmd, filename, lineno)
+    ret = execute_cmd(cmd, filename, lineno, netns)
 
     #
     # report failed test
@@ -104,7 +101,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
         if res == "FAIL":
             reason = "should fail: " + cmd
             print_error(reason, filename, lineno)
-            delete_rule(iptables, rule, filename, lineno)
+            delete_rule(iptables, rule, filename, lineno, netns)
             return -1
 
     matching = 0
@@ -141,7 +138,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
     if proc.returncode == -11:
         reason = "iptables-save segfaults: " + cmd
         print_error(reason, filename, lineno)
-        delete_rule(iptables, rule, filename, lineno)
+        delete_rule(iptables, rule, filename, lineno, netns)
         return -1
 
     # find the rule
@@ -150,7 +147,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
         if res == "OK":
             reason = "cannot find: " + iptables + " -I " + rule
             print_error(reason, filename, lineno)
-            delete_rule(iptables, rule, filename, lineno)
+            delete_rule(iptables, rule, filename, lineno, netns)
             return -1
         else:
             # do not report this error
@@ -159,7 +156,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
         if res != "OK":
             reason = "should not match: " + cmd
             print_error(reason, filename, lineno)
-            delete_rule(iptables, rule, filename, lineno)
+            delete_rule(iptables, rule, filename, lineno, netns)
             return -1
 
     # Test "ip netns del NETNS" path with rules in place
@@ -168,7 +165,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
 
     return delete_rule(iptables, rule, filename, lineno)
 
-def execute_cmd(cmd, filename, lineno = 0):
+def execute_cmd(cmd, filename, lineno = 0, netns = None):
     '''
     Executes a command, checking for segfaults and returning the command exit
     code.
@@ -176,11 +173,15 @@ def execute_cmd(cmd, filename, lineno = 0):
     :param cmd: string with the command to be executed
     :param filename: name of the file tested (used for print_error purposes)
     :param lineno: line number being tested (used for print_error purposes)
+    :param netns: network namespace to run command in
     '''
     global log_file
     if cmd.startswith('iptables ') or cmd.startswith('ip6tables ') or cmd.startswith('ebtables ') or cmd.startswith('arptables '):
         cmd = EXECUTABLE + " " + cmd
 
+    if netns:
+        cmd = "ip netns exec " + netns + " " + cmd
+
     print("command: {}".format(cmd), file=log_file)
     ret = subprocess.call(cmd, shell=True, universal_newlines=True,
         stderr=subprocess.STDOUT, stdout=log_file)
@@ -274,20 +275,11 @@ def run_test_file(filename, netns):
             chain_array = line.rstrip()[1:].split(",")
             continue
 
-        # external non-iptables invocation, executed as is.
-        if line[0] == "@":
-            external_cmd = line.rstrip()[1:]
-            if netns:
-                external_cmd = "ip netns exec " + netns + " " + external_cmd
-            execute_cmd(external_cmd, filename, lineno)
-            continue
-
-        # external iptables invocation, executed as is.
-        if line[0] == "%":
+        # external command invocation, executed as is.
+        # detects iptables commands to prefix with EXECUTABLE automatically
+        if line[0] in ["@", "%"]:
             external_cmd = line.rstrip()[1:]
-            if netns:
-                external_cmd = "ip netns exec " + netns + " " + EXECUTABLE + " " + external_cmd
-            execute_cmd(external_cmd, filename, lineno)
+            execute_cmd(external_cmd, filename, lineno, netns)
             continue
 
         if line[0] == "*":
-- 
2.34.1

