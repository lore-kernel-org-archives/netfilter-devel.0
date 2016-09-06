From: Florian Westphal <fw@strlen.de>
Subject: Re: nfqueue & bridge netfilter considered broken
Date: Tue, 6 Sep 2016 13:24:32 +0200
Message-ID: <20160906112432.GA20188@breakpoint.cc>
References: <20160902090848.GA506@breakpoint.cc>
 <20160902095853.GA5577@salvia>
 <20160902100021.GA5627@salvia>
 <20160902102244.GB506@breakpoint.cc>
 <20160906101004.GA1874@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33026 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753996AbcIFLYf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Sep 2016 07:24:35 -0400
Content-Disposition: inline
In-Reply-To: <20160906101004.GA1874@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Sep 02, 2016 at 12:22:44PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Fri, Sep 02, 2016 at 11:58:53AM +0200, Pablo Neira Ayuso wrote:
> > > > On Fri, Sep 02, 2016 at 11:08:48AM +0200, Florian Westphal wrote:
> > > > > I - discard extra nfct entry when cloning.  Works, but obviously not
> > > > >  compatible in any way (the clones are INVALID).
> > > > 
> > > > This approach is simple and it would only break when packets are
> > > > flooded to all ports, actually this is not working anyway because of
> > > > clashes at confirm, right?
> > > 
> > > Hm, what about attaching the notrack conntrack for this case?
> > 
> > This is what Patrick said last time this came up (source:
> > http://marc.info/?l=netfilter-devel&m=131471329004889&w=2 ):
> > 
> > "I don't think the clones should have invalid state, even untracked is
> > very questionable since all packets should have NAT applied to them in
> > the same way, connmarks might be used etc.

> > way would be to serialize reinjection of packets belonging to
> > unconfirmed conntracks in nf_reinject or the queueing modules. Conntrack
> > related stuff doesn't really belong there, but it seems like the easiest
> > and safest fix to me."
> > 
> > As for bridge conntrack, this is indeed a good question.
> > 
> > Seems we will need to register a dedicated conntrack bridge hook that
> > takes care of uncloning in FORWARD hook, i.e. add a hook in FORWARD
> > that makes a deep copy of all unconfirmed conntracks if skb is cloned,
> > and (once skb reaches nf_confirm) do a non-destructive clash resolution
> > (accept instead of drop of the clashing entries should be enough).
> >
> > We have to sacrifice another status bit for this, or perhaps add a
> > bridge conntrack extension to store such a clash hint though.
> 
> Assuming nf_nat_setup_info() was not yet called, ie. NAT from
> postrouting case, then these packets with a deep copy and the flag set
> may get different ports given the port clash resolution, then the
> clash resolution would need to unmangle packets to get them back to a
> consistent configuration.

Right -- one of the reasons why I did not plan on adding NAT hooks
for NFPROTO_BRIDGE ...

> This is something that can only happen from nfqueue if any of the
> multiqueues approach is used to distribute packets between several
> CPUs, right?

I think we also might have a race with local delivery/upcall vs.
flood forwarding, local_rcv path in bridge uses netif_receive_skb so skb
might be queued on percpu backlog. (the race is much more prominent
with per-cpu nfqueueing though and I don't recall seeing such race
related crashes without nfqueue presence).
