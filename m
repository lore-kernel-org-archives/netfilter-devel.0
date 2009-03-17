From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: No chain/target/match by that name
Date: Tue, 17 Mar 2009 11:44:56 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903171143040.19164@fbirervta.pbzchgretzou.qr>
References: <49BF7930.5000808@gmx.net> <alpine.LSU.2.00.0903171120370.15275@fbirervta.pbzchgretzou.qr> <49BF7B71.2080801@gmx.net> <alpine.LSU.2.00.0903171131220.18190@fbirervta.pbzchgretzou.qr> <49BF7D72.7010401@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Vlad <limonad@gmx.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51365 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbZCQKpD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 06:45:03 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 28EDE402874D
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2009 11:45:01 +0100 (CET)
In-Reply-To: <49BF7D72.7010401@gmx.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-03-17 11:37, Vlad wrote:
>>>>      =20
>>>>> Hallo , I'm trying to write a new module for iptables. I started =
with a
>>>>> dummy
>>>>> module. I can successfully compile it. But if I trying to use it,=
 I get an
>>>>> error message:
>>>>>
>>>>> $ iptables -A INPUT -s 128.0.0.1 -m secan --drop -j DROP
>>>>> drop frame
>>>>> iptables: No chain/target/match by that name
>>>>>
>>>>> Can someone tell me what is a problem? Here is my code:
>>>>> [...]
>>>>>          =20
>>>> The iptables code looks fine, but what about the kernel side modul=
e?
>>>>      =20
>>> All other iptables modules work fine. I'm pretty new to iptables, c=
an you
>>> please tell me what kernel side module do you mean?
>>>   =20
>> Well, xt_secan.c that you (hopefully) wrote that does implement the =
actual
>> packet inspection.
>>
>> =20
> I saved my module as libipt_secan.c in derictory iptables/extensions.=
 Where
> should be xt_secan.c saved?

[ Do not strip CCs! ]

Ehrm, whereever it is convenient.

Since you seem to be not familiar with the matter, I suggest having a
read in the =E2=80=9CWriting Netfilter modules=E2=80=9D e-book, availab=
le on
http://jengelh.medozas.de/ .

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
