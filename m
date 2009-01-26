From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] conntrack-tools 0.9.10 released
Date: Mon, 26 Jan 2009 01:10:03 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901260107400.6592@fbirervta.pbzchgretzou.qr>
References: <497CD41A.3040106@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54276 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbZAZAKF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Jan 2009 19:10:05 -0500
In-Reply-To: <497CD41A.3040106@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-01-25 22:05, Pablo Neira Ayuso wrote:
>
>[conntrack-tools 0.9.10]

Here is a patch for the build stuff of conntrack-tools.


parent 9532b922795943b0ea24e18cc878b28b7833b92e
commit 21c7c0a7cc63d5ba6a89ed823c9b7d26d5485fcd
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Jan 26 00:58:40 2009 +0100

build: upgrade build system

- add .gitignore files
- replace outdated autoconf macros by new constructs, including autogen.sh
- and use AC_CONFIG_MACRO_DIR as suggested by libtool2:

libtoolize: Consider adding `AC_CONFIG_MACRO_DIR([m4])' to configure.in and
libtoolize: rerunning libtoolize, to keep the correct libtool macros in-tree.
libtoolize: Consider adding `-I m4' to ACLOCAL_AMFLAGS in Makefile.am.
---
 .gitignore     |   17 +++++++++++++++++
 Makefile.am    |    1 +
 autogen.sh     |   18 ++----------------
 configure.in   |    6 ++++--
 m4/.gitignore  |    2 ++
 src/.gitignore |    6 ++++++
 6 files changed, 32 insertions(+), 18 deletions(-)
 create mode 100644 .gitignore
 create mode 100644 m4/.gitignore
 create mode 100644 src/.gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..8676479
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,17 @@
+.deps
+.libs
+*.la
+*.lo
+*.o
+Makefile
+Makefile.in
+
+/aclocal.m4
+/config.*
+/configure
+/depcomp
+/install-sh
+/libtool
+/ltmain.sh
+/missing
+/ylwrap
diff --git a/Makefile.am b/Makefile.am
index 7383328..fde65aa 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,6 +2,7 @@ include Make_global.am
 
 # not a GNU package. You can remove this line, if
 # have all needed files, that a GNU package needs
+ACLOCAL_AMFLAGS  = -I m4
 AUTOMAKE_OPTIONS = foreign dist-bzip2 1.6
 
 man_MANS = conntrack.8 conntrackd.8
diff --git a/autogen.sh b/autogen.sh
index e76d3ef..36b2a2a 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,18 +1,4 @@
 #!/bin/sh
 
-run ()
-{
-    echo "running: $*"
-    eval $*
-
-    if test $? != 0 ; then
-	echo "error: while running '$*'"
-	exit 1
-    fi
-}
-
-run aclocal
-run libtoolize -f
-#run autoheader
-run automake -a
-run autoconf
+autoreconf -fi;
+rm -Rf autom4te.cache;
diff --git a/configure.in b/configure.in
index c430df7..cd2e7d5 100644
--- a/configure.in
+++ b/configure.in
@@ -2,7 +2,8 @@ AC_INIT(conntrack-tools, 0.9.10, pablo@netfilter.org)
 
 AC_CANONICAL_SYSTEM
 
-AM_INIT_AUTOMAKE
+AC_CONFIG_MACRO_DIR([m4])
+AM_INIT_AUTOMAKE([-Wall])
 
 AC_PROG_CC
 AM_PROG_LIBTOOL
@@ -130,4 +131,5 @@ CFLAGS="$CFLAGS $LIBNETFILTER_CONNTRACK_CFLAGS"
 
 AC_SUBST(LIBNETFILTER_CONNTRACK_LIBS)
 
-AC_OUTPUT(Makefile src/Makefile include/Makefile extensions/Makefile)
+AC_CONFIG_FILES([Makefile src/Makefile include/Makefile extensions/Makefile])
+AC_OUTPUT
diff --git a/m4/.gitignore b/m4/.gitignore
new file mode 100644
index 0000000..64d9bbc
--- /dev/null
+++ b/m4/.gitignore
@@ -0,0 +1,2 @@
+/libtool.m4
+/lt*.m4
diff --git a/src/.gitignore b/src/.gitignore
new file mode 100644
index 0000000..6e6763d
--- /dev/null
+++ b/src/.gitignore
@@ -0,0 +1,6 @@
+/conntrack
+/conntrackd
+
+/read_config_lex.c
+/read_config_yy.c
+/read_config_yy.h
