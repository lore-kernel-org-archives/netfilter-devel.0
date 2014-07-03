From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Starting point in netfilter development
Date: Thu, 3 Jul 2014 11:18:59 +0200
Message-ID: <20140703091859.GA4358@localhost>
References: <CAFgy_YLvGwc3y3R3vv0hdTPsQ+yX7eUW8YUppef9xJQsdH9frw@mail.gmail.com>
 <20140630152245.GC9515@breakpoint.cc>
 <CAFgy_YJ8wdPm6P2M_bPVXqbHzJ6oQxWT-3DmfQpikqPma=SDAA@mail.gmail.com>
 <20140702204323.GA22753@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Quentin Headen <qheaden@phaseshiftsoftware.com>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33879 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853AbaGCJTE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:19:04 -0400
Content-Disposition: inline
In-Reply-To: <20140702204323.GA22753@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 02, 2014 at 10:43:23PM +0200, Florian Westphal wrote:
> Quentin Headen <qheaden@phaseshiftsoftware.com> wrote:
> >  Florian Westphal <fw@strlen.de> wrote:
> > > nftables is currently under active development; f.e. you could
> > > add one of the missing iptables extensions such as hashlimit
> > > or nfacct.
> > 
> > Working on hashlimit for nftables sounds interesting.
> 
> Its not very beginner-friendly though.
> nfacct *might* be a bit simpler.

I think this proposal was a good idea, but just to avoid overlap.
Arturo already started some hacking on that.

We're still discussing the integration with the new nftables
transaction infrastructure, the idea is to add native nf_tables
commands to add/delete/dump accounting objects, but that would add
dependencies between nfnetlink_acct and nf_tables, which is something
that should only happen on demand.

> Maybe someone else has a better idea.

Working on userspace seems like a better option for a newbie, I'd
suggest. So I would point to detecting bugs in nft, file them into
netfilter's bugzilla and trying to fix them.
