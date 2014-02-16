From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH nft userspace] nft: connlabel matching support
Date: Sun, 16 Feb 2014 11:33:17 +0000
Message-ID: <20140216113316.GA1104@macbook.localnet>
References: <1392504432-20918-1-git-send-email-fw@strlen.de>
 <20140216085319.GA26751@macbook.localnet>
 <20140216110152.GD28751@breakpoint.cc>
 <20140216111252.GA29491@macbook.localnet>
 <20140216112739.GF28751@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39098 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaBPLdU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 06:33:20 -0500
Content-Disposition: inline
In-Reply-To: <20140216112739.GF28751@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 16, 2014 at 12:27:39PM +0100, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> 
> > > Could probably be fixed by having my own parsing
> > > function instead of reusing the rt_symbol_table one, but I would
> > > need to replace the uint64_t value in the sym table structure
> > > for that [need to be able to store (1<<127)]...
> > 
> > I see. Actually I think we could change the rt_parse_symbol function
> > to generate bitmasks in case of basetype == bitmask_type.
> 
> Ok.  I'll look into this, but, as I said I would have to replace
> uint64_t with mpz_t to get the wider range required.

Not sure if that will even work since those types have dynamic sizes.

If you keep your own functions (which seem to make sense), they should
only parse and print a single value at a time, handling lists and bitmasks
is done by the generic code - at least it should be :)
