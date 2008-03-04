From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 10/24] Combine IP{,6}T_LIB_DIR into XTABLES_LIBDIR
Date: Tue, 4 Mar 2008 16:57:49 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041657310.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53764 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYCDP5v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:57:51 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit a200f1acee54cd6489e145be4d0375110f3c726d
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Feb 11 01:02:00 2008 +0100

    Combine IP{,6}T_LIB_DIR into XTABLES_LIBDIR
    
    iptables and ip6tables will now recognize the XTABLES_LIBDIR environment
    variable for extensions to look in before going to the (old) IPT_LIB_DIR
    or IP6T_LIB_DIR (depending on program!) or the default location (/usr..).
    
    XTABLES_LIBDIR can also take multiple directories (like PATH, separated
    by colon).
---
 configure.ac              |   12 +++---
 extensions/GNUmakefile.in |    6 +-
 include/ip6tables.h       |    4 --
 include/iptables.h        |    4 --
 include/xtables.h         |    4 --
 ip6tables-restore.c       |   11 +++-
 ip6tables-save.c          |   11 +++-
 ip6tables-standalone.c    |   11 +++-
 iptables-restore.c        |   11 +++-
 iptables-save.c           |   11 +++-
 iptables-standalone.c     |   11 +++-
 libiptc/libiptc.c         |    4 --
 xtables.c                 |   86 ++++++++++++++++++------------------
 13 files changed, 100 insertions(+), 86 deletions(-)

diff --git a/configure.ac b/configure.ac
index 29f54dc..79775ad 100644
--- a/configure.ac
+++ b/configure.ac
@@ -22,11 +22,11 @@ AC_ARG_WITH([ksource],
 	AS_HELP_STRING([--with-ksource=PATH],
 	[Path to kernel source directory [[/lib/modules/CURRENT/source]]]),
 	[ksourcedir="$withval"])
-AC_ARG_WITH([iptdir],
-	AS_HELP_STRING([--with-iptdir=PATH],
+AC_ARG_WITH([xtlibdir],
+	AS_HELP_STRING([--with-xtlibdir=PATH],
 	[Path to iptables modules [[LIBEXECDIR/iptables]]]),
-	[iptdir="$withval"],
-	[iptdir="${libexecdir}/iptables"])
+	[xtlibdir="$withval"],
+	[xtlibdir="${libexecdir}/iptables"])
 AC_ARG_ENABLE([devel],
 	AS_HELP_STRING([--enable-devel],
 	[Build and install development files (libipq, libipq-devel, iptables-devel)]))
@@ -40,11 +40,11 @@ regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
 	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
 	-Winline -pipe -DIPTABLES_VERSION=\\\"$PACKAGE_VERSION\\\" \
-	-DIPT_LIB_DIR=\\\"\${iptdir}\\\" -DIP6T_LIB_DIR=\\\"\${iptdir}\\\"";
+	-DXTABLES_LIBDIR=\\\"\${xtlibdir}\\\"";
 kinclude_CFLAGS="-I\"$kbuilddir/include\" -I\"$ksourcedir/include\"";
 
 AC_SUBST([regular_CFLAGS kinclude_CFLAGS])
 AC_SUBST([kbuilddir])
 AC_SUBST([ksourcedir])
-AC_SUBST([iptdir])
+AC_SUBST([xtlibdir])
 AC_OUTPUT([Makefile extensions/GNUmakefile libipq/Makefile])
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index c6c181a..b7edce4 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -7,7 +7,7 @@ prefix      := @prefix@
 exec_prefix := @exec_prefix@
 libdir      := @libdir@
 libexecdir  := @libexecdir@
-iptdir      := @iptdir@
+xtlibdir    := @xtlibdir@
 
 CC             := @CC@
 CCLD           := ${CC}
@@ -82,8 +82,8 @@ targets_install :=
 all: ${targets}
 
 install: ${targets_install}
-	@mkdir -p "${DESTDIR}${iptdir}";
-	install -pm0755 $^ "${DESTDIR}${iptdir}/";
+	@mkdir -p "${DESTDIR}${xtlibdir}";
+	install -pm0755 $^ "${DESTDIR}${xtlibdir}/";
 
 clean:
 	rm -f *.o *.oo *.so *.a {matches,targets}[46].man initext4.c initext6.c;
diff --git a/include/ip6tables.h b/include/ip6tables.h
index 4a511b7..e1539eb 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -5,10 +5,6 @@
 
 #include "libiptc/libip6tc.h"
 
-#ifndef IP6T_LIB_DIR
-#define IP6T_LIB_DIR XT_LIB_DIR
-#endif
-
 #ifndef IP6T_SO_GET_REVISION_MATCH /* Old kernel source. */
 #define IP6T_SO_GET_REVISION_MATCH	68
 #define IP6T_SO_GET_REVISION_TARGET	69
diff --git a/include/iptables.h b/include/iptables.h
index 7ce9080..094c64e 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -4,10 +4,6 @@
 #include "xtables.h"
 #include "libiptc/libiptc.h"
 
-#ifndef IPT_LIB_DIR
-#define IPT_LIB_DIR XT_LIB_DIR
-#endif
-
 #ifndef IPT_SO_GET_REVISION_MATCH /* Old kernel source. */
 #define IPT_SO_GET_REVISION_MATCH	(IPT_BASE_CTL + 2)
 #define IPT_SO_GET_REVISION_TARGET	(IPT_BASE_CTL + 3)
diff --git a/include/xtables.h b/include/xtables.h
index f2bcb44..408d199 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -7,10 +7,6 @@
 #include <libiptc/libxtc.h>
 #include <stdbool.h>
 
-#ifndef XT_LIB_DIR
-#define XT_LIB_DIR "/usr/local/lib/iptables"
-#endif
-
 #ifndef IPPROTO_SCTP
 #define IPPROTO_SCTP 132
 #endif
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index e9cc0ff..2c3e95d 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -131,9 +131,14 @@ int main(int argc, char *argv[])
 	program_version = IPTABLES_VERSION;
 	line = 0;
 
-	lib_dir = getenv("IP6TABLES_LIB_DIR");
-	if (!lib_dir)
-		lib_dir = IP6T_LIB_DIR;
+	lib_dir = getenv("XTABLES_LIBDIR");
+	if (lib_dir == NULL) {
+		lib_dir = getenv("IP6TABLES_LIB_DIR");
+		if (lib_dir != NULL)
+			fprintf(stderr, "IP6TABLES_LIB_DIR is deprecated\n");
+	}
+	if (lib_dir == NULL)
+		lib_dir = XTABLES_LIBDIR;
 
 #ifdef NO_SHARED_LIBS
 	init_extensions();
diff --git a/ip6tables-save.c b/ip6tables-save.c
index e7eade1..e440887 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -332,9 +332,14 @@ int main(int argc, char *argv[])
 	program_name = "ip6tables-save";
 	program_version = IPTABLES_VERSION;
 
-	lib_dir = getenv("IP6TABLES_LIB_DIR");
-	if (!lib_dir)
-		lib_dir = IP6T_LIB_DIR;
+	lib_dir = getenv("XTABLES_LIBDIR");
+	if (lib_dir == NULL) {
+		lib_dir = getenv("IP6TABLES_LIB_DIR");
+		if (lib_dir != NULL)
+			fprintf(stderr, "IP6TABLES_LIB_DIR is deprecated\n");
+	}
+	if (lib_dir == NULL)
+		lib_dir = XTABLES_LIBDIR;
 
 #ifdef NO_SHARED_LIBS
 	init_extensions();
diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index 4029c1f..1bb81bc 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -52,9 +52,14 @@ main(int argc, char *argv[])
 	program_name = "ip6tables";
 	program_version = IPTABLES_VERSION;
 
-	lib_dir = getenv("IP6TABLES_LIB_DIR");
-	if (!lib_dir)
-		lib_dir = IP6T_LIB_DIR;
+	lib_dir = getenv("XTABLES_LIBDIR");
+	if (lib_dir == NULL) {
+		lib_dir = getenv("IP6TABLES_LIB_DIR");
+		if (lib_dir != NULL)
+			fprintf(stderr, "IP6TABLES_LIB_DIR is deprecated\n");
+	}
+	if (lib_dir == NULL)
+		lib_dir = XTABLES_LIBDIR;
 
 #ifdef NO_SHARED_LIBS
 	init_extensions();
diff --git a/iptables-restore.c b/iptables-restore.c
index b751d2c..f556fa5 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -132,9 +132,14 @@ main(int argc, char *argv[])
 	program_version = IPTABLES_VERSION;
 	line = 0;
 
-	lib_dir = getenv("IPTABLES_LIB_DIR");
-	if (!lib_dir)
-		lib_dir = IPT_LIB_DIR;
+	lib_dir = getenv("XTABLES_LIBDIR");
+	if (lib_dir == NULL) {
+		lib_dir = getenv("IPTABLES_LIB_DIR");
+		if (lib_dir != NULL)
+			fprintf(stderr, "IPTABLES_LIB_DIR is deprecated\n");
+	}
+	if (lib_dir == NULL)
+		lib_dir = XTABLES_LIBDIR;
 
 #ifdef NO_SHARED_LIBS
 	init_extensions();
diff --git a/iptables-save.c b/iptables-save.c
index c0c37ed..1ce2090 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -357,9 +357,14 @@ main(int argc, char *argv[])
 	program_name = "iptables-save";
 	program_version = IPTABLES_VERSION;
 
-	lib_dir = getenv("IPTABLES_LIB_DIR");
-	if (!lib_dir)
-		lib_dir = IPT_LIB_DIR;
+	lib_dir = getenv("XTABLES_LIBDIR");
+	if (lib_dir == NULL) {
+		lib_dir = getenv("IPTABLES_LIB_DIR");
+		if (lib_dir != NULL)
+			fprintf(stderr, "IPTABLES_LIB_DIR is deprecated\n");
+	}
+	if (lib_dir == NULL)
+		lib_dir = XTABLES_LIBDIR;
 
 #ifdef NO_SHARED_LIBS
 	init_extensions();
diff --git a/iptables-standalone.c b/iptables-standalone.c
index 55c7ce9..369adaf 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -53,9 +53,14 @@ main(int argc, char *argv[])
 	program_name = "iptables";
 	program_version = IPTABLES_VERSION;
 
-	lib_dir = getenv("IPTABLES_LIB_DIR");
-	if (!lib_dir)
-		lib_dir = IPT_LIB_DIR;
+	lib_dir = getenv("XTABLES_LIBDIR");
+	if (lib_dir == NULL) {
+		lib_dir = getenv("IPTABLES_LIB_DIR");
+		if (lib_dir != NULL)
+			fprintf(stderr, "IPTABLES_LIB_DIR is deprecated\n");
+	}
+	if (lib_dir == NULL)
+		lib_dir = XTABLES_LIBDIR;
 
 #ifdef NO_SHARED_LIBS
 	init_extensions();
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index e8f14fc..ca95748 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -46,10 +46,6 @@
 #define debug(x, args...)
 #endif
 
-#ifndef IPT_LIB_DIR
-#define IPT_LIB_DIR "/usr/local/lib/iptables"
-#endif
-
 static int sockfd = -1;
 static int sockfd_use = 0;
 static void *iptc_fn = NULL;
diff --git a/xtables.c b/xtables.c
index 89863d7..0405e3e 100644
--- a/xtables.c
+++ b/xtables.c
@@ -305,12 +305,50 @@ void parse_interface(const char *arg, char *vianame, unsigned char *mask)
 	}
 }
 
+static void *load_extension(const char *search_path, const char *prefix,
+    const char *name)
+{
+	const char *dir = search_path, *next;
+	void *ptr = NULL;
+	struct stat sb;
+	char path[256];
+
+	do {
+		next = strchr(dir, ':');
+		if (next == NULL)
+			next = dir + strlen(dir);
+		snprintf(path, sizeof(path), "%.*s/libxt_%s.so",
+		         next - dir, dir, name);
+
+		if (dlopen(path, RTLD_NOW) != NULL)
+			/* Found library.  If it didn't register itself,
+			   maybe they specified target as match. */
+			ptr = find_match(name, DONT_LOAD, NULL);
+		else if (stat(path, &sb) == 0)
+			fprintf(stderr, "%s: %s\n", path, dlerror());
+
+		if (ptr != NULL)
+			return ptr;
+
+		snprintf(path, sizeof(path), "%.*s/%s%s.so",
+		         next - dir, dir, prefix, name);
+		if (dlopen(path, RTLD_NOW) != NULL)
+			ptr = find_match(name, DONT_LOAD, NULL);
+		else if (stat(path, &sb) == 0)
+			fprintf(stderr, "%s: %s\n", path, dlerror());
+
+		if (ptr != NULL)
+			return ptr;
+
+		dir = next + 1;
+	} while (*next != '\0');
+
+	return NULL;
+}
+
 struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
 				 struct xtables_rule_match **matches)
 {
-#ifndef NO_SHARED_LIBS
-	struct stat sb;
-#endif
 	struct xtables_match *ptr;
 	const char *icmp6 = "icmp6";
 
@@ -343,25 +381,7 @@ struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
 
 #ifndef NO_SHARED_LIBS
 	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
-		char path[strlen(lib_dir) + sizeof("/.so")
-			  + strlen(afinfo.libprefix) + strlen(name)];
-
-		sprintf(path, "%s/libxt_%s.so", lib_dir, name);
-		if (dlopen(path, RTLD_NOW) != NULL)
-			/* Found library.  If it didn't register itself,
-			   maybe they specified target as match. */
-			ptr = find_match(name, DONT_LOAD, NULL);
-		else if (stat(path, &sb) == 0)
-			fprintf(stderr, "%s: %s\n", path, dlerror());
-
-		if (ptr == NULL) {
-			sprintf(path, "%s/%s%s.so", lib_dir, afinfo.libprefix,
-				name);
-			if (dlopen(path, RTLD_NOW) != NULL)
-				ptr = find_match(name, DONT_LOAD, NULL);
-			else if (stat(path, &sb) == 0)
-				fprintf(stderr, "%s: %s\n", path, dlerror());
-		}
+		ptr = load_extension(lib_dir, afinfo.libprefix, name);
 
 		if (ptr == NULL && tryload == LOAD_MUST_SUCCEED)
 			exit_error(PARAMETER_PROBLEM,
@@ -403,9 +423,6 @@ struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
 
 struct xtables_target *find_target(const char *name, enum xt_tryload tryload)
 {
-#ifndef NO_SHARED_LIBS
-	struct stat sb;
-#endif
 	struct xtables_target *ptr;
 
 	/* Standard target? */
@@ -423,25 +440,8 @@ struct xtables_target *find_target(const char *name, enum xt_tryload tryload)
 
 #ifndef NO_SHARED_LIBS
 	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
-		char path[strlen(lib_dir) + sizeof("/.so")
-			  + strlen(afinfo.libprefix) + strlen(name)];
-
-		sprintf(path, "%s/libxt_%s.so", lib_dir, name);
-		if (dlopen(path, RTLD_NOW) != NULL)
-			/* Found library.  If it didn't register itself,
-			   maybe they specified match as a target. */
-			ptr = find_target(name, DONT_LOAD);
-		else if (stat(path, &sb) == 0)
-			fprintf(stderr, "%s: %s\n", path, dlerror());
+		ptr = load_extension(lib_dir, afinfo.libprefix, name);
 
-		if (ptr == NULL) {
-			sprintf(path, "%s/%s%s.so", lib_dir, afinfo.libprefix,
-				name);
-			if (dlopen(path, RTLD_NOW) != NULL)
-				ptr = find_target(name, DONT_LOAD);
-			else if (stat(path, &sb) == 0)
-				fprintf(stderr, "%s: %s\n", path, dlerror());
-		}
 		if (ptr == NULL && tryload == LOAD_MUST_SUCCEED)
 			exit_error(PARAMETER_PROBLEM,
 				   "Couldn't load target `%s':%s\n",
