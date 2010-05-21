From: Jan Engelhardt <jengelh@medozas.de>
Subject: Xtables 1.26 vs. Linux Kernel 2.6.34[.0] - Compile problem
Date: Fri, 21 May 2010 13:41:08 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005211339410.12675@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: d.stussy@yahoo.com, Patrick McHardy <kaber@trash.net>,
	adobriyan@gmail.com
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57405 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab0EULlK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 May 2010 07:41:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Forwarding to nf-dev for the records...


Seems like we need #include <linux/kernel.h> in x_tables.h now.


---------- Forwarded message ----------
Date: Fri, 21 May 2010 02:35:12
From: - <d.stussy@yahoo.com>
To: jengelh@medozas.de
Subject: Xtables 1.26 vs. Linux Kernel 2.6.34[.0] - Compile problem.

(compiling against kernel headers - for modules):

make[3]: Entering directory `/usr/src/xtables-addons-1.26/extensions'
  CC     libxt_CHAOS.oo
libxt_CHAOS.c:99: warning: implicit declaration of function `ALIGN'
libxt_CHAOS.c:99: error: initializer element is not constant
libxt_CHAOS.c:99: error: (near initialization for `chaos_tg_reg.size')
libxt_CHAOS.c:100: error: initializer element is not constant
libxt_CHAOS.c:100: error: (near initialization for `chaos_tg_reg.userspacesize')
make[3]: *** [libxt_CHAOS.oo] Error 1
make[3]: Leaving directory `/usr/src/xtables-addons-1.26/extensions'
make[2]: *** [user-all-local] Error 2
make[2]: Leaving directory `/usr/src/xtables-addons-1.26/extensions'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/usr/src/xtables-addons-1.26'
make: *** [all] Error 2


The error is caused by this change in the kernel header files:

--- /usr/include/linux/netfilter/x_tables.h - From Linux Kernel 2.6.33.4
+++ /tmp/include/linux/netfilter/x_tables.h - From Linux Kernel 2.6.34.0
@@ -93,8 +93,7 @@
        __u64 u64;
 };
 
-#define XT_ALIGN(s) (((s) + (__alignof__(struct _xt_align)-1))         \
-                       & ~(__alignof__(struct _xt_align)-1))
+#define XT_ALIGN(s) ALIGN((s), __alignof__(struct _xt_align))
 
 /* Standard return verdict, or do jump. */
 #define XT_STANDARD_TARGET ""
----------(end of diff )---------------

Including the above header file did NOT help:

# grep -r ALIGN /usr/include/linux/
/usr/include/linux/linkage.h:#define ALIGN __ALIGN


Using the 2.6.33.4 version of the header file allowed compilation.  Therefore, I have a working set of modules (using 2.6.33.4 headers).


