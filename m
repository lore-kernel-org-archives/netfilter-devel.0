From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v2] configure: Show support for connlabel
Date: Thu, 10 Mar 2016 22:40:29 +0530
Message-ID: <20160310171028.GA8038@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34813 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbcCJRKf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 12:10:35 -0500
Received: by mail-pf0-f196.google.com with SMTP id n5so1264548pfn.1
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 09:10:35 -0800 (PST)
Received: from gmail.com ([223.176.189.156])
        by smtp.gmail.com with ESMTPSA id g74sm6898718pfj.1.2016.03.10.09.10.33
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 10 Mar 2016 09:10:34 -0800 (PST)
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
Changes in v2:
	Correct the option to disable-connlabel and add code to make it
	work

 configure.ac | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/configure.ac b/configure.ac
index 33a8f2d..afc6845 100644
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
@@ -114,15 +109,12 @@ AM_CONDITIONAL([ENABLE_LIBIPQ], [test "$enable_libipq" = "yes"])
 AM_CONDITIONAL([ENABLE_BPFC], [test "$enable_bpfc" = "yes"])
 AM_CONDITIONAL([ENABLE_SYNCONF], [test "$enable_nfsynproxy" = "yes"])
 AM_CONDITIONAL([ENABLE_NFTABLES], [test "$enable_nftables" = "yes"])
+AM_CONDITIONAL([ENABLE_CONNLABEL], [test "$enable_connlabel" = "yes"])
 
 if test "x$enable_bpfc" = "xyes" || test "x$enable_nfsynproxy" = "xyes"; then
 	AC_CHECK_LIB(pcap, pcap_compile,, AC_MSG_ERROR(missing libpcap library required by bpf compiler or nfsynproxy tool))
 fi
 
-PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0],
-	[nfnetlink=1], [nfnetlink=0])
-AM_CONDITIONAL([HAVE_LIBNFNETLINK], [test "$nfnetlink" = 1])
-
 if test "x$enable_nftables" = "xyes"; then
 	PKG_CHECK_MODULES([libmnl], [libmnl >= 1.0], [mnl=1], [mnl=0])
 
@@ -163,6 +155,25 @@ fi
 AM_CONDITIONAL([HAVE_LIBMNL], [test "$mnl" = 1])
 AM_CONDITIONAL([HAVE_LIBNFTNL], [test "$nftables" = 1])
 
+if test "x$enable_connlabel" = "xyes"; then
+	PKG_CHECK_MODULES([libnetfilter_conntrack],
+		[libnetfilter_conntrack >= 1.0.4],
+		[nfconntrack=1], [nfconntrack=0])
+
+	if test "$nfconntrack" -ne 1; then
+		blacklist_modules="$blacklist_modules connlabel";
+		echo "WARNING: libnetfilter_conntrack not found, connlabel match will not be built";
+	fi;
+
+	PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0],
+		[nfnetlink=1], [nfnetlink=0])
+else
+	blacklist_modules="$blacklist_modules connlabel";
+fi;
+
+AM_CONDITIONAL([HAVE_LIBNETFILTER_CONNTRACK], [test "$nfconntrack" = 1])
+AM_CONDITIONAL([HAVE_LIBNFNETLINK], [test "$nfnetlink" = 1])
+
 if test "$nftables" != 1; then
 	blacklist_b_modules="$blacklist_b_modules limit mark nflog mangle"
 	blacklist_a_modules="$blacklist_a_modules mangle"
@@ -243,6 +254,7 @@ Iptables Configuration:
   BPF utils support:			${enable_bpfc}
   nfsynproxy util support:		${enable_nfsynproxy}
   nftables support:			${enable_nftables}
+  connlabel support:			${enable_connlabel}
 
 Build parameters:
   Put plugins into executable (static):	${enable_static}
-- 
1.9.1

