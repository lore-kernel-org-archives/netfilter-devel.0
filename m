From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Tue, 27 May 2008 09:35:58 +0200
Message-ID: <483BB9DE.6050003@trash.net>
References: <483AB493.6010503@trash.net> <x6skw443x5@gzp>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000304030108020503020800"
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: "Gabor Z. Papp" <gzp@papp.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45169 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313AbYE0HgB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2008 03:36:01 -0400
In-Reply-To: <x6skw443x5@gzp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000304030108020503020800
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Gabor Z. Papp wrote:
>   CC       libxt_connlimit.oo
> In file included from /usr/include/linux/netfilter_ipv4.h:9,
>                  from ../include/linux/netfilter_ipv4/ip_tables.h:18,
>                  from ../include/libiptc/libiptc.h:7,
>                  from ../include/iptables.h:5,
>                  from libxt_connlimit.c:8:
> ../include/linux/netfilter.h:41: error: expected specifier-qualifier-list before '__be32'
> make[2]: *** [libxt_connlimit.oo] Error 1
> make[2]: Leaving directory `/home/gzp/src/iptables-1.4.1-rc2/extensions'
> make[1]: *** [all-recursive] Error 1
> make[1]: Leaving directory `/home/gzp/src/iptables-1.4.1-rc2'
> make: *** [all] Error 2

Thanks for the report. Does this patch fix it?


--------------000304030108020503020800
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 4196a51..6ea935f 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_NETFILTER_H
 #define __LINUX_NETFILTER_H
 
+#include <linux/types.h>
 
 /* Responses from hook functions. */
 #define NF_DROP 0
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index fc64b97..c42c73f 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -15,6 +15,7 @@
 #ifndef _IPTABLES_H
 #define _IPTABLES_H
 
+#include <linux/types.h>
 #include <linux/netfilter_ipv4.h>
 
 #include <linux/netfilter/x_tables.h>
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 68b22fc..fb03b31 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -15,6 +15,7 @@
 #ifndef _IP6_TABLES_H
 #define _IP6_TABLES_H
 
+#include <linux/types.h>
 #include <linux/netfilter_ipv6.h>
 
 #include <linux/netfilter/x_tables.h>

--------------000304030108020503020800--
