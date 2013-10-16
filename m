From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH nft] src: add support for interface wildcard name
Date: Wed, 16 Oct 2013 15:01:54 +0200
Message-ID: <20131016130154.GA10886@localhost>
References: <1381846993-30093-1-git-send-email-fw@strlen.de>
 <20131016103949.GA10032@localhost>
 <20131016110043.GB12157@breakpoint.cc>
 <20131016125839.GA10867@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Anand Raj Manickam <anandrm@gmail.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46289 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934212Ab3JPNCC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:02:02 -0400
Content-Disposition: inline
In-Reply-To: <20131016125839.GA10867@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 16, 2013 at 02:58:39PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 16, 2013 at 01:00:43PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Tue, Oct 15, 2013 at 04:23:13PM +0200, Florian Westphal wrote:
> > > > Uses same syntax as iptables: itfname+.
> > > 
> > > Good you're bringing up this issue, we've been discussing this for a
> > > while with recent Anand's patch.
> > > 
> > > > The '+' suffix is not stored on the kernel side; this approach
> > > > is the same as the one used by iptables-nftables.
> > > 
> > > Hm, it seems current iptables-nftables seems broken by:
> > > 
> > > 73ea1cc nft: convert rule into a command state structure
> > 
> > I tested with latest ipt-nft (42531b3a6) -- admittingly, I did only
> > test xt-save output, which adds '+' postfix in the no-trailing-nul case.
> > 
> > > >  Caveats:
> > > >   - I am not convinced '+' is a good idea -- it is ambiguous since
> > > >   'foo+' is a legal interface name.
> > > 
> > > I think we can remove the '+' in nft, so we match exactly what we
> > > pass for the ifname case, eg. iifname "eth".
> > 
> > Hm.  "iifname eth1": Should it match eth1? Yes. But what about eth10,
> > eth1.42, etc?  I think we need an explicit way to resolve the ambiguity;
> 
> I think "iffname eth1" should mean match "eth1\0".

Oh I see, the ambiguity comes from nft syntax, then we do need some
the wildcard character, yes.

We can add "ifname-mask eth0", thus,

        ifname-mask eth1 means match "eth1", including eth1, eth1.0, etc.
        ifname eth1 means match "eth1\0".
