From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v6 -next 2/4] netfilter: nftables: add connlabel set
 support
Date: Tue, 26 Apr 2016 04:19:39 +0200
Message-ID: <20160426021939.GE17538@breakpoint.cc>
References: <1461249284-12114-1-git-send-email-fw@strlen.de>
 <1461249284-12114-3-git-send-email-fw@strlen.de>
 <20160425103522.GB29560@macbook.localdomain>
 <20160425105909.GC28797@breakpoint.cc>
 <20160425111638.GB30849@macbook.localdomain>
 <20160425115622.GD28797@breakpoint.cc>
 <20160425170541.GC9987@macbook.localdomain>
 <20160425211937.GB17538@breakpoint.cc>
 <20160425213519.GA29318@macbook.localdomain>
 <20160425215412.GC17538@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33885 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbcDZCTl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 22:19:41 -0400
Content-Disposition: inline
In-Reply-To: <20160425215412.GC17538@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > > If not, I see no choice other than resubmitting the original V1 kernel
> > > patch that simply copied the entire sreg into the label area, this way
> > > no userspace changes are needed.
> > 
> > I have to follow up on the previous discussion. Just wondering, what's wrong
> > with simply memcpy'ing and supplying the full set of labels?
> 
> Ok, here is a summary.
> 
> iptables: userspace gives u16 indicating bit, kernel test_bit()s or
> set_bits depending if set or get is wanted.
> 
> The checkentry hook tells the kernel that label extension for X bits should be
> allocated for new conntracks (where X is what userspace gave in the
> match struct).
> 
> 
> nftables:
> get operation simply copies the label area to the sreg.
> Since we only support up to 129 labels at the moment this fits into
> an nft register.
> 
> nft ct label bla
> 
> simply expands to a bit test on the sreg filled from nft_ct expression.
> 
> There is currently no 'please enable labels for new conntracks'.
> 
> First proposal for set operation was to simply expect userspace to
> populate the label space for us and memcpy the sreg to the label area.
> 
> So
> 
> nft label set bla
> 
> will *replace* the entire area with the sreg content, i.e. we delete
> any other label(s) present.
> 
> To only set a label, one has to use
> 
> ct labels set ct labels | bla
> 
> I have no preference; this is the most simple patch/approach since
> it requires no userspace changes (except documenting it).
> 
> Second drawback is that we don't know which label(s) will be set or
> requested so we either have to unconditionally allocate 16 byte
> in the conntrack extension, or, alternatively, raise the 'use this many
> bits when allocating a new conntrack' variable in the packet path (should
> not be a huge deal since after some time all conntracks would have
> sufficient space).
> 
> 3rd drawback is that its not atomic anymore since we replace
> the entire thing (but I don't think this is a problem in practice).

Disregard this.  I think i have a very simple solution for this, by
reusing V1 and passing the sreg also as the mask argument in
nf_connlabels_replace() [ which is the helper to alter labels via
ctnetlink ], i.e.

nf_connlabels_replace(ct, &regs->data[priv->sreg],
			&regs->data[priv->sreg],
			NF_CT_LABELS_MAX_SIZE / sizeof(u32)))

It gives xtables-connlabel like semantics, i.e.

ct label set bla

will only set bla, leaving all other labels alone.
This even matches the 'get' part since 'ct label bla' already uses a '&' op,
not eq.

Only drawback is that nft will ask to allocate enough room for 128
labels (maximum) in the ct extension area as we don't have the individual
highest desired label bit that xtables can use to ask for a lower
number.

I think its not a big deal.  Will test and submit patch in the next few
hours.

Sorry for not thinking of this sooner, I forgot that this mask argument
even existed 8-/
