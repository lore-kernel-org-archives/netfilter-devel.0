From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [POSSIBLE PATCH] DECLARE_MUTEX while not in __KERNEL__ (Was:
 Re: [Fwd: RE: Second Request for help!!])
Date: Tue, 08 Feb 2005 01:17:08 +0100
Message-ID: <42080504.2080606@eurodev.net>
References: <57143.142.169.215.10.1107791547.squirrel@142.169.215.10>
	<4207FF25.1060404@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040705010601060801020504"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	jamal <hadi@cyberus.ca>, Patrick McHardy <kaber@trash.net>,
	John Hill <jhill@noach.com>
To: sjean@cookinglinux.org
In-Reply-To: <4207FF25.1060404@cookinglinux.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040705010601060801020504
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Samuel Jean wrote:

> I don't know if this patch breaks something, but at least am sure of 
> something:
>
> Into ip_tables.h, DECLARE_MUTEX is used outside of __KERNEL__ 
> compilation.
> However, DECLARE_MUTEX exists only when #ifdef __KERNEL__
> according to asm/.../semaphore.h.
>
> I couldn't track when and why this semaphore had been introduced, but 
> linux-2.4.26
> for sure doesn't use it.


======== include/linux/netfilter_ipv4/ip_tables.h 1.1..1.5 ========
D 1.5 04/06/06 20:13:18-07:00 hadi@zynx.com 6 5 8/0/447
P include/linux/netfilter_ipv4/ip_tables.h
C [NETFILTER]: Small interface cleanup for {ipt,ip6t,arpt}_find_target.

It seems that Jamal introduced this as a clean up some time ago. Maybe 
because of an leftover intention of pushing forward ipt action in 2.4 ?

Anyway, I didn't find any client of ipt_mutex. I think it's better if we 
move it to its original place, ip_tables.c.

--
Pablo

--------------040705010601060801020504
Content-Type: text/x-patch;
 name="ip_tables-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_tables-fix.patch"

===== net/ipv4/netfilter/ip_tables.c 1.16 vs ? (writable without lock!)  =====
--- 1.16/net/ipv4/netfilter/ip_tables.c	2004-12-21 17:48:14 +01:00
+++ ?/net/ipv4/netfilter/ip_tables.c	2005-02-08 01:12:17 +01:00
@@ -53,6 +53,8 @@
 #endif
 #define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
 
+static DECLARE_MUTEX(ipt_mutex);
+
 /* Must have mutex */
 #define ASSERT_READ_LOCK(x) IP_NF_ASSERT(down_trylock(&ipt_mutex) != 0)
 #define ASSERT_WRITE_LOCK(x) IP_NF_ASSERT(down_trylock(&ipt_mutex) != 0)
===== include/linux/netfilter_ipv4/ip_tables.h 1.5 vs ? (writable without lock!)  =====
--- 1.5/include/linux/netfilter_ipv4/ip_tables.h	2004-06-07 05:13:18 +02:00
+++ ?/include/linux/netfilter_ipv4/ip_tables.h	2005-02-07 18:55:54 +01:00
@@ -336,7 +336,6 @@
 /*
  *	Main firewall chains definitions and global var's definitions.
  */
-static DECLARE_MUTEX(ipt_mutex);
 #ifdef __KERNEL__
 
 #include <linux/init.h>

--------------040705010601060801020504--
