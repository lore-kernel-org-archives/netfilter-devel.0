From: Willy TARREAU <willy@w.ods.org>
Subject: Re: patch-o-matic-ng release candidate in cvs
Date: Sun, 9 May 2004 18:44:11 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040509164411.GA20463@pcw.home.local>
References: <Pine.LNX.4.33.0405071658020.4133-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0405071658020.4133-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jozsef,

On Fri, May 07, 2004 at 05:03:35PM +0200, Jozsef Kadlecsik wrote:
> In the last few days a couple of changes happened in pom-ng:
> 
> - a bug in Netfilter_POM.pm was fixed (thanks to Krisztian for the
>   bugreport)
> - *all* linux-2.6 trees was fixed by a script and manually checked
>   wether the tree corresponds to the pom-ng
> 
> Please try it out and report me any pending issue.

RTSP helper does not compile anymore on 2.4 with gcc-2.95.3 in latest
pom-ng. The problem is that at 3 places, you find lines such as :

   INFOP("something");

While INFOP needs at least 2 arguments :

   #define INFOP(fmt, args...) printk(KERN_INFO "%s: %s: " fmt, __FILE__, __FUNCTION__, ## args)

I had to fix it with the following patch. It should not change the
binary size much since there are very few callers of this macro.

Regards,
Willy


--- ./net/ipv4/netfilter/ip_nat_rtsp.c.orig	Sun May  9 17:14:49 2004
+++ ./net/ipv4/netfilter/ip_nat_rtsp.c	Sun May  9 17:15:35 2004
@@ -50,11 +50,11 @@
 #define NF_NEED_MIME_NEXTLINE
 #include <linux/netfilter_mime.h>
 
-#define INFOP(fmt, args...) printk(KERN_INFO "%s: %s: " fmt, __FILE__, __FUNCTION__, ## args)
+#define INFOP(args...) printk(KERN_INFO __FILE__ ": " __FUNCTION__ ": " ## args)
 #ifdef IP_NF_RTSP_DEBUG
-#define DEBUGP(fmt, args...) printk(KERN_DEBUG "%s: %s: " fmt, __FILE__, __FUNCTION__, ## args)
+#define DEBUGP(args...) printk(KERN_DEBUG __FILE__ ": " __FUNCTION__ ": " ## args)
 #else
-#define DEBUGP(fmt, args...)
+#define DEBUGP(args...)
 #endif
 
 #define MAX_PORTS       8
--- ./net/ipv4/netfilter/ip_conntrack_rtsp.c.orig	Sun May  9 17:04:01 2004
+++ ./net/ipv4/netfilter/ip_conntrack_rtsp.c	Sun May  9 17:14:32 2004
@@ -42,11 +42,11 @@
 
 #define MAX_SIMUL_SETUP 8 /* XXX: use max_outstanding */
 
-#define INFOP(fmt, args...) printk(KERN_INFO "%s: %s: " fmt, __FILE__, __FUNCTION__, ## args)
+#define INFOP(args...) printk(KERN_INFO __FILE__ ": " __FUNCTION__ ": " ## args)
 #ifdef IP_NF_RTSP_DEBUG
-#define DEBUGP(fmt, args...) printk(KERN_DEBUG "%s: %s: " fmt, __FILE__, __FUNCTION__, ## args)
+#define DEBUGP(args...) printk(KERN_DEBUG __FILE__ ": " __FUNCTION__ ": " ## args)
 #else
-#define DEBUGP(fmt, args...)
+#define DEBUGP(args...)
 #endif
 
 #define MAX_PORTS 8
