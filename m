From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft v3 2/2] datatype: Implement binary search in
 symbolic_constant_print()
Date: Mon, 28 Nov 2016 23:12:23 +0100
Message-ID: <20161128221223.GB9858@breakpoint.cc>
References: <20161128202312.GA8763@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38562 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755577AbcK1WPT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 17:15:19 -0500
Content-Disposition: inline
In-Reply-To: <20161128202312.GA8763@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Elise Lennion <elise.lennion@gmail.com> wrote:
> Because a linear search is used, which is slower.
> 
> This approach demands that the symbol_table have a variable with its
> size, also, it must be sorted by value.

Did Pablo put you up to this?  Bad Pablo, bad!  :-P

because:

>  static const struct symbol_table ethertype_tbl = {
> +	.size 		= 4,
>  	.symbols	= {
>  		SYMBOL("ip",		__constant_htons(ETH_P_IP)),
> +		SYMBOL("vlan",		__constant_htons(ETH_P_8021Q)),
>  		SYMBOL("arp",		__constant_htons(ETH_P_ARP)),
>  		SYMBOL("ip6",		__constant_htons(ETH_P_IPV6)),
> -		SYMBOL("vlan",		__constant_htons(ETH_P_8021Q)),
>  		SYMBOL_LIST_END
>  	},

This is unmaintanable.  I have no clue what value ETH_P_8021Q is, and that
this has to be placed at spot #2 to not break things.
