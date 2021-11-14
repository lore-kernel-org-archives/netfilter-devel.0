Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F65C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48B0560184
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhKNOER (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 09:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbhKNOEN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 09:04:13 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77728C061766
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 06:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=086GgTyx3EmFYqURfyJ4HkuVcPJto99JQpDLQUH2ij4=; b=e97mDdwDm8WAPzPN/8BTnyD8lT
        GaRcJ5Nic0xUP+Kn68pR6PYeiA1NsTewxKaP+DNbrveiUk4MWdaKyHx+fKffO/FpbvLLdcUAAeZ/W
        iLITfc3bTC790mLONqAeDTr1ybwRuJEUlv00/aYByAa5ng2IjdBdeMasxrNHjczaz04LxxzczSBUg
        O8oo7WoV6dzEr3Aa+lg2PgcFAHbJq5eqsVAhr1sbJQP+JkFvym+NQuGNlMCO5WiLqHp8EEG129mCG
        0eRVIM70S0M2bPO4yf03s7Mlk8Vn5G2ePZHNBVmMOZeHoTZIR7fvMBqz3MdvSqxjMcZmE5XAaIzL/
        SxK+EZ2Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmG4F-00Cdsh-JO
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 14:01:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 06/16] build: add Make_global.am for common flags
Date:   Sun, 14 Nov 2021 14:00:48 +0000
Message-Id: <20211114140058.752394-7-jeremy@azazel.net>
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

Move `${regular_CFLAGS}` from configure.ac to Make_global.am, renaming
it to `AM_CFLAGS`.  Add `AM_CPPFGLAGS` to include
`$(top_srcdir)/include`.  Include the new file in the Makefiles that
require it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 Make_global.am                | 2 ++
 Makefile.am                   | 1 -
 configure.ac                  | 3 ---
 filter/Makefile.am            | 5 +++--
 filter/raw2packet/Makefile.am | 4 +---
 input/flow/Makefile.am        | 4 ++--
 input/packet/Makefile.am      | 4 ++--
 input/sum/Makefile.am         | 6 ++++--
 libipulog/Makefile.am         | 4 +---
 output/Makefile.am            | 8 +++++---
 output/dbi/Makefile.am        | 4 ++--
 output/ipfix/Makefile.am      | 3 +--
 output/mysql/Makefile.am      | 5 +++--
 output/pcap/Makefile.am       | 4 +---
 output/pgsql/Makefile.am      | 4 ++--
 output/sqlite3/Makefile.am    | 5 +++--
 src/Makefile.am               | 9 ++++-----
 17 files changed, 36 insertions(+), 39 deletions(-)
 create mode 100644 Make_global.am

diff --git a/Make_global.am b/Make_global.am
new file mode 100644
index 000000000000..4ce896d06d70
--- /dev/null
+++ b/Make_global.am
@@ -0,0 +1,2 @@
+AM_CPPFLAGS = -I$(top_srcdir)/include
+AM_CFLAGS   = -Wall -Wextra -Wno-unused-parameter
diff --git a/Makefile.am b/Makefile.am
index 5600f8c6f552..0e5721472cb2 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -5,7 +5,6 @@ man_MANS = ulogd.8
 
 EXTRA_DIST = $(man_MANS) ulogd.conf.in doc
 
-AM_CPPFLAGS = -I$(top_srcdir)/include
 SUBDIRS = include libipulog src input filter output
 
 noinst_DATA = ulogd.conf
diff --git a/configure.ac b/configure.ac
index 1d795bad325d..f7d6b50c47f5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -157,9 +157,6 @@ AC_ARG_WITH([ulogd2libdir],
         [ulogd2libdir="${libdir}/ulogd"])
 AC_SUBST([ulogd2libdir])
 
-regular_CFLAGS="-Wall -Wextra -Wno-unused-parameter";
-AC_SUBST([regular_CFLAGS])
-
 dnl AC_SUBST(DATABASE_DIR)
 dnl AC_SUBST(DATABASE_LIB)
 dnl AC_SUBST(DATABASE_LIB_DIR)
diff --git a/filter/Makefile.am b/filter/Makefile.am
index c2755ecb7c49..f1d2c81f48d4 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -1,7 +1,8 @@
 SUBDIRS = raw2packet
 
-AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNFNETLINK_CFLAGS}
-AM_CFLAGS = ${regular_CFLAGS}
+include $(top_srcdir)/Make_global.am
+
+AM_CPPFLAGS += ${LIBNFNETLINK_CFLAGS}
 
 pkglib_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
 			 ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la \
diff --git a/filter/raw2packet/Makefile.am b/filter/raw2packet/Makefile.am
index 7498f9aa3c55..90768ef6ca0e 100644
--- a/filter/raw2packet/Makefile.am
+++ b/filter/raw2packet/Makefile.am
@@ -1,6 +1,4 @@
-
-AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CFLAGS = ${regular_CFLAGS}
+include $(top_srcdir)/Make_global.am
 
 pkglib_LTLIBRARIES = ulogd_raw2packet_BASE.la
 
diff --git a/input/flow/Makefile.am b/input/flow/Makefile.am
index 0e07a7dc1ccc..004e532981a4 100644
--- a/input/flow/Makefile.am
+++ b/input/flow/Makefile.am
@@ -1,6 +1,6 @@
+include $(top_srcdir)/Make_global.am
 
-AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_CONNTRACK_CFLAGS}
-AM_CFLAGS = ${regular_CFLAGS}
+AM_CPPFLAGS += ${LIBNETFILTER_CONNTRACK_CFLAGS}
 
 if BUILD_NFCT
 pkglib_LTLIBRARIES = ulogd_inpflow_NFCT.la # ulogd_inpflow_IPFIX.la
diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index 1c3151d52f13..daf374a65917 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -1,6 +1,6 @@
+include $(top_srcdir)/Make_global.am
 
-AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_LOG_CFLAGS}
-AM_CFLAGS = ${regular_CFLAGS}
+AM_CPPFLAGS += ${LIBNETFILTER_LOG_CFLAGS}
 
 pkglib_LTLIBRARIES = ulogd_inppkt_UNIXSOCK.la
 
diff --git a/input/sum/Makefile.am b/input/sum/Makefile.am
index b6ddb4d29b93..e0c42f7de376 100644
--- a/input/sum/Makefile.am
+++ b/input/sum/Makefile.am
@@ -1,5 +1,7 @@
-AM_CPPFLAGS = -I$(top_srcdir)/include $(LIBNETFILTER_ACCT_CFLAGS) $(LIBMNL_CFLAGS)
-AM_CFLAGS = ${regular_CFLAGS}
+include $(top_srcdir)/Make_global.am
+
+AM_CPPFLAGS += $(LIBNETFILTER_ACCT_CFLAGS) $(LIBMNL_CFLAGS)
+
 if BUILD_NFACCT
 pkglib_LTLIBRARIES = ulogd_inpflow_NFACCT.la
 ulogd_inpflow_NFACCT_la_SOURCES = ulogd_inpflow_NFACCT.c
diff --git a/libipulog/Makefile.am b/libipulog/Makefile.am
index 111cd4889ed6..708975a5fb99 100644
--- a/libipulog/Makefile.am
+++ b/libipulog/Makefile.am
@@ -1,6 +1,4 @@
-
-AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CFLAGS = ${regular_CFLAGS}
+include $(top_srcdir)/Make_global.am
 
 noinst_LTLIBRARIES = libipulog.la
 
diff --git a/output/Makefile.am b/output/Makefile.am
index 7ba821764afe..879c317d03ff 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -1,6 +1,8 @@
-AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_ACCT_CFLAGS} \
-              ${LIBNETFILTER_CONNTRACK_CFLAGS} ${LIBNETFILTER_LOG_CFLAGS}
-AM_CFLAGS = ${regular_CFLAGS}
+include $(top_srcdir)/Make_global.am
+
+AM_CPPFLAGS += ${LIBNETFILTER_ACCT_CFLAGS} \
+	       ${LIBNETFILTER_CONNTRACK_CFLAGS} \
+	       ${LIBNETFILTER_LOG_CFLAGS}
 
 SUBDIRS= pcap mysql pgsql sqlite3 dbi ipfix
 
diff --git a/output/dbi/Makefile.am b/output/dbi/Makefile.am
index f413cab4a340..38db0a26fd84 100644
--- a/output/dbi/Makefile.am
+++ b/output/dbi/Makefile.am
@@ -1,6 +1,6 @@
+include $(top_srcdir)/Make_global.am
 
-AM_CPPFLAGS = -I$(top_srcdir)/include $(DBI_INC)
-AM_CFLAGS = ${regular_CFLAGS}
+AM_CPPFLAGS += $(DBI_INC)
 
 if HAVE_DBI
 
diff --git a/output/ipfix/Makefile.am b/output/ipfix/Makefile.am
index cacda265c1f5..7354f6be6d51 100644
--- a/output/ipfix/Makefile.am
+++ b/output/ipfix/Makefile.am
@@ -1,5 +1,4 @@
-AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CFLAGS = $(regular_CFLAGS)
+include $(top_srcdir)/Make_global.am
 
 pkglib_LTLIBRARIES = ulogd_output_IPFIX.la
 
diff --git a/output/mysql/Makefile.am b/output/mysql/Makefile.am
index c24208c3e302..3839a135c926 100644
--- a/output/mysql/Makefile.am
+++ b/output/mysql/Makefile.am
@@ -1,5 +1,6 @@
-AM_CPPFLAGS = -I$(top_srcdir)/include $(MYSQL_INC)
-AM_CFLAGS = ${regular_CFLAGS}
+include $(top_srcdir)/Make_global.am
+
+AM_CPPFLAGS += $(MYSQL_INC)
 
 if HAVE_MYSQL
 
diff --git a/output/pcap/Makefile.am b/output/pcap/Makefile.am
index c1723a642a63..a022bf0cc15c 100644
--- a/output/pcap/Makefile.am
+++ b/output/pcap/Makefile.am
@@ -1,6 +1,4 @@
-
-AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CFLAGS = ${regular_CFLAGS}
+include $(top_srcdir)/Make_global.am
 
 if HAVE_PCAP
 
diff --git a/output/pgsql/Makefile.am b/output/pgsql/Makefile.am
index bdaf1d249dce..fbc0d04c9f11 100644
--- a/output/pgsql/Makefile.am
+++ b/output/pgsql/Makefile.am
@@ -1,6 +1,6 @@
+include $(top_srcdir)/Make_global.am
 
-AM_CPPFLAGS = -I$(top_srcdir)/include -I$(PQINCPATH)
-AM_CFLAGS = ${regular_CFLAGS}
+AM_CPPFLAGS += -I$(PQINCPATH)
 
 if HAVE_PGSQL
 
diff --git a/output/sqlite3/Makefile.am b/output/sqlite3/Makefile.am
index 62af267c4108..e00e1d6cf11c 100644
--- a/output/sqlite3/Makefile.am
+++ b/output/sqlite3/Makefile.am
@@ -1,5 +1,6 @@
-AM_CPPFLAGS = -I$(top_srcdir)/include ${libsqlite3_CFLAGS}
-AM_CFLAGS = ${regular_CFLAGS}
+include $(top_srcdir)/Make_global.am
+
+AM_CPPFLAGS += ${libsqlite3_CFLAGS}
 
 if HAVE_SQLITE3
 
diff --git a/src/Makefile.am b/src/Makefile.am
index e1d45aee4b6c..7a12a72da9a3 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -1,9 +1,8 @@
+include $(top_srcdir)/Make_global.am
 
-AM_CPPFLAGS = -I$(top_srcdir)/include \
-	      -DULOGD_CONFIGFILE='"$(sysconfdir)/ulogd.conf"' \
-	      -DULOGD_LOGFILE_DEFAULT='"$(localstatedir)/log/ulogd.log"' \
-	      -DULOGD2_LIBDIR='"$(ulogd2libdir)"'
-AM_CFLAGS = ${regular_CFLAGS}
+AM_CPPFLAGS += -DULOGD_CONFIGFILE='"$(sysconfdir)/ulogd.conf"' \
+	       -DULOGD_LOGFILE_DEFAULT='"$(localstatedir)/log/ulogd.log"' \
+	       -DULOGD2_LIBDIR='"$(ulogd2libdir)"'
 
 sbin_PROGRAMS = ulogd
 
-- 
2.33.0

