From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH 1/4] [NETFILTER]: ebtables: expand/remove unneeded
	macros
Date: Sun, 20 Jan 2008 19:57:42 +0100
Message-ID: <1200855462.2894.53.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr>
	 <47934659.50303@trash.net>
	 <Pine.LNX.4.64.0801201407280.14598@fbirervta.pbzchgretzou.qr>
	 <479349D3.6050103@trash.net>
	 <1200839199.2868.25.camel@localhost.localdomain>
	 <47935E7A.1000908@trash.net>
	 <Pine.LNX.4.64.0801201815160.14598@fbirervta.pbzchgretzou.qr>
	 <1200852441.2894.30.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801201909160.14598@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from edna.telenet-ops.be ([195.130.132.58]:48744 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbYATS5o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:57:44 -0500
In-Reply-To: <Pine.LNX.4.64.0801201909160.14598@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op zo, 20-01-2008 te 19:30 +0100, schreef Jan Engelhardt:
> On Jan 20 2008 19:07, Bart De Schuymer wrote:
> >Op zo, 20-01-2008 te 18:34 +0100, schreef Jan Engelhardt:
> >> "Ugh." I do not think ebtables(8) should depend on such macros.
> >> iptables(8) does not do that either.
> >> What good would those macros be for? It is not like the module names
> >> would be changing anyway (one purpose of macros - to reduce the number
> >> of places where you have to change things iff things change).
> >
> >We are talking about EBT_ENTRY_ITERATE and the like, right?
> >I didn't see your patch, but even the kernel code uses the ITERATE
> >macros more than once.
> >
> No, just the name macros:

I see, well they are used in the userspace tool. The point is not that
the value can change, the point is that the value is part of the
interface between userspace and kernel and it prevents using "magical
strings" (as in magical numbers): information that a programmer cannot
know by just looking at the header files (the interface). Of course this
is completely academic, but my taste made me make that choice.

> >packet vs Packet, rate vs Packet, ... But this is not worth the
> >bandwidth at all, I should just shut up :)
> 
> I need to pay more attention. I was kinda missing out on "after 
> Ebtables".
> 
> Well, here you go. 

Thanks,
Bart


