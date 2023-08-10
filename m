Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF8B4C001DE
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 18:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbjHJSzU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 14:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235243AbjHJSzU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 14:55:20 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2EF2696
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 11:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fdM1fimhqH+V36sdTPbzdggAy33PIolZDtk61A4Iw2s=; b=cUJy83at2Y+Opez/cWAt5xJVKG
        sZGSLl6w2pAHBcNB8U/PWb0wRhAxq06nkTrT3gnuDfv73n7uD0C6MzZFBFkgppnG6R0eb1KRRkiTq
        +QWKzp/vFeSPXSi0JqDd9FudBMuZAnHHJ4gjHxtiJ2u3udjjx0M6SCXWtbP71zH4JMghucCxSro2G
        8ndqvxiM6Crq4/t+z6+n6YHQJxalQuxSh1opENdhZARgUFiCxRjKCZJps7eryQbcg2rJcHLoSHkSC
        Tf9higiLs7bp+E0IgiOS+gmMrH0hNj6hdQMem7yKcKYR4DDrX9U+SFXWcgwPkhTX0UGbB5FnoF0Yh
        cJ/tqs1Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qUAoX-0002Yp-2G
        for netfilter-devel@vger.kernel.org; Thu, 10 Aug 2023 20:55:17 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 4/4] tests: Test compat mode
Date:   Thu, 10 Aug 2023 20:54:52 +0200
Message-Id: <20230810185452.24387-5-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230810185452.24387-1-phil@nwl.cc>
References: <20230810185452.24387-1-phil@nwl.cc>
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
 .../testcases/nft-only/0011-compat-mode_0     | 63 +++++++++++++++++++
 2 files changed, 78 insertions(+), 4 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/nft-only/0011-compat-mode_0

diff --git a/iptables-test.py b/iptables-test.py
index 6f63cdbeda9af..22b445df00b9c 100755
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
 
@@ -558,6 +560,8 @@ STDERR_IS_TTY = sys.stderr.isatty()
                         help='Check for missing tests')
     parser.add_argument('-n', '--nftables', action='store_true',
                         help='Test iptables-over-nftables')
+    parser.add_argument('-c', '--nft-compat', action='store_true',
+                        help='Test iptables-over-nftables in compat mode')
     parser.add_argument('-N', '--netns', action='store_const',
                         const='____iptables-container-test',
                         help='Test netnamespace path')
@@ -577,8 +581,10 @@ STDERR_IS_TTY = sys.stderr.isatty()
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
@@ -598,7 +604,12 @@ STDERR_IS_TTY = sys.stderr.isatty()
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
index 0000000000000..c8cee8aef1b94
--- /dev/null
+++ b/iptables/tests/shell/testcases/nft-only/0011-compat-mode_0
@@ -0,0 +1,63 @@
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
+ip raw OUTPUT'
+
+EXPECT="$EXPECT_COMMON
+  [ payload load 1b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x0000a8c0 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
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
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
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

