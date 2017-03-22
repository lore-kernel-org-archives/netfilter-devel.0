From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] extensions: libxt_statistic: Complete nft
 translator
Date: Wed, 22 Mar 2017 14:27:22 +0100
Message-ID: <20170322132722.GA22167@salvia>
References: <20170313160153.21120-1-phil@nwl.cc>
 <20170313165353.GA32057@salvia>
 <20170314141112.GA17939@orbyte.nwl.cc>
 <20170315110127.GA20691@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59404 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758937AbdCVN1f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 09:27:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DC1ED15AEAF
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 14:27:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B3FC1DA39E
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 14:27:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5CF07DA871
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 14:27:26 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170315110127.GA20691@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 15, 2017 at 12:01:27PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Mar 14, 2017 at 03:11:12PM +0100, Phil Sutter wrote:
> > On Mon, Mar 13, 2017 at 05:53:53PM +0100, Pablo Neira Ayuso wrote:
> > > On Mon, Mar 13, 2017 at 05:01:53PM +0100, Phil Sutter wrote:
> > > [...]
> > > > The nftables numgen expression works differently:
> > > 
> > > Phil, if you think we need a 1:1 mapping so iptables users moving to
> > > nftables don't get confused, I'll be fine to take an update to
> > > nft_numgen so we accomodate a new NFT_NG_PROBABILISTIC mode or so.
> > 
> > Well, implementing the translator wasn't exactly trivial, but in general
> > I don't think numgen is particularly hard to use. Of course an explicit
> > probability mode might make things easier, but then I guess it wouldn't
> > fit into the LHS/RHS scheme anymore.
> 
> Right, we would need a specific statement for this.
> 
> Question is how useful this can be as statement. The usecases I found
> for this are:
> 
> 1) Load balancing, which is already covered by numgen via maps.
> 2) Simulate packet loss.

This packet loss simulation can be useful at ingress in testing
environments, I found people on the Internet using it for this
purpose.

> With a statement we could combine this probability thing with flow
> tables, but still I wonder how useful can be to match packets using
> probability at a per-flow level, a.k.a. hashprobability.
> 
> Florian already sent a patch to add an alias for this [1], problem is
> that this break symmetry between what we add to the kernel and what we
> may get, and that is going to break the rule deletion by description.
> 
> Just a brain dump on this in case anyone want to spend jiffies on
> this.
> 
> [1] https://patchwork.ozlabs.org/patch/591534/

Another idea for this:

I think we can probably map this probability thing to
NFT_META_PRANDOM, which is a bit hopeless these days that we got the
numgen expression. What I'm proposing is to replace the 'meta random'
thing to 'meta probability' by using the patch above Florian made
before v0.8 gets out.

This doesn't allow us though to use probability from the flow table,
so this approach doesn't allow for 'hashprobability' (think of this as
iptables hashlimit, we don't need specific extensions anymore, note
that the flow table thing allow us to provide these composites). If we
want to support this approach, then the single statement, as you
mentioned, is the way to go.
