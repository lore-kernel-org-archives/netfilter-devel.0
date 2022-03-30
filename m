Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C1CAC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Mar 2022 16:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348487AbiC3QBt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Mar 2022 12:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343762AbiC3QBt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Mar 2022 12:01:49 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF6E23154
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Mar 2022 09:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kx2FYhBltM6ipyY9Hj2rfzTtodoZ0Y+tAKBjTH5kkSc=; b=X9C9zSKe2vQtfaXDnrpltYPgws
        rGyvgM2u/c85h/UW1soVFRSeWdabLi2bICfgoV0phGK6lfm9j5v5djVpHTgiyHme01Hnx6kAgT9CQ
        +kBtOT8ts/D6YZVuPJ1sgz8S4VWaFSidpjthLQFw9JpphnHIVIY+f1I42W0/tu6O3+hxpgbv5AEuX
        XBtJnZ6h6NreyC8ZHVWMwkJcbxjDVOEjomoHjGhhaqrXVQE9W0zCoLSx4jCLrW4gEGYwKrJb7P0Ow
        G7T9WCklQEf0jPyHQf93x6tUlciZ9pSU72jJGw9tC334be9GRSlU49DxDCIzYJwIUAWC074gZ+eKz
        O7B5v/iA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nZajq-0004ct-QG; Wed, 30 Mar 2022 18:00:02 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] xlate-test: Fix for empty source line on failure
Date:   Wed, 30 Mar 2022 17:59:10 +0200
Message-Id: <20220330155910.13668-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The code overwrites 'line' before checking expected output. Save it in a
temporary variable.

Fixes: 62828a6aff231 ("tests: xlate-test: support multiline expectation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 xlate-test.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/xlate-test.py b/xlate-test.py
index d78e864869318..03bef7e2e5934 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -42,6 +42,7 @@ def run_test(name, payload):
     line = payload.readline()
     while line:
         if line.startswith(keywords):
+            sourceline = line
             tests += 1
             process = Popen([ xtables_nft_multi ] + shlex.split(line), stdout=PIPE, stderr=PIPE)
             (output, error) = process.communicate()
@@ -58,7 +59,7 @@ def run_test(name, payload):
                     test_passed = False
                     failed += 1
                     result.append(name + ": " + red("Fail"))
-                    result.append(magenta("src: ") + line.rstrip(" \n"))
+                    result.append(magenta("src: ") + sourceline.rstrip(" \n"))
                     result.append(magenta("exp: ") + expected)
                     result.append(magenta("res: ") + translation + "\n")
                 else:
-- 
2.34.1

