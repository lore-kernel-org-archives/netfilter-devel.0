From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 2/3] meta: add prandom matching
Date: Thu, 4 Feb 2016 18:38:16 +0100
Message-ID: <20160204173816.GA13157@macbook.localdomain>
References: <1454368741-16368-1-git-send-email-fw@strlen.de>
 <1454368741-16368-3-git-send-email-fw@strlen.de>
 <DB5D81F9-A143-4DE6-A315-465B72EA84B3@trash.net>
 <20160204144646.GA25780@breakpoint.cc>
 <20160204152711.GA3853@macbook.localdomain>
 <20160204153240.GB25780@breakpoint.cc>
 <20160204160937.GA13973@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48791 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbcBDRiT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Feb 2016 12:38:19 -0500
Content-Disposition: inline
In-Reply-To: <20160204160937.GA13973@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.02, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Patrick McHardy <kaber@trash.net> wrote:
> > > > > Any reason why you chose to add this type instead of a generic floating point type?
> > > > 
> > > > I wanted 0.9999 be tranlated to a value close to UINT32_MAX and 0.00001
> > > > to something close to zero so that "meta random 0.999" can be translated to
> > > > something like
> > > > 
> > > > reg1 = prandom_u32()
> > > > reg1 <= 0xffffffee
> > > > 
> > > > I.e. this type cannot represent 5.2 (or whatever).
> > > > 
> > > > Does that answer your question?
> > > 
> > > Not really unless I'm misunderstanding your intention. That part is
> > > related to the kernel internal representation and could be handled
> > > during linearization.
> > 
> > So what would you suggest?
> > Add support for translating double to mpz_t?
> > What precisions would you support?
> 
> So I've started to generalize the proposed precision type
> into type_float which would support 0.000000001 as smallest value.

Sounds good.

> Does that seem ok or would you use a different precision?
> (If so, what & why?)

Seems reasonable for this case as 0.000000000232 is the smallest value
in 32 bit representation.

> Thanks!
> 
> > What should happen when user asks for meta random 42.23 ?
> 
> That still stands, where would this error be detect best?

It would be nice to handle this in expr_evaluate_value() by propagating
the limit from the RHS somehow. Right now we base our limits on the
available bits, we'd also need a numeric limit for this case.

I guess the question is related to how we're going to do the mapping
to 32 bit integers. Define a global mapping that is valid for all floats?
Then the normal bit based range check would work. Not sure if that makes
sense though.

You're way might have been the better one after all.
