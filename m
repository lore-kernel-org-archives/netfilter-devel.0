From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 7/7] libipq: add pkgconfig file
Date: Mon,  8 Aug 2011 02:42:23 +0200
Message-ID: <1312764144-23849-8-git-send-email-jengelh@medozas.de>
References: <1312764144-23849-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44415 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab1HHAme (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Aug 2011 20:42:34 -0400
In-Reply-To: <1312764144-23849-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is just to make sure that projects (still) using it do so with
the right cflags, e.g. for when the include file ends up in a
non-standard location due to ./configure having been called with
--include=/somewhere/else.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac        |    3 ++-
 libipq/.gitignore   |    1 +
 libipq/Makefile.am  |    2 ++
 libipq/libipq.pc.in |   11 +++++++++++
 4 files changed, 16 insertions(+), 1 deletions(-)
 create mode 100644 libipq/.gitignore
 create mode 100644 libipq/libipq.pc.in

diff --git a/configure.ac b/configure.ac
index 6aa0b2a..ab824a4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -111,6 +111,7 @@ AC_SUBST([libxtables_vmajor])
 
 AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
 	iptables/Makefile iptables/xtables.pc
-	libipq/Makefile libiptc/Makefile libiptc/libiptc.pc utils/Makefile
+	libipq/Makefile libipq/libipq.pc
+	libiptc/Makefile libiptc/libiptc.pc utils/Makefile
 	include/xtables.h include/iptables/internal.h])
 AC_OUTPUT
diff --git a/libipq/.gitignore b/libipq/.gitignore
new file mode 100644
index 0000000..6cb21a3
--- /dev/null
+++ b/libipq/.gitignore
@@ -0,0 +1 @@
+/libipq.pc
diff --git a/libipq/Makefile.am b/libipq/Makefile.am
index 93e5b1c..9e3a2ca 100644
--- a/libipq/Makefile.am
+++ b/libipq/Makefile.am
@@ -9,3 +9,5 @@ man_MANS         = ipq_create_handle.3 ipq_destroy_handle.3 ipq_errstr.3 \
                    ipq_get_msgerr.3 ipq_get_packet.3 ipq_message_type.3 \
                    ipq_perror.3 ipq_read.3 ipq_set_mode.3 ipq_set_verdict.3 \
                    libipq.3
+
+pkgconfig_DATA = libipq.pc
diff --git a/libipq/libipq.pc.in b/libipq/libipq.pc.in
new file mode 100644
index 0000000..ea31ec7
--- /dev/null
+++ b/libipq/libipq.pc.in
@@ -0,0 +1,11 @@
+
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+libdir=@libdir@
+includedir=@includedir@
+
+Name:		libipq
+Description:	Interface to the (old) ip_queue mechanism
+Version:	@PACKAGE_VERSION@
+Libs:		-L${libdir} -lipq
+Cflags:		-I${includedir}
-- 
1.7.3.4

