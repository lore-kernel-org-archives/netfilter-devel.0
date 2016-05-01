From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: conntrack: avoid integer overflow when
 resizing
Date: Sun, 1 May 2016 21:48:34 +0200
Message-ID: <20160501194834.GA19580@breakpoint.cc>
References: <1461453501-4428-1-git-send-email-fw@strlen.de>
 <20160429095902.GA15406@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45282 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088AbcEATsh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 May 2016 15:48:37 -0400
Content-Disposition: inline
In-Reply-To: <20160429095902.GA15406@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:

[ Sorry for late reply ]

> On Sun, Apr 24, 2016 at 01:18:21AM +0200, Florian Westphal wrote:
> > Can overflow so we might allocate very small table when bucket count is
> > high on a 32bit platform.
> > 
> > Note: resize is only possible from init_netns.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  net/netfilter/nf_conntrack_core.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > index 2bbb962..11daca5 100644
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
> > @@ -1563,8 +1563,15 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
> >  	unsigned int nr_slots, i;
> >  	size_t sz;
> >  
> > +	if (*sizep > (UINT_MAX / sizeof(struct hlist_nulls_head)))
> > +		return NULL;
> 
> *sizep gets initially set to the number of buckets.

Yes.

> >  	BUILD_BUG_ON(sizeof(struct hlist_nulls_head) != sizeof(struct hlist_head));
> >  	nr_slots = *sizep = roundup(*sizep, PAGE_SIZE / sizeof(struct hlist_nulls_head));
> 
> Then, this value is divided by the number of hlist heads that fit into
> a page.

No, its rounded up to a multiple of PAGE/hlist heads, so for very large
values of *sizep nr_slots would be 0.

> > +	if (nr_slots > (UINT_MAX / sizeof(struct hlist_nulls_head)))
> > +		return NULL;

Alternative would be to change this to:

if (nr_slots == 0 || nr_slots > (UINT_MAX / sizeof(struct hlist_nulls_head)))
	return NULL;

Or, add this check:

if (nr_slots < roundup(1, PAGE_SIZE / sizeof(struct hlist_nulls_head))
    nr_slots = roundup(1, PAGE_SIZE / sizeof(struct hlist_nulls_head)))

I wasn't sure if its better to fail or if we should just pretend a sane
value was given.

Let me know what you think and I'll submit a v2.

[ Its not a big deal, but eventually I'd like to make the sysctl
  writeable so users can just increase that, no need to use this obscure
  module parameter/sysfs param ... ]

Cheers,
Florian
