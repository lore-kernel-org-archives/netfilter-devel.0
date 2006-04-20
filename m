From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Fix --with-kernel for libnfnetlink
Date: Thu, 20 Apr 2006 17:33:26 +0100
Message-ID: <4447B7D6.5050404@ufomechanic.net>
References: <859616420604200825o71f81878lbbb45251f1e0330d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <859616420604200825o71f81878lbbb45251f1e0330d@mail.gmail.com>
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

A similar change is probably good for libctnetlink and any other 
projects that look for kernel headers,

Sam

David Vogt wrote:
> Hi,
> 
> Amin Azez has helped me with some trouble concerning the compilation
> of libnfnetlink.
> The --with-kernel parameter for the configure script did not work as
> intended, so Amin has proposed the following changes that 1) look for
> the kernel sources 2) recognise --with-kernel parameter.
> 
> Index: configure.in
> ===================================================================
> --- configure.in	(revision 6582)
> +++ configure.in	(working copy)
> @@ -18,6 +18,47 @@
> 
> 
>  dnl--------------------------------
> +AC_DEFUN([NF_KERNEL_SOURCE],[
> +
> + if test "$with_kernel" = ""; then
> +   KERNEL="`uname -r`"
> + else
> +   KERNEL="$with_kernel"
> + fi
> +
> + THIS_PREFIX=""
> + for i in "/lib/modules/$KERNEL/build/include" "$KERNEL"
> "$KERNEL/include" "/usr/src/linux-$KERNEL" "/usr/src/kernel-$KERNEL"
> "/usr/src/linux-headers-$KERNEL" "/usr/src/kernel-headers-$KERNEL"
> + do
> +   AC_MSG_CHECKING([Looking for kernel source or headers in $i])
> +   if test -r "$i/linux/config.h"
> +   then
> +     THIS_PREFIX="$i"
> +     AC_MSG_RESULT([found])
> +     break
> +   fi
> +   AC_MSG_RESULT([ ])
> + done
> + if test -r "$THIS_PREFIX/linux/config.h" ; then
> +   AC_SUBST(KERNELDIR,[$THIS_PREFIX])
> +   AC_MSG_RESULT([found])
> + else
> +   AC_MSG_ERROR([not found $THIS_PREFIX])
> + fi
> +
> + # somehow add this as an include path
> +])
> +
> +AC_ARG_WITH(kernel,
> +              AC_HELP_STRING([--with-kernel=DIR],
> +                             [ Show location of kernel source.
> Default is to use uname -r and look in
> /lib/modules/KERNEL/build/include. ]),
> +              NF_KERNEL_SOURCE($with_kernel),NF_KERNEL_SOURCE())
> +
> +if test ! -z "$libdir"; then
> +  MODULE_DIR="\\\"$libdir/\\\""
> +  CFLAGS="$CFLAGS -DCONNTRACK_LIB_DIR=$MODULE_DIR"
> +fi
> +
> +
>  dnl--------------------------------
> 
> 
> Index: src/Makefile.am
> ===================================================================
> --- src/Makefile.am	(revision 6582)
> +++ src/Makefile.am	(working copy)
> @@ -2,7 +2,7 @@
>  # Please read Chapter 6 "Library interface versions" of the libtool
> documentation before making any modification
>  LIBVERSION=1:0:0
> 
> -INCLUDES = $(all_includes) -I$(top_srcdir)/include
> +INCLUDES = $(all_includes) -I$(top_srcdir)/include -I$(KERNELDIR)
>  AM_CFLAGS=-fPIC -Wall
>  LIBS=
> 
> 
