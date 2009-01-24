From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] add --with-kernel-includes configure option to libnetfilter_conntrack
Date: Sat, 24 Jan 2009 12:23:04 +0100
Message-ID: <497AFA18.5020005@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nelson.telenet-ops.be ([195.130.133.66]:56817 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbZAXLXO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jan 2009 06:23:14 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by nelson.telenet-ops.be (Postfix) with SMTP id 4B90C50010
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Jan 2009 12:23:11 +0100 (CET)
Received: from [127.0.0.1] (d54C6FD43.access.telenet.be [84.198.253.67])
	by nelson.telenet-ops.be (Postfix) with ESMTP id CB5F450058
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Jan 2009 12:23:10 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

[This is a rediff which includes support for directories with
spaces.]


This adds the --with-kernel-includes configure option to
libnetfilter_conntrack and updates README. This option allows compiling
with kernel headers not located at /usr/include.

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>


--- libnetfilter_conntrack-0.0.99/configure.in.old	2009-01-19 17:48:09.000000000 +0100
+++ libnetfilter_conntrack-0.0.99/configure.in	2009-01-20 19:24:32.000000000 +0100
@@ -72,11 +72,34 @@ if test ! -z "$libdir"; then
 	CFLAGS="$CFLAGS -DLIBNETFILTER_CONNTRACK_DIR=$MODULE_DIR"
 fi
 
-CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS"
 LIBNFCONNTRACK_LIBS="$LIBNFNETLINK_LIBS"
 
 AC_SUBST(LIBNFCONNTRACK_LIBS)
 
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
 AC_OUTPUT(Makefile src/Makefile include/Makefile utils/Makefile qa/Makefile include/libnetfilter_conntrack/Makefile include/internal/Makefile src/conntrack/Makefile src/expect/Makefile src/deprecated/Makefile src/deprecated/l3extensions/Makefile src/deprecated/extensions/Makefile libnetfilter_conntrack.pc)
 
--- libnetfilter_conntrack-0.0.99/README.old	2009-01-19 17:51:11.000000000 +0100
+++ libnetfilter_conntrack-0.0.99/README	2009-01-19 17:58:21.000000000 +0100
@@ -38,6 +38,9 @@ Linux kernel version >= 2.6.18 (http://w
  * ctnetlink (ip_conntrack_netlink)
  * connection tracking event notification API 
 
+You can specify the location of your kernel sources using the
+"--with-kernel-includes" configure option.
+
 = Documentation =
 
 The libnetfilter_conntrack API is well documented, however we don't have any
