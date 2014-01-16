From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 3/3] payload: fix inconsistency in ethertype output
Date: Thu, 16 Jan 2014 16:32:01 +0000
Message-ID: <20140116163201.GC4111@macbook.localnet>
References: <1389817823-7251-1-git-send-email-pablo@netfilter.org>
 <1389817823-7251-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57413 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaAPQcG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:32:06 -0500
Content-Disposition: inline
In-Reply-To: <1389817823-7251-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 15, 2014 at 09:30:23PM +0100, Pablo Neira Ayuso wrote:
> Use ip6 instead of ipv6.

Sorry, didn't see this before. That leaves just the first problem for patch
1/3.

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/payload.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/payload.c b/src/payload.c
> index decfcd6..bfd8ba4 100644
> --- a/src/payload.c
> +++ b/src/payload.c
> @@ -982,7 +982,7 @@ static const struct symbol_table ethertype_tbl = {
>  	.symbols	= {
>  		SYMBOL("ip",		ETH_P_IP),
>  		SYMBOL("arp",		ETH_P_ARP),
> -		SYMBOL("ipv6",		ETH_P_IPV6),
> +		SYMBOL("ip6",		ETH_P_IPV6),
>  		SYMBOL("vlan",		ETH_P_8021Q),
>  		SYMBOL_LIST_END
>  	},
> -- 
> 1.7.10.4
