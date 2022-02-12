Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42013C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Feb 2022 16:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbiBLQ7D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Feb 2022 11:59:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236998AbiBLQ7B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Feb 2022 11:59:01 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4717F240A1
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Feb 2022 08:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2ITJKnZiVlwrpJM8JZ5rB0d4HACMkATzlY04gExhj0A=; b=qwwvzPJ/4hFKmFhzFhpcPbJOCY
        kMWGKM2Iji5ehtuQPOGzgrOyGf4CwkLx+SFn8C+6VEgEGVi2CQm7OJBBatC5o0SRUn5JDih4DNLrc
        XP8Knr4Y23bYyhIbdE9S4G222z09qSGyT6hJOs9bNDjC2P/RpCsATBF4DUP80Ur8YlO3AEPnh3pSl
        guWiyA4shcPMc3chHyqyF4pn4INY0e4xuJljMCe706HdXmmfroeUHz2EgQGH9Y+JLsMDEy2PRx7Jj
        H5p/jt63sPcoYlonVBQ61uF05cVKorofbCD0nZh325AGFUyQy67lIzqNCufo39pbAC9AXLGD4CoAo
        r9D8apIQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nIvjZ-001xVU-Ep
        for netfilter-devel@vger.kernel.org; Sat, 12 Feb 2022 16:58:53 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [iptables PATCH 3/4] tests: support explicit variant test result
Date:   Sat, 12 Feb 2022 16:58:31 +0000
Message-Id: <20220212165832.2452695-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220212165832.2452695-1-jeremy@azazel.net>
References: <20220212165832.2452695-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Now that there are more than two test results, add support for
explicitly indicating which result to expect if the variants differ.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables-test.py | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 4a587a29c823..6acaa82228fa 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -186,22 +186,23 @@ def execute_cmd(cmd, filename, lineno):
     log_file.flush()
 
     # generic check for segfaults
-    if ret  == -11:
+    if ret == -11:
         reason = "command segfaults: " + cmd
         print_error(reason, filename, lineno)
     return ret
 
 
-def variant_res(res, variant):
+def variant_res(res, variant, alt_res=None):
     '''
     Adjust expected result with given variant
 
     If expected result is scoped to a variant, the other one yields a different
-    result. Therefore map @res to itself if given variant is current, invert it
-    otherwise.
+    result. Therefore map @res to itself if given variant is current, use the
+    alternate result, @alt_res, if specified, invert @res otherwise.
 
     :param res: expected result from test spec ("OK", "FAIL" or "NOMATCH")
     :param variant: variant @res is scoped to by test spec ("NFT" or "LEGACY")
+    :param alt_res: optional expected result for the alternate variant.
     '''
     variant_executable = {
         "NFT": "xtables-nft-multi",
@@ -215,6 +216,8 @@ def variant_res(res, variant):
 
     if variant_executable[variant] == EXECUTABLE:
         return res
+    if alt_res is not None:
+        return alt_res
     return res_inverse[res]
 
 
@@ -312,7 +315,12 @@ def run_test_file(filename, netns):
 
             res = item[2].rstrip()
             if len(item) > 3:
-                res = variant_res(res, item[3].rstrip())
+                variant = item[3].rstrip()
+                if len(item) > 4:
+                    alt_res = item[4].rstrip()
+                else:
+                    alt_res = None
+                res = variant_res(res, variant, alt_res)
 
             ret = run_test(iptables, rule, rule_save,
                            res, filename, lineno + 1, netns)
-- 
2.34.1

