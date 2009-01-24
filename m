From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] add --with-kernel-includes configure option to libnfnetlink
Date: Sat, 24 Jan 2009 12:25:40 +0100
Message-ID: <497AFAB4.6020709@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nelson.telenet-ops.be ([195.130.133.66]:58495 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZAXLZr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jan 2009 06:25:47 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by nelson.telenet-ops.be (Postfix) with SMTP id 61C7E50022
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Jan 2009 12:25:46 +0100 (CET)
Received: from [127.0.0.1] (d54C6FD43.access.telenet.be [84.198.253.67])
	by nelson.telenet-ops.be (Postfix) with ESMTP id 327FC5000E
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Jan 2009 12:25:46 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

[This is a rediff which includes support for directories with
spaces.]


This adds the --with-kernel-includes configure option to
libnfnetlink and updates README. This option allows compiling
with kernel headers not located at /usr/include.

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>


--- libnfnetlink-0.0.40/configure.in.old	2009-01-19 17:31:08.000000000 +0100
+++ libnfnetlink-0.0.40/configure.in	2009-01-20 19:25:22.000000000 +0100
@@ -17,8 +17,26 @@ case $target in 
 esac
 
 
-dnl--------------------------------
-dnl--------------------------------
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
+    CFLAGS="$CFLAGS -I\"$KERNEL_INCLUDES\""],)
 
 
 dnl Output the makefile
--- libnfnetlink-0.0.40/README.old	2009-01-18 18:10:42.000000000 +0100
+++ libnfnetlink-0.0.40/README	2009-01-20 15:06:43.000000000 +0100
@@ -1,5 +1,5 @@
 libnfnetlink - userspace library for handling of netfilter netlink messages
-(C) 2001-2005 Netfilter Core Team <coreteam@netfilter.org>
+(C) 2001-2009 Netfilter Core Team <coreteam@netfilter.org>
 ===========================================================================
 
 What is nfnetlink?
@@ -13,22 +13,22 @@ What is libnfnetlink?
 
 libnfnetlink is a userspace library that provides some low-level
 nfnetlink handling functions.  It is used as a foundation for other, netfilter
-subsystem specific libraries such as libnfnetlink_conntrack, libnfnetlink_log
-and libnfnetlink_queue.
+subsystem specific libraries such as libnetfilter_conntrack, libnetfilter_log
+and libnetfilter_queue.
 
 
 Prerequirements for libnfnetlink
 
 You will need kernel headers from a kernel that has nfnetlink support.  The
-first official kernel release to include nfnetlink support is 2.6.14.  
-You can specify the location of your kernel sources using the "--with-kernel="
-configure option.
+first official kernel release to include nfnetlink support is 2.6.14.
+You can specify the location of your kernel sources using the
+"--with-kernel-includes" configure option.
 
 
 Where can I find documentation?
 
 At the moment, you will have to RTFS.  Sorry, but we have barely enough
-manpower to keep development ongoing.  If you want to conribute documentation,
+manpower to keep development ongoing.  If you want to contribute documentation,
 please contact us.
 
 
@@ -40,6 +40,5 @@ the "libnfnetlink" Product.
 
 Where do I get support?
 
-The netfilter@lists.netfilter.org and netfilter-devel@lists.netfilter.org
-mailinglists server as support forum.
-
+The netfilter@vger.kernel.org and netfilter-devel@vger.kernel.org
+mailinglists serve as support forum.
