From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH] netfilter: add connlabel conntrack extension
Date: Fri, 19 Oct 2012 10:50:07 +0200
Message-ID: <20121019085007.GC18674@breakpoint.cc>
References: <1350577344-16321-1-git-send-email-fw@strlen.de>
 <20121018165104.GA15142@1984>
 <20121018203809.GA18674@breakpoint.cc>
 <20121019081959.GA11880@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50336 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754016Ab2JSIuK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:50:10 -0400
Content-Disposition: inline
In-Reply-To: <20121019081959.GA11880@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Oct 18, 2012 at 10:38:09PM +0200, Florian Westphal wrote:
> [...]
> > The problem i have with this is that 32 unique bits is a bit (pun intended)
> > low.  If its used as enumeration its plentiful but i specifically want
> > to be able to attach 'lots of' different labels to a conntrack entry.
> 
> Ah I see. You want overlapping labels, I like that idea :-)
> 
> What if we provide overlapping and non-overlapping label types,
> something like:
> 
> struct nf_conn_label {
>         uint64_t overlapping:56,
>                  enumerated:8;
> };

I don't like it, because i don't understand the use case.
The main point of the connlabels is so users can avoid having to
play "mask-bit-games" with connmarks.

To illustrate this:
We use connmarks both as enumerator and flag-store:
Upper 8 bits are "enumerated" values, lowest 12 bits
are enumerated too, which makes bits in-between avaialble as
boolean flags.
At the moment, those 12 bits are enough but it looks like that
we'll run out, eventually).

So, in a way the kernel already provides a "enumerated label type": connmark.
And i do not plan on connlabels to supersede connmark; they are
different tools.

Does that make sense, or did i misunderstand what you were saying?

> That provides 56 overlapping labels and 256 non-overlapping labels.
> There will be two configuration files to be used depending on what you
> want. I'm not sure what amount of labels would be fine.

Yes, thats something I also don't know yet.  My guess is that in most
cases it will be unused, or very low (< 32 labels in total).

But I don't want to limit it artificially.

> Thus, we make sure this extension only requires 64-bits (plus the
> extension structure, of course).

I'm thinking about making the label store grow as-needed, so we'd start
with 0 (extension off), and then grow the area once connlabel-rules are
added (we know the largest bit requested, so we don't need to allocate
more than needed).

> My only concern with dynamically allocated purely bit-based labels is
> that users may bloat the size of each conntrack entry.

True, thats a concern.  I chose 32k max label limit because it amounts to
one page (I admit 32k labels is insane, even 1k (128 bytes) is
probably more than enough...).   I'll reduce it.

Thanks,
Florian
