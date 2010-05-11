From: Patrick McHardy <kaber@trash.net>
Subject: Re: Whither xt_SYSRQ?
Date: Tue, 11 May 2010 19:06:08 +0200
Message-ID: <4BE98E80.2000804@trash.net>
References: <4BE96A66.4040607@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Netfilter Core Team <coreteam@netfilter.org>
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43895 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0EKRGJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 May 2010 13:06:09 -0400
In-Reply-To: <4BE96A66.4040607@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

John Haxby wrote:
> 
> The earlier discussions about whether to include xt_SYSRQ in mainline
> seem to have petered out with no clear consensus.  As I recall, there
> were two suggestions as an alternative: use k(g)dboe and use a dedicated
> standalone module.
> 
> The former suggestion, kdboe, doesn't seem to fly because it's not in
> the kernel and also (unless I'm mistaken) provides little or no
> concession to security.  It's great for development but in the case
> where xt_SYSRQ can be used in a production environment, it doesn't seem
> to work.  Providing the environment for the debugger to work in is also
> likely to involve installing a lot on a production machine that wouldn't
> normally be there.  (xt_SYSRQ is nice and light and would sit nicely
> alongside, for example, netconsole.)
> 
> The standalone module is troublesome.  If I was starting from scratch
> with that I'd be putting in filters and whatnot that match those
> provides by xtables anyway.  If everything apart from the actual
> function (sysrq) and password control is duplicated by xtables then
> you'd have to ask "why isn't this part of xtables?".

The main point for putting it in a stand-alone module is that it
is providing a network service. You could still use netfilter to
filter packets of course. I don't see where the big trouble is,
instead of using netfilter for receiving packets, you open up
a socket. That's basically it.

> I know xt_SYSRQ is used by quite a few people and it is seen as
> generally useful, so what needs to be done to get this into the mainline
> kernel?  Once it's there it stands a good chance of being backported to
> some of the production kernels (RHEL6, I'm looking at you) but without
> having some upstream commitment that seems a distant dream.
> 
> if xt_SYSRQ isn't acceptable, what is?  (Bearing in mind that I believe
> that whatever it is needs to be acceptable to a production environment.)

Lets see what other netfilter developers think, I'm easy to convince :)
One thing I'd like to see in any case however is review of the crypto
parts by the crypto people.
