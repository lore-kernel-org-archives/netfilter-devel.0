From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft v3 2/2] datatype: Implement binary search in
 symbolic_constant_print()
Date: Tue, 29 Nov 2016 11:04:18 +0100
Message-ID: <20161129100418.GD11456@breakpoint.cc>
References: <20161128202312.GA8763@lennorien.com>
 <20161128221223.GB9858@breakpoint.cc>
 <20161129083548.GA973@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Elise Lennion <elise.lennion@gmail.com>,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40498 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932162AbcK2KHQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 05:07:16 -0500
Content-Disposition: inline
In-Reply-To: <20161129083548.GA973@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Nov 28, 2016 at 11:12:23PM +0100, Florian Westphal wrote:
> > This is unmaintanable.  I have no clue what value ETH_P_8021Q is, and that
> > this has to be placed at spot #2 to not break things.
> 
> OK, let's try to make this a bit more maintainable, another proposal
> in steps:
> 
> 1) Update symbol_table definition to:
> 
> struct symbol_table {
>         unsignd int                     size;
>         const struct symbolic_constant  *symbols; <---
> };

[..]

> Florian, are you OK if Elise follows this approach? If this is overly
> complicated and not worth, rise your hand.

Is a linear search of ~300-element symtable list a problem?

If it is, then your proposal seems like a sane approach.
But I'd probably benchmark this first.

(Since Elise already did a patch for bsearchable symtable
 it should not be too much work to verify this).
