From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix oob access
Date: Tue, 13 Dec 2016 21:22:25 +0100
Message-ID: <20161213202225.GA11068@breakpoint.cc>
References: <1481633973-11621-1-git-send-email-fw@strlen.de>
 <20161213152904.GA2813@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44580 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753729AbcLMUWi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Dec 2016 15:22:38 -0500
Content-Disposition: inline
In-Reply-To: <20161213152904.GA2813@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Dec 13, 2016 at 01:59:33PM +0100, Florian Westphal wrote:
> > BUG: KASAN: slab-out-of-bounds in nf_tables_rule_destroy+0xf1/0x130 at addr ffff88006a4c35c8
> > Read of size 8 by task nft/1607
> > 
> > When we've destroyed last valid expr, nft_expr_next() returns an invalid expr.
> > We must not dereference it unless it passes != nft_expr_last() check.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  I dislike nft_expr_last() naming, it doesn't return last
> >  valid expression but an invalid address...
> 
> Sure, send a patch for this, or simply update this oneliner in v2,
> your call.  Thanks.

Ok, I will try to come up with a better name and send a patch once
next opens again. (what about rename to nft_expr_end()?)
