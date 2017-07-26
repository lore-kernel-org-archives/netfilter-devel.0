From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nft_set_rbtree: use seqcount to avoid
 lock in most cases
Date: Wed, 26 Jul 2017 13:04:34 +0200
Message-ID: <20170726110434.GC28392@breakpoint.cc>
References: <20170726000941.29673-1-fw@strlen.de>
 <1501065278.12695.8.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58346 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750925AbdGZLGW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jul 2017 07:06:22 -0400
Content-Disposition: inline
In-Reply-To: <1501065278.12695.8.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Wed, 2017-07-26 at 02:09 +0200, Florian Westphal wrote:
> > switch to lockless lockup. write side now also increments sequence
> > counter.  On lookup, sample counter value and only take the lock
> > if we did not find a match and the counter has changed.
> > 
> > This avoids need to write to private area in normal (lookup) cases.
> > 
> > Note that we take the non-blocking variant (raw_seqcount_begin), i.e.
> > read side will not wait for writer to finish.
> > 
> > If we did not find a result we will fall back to use of read-lock.
> > 
> > The readlock is also used during dumps to ensure we get a consistent
> > tree walk.
> > 
> > Similar technique (rbtree+seqlock) was used by David Howells in rxrpc.
> 
> Please note that in commit b145425f269a17ed344d737f746b844dfac60c82
> ("inetpeer: remove AVL implementation in favor of RB tree")
> 
> I chose to also pass the sequence so that the lookup could abort.
> I am not sure that during rb tree write operations, some nodes could be
> left with some kind of loop.

I see.

Ok, I will spin a v2 and will pass the sequence too, thanks Eric.

If we have to abort on seqretry anyway then I can also use
read_seqcount_begin to force readers to wait until writer is done, so I
will change that as well.
