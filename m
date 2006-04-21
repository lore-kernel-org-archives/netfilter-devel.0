From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Fix --with-kernel for libnfnetlink
Date: Fri, 21 Apr 2006 13:09:54 +0200
Message-ID: <20060421110954.GA4403@localhost.localdomain>
References: <859616420604200825o71f81878lbbb45251f1e0330d@mail.gmail.com>
	<4447E23E.4090204@trash.net>
	<859616420604210021y53dda87ai64678342068ed43f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	pablo@netfilter.org, Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Vogt <mail@davidvogt.de>
Content-Disposition: inline
In-Reply-To: <859616420604210021y53dda87ai64678342068ed43f@mail.gmail.com>
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

On Fri, Apr 21, 2006 at 09:21:58AM +0200, David Vogt wrote:
> 2006/4/20, Patrick McHardy <kaber@trash.net>:
> > David Vogt wrote:
> > > Amin Azez has helped me with some trouble concerning the compilation
> > > of libnfnetlink.
> > > The --with-kernel parameter for the configure script did not work as
> > > intended, so Amin has proposed the following changes that 1) look for
> > > the kernel sources 2) recognise --with-kernel parameter.
> >
> > Please change this to use --kernel as literal path as suggested
> > by Sven Koch.
> 
> Like this?
> 
> Index: configure.in
> ===================================================================
> --- configure.in	(revision 6583)
> +++ configure.in	(working copy)
> @@ -18,6 +18,35 @@
> 
> 
>  dnl--------------------------------
> +AC_DEFUN([NF_KERNEL_SOURCE],[
> +
> + if test "$with_kernel" = ""; then
> +   KERNEL="/lib/modules/`uname -r`/build"
> + else
> +   KERNEL="$with_kernel"
> + fi
> +
> + AC_MSG_CHECKING([for kernel headers in $KERNEL/include])
> + if test -r "$KERNEL/include/linux/config.h" ; then
> +   AC_SUBST(KERNELDIR,[$KERNEL])
> +   AC_MSG_RESULT([found])
> + else
> +   AC_MSG_ERROR([not found])
> + fi
> +
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

Why do you need this parameter? the netfilter libraries don't require
kernel headers anymore since they are already bundled in the package
provided. For example, see include/libnfnetlink/linux_nfnetlink.h. We
have had several problems with iptables and the kernel headers in the
past: compilation warnings, breakages... That is the reason why we
decided to do so.

On the other hand, autogen.sh automates the copy of these headers,
so you could choose them via KERNEL_DIR but you need some important
reason to do that.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
