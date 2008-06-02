From: "Dong Wei" <dwei.zh@gmail.com>
Subject: Re: [PATCH] Fix connlimit bug when receive RST packet in ESTABLISHED state
Date: Mon, 2 Jun 2008 21:44:37 +0800
Message-ID: <3104bfb60806020644w656bd8bte56ab8025b7119aa@mail.gmail.com>
References: <3104bfb60806020422s73c60a29kde8c896e1db901d6@mail.gmail.com>
	 <4843E59C.1030808@trash.net>
	 <alpine.LNX.1.10.0806021428440.4055@fbirervta.pbzchgretzou.qr>
	 <4843EF22.9010207@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Jan Engelhardt" <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.185]:9696 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbYFBNoj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:44:39 -0400
Received: by gv-out-0910.google.com with SMTP id e6so117696gvc.37
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Jun 2008 06:44:38 -0700 (PDT)
In-Reply-To: <4843EF22.9010207@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, Jan

  My Signed-off-by message is:

Signed-off-by: Dong Wei <dwei.zh@gmail.com>

Thanks

On Mon, Jun 2, 2008 at 9:01 PM, Patrick McHardy <kaber@trash.net> wrote:
> Jan Engelhardt wrote:
>>
>> On Monday 2008-06-02 14:20, Patrick McHardy wrote:
>>>
>>> Dong Wei wrote:
>>>>
>>>> diff -ruN a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
>>>> --- a/net/netfilter/xt_connlimit.c      2008-06-02 18:48:38.000000000
>>>> +0800
>>>> +++ b/net/netfilter/xt_connlimit.c      2008-06-02 18:50:40.000000000
>>>> +0800
>>>> @@ -75,7 +75,8 @@
>>>>        u_int16_t proto = conn->tuplehash[0].tuple.dst.protonum;
>>>>
>>>>        if (proto == IPPROTO_TCP)
>>>> -               return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT;
>>>> +               return (conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT
>>>> +                       || conn->proto.tcp.state ==
>>>> TCP_CONNTRACK_CLOSE);
>>>
>>> Looks fine to me. Jan?
>>
>> The check for TCP_CONNTRACK_TIME_WAIT was introduced since there is
>> the 2*MSL delay before the TIME_WAIT->CLOSED transition, and not
>> counting a connection beginning with TIME_WAIT is common sense/what
>> people expect.
>
> Yes, though the end-result might not be what people expect.
> The connection can be reopened, exceeding the configured
> limit, and lots of TIME_WAIT/CLOSE connections might linger
> around.
>
>> Though the cleanup delay between TCP_CONNTRACK_CLOSE and (deallocated
>> state) is much less than 2*MSL, it makes sense to also add this case
>> per common sense.
>>
>> Patch is fine, yes, but you do not need the redundant
>> ( ) that were introduced.
>
> I'll remove them when applying the patch.
>
> Dong, I need a Signed-off-by: line from you before I can apply this.
>
