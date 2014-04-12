From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables data type names
Date: Sat, 12 Apr 2014 13:03:53 +0200
Message-ID: <20140412110352.GA15624@macbook.localnet>
References: <20140412102901.GA8090@macbook.localnet>
 <20140412105646.GJ31953@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42412 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbaDLLD4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2014 07:03:56 -0400
Content-Disposition: inline
In-Reply-To: <20140412105646.GJ31953@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 12, 2014 at 12:56:46PM +0200, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > Before the upcoming release, I'd like to add some more consistency among
> > nftables data type names. We currently have the following types:
> [..]
> > In some cases we're more verbose, in other we're using abrevations.
> > I'd like to decide for either one.
> > 
> > The following ones should IMO definitely be changed:
> > 
> > - etheraddr => ether_address or mac_address. ether_addr would be more
> >   consistent with ethertype.
> > 
> > - ethertype => ether_type if ether_addr is used
> 
> I like ether_type/ether_addr.

Ok, lets take those.

> > - optionally: *_address => *_addr
> 
> We already have 'ip saddr/daddr' etc in nft rules,
> so I'd prefer to use _addr everywhere.

Good point.

> > - arphrd => iftype/interface_type?
> 
> I read that as "arphdr"...

Yeah, same here.

> Since its used of iif/oiftype I think interface_type is good choice.

Agreed, will change.

> > If we're deciding for more verbose names (which IMO is fine for types),
> > I'd also change:
> > 
> > - arp_op => arp_operation
> > - ifindex => interface_index
> > - nfproto => nf_protocol
> 
> I agree iff we go for eg. _address instead of _addr.
> I would prefer _addr, i.e.

Yep.

> > otherwise:
> > 
> > - inet_protocol => inet_proto
> 
> inet_proto, too.
> Looking at scanner.l we also have l3proto, l4proto, nfproto keywords.

I'll also change those.

> [ I realize that there is not requirement to be consistent with
> datatype names vs. nft rules but I see no reason to differ ]

Yeah, sticking to internal data type names is a bad habit from a usability
perspective IMO. iiftype / arphrd is the best example for this.

> > Basically the should be human readable, not programmer readable, should
> > describe what they actually are (not arphrd) and should be consistent.
> 
> Fully agree, more consistency would be good.

Thanks for the feedback, I'll post a patch soon.
