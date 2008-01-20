From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH 1/4] [NETFILTER]: ebtables: expand/remove unneeded
	macros
Date: Sun, 20 Jan 2008 19:07:21 +0100
Message-ID: <1200852441.2894.30.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr>
	 <47934659.50303@trash.net>
	 <Pine.LNX.4.64.0801201407280.14598@fbirervta.pbzchgretzou.qr>
	 <479349D3.6050103@trash.net>
	 <1200839199.2868.25.camel@localhost.localdomain>
	 <47935E7A.1000908@trash.net>
	 <Pine.LNX.4.64.0801201815160.14598@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yergi.telenet-ops.be ([195.130.132.36]:44799 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbYATSIG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:08:06 -0500
Received: from monty.telenet-ops.be (unknown [195.130.132.56])
	by yergi.telenet-ops.be (Postfix) with ESMTP id 762ED5C9102
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Jan 2008 19:08:04 +0100 (CET)
In-Reply-To: <Pine.LNX.4.64.0801201815160.14598@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op zo, 20-01-2008 te 18:34 +0100, schreef Jan Engelhardt:
> "Ugh." I do not think ebtables(8) should depend on such macros.
> iptables(8) does not do that either.
> What good would those macros be for? It is not like the module names
> would be changing anyway (one purpose of macros - to reduce the number
> of places where you have to change things iff things change).

We are talking about EBT_ENTRY_ITERATE and the like, right?
I didn't see your patch, but even the kernel code uses the ITERATE
macros more than once.

> >> For the
> >> other patches I have no objection except that the MODULE_DESCRIPTION
> >> isn't consistent with using upper case after 'Ebtables: ', but I guess
> >> that's nitpicking :) Anyway, thanks Jan.
> 
> It is consistent...
> 
> 18:17 ichi:~/Coding/linux_nosov > git log -p
> 4ad299b1644579e5c9aae025bf81f6aff1cbdc77^..4ad299b1644579e5c9aae025bf81f6aff1cbdc77
> | grep MODULE_DESC | grep ^+
> 
> +MODULE_DESCRIPTION("Ebtables: DSAP/SSAP field and SNAP type matching");
> +MODULE_DESCRIPTION("Ebtables: Combined MAC/IP address list matching");
> +MODULE_DESCRIPTION("Ebtables: ARP protocol packet match");
> +MODULE_DESCRIPTION("Ebtables: ARP reply target");
> +MODULE_DESCRIPTION("Ebtables: Destination MAC address translation");
> +MODULE_DESCRIPTION("Ebtables: IPv4 protocol packet match");
> +MODULE_DESCRIPTION("Ebtables: rate-limit match");
> +MODULE_DESCRIPTION("Ebtables: Packet logging to syslog");
> +MODULE_DESCRIPTION("Ebtables: packet mark modification");

packet vs Packet, rate vs Packet, ... But this is not worth the
bandwidth at all, I should just shut up :)

> > But since ebtables, arptables and iptables
> > are pretty similar, perhaps it would be possible to merge ebtables
> > and arptables support with iptables.
> 
> Before you attempt that, try merging ip- with ip6tables first.

And arptables before ebtables :)
For ebtables it's probably best to drop binary compatibility with older
ebtables userspace binaries, it's gonna be a mess if you don't.

cheers,
Bart


