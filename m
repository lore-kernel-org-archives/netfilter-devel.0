From: Florian Westphal <fw@strlen.de>
Subject: Re: using nft & iptables nat in parallel
Date: Wed, 14 Jun 2017 13:19:34 +0200
Message-ID: <20170614111934.GA5591@breakpoint.cc>
References: <20170614092448.GB10130@breakpoint.cc>
 <CAOkSjBiSrj_V0nJoV8zXmfN-0mDcbfYEuf_knAnp+cHgOa=ePA@mail.gmail.com>
 <20170614095803.GC10130@breakpoint.cc>
 <20170614104008.GA14452@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53178 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751726AbdFNLUQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Jun 2017 07:20:16 -0400
Content-Disposition: inline
In-Reply-To: <20170614104008.GA14452@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jun 14, 2017 at 11:58:03AM +0200, Florian Westphal wrote:
> > Arturo Borrero Gonzalez <arturo@debian.org> wrote:
> > > I'm curious, What is the use case of using both nftables and iptables
> > > at the same time?
> > > Some missing functionality in nft?
> > > Perhaps some ipt->nft partial migration procedure?
> > 
> > Yes, partial migration.
> > 
> > Right now there are an awful lot of tools out there (docker, libvirt,
> > kubernetes, ..) that call iptables(-restore) directly (or inject them via
> > firewalld).
> > 
> > And unfortunately I don't see how we can magically move all of this
> > to nftables.
> >
> > So allowing to do a step-by-step migration seems the only viable
> > option.
> 
> We have iptables-compat-restore, this uses the nf_tables netlink
> frontend and packet classification code, plus x_tables extensions to
> run iptables code. It should allow us to schedule the x_tables core
> for removal at some point.

Yes, perhaps.

> In Montpellier, we mentioned that distro could add a iptables-restore
> symlink to iptables-compat-restore so it becomes visible that we're
> relying on the compat infrastructure.
> 
> This iptables-compat-restore interacts with nft via translate layer,
> so if you just 'nft list ruleset' after using iptables-compat-restore,
> you will get a translation (if available).

That still means drastic change, swapping out xt_core for nftables
rather than using "old" iptables is still a big difference...

I also think that ability to use both iptables or nftables nat
is a good thing, since it lowers barrier to 'just try it' without
having to unload iptable_nat and friends.

Also forgot to mention: this will allow to use nat base chains
in multiple tables (even though it is probably not a good idea to do
that due to possible problems because of unexpected/different evaluation
order).
