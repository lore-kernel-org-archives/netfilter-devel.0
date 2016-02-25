From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH 2/2] iptables: Add bash completion to build routine
Date: Thu, 25 Feb 2016 16:06:54 +0100
Message-ID: <1456412814-4580-3-git-send-email-mart.frauenlob@chello.at>
References: <1456412814-4580-1-git-send-email-mart.frauenlob@chello.at>
Cc: Mart Frauenlob <mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at01-1.mx.upcmail.net ([62.179.121.145]:13518 "EHLO
	vie01a-dmta-at01-1.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760249AbcBYPHZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2016 10:07:25 -0500
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aYxVk-0004Fq-4B
	for netfilter-devel@vger.kernel.org; Thu, 25 Feb 2016 16:07:24 +0100
In-Reply-To: <1456412814-4580-1-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the configure option --enable-bashcompl (default disabled).
The PKG_CHECK_VAR requires pkg-config 0.28 or greater.

Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 configure.ac      |   13 +++++++++++++
 utils/Makefile.am |    3 +++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/configure.ac b/configure.ac
index 33a8f2d..af5149d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -63,6 +63,10 @@ AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
 AC_ARG_ENABLE([nftables],
 	AS_HELP_STRING([--disable-nftables], [Do not build nftables compat]),
 	[enable_nftables="$enableval"], [enable_nftables="yes"])
+AC_ARG_ENABLE([bashcompl],
+	AS_HELP_STRING([--enable-bashcompl],
+	[Install bash completion for iptables]),
+	[enable_bashcompl="$enableval"], [enable_bashcompl="no"])
 
 libiptc_LDFLAGS2="";
 AX_CHECK_LINKER_FLAGS([-Wl,--no-as-needed],
@@ -160,6 +164,11 @@ if test "x$enable_nftables" = "xyes"; then
 	fi
 fi
 
+if test "x$enable_bashcompl" = "xyes"; then
+	PKG_CHECK_VAR(bashcompdir, [bash-completion], [completionsdir], , bashcompdir="${sysconfdir}/bash_completion.d")
+	AC_SUBST(bashcompdir)
+fi
+
 AM_CONDITIONAL([HAVE_LIBMNL], [test "$mnl" = 1])
 AM_CONDITIONAL([HAVE_LIBNFTNL], [test "$nftables" = 1])
 
@@ -242,6 +251,7 @@ Iptables Configuration:
   Large file support:			${enable_largefile}
   BPF utils support:			${enable_bpfc}
   nfsynproxy util support:		${enable_nfsynproxy}
+  bash completion support:		${enable_bashcompl}
   nftables support:			${enable_nftables}
 
 Build parameters:
@@ -251,6 +261,9 @@ Build parameters:
   Xtables extension directory:		${e_xtlibdir}
   Pkg-config directory:			${e_pkgconfigdir}"
 
+if [[ -n "$bashcompdir" ]]; then
+	echo "  Bash completion directory:		${bashcompdir}"
+fi;
 if [[ -n "$ksourcedir" ]]; then
 	echo "  Kernel source directory:		${ksourcedir}"
 fi;
diff --git a/utils/Makefile.am b/utils/Makefile.am
index c4192a9..c660390 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -23,3 +23,6 @@ if ENABLE_SYNCONF
 sbin_PROGRAMS += nfsynproxy
 nfsynproxy_LDADD = -lpcap
 endif
+
+bashcompdir = @bashcompdir@
+dist_bashcomp_DATA = iptables-bash_completion/iptables
-- 
1.7.2.5

