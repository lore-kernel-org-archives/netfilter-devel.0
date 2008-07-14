From: Patrick McHardy <kaber@trash.net>
Subject: Re: 02/13 [NETFILTER]: Use unsigned types for hooknum and pf vars
Date: Mon, 14 Jul 2008 15:26:16 +0200
Message-ID: <487B53F8.5080006@trash.net>
References: <alpine.LNX.1.10.0807101522400.27323@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0807101524070.27323@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44685 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYGNN1s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jul 2008 09:27:48 -0400
In-Reply-To: <alpine.LNX.1.10.0807101524070.27323@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit ffffffffffffffffffffffffffffffffffffffff
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Sat Apr 12 08:24:12 2008 +0200
> 
> [NETFILTER]: Use unsigned types for hooknum and pf vars
>     
> and (try to) consistently use u_int8_t for the L3 family.
> 

> +extern struct xt_match *xt_find_match(u_int8_t af, const char *name,
> +				      u8 revision);

It would have been cleaner to at least consistently use u_int8_t/u8
within one function. Alternatively I'd prefer the u8 type since
people usually use that in new patches, so over time we'd get rid
of the type inconsistencies.

> diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
> index a6874ba..55dd1c2 100644
> --- a/include/net/netfilter/nf_conntrack_tuple.h
> +++ b/include/net/netfilter/nf_conntrack_tuple.h
> @@ -37,7 +37,12 @@ union nf_conntrack_man_proto
>  		__be16 port;
>  	} udp;
>  	struct {
> -		__be16 id;
> +		union {
> +			__be16 id;
> +			struct {
> +				__u8 type, code;

This is not exposed to userspace, so there's no need to
use the __ types.

>  	/* These are the parts of the tuple which are fixed. */
>  	struct {
>  		union nf_inet_addr u3;
> -		union {
> -			/* Add other protocols here. */
> -			__be16 all;
> -
> -			struct {
> -				__be16 port;
> -			} tcp;
> -			struct {
> -				__be16 port;
> -			} udp;
> -			struct {
> -				u_int8_t type, code;
> -			} icmp;
> -			struct {
> -				__be16 port;
> -			} dccp;
> -			struct {
> -				__be16 port;
> -			} sctp;
> -			struct {
> -				__be16 key;
> -			} gre;
> -		} u;
> +		union nf_conntrack_man_proto u;

This is an unrelated change that doesn't belong in this patch.
Not that I'm opposed to the change, but the "man" part in the
name stands for manipulable, which doesn't fit here.
