From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ROUTE target : update to pom-ng + new version for kernel
 2.6.x
Date: Sun, 25 Apr 2004 01:03:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <408AF23C.3060300@trash.net>
References: <1082535373.17611.39.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Cedric de Launois <delaunois@info.ucl.ac.be>
In-Reply-To: <1082535373.17611.39.camel@descartes.info.ucl.ac.be>
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
> Here is a patch to convert the ROUTE target to the new pom-ng.
> This patch also contains a corrected version of the ROUTE target
> for kernels 2.6.x.

Please make sure your patch doesn't contain changes to CVS directories.

Regards
Patrick

> 
> Cedric
> 
> 
> 
> diff -Nru ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Entries ROUTE/linux-2.4/net/ipv6/netfilter/CVS/Entries
> --- ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Entries	1970-01-01 01:00:00.000000000 +0100
> +++ ROUTE/linux-2.4/net/ipv6/netfilter/CVS/Entries	2004-03-08 10:06:41.000000000 +0100
> @@ -0,0 +1,5 @@
> +/Config.in.ladd/1.1/Sat Dec 20 16:43:09 2003//
> +/Kconfig.ladd/1.1/Tue Dec 23 11:41:11 2003//
> +/Makefile.ladd/1.1/Sat Dec 20 16:43:09 2003//
> +/ip6t_ROUTE.c/1.1/Sat Dec 20 16:43:09 2003//
> +D
> diff -Nru ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Repository ROUTE/linux-2.4/net/ipv6/netfilter/CVS/Repository
> --- ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Repository	1970-01-01 01:00:00.000000000 +0100
> +++ ROUTE/linux-2.4/net/ipv6/netfilter/CVS/Repository	2004-03-08 10:06:41.000000000 +0100
> @@ -0,0 +1 @@
> +patch-o-matic-ng/ROUTE/linux/net/ipv6/netfilter
> diff -Nru ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Root ROUTE/linux-2.4/net/ipv6/netfilter/CVS/Root
> --- ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Root	1970-01-01 01:00:00.000000000 +0100
> +++ ROUTE/linux-2.4/net/ipv6/netfilter/CVS/Root	2004-03-08 10:06:41.000000000 +0100
> @@ -0,0 +1 @@
> +:pserver:cvs:cvs@pserver.netfilter.org:/cvspublic
