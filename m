From: Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH] iptables: set the path of the lock file via a configure option.
Date: Tue, 14 Mar 2017 17:55:50 +0900
Message-ID: <20170314085550.10153-1-lorenzo@google.com>
Cc: pablo@netfilter.org, jscherpelz@google.com,
        Lorenzo Colitti <lorenzo@google.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:33691 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbdCNIz5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 04:55:57 -0400
Received: by mail-pg0-f45.google.com with SMTP id 25so83792213pgy.0
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2017 01:55:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently the iptables lock is hardcoded as "/run/xtables.lock".
Allow users to change this path using the --with-xt-lock-name
option to ./configure option. This is useful on systems like
Android which do not have /run.

Tested on Ubuntu, as follows:

1. By default, the lock is placed in /run/xtables.lock:

$ make distclean-recursive && ./autogen.sh &&
  ./configure --disable-nftables --prefix /tmp/iptables &&
  make -j64 &&
  make install &&
  sudo strace -e open,flock /tmp/iptables/sbin/iptables -L foo
...
open("/run/xtables.lock", O_RDONLY|O_CREAT, 0600) = 3
flock(3, LOCK_EX|LOCK_NB)               = 0
iptables: No chain/target/match by that name.

2. Specifying the lock results in the expected location being
   used:

$ make distclean-recursive && ./autogen.sh && \
  ./configure --disable-nftables --prefix /tmp/iptables \
  --with-xt-lock-name=/tmp/iptables/run/xtables.lock &&
  make -j64 &&
  make install &&
  sudo strace -e open,flock /tmp/iptables/sbin/iptables -L foo
...
open("/tmp/iptables/run/xtables.lock", O_RDONLY|O_CREAT, 0600) = 3
flock(3, LOCK_EX|LOCK_NB)               = 0
iptables: No chain/target/match by that name.

Signed-off-by: Lorenzo Colitti <lorenzo@google.com>
---
 configure.ac       | 10 ++++++++--
 iptables/xshared.c |  2 --
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index eda7871405..b27502667c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -67,6 +67,10 @@ AC_ARG_ENABLE([connlabel],
 	AS_HELP_STRING([--disable-connlabel],
 	[Do not build libnetfilter_conntrack]),
 	[enable_connlabel="$enableval"], [enable_connlabel="yes"])
+AC_ARG_WITH([xt-lock-name], AS_HELP_STRING([--with-xt-lock-name=PATH],
+	[Path to the xtables lock [[/run/xtables.lock]]]),
+	[xt_lock_name="$withval"],
+	[xt_lock_name="/run/xtables.lock"])
 
 libiptc_LDFLAGS2="";
 AX_CHECK_LINKER_FLAGS([-Wl,--no-as-needed],
@@ -193,7 +197,7 @@ AC_SUBST([blacklist_6_modules])
 regular_CFLAGS="-Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
 	-Winline -pipe";
-regular_CPPFLAGS="${largefile_cppflags} -D_REENTRANT \
+regular_CPPFLAGS="${largefile_cppflags} -DXT_LOCK_NAME=\\\"\${xt_lock_name}\\\" -D_REENTRANT \
 	-DXTABLES_LIBDIR=\\\"\${xtlibdir}\\\" -DXTABLES_INTERNAL";
 kinclude_CPPFLAGS="";
 if [[ -n "$kbuilddir" ]]; then
@@ -231,6 +235,7 @@ AC_SUBST([libxtables_vcurrent])
 AC_SUBST([libxtables_vage])
 libxtables_vmajor=$(($libxtables_vcurrent - $libxtables_vage));
 AC_SUBST([libxtables_vmajor])
+AC_SUBST([xt_lock_name])
 
 AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
 	iptables/Makefile iptables/xtables.pc
@@ -265,7 +270,8 @@ Build parameters:
   Support plugins via dlopen (shared):	${enable_shared}
   Installation prefix (--prefix):	${prefix}
   Xtables extension directory:		${e_xtlibdir}
-  Pkg-config directory:			${e_pkgconfigdir}"
+  Pkg-config directory:			${e_pkgconfigdir}
+  Xtables lock file:			${xt_lock_name}"
 
 if [[ -n "$ksourcedir" ]]; then
 	echo "  Kernel source directory:		${ksourcedir}"
diff --git a/iptables/xshared.c b/iptables/xshared.c
index f0a5ddd0de..383ecf2cf2 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -17,8 +17,6 @@
 #include <math.h>
 #include "xshared.h"
 
-#define XT_LOCK_NAME	"/run/xtables.lock"
-
 /*
  * Print out any special helps. A user might like to be able to add a --help
  * to the commandline, and see expected results. So we call help for all
-- 
2.12.0.246.ga2ecc84866-goog

