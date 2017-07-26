From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nft_set_rbtree: use seqcount to
 avoid lock in most cases
Date: Wed, 26 Jul 2017 03:34:38 -0700
Message-ID: <1501065278.12695.8.camel@edumazet-glaptop3.roam.corp.google.com>
References: <20170726000941.29673-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36577 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751540AbdGZKe5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jul 2017 06:34:57 -0400
Received: by mail-wm0-f65.google.com with SMTP id 184so19335051wmo.3
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jul 2017 03:34:57 -0700 (PDT)
In-Reply-To: <20170726000941.29673-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2017-07-26 at 02:09 +0200, Florian Westphal wrote:
> switch to lockless lockup. write side now also increments sequence
> counter.  On lookup, sample counter value and only take the lock
> if we did not find a match and the counter has changed.
> 
> This avoids need to write to private area in normal (lookup) cases.
> 
> Note that we take the non-blocking variant (raw_seqcount_begin), i.e.
> read side will not wait for writer to finish.
> 
> If we did not find a result we will fall back to use of read-lock.
> 
> The readlock is also used during dumps to ensure we get a consistent
> tree walk.
> 
> Similar technique (rbtree+seqlock) was used by David Howells in rxrpc.


Please note that in commit b145425f269a17ed344d737f746b844dfac60c82
("inetpeer: remove AVL implementation in favor of RB tree")

I chose to also pass the sequence so that the lookup could abort.

I am not sure that during rb tree write operations, some nodes could be
left with some kind of loop.



