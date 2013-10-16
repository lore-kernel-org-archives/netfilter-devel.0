From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH nft] src: add support for interface wildcard name
Date: Wed, 16 Oct 2013 14:58:39 +0200
Message-ID: <20131016125839.GA10867@localhost>
References: <1381846993-30093-1-git-send-email-fw@strlen.de>
 <20131016103949.GA10032@localhost>
 <20131016110043.GB12157@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Anand Raj Manickam <anandrm@gmail.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45464 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760550Ab3JPM6q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:58:46 -0400
Content-Disposition: inline
In-Reply-To: <20131016110043.GB12157@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 16, 2013 at 01:00:43PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Oct 15, 2013 at 04:23:13PM +0200, Florian Westphal wrote:
> > > Uses same syntax as iptables: itfname+.
> > 
> > Good you're bringing up this issue, we've been discussing this for a
> > while with recent Anand's patch.
> > 
> > > The '+' suffix is not stored on the kernel side; this approach
> > > is the same as the one used by iptables-nftables.
> > 
> > Hm, it seems current iptables-nftables seems broken by:
> > 
> > 73ea1cc nft: convert rule into a command state structure
> 
> I tested with latest ipt-nft (42531b3a6) -- admittingly, I did only
> test xt-save output, which adds '+' postfix in the no-trailing-nul case.
> 
> > >  Caveats:
> > >   - I am not convinced '+' is a good idea -- it is ambiguous since
> > >   'foo+' is a legal interface name.
> > 
> > I think we can remove the '+' in nft, so we match exactly what we
> > pass for the ifname case, eg. iifname "eth".
> 
> Hm.  "iifname eth1": Should it match eth1? Yes. But what about eth10,
> eth1.42, etc?  I think we need an explicit way to resolve the ambiguity;

I think "iffname eth1" should mean match "eth1\0".

> relying on 'if_nametoinfex()' and just using index matching if we find
> an interface is not a good idea, it could fail too often in practice,
> or lead to unexpected results if rules are loaded before interfaces
> are brought up.

Agreed, if_nametoindex is not a good idea as I mentioned in my
previous email.
