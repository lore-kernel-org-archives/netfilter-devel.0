Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FE5C4167B
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 15:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235953AbiK2PrG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 10:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235959AbiK2PrA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 10:47:00 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328E159FED
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 07:46:59 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p02oz-0007K0-K7; Tue, 29 Nov 2022 16:46:57 +0100
Date:   Tue, 29 Nov 2022 16:46:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 iptables-nft 2/3] extensions: change expected output
 for new format
Message-ID: <Y4Ypce59j6HbKl0k@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20221129140542.28311-1-fw@strlen.de>
 <20221129140542.28311-3-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129140542.28311-3-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 29, 2022 at 03:05:41PM +0100, Florian Westphal wrote:
> Now that xtables-translate encloses the entire command line in ', update
> the test cases accordingly.

We could also do something like this (untested) and leave the test cases
as-is:

diff --git a/xlate-test.py b/xlate-test.py
index f3fcd797af908..82999beadb2d6 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -158,9 +158,14 @@ xtables_nft_multi = 'xtables-nft-multi'
             sourceline = line.split(';')[0]
 
         expected = payload.readline().rstrip(" \n")
-        next_expected = payload.readline()
+        if expected.startswith("nft ") and expected[5] != "'":
+                expected = "nft '" + expected.removeprefix("nft ") + "'"
+        next_expected = payload.readline().rstrip(" \n")
         if next_expected.startswith("nft"):
-            expected += "\n" + next_expected.rstrip(" \n")
+            if next_expected[5] != "'":
+                expected += "\nnft '" + next_expected.removeprefix("nft ") + "'"
+            else:
+                expected += "\n" + next_expected
             line = payload.readline()
         else:
             line = next_expected

Cheers, Phil
