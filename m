Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D19C47088
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Dec 2022 16:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbiLAQkc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Dec 2022 11:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbiLAQkG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2022 11:40:06 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE32ABA33
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2022 08:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YYcn/PZ3E4akKl8eCSS5hrbAW9HorLFlD5yL21BcrK4=; b=Q/ExjC0xiKVF72kpoygF790Qus
        Vub/tAbduNADR+pmKyWW1b/r8YPoY6s+2SRzwqJOjSL8Qa3QWcOjzt8FNgDf+/mOhDwrXUPcoyEAH
        Mn2wHjcRivs/U7t4vlxVvelpKHMi+hTuisXkYZ1fWbUa2jHkkmWDtdK/4Km8IoN/qPUNsftL95C97
        pazwtIswO9ZE9vajxQtUknlqZQksOAyisPGRWEPLLLIvVC1pN50PRMWse60NbxPq3QxIQ0PbgDemM
        f/mZ9jkGL+l6qKT9RB3yYtqHaJ2dgQuqC8+W06XAW1wAoUCUQvJT92SrHuv+B+Qr7HhoDUev9ckhW
        Gha8CohQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0mbS-0002be-1z; Thu, 01 Dec 2022 17:40:02 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 2/7] tests: xlate: Use --check to verify replay
Date:   Thu,  1 Dec 2022 17:39:11 +0100
Message-Id: <20221201163916.30808-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221201163916.30808-1-phil@nwl.cc>
References: <20221201163916.30808-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

After applying the translated rule using nft, pass the untranslated rule
to --check instead of dumping the ruleset and performing a string
search. This fixes for mandatory match reordering (e.g. addresses before
interfaces) and minor differences like /32 netmasks or even just
whitespace changes.

Fixes: 223e34b057b95 ("tests: xlate-test: Replay results for reverse direction testing")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 xlate-test.py | 46 ++++++++++++++++++----------------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

diff --git a/xlate-test.py b/xlate-test.py
index 6513b314beb35..4f037ef6ed96d 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -67,6 +67,7 @@ xtables_nft_multi = 'xtables-nft-multi'
     srcwords = sourceline.split()
 
     srccmd = srcwords[0]
+    ipt = srccmd.split('-')[0]
     table_idx = -1
     chain_idx = -1
     table_name = "filter"
@@ -84,16 +85,12 @@ xtables_nft_multi = 'xtables-nft-multi'
 
     if searchline is None:
         # adjust sourceline as required
-        srcwords[chain_idx] = "-A"
-        if table_idx >= 0:
-            srcwords.pop(table_idx)
-            srcwords.pop(table_idx)
-        searchline = " ".join(srcwords[1:])
-    elif not searchline.startswith("-A"):
-        tmp = ["-A", chain_name]
-        if len(searchline) > 0:
-            tmp.extend(searchline)
-        searchline = " ".join(tmp)
+        checkcmd = srcwords[:]
+        checkcmd[0] = ipt
+        checkcmd[chain_idx] = "--check"
+    else:
+        checkcmd = [ipt, "-t", table_name]
+        checkcmd += ["--check", chain_name, searchline]
 
     fam = ""
     if srccmd.startswith("ip6"):
@@ -110,30 +107,23 @@ xtables_nft_multi = 'xtables-nft-multi'
 
     rc, output, error = run_proc([args.nft, "-f", "-"], shell = False, input = "\n".join(nft_input))
     if rc != 0:
-        result.append(name + ": " + red("Fail"))
+        result.append(name + ": " + red("Replay Fail"))
         result.append(args.nft + " call failed: " + error.rstrip('\n'))
         for line in nft_input:
             result.append(magenta("input: ") + line)
         return False
 
-    ipt = srccmd.split('-')[0]
-    rc, output, error = run_proc([xtables_nft_multi, ipt + "-save"])
+    rc, output, error = run_proc([xtables_nft_multi] + checkcmd)
     if rc != 0:
-        result.append(name + ": " + red("Fail"))
-        result.append(ipt + "-save call failed: " + error)
-        return False
-
-    if output.find(searchline) < 0:
-        outline = None
-        for l in output.split('\n'):
-            if l.startswith('-A '):
-                output = l
-                break
-        result.append(name + ": " + red("Replay fail"))
-        result.append(magenta("src: '") + str(expected) + "'")
-        result.append(magenta("exp: '") + searchline + "'")
-        for l in output.split('\n'):
-            result.append(magenta("res: ") + l)
+        result.append(name + ": " + red("Check Fail"))
+        result.append(magenta("check: ") + " ".join(checkcmd))
+        result.append(magenta("error: ") + error)
+        rc, output, error = run_proc([xtables_nft_multi, ipt + "-save"])
+        for l in output.split("\n"):
+            result.append(magenta("ipt: ") + l)
+        rc, output, error = run_proc([args.nft, "list", "ruleset"])
+        for l in output.split("\n"):
+            result.append(magenta("nft: ") + l)
         return False
 
     return True
-- 
2.38.0

