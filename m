From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] add --with-kernel-includes configure option to libnetfilter_log
Date: Sat, 24 Jan 2009 12:20:45 +0100
Message-ID: <497AF98D.4040905@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from edna.telenet-ops.be ([195.130.132.58]:52759 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZAXLUx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jan 2009 06:20:53 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by edna.telenet-ops.be (Postfix) with SMTP id B160BE4041
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Jan 2009 12:20:51 +0100 (CET)
Received: from [127.0.0.1] (d54C6FD43.access.telenet.be [84.198.253.67])
	by edna.telenet-ops.be (Postfix) with ESMTP id 81153E403B
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Jan 2009 12:20:51 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

[This is a rediff which includes support for directories with
spaces.]


This adds the --with-kernel-includes configure option to
libnetfilter_log and adds a README. This option allows compiling
with kernel headers not located at /usr/include.

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>



--- libnetfilter_log-0.0.15/configure.in.old	2009-01-19 17:31:47.000000000 +0100
+++ libnetfilter_log-0.0.15/configure.in	2009-01-20 19:23:35.000000000 +0100
@@ -20,15 +20,38 @@ esac
 
 dnl Dependencies
 LIBNFNETLINK_REQUIRED=0.0.39
- 
+
 PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
 	AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
 
-CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS"
 LIBNFLOG_LIBS="$LIBNFNETLINK_LIBS"
- 
+
 AC_SUBST(LIBNFLOG_LIBS)
 
+dnl Allows compiling the library with kernel include headers not located
+dnl at /usr/include
+AC_ARG_WITH([kernel-includes],
+    [AS_HELP_STRING([--with-kernel-includes=PATH],
+    [Path to kernel source include files @<:@default=/usr/include@:>@])],
+    [
+    if test "x$withval" = xyes -o "x$withval" = x ; then
+	AC_MSG_ERROR(--with-kernel-includes must be given the path to your kernel source include files.)
+    fi
+    if ! test -d "$withval" ; then
+	AC_MSG_ERROR(The --with-kernel-includes path $withval is not a directory.)
+    fi
+    if ! test -d "$withval/linux" ; then
+	AC_MSG_ERROR(The --with-kernel-includes directory $withval must contain the directory 'linux'.)
+    fi
+    if ! test -r "$withval/linux" ; then
+	AC_MSG_ERROR(You must have read permissions for the kernel source include files.)
+    fi
+    KERNEL_INCLUDES=`(cd "$withval"; /bin/pwd)`
+    TMP_CFLAGS_OTHER=`$PKG_CONFIG libnfnetlink --cflags-only-other`
+    TMP_CFLAGS_I=`$PKG_CONFIG libnfnetlink --cflags-only-I`
+    CFLAGS="$CFLAGS $TMP_CFLAGS_OTHER -I\"$KERNEL_INCLUDES\" $TMP_CFLAGS_I"],
+    CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS")
+
 dnl Output the makefile
 AC_OUTPUT(Makefile src/Makefile include/Makefile include/libnetfilter_log/Makefile utils/Makefile libnetfilter_log.pc)
 
--- libnetfilter_log-0.0.15/README.old	2009-01-19 17:58:57.000000000 +0100
+++ libnetfilter_log-0.0.15/README	2009-01-20 14:59:14.000000000 +0100
@@ -0,0 +1,44 @@
+libnetfilter_log - userspace library for logging network packets
+(C) 2005-2009 Netfilter Core Team <coreteam@netfilter.org>
+===========================================================================
+
+What is netfilter_log?
+
+netfilter_log enables the kernel packet filter to queue copies of network
+packets to userspace for inspection, using the nfnetlink transport layer.
+
+
+What is libnetfilter_log?
+
+libnetfilter_log is a userspace library providing an interface to packets
+that have been logged by the kernel packet filter. It is part of a system
+that deprecates the old syslog/dmesg based packet logging. This library has
+been previously known as libnfnetlink_log.
+libnetfilter_log is used by ulogd2.
+
+
+Prerequisites for libnetfilter_log
+
+libnetfilter_log requires libnfnetlink and a kernel that includes the
+nfnetlink_log subsystem (i.e. 2.6.14 or later).
+You can specify the location of your kernel sources using the
+"--with-kernel-includes" configure option.
+
+
+Where can I find documentation?
+
+At the moment, you will have to RTFS.  Sorry, but we have barely enough
+manpower to keep development ongoing.  If you want to contribute documentation,
+please contact us.
+
+
+It has bugs.  Where do I report them?
+
+Please report all libnetfilter_log bugs to https://bugzilla.netfilter.org/,
+using the "libnetfilter_log" Product.
+
+
+Where do I get support?
+
+The netfilter@vger.kernel.org and netfilter-devel@vger.kernel.org
+mailinglists serve as support forum.
