Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACFDAC64ED6
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Feb 2023 13:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjBQNtW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Feb 2023 08:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjBQNtU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Feb 2023 08:49:20 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C64B43903
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Feb 2023 05:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xYd2dxbVUy3LT+LOmb7AMeC8goTVgc92ZP5KN/Y/MHc=; b=JeXgxEG7oozMt8KP/Oidi6l1If
        97/OyfvlaTpJ8leZtbjIV3geuiX6yxh5j4h2CJXo0qQT9/ff6qizz5hMPz76+0SBAnKGu9ZxHLyJX
        5yfN8OLlIOJNg1ic+CMa8TsIlgflMNZWqOwH3hqsu27ZygMdGk0kpzA7dVdDS5nTEMtyVu8FkH1xQ
        c5LGMQvy8VSh1G1eGH5sTmX26bO2/FGJC1m8SXIAPYAJ0q75xSJKQsvGtQErfOVHYZfCU4Aj8Mbgt
        mtYWCOWJUaIEfytWFKIQwtwWuEaOswq9ZDz7QoTazA6mOqYd2/gGVV55CIEG7LwxglPi7tiUvaESa
        ZvbM8bQg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pT16m-0001vU-Fr
        for netfilter-devel@vger.kernel.org; Fri, 17 Feb 2023 14:49:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] tests: xlate: Print file names even if specified
Date:   Fri, 17 Feb 2023 14:48:55 +0100
Message-Id: <20230217134855.17247-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230217134855.17247-1-phil@nwl.cc>
References: <20230217134855.17247-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since the script now supports running for multiple files given on
command line, do not skip printing a status line for each.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 xlate-test.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/xlate-test.py b/xlate-test.py
index 09e3b67a853df..6a11659868479 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -176,7 +176,7 @@ xtables_nft_multi = 'xtables-nft-multi'
                 result.append(name + ": " + red("Fail"))
                 result.append("nft flush ruleset call failed: " + error)
 
-    if (passed == tests) and not args.test:
+    if (passed == tests):
         print(name + ": " + green("OK"))
     if not test_passed:
         print("\n".join(result), file=sys.stderr)
-- 
2.38.0

