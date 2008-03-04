From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 13/24] Add all necessary header files - compilation fix for
 various cases
Date: Tue, 4 Mar 2008 17:02:52 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041702270.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60816 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbYCDQCy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:02:54 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 08d78242d410bf83d18618b589f78880bb3aa83d
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Feb 11 01:23:01 2008 +0100

    Add all necessary header files - compilation fix for various cases
    
    Allow iptables to compile without a kernel source tree. This
    implies fixing build for older kernels, such as 2.6.17 which
    lack xt_SECMARK.h.
---
 configure.ac                              |   10 +-
 include/linux/compiler.h                  |  179 +++++++++++++++++++++
 include/linux/netfilter.h                 |    2 +
 include/linux/netfilter/xt_SECMARK.h      |   26 +++
 include/linux/netfilter_ipv4/ipt_DSCP.h   |   18 ++
 include/linux/netfilter_ipv4/ipt_LOG.h    |   18 ++
 include/linux/netfilter_ipv4/ipt_REJECT.h |   20 +++
 include/linux/netfilter_ipv4/ipt_TOS.h    |   12 ++
 include/linux/netfilter_ipv4/ipt_dscp.h   |   21 +++
 include/linux/netfilter_ipv4/ipt_owner.h  |   20 +++
 include/linux/netfilter_ipv4/ipt_tos.h    |   13 ++
 include/linux/netfilter_ipv6/ip6t_LOG.h   |   18 ++
 12 files changed, 354 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/compiler.h
 create mode 100644 include/linux/netfilter/xt_SECMARK.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_DSCP.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_LOG.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_REJECT.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_TOS.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_dscp.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_owner.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_tos.h
 create mode 100644 include/linux/netfilter_ipv6/ip6t_LOG.h

diff --git a/configure.ac b/configure.ac
index 79775ad..4c18cb0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -8,8 +8,6 @@ AM_PROG_CC_C_O
 AC_DISABLE_STATIC
 AC_PROG_LIBTOOL
 
-kbuilddir="/lib/modules/$(uname -r)/build";
-ksourcedir="/lib/modules/$(uname -r)/source";
 AC_ARG_WITH([kernel],
 	AS_HELP_STRING([--with-kernel=PATH],
 	[Path to kernel source/build directory]),
@@ -41,7 +39,13 @@ regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
 	-Winline -pipe -DIPTABLES_VERSION=\\\"$PACKAGE_VERSION\\\" \
 	-DXTABLES_LIBDIR=\\\"\${xtlibdir}\\\"";
-kinclude_CFLAGS="-I\"$kbuilddir/include\" -I\"$ksourcedir/include\"";
+kinclude_CFLAGS="";
+if [[ -n "$kbuilddir" ]]; then
+	kinclude_CFLAGS="$kinclude_CFLAGS -I $kbuilddir/include";
+fi;
+if [[ -n "$ksourcedir" ]]; then
+	kinclude_CFLAGS="$kinclude_CFLAGS -I $ksourcedir/include";
+fi;
 
 AC_SUBST([regular_CFLAGS kinclude_CFLAGS])
 AC_SUBST([kbuilddir])
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
new file mode 100644
index 0000000..d0e17e1
--- /dev/null
+++ b/include/linux/compiler.h
@@ -0,0 +1,179 @@
+#ifndef __LINUX_COMPILER_H
+#define __LINUX_COMPILER_H
+
+#ifndef __ASSEMBLY__
+
+#ifdef __CHECKER__
+# define __user		__attribute__((noderef, address_space(1)))
+# define __kernel	/* default address space */
+# define __safe		__attribute__((safe))
+# define __force	__attribute__((force))
+# define __nocast	__attribute__((nocast))
+# define __iomem	__attribute__((noderef, address_space(2)))
+# define __acquires(x)	__attribute__((context(x,0,1)))
+# define __releases(x)	__attribute__((context(x,1,0)))
+# define __acquire(x)	__context__(x,1)
+# define __release(x)	__context__(x,-1)
+# define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
+extern void __chk_user_ptr(const volatile void __user *);
+extern void __chk_io_ptr(const volatile void __iomem *);
+#else
+# define __user
+# define __kernel
+# define __safe
+# define __force
+# define __nocast
+# define __iomem
+# define __chk_user_ptr(x) (void)0
+# define __chk_io_ptr(x) (void)0
+# define __builtin_warning(x, y...) (1)
+# define __acquires(x)
+# define __releases(x)
+# define __acquire(x) (void)0
+# define __release(x) (void)0
+# define __cond_lock(x,c) (c)
+#endif
+
+#ifdef __KERNEL__
+
+#if __GNUC__ >= 4
+# include <linux/compiler-gcc4.h>
+#elif __GNUC__ == 3 && __GNUC_MINOR__ >= 2
+# include <linux/compiler-gcc3.h>
+#else
+# error Sorry, your compiler is too old/not recognized.
+#endif
+
+/* Intel compiler defines __GNUC__. So we will overwrite implementations
+ * coming from above header files here
+ */
+#ifdef __INTEL_COMPILER
+# include <linux/compiler-intel.h>
+#endif
+
+/*
+ * Generic compiler-dependent macros required for kernel
+ * build go below this comment. Actual compiler/compiler version
+ * specific implementations come from the above header files
+ */
+
+#define likely(x)	__builtin_expect(!!(x), 1)
+#define unlikely(x)	__builtin_expect(!!(x), 0)
+
+/* Optimization barrier */
+#ifndef barrier
+# define barrier() __memory_barrier()
+#endif
+
+#ifndef RELOC_HIDE
+# define RELOC_HIDE(ptr, off)					\
+  ({ unsigned long __ptr;					\
+     __ptr = (unsigned long) (ptr);				\
+    (typeof(ptr)) (__ptr + (off)); })
+#endif
+
+#endif /* __KERNEL__ */
+
+#endif /* __ASSEMBLY__ */
+
+#ifdef __KERNEL__
+/*
+ * Allow us to mark functions as 'deprecated' and have gcc emit a nice
+ * warning for each use, in hopes of speeding the functions removal.
+ * Usage is:
+ * 		int __deprecated foo(void)
+ */
+#ifndef __deprecated
+# define __deprecated		/* unimplemented */
+#endif
+
+#ifdef MODULE
+#define __deprecated_for_modules __deprecated
+#else
+#define __deprecated_for_modules
+#endif
+
+#ifndef __must_check
+#define __must_check
+#endif
+
+#ifndef CONFIG_ENABLE_MUST_CHECK
+#undef __must_check
+#define __must_check
+#endif
+#ifndef CONFIG_ENABLE_WARN_DEPRECATED
+#undef __deprecated
+#undef __deprecated_for_modules
+#define __deprecated
+#define __deprecated_for_modules
+#endif
+
+/*
+ * Allow us to avoid 'defined but not used' warnings on functions and data,
+ * as well as force them to be emitted to the assembly file.
+ *
+ * As of gcc 3.4, static functions that are not marked with attribute((used))
+ * may be elided from the assembly file.  As of gcc 3.4, static data not so
+ * marked will not be elided, but this may change in a future gcc version.
+ *
+ * NOTE: Because distributions shipped with a backported unit-at-a-time
+ * compiler in gcc 3.3, we must define __used to be __attribute__((used))
+ * for gcc >=3.3 instead of 3.4.
+ *
+ * In prior versions of gcc, such functions and data would be emitted, but
+ * would be warned about except with attribute((unused)).
+ *
+ * Mark functions that are referenced only in inline assembly as __used so
+ * the code is emitted even though it appears to be unreferenced.
+ */
+#ifndef __used
+# define __used			/* unimplemented */
+#endif
+
+#ifndef __maybe_unused
+# define __maybe_unused		/* unimplemented */
+#endif
+
+#ifndef noinline
+#define noinline
+#endif
+
+#ifndef __always_inline
+#define __always_inline inline
+#endif
+
+#endif /* __KERNEL__ */
+
+/*
+ * From the GCC manual:
+ *
+ * Many functions do not examine any values except their arguments,
+ * and have no effects except the return value.  Basically this is
+ * just slightly more strict class than the `pure' attribute above,
+ * since function is not allowed to read global memory.
+ *
+ * Note that a function that has pointer arguments and examines the
+ * data pointed to must _not_ be declared `const'.  Likewise, a
+ * function that calls a non-`const' function usually must not be
+ * `const'.  It does not make sense for a `const' function to return
+ * `void'.
+ */
+#ifndef __attribute_const__
+# define __attribute_const__	/* unimplemented */
+#endif
+
+/*
+ * Tell gcc if a function is cold. The compiler will assume any path
+ * directly leading to the call is unlikely.
+ */
+
+#ifndef __cold
+#define __cold
+#endif
+
+/* Simple shorthand for a section definition */
+#ifndef __section
+# define __section(S) __attribute__ ((__section__(#S)))
+#endif
+
+#endif /* __LINUX_COMPILER_H */
diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 3c5b889..0d1ba11 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_NETFILTER_H
 #define __LINUX_NETFILTER_H
 
+#include <linux/compiler.h>
+
 /* Responses from hook functions. */
 #define NF_DROP 0
 #define NF_ACCEPT 1
diff --git a/include/linux/netfilter/xt_SECMARK.h b/include/linux/netfilter/xt_SECMARK.h
new file mode 100644
index 0000000..c53fbff
--- /dev/null
+++ b/include/linux/netfilter/xt_SECMARK.h
@@ -0,0 +1,26 @@
+#ifndef _XT_SECMARK_H_target
+#define _XT_SECMARK_H_target
+
+/*
+ * This is intended for use by various security subsystems (but not
+ * at the same time).
+ *
+ * 'mode' refers to the specific security subsystem which the
+ * packets are being marked for.
+ */
+#define SECMARK_MODE_SEL	0x01		/* SELinux */
+#define SECMARK_SELCTX_MAX	256
+
+struct xt_secmark_target_selinux_info {
+	u_int32_t selsid;
+	char selctx[SECMARK_SELCTX_MAX];
+};
+
+struct xt_secmark_target_info {
+	u_int8_t mode;
+	union {
+		struct xt_secmark_target_selinux_info sel;
+	} u;
+};
+
+#endif /*_XT_SECMARK_H_target */
diff --git a/include/linux/netfilter_ipv4/ipt_DSCP.h b/include/linux/netfilter_ipv4/ipt_DSCP.h
new file mode 100644
index 0000000..3491e52
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_DSCP.h
@@ -0,0 +1,18 @@
+/* iptables module for setting the IPv4 DSCP field
+ *
+ * (C) 2002 Harald Welte <laforge@gnumonks.org>
+ * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
+ * This software is distributed under GNU GPL v2, 1991
+ * 
+ * See RFC2474 for a description of the DSCP field within the IP Header.
+ *
+ * ipt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
+*/
+#ifndef _IPT_DSCP_TARGET_H
+#define _IPT_DSCP_TARGET_H
+#include <linux/netfilter_ipv4/ipt_dscp.h>
+#include <linux/netfilter/xt_DSCP.h>
+
+#define ipt_DSCP_info xt_DSCP_info
+
+#endif /* _IPT_DSCP_TARGET_H */
diff --git a/include/linux/netfilter_ipv4/ipt_LOG.h b/include/linux/netfilter_ipv4/ipt_LOG.h
new file mode 100644
index 0000000..90fa652
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_LOG.h
@@ -0,0 +1,18 @@
+#ifndef _IPT_LOG_H
+#define _IPT_LOG_H
+
+/* make sure not to change this without changing netfilter.h:NF_LOG_* (!) */
+#define IPT_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
+#define IPT_LOG_TCPOPT		0x02	/* Log TCP options */
+#define IPT_LOG_IPOPT		0x04	/* Log IP options */
+#define IPT_LOG_UID		0x08	/* Log UID owning local socket */
+#define IPT_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
+#define IPT_LOG_MASK		0x1f
+
+struct ipt_log_info {
+	unsigned char level;
+	unsigned char logflags;
+	char prefix[30];
+};
+
+#endif /*_IPT_LOG_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_REJECT.h b/include/linux/netfilter_ipv4/ipt_REJECT.h
new file mode 100644
index 0000000..4293a1a
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_REJECT.h
@@ -0,0 +1,20 @@
+#ifndef _IPT_REJECT_H
+#define _IPT_REJECT_H
+
+enum ipt_reject_with {
+	IPT_ICMP_NET_UNREACHABLE,
+	IPT_ICMP_HOST_UNREACHABLE,
+	IPT_ICMP_PROT_UNREACHABLE,
+	IPT_ICMP_PORT_UNREACHABLE,
+	IPT_ICMP_ECHOREPLY,
+	IPT_ICMP_NET_PROHIBITED,
+	IPT_ICMP_HOST_PROHIBITED,
+	IPT_TCP_RESET,
+	IPT_ICMP_ADMIN_PROHIBITED
+};
+
+struct ipt_reject_info {
+	enum ipt_reject_with with;      /* reject type */
+};
+
+#endif /*_IPT_REJECT_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_TOS.h b/include/linux/netfilter_ipv4/ipt_TOS.h
new file mode 100644
index 0000000..6bf9e1f
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_TOS.h
@@ -0,0 +1,12 @@
+#ifndef _IPT_TOS_H_target
+#define _IPT_TOS_H_target
+
+#ifndef IPTOS_NORMALSVC
+#define IPTOS_NORMALSVC 0
+#endif
+
+struct ipt_tos_target_info {
+	u_int8_t tos;
+};
+
+#endif /*_IPT_TOS_H_target*/
diff --git a/include/linux/netfilter_ipv4/ipt_dscp.h b/include/linux/netfilter_ipv4/ipt_dscp.h
new file mode 100644
index 0000000..4b82ca9
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_dscp.h
@@ -0,0 +1,21 @@
+/* iptables module for matching the IPv4 DSCP field
+ *
+ * (C) 2002 Harald Welte <laforge@gnumonks.org>
+ * This software is distributed under GNU GPL v2, 1991
+ * 
+ * See RFC2474 for a description of the DSCP field within the IP Header.
+ *
+ * ipt_dscp.h,v 1.3 2002/08/05 19:00:21 laforge Exp
+*/
+#ifndef _IPT_DSCP_H
+#define _IPT_DSCP_H
+
+#include <linux/netfilter/xt_dscp.h>
+
+#define IPT_DSCP_MASK	XT_DSCP_MASK
+#define IPT_DSCP_SHIFT	XT_DSCP_SHIFT
+#define IPT_DSCP_MAX	XT_DSCP_MAX
+
+#define ipt_dscp_info	xt_dscp_info
+
+#endif /* _IPT_DSCP_H */
diff --git a/include/linux/netfilter_ipv4/ipt_owner.h b/include/linux/netfilter_ipv4/ipt_owner.h
new file mode 100644
index 0000000..92f4bda
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_owner.h
@@ -0,0 +1,20 @@
+#ifndef _IPT_OWNER_H
+#define _IPT_OWNER_H
+
+/* match and invert flags */
+#define IPT_OWNER_UID	0x01
+#define IPT_OWNER_GID	0x02
+#define IPT_OWNER_PID	0x04
+#define IPT_OWNER_SID	0x08
+#define IPT_OWNER_COMM	0x10
+
+struct ipt_owner_info {
+    uid_t uid;
+    gid_t gid;
+    pid_t pid;
+    pid_t sid;
+    char comm[16];
+    u_int8_t match, invert;	/* flags */
+};
+
+#endif /*_IPT_OWNER_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_tos.h b/include/linux/netfilter_ipv4/ipt_tos.h
new file mode 100644
index 0000000..a21f5df
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_tos.h
@@ -0,0 +1,13 @@
+#ifndef _IPT_TOS_H
+#define _IPT_TOS_H
+
+struct ipt_tos_info {
+    u_int8_t tos;
+    u_int8_t invert;
+};
+
+#ifndef IPTOS_NORMALSVC
+#define IPTOS_NORMALSVC 0
+#endif
+
+#endif /*_IPT_TOS_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_LOG.h b/include/linux/netfilter_ipv6/ip6t_LOG.h
new file mode 100644
index 0000000..0d0119b
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6t_LOG.h
@@ -0,0 +1,18 @@
+#ifndef _IP6T_LOG_H
+#define _IP6T_LOG_H
+
+/* make sure not to change this without changing netfilter.h:NF_LOG_* (!) */
+#define IP6T_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
+#define IP6T_LOG_TCPOPT		0x02	/* Log TCP options */
+#define IP6T_LOG_IPOPT		0x04	/* Log IP options */
+#define IP6T_LOG_UID		0x08	/* Log UID owning local socket */
+#define IP6T_LOG_NFLOG		0x10	/* Unsupported, don't use */
+#define IP6T_LOG_MASK		0x1f
+
+struct ip6t_log_info {
+	unsigned char level;
+	unsigned char logflags;
+	char prefix[30];
+};
+
+#endif /*_IPT_LOG_H*/
