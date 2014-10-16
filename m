From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH v2 2/3] netfilter: refactor NAT redirect IPv6
 code to use it from nf_tables
Date: Thu, 16 Oct 2014 14:02:47 +0200
Message-ID: <20141016120247.GC3346@salvia>
References: <20141016102224.4715.64585.stgit@nfdev.cica.es>
 <20141016102335.4715.60796.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40012 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbaJPMB3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:01:29 -0400
Content-Disposition: inline
In-Reply-To: <20141016102335.4715.60796.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 16, 2014 at 12:23:57PM +0200, Arturo Borrero Gonzalez wrote:
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index a0716a3..f54b5f8 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -836,6 +836,7 @@ config NETFILTER_XT_TARGET_REDIRECT
>  	tristate "REDIRECT target support"
>  	depends on NF_NAT
>  	select NF_NAT_REDIRECT_IPV4
> +	select NF_NAT_REDIRECT_IPV6

        select NF_NAT_REDIRECT_IPV6 if IP6_NF_IPTABLES
