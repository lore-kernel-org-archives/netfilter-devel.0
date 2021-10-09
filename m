Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E89FC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F098560F4B
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhJILo0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Oct 2021 07:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbhJILoZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Oct 2021 07:44:25 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112E0C061762
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Oct 2021 04:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vWTNFq667vXOGa35C2Ll3tlW4+k1mGVXnu3z7iM5Uto=; b=oh/6JYFb8A0+W0DKq0+0LJ+9UL
        QxBLI2HGl9W0MfsUNgKks9ibqiQAQk4hHU7c1OniBkIahwfqCE47CTA5kRGDfgySnHC4FNgy2y3w6
        NHVA/jmCcJnGE/MmqNDYUw4CF7TQR1dsRxRdpYzJUcryeoguYr3BKFqphBptTrr2rp0ZZOb3b4RSI
        PgR3V4J1DxV3kDk/KrSYB6h5MZXNkPAWb4H59zsW6qWbG8KVLGxt4N1RhCDwSaHNafUMicQHYWANr
        AIeAj1o/6iBtDtQ4xnkfPmB4/m4cvVwirFIrXq1J4WToY5CiBjJRTEMVKTuCw8HNL6E5tqJOR4KbU
        ODxUV4AA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mZAkF-00BfRm-AI
        for netfilter-devel@vger.kernel.org; Sat, 09 Oct 2021 12:42:27 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnetfilter_log PATCH 2/9] build: add pkg-config configuration for libipulog
Date:   Sat,  9 Oct 2021 12:38:32 +0100
Message-Id: <20211009113839.2765382-3-jeremy@azazel.net>
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

Put libnfnetlink and libnetfilter_log in `Requires.private`.  They both
use pkg-config (thus `Requires`, not `Libs`), and they are both required
for static builds, but do not need to be exposed otherwise (thus
`Requires.private`).

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 Makefile.am                      |  2 +-
 configure.ac                     | 11 ++++++++---
 libnetfilter_log_libipulog.pc.in | 16 ++++++++++++++++
 3 files changed, 25 insertions(+), 4 deletions(-)
 create mode 100644 libnetfilter_log_libipulog.pc.in

diff --git a/Makefile.am b/Makefile.am
index 2a9cdd826dae..c7b86f77aee6 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -5,4 +5,4 @@ ACLOCAL_AMFLAGS = -I m4
 EXTRA_DIST = Make_global.am
 
 pkgconfigdir = $(libdir)/pkgconfig
-pkgconfig_DATA = libnetfilter_log.pc
+pkgconfig_DATA = libnetfilter_log.pc libnetfilter_log_libipulog.pc
diff --git a/configure.ac b/configure.ac
index 8360e91063ae..1723426aa0c4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -39,7 +39,12 @@ PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2],
 AM_CONDITIONAL([BUILD_NFCT], [test "$HAVE_LNFCT" -eq 1])
 
 dnl Output the makefile
-AC_CONFIG_FILES([Makefile src/Makefile include/Makefile
-	include/libnetfilter_log/Makefile utils/Makefile libnetfilter_log.pc
-	doxygen.cfg])
+AC_CONFIG_FILES([Makefile
+		src/Makefile
+		include/Makefile
+		include/libnetfilter_log/Makefile
+		utils/Makefile
+		libnetfilter_log.pc
+		libnetfilter_log_libipulog.pc
+		doxygen.cfg])
 AC_OUTPUT
diff --git a/libnetfilter_log_libipulog.pc.in b/libnetfilter_log_libipulog.pc.in
new file mode 100644
index 000000000000..1b7d17a0ac62
--- /dev/null
+++ b/libnetfilter_log_libipulog.pc.in
@@ -0,0 +1,16 @@
+# libnetfilter_log_libipulog pkg-config file
+
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+libdir=@libdir@
+includedir=@includedir@
+
+Name: libnetfilter_log_libipulog
+Description: Netfilter ULOG userspace compat library
+URL: http://netfilter.org/projects/libnetfilter_log/
+Version: @VERSION@
+Requires.private: libnetfilter_log >= @VERSION@,
+                  libnfnetlink >= @LIBNFNETLINK_MIN_VERSION@
+Conflicts:
+Libs: -L${libdir} -lnetfilter_log_libipulog
+Cflags: -I${includedir}
-- 
2.33.0

