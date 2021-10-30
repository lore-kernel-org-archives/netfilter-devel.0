Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4010C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6B0F60F93
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbhJ3QER (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 12:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbhJ3QER (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 12:04:17 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442A9C061764
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 09:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eClxUQka4Up6XKZXdv+/5PC/rsibKJgCai36+4gqbPw=; b=Yg9v+19DBx3XxzNgU1rH8XBSVG
        1ka73Wvl+xFowFE2jmJOxtuUP6UHAQJGHuxcYikDPmwhAGUO4W9KwzAf6r4LvLtIH8P76bCV+YZcN
        2y7CvA3JpeAkSYAmaxNososhoFb6En9vDS1vXdGDfdVYTbpN9O6p0qAKoskLhcsB50HArdw7M/++Y
        TwdVBjBgYOBtvJMXyQeQ3TuGKBCldWGsLC5CBxvL2TU5E6PazGy+mWcsBqN8ske+/iSVimJWzGzsv
        YnfkJZH94xVCmGO1RrGTwsWpNV4XFS2vsDRgov16JsxG8/SchHwUtC+rCcXKAtB7cfTc1iNMdA6OC
        hGDHdVDA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgqng-00AFQk-3r
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:01:44 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 08/13] build: only conditionally enter sub-directories containing optional code
Date:   Sat, 30 Oct 2021 17:01:36 +0100
Message-Id: <20211030160141.1132819-9-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030160141.1132819-1-jeremy@azazel.net>
References: <20211030160141.1132819-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently, make enters all sub-directories containing source-code, even if they
only contain optional targets which are not configured to be built.  Instead,
change the Makefiles so that the sub-directories are optional, rather than the
targets.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 input/Makefile.am          | 10 +++++++++-
 input/flow/Makefile.am     |  2 --
 input/sum/Makefile.am      |  3 +--
 output/Makefile.am         | 33 +++++++++++++++++++++++++++++----
 output/dbi/Makefile.am     |  4 ----
 output/mysql/Makefile.am   |  4 ----
 output/pcap/Makefile.am    |  4 ----
 output/pgsql/Makefile.am   |  4 ----
 output/sqlite3/Makefile.am |  4 ----
 9 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/input/Makefile.am b/input/Makefile.am
index 8f2e934fcdfa..668fc2b1444a 100644
--- a/input/Makefile.am
+++ b/input/Makefile.am
@@ -1 +1,9 @@
-SUBDIRS = packet flow sum
+if BUILD_NFCT
+    OPT_SUBDIR_FLOW = flow
+endif
+
+if BUILD_NFACCT
+    OPT_SUBDIR_SUM = sum
+endif
+
+SUBDIRS = packet $(OPT_SUBDIR_FLOW) $(OPT_SUBDIR_SUM)
diff --git a/input/flow/Makefile.am b/input/flow/Makefile.am
index 004e532981a4..2171a0cd80c8 100644
--- a/input/flow/Makefile.am
+++ b/input/flow/Makefile.am
@@ -2,12 +2,10 @@ include $(top_srcdir)/Make_global.am
 
 AM_CPPFLAGS += ${LIBNETFILTER_CONNTRACK_CFLAGS}
 
-if BUILD_NFCT
 pkglib_LTLIBRARIES = ulogd_inpflow_NFCT.la # ulogd_inpflow_IPFIX.la
 
 ulogd_inpflow_NFCT_la_SOURCES = ulogd_inpflow_NFCT.c
 ulogd_inpflow_NFCT_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS)
-endif
 
 #ulogd_inpflow_IPFIX_la_SOURCES = ulogd_inpflow_IPFIX.c
 #ulogd_inpflow_IPFIX_la_LDFLAGS = -avoid-version -module
diff --git a/input/sum/Makefile.am b/input/sum/Makefile.am
index e0c42f7de376..b24af7b5606c 100644
--- a/input/sum/Makefile.am
+++ b/input/sum/Makefile.am
@@ -2,9 +2,8 @@ include $(top_srcdir)/Make_global.am
 
 AM_CPPFLAGS += $(LIBNETFILTER_ACCT_CFLAGS) $(LIBMNL_CFLAGS)
 
-if BUILD_NFACCT
 pkglib_LTLIBRARIES = ulogd_inpflow_NFACCT.la
+
 ulogd_inpflow_NFACCT_la_SOURCES = ulogd_inpflow_NFACCT.c
 ulogd_inpflow_NFACCT_la_LDFLAGS = -avoid-version -module
 ulogd_inpflow_NFACCT_la_LIBADD  = $(LIBMNL_LIBS) $(LIBNETFILTER_ACCT_LIBS)
-endif
diff --git a/output/Makefile.am b/output/Makefile.am
index 2b7d12b12be3..981ff0a30808 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -1,4 +1,29 @@
-SUBDIRS= pcap mysql pgsql sqlite3 dbi ipfix
+if HAVE_PCAP
+  OPT_SUBDIR_PCAP = pcap
+endif
+
+if HAVE_MYSQL
+  OPT_SUBDIR_MYSQL = mysql
+endif
+
+if HAVE_PGSQL
+  OPT_SUBDIR_PGSQL = pgsql
+endif
+
+if HAVE_SQLITE3
+  OPT_SUBDIR_SQLITE3 = sqlite3
+endif
+
+if HAVE_DBI
+  OPT_SUBDIR_DBI = dbi
+endif
+
+SUBDIRS = $(OPT_SUBDIR_PCAP) \
+	  $(OPT_SUBDIR_MYSQL) \
+	  $(OPT_SUBDIR_PGSQL) \
+	  $(OPT_SUBDIR_SQLITE3) \
+	  $(OPT_SUBDIR_DBI) \
+	  ipfix
 
 include $(top_srcdir)/Make_global.am
 
@@ -7,9 +32,9 @@ AM_CPPFLAGS += ${LIBNETFILTER_ACCT_CFLAGS} \
 	       ${LIBNETFILTER_LOG_CFLAGS}
 
 pkglib_LTLIBRARIES = ulogd_output_LOGEMU.la ulogd_output_SYSLOG.la \
-			 ulogd_output_OPRINT.la ulogd_output_GPRINT.la \
-			 ulogd_output_NACCT.la ulogd_output_XML.la \
-			 ulogd_output_GRAPHITE.la
+		     ulogd_output_OPRINT.la ulogd_output_GPRINT.la \
+		     ulogd_output_NACCT.la ulogd_output_XML.la \
+		     ulogd_output_GRAPHITE.la
 
 if HAVE_JANSSON
 pkglib_LTLIBRARIES += ulogd_output_JSON.la
diff --git a/output/dbi/Makefile.am b/output/dbi/Makefile.am
index 38db0a26fd84..f8b0a9c68c78 100644
--- a/output/dbi/Makefile.am
+++ b/output/dbi/Makefile.am
@@ -2,12 +2,8 @@ include $(top_srcdir)/Make_global.am
 
 AM_CPPFLAGS += $(DBI_INC)
 
-if HAVE_DBI
-
 pkglib_LTLIBRARIES = ulogd_output_DBI.la
 
 ulogd_output_DBI_la_SOURCES = ulogd_output_DBI.c ../../util/db.c
 ulogd_output_DBI_la_LIBADD  = ${DBI_LIB}
 ulogd_output_DBI_la_LDFLAGS = -avoid-version -module
-
-endif
diff --git a/output/mysql/Makefile.am b/output/mysql/Makefile.am
index 3839a135c926..54abb9654eb7 100644
--- a/output/mysql/Makefile.am
+++ b/output/mysql/Makefile.am
@@ -2,12 +2,8 @@ include $(top_srcdir)/Make_global.am
 
 AM_CPPFLAGS += $(MYSQL_INC)
 
-if HAVE_MYSQL
-
 pkglib_LTLIBRARIES = ulogd_output_MYSQL.la
 
 ulogd_output_MYSQL_la_SOURCES = ulogd_output_MYSQL.c ../../util/db.c
 ulogd_output_MYSQL_la_LIBADD  = ${MYSQL_LIB}
 ulogd_output_MYSQL_la_LDFLAGS = -avoid-version -module
-
-endif
diff --git a/output/pcap/Makefile.am b/output/pcap/Makefile.am
index a022bf0cc15c..9b4b3dde3a9c 100644
--- a/output/pcap/Makefile.am
+++ b/output/pcap/Makefile.am
@@ -1,11 +1,7 @@
 include $(top_srcdir)/Make_global.am
 
-if HAVE_PCAP
-
 pkglib_LTLIBRARIES = ulogd_output_PCAP.la
 
 ulogd_output_PCAP_la_SOURCES = ulogd_output_PCAP.c
 ulogd_output_PCAP_la_LIBADD  = ${libpcap_LIBS}
 ulogd_output_PCAP_la_LDFLAGS = -avoid-version -module
-
-endif
diff --git a/output/pgsql/Makefile.am b/output/pgsql/Makefile.am
index fbc0d04c9f11..9cdf22d7f765 100644
--- a/output/pgsql/Makefile.am
+++ b/output/pgsql/Makefile.am
@@ -2,12 +2,8 @@ include $(top_srcdir)/Make_global.am
 
 AM_CPPFLAGS += -I$(PQINCPATH)
 
-if HAVE_PGSQL
-
 pkglib_LTLIBRARIES = ulogd_output_PGSQL.la
 
 ulogd_output_PGSQL_la_SOURCES = ulogd_output_PGSQL.c ../../util/db.c
 ulogd_output_PGSQL_la_LIBADD  = ${PQLIBS}
 ulogd_output_PGSQL_la_LDFLAGS = -avoid-version -module
-
-endif
diff --git a/output/sqlite3/Makefile.am b/output/sqlite3/Makefile.am
index e00e1d6cf11c..72fd1a6a8db4 100644
--- a/output/sqlite3/Makefile.am
+++ b/output/sqlite3/Makefile.am
@@ -2,12 +2,8 @@ include $(top_srcdir)/Make_global.am
 
 AM_CPPFLAGS += ${libsqlite3_CFLAGS}
 
-if HAVE_SQLITE3
-
 pkglib_LTLIBRARIES = ulogd_output_SQLITE3.la
 
 ulogd_output_SQLITE3_la_SOURCES = ulogd_output_SQLITE3.c ../../util/db.c
 ulogd_output_SQLITE3_la_LIBADD  = ${libsqlite3_LIBS}
 ulogd_output_SQLITE3_la_LDFLAGS = -avoid-version -module
-
-endif
-- 
2.33.0

