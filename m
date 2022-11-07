Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C786C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Nov 2022 13:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbiKGNJH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Nov 2022 08:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiKGNJG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Nov 2022 08:09:06 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472CE19C1A
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Nov 2022 05:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=m0x81YvoUWiANFB1m52jbPyrEF/2Ap5j9qfZ6ZoPJVE=; b=PAGlX1t38Gz6NXMXUH+ETYch7l
        Obg8m/1CAos2Ow58yK7VmUVS6RD1Mvhf9bbxJ5v6AgueSXj5JImAioR5hzDffBLtxOB7GvPlKpoc4
        1wPopHWsi/KFB6Mo6TWVCTruhx1e5ZX5Z/GJHmggD4va4cjuuOVMS/SPkSXrfrEO3EFsYaO4jYW3N
        P6qZkIPRzaALe8RDfd/Kn67SscF8htiEhw6KV4d1vhmawIfTtZb5MgT696AXRiEAbuCPOaDyfyUYs
        FlzqQspt7Lw0V6rAMZOdrflLsO4BlY9hRdqRvrPda1Klxk0OBn+ny3Azu1vg2s5zOj6uUAIyLMmLJ
        LVTH8mbQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1os1s7-0002hn-IN
        for netfilter-devel@vger.kernel.org; Mon, 07 Nov 2022 14:09:03 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/3] tests: xlate-test.py: Introduce run_proc()
Date:   Mon,  7 Nov 2022 14:08:42 +0100
Message-Id: <20221107130843.8024-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221107130843.8024-1-phil@nwl.cc>
References: <20221107130843.8024-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's just a convenience wrapper around Popen(), simplifying the call.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 xlate-test.py | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/xlate-test.py b/xlate-test.py
index ee393349da50d..bfcddde0f84a6 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -7,6 +7,13 @@ import shlex
 import argparse
 from subprocess import Popen, PIPE
 
+def run_proc(args, shell = False):
+    """A simple wrapper around Popen, returning (rc, stdout, stderr)"""
+    process = Popen(args, text = True, shell = shell,
+                    stdout = PIPE, stderr = PIPE)
+    output, error = process.communicate()
+    return (process.returncode, output, error)
+
 keywords = ("iptables-translate", "ip6tables-translate", "ebtables-translate")
 xtables_nft_multi = 'xtables-nft-multi'
 
@@ -34,14 +41,13 @@ xtables_nft_multi = 'xtables-nft-multi'
 
 
 def test_one_xlate(name, sourceline, expected, result):
-    process = Popen([ xtables_nft_multi ] + shlex.split(sourceline), stdout=PIPE, stderr=PIPE)
-    (output, error) = process.communicate()
-    if process.returncode != 0:
+    rc, output, error = run_proc([xtables_nft_multi] + shlex.split(sourceline))
+    if rc != 0:
         result.append(name + ": " + red("Error: ") + "iptables-translate failure")
-        result.append(error.decode("utf-8"))
+        result.append(error)
         return False
 
-    translation = output.decode("utf-8").rstrip(" \n")
+    translation = output.rstrip(" \n")
     if translation != expected:
         result.append(name + ": " + red("Fail"))
         result.append(magenta("src: ") + sourceline.rstrip(" \n"))
-- 
2.38.0

