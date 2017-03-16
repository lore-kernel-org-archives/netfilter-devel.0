From: Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH] iptables: move XT_LOCK_NAME from CFLAGS to config.h.
Date: Thu, 16 Mar 2017 12:54:20 +0900
Message-ID: <20170316035420.96237-1-lorenzo@google.com>
Cc: pablo@netfilter.org, jscherpelz@google.com,
        Lorenzo Colitti <lorenzo@google.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33576 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbdCPD4S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 23:56:18 -0400
Received: by mail-pf0-f182.google.com with SMTP id w189so17978127pfb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 20:54:28 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This slightly simplifies configure.ac and results in more
correct dependencies.

Tested by running ./configure with --with-xt-lock-name and
without, and using strace to verify that the right lock is used.

$ make distclean-recursive && ./autogen.sh &&
  ./configure --disable-nftables --prefix /tmp/iptables &&
  make -j64 &&
  make install &&
  sudo strace -e open,flock /tmp/iptables/sbin/iptables -L foo
...
open("/run/xtables.lock", O_RDONLY|O_CREAT, 0600) = 3
flock(3, LOCK_EX|LOCK_NB)               = 0

$ make distclean-recursive && ./autogen.sh && \
  ./configure --disable-nftables --prefix /tmp/iptables \
  --with-xt-lock-name=/tmp/iptables/run/xtables.lock &&
  make -j64 &&
  make install &&
  sudo strace -e open,flock /tmp/iptables/sbin/iptables -L foo
...
open("/tmp/iptables/run/xtables.lock", O_RDONLY|O_CREAT, 0600) = 3
flock(3, LOCK_EX|LOCK_NB)               = 0

Signed-off-by: Lorenzo Colitti <lorenzo@google.com>
---
 configure.ac       | 6 ++++--
 iptables/xshared.c | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index b27502667c..221812a8f3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -197,7 +197,7 @@ AC_SUBST([blacklist_6_modules])
 regular_CFLAGS="-Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
 	-Winline -pipe";
-regular_CPPFLAGS="${largefile_cppflags} -DXT_LOCK_NAME=\\\"\${xt_lock_name}\\\" -D_REENTRANT \
+regular_CPPFLAGS="${largefile_cppflags} -D_REENTRANT \
 	-DXTABLES_LIBDIR=\\\"\${xtlibdir}\\\" -DXTABLES_INTERNAL";
 kinclude_CPPFLAGS="";
 if [[ -n "$kbuilddir" ]]; then
@@ -235,7 +235,9 @@ AC_SUBST([libxtables_vcurrent])
 AC_SUBST([libxtables_vage])
 libxtables_vmajor=$(($libxtables_vcurrent - $libxtables_vage));
 AC_SUBST([libxtables_vmajor])
-AC_SUBST([xt_lock_name])
+
+AC_DEFINE_UNQUOTED([XT_LOCK_NAME], "${xt_lock_name}",
+	[Location of the iptables lock file])
 
 AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
 	iptables/Makefile iptables/xtables.pc
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 383ecf2cf2..9b8e856e25 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1,3 +1,4 @@
+#include <config.h>
 #include <getopt.h>
 #include <errno.h>
 #include <libgen.h>
-- 
2.12.0.367.g23dc2f6d3c-goog

