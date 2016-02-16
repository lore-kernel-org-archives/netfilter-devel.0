From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 2/3] meta: add prandom matching
Date: Tue, 16 Feb 2016 13:00:24 +0100
Message-ID: <20160216120024.GB13417@breakpoint.cc>
References: <1454368741-16368-3-git-send-email-fw@strlen.de>
 <DB5D81F9-A143-4DE6-A315-465B72EA84B3@trash.net>
 <20160204144646.GA25780@breakpoint.cc>
 <20160204152711.GA3853@macbook.localdomain>
 <20160204153240.GB25780@breakpoint.cc>
 <20160204160937.GA13973@breakpoint.cc>
 <20160204164243.GB13973@breakpoint.cc>
 <20160204174029.GB13157@macbook.localdomain>
 <20160215125446.GA23168@breakpoint.cc>
 <20160216114523.GA2502@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39268 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688AbcBPMA1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 07:00:27 -0500
Content-Disposition: inline
In-Reply-To: <20160216114523.GA2502@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Feb 15, 2016 at 01:54:46PM +0100, Florian Westphal wrote:
> > Patrick McHardy <kaber@trash.net> wrote:
> > 
> > Hi Patrick
> > 
> > > On 04.02, Florian Westphal wrote:
> > > > In fact, doing the scaling via precision_type seems to
> > > > be a lot simpler as then its applied only in this one case of the
> > > > prandom META_TEMPLATE while keeping this detail limited to meta.c.
> > > 
> > > Yes, on second thought I agree, sorry. Maybe the work is not lost though,
> > > what does seem to make sense is to use a float basetype and derive your
> > > probability type from that.
> > 
> > I can do this.
> > However, I don't currently see any other type that could be derived from
> > that.  Would you be OK with leaving things as-is and adding a float
> > type later on once a use case presents itself?
> 
> I also think you can add a new TYPE_FLOAT.

Yes, but what I'm asking is: 'What for'?

> Then, from the evaluation step make sure that META_PRANDOM is under
> the valid limits (0, 1].

Thats not so simple.  META_PRANDOM is scaled so its represented
as 1.0 == UINT32_MAX and 0 = 0.

We can't do that for TYPE_FLOAT since it means that it could not
represent values > 1.0 .

Doing the scaling in the eval step is possible but its a bit ugly.

> These TYPE_* will be part of the public API of the high level library
> at some point, they describe the datatype that are used in set
> definitions in the kernel (through the NFTA_SET_DATATYPE netlink
> attribute and the new NFTA_SET_USERDATA through TLVs).

I understand, but,  the proposed float and probability types
are very different, and allow for very little re-use.

For example on printing the probability type has to undo the scaling
so we print 1.0 instead of $bignum.

