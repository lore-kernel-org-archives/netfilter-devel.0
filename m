From: "David Vogt" <beunlovable@gmail.com>
Subject: Fix --with-kernel for libnfnetlink
Date: Thu, 20 Apr 2006 17:25:11 +0200
Message-ID: <859616420604200825o71f81878lbbb45251f1e0330d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Amin Azez <azez@ufomechanic.net>, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

Amin Azez has helped me with some trouble concerning the compilation
of libnfnetlink.
The --with-kernel parameter for the configure script did not work as
intended, so Amin has proposed the following changes that 1) look for
the kernel sources 2) recognise --with-kernel parameter.

Index: configure.in
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- configure.in=09(revision 6582)
+++ configure.in=09(working copy)
@@ -18,6 +18,47 @@


 dnl--------------------------------
+AC_DEFUN([NF_KERNEL_SOURCE],[
+
+ if test "$with_kernel" =3D ""; then
+   KERNEL=3D"`uname -r`"
+ else
+   KERNEL=3D"$with_kernel"
+ fi
+
+ THIS_PREFIX=3D""
+ for i in "/lib/modules/$KERNEL/build/include" "$KERNEL"
"$KERNEL/include" "/usr/src/linux-$KERNEL" "/usr/src/kernel-$KERNEL"
"/usr/src/linux-headers-$KERNEL" "/usr/src/kernel-headers-$KERNEL"
+ do
+   AC_MSG_CHECKING([Looking for kernel source or headers in $i])
+   if test -r "$i/linux/config.h"
+   then
+     THIS_PREFIX=3D"$i"
+     AC_MSG_RESULT([found])
+     break
+   fi
+   AC_MSG_RESULT([ ])
+ done
+ if test -r "$THIS_PREFIX/linux/config.h" ; then
+   AC_SUBST(KERNELDIR,[$THIS_PREFIX])
+   AC_MSG_RESULT([found])
+ else
+   AC_MSG_ERROR([not found $THIS_PREFIX])
+ fi
+
+ # somehow add this as an include path
+])
+
+AC_ARG_WITH(kernel,
+              AC_HELP_STRING([--with-kernel=3DDIR],
+                             [ Show location of kernel source.
Default is to use uname -r and look in
/lib/modules/KERNEL/build/include. ]),
+              NF_KERNEL_SOURCE($with_kernel),NF_KERNEL_SOURCE())
+
+if test ! -z "$libdir"; then
+  MODULE_DIR=3D"\\\"$libdir/\\\""
+  CFLAGS=3D"$CFLAGS -DCONNTRACK_LIB_DIR=3D$MODULE_DIR"
+fi
+
+
 dnl--------------------------------


Index: src/Makefile.am
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- src/Makefile.am=09(revision 6582)
+++ src/Makefile.am=09(working copy)
@@ -2,7 +2,7 @@
 # Please read Chapter 6 "Library interface versions" of the libtool
documentation before making any modification
 LIBVERSION=3D1:0:0

-INCLUDES =3D $(all_includes) -I$(top_srcdir)/include
+INCLUDES =3D $(all_includes) -I$(top_srcdir)/include -I$(KERNELDIR)
 AM_CFLAGS=3D-fPIC -Wall
 LIBS=3D
