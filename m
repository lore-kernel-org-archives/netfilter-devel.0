From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] proto: fix VLAN header definition
Date: Mon, 30 Nov 2015 14:53:22 +0100
Message-ID: <20151130135322.GD29878@breakpoint.cc>
References: <20151127095424.GF4263@macbook.localdomain>
 <20151127103428.GC15392@breakpoint.cc>
 <20151127104248.GD15392@breakpoint.cc>
 <20151127104923.GH4263@macbook.localdomain>
 <20151127105417.GE15392@breakpoint.cc>
 <20151128233201.GA3542@salvia>
 <20151129000929.GA15493@breakpoint.cc>
 <20151129220037.GA2301@salvia>
 <20151129223743.GA29878@breakpoint.cc>
 <20151130123143.GA4233@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43498 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754127AbbK3NxZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Nov 2015 08:53:25 -0500
Content-Disposition: inline
In-Reply-To: <20151130123143.GA4233@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Nov 29, 2015 at 11:37:43PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Sun, Nov 29, 2015 at 01:09:29AM +0100, Florian Westphal wrote:
> > > > Thanks for looking at this.  I'll take a closer look tomorrow,
> > > > your patch works fine for ip version/hdrlength but seems it messes
> > > > with endianess somewhere.
> > > 
> > > I forgot to update payload_shift_value() too, to skip the shift when
> > > not needed, sorry, new patch attached.
> > 
> > Almost there. Again, with Patricks patch to fix VLAN header:
> > 
> > # src/nft --debug=netlink add rule bridge raw prerouting ether type vlan vlan type ip vlan id 4094 ip version 4 counter 
> > bridge raw prerouting
> 
> OK, new try, the idea behind is to calculate this shift through:
> 
>         x = offset % BITS_PER_BYTE
>         y = len % BITS_PER_BYTE
> 
> to get both offset and length at byte level.
> 
> Then calculate the shift based on this:
> 
>         shift = BITS_PER_BYTE - (x + y)
> 
> Does this look good to you?

Sorry, that patch doesn't apply for me to master branch,
neither standalone nor on top of your previous patch.
