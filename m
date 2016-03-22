From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v4] configure: Show support for connlabel
Date: Tue, 22 Mar 2016 10:43:06 +0530
Message-ID: <20160322051306.GA9115@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36355 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbcCVFNo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 01:13:44 -0400
Received: by mail-pf0-f195.google.com with SMTP id q129so34290791pfb.3
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2016 22:13:44 -0700 (PDT)
Received: from gmail.com ([116.202.34.149])
        by smtp.gmail.com with ESMTPSA id fn3sm44610055pab.20.2016.03.21.22.13.41
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 21 Mar 2016 22:13:43 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the --disable-connlabel option and the appropriate functionality
associated with it.

After this patch, iptables configuration shows up as:

Iptables Configuration:
  IPv4 support:                         yes
  IPv6 support:                         yes
  Devel support:                        yes
  IPQ support:                          no
  Large file support:                   yes
  BPF utils support:                    no
  nfsynproxy util support:              no
  nftables support:                     yes
  connlabel support:                    yes

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v4:
	Set enable_connlabel to "no" when package requirements are not
	met

Changes in v3:
        Remove check for libnfnetlink from the if block

Changes in v2:
	Correct the option to disable-connlabel and add code to make it
	work

 configure.ac | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/configure.ac b/configure.ac
index 33a8f2d..12bffa9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -63,6 +63,10 @@ AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
 AC_ARG_ENABLE([nftables],
 	AS_HELP_STRING([--disable-nftables], [Do not build nftables compat]),
 	[enable_nftables="$enableval"], [enable_nftables="yes"])
+AC_ARG_ENABLE([connlabel],
+	AS_HELP_STRING([--disable-connlabel],
+	[Do not build libnetfilter_conntrack]),
+	[enable_connlabel="$enableval"], [enable_connlabel="yes"])
 
 libiptc_LDFLAGS2="";
 AX_CHECK_LINKER_FLAGS([-Wl,--no-as-needed],
@@ -93,15 +97,6 @@ if test "$ac_cv_header_linux_ip_vs_h" != "yes"; then
 	blacklist_modules="$blacklist_modules ipvs";
 fi;
 
-PKG_CHECK_MODULES([libnetfilter_conntrack], [libnetfilter_conntrack >= 1.0.4],
-	[nfconntrack=1], [nfconntrack=0])
-AM_CONDITIONAL([HAVE_LIBNETFILTER_CONNTRACK], [test "$nfconntrack" = 1])
-
-if test "$nfconntrack" -ne 1; then
-	blacklist_modules="$blacklist_modules connlabel";
-	echo "WARNING: libnetfilter_conntrack not found, connlabel match will not be built";
-fi;
-
 AC_CHECK_SIZEOF([struct ip6_hdr], [], [#include <netinet/ip6.h>])
 
 AM_CONDITIONAL([ENABLE_STATIC], [test "$enable_static" = "yes"])
@@ -114,6 +109,7 @@ AM_CONDITIONAL([ENABLE_LIBIPQ], [test "$enable_libipq" = "yes"])
 AM_CONDITIONAL([ENABLE_BPFC], [test "$enable_bpfc" = "yes"])
 AM_CONDITIONAL([ENABLE_SYNCONF], [test "$enable_nfsynproxy" = "yes"])
 AM_CONDITIONAL([ENABLE_NFTABLES], [test "$enable_nftables" = "yes"])
+AM_CONDITIONAL([ENABLE_CONNLABEL], [test "$enable_connlabel" = "yes"])
 
 if test "x$enable_bpfc" = "xyes" || test "x$enable_nfsynproxy" = "xyes"; then
 	AC_CHECK_LIB(pcap, pcap_compile,, AC_MSG_ERROR(missing libpcap library required by bpf compiler or nfsynproxy tool))
@@ -168,6 +164,22 @@ if test "$nftables" != 1; then
 	blacklist_a_modules="$blacklist_a_modules mangle"
 fi
 
+if test "x$enable_connlabel" = "xyes"; then
+	PKG_CHECK_MODULES([libnetfilter_conntrack],
+		[libnetfilter_conntrack >= 1.0.4],
+		[nfconntrack=1], [nfconntrack=0])
+
+	if test "$nfconntrack" -ne 1; then
+		blacklist_modules="$blacklist_modules connlabel";
+		echo "WARNING: libnetfilter_conntrack not found, connlabel match will not be built";
+		enable_connlabel = "no";
+	fi;
+else
+	blacklist_modules="$blacklist_modules connlabel";
+fi;
+
+AM_CONDITIONAL([HAVE_LIBNETFILTER_CONNTRACK], [test "$nfconntrack" = 1])
+
 AC_SUBST([blacklist_modules])
 AC_SUBST([blacklist_x_modules])
 AC_SUBST([blacklist_b_modules])
@@ -243,6 +255,7 @@ Iptables Configuration:
   BPF utils support:			${enable_bpfc}
   nfsynproxy util support:		${enable_nfsynproxy}
   nftables support:			${enable_nftables}
+  connlabel support:			${enable_connlabel}
 
 Build parameters:
   Put plugins into executable (static):	${enable_static}
-- 
1.9.1

