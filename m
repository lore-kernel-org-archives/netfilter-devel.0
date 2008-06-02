From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Fix connlimit bug when receive RST packet in ESTABLISHED
 state
Date: Mon, 2 Jun 2008 14:46:36 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806021428440.4055@fbirervta.pbzchgretzou.qr>
References: <3104bfb60806020422s73c60a29kde8c896e1db901d6@mail.gmail.com> <4843E59C.1030808@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dong Wei <dwei.zh@gmail.com>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42168 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981AbYFBMqi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:46:38 -0400
In-Reply-To: <4843E59C.1030808@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-06-02 14:20, Patrick McHardy wrote:
> Dong Wei wrote:
>> Hi, all
>>   In xt_connlimit match module, the counter of an IP is decreased when
>> the TCP packet is go through the chain with ip_conntrack state TW.
>> Well, it's very natural that the server and client close the socket
>> with FIN packet. But when the client/server close the socket with RST
>> packet(using so_linger), the counter for this connection still exsit.
>> The following patch can fix it which is based on linux-2.6.25.4
>> 
>> diff -ruN a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
>> --- a/net/netfilter/xt_connlimit.c      2008-06-02 18:48:38.000000000 +0800
>> +++ b/net/netfilter/xt_connlimit.c      2008-06-02 18:50:40.000000000 +0800
>> @@ -75,7 +75,8 @@
>>         u_int16_t proto = conn->tuplehash[0].tuple.dst.protonum;
>> 
>>         if (proto == IPPROTO_TCP)
>> -               return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT;
>> +               return (conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT
>> +                       || conn->proto.tcp.state == TCP_CONNTRACK_CLOSE);
>
> Looks fine to me. Jan?

The check for TCP_CONNTRACK_TIME_WAIT was introduced since there is
the 2*MSL delay before the TIME_WAIT->CLOSED transition, and not
counting a connection beginning with TIME_WAIT is common sense/what
people expect.

Though the cleanup delay between TCP_CONNTRACK_CLOSE and (deallocated
state) is much less than 2*MSL, it makes sense to also add this case
per common sense.

Patch is fine, yes, but you do not need the redundant
( ) that were introduced.
