From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_conntrack: don't release a conntrack with
 non-zero refcnt
Date: Thu, 6 Feb 2014 00:00:05 +0100
Message-ID: <20140205230005.GA3806@localhost>
References: <1391465397-3856-1-git-send-email-pablo@netfilter.org>
 <1391474362.28432.112.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, avagin@parallels.com, fw@strlen.de
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47919 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaBEXAN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:00:13 -0500
Content-Disposition: inline
In-Reply-To: <1391474362.28432.112.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 03, 2014 at 04:39:22PM -0800, Eric Dumazet wrote:
> On Mon, 2014-02-03 at 23:09 +0100, Pablo Neira Ayuso wrote:
> > With this patch, the conntrack refcount is initially set to zero and
> > it is bumped once it is added to any of the list, so we fulfill
> > Eric's golden rule which is that all released objects always have a
> > refcount that equals zero.
> > 
> > Andrey Vagin reports that nf_conntrack_free can't be called for a
> > conntrack with non-zero ref-counter, because it can race with
> > nf_conntrack_find_get().
> > 
> > A conntrack slab is created with SLAB_DESTROY_BY_RCU. Non-zero
> > ref-counter says that this conntrack is used. So when we release
> > a conntrack with non-zero counter, we break this assumption.
> ...
> > Cc: Eric Dumazet <eric.dumazet@gmail.com>
> > Cc: Florian Westphal <fw@strlen.de>
> > Cc: Andrew Vagin <avagin@parallels.com>
> > Reported-by: Andrew Vagin <avagin@parallels.com>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> 
> SGTM !
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Applied, thanks everyone!
