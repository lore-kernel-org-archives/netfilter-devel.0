From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [PATCH] TPROXY cleanups
Date: Mon, 6 Oct 2008 14:26:03 +0200
Message-ID: <20081006122603.GA18559@sch.bme.hu>
References: <20081006121943.GA13547@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, hidden@sch.bme.hu, netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:35574 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYJFM0H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:26:07 -0400
Content-Disposition: inline
In-Reply-To: <20081006121943.GA13547@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On h, okt 06, 2008 at 04:19:44 +0400, Alexey Dobriyan wrote:
> * drop version.h -- unneeded and file will be needlessly rebuilt.
> * make tproxy_core unloadable
> * use "in" device outright, -- target and match are only in PRE_ROUTING,
>   so should avoid dereference.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  net/netfilter/nf_tproxy_core.c |    5 ++++-
>  net/netfilter/xt_TPROXY.c      |    2 +-
>  net/netfilter/xt_socket.c      |    2 +-
>  3 files changed, 6 insertions(+), 3 deletions(-)
> 
> --- a/net/netfilter/nf_tproxy_core.c
> +++ b/net/netfilter/nf_tproxy_core.c
> @@ -10,7 +10,6 @@
>   *
>   */
>  
> -#include <linux/version.h>
>  #include <linux/module.h>
>  
>  #include <linux/net.h>
> @@ -89,7 +88,11 @@ static int __init nf_tproxy_init(void)
>  	return 0;
>  }
>  
> +static void __exit nf_tproxy_exit(void)
> +{
> +}
>  module_init(nf_tproxy_init);
> +module_exit(nf_tproxy_exit);

Please don't do this. The module was made unloadable because it attaches a
function pointer to skb's and removing the module while there's an skb in
flight would cause a kernel crash.

Thanks for the other cleanups, though.

-- 
KOVACS Krisztian
