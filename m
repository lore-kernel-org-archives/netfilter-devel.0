Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70650C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 00:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJFA2j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 20:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiJFA23 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 20:28:29 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2072782D26
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 17:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HMHhCs+yNQ7ZyezM/8XYxtjcq7CHsjY2M0KAQES3QXc=; b=WBCC+LpFPb1ZXluNu56nPX5Kc6
        +Eky0nDxUq1O1sWeI8M8B66Br9zQhLjoGLCdMHTuslgU2H2XcSb0GYku+KxEo2yiuaPw1rQLMvoWy
        izHEjCL5u/mzzbT1jBBa0grxFGGpGrKy7SNiOkZIk6x1XizkpCXSZ7l8UFZa9dfc4A5E5kbKrYOzk
        nzLL3kCFNT2RFIOAIGXMQBJamnB+1fO5Dvxj/+hXcPmYt03WoTaTTnI8fFqTWnGNwe1N7tc/tYW/0
        Z/2jeGCB1HvMFuwB/WDwQH+aQj+lljomw2weui5r0CN3slgDgaOqexWA0728HDp9Tix4GErQoai1h
        EPA8/ekw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ogEkP-0001wj-S3; Thu, 06 Oct 2022 02:28:21 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 01/12] tests: iptables-test: Implement fast test mode
Date:   Thu,  6 Oct 2022 02:27:51 +0200
Message-Id: <20221006002802.4917-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221006002802.4917-1-phil@nwl.cc>
References: <20221006002802.4917-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Implement a faster mode of operation for suitable test files:

1) Collect all rules to add and all expected output in lists
2) Any supposedly failing rules are checked immediately like in slow
   mode.
3) Create and load iptables-restore input from the list in (1)
5) Construct the expected iptables-save output from (1) and check it in
   a single search
5) If any of the steps above fail, fall back to slow mode for
   verification and detailed error analysis. Fast mode failures are not
   fatal, merely warn about them.

To keep things simple (and feasible), avoid complicated test files
involving external commands, multiple tables or variant-specific
results.

Aside from speeding up testsuite run-time, rule searching has become
more strict since EOL char is practically part of the search string.
This revealed many false positives where the expected string was
actually a substring of the printed rule.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 197 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 196 insertions(+), 1 deletion(-)

diff --git a/iptables-test.py b/iptables-test.py
index b5a70e44b9e44..89220f29fe552 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -28,6 +28,11 @@ EBTABLES_SAVE = "ebtables-save"
 #IPTABLES_SAVE = ['xtables-save','-4']
 #IP6TABLES_SAVE = ['xtables-save','-6']
 
+IPTABLES_RESTORE = "iptables-restore"
+IP6TABLES_RESTORE = "ip6tables-restore"
+ARPTABLES_RESTORE = "arptables-restore"
+EBTABLES_RESTORE = "ebtables-restore"
+
 EXTENSIONS_PATH = "extensions"
 LOGFILE="/tmp/iptables-test.log"
 log_file = None
@@ -222,6 +227,185 @@ STDERR_IS_TTY = sys.stderr.isatty()
         return alt_res
     return res_inverse[res]
 
+def fast_run_possible(filename):
+    '''
+    Keep things simple, run only for simple test files:
+    - no external commands
+    - no multiple tables
+    - no variant-specific results
+    '''
+    table = None
+    rulecount = 0
+    for line in open(filename):
+        if line[0] in ["#", ":"] or len(line.strip()) == 0:
+            continue
+        if line[0] == "*":
+            if table or rulecount > 0:
+                return False
+            table = line.rstrip()[1:]
+        if line[0] in ["@", "%"]:
+            return False
+        if len(line.split(";")) > 3:
+            return False
+        rulecount += 1
+
+    return True
+
+def run_test_file_fast(filename, netns):
+    '''
+    Run a test file, but fast
+
+    :param filename: name of the file with the test rules
+    :param netns: network namespace to perform test run in
+    '''
+    if "libipt_" in filename:
+        iptables = IPTABLES
+        iptables_save = IPTABLES_SAVE
+        iptables_restore = IPTABLES_RESTORE
+    elif "libip6t_" in filename:
+        iptables = IP6TABLES
+        iptables_save = IP6TABLES_SAVE
+        iptables_restore = IP6TABLES_RESTORE
+    elif "libxt_"  in filename:
+        iptables = IPTABLES
+        iptables_save = IPTABLES_SAVE
+        iptables_restore = IPTABLES_RESTORE
+    elif "libarpt_" in filename:
+        # only supported with nf_tables backend
+        if EXECUTABLE != "xtables-nft-multi":
+           return 0
+        iptables = ARPTABLES
+        iptables_save = ARPTABLES_SAVE
+        iptables_restore = ARPTABLES_RESTORE
+    elif "libebt_" in filename:
+        # only supported with nf_tables backend
+        if EXECUTABLE != "xtables-nft-multi":
+           return 0
+        iptables = EBTABLES
+        iptables_save = EBTABLES_SAVE
+        iptables_restore = EBTABLES_RESTORE
+    else:
+        # default to iptables if not known prefix
+        iptables = IPTABLES
+        iptables_save = IPTABLES_SAVE
+        iptables_restore = IPTABLES_RESTORE
+
+    f = open(filename)
+
+    rules = {}
+    table = "filter"
+    chain_array = []
+    tests = 0
+
+    for lineno, line in enumerate(f):
+        if line[0] == "#" or len(line.strip()) == 0:
+            continue
+
+        if line[0] == "*":
+            table = line.rstrip()[1:]
+            continue
+
+        if line[0] == ":":
+            chain_array = line.rstrip()[1:].split(",")
+            continue
+
+        if len(chain_array) == 0:
+            return -1
+
+        tests += 1
+
+        for chain in chain_array:
+            item = line.split(";")
+            rule = chain + " " + item[0]
+
+            if item[1] == "=":
+                rule_save = chain + " " + item[0]
+            else:
+                rule_save = chain + " " + item[1]
+
+            res = item[2].rstrip()
+            if res != "OK":
+                rule = chain + " -t " + table + " " + item[0]
+                ret = run_test(iptables, rule, rule_save,
+                               res, filename, lineno + 1, netns)
+
+                if ret < 0:
+                    return -1
+                continue
+
+            if not chain in rules.keys():
+                rules[chain] = []
+            rules[chain].append((rule, rule_save))
+
+    restore_data = ["*" + table]
+    out_expect = []
+    for chain in ["PREROUTING", "INPUT", "FORWARD", "OUTPUT", "POSTROUTING"]:
+        if not chain in rules.keys():
+            continue
+        for rule in rules[chain]:
+            restore_data.append("-A " + rule[0])
+            out_expect.append("-A " + rule[1])
+    restore_data.append("COMMIT")
+
+    out_expect = "\n".join(out_expect)
+
+    # load all rules via iptables_restore
+
+    command = EXECUTABLE + " " + iptables_restore
+    if netns:
+        command = "ip netns exec " + netns + " " + command
+
+    for line in restore_data:
+        print(iptables_restore + ": " + line, file=log_file)
+
+    proc = subprocess.Popen(command, shell = True, text = True,
+                            stdin = subprocess.PIPE,
+                            stdout = subprocess.PIPE,
+                            stderr = subprocess.PIPE)
+    restore_data = "\n".join(restore_data) + "\n"
+    out, err = proc.communicate(input = restore_data)
+
+    if proc.returncode == -11:
+        reason = "iptables-restore segfaults: " + cmd
+        print_error(reason, filename, lineno)
+        return -1
+
+    if proc.returncode != 0:
+        print("%s returned %d: %s" % (iptables_restore, proc.returncode, err),
+              file=log_file)
+        return -1
+
+    # find all rules in iptables_save output
+
+    command = EXECUTABLE + " " + iptables_save
+    if netns:
+        command = "ip netns exec " + netns + " " + command
+
+    proc = subprocess.Popen(command, shell = True,
+                            stdin = subprocess.PIPE,
+                            stdout = subprocess.PIPE,
+                            stderr = subprocess.PIPE)
+    out, err = proc.communicate()
+
+    if proc.returncode == -11:
+        reason = "iptables-save segfaults: " + cmd
+        print_error(reason, filename, lineno)
+        return -1
+
+    cmd = iptables + " -F -t " + table
+    execute_cmd(cmd, filename, 0, netns)
+
+    out = out.decode('utf-8').rstrip()
+    if out.find(out_expect) < 0:
+        print("dumps differ!", file=log_file)
+        print("\n".join(["expect: " + l for l in out_expect.split("\n")]), file=log_file)
+        print("\n".join(["got: " + l
+                         for l in out.split("\n")
+                         if not l[0] in ['*', ':', '#']]),
+              file=log_file)
+        return -1
+
+    return tests
 
 def run_test_file(filename, netns):
     '''
@@ -236,6 +420,14 @@ STDERR_IS_TTY = sys.stderr.isatty()
     if not filename.endswith(".t"):
         return 0, 0
 
+    fast_failed = False
+    if fast_run_possible(filename):
+        tests = run_test_file_fast(filename, netns)
+        if tests > 0:
+            print(filename + ": " + maybe_colored('green', "OK", STDOUT_IS_TTY))
+            return tests, tests
+        fast_failed = True
+
     if "libipt_" in filename:
         iptables = IPTABLES
     elif "libip6t_" in filename:
@@ -330,7 +522,10 @@ STDERR_IS_TTY = sys.stderr.isatty()
     if netns:
         execute_cmd("ip netns del " + netns, filename)
     if total_test_passed:
-        print(filename + ": " + maybe_colored('green', "OK", STDOUT_IS_TTY))
+        suffix = ""
+        if fast_failed:
+            suffix = maybe_colored('red', " but fast mode failed!", STDOUT_IS_TTY)
+        print(filename + ": " + maybe_colored('green', "OK", STDOUT_IS_TTY) + suffix)
 
     f.close()
     return tests, passed
-- 
2.34.1

