From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH V2 iptables] extensions: libxt_connlabel: Add translation
 to nft
Date: Sun, 17 Jul 2016 12:41:59 +0200
Message-ID: <20160717104159.GA21065@breakpoint.cc>
References: <1468665744-21839-1-git-send-email-zlpnobody@163.com>
 <20160716145130.GA2307@salvia>
 <20160716145505.GA2359@salvia>
 <20160716181251.GC16259@breakpoint.cc>
 <20160717102449.GA1015@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Liping Zhang <zlpnobody@163.com>,
	netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49899 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbcGQKm1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Jul 2016 06:42:27 -0400
Content-Disposition: inline
In-Reply-To: <20160717102449.GA1015@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Jul 16, 2016 at 08:12:51PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Sat, Jul 16, 2016 at 04:51:30PM +0200, Pablo Neira Ayuso wrote:
> > > > On Sat, Jul 16, 2016 at 06:42:24PM +0800, Liping Zhang wrote:
> > > > >   # iptables-translate -A INPUT -m connlabel ! --label bit40 --set
> > > > >   nft add rule ip filter INPUT ct label set bit40 ct label and bit40 != bit40 counter
> > > > 
> > > > I think this logic is inverted, I mean:
> > > > 
> > > > nft add rule ip filter INPUT ct label and bit40 != bit40 ct label set bit40 counter
> > > >                              ---------------------------
> > > > 
> > > > test should happen before set.
> > > 
> > > BTW, why not simply translate this to:
> > > 
> > >         nft add rule ip filter INPUT ct label set bit40 counter
> > 
> > Its not the same as the bloated version.
> > 
> > The set operation will only ever fail in case the conntrack doesn't have a label
> >
> > extension or is untracked/invalid, but if that is the case we get
> > different results:
> > 
> > nft add rule ip filter INPUT ct label set bit40 ct label and bit40 != bit40 counter
> > 
> > -> counter Increments for every packet that lacks a conntrack, or the
> > conntrack extension
> > 
> > nft add rule ip filter INPUT ct label set bit40 counter
> > 
> > -> counter Increments for every packet (we don't set NFT_BREAK anywhere
> > in the setter).
> 
> set operations are not expected to return anything at all, they must
> always evaluate true.

Yes.

> This behaviour is deviating from what we have in other set operations,
> this is clearly inconsistent.

How so?
