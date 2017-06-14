From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: using nft & iptables nat in parallel
Date: Wed, 14 Jun 2017 13:29:34 +0200
Message-ID: <20170614112934.GA21546@salvia>
References: <20170614092448.GB10130@breakpoint.cc>
 <CAOkSjBiSrj_V0nJoV8zXmfN-0mDcbfYEuf_knAnp+cHgOa=ePA@mail.gmail.com>
 <20170614095803.GC10130@breakpoint.cc>
 <20170614104008.GA14452@salvia>
 <20170614111934.GA5591@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo@debian.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57986 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751771AbdFNL3n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Jun 2017 07:29:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DF7B52EFEA5
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2017 13:29:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CE70B20511
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2017 13:29:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3EB5D190F
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2017 13:29:30 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170614111934.GA5591@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 14, 2017 at 01:19:34PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Jun 14, 2017 at 11:58:03AM +0200, Florian Westphal wrote:
> > > Arturo Borrero Gonzalez <arturo@debian.org> wrote:
> > > > I'm curious, What is the use case of using both nftables and iptables
> > > > at the same time?
> > > > Some missing functionality in nft?
> > > > Perhaps some ipt->nft partial migration procedure?
> > > 
> > > Yes, partial migration.
> > > 
> > > Right now there are an awful lot of tools out there (docker, libvirt,
> > > kubernetes, ..) that call iptables(-restore) directly (or inject them via
> > > firewalld).
> > > 
> > > And unfortunately I don't see how we can magically move all of this
> > > to nftables.
> > >
> > > So allowing to do a step-by-step migration seems the only viable
> > > option.
> > 
> > We have iptables-compat-restore, this uses the nf_tables netlink
> > frontend and packet classification code, plus x_tables extensions to
> > run iptables code. It should allow us to schedule the x_tables core
> > for removal at some point.
> 
> Yes, perhaps.
> 
> > In Montpellier, we mentioned that distro could add a iptables-restore
> > symlink to iptables-compat-restore so it becomes visible that we're
> > relying on the compat infrastructure.
> > 
> > This iptables-compat-restore interacts with nft via translate layer,
> > so if you just 'nft list ruleset' after using iptables-compat-restore,
> > you will get a translation (if available).
> 
> That still means drastic change, swapping out xt_core for nftables
> rather than using "old" iptables is still a big difference...

Not drastic. The idea is that compat provides same semantics. Did you
give it a try to evaluate the state of this? I would be glad to see
feedback on this. We can probably get some GSoC people helping us
polish this...

> I also think that ability to use both iptables or nftables nat
> is a good thing, since it lowers barrier to 'just try it' without
> having to unload iptable_nat and friends.

Don't get me wrong, I'm not opposing to your idea of get both working
if you want to work on this if you think this is useful.

The extra hook has a performance impact though, is it something that
would just go away one x_tables is gone? What is your plan on this?

On a different front (just an idea), I would really like to provide an
alternative to setting conntrack templates, so we can get rid of
having a chain (hence another hook) just to set the zone. It's just
more cycles on a hook to do something very simple.

> Also forgot to mention: this will allow to use nat base chains
> in multiple tables (even though it is probably not a good idea to do
> that due to possible problems because of unexpected/different evaluation
> order).

nftables NAT configuration needs a closer look indeed, we should
probably autoregister the hook that are needed without having to
require the user to register explicitly an empty chain as the
documentation suggest now.
