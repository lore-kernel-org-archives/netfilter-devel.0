From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2 iptables] extensions: libxt_connlabel: Add translation
 to nft
Date: Mon, 18 Jul 2016 22:18:05 +0200
Message-ID: <20160718201805.GA4432@salvia>
References: <1468665744-21839-1-git-send-email-zlpnobody@163.com>
 <20160716145130.GA2307@salvia>
 <20160716145505.GA2359@salvia>
 <20160716181251.GC16259@breakpoint.cc>
 <20160717102449.GA1015@salvia>
 <20160717104159.GA21065@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60951 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbcGRUSL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2016 16:18:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D70E8168383
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Jul 2016 22:18:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C535D100A47
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Jul 2016 22:18:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9CA04100A46
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Jul 2016 22:18:06 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160717104159.GA21065@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jul 17, 2016 at 12:41:59PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sat, Jul 16, 2016 at 08:12:51PM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > On Sat, Jul 16, 2016 at 04:51:30PM +0200, Pablo Neira Ayuso wrote:
> > > > > On Sat, Jul 16, 2016 at 06:42:24PM +0800, Liping Zhang wrote:
> > > > > >   # iptables-translate -A INPUT -m connlabel ! --label bit40 --set
> > > > > >   nft add rule ip filter INPUT ct label set bit40 ct label and bit40 != bit40 counter
> > > > > 
> > > > > I think this logic is inverted, I mean:
> > > > > 
> > > > > nft add rule ip filter INPUT ct label and bit40 != bit40 ct label set bit40 counter
> > > > >                              ---------------------------
> > > > > 
> > > > > test should happen before set.
> > > > 
> > > > BTW, why not simply translate this to:
> > > > 
> > > >         nft add rule ip filter INPUT ct label set bit40 counter
> > > 
> > > Its not the same as the bloated version.
> > > 
> > > The set operation will only ever fail in case the conntrack doesn't have a label
> > >
> > > extension or is untracked/invalid, but if that is the case we get
> > > different results:
> > >
> > > nft add rule ip filter INPUT ct label set bit40 ct label and bit40 != bit40 counter
> > > 
> > > -> counter Increments for every packet that lacks a conntrack, or the
> > > conntrack extension
> > > 
> > > nft add rule ip filter INPUT ct label set bit40 counter
> > > 
> > > -> counter Increments for every packet (we don't set NFT_BREAK anywhere
> > > in the setter).
>
> > set operations are not expected to return anything at all, they must
> > always evaluate true.
> 
> Yes.
> 
> > This behaviour is deviating from what we have in other set operations,
> > this is clearly inconsistent.
> 
> How so?

So this is there just to cover the fail the ENOSPC when setting label?

This internal behaviour in xt connlabel seems confusing to me, this
rule:

        iptables -A INPUT -m connlabel ! --label bit40 --set

following the reading from left to right convention tells me:

        if not bit40 set, then set it.

But this is actually setting in first place inconditionally, then
checking this is not set, what is the use case for this?

Actually the kernel code first sets the bit, then checks if this is
unset for this. Note iptables-save displays this in that way as
output.

You can probably introduce in iptables something like:

        iptables -A INPUT -m connlabel --set-label bit40

that we can naturally map to nftables for newcomers using this, as
well as less expensive.
