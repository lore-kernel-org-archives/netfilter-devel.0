Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 492E4C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F24A61101
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbhKFQUy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234525AbhKFQUx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 12:20:53 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E7AC061205
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 09:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1cPTYzBqt51FAeSbSX1dJY3eZzg7YED7CVyzy+15kyg=; b=oC4mqMJQMXzZ9zpsKmA3NHIfMC
        yrjCw+4NTmMuYjr9b1z5tvW6EkvKkCB/w8DCnKtTpQFXNQM0IZ0r134bw5/FDAfdb53cPTlSpcpWH
        kFGFMB/T4vHOLqvhmU/iDrEiBVkovYlPwq86ySCKesa9Yhs+F6GZOuY9U9WAHMf/FmSndrJ8Sk1z3
        ixGjhPJAtd1G+3c2S3hJmWM0INHAzH+gDGECHMrWK0RUZBwFB51zPP5hBBpnueCrsg7DWUPo3ke2x
        uqAMkvYcOfZ0mp9LIQQVKm5WBjiX/1eG++Rh/6dxhnoO4Ekbd6/0torXsYHTGG7F7rknidtHUOvro
        Vx+Aaj1w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOOQ-004loO-Jw
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:18:10 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 03/12] build: remove unused Makefile fragment
Date:   Sat,  6 Nov 2021 16:17:50 +0000
Message-Id: <20211106161759.128364-4-jeremy@azazel.net>
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

