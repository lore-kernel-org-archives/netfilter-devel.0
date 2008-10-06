From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Alignment problem with ebt_among
Date: Sun, 5 Oct 2008 20:57:09 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810052047530.3354@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0809100931120.24942@fbirervta.pbzchgretzou.qr> <48C7D84A.2010703@trash.net> <alpine.LNX.1.10.0809101027500.24942@fbirervta.pbzchgretzou.qr> <48C7DD2A.8000004@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	David Miller <davem@davemloft.net>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46503 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbYJFA5L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 20:57:11 -0400
In-Reply-To: <48C7DD2A.8000004@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-09-10 10:43, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Wednesday 2008-09-10 10:23, Patrick McHardy wrote:
>> > > but this of course breaks the binary interface between userspace and
>> > > kernel. Possible solutions I can think of:
>> > >
>> > >  (a) kill ebt_among
>> > >  (b) willingly change it and break ABI
>> > >  (c) continue planned transformation to Xtables and fix later
>> > >
>> > > Which should it be?
>> > How about:
>> >
>> > (d) add compat support to ebtables, transform to xtables,
>> >    add compat translation

We cannot use compat here, simply because this already happens on a
64-bit userspace with a 64-bit kernel, so compat would never be
invoked. Not to say that compat code is also only available to
architectures that actually support this sort of multiarching.
