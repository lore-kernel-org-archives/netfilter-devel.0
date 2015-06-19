From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] src: add tee statement
Date: Fri, 19 Jun 2015 15:37:08 +0200
Message-ID: <20150619133708.GJ22946@acer.localdomain>
References: <1434709594-6460-1-git-send-email-pablo@netfilter.org>
 <20150619125724.GG22946@acer.localdomain>
 <2024102.ynN6JVsV1M@rofl>
 <alpine.LSU.2.20.1506191520530.15886@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <netdev@bof.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56614 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbbFSNhM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 09:37:12 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1506191520530.15886@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19.06, Jan Engelhardt wrote:
> 
> On Friday 2015-06-19 15:17, Patrick Schaaf wrote:
> >On Friday 19 June 2015 14:57:24 Patrick McHardy wrote:
> >>
> >> Is tee a name we want to use for userspace syntax? It's not particulary
> >> descriptive for people who don't know what "tee" is, which I guess are
> >> quite a few.
> >
> >Naming the thing "tee" was a conscious decision when I invented the it as an 
> >option to the ROUTE target back in 2004  - because it is a huge foot gun, and 
> >obscurity seemed appropriate.
> 
> Well, "clone" is the term that should be used if one really wants to
> avoid "tee". But tee is now used for the kernel module and for the
> iptables module, so out of consistency, you want the same in nft.

We are free to use whatever we want in the nft syntax. There's no need
to use the kernel internal names.

> Besides, tee is inspired from /usr/bin/tee and therefore ought to be
> rather well-known already: it's what people are usually learning in
> the same chapter as cat(1) when they make their first steps in Shell.

I'm aware of that, but I don't think it is necessarily well known among
firewall admins. That was my whole point.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
