From: Patrick McHardy <kaber@trash.net>
Subject: Re: Is this nf_conn "use" counter bug???
Date: Mon, 23 Nov 2009 13:05:57 +0100
Message-ID: <4B0A7AA5.9010509@trash.net>
References: <7EEFA75B664A4BAFB3D6946823690567@kendo74746f2c0> <4B0A7A70.2020702@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kendo <kendo999@sohu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38498 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121AbZKWMFw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Nov 2009 07:05:52 -0500
In-Reply-To: <4B0A7A70.2020702@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> kendo wrote:
>> ----- Original Message -----=20
>> From: "kendo" <kendo999@sohu.com>
>> To: "Patrick McHardy" <kaber@trash.net>
>> Sent: Monday, November 23, 2009 7:12 PM
>> Subject: Re: Is this nf_conn "use" counter bug???
>>
>>
>>>> This code looks like from the 2.4 era.
>>> ----I'm sorry, I copy from 2.6.12,not 2.6.30.9.Because I also opene=
d up them.
>>>
>>>> Most likely there's an skb leak somewhere and the conntrack refere=
nces
>>>> are not released.
>>> ----Yes, I think so.But why is that so??kfree_skb function has not =
been properly invoked when skb leave?
>=20
> Possibly. You can check the skbuff caches in /proc/slabinfo to see
> whether this is the case.
>=20
>>>>> Environment:
>>>>> -----internet--cisco switch (two port bonding)-----linux box(two =
bridge)----cisco switch(two port bonging)---server
>>>>>
>>>>> Cisco switch link aggregation=EF=BC=8Cuse two port.Linux box have=
 two Independent network bridge.
>>>                                           (ge0/1) ---------------(e=
th0) (eth1)------------(ge1/0/1)
>>> ---interface-----cisco switch 1                           linux box=
                           cisco switch 2--------servers
>>>                                           (ge0/2)----------------(e=
th2) (eth3)------------(ge1/0/1)
>>>
>>> switch 1:
>>> port 0/1 and port 0/2 link aggregation
>>>
>>> switch 2:
>>> port 1/0/1 and port 1/0/2 link aggregation
>=20
> So you're bridging two ports which are connected to aggregated links?
> What is the purpose of doing this?

Ah I see this was a misunderstanding.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
