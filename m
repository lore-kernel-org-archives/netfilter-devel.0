From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables: how to parse optional packet header fields?
Date: Fri, 24 Jan 2014 22:37:01 +0000
Message-ID: <20140124223701.GA9170@macbook.localnet>
References: <52E2A1B8.4060008@katalix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: James Chapman <jchapman@katalix.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40737 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaAXWhF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jan 2014 17:37:05 -0500
Content-Disposition: inline
In-Reply-To: <52E2A1B8.4060008@katalix.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 24, 2014 at 05:24:08PM +0000, James Chapman wrote:
> I'm working on adding L2TP support to nftables. L2TP has some optional
> header fields which affect the offset of fields that nftables packet
> filters need to match.
> 
> One possibility could be to define fixed header structures for all
> possible L2TP field offset combinations and have the nft L2TP parser add
> rules for all of the possible layout combinations when matching fields
> which can be at a variable offset, i.e.
> 
> struct l2tpv2_hdr {
>     uint16_t flags;
>     uint16_t len;       /* present if L bit in flags is set */
>     uint16_t tunnel_id;
>     uint16_t session_id;
> };
> 
> struct l2tpv2_nolen_hdr {
>     uint16_t flags;
>     uint16_t tunnel_id;
>     uint16_t session_id;
> };
> 
> L2TP users don't know or care if the L2TPv2 header includes the length
> field, so it would be best not to expose this as a nft rule parameter.
> Its presence is determined by a bit in the flags field of the header.
> 
> Is there a better way to handle packet header layouts where the field
> offsets depend on other field values?

That's an interesting question which is also relevant for GRE. So far
I've ignored it.

First, lets start with semantics I guess - the user doesn't care about
this, I agree. Still, if the user explicitly asks for the len field,
I think we should assume he's only interested in packets with the
L bit set, so in that case we check for the L bit and assume the first
header type even for the other members.

The other cases are unfortunately not easy to handle. One possibility
would be to generate two matches and combine them using |. The problem
is that we don't have conditional execution for single expressions
and adding it just for this very special case is very undesirable since
it would affect the hottest loop in the entire code.

I think we might be able to add something that doesn't add much costs
to the main loop. Basically a conditional seek to an expression in
the current rule. Similar as we do with chain jumps, we'd return a
verdict of NFT_SEEK and a pointer to the expression where to continue.

Another possibility would be to add some arithmentic operations and
a runtime parameterizable variant of the payload expression. This
would keep all the ugly contained outside of the main loop.

Not sure, I think we need to think about this a bit more to make
sure we can also handle the next similar case that comes up
properly.

Any other ideas?
