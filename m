From: Guillaume Nault <g.nault@alphalink.fr>
Subject: Re: [PATCH nf 0/2] netfilter: nat: do not use rhltable
Date: Mon, 11 Sep 2017 13:47:04 +0200
Message-ID: <20170911114704.fge5tepnxzz2i52r@alphalink.fr>
References: <20170906123952.12555-1-fw@strlen.de>
 <20170908115536.GC13597@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zimbra.alphalink.fr ([217.15.80.77]:33700 "EHLO
        zimbra.alphalink.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751013AbdIKLrI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Sep 2017 07:47:08 -0400
Content-Disposition: inline
In-Reply-To: <20170908115536.GC13597@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 08, 2017 at 01:55:36PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 06, 2017 at 02:39:50PM +0200, Florian Westphal wrote:
> > This reverts the conversion of the nat bysource table to rhlist that
> > I did last year.
> > 
> > It was a bad idea to begin with.
> > 
> > Fast lookup is not essential; in most cases there is no lookup
> > at all because original tuple is not taken and can be used as-is.
> > What needs to be fast is insertion and deletion.
> > 
> > With rhlist, deletion is slow as it requires a list traversal.
> > So, switch back to a statically-sized table for bysource hash.
> 
> Series applied.
> 
We've hit this issue in production on Linux 4.9. Even though that's
just a "performance" fix (as opposed to actual crash), I believe it's
worth queuing it up to -stable (without it we've seen several freezes
of 20 seconds and more).

Patch #1 needs minor editing before applying to 4.9. Not sure if
patch #2 is worth backporting though. What do you think?
