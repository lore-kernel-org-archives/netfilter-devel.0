From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Missing limits.h includes
Date: Tue, 19 Aug 2008 08:37:50 -0700
Message-ID: <20080819153750.GB13246@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:54312
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752879AbYHSPhv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:37:51 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Latest git doesn't compile for me on Fedora 9 due to various *MAX constants
being undefined.  Below adds the include in 3 files which need it (although
I can't see why this isn't required in 1.4.1.1).

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ipt-limits

diff -ruN ipt-orig/extensions/libxt_esp.c ipt-new/extensions/libxt_esp.c
--- ipt-orig/extensions/libxt_esp.c	2008-08-18 14:55:57.000000000 -0700
+++ ipt-new/extensions/libxt_esp.c	2008-08-19 08:16:38.000000000 -0700
@@ -5,6 +5,8 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <errno.h>
+#include <limits.h>
+
 #include <xtables.h>
 #include <linux/netfilter/xt_esp.h>
 
diff -ruN ipt-orig/extensions/libxt_owner.c ipt-new/extensions/libxt_owner.c
--- ipt-orig/extensions/libxt_owner.c	2008-08-18 14:55:57.000000000 -0700
+++ ipt-new/extensions/libxt_owner.c	2008-08-19 08:16:58.000000000 -0700
@@ -12,6 +12,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <limits.h>
 
 #include <xtables.h>
 #include <linux/netfilter/xt_owner.h>
diff -ruN ipt-orig/extensions/libxt_time.c ipt-new/extensions/libxt_time.c
--- ipt-orig/extensions/libxt_time.c	2008-08-18 14:55:57.000000000 -0700
+++ ipt-new/extensions/libxt_time.c	2008-08-19 08:17:33.000000000 -0700
@@ -18,6 +18,8 @@
 #include <stdlib.h>
 #include <stddef.h>
 #include <time.h>
+#include <limits.h>
+
 #include <linux/netfilter/xt_time.h>
 #include <xtables.h>
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof(*x))

--YZ5djTAD1cGYuMQK--
