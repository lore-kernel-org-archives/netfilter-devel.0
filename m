From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ROUTE target : update to pom-ng + new version for	kernel
 2.6.x
Date: Thu, 29 Apr 2004 18:45:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40913131.3010400@trash.net>
References: <1082535373.17611.39.camel@descartes.info.ucl.ac.be>	 <408AF23C.3060300@trash.net> <1083165943.709.18.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Cedric de Launois <delaunois@info.ucl.ac.be>
In-Reply-To: <1083165943.709.18.camel@descartes.info.ucl.ac.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Cedric de Launois wrote:

>Oops, sorry. This patch should be better.
>  
>
Still can't apply, the patch contains changes to a
non-existing file, linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c.

Regards
Patrick

>Regards,
>
>Cedric
>
>  
>
>diff -Nru ./ROUTE.orig/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c ./ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c
>--- ./ROUTE.orig/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	2004-02-22 18:29:10.000000000 +0100
>+++ ./ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	2004-04-21 10:17:44.000000000 +0200
>@@ -19,6 +19,7 @@
> #include <net/ip.h>
> #include <net/route.h>
> #include <net/icmp.h>
>+#include <net/checksum.h>
> 
> #if 0
> #define DEBUGP printk
>@@ -28,6 +29,7 @@
> 
>  
>
