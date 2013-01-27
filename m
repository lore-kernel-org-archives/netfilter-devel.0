From: Eric Leblond <eric@regit.org>
Subject: [iptables PATCH v2] configure: display summary at end of configure
Date: Sun, 27 Jan 2013 09:26:36 +0100
Message-ID: <1359275196-19222-1-git-send-email-eric@regit.org>
References: <alpine.LNX.2.01.1301260113570.24932@nerf07.vanv.qr>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:57293 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab3A0IaO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jan 2013 03:30:14 -0500
In-Reply-To: <alpine.LNX.2.01.1301260113570.24932@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a message at the end of configure which displays
the different compilation options and system settings.

An example output is the following:

Iptables Configuration:
  IPv4 support:				yes
  IPv6 support:				yes
  Devel support:			yes
  IPQ support:				no
  Large file support:			yes

Build parameters:
  Put plugins into executable (static):	no
  Support plugins via dlopen (shared):	yes
  Installation prefix (--prefix):	/usr/local
  Xtables extension directory:		/usr/local/lib/xtables
  Pkg-config directory:			/usr/local/lib/pkgconfig
  Kernel build directory:		/lib/modules/custom
  Host:					x86_64-unknown-linux-gnu
  GCC binary:				gcc

Signed-off-by: Eric Leblond <eric@regit.org>
---
 configure.ac |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index ffd088c..e7036ff 100644
--- a/configure.ac
+++ b/configure.ac
@@ -49,7 +49,8 @@ AC_ARG_ENABLE([devel],
 	[Install Xtables development headers]),
 	[enable_devel="$enableval"], [enable_devel="yes"])
 AC_ARG_ENABLE([libipq],
-	AS_HELP_STRING([--enable-libipq], [Build and install libipq]))
+	AS_HELP_STRING([--enable-libipq], [Build and install libipq]),
+	[enable_libipq="$enableval"], [enable_libipq="no"])
 AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
 	[Path to the pkgconfig directory [[LIBDIR/pkgconfig]]]),
 	[pkgconfigdir="$withval"], [pkgconfigdir='${libdir}/pkgconfig'])
@@ -107,6 +108,20 @@ if [[ -n "$ksourcedir" ]]; then
 fi;
 pkgdatadir='${datadir}/xtables';
 
+define([EXPAND_VARIABLE],
+[$2=[$]$1
+if test $prefix = 'NONE'; then
+	prefix="/usr/local"
+fi
+while true; do
+  case "[$]$2" in
+    *\[$]* ) eval "$2=[$]$2" ;;
+    *) break ;;
+  esac
+done
+eval "$2=[$]$2"
+])dnl EXPAND_VARIABLE
+
 AC_SUBST([regular_CFLAGS])
 AC_SUBST([regular_CPPFLAGS])
 AC_SUBST([noundef_LDFLAGS])
@@ -129,3 +144,32 @@ AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
 	libxtables/Makefile utils/Makefile
 	include/xtables-version.h include/iptables/internal.h])
 AC_OUTPUT
+
+
+EXPAND_VARIABLE(xtlibdir, e_xtlibdir)
+EXPAND_VARIABLE(pkgconfigdir, e_pkgconfigdir)
+
+echo "
+Iptables Configuration:
+  IPv4 support:				${enable_ipv4}
+  IPv6 support:				${enable_ipv6}
+  Devel support:			${enable_devel}
+  IPQ support:				${enable_libipq}
+  Large file support:			${enable_largefile}
+
+Build parameters:
+  Put plugins into executable (static):	${enable_static}
+  Support plugins via dlopen (shared):	${enable_shared}
+  Installation prefix (--prefix):	${prefix}
+  Xtables extension directory:		${e_xtlibdir}
+  Pkg-config directory:			${e_pkgconfigdir}"
+
+if [[ -n "$ksourcedir" ]]; then
+	echo "  Kernel source directory:		${ksourcedir}"
+fi;
+if [[ -n "$kbuilddir" ]]; then
+	echo "  Kernel build directory:		${kbuilddir}"
+fi;
+
+echo "  Host:					${host}
+  GCC binary:				${CC}"
-- 
1.7.10.4

