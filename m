From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: NAT66 : A first implementation
Date: Fri, 15 Jul 2011 13:09:01 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1107151229330.11501@frira.zrqbmnf.qr>
References: <4E1F0F88.3090704@student.ulg.ac.be> <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr> <4E1F1902.9020605@student.ulg.ac.be> <alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr> <4E20051D.7080208@student.ulg.ac.be>
 <4E20057B.4010302@student.ulg.ac.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Terry_Mo=C3=ABs?= <T.Moes@student.ulg.ac.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:46390 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1GOLJD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jul 2011 07:09:03 -0400
In-Reply-To: <4E20057B.4010302@student.ulg.ac.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2011-07-15 11:16, Terry Mo=C3=ABs wrote:

>>- At times, the document reads like a speech, owing to certain=20
>>linguistic constructs such as enumerations, relatively short sentence=
s=20
>>("election campaingn" style), and a somewhat abundant use of=20
>>exclamation marks.
>
>I'm not seeing myself as an English-master, and this is the first real=
=20
>big project I had in English, thus yes, I agree it can be difficult to=
=20
>read. But I don't think we are on this list to criticize my level in=20
>English.

Well, it is independent of English - the same atmosphere one can=20
construct with many indoeuropean languages. (=E2=80=9CIPv6 n'est pas un=
=20
illusion, [n'est pas] un r=C3=AAve, [n'est pas] une chim=C3=A8re, [n'es=
t pas] un=20
concept obscur. C'est ici!=E2=80=9D =E2=80=9CIPv6 =C3=A4r inte en illus=
ion, [inte] en dr=C3=B6m,=20
[inte] en chim=C3=A4r, [inte] en m=C3=B6rk koncept. Det =C3=A4r h=C3=A4=
r!=E2=80=9D)

If you have a French copy of the work, I am happy to read it.

>>>This feature [NAT] is very common in IPv4 networks today - it made=20
>>>the delay of the X-Day possible - and will surely have its=20
>>>applications in IPv6 networks.
>>
>>Possible yes, however, delaying of the x-day was surely not one of it=
s=20
>>design goals. As such, the delay seems more like a side-effect at=20
>>first =E2=80=94 and then when it became apparent that address space r=
uns out=20
>>"soon", NAT became a constant abuse.
>
>I don't see where I say "Its goal was" in this sentence.

You don't explicitly, but the subconscious sound is there. (Reads: "NAT=
=20
made the delay possible".)


>maybe, but an abuse that helped the most people to have an Internet=20
>access at home.

NAT is not a prerequisite to Internetworking.


>>In fact, each IPv6 hosts usually already has more than one address -=20
>>and one of them is the fe80::/ link-scope prefix. So they are=20
>>generally already multi-homed once one has added a unicast address to=
=20
>>an interface.
>
>Yes, and these link-scope addresses are not routable,

Routable or not, your host is essentially multi-homed already for a=20
particular group of hosts.


>and if you add a unicast address from the prefix of one ISP, another=20
>one will reject this prefix.

As I reported, this is not the case. At first I too thought this was a=20
bug that one ISP allows packets from another one's address space, but i=
t=20
also seemed like a deliberate goal of IPv6.


>>A 128-bit entity can very well be atomic if the programming language=20
>>implementation decides to make it so. Just because yours does not do=20
>>it currently does not mean it will never be.
>
>Yes, but the title of my thesis say "in a Linux kernel", and I'm not=20
>thinking that the kernel is compiled in a way that 128 bits are atomic=
=20
>! But you're right on one point : I should have enlightened that by=20
>saying "by the time of this writing, and in the Linux kernel".

I meant the programming language implementation (e.g. compiler with a=20
hardware that offers a 128-bit atomic type), not adding atomic barriers=
=20
like spinlocks around IPv6 manipulations in the source code.

Maybe Dave knows whether "long double", which occupies 128 bits on=20
x86_64, is an example of an already-existing atomic type.

(And then there is __m128 too.)


>>>routers cannot fragment a packet on their own anymore, and cannot=20
>>>reassemble fragments either.
>>
>>While I can agree with this statement, be aware that "routers" runnin=
g=20
>>nf_conntrack will undoubtedly reassemble in all cases, save perhaps=20
>>for packets delievered to raw sockets due to the order of raw-socket=20
>>delivery and nf_defrag.
>
>My knowledge so far is that the reassembling routine in the conntrack=20
>(in IPv6) is authorized only in the INPUT chain (Pierre Rondou, who is=
=20
>from same University and has same jury of mine has been confronted to=20
>this problem).

>>nf_conntrack (required by nf_nat) forces reassembly of packets exactl=
y=20
>>because the L4 header is part of the tracking tuple.
>
>In IPv6 also ? And if some modules in the kernel need to reassemble,=20
>I'm not, and I can very well work with packet fragmented.

Look at NF_IP{,6}_PRI_CONNTRACK_DEFRAG. It runs even before raw,=20
otherwise one could not reliably select packets to be -j CT=20
--notrack'ed. Cf.=20
http://www.spinics.net/lists/netfilter-devel/msg11656.html


>>> int i; // A loop counter
>> 	=E2=80=9CA loop counter!? Nobody would have expected _that_!=E2=80=9D
>
>What do you mean ? If what makes you react is the comment, I will say=20
>"a comment not very useful is more than nothing,[...] which is=20
>approximately the level of comment in the kernel, and that really is a=
=20
>pain in the ass when you're trying to understand something ; and if I=20
>was the reader of this portion of code, such a comment would surely no=
t=20
>hinder me".

What code does, one can read from the source. Summaries are ok, like th=
e=20
ones inside xt_find_target. Comments should more often explain why they=
=20
do something - and I agree there is a shortage of those in networking.=20
But // A loop counter would just be noise that does not add=20
documentation value. ("i" is concise, short, and if it were not used fo=
r=20
a loop, temporary or immediately obvious construct, you have a naming=20
issue according to LKCS chapter 4.)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
