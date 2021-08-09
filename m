Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A6A7C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 16:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 241E961019
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 16:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhHIQzq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Aug 2021 12:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbhHIQzq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Aug 2021 12:55:46 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F10C0613D3
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Aug 2021 09:55:25 -0700 (PDT)
Received: from localhost ([::1]:48796 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mD8Ye-0000Km-3B; Mon, 09 Aug 2021 18:55:24 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] extensions: hashlimit: Fix tests with HZ=100
Date:   Mon,  9 Aug 2021 18:55:19 +0200
Message-Id: <20210809165519.24592-1-phil@nwl.cc>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With the kernel ticking at 100Hz, a limit of 1/day with burst 5 does not
overflow in kernel, making the test unstable depending on kernel config.
Change it to not overflow with 1000Hz either by increasing the burst
value by a factor of 100.

Fixes: fcf9f6f25db11 ("extensions: libxt_hashlimit: add unit test")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_hashlimit.t | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_hashlimit.t b/extensions/libxt_hashlimit.t
index ccd0d1e6a2a1a..8369933786f68 100644
--- a/extensions/libxt_hashlimit.t
+++ b/extensions/libxt_hashlimit.t
@@ -3,14 +3,12 @@
 -m hashlimit --hashlimit-above 1000000/sec --hashlimit-burst 5 --hashlimit-name mini1;=;OK
 -m hashlimit --hashlimit-above 1/min --hashlimit-burst 5 --hashlimit-name mini1;=;OK
 -m hashlimit --hashlimit-above 1/hour --hashlimit-burst 5 --hashlimit-name mini1;=;OK
-# kernel says "xt_hashlimit: overflow, try lower: 864000000/5"
--m hashlimit --hashlimit-above 1/day --hashlimit-burst 5 --hashlimit-name mini1;;FAIL
+-m hashlimit --hashlimit-above 1/day --hashlimit-burst 500 --hashlimit-name mini1;=;OK
 -m hashlimit --hashlimit-upto 1/sec --hashlimit-burst 5 --hashlimit-name mini1;=;OK
 -m hashlimit --hashlimit-upto 1000000/sec --hashlimit-burst 5 --hashlimit-name mini1;=;OK
 -m hashlimit --hashlimit-upto 1/min --hashlimit-burst 5 --hashlimit-name mini1;=;OK
 -m hashlimit --hashlimit-upto 1/hour --hashlimit-burst 5 --hashlimit-name mini1;=;OK
-# kernel says "xt_hashlimit: overflow, try lower: 864000000/5"
--m hashlimit --hashlimit-upto 1/day --hashlimit-burst 5 --hashlimit-name mini1;;FAIL
+-m hashlimit --hashlimit-upto 1/day --hashlimit-burst 500 --hashlimit-name mini1;=;OK
 -m hashlimit --hashlimit-upto 1/sec --hashlimit-burst 1 --hashlimit-name mini1 --hashlimit-htable-expire 2000;=;OK
 -m hashlimit --hashlimit-upto 1/sec --hashlimit-burst 1 --hashlimit-mode srcip --hashlimit-name mini1 --hashlimit-htable-expire 2000;=;OK
 -m hashlimit --hashlimit-upto 1/sec --hashlimit-burst 1 --hashlimit-mode dstip --hashlimit-name mini1 --hashlimit-htable-expire 2000;=;OK
-- 
2.32.0

