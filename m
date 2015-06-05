From: Florian Westphal <fw@strlen.de>
Subject: Re: Possible bug when bridging traffic we just SNATed and sent to
 another router
Date: Fri, 5 Jun 2015 17:08:27 +0200
Message-ID: <20150605150827.GJ11015@breakpoint.cc>
References: <CAOmdcgX+niENv18DKyn8BVZfwhYXmNcBCBoHVnrsEYWEJTtrhg@mail.gmail.com>
 <20150605143542.GH11015@breakpoint.cc>
 <CAOmdcgVx6=3imz09QNW0eKU8Go=wZDHcWiKC8k2ki__af+rbAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Daniel Collins <daniel.collins@smoothwall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38629 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423408AbbFEPI3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 11:08:29 -0400
Content-Disposition: inline
In-Reply-To: <CAOmdcgVx6=3imz09QNW0eKU8Go=wZDHcWiKC8k2ki__af+rbAQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Daniel Collins <daniel.collins@smoothwall.net> wrote:

please avoid top-posting, thanks.

> +----+   +----+
> | R1 |   | R2 |
> +----+   +----+
>    |       |
> +-------------+
> | eth0   eth1 |
> |   \     /   |
> |    \   /    |
> |     br0     |
> +-------------+
> 
> So, the Linux box at the bottom attempts to route a packet from itself
> using R1, but R1 forwards the packet on to R2, at which point Linux
> creates a new conntrack and rewrites the port number as it passes over
> the bridge since that particular IP/port combination was already in
> use, by the first conntrack.
> 
> Does that make it clearer?

So just to make sure:

#1 Linux send skb from (local_addr,daddr)
#2 r1 forwards packet to r2
#3 Linux receives its own packet again, with (saddr local_addr, daddr)
#4 Linux creates a new conntrack entry since lookup for old one would
expect (local_addr is daddr) reply
#5 new conntrack is created, with PAT applied to resolve port clash
collision
#6 remote_addr sends reply, to local_addr
#7 we lookup conntrack, find the one without PAT translation applied
#8 we possibly toss the packet since PAT undo doesn't (yet) yield
skb with a socket.

I'd recommend to fix this setup... If that can't be done, can you
suppress creation of 2nd conntrack entry?

It should be possible via "-t raw -s local_address -j CT --notrack".
