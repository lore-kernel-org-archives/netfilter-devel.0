From: Florian Westphal <fw@strlen.de>
Subject: Re: nftables data type names
Date: Sat, 12 Apr 2014 12:56:46 +0200
Message-ID: <20140412105646.GJ31953@breakpoint.cc>
References: <20140412102901.GA8090@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36267 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754188AbaDLK4s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2014 06:56:48 -0400
Content-Disposition: inline
In-Reply-To: <20140412102901.GA8090@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> Before the upcoming release, I'd like to add some more consistency among
> nftables data type names. We currently have the following types:
[..]
> In some cases we're more verbose, in other we're using abrevations.
> I'd like to decide for either one.
> 
> The following ones should IMO definitely be changed:
> 
> - etheraddr => ether_address or mac_address. ether_addr would be more
>   consistent with ethertype.
> 
> - ethertype => ether_type if ether_addr is used

I like ether_type/ether_addr.

> - optionally: *_address => *_addr

We already have 'ip saddr/daddr' etc in nft rules,
so I'd prefer to use _addr everywhere.

> - arphrd => iftype/interface_type?

I read that as "arphdr"...

Since its used of iif/oiftype I think interface_type is good choice.

> If we're deciding for more verbose names (which IMO is fine for types),
> I'd also change:
> 
> - arp_op => arp_operation
> - ifindex => interface_index
> - nfproto => nf_protocol

I agree iff we go for eg. _address instead of _addr.
I would prefer _addr, i.e.

> otherwise:
> 
> - inet_protocol => inet_proto

inet_proto, too.
Looking at scanner.l we also have l3proto, l4proto, nfproto keywords.

[ I realize that there is not requirement to be consistent with
datatype names vs. nft rules but I see no reason to differ ]

> Basically the should be human readable, not programmer readable, should
> describe what they actually are (not arphrd) and should be consistent.

Fully agree, more consistency would be good.
