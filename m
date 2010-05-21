From: Patrick McHardy <kaber@trash.net>
Subject: Re: Xtables 1.26 vs. Linux Kernel 2.6.34[.0] - Compile problem
Date: Fri, 21 May 2010 13:50:00 +0200
Message-ID: <4BF67368.7040508@trash.net>
References: <alpine.LSU.2.01.1005211339410.12675@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080109000007000309050408"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, d.stussy@yahoo.com,
	adobriyan@gmail.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38502 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab0EULuD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 May 2010 07:50:03 -0400
In-Reply-To: <alpine.LSU.2.01.1005211339410.12675@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080109000007000309050408
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:
> Forwarding to nf-dev for the records...
> 
> 
> Seems like we need #include <linux/kernel.h> in x_tables.h now.


This should be fixed by commit a79ff731, "netfilter: xtables: make
XT_ALIGN() usable in exported headers by exporting __ALIGN_KERNEL()"


> ---------- Forwarded message ----------
> Date: Fri, 21 May 2010 02:35:12
> From: - <d.stussy@yahoo.com>
> To: jengelh@medozas.de
> Subject: Xtables 1.26 vs. Linux Kernel 2.6.34[.0] - Compile problem.
> 
> (compiling against kernel headers - for modules):
> 
> make[3]: Entering directory `/usr/src/xtables-addons-1.26/extensions'
>   CC     libxt_CHAOS.oo
> libxt_CHAOS.c:99: warning: implicit declaration of function `ALIGN'
> libxt_CHAOS.c:99: error: initializer element is not constant
> libxt_CHAOS.c:99: error: (near initialization for `chaos_tg_reg.size')
> libxt_CHAOS.c:100: error: initializer element is not constant
> libxt_CHAOS.c:100: error: (near initialization for `chaos_tg_reg.userspacesize')
> make[3]: *** [libxt_CHAOS.oo] Error 1
> make[3]: Leaving directory `/usr/src/xtables-addons-1.26/extensions'
> make[2]: *** [user-all-local] Error 2
> make[2]: Leaving directory `/usr/src/xtables-addons-1.26/extensions'
> make[1]: *** [all-recursive] Error 1
> make[1]: Leaving directory `/usr/src/xtables-addons-1.26'
> make: *** [all] Error 2
> 
> 
> The error is caused by this change in the kernel header files:
> 
> --- /usr/include/linux/netfilter/x_tables.h - From Linux Kernel 2.6.33.4
> +++ /tmp/include/linux/netfilter/x_tables.h - From Linux Kernel 2.6.34.0
> @@ -93,8 +93,7 @@
>         __u64 u64;
>  };
>  
> -#define XT_ALIGN(s) (((s) + (__alignof__(struct _xt_align)-1))         \
> -                       & ~(__alignof__(struct _xt_align)-1))
> +#define XT_ALIGN(s) ALIGN((s), __alignof__(struct _xt_align))
>  
>  /* Standard return verdict, or do jump. */
>  #define XT_STANDARD_TARGET ""
> ----------(end of diff )---------------
> 
> Including the above header file did NOT help:
> 
> # grep -r ALIGN /usr/include/linux/
> /usr/include/linux/linkage.h:#define ALIGN __ALIGN
> 
> 
> Using the 2.6.33.4 version of the header file allowed compilation.  Therefore, I have a working set of modules (using 2.6.33.4 headers).
> 
> 


--------------080109000007000309050408
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit a79ff731a1b277d0e92d9453bdf374e04cec717a
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Tue Apr 13 11:21:46 2010 +0200

    netfilter: xtables: make XT_ALIGN() usable in exported headers by exporting __ALIGN_KERNEL()
    
    XT_ALIGN() was rewritten through ALIGN() by commit 42107f5009da223daa800d6da6904d77297ae829
    "netfilter: xtables: symmetric COMPAT_XT_ALIGN definition".
    ALIGN() is not exported in userspace headers, which created compile problem for tc(8)
    and will create problem for iptables(8).
    
    We can't export generic looking name ALIGN() but we can export less generic
    __ALIGN_KERNEL() (suggested by Ben Hutchings).
    Google knows nothing about __ALIGN_KERNEL().
    
    COMPAT_XT_ALIGN() changed for symmetry.
    
    Reported-by: Andreas Henriksson <andreas@fatal.se>
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 7f07074..284ea99 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -4,6 +4,8 @@
 /*
  * 'kernel.h' contains some often-used function prototypes etc
  */
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
 
 #ifdef __KERNEL__
 
@@ -37,8 +39,7 @@ extern const char linux_proc_banner[];
 
 #define STACK_MAGIC	0xdeadbeef
 
-#define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
-#define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
+#define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
 #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
 #define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
 
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 1a65d45..26ced0c 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -1,6 +1,6 @@
 #ifndef _X_TABLES_H
 #define _X_TABLES_H
-
+#include <linux/kernel.h>
 #include <linux/types.h>
 
 #define XT_FUNCTION_MAXNAMELEN 30
@@ -93,7 +93,7 @@ struct _xt_align {
 	__u64 u64;
 };
 
-#define XT_ALIGN(s) ALIGN((s), __alignof__(struct _xt_align))
+#define XT_ALIGN(s) __ALIGN_KERNEL((s), __alignof__(struct _xt_align))
 
 /* Standard return verdict, or do jump. */
 #define XT_STANDARD_TARGET ""
@@ -603,7 +603,7 @@ struct _compat_xt_align {
 	compat_u64 u64;
 };
 
-#define COMPAT_XT_ALIGN(s) ALIGN((s), __alignof__(struct _compat_xt_align))
+#define COMPAT_XT_ALIGN(s) __ALIGN_KERNEL((s), __alignof__(struct _compat_xt_align))
 
 extern void xt_compat_lock(u_int8_t af);
 extern void xt_compat_unlock(u_int8_t af);

--------------080109000007000309050408--
