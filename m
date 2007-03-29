From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnetfilter_conntrack: add extern C's to public headers
Date: Fri, 30 Mar 2007 00:05:34 +0200
Message-ID: <460C382E.6020108@netfilter.org>
References: <45FF7A38.8090907@ipom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Phil Dibowitz <phil@ipom.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45FF7A38.8090907@ipom.com>
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

Sorry for the late reply.

Phil Dibowitz wrote:
> --- libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h.orig	2007-03-19 22:53:08.000000000 -0700
> +++ libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h	2007-03-19 22:53:30.000000000 -0700
> @@ -2,6 +2,10 @@
>  #define _IPCONNTRACK_NETLINK_H
>  #include <libnfnetlink/linux_nfnetlink.h>
>  
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +

Do you really need to include the extern "C" in linux_nfnetlink_conntrack.h?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
