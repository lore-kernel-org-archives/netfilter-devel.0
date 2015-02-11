From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Don't hide NETFILTER_XT_MATCH_ADDRTYPE behind
 NETFILTER_ADVANCED
Date: Wed, 11 Feb 2015 16:11:07 +0100
Message-ID: <20150211151107.GA4333@salvia>
References: <20150121105350.77e77534@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>, sfr@canb.auug.org.au,
	mpe@ellerman.id.au, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
To: Anton Blanchard <anton@samba.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34801 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbbBKPHw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2015 10:07:52 -0500
Content-Disposition: inline
In-Reply-To: <20150121105350.77e77534@kryten>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 21, 2015 at 10:53:50AM +1100, Anton Blanchard wrote:
> Docker needs NETFILTER_XT_MATCH_ADDRTYPE, so move it out from behind
> NETFILTER_ADVANCED and make it default to a module.

Missed this little one, applied thanks.

> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
>  net/netfilter/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index b02660f..c68c3b4 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -951,7 +951,7 @@ comment "Xtables matches"
>  
>  config NETFILTER_XT_MATCH_ADDRTYPE
>  	tristate '"addrtype" address type match support'
> -	depends on NETFILTER_ADVANCED
> +	default m if NETFILTER_ADVANCED=n
>  	---help---
>  	  This option allows you to match what routing thinks of an address,
>  	  eg. UNICAST, LOCAL, BROADCAST, ...
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
