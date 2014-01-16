From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 1/3] parser: fix parsing of ethernet protocol types
Date: Thu, 16 Jan 2014 16:28:16 +0000
Message-ID: <20140116162816.GA4111@macbook.localnet>
References: <1389817823-7251-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57380 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbaAPQ2T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:28:19 -0500
Content-Disposition: inline
In-Reply-To: <1389817823-7251-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 15, 2014 at 09:30:21PM +0100, Pablo Neira Ayuso wrote:
> This allows us to use the protocol type keyword, eg.
> 
> nft add rule ip filter output meta protocol ip6 counte
>                                             ^^^

I see two problems with this patch:

- the mapping to ETH_P_* is fixed. In case of f.i. meta nfproto relational
  expression it would have to map to NFPROTO_* values. So I think we should
  use symbolic expressions instead of constants and leave parsing to the
  evaluation phase-

- we're still using a mix of ip6 and ipv6. Lets also fix that, ideally
  as a patch before this one.

I can take care of this if you like.


> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/parser.y |   29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/src/parser.y b/src/parser.y
> index 038282e..23662f7 100644
> --- a/src/parser.y
> +++ b/src/parser.y
> @@ -23,6 +23,7 @@
>  #include <expression.h>
>  #include <utils.h>
>  #include <parser.h>
> +#include <if_ether.h>
>  #include <erec.h>
>  
>  #include "parser.h"
> @@ -1418,6 +1419,13 @@ vlan_hdr_expr		:	VLAN	vlan_hdr_field
>  			{
>  				$$ = payload_expr_alloc(&@$, &payload_vlan, $2);
>  			}
> +			|	VLAN
> +			{
> +				uint16_t data = ETH_P_8021Q;
> +				$$ = constant_expr_alloc(&@$, &ethertype_type,
> +							 BYTEORDER_HOST_ENDIAN,
> +							 sizeof(data) * BITS_PER_BYTE, &data);
> +			}
>  			;
>  
>  vlan_hdr_field		:	ID		{ $$ = VLANHDR_VID; }
> @@ -1430,6 +1438,13 @@ arp_hdr_expr		:	ARP	arp_hdr_field
>  			{
>  				$$ = payload_expr_alloc(&@$, &payload_arp, $2);
>  			}
> +			|	ARP
> +			{
> +				uint16_t data = ETH_P_ARP;
> +				$$ = constant_expr_alloc(&@$, &ethertype_type,
> +							 BYTEORDER_HOST_ENDIAN,
> +							 sizeof(data) * BITS_PER_BYTE, &data);
> +			}
>  			;
>  
>  arp_hdr_field		:	HTYPE		{ $$ = ARPHDR_HRD; }
> @@ -1443,6 +1458,13 @@ ip_hdr_expr		:	IP	ip_hdr_field
>  			{
>  				$$ = payload_expr_alloc(&@$, &payload_ip, $2);
>  			}
> +			|	IP
> +			{
> +				uint16_t data = ETH_P_IP;
> +				$$ = constant_expr_alloc(&@$, &ethertype_type,
> +							 BYTEORDER_HOST_ENDIAN,
> +							 sizeof(data) * BITS_PER_BYTE, &data);
> +			}
>  			;
>  
>  ip_hdr_field		:	VERSION		{ $$ = IPHDR_VERSION; }
> @@ -1484,6 +1506,13 @@ ip6_hdr_expr		:	IP6	ip6_hdr_field
>  			{
>  				$$ = payload_expr_alloc(&@$, &payload_ip6, $2);
>  			}
> +			|	IP6
> +			{
> +				uint16_t data = ETH_P_IPV6;
> +				$$ = constant_expr_alloc(&@$, &ethertype_type,
> +							 BYTEORDER_HOST_ENDIAN,
> +							 sizeof(data) * BITS_PER_BYTE, &data);
> +			}
>  			;
>  
>  ip6_hdr_field		:	VERSION		{ $$ = IP6HDR_VERSION; }
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
