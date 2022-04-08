Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10AAFC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Apr 2022 13:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbiDHNtW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 09:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbiDHNtV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 09:49:21 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEE0F47C9
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2022 06:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=t+6k+dKhQ1jTBloug3oAUSsaJEVHSUMH4ExHco7nWHA=; b=C916Td8xK3FSoI0DgRvr2xoF8t
        k3l5ZAmFg4gbS54RPNkJruwBqCrVjv0FuNHRGvg1ABnCys7tAASr71wEMBBK+3Y2vIkejSuhmiBvq
        ZvWZ4YkJ6/dUxfOFVwP2Y80pM+JKs3rgLbSBRsgyugPA5xt/gThg8LitrNOVHeAOBCJZsoih/6ax0
        6VbR5JY1XC2Jcxl4CIRz8R0UB1+DX7d5576hjt4wv1qgsVJY57tfZwusjjne4CV/cyQbh7OavjKHS
        gWH2sTofsshURG24Njff8G1ohzRYMKsalyj0PzOJQwQUH9GEJjpK/prP/uH8lbLmPgJyXK3Vr155Q
        sjk4yTag==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ncoxC-0003EQ-Qm; Fri, 08 Apr 2022 15:47:10 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: py: Don't colorize output if stderr is redirected
Date:   Fri,  8 Apr 2022 15:47:07 +0200
Message-Id: <20220408134707.24384-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cover for calls with '2>/tmp/log' and avoid printing escape sequences to
that file. One could still keep colored output on stdout, but that
required a printing routine for non-errors.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/nft-test.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 04dac8d77b25f..b66a33c21f661 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -39,7 +39,7 @@ signal_received = 0
 
 
 class Colors:
-    if sys.stdout.isatty():
+    if sys.stdout.isatty() and sys.stderr.isatty():
         HEADER = '\033[95m'
         GREEN = '\033[92m'
         YELLOW = '\033[93m'
-- 
2.34.1

