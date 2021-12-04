Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C89C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Dec 2021 20:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353205AbhLDU7c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Dec 2021 15:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243137AbhLDU7c (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Dec 2021 15:59:32 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3A6C061751
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Dec 2021 12:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4b+QhE/gvzRBZYDT2yR8qYLon0WuPIzF0Y5MutRF00Q=; b=RIqvuiVKWjgcgQIq9ODYdMp0mW
        6KVr2Zlx37gRdwLEEWUKmWpWrKBmQDFKGI8a9Rr0tmqBLUpyYXS8DxTCxUcmMckCPTVBopCuqIa+T
        4761xxO4/MHw8R3ig6+4CuUV9t146pf2vjV8BitftSTGkca5y47/CrvGd2DLfd4xgzwdYfYmTcFnx
        /B2UZ8ZIldohOI45rJrIT6CFfy+izCORUB4ArtRDtGm5sXVLCthZPxPtXq2Cml/CotTqdmvPYLVmU
        wX+YEbQINIzP+RCQOXSXng41/6eFuoh5bzzf9gDxbFX7fHPpxU9B8e0IiYl59kURaRlHELBzp0prx
        n/xPRJgA==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mtc4h-00FAZ2-Qd
        for netfilter-devel@vger.kernel.org; Sat, 04 Dec 2021 20:56:03 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH] build: bump libnetfilter_log dependency
Date:   Sat,  4 Dec 2021 20:56:00 +0000
Message-Id: <20211204205600.3570672-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Recent changes to add conntrack info to the NFLOG output plug-in rely on
symbols only present in the headers provided by libnetfilter-log v1.0.2:

    CC       ulogd_inppkt_NFLOG.lo
  ulogd_inppkt_NFLOG.c: In function 'build_ct':
  ulogd_inppkt_NFLOG.c:346:34: error: 'NFULA_CT' undeclared (first use in this function); did you mean 'NFULA_GID'?
     if (mnl_attr_get_type(attr) == NFULA_CT) {
                                    ^~~~~~~~
                                    NFULA_GID
  ulogd_inppkt_NFLOG.c:346:34: note: each undeclared identifier is reported only once for each function it appears in
  ulogd_inppkt_NFLOG.c: In function 'start':
  ulogd_inppkt_NFLOG.c:669:12: error: 'NFULNL_CFG_F_CONNTRACK' undeclared (first use in this function); did you mean 'NFULNL_CFG_F_SEQ'?
     flags |= NFULNL_CFG_F_CONNTRACK;
              ^~~~~~~~~~~~~~~~~~~~~~
              NFULNL_CFG_F_SEQ

Bump the pkg-config version accordingly.

Fixes: f6a615587a10 ("NFLOG: attach struct nf_conntrack")
Fixes: e513a04cd925 ("NFLOG: add NFULNL_CFG_F_CONNTRACK flag")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 895d58439ef7..b3e1c8f6b926 100644
--- a/configure.ac
+++ b/configure.ac
@@ -52,7 +52,7 @@ AC_ARG_ENABLE([nflog],
               [enable_nflog=$enableval],
               [enable_nflog=yes])
 AS_IF([test "x$enable_nflog" = "xyes"],
-      [PKG_CHECK_MODULES([LIBNETFILTER_LOG], [libnetfilter_log >= 1.0.0])
+      [PKG_CHECK_MODULES([LIBNETFILTER_LOG], [libnetfilter_log >= 1.0.2])
        AC_DEFINE([BUILD_NFLOG], [1], [Building nflog module])],
       [enable_nflog=no])
 AM_CONDITIONAL([BUILD_NFLOG], [test "x$enable_nflog" = "xyes"])
-- 
2.33.0

