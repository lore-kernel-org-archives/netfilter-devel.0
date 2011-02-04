From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/8] build: directly use config.h in internal.h
Date: Fri,  4 Feb 2011 14:08:52 +0100
Message-ID: <1296824935-4606-7-git-send-email-jengelh@medozas.de>
References: <1296824935-4606-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36781 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab1BDNJD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:09:03 -0500
In-Reply-To: <1296824935-4606-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This avoids the extra indirection via the .h.in file.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore                     |    1 -
 Makefile.am                    |    3 +--
 configure.ac                   |    2 +-
 include/iptables/internal.h    |   15 +++++++++++++++
 include/iptables/internal.h.in |   13 -------------
 5 files changed, 17 insertions(+), 17 deletions(-)
 create mode 100644 include/iptables/internal.h
 delete mode 100644 include/iptables/internal.h.in

diff --git a/.gitignore b/.gitignore
index e5d3099..7d0df25 100644
--- a/.gitignore
+++ b/.gitignore
@@ -18,7 +18,6 @@ Makefile.in
 /extensions/targets?.man
 
 /include/xtables.h
-/include/iptables/internal.h
 
 /aclocal.m4
 /autom4te*.cache
diff --git a/Makefile.am b/Makefile.am
index 7f0eb2f..cfccbf2 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -89,8 +89,7 @@ tarball:
 	tar -C /tmp -cjf ${PACKAGE_TARNAME}-${PACKAGE_VERSION}.tar.bz2 --owner=root --group=root ${PACKAGE_TARNAME}-${PACKAGE_VERSION}/;
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
 
-config.status: extensions/GNUmakefile.in \
-	include/xtables.h.in include/iptables/internal.h.in
+config.status: extensions/GNUmakefile.in include/xtables.h.in
 
 # Using if..fi avoids an ugly "error (ignored)" message :)
 install-exec-hook:
diff --git a/configure.ac b/configure.ac
index eb447e0..94d5ab2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -111,5 +111,5 @@ AC_SUBST([libxtables_vmajor])
 
 AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
 	libipq/Makefile utils/Makefile
-	include/xtables.h include/iptables/internal.h libiptc.pc xtables.pc])
+	include/xtables.h libiptc.pc xtables.pc])
 AC_OUTPUT
diff --git a/include/iptables/internal.h b/include/iptables/internal.h
new file mode 100644
index 0000000..531fe4f
--- /dev/null
+++ b/include/iptables/internal.h
@@ -0,0 +1,15 @@
+#ifndef IPTABLES_INTERNAL_H
+#define IPTABLES_INTERNAL_H 1
+
+#include "config.h"
+
+#define IPTABLES_VERSION PACKAGE_VERSION
+
+/**
+ * Program's own name and version.
+ */
+extern const char *program_name, *program_version;
+
+extern int line;
+
+#endif /* IPTABLES_INTERNAL_H */
diff --git a/include/iptables/internal.h.in b/include/iptables/internal.h.in
deleted file mode 100644
index 8568e58..0000000
--- a/include/iptables/internal.h.in
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef IPTABLES_INTERNAL_H
-#define IPTABLES_INTERNAL_H 1
-
-#define IPTABLES_VERSION "@PACKAGE_VERSION@"
-
-/**
- * Program's own name and version.
- */
-extern const char *program_name, *program_version;
-
-extern int line;
-
-#endif /* IPTABLES_INTERNAL_H */
-- 
1.7.1

