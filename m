From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2 iptables] extensions: libxt_connlabel: Add translation
 to nft
Date: Sun, 17 Jul 2016 12:24:49 +0200
Message-ID: <20160717102449.GA1015@salvia>
References: <1468665744-21839-1-git-send-email-zlpnobody@163.com>
 <20160716145130.GA2307@salvia>
 <20160716145505.GA2359@salvia>
 <20160716181251.GC16259@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53202 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbcGQKZC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Jul 2016 06:25:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 50DE7E7DB7
	for <netfilter-devel@vger.kernel.org>; Sun, 17 Jul 2016 12:25:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4166AFAB55
	for <netfilter-devel@vger.kernel.org>; Sun, 17 Jul 2016 12:25:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 21412FAB52
	for <netfilter-devel@vger.kernel.org>; Sun, 17 Jul 2016 12:24:58 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160716181251.GC16259@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 16, 2016 at 08:12:51PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sat, Jul 16, 2016 at 04:51:30PM +0200, Pablo Neira Ayuso wrote:
> > > On Sat, Jul 16, 2016 at 06:42:24PM +0800, Liping Zhang wrote:
> > > >   # iptables-translate -A INPUT -m connlabel ! --label bit40 --set
> > > >   nft add rule ip filter INPUT ct label set bit40 ct label and bit40 != bit40 counter
> > > 
> > > I think this logic is inverted, I mean:
> > > 
> > > nft add rule ip filter INPUT ct label and bit40 != bit40 ct label set bit40 counter
> > >                              ---------------------------
> > > 
> > > test should happen before set.
> > 
> > BTW, why not simply translate this to:
> > 
> >         nft add rule ip filter INPUT ct label set bit40 counter
> 
> Its not the same as the bloated version.
> 
> The set operation will only ever fail in case the conntrack doesn't have a label
>
> extension or is untracked/invalid, but if that is the case we get
> different results:
> 
> nft add rule ip filter INPUT ct label set bit40 ct label and bit40 != bit40 counter
> 
> -> counter Increments for every packet that lacks a conntrack, or the
> conntrack extension
> 
> nft add rule ip filter INPUT ct label set bit40 counter
> 
> -> counter Increments for every packet (we don't set NFT_BREAK anywhere
> in the setter).

set operations are not expected to return anything at all, they must
always evaluate true.

This behaviour is deviating from what we have in other set operations,
this is clearly inconsistent.
