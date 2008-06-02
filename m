From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix connlimit bug when receive RST packet in ESTABLISHED
 state
Date: Mon, 02 Jun 2008 15:01:22 +0200
Message-ID: <4843EF22.9010207@trash.net>
References: <3104bfb60806020422s73c60a29kde8c896e1db901d6@mail.gmail.com> <4843E59C.1030808@trash.net> <alpine.LNX.1.10.0806021428440.4055@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dong Wei <dwei.zh@gmail.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36925 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbYFBNB2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:01:28 -0400
In-Reply-To: <alpine.LNX.1.10.0806021428440.4055@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2008-06-02 14:20, Patrick McHardy wrote:
>> Dong Wei wrote:
>>> diff -ruN a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
>>> --- a/net/netfilter/xt_connlimit.c      2008-06-02 18:48:38.000000000 +0800
>>> +++ b/net/netfilter/xt_connlimit.c      2008-06-02 18:50:40.000000000 +0800
>>> @@ -75,7 +75,8 @@
>>>         u_int16_t proto = conn->tuplehash[0].tuple.dst.protonum;
>>>
>>>         if (proto == IPPROTO_TCP)
>>> -               return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT;
>>> +               return (conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT
>>> +                       || conn->proto.tcp.state == TCP_CONNTRACK_CLOSE);
>> Looks fine to me. Jan?
> 
> The check for TCP_CONNTRACK_TIME_WAIT was introduced since there is
> the 2*MSL delay before the TIME_WAIT->CLOSED transition, and not
> counting a connection beginning with TIME_WAIT is common sense/what
> people expect.

Yes, though the end-result might not be what people expect.
The connection can be reopened, exceeding the configured
limit, and lots of TIME_WAIT/CLOSE connections might linger
around.

> Though the cleanup delay between TCP_CONNTRACK_CLOSE and (deallocated
> state) is much less than 2*MSL, it makes sense to also add this case
> per common sense.
> 
> Patch is fine, yes, but you do not need the redundant
> ( ) that were introduced.

I'll remove them when applying the patch.

Dong, I need a Signed-off-by: line from you before I can apply this.
