Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC43EC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 967F161A8E
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355185AbhJARr2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 13:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355237AbhJARrY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 13:47:24 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26965C06177D
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Oct 2021 10:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6ZVOaoXA8b9aYOU8Z8j76Fogaads+UzuYHWVnO+9icU=; b=OJfb2uptCE46jWmZlUMRWz+Jcx
        rJiUrDV3SspeHlLsHtIkIBYDbXAwZYy+MSTTlapEuXUfKgmvtzvLRFkfF6sQTChFKDYb5vCN4mqv7
        WOrJsLv3XhzZx0JOy6Xk/42UmlnUwcl+RZvLAiptDLk0TXXgJuCrShKQZaFoxarwLRIFIdJatrmJf
        SD9Cr8cc3oszD7z0bMSR3GENqAMc7fsAPUEyDP1TvEAz89M0Snd0AY2GhvnhhWEfJ6jzEb3LtajJr
        m996aocvaE9ouuZX4T0KtEvGVBLsp0zkITk32+9FLnMqacY4i/UamKSFzpa9MM2Gqb+a6HSa25IFF
        R4C2Fq9g==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mWMbH-002RLP-Nn; Fri, 01 Oct 2021 18:45:35 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kyle Bowman <kbowman@cloudflare.com>,
        Alex Forster <aforster@cloudflare.com>,
        Cloudflare Kernel Team <kernel-team@cloudflare.com>
Subject: [PATCH iptables v2 8/8] tests: iptables-test: correct misspelt variable
Date:   Fri,  1 Oct 2021 18:41:42 +0100
Message-Id: <20211001174142.1267726-9-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211001174142.1267726-1-jeremy@azazel.net>
References: <20211001174142.1267726-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

"EXECUTEABLE" -> "EXECUTABLE"

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables-test.py | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 0ba3d36864fd..95fa11b1475c 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -84,7 +84,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
 
     cmd = iptables + " -A " + rule
     if netns:
-            cmd = "ip netns exec ____iptables-container-test " + EXECUTEABLE + " " + cmd
+            cmd = "ip netns exec ____iptables-container-test " + EXECUTABLE + " " + cmd
 
     ret = execute_cmd(cmd, filename, lineno)
 
@@ -123,7 +123,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
         elif splitted[0] == EBTABLES:
             command = EBTABLES_SAVE
 
-    command = EXECUTEABLE + " " + command
+    command = EXECUTABLE + " " + command
 
     if netns:
             command = "ip netns exec ____iptables-container-test " + command
@@ -168,7 +168,7 @@ def execute_cmd(cmd, filename, lineno):
     '''
     global log_file
     if cmd.startswith('iptables ') or cmd.startswith('ip6tables ') or cmd.startswith('ebtables ') or cmd.startswith('arptables '):
-        cmd = EXECUTEABLE + " " + cmd
+        cmd = EXECUTABLE + " " + cmd
 
     print("command: {}".format(cmd), file=log_file)
     ret = subprocess.call(cmd, shell=True, universal_newlines=True,
@@ -202,12 +202,12 @@ def run_test_file(filename, netns):
         iptables = IPTABLES
     elif "libarpt_" in filename:
         # only supported with nf_tables backend
-        if EXECUTEABLE != "xtables-nft-multi":
+        if EXECUTABLE != "xtables-nft-multi":
            return 0, 0
         iptables = ARPTABLES
     elif "libebt_" in filename:
         # only supported with nf_tables backend
-        if EXECUTEABLE != "xtables-nft-multi":
+        if EXECUTABLE != "xtables-nft-multi":
            return 0, 0
         iptables = EBTABLES
     else:
@@ -245,7 +245,7 @@ def run_test_file(filename, netns):
         if line[0] == "%":
             external_cmd = line.rstrip()[1:]
             if netns:
-                external_cmd = "ip netns exec ____iptables-container-test " + EXECUTEABLE + " " + external_cmd
+                external_cmd = "ip netns exec ____iptables-container-test " + EXECUTABLE + " " + external_cmd
             execute_cmd(external_cmd, filename, lineno)
             continue
 
@@ -366,10 +366,10 @@ def main():
         show_missing()
         return
 
-    global EXECUTEABLE
-    EXECUTEABLE = "xtables-legacy-multi"
+    global EXECUTABLE
+    EXECUTABLE = "xtables-legacy-multi"
     if args.nftables:
-        EXECUTEABLE = "xtables-nft-multi"
+        EXECUTABLE = "xtables-nft-multi"
 
     if os.getuid() != 0:
         print("You need to be root to run this, sorry", file=sys.stderr)
-- 
2.33.0

