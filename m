From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH nft userspace] nft: connlabel matching support
Date: Sun, 16 Feb 2014 12:27:39 +0100
Message-ID: <20140216112739.GF28751@breakpoint.cc>
References: <1392504432-20918-1-git-send-email-fw@strlen.de>
 <20140216085319.GA26751@macbook.localnet>
 <20140216110152.GD28751@breakpoint.cc>
 <20140216111252.GA29491@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52753 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169AbaBPL1k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 06:27:40 -0500
Content-Disposition: inline
In-Reply-To: <20140216111252.GA29491@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> > src/nft add rule filter output ct labels == foo --debug=netlink
> > ip filter output 0 0
> > [ ct load labels => reg 1 ]
> > [ cmp eq reg 1 0x00000001 0x00000000 0x00000000 0x00000000 ]
> > 
> > I guess I am doing something wrong in my patch.
> > Let me investigate.  The behaviour you describe seems to be exactly
> > what I want.
> 
> This looks correct, doesn't it? Its an equality comparison of the label.

Argh.  Sorry.  I misunderstood what you were saying :-/
This is not the behaviour that iptables -m connlabel --label foo
would have, since that peforms bit-test.

The equality compare would only match if 'foo' and only 'foo' label
is set.  This is obviously not *wrong*.  It just needs to be understood
that when doing 'ct labels foo' it may not be whats expected.

I think i'll leave it as-is for the time being; I like the register
approach since you can test for multiple labels in one operation
and can even express things like 'match if foo and bar are both set but
baz is not'.

> > > I have to admit that I don't know how connlabels are used, so I don't
> > > know what the best default implicit op would be.
> > 
> > I think it should be a bit-test to make it behave like xt_connlabels
> > match.
> 
> Ok I misunderstood your initial problem statement. So basically what it
> should currently do:
> 
> ct labels foo => test whether that bit is set
> ct labels == foo => test whether foo and only foo is set

Yes :-)

I think it would mimic the connlabel match in itpables better.

> Ok I can see the problem :)
> 
> The implicit op only selects FLAGCMP for EXPR_LIST (see
> expr_evaluate_relational()). That should probably be changed to take the
> base type into account. This also seems wrong for the ct state expression,
> we currently use equality if only one state is specified but use a flag
> comparison if multiple flags are specified.
> 
> If you change the default case to take the basetype into account it should
> do what you want.

Awesome, thanks a lot Patrick.  I'll try it out later today.

> > Could probably be fixed by having my own parsing
> > function instead of reusing the rt_symbol_table one, but I would
> > need to replace the uint64_t value in the sym table structure
> > for that [need to be able to store (1<<127)]...
> 
> I see. Actually I think we could change the rt_parse_symbol function
> to generate bitmasks in case of basetype == bitmask_type.

Ok.  I'll look into this, but, as I said I would have to replace
uint64_t with mpz_t to get the wider range required.

Thanks for your help.
