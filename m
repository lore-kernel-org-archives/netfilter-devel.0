From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 14/24] Update package name (Xtables) and documentation
Date: Tue, 4 Mar 2008 17:04:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041702550.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44003 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYCDQEd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:04:33 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit a4611e2d805be5d75fa2224a838f70fb14410cb9
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Feb 11 14:11:14 2008 +0100

    Update package name (Xtables) and documentation
---
 INSTALL      |   90 +++++++++++++++++++++++++++++++-------------------
 configure.ac |    6 ++--
 2 files changed, 59 insertions(+), 37 deletions(-)

diff --git a/INSTALL b/INSTALL
index a41e0cc..7b4cb9b 100644
--- a/INSTALL
+++ b/INSTALL
@@ -1,52 +1,74 @@
-FOLLOW THESE STEPS:
+Installation instructions for Xtables
+=====================================
 
-0) There may be some outstanding bugfixes or tweaks which are not yet
-   in the official kernel.  Those are now (as of iptables-1.2.7) kept
-   in a seperate package, called patch-o-matic.  It is available from
-   ftp://ftp.netfilter.org/pub/patch-o-matic/
+Xtables uses the well-known configure(autotools) infrastructure.
 
-1) Next, make the package. If you use a standard distribution kernel,
-   just run ./configure.
+	$ ./configure
+	$ make
+	# make install
 
-   If you want to build against an own kernel tree:
 
-	$ ./configure --with-kernel=/home/jengelh/mykernel
+Prerequisites
+=============
 
-   or whereever you put it. If you are using a dedicated kernel build
-   directory, you use:
+	* no other packages required
+	  (well, you obviously need the basics like a compiler)
 
-	$ ./configure --with-kbuild=<<where-built>> --with-ksource=<<source>>
 
-2) Finally, you need to install the binaries and shared libraries:
+Configuring and compiling
+=========================
 
-	# make install
+./configure [options]
 
-That's it!
-================================================================
-PROBLEMS YOU MAY ENCOUNTER:
+--prefix=
 
-1) This package requires a 2.4.4 kernel, or above.
+	The prefix to put all installed files under. It defaults to
+	/usr/local, so the binaries will go into /usr/local/bin, sbin,
+	manpages into /usr/local/share/man, etc.
 
-2) If you get the kernel directory wrong, you may get compile failures.
+--xtlibdir=
 
-3) If you want to specify alternate directories for installation
-(instead of /usr/local/ bin lib man), do this:
+	The path to where Xtables extensions should be installed to. It
+	defaults to ${prefix}/libexec/xtables.
 
-	$ ./configure --prefix=/usr
-	$ make
-	# make install
+--enable-devel
+
+	This causes development files to be installed to
+	${prefix}/include. (By default, no headers and libraries are
+	installed.)
+
+	This is needed for building additional packages,
+	such as Xtables-addons or other 3rd-party extensions.
+
+--enable-static
+
+	Enable building single standalone multipurpose binaries,
+	(iptables-static and ip6tables-static), which contain every
+	extension compiled-in (and does not support additional
+	extensions).
+
+--with-ksource=
+
+	Xtables does not depend on kernel headers anymore, but you can
+	optionally specify a search path to include anyway. This is
+	probably only useful for development.
+
+If you want to enable debugging, use
+
+	./configure CFLAGS="-ggdb3 -O0"
 
-4) The make process will automatically build a multipurpose binary under the
-   names iptables-multi and ip6tables-multi.
+(-O0 is used to turn off instruction reordering, which makes debugging
+much easier.)
 
-5) If you want to build a statically linked version of the iptables binary,
-   without the need for loading the plugins at runtime (e.g. for an embedded
-   device or router-on-a-disk), please use
 
-	$ ./configure --enable-static
+Other notes
+===========
 
-   which will build both a semi-static multi binary (iptables-mtss, uses
-   libc but not plugins) and a fully static multi binary (iptables-static).
+The make process will automatically build multipurpose binaries.
+These have the core (iptables), -save, -restore and -xml code
+compiled into one binary, but extensions remain as modules.
 
-6) If you want to install libipq (old interface), add --enable-devel to
-   ./configure.
+If you want to build a statically linked version of the iptables binary,
+without the need for loading the plugins at runtime (e.g. for an
+embedded device or router-on-a-disk), you can use the --enable-static
+configure flag.
diff --git a/configure.ac b/configure.ac
index 4c18cb0..261356f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -22,12 +22,12 @@ AC_ARG_WITH([ksource],
 	[ksourcedir="$withval"])
 AC_ARG_WITH([xtlibdir],
 	AS_HELP_STRING([--with-xtlibdir=PATH],
-	[Path to iptables modules [[LIBEXECDIR/iptables]]]),
+	[Path where to install Xtables extensions [[LIBEXECDIR/xtables]]]),
 	[xtlibdir="$withval"],
-	[xtlibdir="${libexecdir}/iptables"])
+	[xtlibdir="${libexecdir}/xtables"])
 AC_ARG_ENABLE([devel],
 	AS_HELP_STRING([--enable-devel],
-	[Build and install development files (libipq, libipq-devel, iptables-devel)]))
+	[Build and install development files (libipq, libipq-devel, xtables-devel)]))
 
 AC_CHECK_HEADER([netinet/ip6.h], [], [AC_MSG_ERROR(but we need that for IPv6)])
 AM_CONDITIONAL([ENABLE_STATIC], [test "$enable_static" == "yes"])
