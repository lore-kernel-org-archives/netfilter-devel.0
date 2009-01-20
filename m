From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] add --with-kernel-includes configure option to libnetfilter_queue
Date: Tue, 20 Jan 2009 17:30:57 +0100
Message-ID: <4975FC41.70906@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from winston.telenet-ops.be ([195.130.137.75]:43421 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbZATQbB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Jan 2009 11:31:01 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by winston.telenet-ops.be (Postfix) with SMTP id 0A66DA005A
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2009 17:30:58 +0100 (CET)
Received: from [127.0.0.1] (d54C6FD43.access.telenet.be [84.198.253.67])
	by winston.telenet-ops.be (Postfix) with ESMTP id D3782A0025
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2009 17:30:57 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This adds the --with-kernel-includes configure option to
libnetfilter_queue and creates a README. This option allows compiling
with kernel headers not located at /usr/include.

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>


--- libnetfilter_queue_snapshot/configure.in.old	2009-01-20 15:30:31.000000000 +0100
+++ libnetfilter_queue_snapshot/configure.in	2009-01-20 15:30:46.000000000 +0100
@@ -19,14 +19,37 @@ esac
 
 dnl Dependencies
 LIBNFNETLINK_REQUIRED=0.0.38
- 
+
 PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
 	AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
- 
-CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS"
+
 LIBNFQUEUE_LIBS="$LIBNFNETLINK_LIBS"
- 
+
 AC_SUBST(LIBNFQUEUE_LIBS)
 
+dnl Allows compiling the library with kernel include headers not located
+dnl at /usr/include
+AC_ARG_WITH([kernel-includes],
+    [AS_HELP_STRING([--with-kernel-includes=PATH],
+    [Path to kernel source include files @<:@default=/usr/include@:>@])],
+    [
+    if test x$withval = xyes -o x$withval = x ; then
+	AC_MSG_ERROR(--with-kernel-includes must be given the path to your kernel source include files.)
+    fi
+    if ! test -d $withval ; then
+	AC_MSG_ERROR(The --with-kernel-includes path $withval is not a directory.)
+    fi
+    if ! test -d $withval/linux ; then
+	AC_MSG_ERROR(The --with-kernel-includes directory $withval must contain the directory 'linux'.)
+    fi
+    if ! test -r $withval/linux ; then
+	AC_MSG_ERROR(You must have read permissions for the kernel source include files.)
+    fi
+    KERNEL_INCLUDES=`(cd $withval; /bin/pwd)`
+    TMP_CFLAGS_OTHER=`$PKG_CONFIG libnfnetlink --cflags-only-other`
+    TMP_CFLAGS_I=`$PKG_CONFIG libnfnetlink --cflags-only-I`
+    CFLAGS="$CFLAGS $TMP_CFLAGS_OTHER -I$KERNEL_INCLUDES $TMP_CFLAGS_I"],
+    CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS")
+
 dnl Output the makefiles
 AC_OUTPUT(Makefile include/Makefile include/libnetfilter_queue/Makefile src/Makefile utils/Makefile libnetfilter_queue.pc doxygen.cfg)
--- libnetfilter_queue_snapshot/README.old	2009-01-20 15:30:40.000000000 +0100
+++ libnetfilter_queue_snapshot/README	2009-01-20 15:31:11.000000000 +0100
@@ -0,0 +1,45 @@
+libnetfilter_queue - userspace library for handling queued network packets
+(C) 2005-2009 Netfilter Core Team <coreteam@netfilter.org>
+===========================================================================
+
+What is netfilter_queue?
+
+netfilter_queue enables the kernel packet filter to queue network packets
+to userspace, using the nfnetlink transport layer. These packets can then be
+inspected and/or altered by a userspace program and reinjected in the kernel
+network stack.
+
+
+What is libnetfilter_queue?
+
+libnetfilter_queue is a userspace library providing an API to packets that
+have been queued by the kernel packet filter. It is part of a system that
+deprecates the old ip_queue / libipq mechanism. libnetfilter_queue has been
+previously known as libnfnetlink_queue.
+
+
+Prerequisites for libnetfilter_queue
+
+libnetfilter_queue requires libnfnetlink and a kernel that includes the
+nfnetlink_queue subsystem (i.e. 2.6.14 or later).
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
+Please report all libnetfilter_queue bugs to https://bugzilla.netfilter.org/,
+using the "libnetfilter_queue" Product.
+
+
+Where do I get support?
+
+The netfilter@vger.kernel.org and netfilter-devel@vger.kernel.org
+mailinglists serve as support forum.
