From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] extensions: libxt_statistic: Complete nft
 translator
Date: Wed, 15 Mar 2017 12:01:27 +0100
Message-ID: <20170315110127.GA20691@salvia>
References: <20170313160153.21120-1-phil@nwl.cc>
 <20170313165353.GA32057@salvia>
 <20170314141112.GA17939@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55548 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751195AbdCOLBo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 07:01:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 32995249CE
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 12:01:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 196ABDA86E
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 12:01:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5EEEFDA57D
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 12:01:31 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170314141112.GA17939@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 14, 2017 at 03:11:12PM +0100, Phil Sutter wrote:
> On Mon, Mar 13, 2017 at 05:53:53PM +0100, Pablo Neira Ayuso wrote:
> > On Mon, Mar 13, 2017 at 05:01:53PM +0100, Phil Sutter wrote:
> > [...]
> > > The nftables numgen expression works differently:
> > 
> > Phil, if you think we need a 1:1 mapping so iptables users moving to
> > nftables don't get confused, I'll be fine to take an update to
> > nft_numgen so we accomodate a new NFT_NG_PROBABILISTIC mode or so.
> 
> Well, implementing the translator wasn't exactly trivial, but in general
> I don't think numgen is particularly hard to use. Of course an explicit
> probability mode might make things easier, but then I guess it wouldn't
> fit into the LHS/RHS scheme anymore.

Right, we would need a specific statement for this.

Question is how useful this can be as statement. The usecases I found
for this are:

1) Load balancing, which is already covered by numgen via maps.
2) Simulate packet loss.

With a statement we could combine this probability thing with flow
tables, but still I wonder how useful can be to match packets using
probability at a per-flow level, a.k.a. hashprobability.

Florian already sent a patch to add an alias for this [1], problem is
that this break symmetry between what we add to the kernel and what we
may get, and that is going to break the rule deletion by description.

Just a brain dump on this in case anyone want to spend jiffies on
this.

[1] https://patchwork.ozlabs.org/patch/591534/
