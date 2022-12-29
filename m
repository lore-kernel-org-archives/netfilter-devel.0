Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C775AC4167B
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Dec 2022 16:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbiL2QfV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Dec 2022 11:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiL2QfT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Dec 2022 11:35:19 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F38511A32
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Dec 2022 08:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Xc3pHBDf1gSIeCKkCeaLRbyNZ7TvxoacWyFrd7eG2YU=; b=hFKwwCyJ93phGvG31VbnDij2xE
        v35cbBfZceMRzl7XCJKcrM0J0gNVe8TkIC0f909IfE8yL7UXL/M93HlXtCpXe3dgIysntPyePkFTQ
        p8afyMDc+73JEVKwnejyL6pFhqN8R8aK1gYlJPj1DSRJ+SfQYxBNrCJJI/9FAfJuxgkxvJaZ/R2ZF
        sL8U2WDiuzUR8c6q0jtmhLhOIsi5+LcAQf4NP/EDlJpvdFevIVlGh7+QQNk+HxFEiauT8lAEnUyRU
        BIdQBEWEOmvzXuIJXxzp1HNa7zgsegvF6CmQespb0N2QtA8WkGvPN2RvzL2Ieq1Pv6O5olCKFhQut
        Je8xrZxQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pAvsA-00D08G-8H
        for netfilter-devel@vger.kernel.org; Thu, 29 Dec 2022 16:35:14 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 1/3] build: replace obsolete `AC_PROG_LIBTOOL` macro with `LT_INIT`
Date:   Thu, 29 Dec 2022 16:35:05 +0000
Message-Id: <20221229163507.352888-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221229163507.352888-1-jeremy@azazel.net>
References: <20221229163507.352888-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 549425742340..5d07a1026a20 100644
--- a/configure.ac
+++ b/configure.ac
@@ -8,7 +8,7 @@ AC_PROG_CC
 AM_PROG_CC_C_O
 m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 AC_DISABLE_STATIC
-AC_PROG_LIBTOOL
+LT_INIT
 
 AC_ARG_WITH([kbuild],
 	AS_HELP_STRING([--with-kbuild=PATH],
-- 
2.39.0

