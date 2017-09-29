From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 0/10] nftables remove use of meta nfproto
Date: Fri, 29 Sep 2017 12:24:34 +0200
Message-ID: <20170929102434.GA2654@salvia>
References: <20170927181654.3129-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [213.95.27.120] ([213.95.27.120]:58955 "EHLO
        ganesha.gnumonks.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750927AbdI2KZr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2017 06:25:47 -0400
Content-Disposition: inline
In-Reply-To: <20170927181654.3129-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 27, 2017 at 08:16:44PM +0200, Florian Westphal wrote:
> inet family (and others, e.g. bridge) lack context to figure
> out the layer 3 address type.
> 
> examples:
> ct original saddr $addr
> rt nexthop $addr
> 
> We can't use $addr, because it might be a set reference, e.g.
> 
> ct original saddr @whitelist
> 
> currently implemented workaround is to use 'meta nfproto'
> to provide the l3 context, e.g.
> 
> meta nfproto ip rt nexthop 10.2.3.4
> 
> i.e. users need to fill dependency manually.
> 
> Pablo suggested to instead specify ip saddr, ip6 saddr:
> 
> ct original ip saddr $address
> 
> and then let nft handle the dependency injection.
> 
> This series does just that.
> 
> Old syntax is preserved.

Nice series, thanks Florian.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
