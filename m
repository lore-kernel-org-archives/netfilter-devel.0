From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: patch-o-matic-ng release candidate in cvs
Date: Mon, 10 May 2004 00:04:50 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405092357270.14931-100000@filer.marasystems.com>
References: <20040509164411.GA20463@pcw.home.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy TARREAU <willy@w.ods.org>
In-Reply-To: <20040509164411.GA20463@pcw.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 9 May 2004, Willy TARREAU wrote:

> While INFOP needs at least 2 arguments :
> 
>    #define INFOP(fmt, args...) printk(KERN_INFO "%s: %s: " fmt, __FILE__, __FUNCTION__, ## args)

Actually I think the bug is that there is no space infront of the comma in
the ## expansion. To limit the conflicts with C99 the GNU CPP varargs
comma magics is only activated if there is a space infront of the comma
like in this example from the GNU CPP manual:

     #define eprintf(format, args...) fprintf (stderr, format , ##args)

> I had to fix it with the following patch. It should not change the
> binary size much since there are very few callers of this macro.

The binary should be unaffected as this is preprocessor juggling only.. 
the resulting C code is identical in both cases.


Revised patch (done inline by modifying your patch, not tested):

--- ./net/ipv4/netfilter/ip_nat_rtsp.c.orig	Sun May  9 17:14:49 2004
+++ ./net/ipv4/netfilter/ip_nat_rtsp.c	Sun May  9 17:15:35 2004
@@ -50,9 +50,9 @@
 #define NF_NEED_MIME_NEXTLINE
 #include <linux/netfilter_mime.h>
 
-#define INFOP(fmt, args...) printk(KERN_INFO "%s: %s: " fmt, __FILE__, __FUNCTION__, ## args)
+#define INFOP(fmt, args...) printk(KERN_INFO "%s: %s: " fmt, __FILE__, __FUNCTION__ , ## args)
 #ifdef IP_NF_RTSP_DEBUG
-#define DEBUGP(fmt, args...) printk(KERN_DEBUG "%s: %s: " fmt, __FILE__, __FUNCTION__, ## args)
+#define DEBUGP(fmt, args...) printk(KERN_DEBUG "%s: %s: " fmt, __FILE__, __FUNCTION__ , ## args)
 #else
 #define DEBUGP(fmt, args...)
 #endif
--- ./net/ipv4/netfilter/ip_conntrack_rtsp.c.orig	Sun May  9 17:04:01 2004
+++ ./net/ipv4/netfilter/ip_conntrack_rtsp.c	Sun May  9 17:14:32 2004
@@ -42,9 +42,9 @@
 
 #define MAX_SIMUL_SETUP 8 /* XXX: use max_outstanding */
 
-#define INFOP(fmt, args...) printk(KERN_INFO "%s: %s: " fmt, __FILE__, __FUNCTION__, ## args)
+#define INFOP(fmt, args...) printk(KERN_INFO "%s: %s: " fmt, __FILE__, __FUNCTION__ , ## args)
 #ifdef IP_NF_RTSP_DEBUG
-#define DEBUGP(fmt, args...) printk(KERN_DEBUG "%s: %s: " fmt, __FILE__, __FUNCTION__, ## args)
+#define DEBUGP(fmt, args...) printk(KERN_DEBUG "%s: %s: " fmt, __FILE__, __FUNCTION__ , ## args)
 #else
 #define DEBUGP(fmt, args...)
 #endif


Regards
Henrik
