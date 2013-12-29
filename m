From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: nft: explicit dependency to IPv6
Date: Sun, 29 Dec 2013 12:00:55 +0100
Message-ID: <20131229110055.GA3808@localhost>
References: <1388311290-18366-1-git-send-email-eric@regit.org>
 <1388311290-18366-3-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55487 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab3L2LBB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Dec 2013 06:01:01 -0500
Content-Disposition: inline
In-Reply-To: <1388311290-18366-3-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

On Sun, Dec 29, 2013 at 11:01:30AM +0100, Eric Leblond wrote:
> nftables IPv6 tables could be selected independently of other
> Netfilter component so it needs to be dependent of IPv6.
> 
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  net/ipv6/netfilter/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
> index 7702f9e..36c71da 100644
> --- a/net/ipv6/netfilter/Kconfig
> +++ b/net/ipv6/netfilter/Kconfig
> @@ -27,6 +27,7 @@ config NF_CONNTRACK_IPV6
>  
>  config NF_TABLES_IPV6
>  	depends on NF_TABLES
> +	depends on INET && IPV6
>  	tristate "IPv6 nf_tables support"

We already have this dependency in the parent menu

 #
 # IP netfilter configuration
 #

 menu "IPv6: Netfilter Configuration"
         depends on INET && IPV6 && NETFILTER

So I think that should be enough, let me know if you're noticing any
problem. Thanks.
