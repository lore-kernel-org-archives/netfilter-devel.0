From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nfqueue & bridge netfilter considered broken
Date: Tue, 6 Sep 2016 12:10:04 +0200
Message-ID: <20160906101004.GA1874@salvia>
References: <20160902090848.GA506@breakpoint.cc>
 <20160902095853.GA5577@salvia>
 <20160902100021.GA5627@salvia>
 <20160902102244.GB506@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59672 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932799AbcIFKKR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Sep 2016 06:10:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 942F42791A2
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Sep 2016 12:10:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7FA76114D63
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Sep 2016 12:10:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16D36114D74
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Sep 2016 12:10:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160902102244.GB506@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 02, 2016 at 12:22:44PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Sep 02, 2016 at 11:58:53AM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, Sep 02, 2016 at 11:08:48AM +0200, Florian Westphal wrote:
> > > > I - discard extra nfct entry when cloning.  Works, but obviously not
> > > >  compatible in any way (the clones are INVALID).
> > > 
> > > This approach is simple and it would only break when packets are
> > > flooded to all ports, actually this is not working anyway because of
> > > clashes at confirm, right?
> > 
> > Hm, what about attaching the notrack conntrack for this case?
> 
> This is what Patrick said last time this came up (source:
> http://marc.info/?l=netfilter-devel&m=131471329004889&w=2 ):
> 
> "I don't think the clones should have invalid state, even untracked is
> very questionable since all packets should have NAT applied to them in
> the same way, connmarks might be used etc.
> 
> We probably need to restore the above mentioned assumption somehow. One
> way would be to serialize reinjection of packets belonging to
> unconfirmed conntracks in nf_reinject or the queueing modules. Conntrack
> related stuff doesn't really belong there, but it seems like the easiest
> and safest fix to me."
> 
> As for bridge conntrack, this is indeed a good question.
> 
> Seems we will need to register a dedicated conntrack bridge hook that
> takes care of uncloning in FORWARD hook, i.e. add a hook in FORWARD
> that makes a deep copy of all unconfirmed conntracks if skb is cloned,
> and (once skb reaches nf_confirm) do a non-destructive clash resolution
> (accept instead of drop of the clashing entries should be enough).
>
> We have to sacrifice another status bit for this, or perhaps add a
> bridge conntrack extension to store such a clash hint though.

Assuming nf_nat_setup_info() was not yet called, ie. NAT from
postrouting case, then these packets with a deep copy and the flag set
may get different ports given the port clash resolution, then the
clash resolution would need to unmangle packets to get them back to a
consistent configuration.

This is something that can only happen from nfqueue if any of the
multiqueues approach is used to distribute packets between several
CPUs, right?
