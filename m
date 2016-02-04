From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 2/3] meta: add prandom matching
Date: Thu, 4 Feb 2016 17:42:43 +0100
Message-ID: <20160204164243.GB13973@breakpoint.cc>
References: <1454368741-16368-1-git-send-email-fw@strlen.de>
 <1454368741-16368-3-git-send-email-fw@strlen.de>
 <DB5D81F9-A143-4DE6-A315-465B72EA84B3@trash.net>
 <20160204144646.GA25780@breakpoint.cc>
 <20160204152711.GA3853@macbook.localdomain>
 <20160204153240.GB25780@breakpoint.cc>
 <20160204160937.GA13973@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43892 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755199AbcBDQmp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Feb 2016 11:42:45 -0500
Content-Disposition: inline
In-Reply-To: <20160204160937.GA13973@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
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
> 
> Does that seem ok or would you use a different precision?
> (If so, what & why?)

> > What should happen when user asks for meta random 42.23 ?
> 
> That still stands, where would this error be detect best?

I've also been unable to figure out where the u32 scaling has
to be performed, netlink_linearize.c seems to be a very poor place
for this since it would mean special-casing netlink_gen_cmp
to check for OP_LTE and presence of EXPR_META with the meta PRANDOM
key...?

In fact, doing the scaling via precision_type seems to
be a lot simpler as then its applied only in this one case of the
prandom META_TEMPLATE while keeping this detail limited to meta.c.

