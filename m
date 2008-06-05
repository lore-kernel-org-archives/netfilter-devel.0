From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [netfilter-core] [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Thu, 5 Jun 2008 19:53:51 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806051953430.29055@fbirervta.pbzchgretzou.qr>
References: <483AB493.6010503@trash.net> <x6skw443x5@gzp> <483BB9DE.6050003@trash.net> <x6y75w3q2j@gzp> <483C088E.4020405@trash.net> <x67idfq6d8@gzp> <483CFF21.40608@trash.net> <4847F64C.2040902@trash.net> <x663snremo@gzp> <4848200A.3060600@trash.net>
 <alpine.LNX.1.10.0806051946330.29055@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Gabor Z. Papp" <gzp@papp.hu>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36495 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbYFERxw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2008 13:53:52 -0400
In-Reply-To: <alpine.LNX.1.10.0806051946330.29055@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 1ebc55e29f220082814a97e541427be7746400e0
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Jun 5 19:48:31 2008 +0200

    build: check for missing feature files
    
    linux/dccp.h is unlikely to be installed before 2.6.18 (which was
    when headers_install was introduced), and does not exist at all
    before 2.6.14. Add a compile-time check to skip compilation of
    libxt_dccp in case this was detected.
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac              |    8 ++++++++
 extensions/GNUmakefile.in |    3 +++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/configure.ac b/configure.ac
index e718eff..d063605 100644
--- a/configure.ac
+++ b/configure.ac
@@ -39,6 +39,14 @@ AC_ARG_ENABLE([libipq],
 	AS_HELP_STRING([--enable-libipq], [Build and install libipq]))
 
 AC_CHECK_HEADER([netinet/ip6.h], [], [AC_MSG_ERROR(but we need that for IPv6)])
+AC_CHECK_HEADER([linux/dccp.h])
+
+blacklist_modules="";
+if test "$ac_cv_header_linux_dccp_h" != "yes"; then
+	blacklist_modules="$blacklist_modules dccp";
+fi;
+AC_SUBST([blacklist_modules])
+
 AM_CONDITIONAL([ENABLE_STATIC], [test "$enable_static" == "yes"])
 AM_CONDITIONAL([ENABLE_SHARED], [test "$enable_shared" == "yes"])
 AM_CONDITIONAL([ENABLE_DEVEL], [test "$enable_devel" == "yes"])
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 9419574..8d44e4e 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -37,6 +37,9 @@ endif
 pfx_build_mod := $(patsubst ${srcdir}/libxt_%.c,%,$(wildcard ${srcdir}/libxt_*.c))
 pf4_build_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(wildcard ${srcdir}/libipt_*.c))
 pf6_build_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(wildcard ${srcdir}/libip6t_*.c))
+pfx_build_mod := $(filter-out @blacklist_modules@,${pfx_build_mod})
+pf4_build_mod := $(filter-out @blacklist_modules@,${pf4_build_mod})
+pf6_build_mod := $(filter-out @blacklist_modules@,${pf6_build_mod})
 pfx_objs      := $(patsubst %,libxt_%.o,${pfx_build_mod})
 pf4_objs      := $(patsubst %,libipt_%.o,${pf4_build_mod})
 pf6_objs      := $(patsubst %,libip6t_%.o,${pf6_build_mod})
