From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 1/4] [NETFILTER]: ebtables: expand/remove unneeded macros
Date: Sun, 20 Jan 2008 20:03:24 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801202002190.14598@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr>
 <47934659.50303@trash.net>  <Pine.LNX.4.64.0801201407280.14598@fbirervta.pbzchgretzou.qr>
  <479349D3.6050103@trash.net>  <1200839199.2868.25.camel@localhost.localdomain>
  <47935E7A.1000908@trash.net>  <Pine.LNX.4.64.0801201815160.14598@fbirervta.pbzchgretzou.qr>
  <1200852441.2894.30.camel@localhost.localdomain>
 <Pine.LNX.4.64.0801201909160.14598@fbirervta.pbzchgretzou.qr>
 <1200855462.2894.53.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39071 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbYATTDZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 14:03:25 -0500
In-Reply-To: <1200855462.2894.53.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 20 2008 19:57, Bart De Schuymer wrote:
>
>I see, well they are used in the userspace tool. The point is not that
>the value can change, the point is that the value is part of the
>interface between userspace and kernel and it prevents using "magical
>strings" (as in magical numbers): information that a programmer cannot
>know by just looking at the header files (the interface). Of course this
>is completely academic, but my taste made me make that choice.
>
May I reverse your academic stance with a bunch of patches? :)


>> >packet vs Packet, rate vs Packet, ... But this is not worth the
>> >bandwidth at all, I should just shut up :)
>> 
>> I need to pay more attention. I was kinda missing out on "after 
>> Ebtables".
>> 
>> Well, here you go. 
>
>Thanks,
>Bart

Contains both net/{ipv4/netfilter,ipv6/netfilter,netfilter} and ebtables
bits, so well, just merge.
