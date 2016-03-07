From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] configure: Show support for connlabel
Date: Mon, 7 Mar 2016 14:44:47 +0530
Message-ID: <20160307091447.GA10194@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33809 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbcCGJOx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 04:14:53 -0500
Received: by mail-pa0-f41.google.com with SMTP id fy10so75312944pac.1
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Mar 2016 01:14:53 -0800 (PST)
Received: from gmail.com ([106.212.1.83])
        by smtp.gmail.com with ESMTPSA id w20sm22621146pfi.31.2016.03.07.01.14.51
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 07 Mar 2016 01:14:52 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the --enable-connlabel option and show whether it is already
supported.

After this patch, iptables configuration shows up as:

Iptables Configuration:
  IPv4 support:				yes
  IPv6 support:				yes
  Devel support:			yes
  IPQ support:				no
  Large file support:			yes
  BPF utils support:			no
  nfsynproxy util support:		no
  nftables support:			yes
  connlabel support:			yes

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 configure.ac | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/configure.ac b/configure.ac
index 33a8f2d..c946d69 100644
--- a/configure.ac
+++ b/configure.ac
@@ -63,6 +63,9 @@ AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
 AC_ARG_ENABLE([nftables],
 	AS_HELP_STRING([--disable-nftables], [Do not build nftables compat]),
 	[enable_nftables="$enableval"], [enable_nftables="yes"])
+AC_ARG_ENABLE([connlabel],
+	AS_HELP_STRING([--enable-connlabel], [Build libnetfilter_conntrack]),
+	[enable_connlabel="$enableval"], [enable_connlabel="yes"])
 
 libiptc_LDFLAGS2="";
 AX_CHECK_LINKER_FLAGS([-Wl,--no-as-needed],
@@ -114,6 +117,7 @@ AM_CONDITIONAL([ENABLE_LIBIPQ], [test "$enable_libipq" = "yes"])
 AM_CONDITIONAL([ENABLE_BPFC], [test "$enable_bpfc" = "yes"])
 AM_CONDITIONAL([ENABLE_SYNCONF], [test "$enable_nfsynproxy" = "yes"])
 AM_CONDITIONAL([ENABLE_NFTABLES], [test "$enable_nftables" = "yes"])
+AM_CONDITIONAL([ENABLE_CONNLABEL], [test "$enable_connlabel" = "yes"])
 
 if test "x$enable_bpfc" = "xyes" || test "x$enable_nfsynproxy" = "xyes"; then
 	AC_CHECK_LIB(pcap, pcap_compile,, AC_MSG_ERROR(missing libpcap library required by bpf compiler or nfsynproxy tool))
@@ -243,6 +247,7 @@ Iptables Configuration:
   BPF utils support:			${enable_bpfc}
   nfsynproxy util support:		${enable_nfsynproxy}
   nftables support:			${enable_nftables}
+  connlabel support:			${enable_connlabel}
 
 Build parameters:
   Put plugins into executable (static):	${enable_static}
-- 
1.9.1

