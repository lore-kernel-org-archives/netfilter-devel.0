From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_nat_snmp_basic: fix compiler warning on 64-bit	arch-s
Date: Fri, 18 Jul 2008 19:57:41 +0200
Message-ID: <4880D995.4010606@trash.net>
References: <4880A611.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jan Beulich <jbeulich@novell.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59301 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbYGRR5k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:57:40 -0400
In-Reply-To: <4880A611.76E4.0078.0@novell.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Beulich wrote:
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  net/ipv4/netfilter/nf_nat_snmp_basic.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.26/net/ipv4/netfilter/nf_nat_snmp_basic.c	2008-07-13 23:51:29.000000000 +0200
> +++ 2.6.26-netfilter-warning/net/ipv4/netfilter/nf_nat_snmp_basic.c	2008-07-15 14:51:28.000000000 +0200
> @@ -445,7 +445,7 @@ static unsigned char asn1_oid_decode(str
>  	size = eoc - ctx->pointer + 1;
>  
>  	/* first subid actually encodes first two subids */
> -	if (size < 2 || size > ULONG_MAX/sizeof(unsigned long))
> +	if (size < 2 || size > UINT_MAX/sizeof(unsigned long))

Thanks, I already have a similar fix queued.
