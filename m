From: Patrick McHardy <kaber@trash.net>
Subject: Re: Alignment problem with ebt_among
Date: Wed, 10 Sep 2008 16:43:54 +0200
Message-ID: <48C7DD2A.8000004@trash.net>
References: <alpine.LNX.1.10.0809100931120.24942@fbirervta.pbzchgretzou.qr> <48C7D84A.2010703@trash.net> <alpine.LNX.1.10.0809101027500.24942@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	David Miller <davem@davemloft.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39906 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYIJOoA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:44:00 -0400
In-Reply-To: <alpine.LNX.1.10.0809101027500.24942@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-09-10 10:23, Patrick McHardy wrote:
>>> but this of course breaks the binary interface between userspace and
>>> kernel. Possible solutions I can think of:
>>>
>>>  (a) kill ebt_among
>>>  (b) willingly change it and break ABI
>>>  (c) continue planned transformation to Xtables and fix later
>>>
>>> Which should it be?
>> How about:
>>
>> (d) add compat support to ebtables, transform to xtables,
>>    add compat translation
> 
> That's the same as (c) for me ;-)
> except that the order is slightly different -- I think the patches
> would also be smaller if we went for Xtables first, because its
> structs at least already have the compat members, for example.

Thats true, its easier to do it the other way around since
you don't have to add compat support to ebtables while its
still standalone, just to delete it in following patches
again.

OTOH, 99% of the core compat support is contained in the
*_tables files anyway, so the difference should be very small.
If you take the route I asked you to, namely first making
ebtables and xtables structs and return conventions match
before doing the actual conversion to use the x_tables
infrastructure, you could already use the compat helpers.
This should result in a fully bisectable set of changes.
