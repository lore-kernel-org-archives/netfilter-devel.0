From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: xt_stealth as separate patch against xtables-addons-1.17
Date: Thu, 24 Sep 2009 17:06:38 +0200
Message-ID: <1253804798.13029.45.camel@bzorp.balabit>
References: <alpine.LNX.2.00.0909011937060.7713@cedric.unob.cz>
	 <alpine.LSU.2.00.0909240211160.31517@obet.zrqbmnf.qr>
	 <alpine.LNX.2.00.0909241450270.8925@cedric.unob.cz>
	 <alpine.LSU.2.00.0909241503360.29849@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Rafaj <jr+netfilter-devel@cedric.unob.cz>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, spender@grsecurity.net
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:36225 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754064AbZIXPGj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:06:39 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 1867711E14E
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Sep 2009 17:06:41 +0200 (CEST)
In-Reply-To: <alpine.LSU.2.00.0909241503360.29849@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2009-09-24 at 15:11 +0200, Jan Engelhardt wrote:
> On Thursday 2009-09-24 14:58, Jan Rafaj wrote:
> >> I looked at xt_stealth and it looks like
> >> -A INPUT -j sktest; -A sktest -m socket -j RETURN; -A sktest -j DROP
> >> can do just the same. Please tell me if I am wrong anywhere.
> >> That would mean there is no need for xt_stealth.
> >
> > Yeah, thanks for suggestion.
> > On 2.6.29.6 with iptables 1.4.4, tried [that].
> > Unfortunately, adding the last rule failed with message:
> >
> >  ip_tables: socket match: bad hook_mask 0x2/0x1
> 
> Ah, xt_socket is only for PREROUTING at the moment. I wonder,
> (cc'ing Balazs) whether there would be any adverse effect
> (or not doing anything at all) if it were also made available
> in INPUT. The difference would not be that much; you could
> test for the socket in PREROUTING/mangle and set a mark;
> test the mark in filter and DROP or let through. Anyway,
> for great simplicity, I am proposing
> 
> 
> parent 94a8d5caba74211ec76dac80fc6e2d5c391530df (v2.6.31-8358-g94a8d5c)
> commit d075810e672c11ef7287f36f0366e9f44c0b46e2
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Thu Sep 24 15:09:19 2009 +0200
> 
> netfilter: xt_socket: make module available for INPUT chain
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  net/netfilter/xt_socket.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
> index ebf00ad..3965778 100644
> --- a/net/netfilter/xt_socket.c
> +++ b/net/netfilter/xt_socket.c
> @@ -192,7 +192,8 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
>  		.revision	= 0,
>  		.family		= NFPROTO_IPV4,
>  		.match		= socket_mt_v0,
> -		.hooks		= 1 << NF_INET_PRE_ROUTING,
> +		.hooks		= (1 << NF_INET_PRE_ROUTING) |
> +				  (1 << NF_INET_LOCAL_IN),
>  		.me		= THIS_MODULE,
>  	},
>  	{
> @@ -201,7 +202,8 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
>  		.family		= NFPROTO_IPV4,
>  		.match		= socket_mt_v1,
>  		.matchsize	= sizeof(struct xt_socket_mtinfo1),
> -		.hooks		= 1 << NF_INET_PRE_ROUTING,
> +		.hooks		= (1 << NF_INET_PRE_ROUTING) |
> +				  (1 << NF_INET_LOCAL_IN),
>  		.me		= THIS_MODULE,
>  	},
>  };

This looks ok for me.

Signed-off-by: Balazs Scheidler <bazsi@balabit.hu>

-- 
Bazsi

