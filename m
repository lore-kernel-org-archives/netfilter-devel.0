From: Florian Westphal <fw@strlen.de>
Subject: Re: Starting point in netfilter development
Date: Wed, 2 Jul 2014 22:43:23 +0200
Message-ID: <20140702204323.GA22753@breakpoint.cc>
References: <CAFgy_YLvGwc3y3R3vv0hdTPsQ+yX7eUW8YUppef9xJQsdH9frw@mail.gmail.com>
 <20140630152245.GC9515@breakpoint.cc>
 <CAFgy_YJ8wdPm6P2M_bPVXqbHzJ6oQxWT-3DmfQpikqPma=SDAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Quentin Headen <qheaden@phaseshiftsoftware.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45967 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638AbaGBUnZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:43:25 -0400
Content-Disposition: inline
In-Reply-To: <CAFgy_YJ8wdPm6P2M_bPVXqbHzJ6oQxWT-3DmfQpikqPma=SDAA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Quentin Headen <qheaden@phaseshiftsoftware.com> wrote:
>  Florian Westphal <fw@strlen.de> wrote:
> > nftables is currently under active development; f.e. you could
> > add one of the missing iptables extensions such as hashlimit
> > or nfacct.
> 
> Working on hashlimit for nftables sounds interesting.

Its not very beginner-friendly though.
nfacct *might* be a bit simpler.

Maybe someone else has a better idea.

> > nf.git and nf-next.git from kernel.org. git.netfilter.org
> > mostly hosts the userspace tools like iptables/nftables
> > and the associated libraries.
> 
> So to work on hashlimit functionality for nftables, I'm guessing I
> would need to work with the code found on git.netfilter.org? Would it
> be mostly a userspace coding experience?

Yes, most of the functionality should be in userspace, but it
would need kernel support as well.
