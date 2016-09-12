From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] nftables: reverse path filtering for nft
Date: Mon, 12 Sep 2016 20:52:28 +0200
Message-ID: <20160912185228.GA10862@salvia>
References: <20160910200102.GA11377@breakpoint.cc>
 <20160912120437.GA9323@salvia>
 <20160912122107.GB27566@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40728 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753128AbcILSwd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 14:52:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4C1041714E0
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 20:52:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39628FB45F
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 20:52:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26DCD114D68
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 20:52:29 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160912122107.GB27566@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 12, 2016 at 02:21:07PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sat, Sep 10, 2016 at 10:01:02PM +0200, Florian Westphal wrote:
> > > Hi.
> > > 
> > > Linux has a builtin rp filter for ipv4, but not for ipv6.
> > > xtables has rpfilter match for both ipv4 and ipv6.
> > > nftables currently does not have such a feature.
> > > 
> > > Any idea on how specific or generic this should be for nft?
> > > 
> > > Current idea is to add 'fib' expression that initially supports
> > > lookup of outinterface index for reply direction, i.e.:
> > > 
> > > nft ... fib reply oif ne 0 accept (found something)
> > 
> > Probably use 'fib lookup' instead of 'fib reply'?
> 
> I was thinking that we might want to support lookup in original
> direction as well at some point, so 'fib original oif' would do
> a route lookup for daddr (fib reply/rpf uses saddr).

Then, I'd suggest:

        fib lookup ip daddr

to look up for the route base on the IPv4 destinarion address.

If you include the interface, you can express this through a
concatenation:

        fib lookup ip daddr . oif

As you are basically looking for the route based on IPv4 address and
the output interface, so this boils down to:

        fib lookup $expr $flags
