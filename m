From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft RFC] payload: use ethertype in hexadecimal for meta
 protocol
Date: Wed, 15 Jan 2014 17:17:21 +0000
Message-ID: <20140115171642.GA4033@macbook.localnet>
References: <1389805902-8807-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46738 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbaAORRZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:17:25 -0500
Content-Disposition: inline
In-Reply-To: <1389805902-8807-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 15, 2014 at 06:11:42PM +0100, Pablo Neira Ayuso wrote:
> This is a temporary workaround to avoid parsing problems since
> ip and arp are misinterpreted by the parser. It also uses ipv6
> which is different from ip6 and it seems inconsistent to me.

Why not fix it the way we did for TCP/UDP/...?

I agree about the inconsistencies wrt. ipv6 vs. ip6, we should change
all occurences to one of both. Don't really care which one, but I guess
ipv6 is "more correct".

> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> A possible alternative to this patch could be to use something
> like: ether-arp ether-ip ether-ipv6 ether-vlan, as these represent
> ethernet protocol types.



> 
>  src/payload.c |   17 +++--------------
>  1 file changed, 3 insertions(+), 14 deletions(-)
> 
> diff --git a/src/payload.c b/src/payload.c
> index 86d75fa..c4ea6da 100644
> --- a/src/payload.c
> +++ b/src/payload.c
> @@ -978,16 +978,6 @@ const struct datatype etheraddr_type = {
>  	.basetype	= &lladdr_type,
>  };
>  
> -static const struct symbol_table ethertype_tbl = {
> -	.symbols	= {
> -		SYMBOL("ip",		ETH_P_IP),
> -		SYMBOL("arp",		ETH_P_ARP),
> -		SYMBOL("ipv6",		ETH_P_IPV6),
> -		SYMBOL("vlan",		ETH_P_8021Q),
> -		SYMBOL_LIST_END
> -	},
> -};
> -
>  static struct error_record *ethertype_parse(const struct expr *sym,
>  					    struct expr **res)
>  {
> @@ -996,14 +986,13 @@ static struct error_record *ethertype_parse(const struct expr *sym,
>  	erec = sym->dtype->basetype->parse(sym, res);
>  	if (erec != NULL)
>  		return erec;
> -	if (*res)
> -		return NULL;
> -	return symbolic_constant_parse(sym, &ethertype_tbl, res);
> +
> +	return NULL;
>  }
>  
>  static void ethertype_print(const struct expr *expr)
>  {
> -	return symbolic_constant_print(&ethertype_tbl, expr);
> +	expr_basetype(expr)->print(expr);
>  }
>  
>  const struct datatype ethertype_type = {
> -- 
> 1.7.10.4
