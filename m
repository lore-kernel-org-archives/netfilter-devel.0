From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] scanner: rename address selector from 'eth' to
 'ether'
Date: Tue, 14 Jan 2014 12:23:39 +0000
Message-ID: <20140114122339.GC27277@macbook.localnet>
References: <1389699030-6301-1-git-send-email-pablo@netfilter.org>
 <1389699030-6301-4-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33912 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaANMXn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:23:43 -0500
Content-Disposition: inline
In-Reply-To: <1389699030-6301-4-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 14, 2014 at 12:30:30PM +0100, Pablo Neira Ayuso wrote:
> eth is may easily ocur when using ifname mask. This could be also
> fixed by interpreting 'eth' as a simple string in the parser but
> I think this selector also looks more similar to what we use in
> tcpdump.

This is a very good idea, I always use ether by mistake anyway :)

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/parser.y  |    4 ++--
>  src/scanner.l |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/src/parser.y b/src/parser.y
> index 26e71e3..461eb3f 100644
> --- a/src/parser.y
> +++ b/src/parser.y
> @@ -193,7 +193,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
>  
>  %token BRIDGE			"bridge"
>  
> -%token ETH			"eth"
> +%token ETHER			"ether"
>  %token SADDR			"saddr"
>  %token DADDR			"daddr"
>  %token TYPE			"type"
> @@ -1392,7 +1392,7 @@ payload_base_spec	:	LL_HDR		{ $$ = PAYLOAD_BASE_LL_HDR; }
>  			|	TRANSPORT_HDR	{ $$ = PAYLOAD_BASE_TRANSPORT_HDR; }
>  			;
>  
> -eth_hdr_expr		:	ETH	eth_hdr_field
> +eth_hdr_expr		:	ETHER	eth_hdr_field
>  			{
>  				$$ = payload_expr_alloc(&@$, &payload_eth, $2);
>  			}
> diff --git a/src/scanner.l b/src/scanner.l
> index 2d7ac88..a4db017 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -278,7 +278,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  
>  "bridge"		{ return BRIDGE; }
>  
> -"eth"			{ return ETH; }
> +"ether"			{ return ETHER; }
>  "saddr"			{ return SADDR; }
>  "daddr"			{ return DADDR; }
>  "type"			{ return TYPE; }
> -- 
> 1.7.10.4
