From: Patrick McHardy <kaber@trash.net>
Subject: Re: include/linux/netfilter.h after make headers_install is incomplete
Date: Wed, 21 May 2008 12:58:44 +0200
Message-ID: <48340064.4090805@trash.net>
References: <a27c0c970805161521k332fba8cg808d52396b5cdce5@mail.gmail.com>	<a27c0c970805201139i38e12d15ue807fc0239b1c10e@mail.gmail.com>	<a27c0c970805201144j12189201g9567460d4d3d8361@mail.gmail.com> <20080520.142121.15017166.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000401050007010703090101"
Cc: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org
To: greg@nest.cx
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36959 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbYEUK6q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 06:58:46 -0400
In-Reply-To: <20080520.142121.15017166.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000401050007010703090101
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

David Miller wrote:
> From: "Greg Steuck" <greg@nest.cx>
> Date: Tue, 20 May 2008 11:44:56 -0700
>> I ran make headers_install in 2.6.25 tree and the installed netfilter.h is
>> not complete. Namely, it declares
>> union nf_inet_addr {
>>       __u32           all[4];
>>       __be32          ip;
>>       __be32          ip6[4];
>> ...
>> }
>>
>> The __u32, __be32 types are declared in <linux/types.h> and the #include
>> directive is removed by the installation process. This in turn makes some
>> applications unbuildable against such an exported tree, e.g.
>>
>> busybox-1.10.1/networking/tcpudp.c:#include <linux/netfilter_ipv4.h>
>>
>> If I correctly understand the purpose of make headers_install, it is
>> supposed to generate an API for applications. I could certainly
>> make tcpudp.c include linux/types.h, but given that the application
>> does not even use nf_inet_addr, this would be the wrong place for
>> the fix.

Greg, does this fix the problem?


--------------000401050007010703090101
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 34d75b526704f4aa4d71f57a81cc15d8b18f5555
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed May 21 12:57:49 2008 +0200

    [NETFILTER]: Move linux/types.h inclusions outside of #ifdef __KERNEL__
    
    Greg Steuck <greg@nest.cx> points out that some of the netfilter
    headers can't be used in userspace without including linux/types.h
    first. The headers include their own linux/types.h include statements,
    these are stripped by make headers-install because they are inside
    #ifdef __KERNEL__ however. Move them out to fix this.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index e4c6659..0c5eb7e 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -3,7 +3,6 @@
 
 #ifdef __KERNEL__
 #include <linux/init.h>
-#include <linux/types.h>
 #include <linux/skbuff.h>
 #include <linux/net.h>
 #include <linux/netdevice.h>
@@ -14,6 +13,7 @@
 #include <linux/list.h>
 #include <net/net_namespace.h>
 #endif
+#include <linux/types.h>
 #include <linux/compiler.h>
 
 /* Responses from hook functions. */
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index dd9c97f..590ac3d 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -11,11 +11,11 @@
 
 #ifdef __KERNEL__
 #include <linux/if.h>
-#include <linux/types.h>
 #include <linux/in.h>
 #include <linux/if_arp.h>
 #include <linux/skbuff.h>
 #endif
+#include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/netfilter_arp.h>
 
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index bfc889f..092bd50 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -17,11 +17,11 @@
 
 #ifdef __KERNEL__
 #include <linux/if.h>
-#include <linux/types.h>
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/skbuff.h>
 #endif
+#include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/netfilter_ipv4.h>
 
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index f2507dc..1089e33 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -17,11 +17,11 @@
 
 #ifdef __KERNEL__
 #include <linux/if.h>
-#include <linux/types.h>
 #include <linux/in6.h>
 #include <linux/ipv6.h>
 #include <linux/skbuff.h>
 #endif
+#include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/netfilter_ipv6.h>
 

--------------000401050007010703090101--
