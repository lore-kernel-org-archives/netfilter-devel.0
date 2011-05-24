From: Pierre Rondou <prondou@gmail.com>
Subject: Re: icmp_send function broken?
Date: Tue, 24 May 2011 15:42:40 +0200
Message-ID: <4DDBB5D0.6000906@gmail.com>
References: <4DDBAE27.7020502@gmail.com> <1306243605.3026.38.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:56101 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756372Ab1EXNmk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 09:42:40 -0400
In-Reply-To: <1306243605.3026.38.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 24/05/11 15:26, Eric Dumazet a =C3=A9crit :
>> I'm using 2.6.32-5 kernel to developp, but the function itself didn'=
t
>> seem to have been updated in the 2.6.38 kernel.
>>
>>     =20
> You really should use 2.6.39 kernel for your dev...
>   =20

It is a long-term work (started in October 2010), plus I rely on Xtable=
s=20
to develop it, I used a stable kernel, as my module does not involve=20
kernel re-compilation.

>   =20
>> The modification I had to apply is to re-execute the routing process=
 on
>> the incoming paquet in order to get the ICMP packet sent:
>>     =20
>
>
>   =20
>> instead of the simple
>>
>>      if (!rt)
>> //       goto out;
>>
>> Is there an other reason why the rtable of the incoming packet was n=
ot set?
>>     =20
> It is set by caller.
>
> check ip_rcv_finish()
>
> Also please take a look at commit 64f3b9e203bd06855
> net: ip_expire() must revalidate route
>
> [ Since I understand from a prior mail that you maybe queued an skb f=
or
> a while for your defrag purpose ]
>   =20

It is a packet that has just been matched by an iptables rule (my modul=
e=20
is simply branched on a hook), so no queue for it.
So i just should just process the routing before calling the icmp_send(=
)=20
function?

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
