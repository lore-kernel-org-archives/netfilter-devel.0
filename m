Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC42C4708A
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 14:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbiK2OGU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 09:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234975AbiK2OGD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 09:06:03 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6448751C01
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 06:06:02 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1p01FI-00042U-Oq; Tue, 29 Nov 2022 15:06:00 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 iptables-nft 3/3] xlate-test: avoid shell entanglements
Date:   Tue, 29 Nov 2022 15:05:42 +0100
Message-Id: <20221129140542.28311-4-fw@strlen.de>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221129140542.28311-1-fw@strlen.de>
References: <20221129140542.28311-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Feed the nft expected output found in the .txlate test files to
nft -f via pipe/stdin directly without the shell mangling it.

The shell step isn't needed anymore because xtables-translate no longer
escapes quotes.

We only need to remove the "nft '" and trailing "'" because nft doesn't
expect those.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 new in v2.

 xlate-test.py | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/xlate-test.py b/xlate-test.py
index f3fcd797af90..b93bf0547213 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -7,11 +7,11 @@ import shlex
 import argparse
 from subprocess import Popen, PIPE
 
-def run_proc(args, shell = False):
+def run_proc(args, shell = False, input = None):
     """A simple wrapper around Popen, returning (rc, stdout, stderr)"""
     process = Popen(args, text = True, shell = shell,
-                    stdout = PIPE, stderr = PIPE)
-    output, error = process.communicate()
+                    stdin = PIPE, stdout = PIPE, stderr = PIPE)
+    output, error = process.communicate(input)
     return (process.returncode, output, error)
 
 keywords = ("iptables-translate", "ip6tables-translate", "ebtables-translate")
@@ -100,15 +100,15 @@ def test_one_replay(name, sourceline, expected, result):
         fam = "ip6 "
     elif srccmd.startswith("ebt"):
         fam = "bridge "
+
+    expected = expected.removeprefix("nft '").removesuffix("'")
     nft_input = [
             "flush ruleset",
             "add table " + fam + table_name,
-            "add chain " + fam + table_name + " " + chain_name
-    ] + [ l.removeprefix("nft ") for l in expected.split("\n") ]
+            "add chain " + fam + table_name + " " + chain_name,
+    ] + [ expected ]
 
-    # feed input via the pipe to make sure the shell "does its thing"
-    cmd = "echo \"" + "\n".join(nft_input) + "\" | " + args.nft + " -f -"
-    rc, output, error = run_proc(cmd, shell = True)
+    rc, output, error = run_proc([args.nft, "-f", "-"], shell = False, input = "\n".join(nft_input))
     if rc != 0:
         result.append(name + ": " + red("Fail"))
         result.append(args.nft + " call failed: " + error.rstrip('\n'))
-- 
2.37.4

