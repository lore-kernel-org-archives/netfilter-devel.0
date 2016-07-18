From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH V2 iptables] extensions: libxt_connlabel: Add translation
 to nft
Date: Mon, 18 Jul 2016 23:02:56 +0200
Message-ID: <20160718210256.GC19066@breakpoint.cc>
References: <1468665744-21839-1-git-send-email-zlpnobody@163.com>
 <20160716145130.GA2307@salvia>
 <20160716145505.GA2359@salvia>
 <20160716181251.GC16259@breakpoint.cc>
 <20160717102449.GA1015@salvia>
 <20160717104159.GA21065@breakpoint.cc>
 <20160718201805.GA4432@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Liping Zhang <zlpnobody@163.com>,
	netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51942 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538AbcGRVDP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2016 17:03:15 -0400
Content-Disposition: inline
In-Reply-To: <20160718201805.GA4432@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > How so?
> 
> So this is there just to cover the fail the ENOSPC when setting label?

No label extension present or skb->nfct is untracked.
-m label --label bit40 will never match if the packet has no conntrack
attached.

"-m label --label bit40 --set" will behave the same in that case.

I would really prefer to expose this 1:1 in the translation
because it matches the behaviour.

Users that don't care about success can always just
"ct label set foo".

> This internal behaviour in xt connlabel seems confusing to me, this
> rule:
> 
>         iptables -A INPUT -m connlabel ! --label bit40 --set
> 
> following the reading from left to right convention tells me:
> 
>         if not bit40 set, then set it.

If not set, then *try* to set it:

if (ct == NULL || nf_ct_is_untracked(ct))
 return invert;

if (info->options & XT_CONNLABEL_OP_SET)
  return (nf_connlabel_set(ct, info->bit) == 0) ^ invert;

return connlabel_match(ct, info->bit) ^ invert;

> But this is actually setting in first place inconditionally, then
> checking this is not set, what is the use case for this?

The xt module doesn't have to recheck, if nf_connlabel_set returns 0
then the bit will be set.

> Actually the kernel code first sets the bit, then checks if this is
> unset for this. Note iptables-save displays this in that way as
> output.
> 
> You can probably introduce in iptables something like:
> 
>         iptables -A INPUT -m connlabel --set-label bit40

This is identical to

iptables -A INPUT -m connlabel --label bit40 --set

... unless you meant that this "--set-label bit40" should always return
true even if skb->nfct is NULL, but that seems wrong to me.

It would be more xtables-style to add
-j CONNLABEL --set-bit40

[ i.e. XT_CONTINUE regardless if we could set anything ]

But that doesn't make xtables any better and provides no benefit to
end users.
