Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD1BBC43217
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5020610FD
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbhKFQUz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234527AbhKFQUx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 12:20:53 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6786BC06120A
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 09:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d7YYeVwYLvmoNjdOTzGlNW70LUbZrOQu9H8r0+vayQw=; b=PFpMzbi4M3FkkyS7uMtIeoBQ5r
        v5b0FC51lYTy3W3R33e22dOR84vjhyBZtEXeSQsJOKpV/4OgCdSBWdrwy4wQHa9jD1t99SqBek7fe
        Wdnngw9V+lt1jrO5o3I3nZaJIa5krqO3SzUaxD0fpbAltooKe2ldBby2va4ipbDrfj+gQfA/LJ/ZM
        rusxaHYTdr8+53ccKzuUuEKlyDXAhVR2J/8B6RzlGJTrFcpFlLcrPtC7jutvrbceB1qYcYLE8xWUa
        aivBUPwscvLW43by8yNLchrM/aleQExZVbZRbmh3/DI8YLaVJ9kvJwbzrR7zWQHYchn/PLcc/rc/i
        7JTKdR4w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOOQ-004loO-Pc
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:18:10 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 05/12] build: move cpp flag to the only Makefile.am file where it's needed
Date:   Sat,  6 Nov 2021 16:17:52 +0000
Message-Id: <20211106161759.128364-6-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106161759.128364-1-jeremy@azazel.net>
References: <20211106161759.128364-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac    | 2 +-
 src/Makefile.am | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index 4e502171292e..1d795bad325d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -157,7 +157,7 @@ AC_ARG_WITH([ulogd2libdir],
         [ulogd2libdir="${libdir}/ulogd"])
 AC_SUBST([ulogd2libdir])
 
-regular_CFLAGS="-Wall -Wextra -Wno-unused-parameter -DULOGD2_LIBDIR=\\\"\${ulogd2libdir}\\\"";
+regular_CFLAGS="-Wall -Wextra -Wno-unused-parameter";
 AC_SUBST([regular_CFLAGS])
 
 dnl AC_SUBST(DATABASE_DIR)
diff --git a/src/Makefile.am b/src/Makefile.am
index 998e776a8079..e1d45aee4b6c 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -1,7 +1,8 @@
 
 AM_CPPFLAGS = -I$(top_srcdir)/include \
-	      -DULOGD_CONFIGFILE="\"$(sysconfdir)/ulogd.conf\"" \
-	      -DULOGD_LOGFILE_DEFAULT="\"$(localstatedir)/log/ulogd.log\""
+	      -DULOGD_CONFIGFILE='"$(sysconfdir)/ulogd.conf"' \
+	      -DULOGD_LOGFILE_DEFAULT='"$(localstatedir)/log/ulogd.log"' \
+	      -DULOGD2_LIBDIR='"$(ulogd2libdir)"'
 AM_CFLAGS = ${regular_CFLAGS}
 
 sbin_PROGRAMS = ulogd
-- 
2.33.0

