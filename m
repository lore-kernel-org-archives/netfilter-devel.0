From: Florian Westphal <fw@strlen.de>
Subject: Re: Easy way to set NOTRACK for INPUT, FORWARD and OUTPUT
 independently
Date: Sat, 17 Dec 2016 13:29:22 +0100
Message-ID: <20161217122922.GC13094@breakpoint.cc>
References: <83039186e8c81a62f20e605de41ccba3@spoje.net>
 <c84a9319f8b1f2bb0554d5a4a942e3b1@spoje.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: mudrunka@spoje.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57844 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753624AbcLQM3m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Dec 2016 07:29:42 -0500
Content-Disposition: inline
In-Reply-To: <c84a9319f8b1f2bb0554d5a4a942e3b1@spoje.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

mudrunka@spoje.net <mudrunka@spoje.net> wrote:
> >It would be super useful if one can simply use "-j CT --notrack" in
> >INPUT and FORWARD. (it already works in OUTPUT)
> >
> >If it's impossible to postpone conntrack after routing decision, it
> >might be possible to add some macro that would match any of local
> >adresses that are currently on any of interfaces. like "--src local"
> >or "--dst local".

conntrack hook is in PREROUTING so by time INPUT/FORWARD hooks are
invokes conntrack already picked the packet up.

> >with all these adresses parsed from "ip a s". But that's far from
> >being elegant or reliable.

I suggest to use the addrtype match for this:
addrtype --dst-type LOCAL should do what you want.

> >I am planning to switch over to nftables, so it might be another
> >solution...
> >Is this planned to be fixed in nftables? If not can you please
> >consider fixing it?

The fib expression can be used in nft. ("fib daddr type local").
