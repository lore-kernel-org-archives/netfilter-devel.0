From: Mike Frysinger <vapier@gentoo.org>
Subject: [patch] iptables and NO_SHARED_LIBS/dlfcn.h
Date: Wed, 19 Dec 2007 07:15:46 -0500
Message-ID: <200712190715.46466.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:43280 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbXLSMPr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Dec 2007 07:15:47 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id E96E4657F5
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Dec 2007 12:15:46 +0000 (UTC)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

if NO_SHARED_LIBS is defined, then iptables shouldnt even include dlfcn.h.
otherwise you hit a build failure when using toolchains that do not provide
dlfcn.h because they do not support shared objects.

Signed-Off-By: Mike Frysinger <vapier@gentoo.org>
---
i'd file a bug on the netfilter bugzilla, but looks like the system is hosed ...

Index: iptables-save.c
===================================================================
--- iptables-save.c	(revision 7145)
+++ iptables-save.c	(working copy)
@@ -11,12 +11,15 @@
 #include <fcntl.h>
 #include <stdlib.h>
 #include <string.h>
-#include <dlfcn.h>
 #include <time.h>
 #include <netdb.h>
 #include "libiptc/libiptc.h"
 #include "iptables.h"
 
+#ifndef NO_SHARED_LIBS
+#include <dlfcn.h>
+#endif
+
 static int binary = 0, counters = 0;
 
 static struct option options[] = {
Index: xtables.c
===================================================================
--- xtables.c	(revision 7145)
+++ xtables.c	(working copy)
@@ -16,7 +16,6 @@
  *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <dlfcn.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <netdb.h>
@@ -31,6 +30,10 @@
 
 #include <xtables.h>
 
+#ifndef NO_SHARED_LIBS
+#include <dlfcn.h>
+#endif
+
 #define NPROTO	255
 
 #ifndef PROC_SYS_MODPROBE
Index: ip6tables-save.c
===================================================================
--- ip6tables-save.c	(revision 7145)
+++ ip6tables-save.c	(working copy)
@@ -11,13 +11,16 @@
 #include <fcntl.h>
 #include <stdlib.h>
 #include <string.h>
-#include <dlfcn.h>
 #include <time.h>
 #include <netdb.h>
 #include <arpa/inet.h>
 #include "libiptc/libip6tc.h"
 #include "ip6tables.h"
 
+#ifndef NO_SHARED_LIBS
+#include <dlfcn.h>
+#endif
+
 static int binary = 0, counters = 0;
 
 static struct option options[] = {
