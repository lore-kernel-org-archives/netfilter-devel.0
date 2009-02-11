From: jengelh@medozas.de
Subject: [PATCH 4/8] libxtables: decouple non-xtables parts from header
Date: Wed, 11 Feb 2009 16:03:32 +0100
Message-ID: <1234364616-19974-5-git-send-email-jengelh@medozas.de>
References: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48688 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbZBKPDj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:03:39 -0500
In-Reply-To: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore                     |    2 +-
 Makefile.am                    |    2 +-
 configure.ac                   |    2 +-
 include/ip6tables.h            |    1 +
 include/iptables.h             |    1 +
 include/iptables/internal.h.in |   11 +++++++++++
 include/xtables.h.in           |    7 ++++++-
 include/xtables/internal.h.in  |   13 -------------
 8 files changed, 22 insertions(+), 17 deletions(-)
 create mode 100644 include/iptables/internal.h.in
 delete mode 100644 include/xtables/internal.h.in

diff --git a/.gitignore b/.gitignore
index 116de2c..97c3004 100644
--- a/.gitignore
+++ b/.gitignore
@@ -18,7 +18,7 @@ Makefile.in
 /extensions/targets?.man
 
 /include/xtables.h
-/include/xtables/internal.h
+/include/iptables/internal.h
 
 /aclocal.m4
 /autom4te*.cache
diff --git a/Makefile.am b/Makefile.am
index 2348976..0e24717 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -105,7 +105,7 @@ tarball:
 	tar -C /tmp -cjf ${PACKAGE_TARNAME}-${PACKAGE_VERSION}.tar.bz2 --owner=root --group=root ${PACKAGE_TARNAME}-${PACKAGE_VERSION}/;
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
 
-config.status: include/xtables.h.in
+config.status: include/xtables.h.in include/iptables/internal.h.in
 
 # ldconfig may fail when we are not root (as is the case in build systems)
 # so add appropriate protection that it does not let `make` fail.
diff --git a/configure.ac b/configure.ac
index bb32130..888ba42 100644
--- a/configure.ac
+++ b/configure.ac
@@ -79,5 +79,5 @@ libxtables_vmajor=$(($libxtables_vcurrent - $libxtables_vage));
 AC_SUBST([libxtables_vmajor])
 
 AC_CONFIG_FILES([Makefile extensions/GNUmakefile libipq/Makefile
-	include/xtables.h include/xtables/internal.h xtables.pc])
+	include/xtables.h include/iptables/internal.h xtables.pc])
 AC_OUTPUT
diff --git a/include/ip6tables.h b/include/ip6tables.h
index 1956cf0..663da9c 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -4,6 +4,7 @@
 #include <netinet/ip.h>
 #include <xtables.h>
 #include <libiptc/libip6tc.h>
+#include <iptables/internal.h>
 
 #ifndef IP6T_SO_GET_REVISION_MATCH /* Old kernel source. */
 #define IP6T_SO_GET_REVISION_MATCH	68
diff --git a/include/iptables.h b/include/iptables.h
index f7ae0cc..ee769a5 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -4,6 +4,7 @@
 #include <netinet/ip.h>
 #include <xtables.h>
 #include <libiptc/libiptc.h>
+#include <iptables/internal.h>
 
 #ifndef IPT_SO_GET_REVISION_MATCH /* Old kernel source. */
 #define IPT_SO_GET_REVISION_MATCH	(IPT_BASE_CTL + 2)
diff --git a/include/iptables/internal.h.in b/include/iptables/internal.h.in
new file mode 100644
index 0000000..849e172
--- /dev/null
+++ b/include/iptables/internal.h.in
@@ -0,0 +1,11 @@
+#ifndef IPTABLES_INTERNAL_H
+#define IPTABLES_INTERNAL_H 1
+
+#define IPTABLES_VERSION "@PACKAGE_VERSION@"
+
+/**
+ * Program's own name and version.
+ */
+extern const char *program_name, *program_version;
+
+#endif /* IPTABLES_INTERNAL_H */
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 02750fb..1455e9c 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -258,10 +258,15 @@ extern const struct xtables_pprot xtables_chain_protos[];
 extern u_int16_t xtables_parse_protocol(const char *s);
 
 #ifdef XTABLES_INTERNAL
+
+/* Shipped modules rely on this... */
+
 #	ifndef ARRAY_SIZE
 #		define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
 #	endif
-#	include <xtables/internal.h>
+
+extern void _init(void);
+
 #endif
 
 #endif /* _XTABLES_H */
diff --git a/include/xtables/internal.h.in b/include/xtables/internal.h.in
deleted file mode 100644
index 5e34694..0000000
--- a/include/xtables/internal.h.in
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef _XTABLES_INTERNAL_H
-#define _XTABLES_INTERNAL_H 1
-
-#define IPTABLES_VERSION "@PACKAGE_VERSION@"
-
-/**
- * Program's own name and version.
- */
-extern const char *program_name, *program_version;
-
-extern void _init(void);
-
-#endif /* _XTABLES_INTERNAL_H */
-- 
1.6.1.2

