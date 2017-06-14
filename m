From: Florian Westphal <fw@strlen.de>
Subject: Re: using nft & iptables nat in parallel
Date: Wed, 14 Jun 2017 13:53:38 +0200
Message-ID: <20170614115338.GB5591@breakpoint.cc>
References: <20170614092448.GB10130@breakpoint.cc>
 <CAOkSjBiSrj_V0nJoV8zXmfN-0mDcbfYEuf_knAnp+cHgOa=ePA@mail.gmail.com>
 <20170614095803.GC10130@breakpoint.cc>
 <20170614104008.GA14452@salvia>
 <20170614111934.GA5591@breakpoint.cc>
 <20170614112934.GA21546@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53266 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751707AbdFNLyS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Jun 2017 07:54:18 -0400
Content-Disposition: inline
In-Reply-To: <20170614112934.GA21546@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > That still means drastic change, swapping out xt_core for nftables
> > rather than using "old" iptables is still a big difference...
> 
> Not drastic. The idea is that compat provides same semantics. Did you
> give it a try to evaluate the state of this?

Not yet.

> The extra hook has a performance impact though, is it something that
> would just go away one x_tables is gone? What is your plan on this?

Once we do it we can't remove it again, because you can have multiple
nat base chains after this change, and removing hook and merging it back
into the l3 nat code means first chain attaches a null binding again.

> On a different front (just an idea), I would really like to provide an
> alternative to setting conntrack templates, so we can get rid of
> having a chain (hence another hook) just to set the zone. It's just
> more cycles on a hook to do something very simple.

I don't think it can be done, the zone id has to be set before conntrack
lookup, I see no way to avoid this?

So even if we find a way to transport zone id from one hook to the
next (sans skb->nfct template) we still need one extra hook to
configure/set the zone id to use.
