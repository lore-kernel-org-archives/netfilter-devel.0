From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] nftables: reverse path filtering for nft
Date: Mon, 12 Sep 2016 21:14:38 +0200
Message-ID: <20160912191438.GA11229@salvia>
References: <20160910200102.GA11377@breakpoint.cc>
 <20160912120437.GA9323@salvia>
 <20160912122107.GB27566@breakpoint.cc>
 <20160912185228.GA10862@salvia>
 <20160912190025.GB11685@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47058 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755118AbcILTOp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 15:14:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 825341D94A1
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 21:14:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 66C1329B0F
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 21:14:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 601BFFF2FE
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 21:14:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160912190025.GB11685@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 12, 2016 at 09:00:25PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >         fib lookup ip daddr . oif
> > 
> > As you are basically looking for the route based on IPv4 address and
> > the output interface, so this boils down to:
> > 
> >         fib lookup $expr $flags
> 
> How would the kernel disentangle the register data?

What I'm proposing is to represent this as a concatenation, since this
represents the tuple that you use to look up for route.

> (i.e., how do i know where in the sreg e.g. the daddr is
>  that i need to stuff in the flowi struct?)

You can iterate over the concatenation compound from the
netlink_linearize path, it is just a list of expressions. Then, you
can set the NFTA_FIB_* netlink attribute using them.

>From the evaluation step, you would need to validate that the
expressions that we're using in the concatenation fit into flowi
struct, otherwise tell the user that they are not supported.

We cannot not actually support every tuple, as we are constrained by
flowi.
