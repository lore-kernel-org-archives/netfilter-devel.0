From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: Re: [PATCH] ipt_ROUTE build fix
Date: Thu, 10 Jun 2004 10:23:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1086855832.570.2.camel@descartes.info.ucl.ac.be>
References: <20040530000459.GA2389@alpha.home.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ZFasdJfd9QDNgS5AYklb"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20040530000459.GA2389@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-ZFasdJfd9QDNgS5AYklb
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Le dim 30/05/2004 a 02:04, Willy Tarreau a ecrit :
> Hi all,
> 
> I had to include the following patch to build ipt_ROUTE as a module
> under 2.4.27-pre3 (ip_fast_csum not found). I believe it broke not too
> long ago but was lazy enough to check when since the patch is 1-line.
> Patch against pom-ng-040528. 

Ok. Thanks. The rediff-ed patch is attached.

Jozsef ? please apply,

Cedric


--=-ZFasdJfd9QDNgS5AYklb
Content-Disposition: attachment; filename=ipt_ROUTE-csum-include.patch
Content-Type: text/x-patch; name=ipt_ROUTE-csum-include.patch; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

--- patch-o-matic-ng/ROUTE/linux/net/ipv4/netfilter/ipt_ROUTE.c.orig	2004-05-14 09:08:03.000000000 +0200
+++ patch-o-matic-ng/ROUTE/linux/net/ipv4/netfilter/ipt_ROUTE.c	2004-06-09 16:27:05.000000000 +0200
@@ -19,6 +19,7 @@
 #include <net/ip.h>
 #include <net/route.h>
 #include <net/icmp.h>
+#include <net/checksum.h>
 
 #if 0
 #define DEBUGP printk

--=-ZFasdJfd9QDNgS5AYklb--
