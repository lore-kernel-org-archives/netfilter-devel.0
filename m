From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] libiptc: provide separate pkgconfig files
Date: Sun, 18 Dec 2011 03:06:48 +0100
Message-ID: <1324174009-1559-4-git-send-email-jengelh@medozas.de>
References: <1324174009-1559-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:55614 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab1LRCIP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 21:08:15 -0500
In-Reply-To: <1324174009-1559-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac           |    4 +++-
 libiptc/.gitignore     |    2 +-
 libiptc/Makefile.am    |    2 +-
 libiptc/libip4tc.pc.in |   10 ++++++++++
 libiptc/libip6tc.pc.in |   10 ++++++++++
 libiptc/libiptc.pc.in  |    6 ++----
 6 files changed, 27 insertions(+), 7 deletions(-)
 create mode 100644 libiptc/libip4tc.pc.in
 create mode 100644 libiptc/libip6tc.pc.in

diff --git a/configure.ac b/configure.ac
index 8afba8c..298d551 100644
--- a/configure.ac
+++ b/configure.ac
@@ -112,6 +112,8 @@ AC_SUBST([libxtables_vmajor])
 AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
 	iptables/Makefile iptables/xtables.pc
 	libipq/Makefile libipq/libipq.pc
-	libiptc/Makefile libiptc/libiptc.pc libxtables/Makefile utils/Makefile
+	libiptc/Makefile libiptc/libiptc.pc
+	libiptc/libip4tc.pc libiptc/libip6tc.pc
+	libxtables/Makefile utils/Makefile
 	include/xtables.h include/iptables/internal.h])
 AC_OUTPUT
diff --git a/libiptc/.gitignore b/libiptc/.gitignore
index 8767550..49ca83d 100644
--- a/libiptc/.gitignore
+++ b/libiptc/.gitignore
@@ -1 +1 @@
-/libiptc.pc
+/*.pc
diff --git a/libiptc/Makefile.am b/libiptc/Makefile.am
index 22c920f..c170cb2 100644
--- a/libiptc/Makefile.am
+++ b/libiptc/Makefile.am
@@ -3,7 +3,7 @@
 AM_CFLAGS        = ${regular_CFLAGS}
 AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CPPFLAGS}
 
-pkgconfig_DATA      = libiptc.pc
+pkgconfig_DATA      = libiptc.pc libip4tc.pc libip6tc.pc
 
 lib_LTLIBRARIES     = libip4tc.la libip6tc.la libiptc.la
 libiptc_la_SOURCES  =
diff --git a/libiptc/libip4tc.pc.in b/libiptc/libip4tc.pc.in
new file mode 100644
index 0000000..5efa1ca
--- /dev/null
+++ b/libiptc/libip4tc.pc.in
@@ -0,0 +1,10 @@
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+libdir=@libdir@
+includedir=@includedir@
+
+Name:		libip4tc
+Description:	iptables IPv4 ruleset ADT and kernel interface
+Version:	@PACKAGE_VERSION@
+Libs:		-L${libdir} -lip4tc
+Cflags:		-I${includedir}
diff --git a/libiptc/libip6tc.pc.in b/libiptc/libip6tc.pc.in
new file mode 100644
index 0000000..30a61b2
--- /dev/null
+++ b/libiptc/libip6tc.pc.in
@@ -0,0 +1,10 @@
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+libdir=@libdir@
+includedir=@includedir@
+
+Name:		libip6tc
+Description:	iptables IPv6 ruleset ADT and kernel interface
+Version:	@PACKAGE_VERSION@
+Libs:		-L${libdir} -lip6tc
+Cflags:		-I${includedir}
diff --git a/libiptc/libiptc.pc.in b/libiptc/libiptc.pc.in
index 99a3544..0264bf0 100644
--- a/libiptc/libiptc.pc.in
+++ b/libiptc/libiptc.pc.in
@@ -5,8 +5,6 @@ libdir=@libdir@
 includedir=@includedir@
 
 Name:		libiptc
-Description:	iptables ruleset ADT and kernel interface
+Description:	iptables v4/v6 ruleset ADT and kernel interface
 Version:	@PACKAGE_VERSION@
-Libs:		-L${libdir} -liptc
-Libs.private:	-lip4tc -lip6tc
-Cflags:		-I${includedir}
+Requires:	libip4tc libip6tc
-- 
1.7.3.4

