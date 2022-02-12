Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8125DC433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Feb 2022 16:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbiBLQ7C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Feb 2022 11:59:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236933AbiBLQ7B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Feb 2022 11:59:01 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5888B240A4
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Feb 2022 08:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XVzUxXMMl2LrUlB1aMm6/tX5jO0DLHjxjozatXOXI/w=; b=pdlv+OnMIdWJTQHpBV9hZt98QA
        ayc+yIxp8A4AukvxAnO48f6ibo9efVWxPSq5hAXP9OBLhiGRUvt7DV2YyQqlyMgrV4vUqMQwLxgA9
        GixKuFkIXysef1XK+CDMc+ZfjWKWg6pX2ihWM5qL2boBYIFNyfn9gf1Kgvd0+H+1/isKWDWdR/xEA
        QIDKul7cjEhTVMCZLXnZt4MRDvxCDDDqDSN2uqVG/84yqRCho2pxo/vKASqgd6EDgze92NwbveMkV
        uXjLB15t0eziI2p4L10VEGo09vHTxaccnJfSVnCRI+2E2gMjTkX6DhWAZ2dUcNKv2oCmM1KWEGfZm
        VuZSFTJw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nIvjZ-001xVU-HI
        for netfilter-devel@vger.kernel.org; Sat, 12 Feb 2022 16:58:53 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [iptables PATCH 4/4] tests: NFLOG: enable `--nflog-range` tests
Date:   Sat, 12 Feb 2022 16:58:32 +0000
Message-Id: <20220212165832.2452695-5-jeremy@azazel.net>
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

iptables-legacy and iptable-nft have different results for these tests.
Now that it is possible to specify the expected results correctly, we
can enable the tests.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/libxt_NFLOG.t | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/extensions/libxt_NFLOG.t b/extensions/libxt_NFLOG.t
index 561ec8c77650..25f332ae16b6 100644
--- a/extensions/libxt_NFLOG.t
+++ b/extensions/libxt_NFLOG.t
@@ -3,12 +3,12 @@
 -j NFLOG --nflog-group 65535;=;OK
 -j NFLOG --nflog-group 65536;;FAIL
 -j NFLOG --nflog-group 0;-j NFLOG;OK
-# `--nflog-range` is broken and only supported by xtables-legacy.  It
-# has been superseded by `--nflog--group`.
-# -j NFLOG --nflog-range 1;=;OK
-# -j NFLOG --nflog-range 4294967295;=;OK
-# -j NFLOG --nflog-range 4294967296;;FAIL
-# -j NFLOG --nflog-range -1;;FAIL
+# `--nflog-range` is broken and only supported by xtables-legacy.
+# It has been superseded by `--nflog--group`.
+-j NFLOG --nflog-range 1;=;OK;LEGACY;NOMATCH
+-j NFLOG --nflog-range 4294967295;=;OK;LEGACY;NOMATCH
+-j NFLOG --nflog-range 4294967296;;FAIL
+-j NFLOG --nflog-range -1;;FAIL
 -j NFLOG --nflog-size 0;=;OK
 -j NFLOG --nflog-size 1;=;OK
 -j NFLOG --nflog-size 4294967295;=;OK
-- 
2.34.1

