From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: nft_nth: match every n packets
Date: Tue, 9 Aug 2016 12:52:53 +0200
Message-ID: <20160809105253.GA11493@salvia>
References: <20160727220053.GA26643@sonyv>
 <20160727230105.GC2565@breakpoint.cc>
 <20160728074252.GA28885@sonyv>
 <20160728092059.GD2565@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laura Garcia <nevola@gmail.com>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57274 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbcHIKxD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2016 06:53:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 87EB7153AA4
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 12:52:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 777AEFF154
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 12:52:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8E78B1B3327
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 12:52:55 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160728092059.GD2565@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 28, 2016 at 11:20:59AM +0200, Florian Westphal wrote:
> Laura Garcia <nevola@gmail.com> wrote:
> > On Thu, Jul 28, 2016 at 01:01:05AM +0200, Florian Westphal wrote:
> > > How exactly is this used by nftables?
> > > 
> > > AFAIU usespace will check if ->dreg is 0 or not, but does that make
> > > sense?
> > > 
> > > Seems to me it would be more straightforward to not use a dreg at all
> > > and just NFT_BREAK if nval != 0?
> > > 
> > 
> > The main idea is to provide a round robin like scheduling method, for
> > example:
> > 
> > ip daddr <ipsaddr> dnat nth 3 map {
> >         0: <ipdaddrA>,
> >         1: <ipdaddrB>,
> >         2: <ipdaddrC>
> > }
> > 
> 
> That makes sense, would be nice to place a small blurb in the commit
> message.

I'd suggest you rename this to nft_numgen.c where numgen stands for
'number generator', then rename 'every' to 'until' (this sets the
upper limit in the generator) and add support for random too, so we
provide incremental and random number generators to start with and we
leave room to extend this with more number generators in the future if
needed.

Florian added random to meta, but I don't see an easy way to reuse
this with maps unless we introduce another modulus/scale expression,
and we should skip oversplitting expressions in way too basic
operations.
