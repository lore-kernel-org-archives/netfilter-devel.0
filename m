From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] build: add finer module blacklisting
Date: Tue, 18 Aug 2015 18:48:54 -0400
Message-ID: <1439938134-1930-1-git-send-email-vapier@gentoo.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:59875 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbbHRWs6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 18:48:58 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id F07463409B7
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2015 22:48:57 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Newer extensions require libnftnl in order to build, but there are no
configure or build checks for it, which leads to a bunch of modules
failing when libnftnl isn't installed.  Add finer grained blacklisting
so we can disable modules for specific parts rather than all of them.
e.g. We want to blacklist libebt_limit, but not libxt_limit.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 configure.ac              | 20 ++++++++++++++++++--
 extensions/GNUmakefile.in | 10 +++++-----
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/configure.ac b/configure.ac
index 46606cf..de588d8 100644
--- a/configure.ac
+++ b/configure.ac
@@ -78,7 +78,12 @@ AC_LINK_IFELSE([AC_LANG_SOURCE([int main(void) {}])],
 )
 LDFLAGS="$saved_LDFLAGS";
 
-blacklist_modules="";
+blacklist_modules=""
+blacklist_x_modules=""
+blacklist_b_modules=""
+blacklist_a_modules=""
+blacklist_4_modules=""
+blacklist_6_modules=""
 
 AC_CHECK_HEADERS([linux/dccp.h linux/ip_vs.h linux/magic.h linux/proc_fs.h])
 if test "$ac_cv_header_linux_dccp_h" != "yes"; then
@@ -97,7 +102,6 @@ if test "$nfconntrack" -ne 1; then
 	echo "WARNING: libnetfilter_conntrack not found, connlabel match will not be built";
 fi;
 
-AC_SUBST([blacklist_modules])
 AC_CHECK_SIZEOF([struct ip6_hdr], [], [#include <netinet/ip6.h>])
 
 AM_CONDITIONAL([ENABLE_STATIC], [test "$enable_static" = "yes"])
@@ -166,6 +170,18 @@ if test "$mnl" != 1 -o "$nftables" != 1; then
 fi
 AM_CONDITIONAL([ENABLE_NFTABLES], [test "$enable_nftables" = "yes"])
 
+if test "$nftables" != 1; then
+	blacklist_b_modules="$blacklist_b_modules limit mark nflog mangle"
+	blacklist_a_modules="$blacklist_a_modules mangle"
+fi
+
+AC_SUBST([blacklist_modules])
+AC_SUBST([blacklist_x_modules])
+AC_SUBST([blacklist_b_modules])
+AC_SUBST([blacklist_a_modules])
+AC_SUBST([blacklist_4_modules])
+AC_SUBST([blacklist_6_modules])
+
 regular_CFLAGS="-Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
 	-Winline -pipe";
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 181e155..53be2cd 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -44,11 +44,11 @@ pfa_build_mod := $(patsubst ${srcdir}/libarpt_%.c,%,$(sort $(wildcard ${srcdir}/
 pfx_symlinks  := NOTRACK state
 @ENABLE_IPV4_TRUE@ pf4_build_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(sort $(wildcard ${srcdir}/libipt_*.c)))
 @ENABLE_IPV6_TRUE@ pf6_build_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(sort $(wildcard ${srcdir}/libip6t_*.c)))
-pfx_build_mod := $(filter-out @blacklist_modules@,${pfx_build_mod})
-pfb_build_mod := $(filter-out @blacklist_modules@,${pfb_build_mod})
-pfa_build_mod := $(filter-out @blacklist_modules@,${pfa_build_mod})
-pf4_build_mod := $(filter-out @blacklist_modules@,${pf4_build_mod})
-pf6_build_mod := $(filter-out @blacklist_modules@,${pf6_build_mod})
+pfx_build_mod := $(filter-out @blacklist_modules@ @blacklist_x_modules@,${pfx_build_mod})
+pfb_build_mod := $(filter-out @blacklist_modules@ @blacklist_b_modules@,${pfb_build_mod})
+pfa_build_mod := $(filter-out @blacklist_modules@ @blacklist_a_modules@,${pfa_build_mod})
+pf4_build_mod := $(filter-out @blacklist_modules@ @blacklist_4_modules@,${pf4_build_mod})
+pf6_build_mod := $(filter-out @blacklist_modules@ @blacklist_6_modules@,${pf6_build_mod})
 pfx_objs      := $(patsubst %,libxt_%.o,${pfx_build_mod})
 pfb_objs      := $(patsubst %,libebt_%.o,${pfb_build_mod})
 pfa_objs      := $(patsubst %,libarpt_%.o,${pfa_build_mod})
-- 
2.4.4

