From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] Provide a pkgconfig file
Date: Sun,  1 Jan 2012 01:25:35 +0100
Message-ID: <1325377535-11289-3-git-send-email-jengelh@medozas.de>
References: <1325377535-11289-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51157 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab2AAAZi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Dec 2011 19:25:38 -0500
In-Reply-To: <1325377535-11289-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 .gitignore         |    1 +
 configure.ac       |    3 ++-
 lib/libipset.pc.in |   11 +++++++++++
 3 files changed, 14 insertions(+), 1 deletions(-)
 create mode 100644 lib/libipset.pc.in

diff --git a/.gitignore b/.gitignore
index a3168e4..686413d 100644
--- a/.gitignore
+++ b/.gitignore
@@ -2,6 +2,7 @@
 *.la
 *.lo
 *.o
+*.pc
 .deps/
 .libs/
 Makefile
diff --git a/configure.ac b/configure.ac
index 56a2dff..a0bc58d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -161,5 +161,6 @@ fi
 dnl Checks for library functions.
 
 dnl Generate output
-AC_CONFIG_FILES([Makefile include/libipset/Makefile lib/Makefile src/Makefile])
+AC_CONFIG_FILES([Makefile include/libipset/Makefile
+	lib/Makefile lib/libipset.pc src/Makefile])
 AC_OUTPUT
diff --git a/lib/libipset.pc.in b/lib/libipset.pc.in
new file mode 100644
index 0000000..1878c97
--- /dev/null
+++ b/lib/libipset.pc.in
@@ -0,0 +1,11 @@
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+libdir=@libdir@
+includedir=@includedir@
+
+Name: libipset
+Description: Userspace library for the ipset extensions and the kernel interface
+Version: @VERSION@
+Cflags: -I${includedir}
+Libs: -L${libdir} -lipset
+Requires.private: libmnl >= 1
-- 
1.7.7

