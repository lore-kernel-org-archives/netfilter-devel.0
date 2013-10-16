From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH nft] src: add support for interface wildcard name
Date: Wed, 16 Oct 2013 13:00:43 +0200
Message-ID: <20131016110043.GB12157@breakpoint.cc>
References: <1381846993-30093-1-git-send-email-fw@strlen.de>
 <20131016103949.GA10032@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Anand Raj Manickam <anandrm@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45747 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760726Ab3JPLAq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:00:46 -0400
Content-Disposition: inline
In-Reply-To: <20131016103949.GA10032@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Oct 15, 2013 at 04:23:13PM +0200, Florian Westphal wrote:
> > Uses same syntax as iptables: itfname+.
> 
> Good you're bringing up this issue, we've been discussing this for a
> while with recent Anand's patch.
> 
> > The '+' suffix is not stored on the kernel side; this approach
> > is the same as the one used by iptables-nftables.
> 
> Hm, it seems current iptables-nftables seems broken by:
> 
> 73ea1cc nft: convert rule into a command state structure

I tested with latest ipt-nft (42531b3a6) -- admittingly, I did only
test xt-save output, which adds '+' postfix in the no-trailing-nul case.

> >  Caveats:
> >   - I am not convinced '+' is a good idea -- it is ambiguous since
> >   'foo+' is a legal interface name.
> 
> I think we can remove the '+' in nft, so we match exactly what we
> pass for the ifname case, eg. iifname "eth".

Hm.  "iifname eth1": Should it match eth1? Yes. But what about eth10,
eth1.42, etc?  I think we need an explicit way to resolve the ambiguity;
relying on 'if_nametoinfex()' and just using index matching if we find
an interface is not a good idea, it could fail too often in practice,
or lead to unexpected results if rules are loaded before interfaces
are brought up.

> >   - removes a FIXME in netlink_delinearize.  What was that about? :-}
> 
> I don't remember the reason for that case, please try to dig it out
> from the history. Thanks!

// FIXME
if (left->len && left->dtype && left->dtype->type != TYPE_STRING

... is from Patricks initial commit.  Lets see if Patrick remembers :)
