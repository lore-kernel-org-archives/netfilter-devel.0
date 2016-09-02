From: Florian Westphal <fw@strlen.de>
Subject: Re: nfqueue & bridge netfilter considered broken
Date: Fri, 2 Sep 2016 12:22:44 +0200
Message-ID: <20160902102244.GB506@breakpoint.cc>
References: <20160902090848.GA506@breakpoint.cc>
 <20160902095853.GA5577@salvia>
 <20160902100021.GA5627@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49608 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752550AbcIBKWq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Sep 2016 06:22:46 -0400
Content-Disposition: inline
In-Reply-To: <20160902100021.GA5627@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Sep 02, 2016 at 11:58:53AM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Sep 02, 2016 at 11:08:48AM +0200, Florian Westphal wrote:
> > > I - discard extra nfct entry when cloning.  Works, but obviously not
> > >  compatible in any way (the clones are INVALID).
> > 
> > This approach is simple and it would only break when packets are
> > flooded to all ports, actually this is not working anyway because of
> > clashes at confirm, right?
> 
> Hm, what about attaching the notrack conntrack for this case?

This is what Patrick said last time this came up (source:
http://marc.info/?l=netfilter-devel&m=131471329004889&w=2 ):

"I don't think the clones should have invalid state, even untracked is
very questionable since all packets should have NAT applied to them in
the same way, connmarks might be used etc.

We probably need to restore the above mentioned assumption somehow. One
way would be to serialize reinjection of packets belonging to
unconfirmed conntracks in nf_reinject or the queueing modules. Conntrack
related stuff doesn't really belong there, but it seems like the easiest
and safest fix to me."

As for bridge conntrack, this is indeed a good question.

Seems we will need to register a dedicated conntrack bridge hook that
takes care of uncloning in FORWARD hook, i.e. add a hook in FORWARD
that makes a deep copy of all unconfirmed conntracks if skb is cloned,
and (once skb reaches nf_confirm) do a non-destructive clash resolution
(accept instead of drop of the clashing entries should be enough).

We have to sacrifice another status bit for this, or perhaps add a
bridge conntrack extension to store such a clash hint though.

Any other idea?
