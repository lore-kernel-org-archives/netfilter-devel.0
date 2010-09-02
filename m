From: Amir Herzberg <amir.herzberg@gmail.com>
Subject: Re: Resolver behind NetFilter NAT service vulnerable to DNS poisoning attack
Date: Thu, 2 Sep 2010 17:06:57 +0200
Message-ID: <AANLkTimoL4yDha_iMKtHRFSaLQcf=xeYp1cF=qySAz_D@mail.gmail.com>
References: <AANLkTikjFnoh_=PX7YDv18O46JhLFnyXQ9-f2CEumqRd@mail.gmail.com>
	<AANLkTikVRqRjzzoRyDQzA0AiO1_kBNYiTwEZ2cLnsxhe@mail.gmail.com>
	<1283436292.2454.790.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Haya Shulman <haya.shulman@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38783 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab0IBPG6 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:06:58 -0400
Received: by vws3 with SMTP id 3so436264vws.19
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Sep 2010 08:06:57 -0700 (PDT)
In-Reply-To: <1283436292.2454.790.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric, thanks. I'm sorry for forgetting to mention this before, but the
attack I referred to was against NAT _using_ port randomization, i.e.
--random option (Netfilter from 2.4).

We did _not_ refer to the known attack against NAT using
port-preserving option (i.e., without port randomization). This attack
is trivial when the DNS is not using port randomization, and we also
show how to do this when the DNS is using port randomization. But the
more challenging attack is when the NAT is using port randomization
(--random). Of course, we also explain how to prevent these attacks.

Cheers, Amir and Haya

On Thu, Sep 2, 2010 at 4:04 PM, Eric Dumazet <eric.dumazet@gmail.com> w=
rote:
> Le jeudi 02 septembre 2010 =E0 15:50 +0200, Amir Herzberg a =E9crit :
>> We investigate some issues related to DNS poisoning, and specificall=
y,
>> an attack that poisons DNS cache, similar to Kaminski's attack, but
>> that works even if the resolver selects random ports, as long as
>> resolver is connected to the Internet via NAT. In particular, we
>> tested the attack for the NetFilter NAT.
>>
>> For obvious reasons, I prefer at this point to share details only wi=
th
>> developers of NAT devices. If you are such developer, please contact
>> me and I can send you the details (paper).
>> Feel also welcome to forward the messages to individuals/forums whic=
h
>> may be relevant (i.e., developers).
>>
>> I apologize for not being able to promise to respond to requests fro=
m
>> people who are just curious (i.e., not NAT developers). Thanks for
>> your understanding.
>> --
>
> Strange, this should be supported since 2007 (port randomization for
> nat)
>
> commit 41f4689a7c8cd76b77864461b3c58fde8f322b2c
> Author: Eric Leblond <eric@inl.fr>
> Date: =A0 Wed Feb 7 15:10:09 2007 -0800
>
> =A0 =A0[NETFILTER]: NAT: optional source port randomization support
>
> =A0 =A0This patch adds support to NAT to randomize source ports.
>
> =A0 =A0Signed-off-by: Eric Leblond <eric@inl.fr>
> =A0 =A0Signed-off-by: Patrick McHardy <kaber@trash.net>
> =A0 =A0Signed-off-by: David S. Miller <davem@davemloft.net>
>
> If using MASQUERADE, its a very easy setup :
>
> iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE --random
>
>
>
>



--=20
Amir Herzberg
Associate Professor, Dept. of Computer Science
Bar Ilan University
http://AmirHerzberg.com
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
