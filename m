From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] Autoconf stuff for iptables
Date: Sun, 09 May 2004 16:17:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <409E3D87.10804@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020207010603070806010308"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020207010603070806010308
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi everyone,

this is a resend, my previous email was a bit big, something like 100k, 
so it seems that mailman wasn't so happy with it.

So this time I just attached the configure.ac file. To get the whole patch:

http://eurodev.net/~pablo/autostuff2.patch

regards,
Pablo

-------- my previous email ----------

Hi,

I made a configure.ac file to make iptables compile using autoconf
stuff, it applies to the current CVS snapshot. I defined three possible
options which can be passed to configure, they are:


   --disable-shared-libs     compile static linked version of iptables
   --disable-ipv6     disable support for ipv6
   --with-kernel-dir=DIR     location of kernel sources

I also added another one called --enable-debug-mode but I'm not sure the
way iptables is compiled in debug mode, so I just commented it, please
have a look at the configure.ac to see what I'm talking about.

I respected as much as possible the current Makefile to generate the
Makefile.in . I also renamed all Makefiles to Makefile.in included in
subdirs because someone could add to them some autoconf stuff later.

The configure script generates a file called config.h which includes a
define which specifies the architecture where iptables is going to be
compiled. Oh, we could avoid the use of this file just passing the
architecture as a C flag, sure.

I'm not an autoconf geek, so if there's something weird, please let me
know. Comments are welcome.

regards,
Pablo


--------------020207010603070806010308
Content-Type: text/plain;
 name="configure.ac"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="configure.ac"

AC_PREREQ(2.57)
AC_INIT(iptables, iptables, [coreteam@netfilter.org])
AC_COPYRIGHT(Copyright 2004 Netfilter Core Team)
AC_REVISION($Revision: 1.0 $)

AC_CONFIG_SRCDIR([iptables-standalone.c])
AC_CONFIG_HEADER([config.h])

AC_CANONICAL_HOST

IPTABLES_VERSION=1.2.10
OLD_IPTABLES_VERSION=1.2.9
AC_SUBST(IPTABLES_VERSION)
AC_SUBST(OLD_IPTABLES_VERSION)

CFLAGS=-O2

# This may be overridden using --prefix=/usr to configure
AC_PREFIX_DEFAULT(/usr/local)

dnl
dnl where is the kernel?
dnl

AC_ARG_WITH(kernel-dir, 
          [  --with-kernel-dir=DIR     location of kernel sources],
          [KERNEL_DIR=${withval}],
	  [KERNEL_DIR=/usr/src/linux])
AC_SUBST(KERNEL_DIR)

dnl
dnl compile static linked version. NO_SHARED_LIBS=1 means no dynamic linked 
dnl compilation
dnl
AC_ARG_ENABLE(shared-libs, 
           [  --disable-shared-libs     compile static linked version of iptables], 
	   NO_SHARED_LIBS=1, NO_SHARED_LIBS=0)

AC_SUBST(NO_SHARED_LIBS)

dnl
dnl disable ipv6 support. DO_IPV6=0 means that it's disabled
dnl
AC_ARG_ENABLE(ipv6,
           [  --disable-ipv6     disable support for ipv6],
           DO_IPV6=0, DO_IPV6=1)
	   
AC_SUBST(DO_IPV6)

# FIXME: Debug. should I remove this?
#
#AC_ARG_ENABLE(debug-mode,
#           [  --enable-debug-mode      enable debug mode],
#	   debug="yes", debug="no")

dnl Checks architecture
dnl Check for CPU / vendor / OS
AC_MSG_CHECKING([host platform characteristics])
case "${host}" in
alpha*-*-linux-gnu*)
	AC_DEFINE(__alpha__, 1, [ ])
	;;
arm*-*-linux-gnu*)
	AC_DEFINE(__arm__, 1, [ ])
	;;
ia64*-*-linux-gnu*)
	AC_DEFINE(__ia64__, 1, [ ])
	;;
i[[3456]]86-*-linux-gnu*)
        AC_DEFINE(__x86__, 1, [ ])
        ;;
m68k-*-*-linux-gnu*)
        AC_DEFINE(__m68k__, 1, [ ])
        ;;
mips-*-*-linux-gnu*)
	AC_DEFINE(__mips__, 1, [ ])
	;;
sparc-*-linux-gnu*)
	AC_DEFINE(__sparc__, 1, [ ])
	;;
hppa64-*-linux-gnu*)
	AC_DEFINE(__hppa64__, 1, [ ])
	;;
mips64-*-*-linux-gnu*)
        AC_DEFINE(__mips64__, 1, [ ])
	;;
sparc64-*-linux-gnu*)
        CFLAGS="$CFLAGS -DIPT_MIN_ALIGN=8 -DKERNEL_64_USERSPACE_32"
        AC_DEFINE(__sparc64__, 1, [ ])
        ;;
parisc64-*-linux-gnu*)
        CFLAGS="$CFLAGS -DIPT_MIN_ALIGN=8 -DKERNEL_64_USERSPACE_32"
        AC_DEFINE(__parisc64__, 1, [ ])
        ;;
powerpc64-*-linux-gnu*)
        AC_DEFINE(__powerpc64__, 1, [ ])
	;;
x86_64-*-linux-gnu*)
	AC_DEFINE(__x86_64__, 1, [ ])
	;;
*)
	AC_MSG_CHECKING([Cannot determine your architecture!!])
esac
AC_MSG_RESULT(ok)

# Checks for programs.
AC_PROG_CC
AC_PROG_LN_S

# Checks for libraries.
# FIXME: Replace `main' with a function in `-ldl':
AC_CHECK_LIB([dl], [main])
# FIXME: Replace `main' with a function in `-lnsl':
AC_CHECK_LIB([nsl], [main])

# Checks for header files.
AC_HEADER_STDC
AC_HEADER_SYS_WAIT
AC_CHECK_HEADERS([arpa/inet.h fcntl.h limits.h netdb.h netinet/in.h stddef.h stdlib.h string.h sys/socket.h sys/time.h syslog.h unistd.h])
# FIXME: I know, I could check for ALL the headers... not just ipt_ah.h :)
AC_CHECK_HEADERS([${KERNEL_DIR}/include/linux/netfilter_ipv4/ipt_ah.h], 
                 [ ],
                 [AC_MSG_ERROR([doh? cannot find valid kernel headers, is your kernel in /usr/src/linux? if not, use --with-kernel-dir=DIR option])])

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_TYPE_UID_T
AC_C_INLINE
AC_TYPE_PID_T
AC_TYPE_SIZE_T
AC_HEADER_TIME

dnl
dnl Disable IPv6 support if we don't find needed headers
dnl
AC_CHECK_HEADER(/usr/include/netinet/ip6.h,
                have_ipv6=yes,
                have_ipv6=no)

if test "x$have_ipv6" = "xno"
then
	DO_IPV6=0
	AC_MSG_WARN([Disabling ipv6 support, /usr/include/netinet/ip6.h not found])
fi


# Checks for library functions.
AC_FUNC_FORK
AC_FUNC_MALLOC
AC_FUNC_MEMCMP
AC_FUNC_REALLOC
AC_FUNC_SELECT_ARGTYPES
AC_FUNC_VPRINTF
AC_CHECK_FUNCS([alarm bzero gethostbyaddr gethostbyname inet_ntoa memmove memset select socket strcasecmp strchr strdup strerror strncasecmp strrchr strtol strtoul strtoull])

# FIXME: debug, should I remove this?
#
#if test "x$debug" = "xyes"
#then
#	CFLAGS="$CFLAGS -g DDEBUG -pg -DIPTC_DEBUG"
#fi


AC_CONFIG_FILES([Makefile
                 extensions/Makefile
                 ippool/Makefile
                 libipq/Makefile
                 libiptc/Makefile])
AC_OUTPUT

--------------020207010603070806010308--
