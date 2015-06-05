From: Daniel Collins <daniel.collins@smoothwall.net>
Subject: Re: Possible bug when bridging traffic we just SNATed and sent to
 another router
Date: Fri, 5 Jun 2015 16:27:02 +0100
Message-ID: <CAOmdcgVbFZ=DskdrYjx5-pb9KdmqnEtf-mXou7k2c8PUue6xPg@mail.gmail.com>
References: <CAOmdcgX+niENv18DKyn8BVZfwhYXmNcBCBoHVnrsEYWEJTtrhg@mail.gmail.com>
	<20150605143542.GH11015@breakpoint.cc>
	<CAOmdcgVx6=3imz09QNW0eKU8Go=wZDHcWiKC8k2ki__af+rbAQ@mail.gmail.com>
	<20150605150827.GJ11015@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from exprod7og115.obsmtp.com ([64.18.2.217]:43888 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751692AbbFEP1F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 11:27:05 -0400
Received: by wgbgq6 with SMTP id gq6so59576047wgb.3
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jun 2015 08:27:03 -0700 (PDT)
In-Reply-To: <20150605150827.GJ11015@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 5 June 2015 at 16:08, Florian Westphal <fw@strlen.de> wrote:

> So just to make sure:
>
> #1 Linux send skb from (local_addr,daddr)
> #2 r1 forwards packet to r2
> #3 Linux receives its own packet again, with (saddr local_addr, daddr)
> #4 Linux creates a new conntrack entry since lookup for old one would
> expect (local_addr is daddr) reply
> #5 new conntrack is created, with PAT applied to resolve port clash
> collision
> #6 remote_addr sends reply, to local_addr
> #7 we lookup conntrack, find the one without PAT translation applied
> #8 we possibly toss the packet since PAT undo doesn't (yet) yield
> skb with a socket.

Yes

> I'd recommend to fix this setup... If that can't be done, can you
> suppress creation of 2nd conntrack entry?

This configuration has been used by a small handful of our customers,
we are probably going to get them to fix their routing tables.

> It should be possible via "-t raw -s local_address -j CT --notrack".

Considered this, but doesn't work for us in all cases (tproxy!).

Thanks

-- 
Daniel Collins
Software Developer

smoothwall
daniel.collins@smoothwall.com
www.smoothwall.com

Head Office : 1 John Charles Way, Leeds, LS12 6QA, United Kingdom
Tech Office : Eagle Point, Little Park Farm Road, Fareham, PO15 5TD,
United Kingdom
US Office : 8008 Corporate Center Dr #410, Charlotte, NC 28226, United States

Telephone: UK: +44 870-199-9500 US: +1 800-959-3760

Smoothwall Limited is registered in England, Company Number: 4298247
and whose registered address is 1 John Charles Way, Leeds, LS12 6QA
United Kingdom.
