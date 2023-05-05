Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 750CBC77B7C
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 18:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjEESfL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 14:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbjEESfH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 14:35:07 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C941A4AE
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 11:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gOGeHnEuYLLNfRXhaQAEwK3P8uklwUC4FzfC/HRUhwA=; b=c/RhB2QbX8ACTPIKTEQzWpvx+5
        wChe6aaYwDq6rQvi4dC+yiP1EuaL2EPOh0/YWHgcFbwXlTWDB1Kd1jD4g+5AFJrUsWGry4xge6eQg
        hXJ/pzKuXwutY2+t/jatMzOBYIlEfR0qxSv0XPpvmtVzVRWPUjmE35KIVXFTnIW8qYKmS7nni5qTc
        L7MO+YMIQi3BAZrT68mNZzs9iByNHttvY+3FOfTKZvTXfb3wZ2JrUQidwVUz7zAupVgjpWzrDSAZt
        tdseMeySxsYh1UkF4slYaBCrv1KqJ1yEHzkO5T6E/XJgKMHVytd/stithVSM+N/W1YP+4Ujoe1Cq/
        gzK36lfQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pv0Gi-0004Oq-Be; Fri, 05 May 2023 20:35:01 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Garver <e@erig.me>, danw@redhat.com, aauren@gmail.com
Subject: [iptables PATCH 4/4] tests: Test compat mode
Date:   Fri,  5 May 2023 20:34:46 +0200
Message-Id: <20230505183446.28822-5-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230505183446.28822-1-phil@nwl.cc>
References: <20230505183446.28822-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend iptables-test.py by a third mode, which is using
xtables-nft-multi and passing --compat to all calls creating rules.

Also add a shell testcase asserting the effectiveness of --compat by
comparing debug (-vv) output.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py                              | 19 ++++--
 .../testcases/nft-only/0011-compat-mode_0     | 61 +++++++++++++++++++
 2 files changed, 76 insertions(+), 4 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/nft-only/0011-compat-mode_0

diff --git a/iptables-test.py b/iptables-test.py
index ef0a35d3daa22..d41778ba4e653 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -28,6 +28,8 @@ EBTABLES_SAVE = "ebtables-save"
 #IPTABLES_SAVE = ['xtables-save','-4']
 #IP6TABLES_SAVE = ['xtables-save','-6']
 
+COMPAT_ARG = ""
+
 EXTENSIONS_PATH = "extensions"
 LOGFILE="/tmp/iptables-test.log"
 log_file = None
@@ -83,7 +85,7 @@ STDERR_IS_TTY = sys.stderr.isatty()
     '''
     ret = 0
 
-    cmd = iptables + " -A " + rule
+    cmd = iptables + COMPAT_ARG + " -A " + rule
     ret = execute_cmd(cmd, filename, lineno, netns)
 
     #
@@ -318,7 +320,7 @@ STDERR_IS_TTY = sys.stderr.isatty()
 
     # load all rules via iptables_restore
 
-    command = EXECUTABLE + " " + iptables + "-restore"
+    command = EXECUTABLE + " " + iptables + "-restore" + COMPAT_ARG
     if netns:
         command = "ip netns exec " + netns + " " + command
 
@@ -555,6 +557,8 @@ STDERR_IS_TTY = sys.stderr.isatty()
                         help='Check for missing tests')
     parser.add_argument('-n', '--nftables', action='store_true',
                         help='Test iptables-over-nftables')
+    parser.add_argument('-c', '--nft-compat', action='store_true',
+                        help='Test iptables-over-nftables in compat mode')
     parser.add_argument('-N', '--netns', action='store_const',
                         const='____iptables-container-test',
                         help='Test netnamespace path')
@@ -574,8 +578,10 @@ STDERR_IS_TTY = sys.stderr.isatty()
         variants.append("legacy")
     if args.nftables:
         variants.append("nft")
+    if args.nft_compat:
+        variants.append("nft_compat")
     if len(variants) == 0:
-        variants = [ "legacy", "nft" ]
+        variants = [ "legacy", "nft", "nft_compat" ]
 
     if os.getuid() != 0:
         print("You need to be root to run this, sorry", file=sys.stderr)
@@ -595,7 +601,12 @@ STDERR_IS_TTY = sys.stderr.isatty()
     total_tests = 0
     for variant in variants:
         global EXECUTABLE
-        EXECUTABLE = "xtables-" + variant + "-multi"
+        global COMPAT_ARG
+        if variant == "nft_compat":
+            EXECUTABLE = "xtables-nft-multi"
+            COMPAT_ARG = " --compat"
+        else:
+            EXECUTABLE = "xtables-" + variant + "-multi"
 
         test_files = 0
         tests = 0
diff --git a/iptables/tests/shell/testcases/nft-only/0011-compat-mode_0 b/iptables/tests/shell/testcases/nft-only/0011-compat-mode_0
new file mode 100755
index 0000000000000..b339dd9ec870b
--- /dev/null
+++ b/iptables/tests/shell/testcases/nft-only/0011-compat-mode_0
@@ -0,0 +1,61 @@
+#!/bin/bash
+
+[[ $XT_MULTI == *xtables-nft-multi ]] || { echo "skip $XT_MULTI"; exit 0; }
+
+set -e
+
+# reduce noise in debug output
+$XT_MULTI iptables -t raw -A OUTPUT
+$XT_MULTI iptables -t raw -F
+
+# add all the things which were "optimized" here
+RULE='-t raw -A OUTPUT'
+
+# prefix matches on class (actually: byte) boundaries no longer need a bitwise
+RULE+=' -s 10.0.0.0/8 -d 192.168.0.0/16'
+
+# these were turned into native matches meanwhile
+# (plus -m tcp, but it conflicts with -m udp)
+RULE+=' -m limit --limit 1/min'
+RULE+=' -p udp -m udp --sport 1024:65535'
+RULE+=' -m mark --mark 0xfeedcafe/0xfeedcafe'
+RULE+=' -j TRACE'
+
+EXPECT_COMMON='TRACE  udp opt -- in * out *  10.0.0.0/8  -> 192.168.0.0/16   limit: avg 1/min burst 5 udp spts:1024:65535 mark match 0xfeedcafe/0xfeedcafe
+ip raw OUTPUT
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]'
+
+EXPECT="$EXPECT_COMMON
+  [ payload load 1b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x0000a8c0 ]
+  [ limit rate 1/minute burst 5 type packets flags 0x0 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ range eq reg 1 0x00000004 0x0000ffff ]
+  [ meta load mark => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfeedcafe ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0xfeedcafe ]
+  [ counter pkts 0 bytes 0 ]
+  [ immediate reg 9 0x00000001 ]
+  [ meta set nftrace with reg 9 ]
+"
+
+diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI iptables -vv $RULE)
+
+EXPECT="$EXPECT_COMMON
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ffff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000a8c0 ]
+  [ match name limit rev 0 ]
+  [ match name udp rev 0 ]
+  [ match name mark rev 1 ]
+  [ counter pkts 0 bytes 0 ]
+  [ target name TRACE rev 0 ]
+"
+
+diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI iptables --compat -vv $RULE)
-- 
2.40.0

