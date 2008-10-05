From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: Move extensions' arguments into compound structure
 (1/2)
Date: Sun, 05 Oct 2008 16:30:08 +0200
Message-ID: <48E8CF70.9090309@trash.net>
References: <alpine.LNX.1.10.0810031851430.13861@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46026 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbYJEOaO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 10:30:14 -0400
In-Reply-To: <alpine.LNX.1.10.0810031851430.13861@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> [NETFILTER]: Move extensions' arguments into compound structure (1/2)
> 
> The function signatures for Xtables extensions have grown over time.
> It involves a lot of typing/replication, and also a bit of stack space
> even if they are not used. Realize an NFWS2008 idea and pack them into
> structs. The skb remains outside of the struct so gcc can continue to
> apply its optimizations.
> 
> This patch does this for matches (only).

This looks good to me, it will reduce the maintenance overhead
considerably when doing changes in this area.

> @@ -223,9 +223,18 @@ do_match(struct ip6t_entry_match *m,
>  	      unsigned int protoff,
>  	      bool *hotdrop)
>  {
> +	struct xt_match_param par = {
> +		.in        = in,
> +		.out       = out,
> +		.match     = m->u.kernel.match,
> +		.matchinfo = m->data,
> +		.fragoff   = offset,
> +		.thoff     = protoff,
> +		.hotdrop   = hotdrop,
> +	};

Some of these members are constant during evaluation, so it would save
some overhead to initialize the structure on a higher level and only
fill in the match specific bits in do_match(). Alternatively you could
use two structures, one for the fixes bits related to the packet, one
for the match specific bits.

BTW, networking is using the same patch headline scheme as most of
the other subsystems nowadays, so please use "netfilter: " instead
of [NETFILTER]: in future patches. I also usually add the netfilter
internal subsystem, so this one would probably be
"netfilter: x_tables: move extensions' arguments ...".

