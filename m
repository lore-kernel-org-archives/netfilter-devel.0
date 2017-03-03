From: Phil Sutter <phil@nwl.cc>
Subject: Re: nft: ah expression doesn't work for IPv6
Date: Fri, 3 Mar 2017 15:01:57 +0100
Message-ID: <20170303140157.GB19896@orbyte.nwl.cc>
References: <20170302195651.GX6099@orbyte.nwl.cc>
 <20170302210129.GA19330@salvia>
 <20170302212522.GA8035@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:52019 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751369AbdCCOLm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 09:11:42 -0500
Content-Disposition: inline
In-Reply-To: <20170302212522.GA8035@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 02, 2017 at 10:25:22PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Mar 02, 2017 at 10:01:29PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Mar 02, 2017 at 08:56:52PM +0100, Phil Sutter wrote:
> > > Hi,
> > > 
> > > There is currently an open issue with nft in that ah expression doesn't
> > > work for IPv6 since it creates a payload expression which doesn't find
> > > the AH IPv6 extension header.
> > > 
> > > There has been a discussion about this problem off-list in which two
> > > alternative "solutions" were named, both involve checking the context
> > > to find out whether one is trying to match an IPv4 or IPv6 packet and
> > > then create either payload or exthdr expression. Though this solution is
> > > not optimal, as in (at least) inet table the address family is not given
> > > per se.
> > > 
> > > I had the idea of creating a "real" solution to the problem which
> > > consists of a payload/exthdr hybrid in kernel space searching for the
> > > given header in different locations depending on the family of the
> > > actual package being handled. Ideally this should reuse as much code as
> > > possible, so maybe "just" create both expressions in user space and in
> > > kernel space only branch between the two.
> > 
> > If the problem is the inet chain, I would prefer we request explicit
> > dependencies for ah so we generate the right bytecode depending on the
> > family. Yes, I mean we would need two different rules for each case by
> > now.

Well, in bison there would have to be a common entrance point, which
checks the scope and then generates either payload expr, exthdr expr or
an error depending on what it is. Correct?

> > On top of that, do you have a real usecase having both AH traffic for
> > IPv4 and IPv6 traffic? If you don't I would prefer you just fix what
> > we have and focus on a different task, we have plenty of work to do
> > ahead. We can hand over you more useful tasks.

Not sure if I understand you correctly, but the use-case is matching on
some AH header field in IPv6 traffic? But sure, if you think that's too
exotic I could maybe just add some check somewhere which causes an error
if the family is not specified or not IPv4 and ah expression is being
used.

> Sorry, I didn't mean to sound rude. But I would like to see more
> usecases that would fit into such hybrid. I think we need more
> usecases (not only AH) to justify this extra complexity that this
> hybrid (or probably something else we can come up with) requires.

No problem! Didn't sound rude to me, just inappropriate - it's not up to
you what I'm wasting my time for. :)

Cheers, Phil
