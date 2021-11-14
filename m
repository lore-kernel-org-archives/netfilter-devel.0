Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CD1C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69D9860E97
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhKNOE2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 09:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhKNOER (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 09:04:17 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4323C061766
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 06:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=k54GslsH3dC8WO0RY5sBihWZReT/GhxI5aCMg46cg98=; b=JnLGhExG0X2lwUOoHcrfnxw8Xr
        UosAxJD+a8mDv5WKznaTGW7AvUPuRF5tdNyw9HSp5nl1kZlkSkGC5exUXlbxagd4y2aPQiberLJQq
        iPU5COrSQyo2U6rg+2v9Opc/eSHbjjBLz3fI9g4XsaAvmPZzOeeOhqMblA3B2Jg93gpGeKKwQm4L2
        X+4FW6gS5HlMh8ABzf4EIMxZiiG2GbQY4R8rOoznjMx8RGgLm3ozNn+Btlirool4QaGCctv/ZgGpo
        1yYqV4Qbp1Lf3v53G0Snh98ehdfl4UsGx7FHGGupsOXjXH3BuckcV9bIrxla621eaZRUDKHDro6Ds
        /WGhXlOw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmG4E-00Cdsh-UD
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 14:01:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 03/16] build: remove unused Makefile fragment
Date:   Sun, 14 Nov 2021 14:00:45 +0000
Message-Id: <20211114140058.752394-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211114140058.752394-1-jeremy@azazel.net>
References: <20211114140058.752394-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Rules.make.in contains a number of variables defined by configure.  It
is left-over from the pre-Automake build-system, in which it used to
fill a similar role to Make_global.am.  It is no longer used anywhere.
Remove it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .gitignore    |  1 -
 Rules.make.in | 43 -------------------------------------------
 configure.ac  |  2 +-
 3 files changed, 1 insertion(+), 45 deletions(-)
 delete mode 100644 Rules.make.in

diff --git a/.gitignore b/.gitignore
index 3eb592245c0d..5c06684db5fb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -12,7 +12,6 @@ Makefile
 Makefile.in
 
 # this dir
-/Rules.make
 /ulogd.conf
 
 # build system
diff --git a/Rules.make.in b/Rules.make.in
deleted file mode 100644
index 21b05d9ca6ff..000000000000
--- a/Rules.make.in
+++ /dev/null
@@ -1,43 +0,0 @@
-#
-
-PREFIX=@prefix@
-exec_prefix=@exec_prefix@
-ETCDIR=@sysconfdir@
-BINDIR=@sbindir@
-
-ULOGD_CONFIGFILE=@sysconfdir@/ulogd.conf
-
-ULOGD_LIB_PATH=@libdir@/ulogd
-
-# Path of libipulog (from iptables)
-LIBIPULOG=@top_srcdir@/libipulog
-INCIPULOG=-I@top_srcdir@/libipulog/include
-INCCONFFILE=-I@top_srcdir@/conffile
-
-CC=@CC@
-LD=@LD@
-INSTALL=@INSTALL@
-
-CFLAGS=@CFLAGS@ @CPPFLAGS@ -Wall
-CFLAGS+=-DULOGD_CONFIGFILE=\"$(ULOGD_CONFIGFILE)\"
-# doesn't work for subdirs
-#CFLAGS+=$(INCIPULOG) $(INCCONFFILE)
-CFLAGS+=-I/lib/modules/`uname -r`/build/include
-#CFLAGS+=@DEFS@
-#CFLAGS+=-g -DDEBUG -DDEBUG_MYSQL -DDEBUG_PGSQL
-
-LIBS=@LIBS@
-
-
-# Names of the plugins to be compiled
-ULOGD_SL:=BASE OPRINT PWSNIFF LOGEMU LOCAL SYSLOG
-
-# mysql output support
-#ULOGD_SL+=MYSQL
-MYSQL_CFLAGS=-I@MYSQLINCLUDES@ @EXTRA_MYSQL_DEF@
-MYSQL_LDFLAGS=@DATABASE_LIB_DIR@ @MYSQL_LIB@
-
-# postgreSQL output support
-#ULOGD_SL+=PGSQL
-PGSQL_CFLAGS=-I@PGSQLINCLUDES@ @EXTRA_PGSQL_DEF@
-PGSQL_LDFLAGS=@DATABASE_LIB_DIR@ @PGSQL_LIB@
diff --git a/configure.ac b/configure.ac
index 48b4995f148c..e341ad12a159 100644
--- a/configure.ac
+++ b/configure.ac
@@ -180,7 +180,7 @@ AC_CONFIG_FILES(include/Makefile include/ulogd/Makefile include/libipulog/Makefi
 	  filter/Makefile filter/raw2packet/Makefile filter/packet2flow/Makefile \
 	  output/Makefile output/pcap/Makefile output/mysql/Makefile output/pgsql/Makefile output/sqlite3/Makefile \
 	  output/dbi/Makefile output/ipfix/Makefile \
-	  src/Makefile Makefile Rules.make)
+	  src/Makefile Makefile)
 AC_OUTPUT
 
 define([EXPAND_VARIABLE],
-- 
2.33.0

