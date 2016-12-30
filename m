From: Keno Fischer <keno@juliacomputing.com>
Subject: [PATCH] Add a configure flag to link libc statically
Date: Fri, 30 Dec 2016 00:44:26 -0500
Message-ID: <20161230054426.GA9694@juliacomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:32862 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbcL3Fo3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Dec 2016 00:44:29 -0500
Received: by mail-qk0-f174.google.com with SMTP id t184so289936298qkd.0
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Dec 2016 21:44:28 -0800 (PST)
Received: from juliacomputing.com ([2601:184:4380:e6e:801d:58a2:bb9:dc])
        by smtp.gmail.com with ESMTPSA id q3sm34613260qtc.34.2016.12.29.21.44.27
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Dec 2016 21:44:27 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The primary concern here is probably that iptables uses functions
that in glibc still require the dynamic library at runtime. However,
for my usage of iptables, I have never actually run into this situation,
and even if I did, I'd rather switch libcs (though I may be in the
minority there). Nevertheless, I think it would be useful to have
this option available for those wanting a statically linked iptables.

Signed-off-by: Keno Fischer <keno@juliacomputing.com>
---
 configure.ac         | 10 ++++++++++
 iptables/Makefile.am |  6 ++++++
 2 files changed, 16 insertions(+)

diff --git a/configure.ac b/configure.ac
index 6ae63f8..a787de9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -67,6 +67,9 @@ AC_ARG_ENABLE([connlabel],
 	AS_HELP_STRING([--disable-connlabel],
 	[Do not build libnetfilter_conntrack]),
 	[enable_connlabel="$enableval"], [enable_connlabel="yes"])
+AC_ARG_ENABLE([static_executables],
+	AS_HELP_STRING([--enable-static-executables], [Statically link executables against libc]),
+	[enable_static_executables="$enableval"], [enable_static_executables="no"])
 
 libiptc_LDFLAGS2="";
 AX_CHECK_LINKER_FLAGS([-Wl,--no-as-needed],
@@ -100,6 +103,7 @@ fi;
 AC_CHECK_SIZEOF([struct ip6_hdr], [], [#include <netinet/ip6.h>])
 
 AM_CONDITIONAL([ENABLE_STATIC], [test "$enable_static" = "yes"])
+AM_CONDITIONAL([ENABLE_STATIC_EXECUTABLES], [test "$enable_static_executables" = "yes"])
 AM_CONDITIONAL([ENABLE_SHARED], [test "$enable_shared" = "yes"])
 AM_CONDITIONAL([ENABLE_IPV4], [test "$enable_ipv4" = "yes"])
 AM_CONDITIONAL([ENABLE_IPV6], [test "$enable_ipv6" = "yes"])
@@ -111,6 +115,11 @@ AM_CONDITIONAL([ENABLE_SYNCONF], [test "$enable_nfsynproxy" = "yes"])
 AM_CONDITIONAL([ENABLE_NFTABLES], [test "$enable_nftables" = "yes"])
 AM_CONDITIONAL([ENABLE_CONNLABEL], [test "$enable_connlabel" = "yes"])
 
+if test "x$enable_static_executables" = "xyes" && test "x$enable_static" != "xyes"; then
+    echo "*** Error: --enable-static-executables without --enable-static. ***"
+    exit 1
+fi
+
 if test "x$enable_bpfc" = "xyes" || test "x$enable_nfsynproxy" = "xyes"; then
 	AC_CHECK_LIB(pcap, pcap_compile,, AC_MSG_ERROR(missing libpcap library required by bpf compiler or nfsynproxy tool))
 fi
@@ -262,6 +271,7 @@ Iptables Configuration:
 
 Build parameters:
   Put plugins into executable (static):	${enable_static}
+  Build static executables (static-executables): ${enable_static_executables}
   Support plugins via dlopen (shared):	${enable_shared}
   Installation prefix (--prefix):	${prefix}
   Xtables extension directory:		${e_xtlibdir}
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index f92cc4f..5c3edec 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -12,6 +12,9 @@ xtables_multi_LDADD    = ../extensions/libext.a
 if ENABLE_STATIC
 xtables_multi_CFLAGS  += -DALL_INCLUSIVE
 endif
+if ENABLE_STATIC_EXECUTABLES
+xtables_multi_LDFLAGS  = ${AM_LDFLAGS} -all-static
+endif
 if ENABLE_IPV4
 xtables_multi_SOURCES += iptables-save.c iptables-restore.c \
                          iptables-standalone.c iptables.c
@@ -36,6 +39,9 @@ xtables_compat_multi_LDADD    = ../extensions/libext.a ../extensions/libext_ebt.
 if ENABLE_STATIC
 xtables_compat_multi_CFLAGS  += -DALL_INCLUSIVE
 endif
+if ENABLE_STATIC_EXECUTABLES
+xtables_compat_multi_LDFLAGS  = ${AM_LDFLAGS} -all-static
+endif
 xtables_compat_multi_CFLAGS  += -DENABLE_NFTABLES -DENABLE_IPV4 -DENABLE_IPV6
 xtables_compat_multi_SOURCES += xtables-config-parser.y xtables-config-syntax.l
 xtables_compat_multi_SOURCES += xtables-save.c xtables-restore.c \
-- 
2.9.3

