From: Patrick McHardy <kaber@trash.net>
Subject: Re: Is this nf_conn "use" counter bug???
Date: Mon, 23 Nov 2009 13:05:04 +0100
Message-ID: <4B0A7A70.2020702@trash.net>
References: <7EEFA75B664A4BAFB3D6946823690567@kendo74746f2c0>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kendo <kendo999@sohu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38468 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757354AbZKWME7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Nov 2009 07:04:59 -0500
In-Reply-To: <7EEFA75B664A4BAFB3D6946823690567@kendo74746f2c0>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

kendo wrote:
> ----- Original Message -----=20
> From: "kendo" <kendo999@sohu.com>
> To: "Patrick McHardy" <kaber@trash.net>
> Sent: Monday, November 23, 2009 7:12 PM
> Subject: Re: Is this nf_conn "use" counter bug???
>=20
>=20
>>> This code looks like from the 2.4 era.
>> ----I'm sorry, I copy from 2.6.12,not 2.6.30.9.Because I also opened=
 up them.
>>
>>> Most likely there's an skb leak somewhere and the conntrack referen=
ces
>>> are not released.
>> ----Yes, I think so.But why is that so??kfree_skb function has not b=
een properly invoked when skb leave?

Possibly. You can check the skbuff caches in /proc/slabinfo to see
whether this is the case.

>>>> Environment:
>>>> -----internet--cisco switch (two port bonding)-----linux box(two b=
ridge)----cisco switch(two port bonging)---server
>>>>
>>>> Cisco switch link aggregation=EF=BC=8Cuse two port.Linux box have =
two Independent network bridge.
>>                                           (ge0/1) ---------------(et=
h0) (eth1)------------(ge1/0/1)
>> ---interface-----cisco switch 1                           linux box =
                          cisco switch 2--------servers
>>                                           (ge0/2)----------------(et=
h2) (eth3)------------(ge1/0/1)
>>
>> switch 1:
>> port 0/1 and port 0/2 link aggregation
>>
>> switch 2:
>> port 1/0/1 and port 1/0/2 link aggregation

So you're bridging two ports which are connected to aggregated links?
What is the purpose of doing this?

>> linux config:
>>    eth0, eth1 =3D> bridge0 up, no ip, stp off.
>>    eth2, eth3 =3D> bridge1 up, no ip, stp off.
>>    2.6.30.9
>>    xeon 5420 *8
>>    intel 82575 * 8(version 2.0.6 or linux 2.6.30.9 inside)
>> iptables rule:
>>    no any thing
>>
>> no other config.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
