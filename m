From: Phil Sutter <phil@nwl.cc>
Subject: [iptables PATCH 2/2] utils: Add a man page for nfnl_osf
Date: Wed, 20 Sep 2017 18:54:09 +0200
Message-ID: <20170920165409.11456-3-phil@nwl.cc>
References: <20170920165409.11456-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:41440 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750973AbdITQyb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2017 12:54:31 -0400
In-Reply-To: <20170920165409.11456-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 configure.ac        |  3 ++-
 utils/.gitignore    |  1 +
 utils/Makefile.am   |  4 ++++
 utils/nfnl_osf.8.in | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 74 insertions(+), 1 deletion(-)
 create mode 100644 utils/nfnl_osf.8.in

diff --git a/configure.ac b/configure.ac
index 221812a8f3f1f..9ca74743108ee 100644
--- a/configure.ac
+++ b/configure.ac
@@ -248,7 +248,8 @@ AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
 	libiptc/Makefile libiptc/libiptc.pc
 	libiptc/libip4tc.pc libiptc/libip6tc.pc
 	libxtables/Makefile utils/Makefile
-	include/xtables-version.h include/iptables/internal.h])
+	include/xtables-version.h include/iptables/internal.h
+	utils/nfnl_osf.8])
 AC_OUTPUT
 
 
diff --git a/utils/.gitignore b/utils/.gitignore
index 216d1e4a621ed..7c6afbf4e6a52 100644
--- a/utils/.gitignore
+++ b/utils/.gitignore
@@ -1,2 +1,3 @@
 /nfnl_osf
+/nfnl_osf.8
 /nfbpf_compile
diff --git a/utils/Makefile.am b/utils/Makefile.am
index c4192a9e73688..80029e303ff3b 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -6,8 +6,10 @@ AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_builddir}/include \
 
 sbin_PROGRAMS =
 pkgdata_DATA =
+man_MANS =
 
 if HAVE_LIBNFNETLINK
+man_MANS += nfnl_osf.8
 sbin_PROGRAMS += nfnl_osf
 pkgdata_DATA += pf.os
 
@@ -23,3 +25,5 @@ if ENABLE_SYNCONF
 sbin_PROGRAMS += nfsynproxy
 nfsynproxy_LDADD = -lpcap
 endif
+
+CLEANFILES = nfnl_osf.8
diff --git a/utils/nfnl_osf.8.in b/utils/nfnl_osf.8.in
new file mode 100644
index 0000000000000..dfff608928032
--- /dev/null
+++ b/utils/nfnl_osf.8.in
@@ -0,0 +1,67 @@
+.TH NFNL_OSF 8 "" "@PACKAGE_STRING@" "@PACKAGE_STRING@"
+
+.SH NAME
+nfnl_osf \- OS fingerprint loader utility
+.SH SYNOPSIS
+
+.ad l
+.in +8
+.ti -8
+.B nfnl_osf
+.BI -f " fingerprints"
+[
+.B -d
+]
+
+.SH DESCRIPTION
+The
+.B nfnl_osf
+utility allows to load a set of operating system signatures into the kernel for
+later matching against using iptables'
+.B osf
+match.
+
+.SH OPTIONS
+
+.TP
+.BI -f " fingerprints"
+Read signatures from file
+.IR fingerprints .
+
+.TP
+.B -d
+Instead of adding the signatures from
+.I fingerprints
+into the kernel, remove them.
+
+.SH EXIT STATUS
+Exit status is 0 if command succeeded, otherwise a negative return code
+indicates the type of error which happened:
+
+.TP
+.B -1
+Illegal arguments passed, fingerprints file not readable or failure in netlink
+communication.
+
+.TP
+.B -ENOENT
+Fingerprints file not specified.
+
+.TP
+.B -EINVAL
+Netlink handle initialization failed or fingerprints file format invalid.
+
+.SH FILES
+
+An up to date set of operating system signatures can be downloaded from
+http://www.openbsd.org/cgi-bin/cvsweb/src/etc/pf.os .
+
+.SH SEE ALSO
+
+The description of
+.B osf
+match in 
+.BR iptables-extensions (8)
+contains further information about the topic as well as example
+.B nfnl_osf
+invocations.
-- 
2.13.1

