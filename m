From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 05/10] Update documentation about building the package
Date: Tue, 15 Apr 2008 12:33:23 +0200
Message-ID: <d1acf22eb0056337f64b6da78c85f8021c52badc.1208255176.git.jengelh@computergmbh.de>
References: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34600 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbYDOKda (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 06:33:30 -0400
In-Reply-To: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <0e1521015bea15f495f191fa5534eb65ad9bd43f.1208255176.git.jengelh@computergmbh.de>
References: <0e1521015bea15f495f191fa5534eb65ad9bd43f.1208255176.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 INSTALL      |   96 ++++++++++++++++++++++++++++++++------------------
 configure.ac |    4 +-
 2 files changed, 64 insertions(+), 36 deletions(-)

diff --git a/INSTALL b/INSTALL
index a41e0cc..4a44989 100644
--- a/INSTALL
+++ b/INSTALL
@@ -1,52 +1,80 @@
-FOLLOW THESE STEPS:
+Installation instructions for iptables
+======================================
 
-0) There may be some outstanding bugfixes or tweaks which are not yet
-   in the official kernel.  Those are now (as of iptables-1.2.7) kept
-   in a seperate package, called patch-o-matic.  It is available from
-   ftp://ftp.netfilter.org/pub/patch-o-matic/
+iptables uses the well-known configure(autotools) infrastructure.
 
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
+	* no kernel-source required
 
-	$ ./configure --with-kbuild=<<where-built>> --with-ksource=<<source>>
+	* but obviously a compiler, glibc-devel and linux-kernel-headers
+	  (/usr/include/linux)
 
-2) Finally, you need to install the binaries and shared libraries:
 
-	# make install
+Configuring and compiling
+=========================
 
-That's it!
-================================================================
-PROBLEMS YOU MAY ENCOUNTER:
+./configure [options]
 
-1) This package requires a 2.4.4 kernel, or above.
+--prefix=
 
-2) If you get the kernel directory wrong, you may get compile failures.
+	The prefix to put all installed files under. It defaults to
+	/usr/local, so the binaries will go into /usr/local/bin, sbin,
+	manpages into /usr/local/share/man, etc.
 
-3) If you want to specify alternate directories for installation
-(instead of /usr/local/ bin lib man), do this:
+--with-xtlibdir=
 
-	$ ./configure --prefix=/usr
-	$ make
-	# make install
+	The path to where Xtables extensions should be installed to. It
+	defaults to ${prefix}/libexec/xtables.
+
+--enable-devel (or --disable-devel)
+
+	This option causes development files to be installed to
+	${includedir}, which is needed for building additional packages,
+	such as Xtables-addons or other 3rd-party extensions.
+
+	It is enabled by default.
+
+--enable-libipq
+
+	This option causes libipq to be installed into ${libdir} and
+	${includedir}.
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
index 10d4380..42fb728 100644
--- a/configure.ac
+++ b/configure.ac
@@ -22,9 +22,9 @@ AC_ARG_WITH([ksource],
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
 	[Install Xtables development headers]),
-- 
1.5.5.rc3

