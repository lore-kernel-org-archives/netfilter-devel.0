From: Jan Engelhardt <jengelh@medozas.de>
Subject: [4/5] build: resolve autotools suggestions to use
 AC_CONFIG_MACRO_DIR
Date: Tue, 20 Jan 2009 12:17:11 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901201217040.13700@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901201214520.13700@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: eric@inl.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39855 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550AbZATLRM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Jan 2009 06:17:12 -0500
In-Reply-To: <alpine.LSU.2.00.0901201214520.13700@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent 433135f373edde9cc9c129b28257844eb1b3642c
commit d3ced9d5dcdb6b42a4c887b3afbfaaaa2bc09419
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jan 20 12:05:54 2009 +0100

build: resolve autotools suggestions to use AC_CONFIG_MACRO_DIR

libtoolize: Consider adding `AC_CONFIG_MACRO_DIR([m4])' to configure.ac and
libtoolize: rerunning libtoolize, to keep the correct libtool macros in-tree.
libtoolize: Consider adding `-I m4' to ACLOCAL_AMFLAGS in Makefile.am.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am   |    1 +
 configure.in  |    1 +
 m4/.gitignore |    2 ++
 3 files changed, 4 insertions(+), 0 deletions(-)
 create mode 100644 m4/.gitignore

diff --git a/Makefile.am b/Makefile.am
index e8b1154..ac35ce3 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,4 +1,5 @@
 
+ACLOCAL_AMFLAGS  = -I m4
 AUTOMAKE_OPTIONS = foreign dist-bzip2 1.6
 
 man_MANS = ulogd.8
diff --git a/configure.in b/configure.in
index 9d3f02a..141fa7d 100644
--- a/configure.in
+++ b/configure.in
@@ -4,6 +4,7 @@ AC_INIT
 
 AM_INIT_AUTOMAKE(ulogd, 2.0.0beta2)
 AM_CONFIG_HEADER(config.h)
+AC_CONFIG_MACRO_DIR([m4])
 
 dnl Checks for programs.
 AC_PROG_MAKE_SET
diff --git a/m4/.gitignore b/m4/.gitignore
new file mode 100644
index 0000000..64d9bbc
--- /dev/null
+++ b/m4/.gitignore
@@ -0,0 +1,2 @@
+/libtool.m4
+/lt*.m4
