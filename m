From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 2/2] netfilter: conntrack: remove timer from ecache
 extension
Date: Tue, 10 Jun 2014 17:36:47 +0200
Message-ID: <20140610153647.GC1970@breakpoint.cc>
References: <1400751788-7923-1-git-send-email-fw@strlen.de>
 <1400751788-7923-3-git-send-email-fw@strlen.de>
 <20140605142549.GA24216@localhost>
 <20140605145640.GC23367@breakpoint.cc>
 <20140610145717.GA12398@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49883 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339AbaFJPgt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:36:49 -0400
Content-Disposition: inline
In-Reply-To: <20140610145717.GA12398@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I already told you, your patchset works in my testbed here.
> 
> My only doubt still here is the need for the extra bit. I don't find
> the scenario that will trigger the problem yet. Some comments:

Its not obvious but you should be able to produce crashes in your
tests when you only look for dying-bit-not-set, however...

> > OR it can mean
> > 
> > b) 'This conntrack is being allocated/setup as new connection, the
> > flag field was already cleared'.
> 
> In this case, the conntrack is placed in the unconfirmed list or the
> hashes.

Not necessarily.
conntracks are placed on the dying list, when refcnt reaches zero
they're deleted from the dying list.  But we could have picked it up
right before.

I *think* you're right in that we could avoid the extra bit if we hold
the dying list spinlock.  Then, if we pick it up before removal, dying
bit is always set since no recycling can happen underneath.

> either a) release the entry whose event was already delivered or b)
> decrement the use counter.
> 
> > I've found no way to tell these two conditions apart except via new bit.
> 
> I believe the rule: "all dead conntracks have the dying bit set"
> always fulfills.

Looking at it again I think I need to rework the patch to use the appropriate
lock during traversal instead of rcu, as the dying list manipulation
routines don't use the _rcu versions for hlist manipulation anyway...

I'll send a v3 soon, after doing short sanity test.

Since 3.15 has been released already we should simply aim this patch for
3.17. No harm done.

Thanks for reviewing and testing!
