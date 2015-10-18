From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] src: add interface wildcard matching
Date: Sun, 18 Oct 2015 22:18:49 +0200
Message-ID: <20151018201849.GC4386@breakpoint.cc>
References: <1445191336-2041-1-git-send-email-pablo@netfilter.org>
 <20151018183313.GA4386@breakpoint.cc>
 <20151018201427.GA9765@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:32989 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749AbbJRUSw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Oct 2015 16:18:52 -0400
Content-Disposition: inline
In-Reply-To: <20151018201427.GA9765@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Oct 18, 2015 at 08:33:13PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Contrary to iptables, we use '*' as wildcard as in udev since the '+' can be
> > > used as a valid interface name.
> > 
> > '*' can also be part of an interface name, seems only '/', ':', and ' '
> > (space) are disallowed.
> 
> We can allow escaping the asterisk:
> 
> # nft --debug=netlink add rule test test iifname eth\\*
>   ip test test 
>     [ meta load iifname => reg 1 ]
>     [ cmp eq reg 1 0x5c687465 0x0000002a 0x00000000 0x00000000 ]
> 
> This means, exact matching for those outthere using wildcards in
> device name, see patch attached.

Right, nice.  I agree that * is a better choice than +.

> This applies on top of this initial patch.

After re-reading Patricks suggestion I'm withdrawing my question wrt.
binop-and.  Patch looks good to me, thanks Pablo!
