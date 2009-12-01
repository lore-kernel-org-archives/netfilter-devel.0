From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Add seperated timeout for the connections that only receive
 packets in one direction
Date: Tue, 1 Dec 2009 10:45:15 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0912011038560.575@blackhole.kfki.hu>
References: <4B0FA3AA.4070702@trash.net> <4B0FBC5F.8030108@trash.net>  <412e6f7f0911292039v74b89b4cieca5e2a043bad43d@mail.gmail.com>  <alpine.DEB.2.00.0912010940390.575@blackhole.kfki.hu> <412e6f7f0912010129l10386c75y5109578caf83147c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:52718 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbZLAJpK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Dec 2009 04:45:10 -0500
In-Reply-To: <412e6f7f0912010129l10386c75y5109578caf83147c@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 1 Dec 2009, Changli Gao wrote:

> On Tue, Dec 1, 2009 at 5:14 PM, Jozsef Kadlecsik
> <kadlec@blackhole.kfki.hu> wrote:
> > On Mon, 30 Nov 2009, Changli Gao wrote:
> >
> >> Think about this topologic:
> >>
> >> Attacker -> router1 -> router2 -> ... -> Linux Router -> Apache.
> >>
> >> the packets in the other direction won't be sent to the Linux Router,
> >> as the other routers will routed them to the other place.
> >
> > Sorry, I don't get it.
> 
> There is a assumption: the final receiver doesn't reply any packet for
> this packet in the invalid state.

Who's assumption? Mine? Yours? For which case did you answer this?

Please describe a complete example, not bits here and there and leaving 
out conditions.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
