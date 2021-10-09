Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB85C433FE
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3459860F38
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbhJILo0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Oct 2021 07:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbhJILoZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Oct 2021 07:44:25 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11E2C061755
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Oct 2021 04:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4lG9ERdarqNJisZvubsaNdjwjE6buchMCodRhqLdwrY=; b=Kn3Uh9BS8J4CKeNVZczg13yTNI
        9vJPycFQGVfiHu+o0mgaMWouS7ClPsz7KlsVboGm3Cuic6U3g7Dadh2HumQCiEYzbObS05ogzKyxb
        oaj2mCKZkG1Wsxlu4/Ydwrph5DvgizpoywINaAibQUPF2LnkZx13TTvdxuRflJXY8QG3j8RSbV+U0
        xImE3Mh12iNJZkcY1QHlHLeu6MBvlo9KbpZgOW6SWZu5L+FvHgPNDogEz8X7EC+cHkTqrKEtVouRn
        3L2nW9jfwnJtFlaHWnHQWkSpjECSGMIHfhHTBdCObkOQOVCFyjmGX40fW7/5VfBpKL+ukifrgf+j8
        rdYakrtg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mZAkF-00BfRm-65
        for netfilter-devel@vger.kernel.org; Sat, 09 Oct 2021 12:42:27 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnetfilter_log PATCH 1/9] build: correct pkg-config dependency configuration
Date:   Sat,  9 Oct 2021 12:38:31 +0100
Message-Id: <20211009113839.2765382-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211009113839.2765382-1-jeremy@azazel.net>
References: <20211009113839.2765382-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Put libnfnetlink and libmnl in `Requires.private`.  They both use
pkg-config (thus `Requires`, not `Libs`), and they are both required for
static builds, but do not need to be exposed otherwise (thus
`Requires.private`).

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac           | 7 +++++--
 libnetfilter_log.pc.in | 6 +++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/configure.ac b/configure.ac
index c914e00a8ffe..8360e91063ae 100644
--- a/configure.ac
+++ b/configure.ac
@@ -29,8 +29,11 @@ AC_ARG_WITH([ipulog],
 AM_CONDITIONAL([BUILD_IPULOG], [test "x$with_ipulog" != xno])
 
 dnl Dependencies
-PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.41])
-PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
+AC_SUBST([LIBNFNETLINK_MIN_VERSION], [0.0.41])
+AC_SUBST([LIBMNL_MIN_VERSION],       [1.0.3])
+
+PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= ${LIBNFNETLINK_MIN_VERSION}])
+PKG_CHECK_MODULES([LIBMNL], [libmnl >= ${LIBMNL_MIN_VERSION}])
 PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2],
 		  [HAVE_LNFCT=1], [HAVE_LNFCT=0])
 AM_CONDITIONAL([BUILD_NFCT], [test "$HAVE_LNFCT" -eq 1])
diff --git a/libnetfilter_log.pc.in b/libnetfilter_log.pc.in
index a4b2f3bd4f70..9dbed7709632 100644
--- a/libnetfilter_log.pc.in
+++ b/libnetfilter_log.pc.in
@@ -6,11 +6,11 @@ libdir=@libdir@
 includedir=@includedir@
 
 Name: libnetfilter_log
-Description: netfilter userspace packet logging library
+Description: Netfilter userspace packet logging library
 URL: http://netfilter.org/projects/libnetfilter_log/
 Version: @VERSION@
-Requires: libnfnetlink
+Requires.private: libnfnetlink >= @LIBNFNETLINK_MIN_VERSION@,
+		  libmnl >= @LIBMNL_MIN_VERSION@
 Conflicts:
 Libs: -L${libdir} -lnetfilter_log
-Libs.private: @LIBNFNETLINK_LIBS@
 Cflags: -I${includedir}
-- 
2.33.0

