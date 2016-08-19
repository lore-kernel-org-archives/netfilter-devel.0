From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 4/6] netfilter: conntrack: add gc worker to
 remove timed-out entries
Date: Fri, 19 Aug 2016 17:22:20 +0200
Message-ID: <20160819152220.GB11049@breakpoint.cc>
References: <1471606575-2197-1-git-send-email-fw@strlen.de>
 <1471606575-2197-5-git-send-email-fw@strlen.de>
 <1471617673.29842.105.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57000 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754014AbcHSPWX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Aug 2016 11:22:23 -0400
Content-Disposition: inline
In-Reply-To: <1471617673.29842.105.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Fri, 2016-08-19 at 13:36 +0200, Florian Westphal wrote:
> > Conntrack gc worker to evict stale entries.
> 
> ...
> 
> > +
> > +		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
> > +			tmp = nf_ct_tuplehash_to_ctrack(h);
> > +
> > +			if (nf_ct_is_expired(tmp)) {
> > +				nf_ct_gc_expired(tmp);
> > +				expired_count++;
> > +				continue;
> 
> Same remark about hlist_nulls_for_each_entry_rcu() not 'safe' here

Hmm, I am missing something, I will wait for your answer on my previous
reply ...

I though this was safe due to rcu -- another cpu could evict entry as
well so we can always see 'free'd objects with refcnt 0.

(nf_ct_gc_expired() skips those to avoid double-free).

> > +		rcu_read_unlock();
> > +		cond_resched();
> 
> This could use cond_resched_rcu_qs() 

Indeed, I did not kown about this, nice!

Will add it in V2, thanks!

