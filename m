From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] iptables: libxt_owner
Date: Sun, 25 Nov 2007 17:02:47 +0100
Message-ID: <47499CA7.4070000@trash.net>
References: <Pine.LNX.4.64.0711250204360.25644@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711250206430.25644@fbirervta.pbzchgretzou.qr> <4749932A.4010902@trash.net> <Pine.LNX.4.64.0711251623160.9477@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62669 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbXKYQDZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 11:03:25 -0500
In-Reply-To: <Pine.LNX.4.64.0711251623160.9477@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 25 2007 16:22, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> +static void owner_mt_help(void)
>>> +{
>>> +	printf(
>>> +"owner match v%s options:\n"
>>> +"[!] --uid-owner userid     Match local UID\n"
>>> +"[!] --gid-owner groupid    Match local GID\n"
>>> +"[!] --socket-exists        Match if socket exists\n"
>>> +"[!] --filp-exists          Match if filp exists\n"
>>> +"\n",
>>> +IPTABLES_VERSION);
>> The filp-exists option strikes me as useless, what would the
>> use case be? For the socket-exists option, I'd prefer for the
>> owner match to simply accept no further option, i.e. "-m owner".
>>
> 
> 
> hasSocket hasFilp whatCouldItBe
> ===============================
>        0       0  forwarded packet
>        1       0  ping, nfs client, nfsd
>        1       1  real connection
> 
> However, you mentioned that encapsulated (socket=1,filp=1) traffic
> will show up without a "socket", but did you actually mean socket
> or filp?

No, I was talking about forwarded encapsulated traffic showing
up in the output chain (we were talking about locally outgoing
packets). These packets have neither.

> I just checked, and xfrm'ed traffic has the same properties as before 
> the transformation.
> 
> So actually socket-exists is the useless one, as there is always a 
> socket in any normal case.
> 
> What do you think?

I think both (together) expose too much of the internals and are
not very useful. There is no guarantee that nfsd will behave the
same way tommorrow. The "socket exists" option is IMO useful for
one single purpose, distinguish packets that originate from
local sockets from packets that are forwarded in the OUTPUT
and POSTROUTING chains in cases where the source address can't
be used, like tunneling. But before it gets too ugly I'd
rather not support it.


