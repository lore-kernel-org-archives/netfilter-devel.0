From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [PATCH] netfilter: resolve compilation error in userspace when
 using ip_tables.h
Date: Sun, 24 Apr 2016 19:38:24 +0300
Message-ID: <20160424163824.GK5160@lakka.kapsi.fi>
References: <alpine.LSU.2.20.1604221535250.14824@nerf40.vanv.qr>
 <1461333870-17030-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	normand@linux.vnet.ibm.com
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45708 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbcDXQib (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Apr 2016 12:38:31 -0400
Content-Disposition: inline
In-Reply-To: <1461333870-17030-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 22, 2016 at 04:04:30PM +0200, Jan Engelhardt wrote:
> Compilation of iptables plugins which include these two lines
> 
> 	#include <xtables.h>
> 	#include <linux/netfilter_ipv4/ip_tables.h>
> 
> fails since commit 1ffad83dffd675cd742286ae82dca7d746cb0da8, because
> the userspace parts almost everywhere include <net/if.h>, which
> collides with <linux/if.h>.
> 
> Use the __KERNEL__ trick that was last present in
> d16cf20e2f2f13411eece7f7fb72c17d141c4a84^:include/linux/netfilter_ipv4/ip_queue.h
> to resolve this.
> 
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>  include/uapi/linux/netfilter_ipv4/ip_tables.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/netfilter_ipv4/ip_tables.h b/include/uapi/linux/netfilter_ipv4/ip_tables.h
> index d0da53d..784a4b7 100644
> --- a/include/uapi/linux/netfilter_ipv4/ip_tables.h
> +++ b/include/uapi/linux/netfilter_ipv4/ip_tables.h
> @@ -17,7 +17,11 @@
>  
>  #include <linux/types.h>
>  #include <linux/compiler.h>
> -#include <linux/if.h>
> +#ifdef __KERNEL__
> +#	include <linux/if.h>
> +#else
> +#	include <net/if.h>
> +#endif

When I tried to fix uapi header compile problems like this, they got rejected
in review since kernel uapi headers should not include on glibc headers.

I hope http://marc.info/?l=linux-kernel&m=146151279018490
fixes this. If not, then I guess the headers include kernel side headers
before glibc ones and need some #define magic into glibc.

-Mikko
