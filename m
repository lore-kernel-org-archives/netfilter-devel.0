From: Jan Engelhardt <jengelh@medozas.de>
Subject: [5/5] build: update configure.ac
Date: Tue, 20 Jan 2009 12:17:18 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901201217110.13700@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901201214520.13700@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: eric@inl.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39859 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550AbZATLRT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Jan 2009 06:17:19 -0500
In-Reply-To: <alpine.LSU.2.00.0901201214520.13700@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent d3ced9d5dcdb6b42a4c887b3afbfaaaa2bc09419
commit 71d45403400bdb18bc6ae5efaf4772f6b847c351
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jan 20 12:08:06 2009 +0100

build: update configure.ac

Some constructs in there are old-fashioned. Replace them by their
modern counterparts.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 autogen.sh                   |    7 ++-----
 configure.in => configure.ac |   13 +++++++------
 2 files changed, 9 insertions(+), 11 deletions(-)
 rename configure.in => configure.ac (91%)

diff --git a/autogen.sh b/autogen.sh
index 189e2f4..36b2a2a 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,7 +1,4 @@
 #!/bin/sh
 
-aclocal
-autoheader
-libtoolize -c --force 
-automake -c --add-missing
-autoconf
+autoreconf -fi;
+rm -Rf autom4te.cache;
diff --git a/configure.in b/configure.ac
similarity index 91%
rename from configure.in
rename to configure.ac
index 141fa7d..4429d5c 100644
--- a/configure.in
+++ b/configure.ac
@@ -1,16 +1,16 @@
 dnl Process this file with autoconf to produce a configure script.
-AC_PREQ(2.50)
-AC_INIT
+AC_PREREQ([2.50])
+AC_INIT([ulogd], [2.0.0beta2])
 
-AM_INIT_AUTOMAKE(ulogd, 2.0.0beta2)
-AM_CONFIG_HEADER(config.h)
+AM_INIT_AUTOMAKE([-Wall])
+AC_CONFIG_HEADER([config.h])
 AC_CONFIG_MACRO_DIR([m4])
 
 dnl Checks for programs.
 AC_PROG_MAKE_SET
 AC_PROG_CC
 AC_PROG_INSTALL
-AM_PROG_LIBTOOL
+AC_PROG_LIBTOOL
 
 dnl Checks for libraries.
 AC_CHECK_LIB(dl, dlopen)
@@ -74,10 +74,11 @@ dnl AC_SUBST(HAVE_PCAP_H)
 dnl AM_CONDITIONAL(HAVE_MYSQL, test x$mysqldir != x)
 dnl AM_CONDITIONAL(HAVE_PGSQL, test x$pgsqldir != x)
 
-AC_OUTPUT(include/Makefile include/ulogd/Makefile include/libipulog/Makefile \
+AC_CONFIG_FILES(include/Makefile include/ulogd/Makefile include/libipulog/Makefile \
 	  libipulog/Makefile \
 	  input/Makefile input/packet/Makefile input/flow/Makefile \
 	  filter/Makefile filter/raw2packet/Makefile filter/packet2flow/Makefile \
 	  output/Makefile output/pcap/Makefile output/mysql/Makefile output/pgsql/Makefile output/sqlite3/Makefile \
 	  output/dbi/Makefile \
 	  src/Makefile Makefile Rules.make)
+AC_OUTPUT
