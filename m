From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Accessing packet marking functions
Date: Mon, 25 Oct 2010 01:55:19 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010250148460.17324@obet.zrqbmnf.qr>
References: <1276965739.1476.35.camel@andybev>  <alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr>  <1277846567.1561.21.camel@andybev>  <AANLkTimPhd8UTiZiQTTYkMxWOZiFD5jK2iYyzhM9U2d4@mail.gmail.com>  <1277878469.1561.25.camel@andybev>
 <alpine.LSU.2.01.1006300815280.30439@obet.zrqbmnf.qr>  <1277879533.1561.39.camel@andybev>  <alpine.LSU.2.01.1006300844260.2225@obet.zrqbmnf.qr> <1287941423.1550.15.camel@andybev>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Andrew Beverley <andy@andybev.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:60858 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab0JXXzU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 19:55:20 -0400
In-Reply-To: <1287941423.1550.15.camel@andybev>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2010-10-24 19:30, Andrew Beverley wrote:
>> >All I want to do is retain a packet's mark from its arrival into Squid,
>> >onto its transmission to the client. Something like this:
>> >
>> >
>> >ppp0 -> PREROUTING -> Squid -> POSTROUTING -> eth0
>> >
>> >            ^^                      ^^
>> >         Set Mark               Read mark
>> >
>> >If this isn't possible then please tell me.
>> 
>> Hm, interesting case. I would say you could:
>> 
>>  - use CONNMARK in PREROUTING/INPUT
>>  - use libnetfilter_conntrack to query the connmark from within squid
>>    (since squid has address and port, that should identify the 
>>    connection within the nfct table)
>>  - use the so-obtained ctmark to populate the new socket's skmark
>
>Thanks for this suggestion. Thought I'd drop a quick email (for
>completeness) to say that the patch for this has now been included into
>Squid. So, it is now possible for Squid to retain the mark on packets
>for items that aren't cached, or set a mark on packets when items are
>fetched from the cache.

I looked at the change in the squid SCM and...

libnetfilter_conntrack offers .pc files, so squid's configure.ac
should make use of PKG_CHECK_MODULES.
