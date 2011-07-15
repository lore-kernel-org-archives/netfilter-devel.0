From: =?windows-1252?Q?Terry_Mo=EBs?= <T.Moes@student.ulg.ac.be>
Subject: Re: NAT66 : A first implementation
Date: Fri, 15 Jul 2011 11:16:43 +0200
Message-ID: <4E20057B.4010302@student.ulg.ac.be>
References: <4E1F0F88.3090704@student.ulg.ac.be> <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr> <4E1F1902.9020605@student.ulg.ac.be> <alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr> <4E20051D.7080208@student.ulg.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:34001 "EHLO
	serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965364Ab1GOJQq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jul 2011 05:16:46 -0400
Received: from unknown (HELO [192.168.1.6]) (s061420@[91.179.116.231])
          (envelope-sender <T.Moes@student.ulg.ac.be>)
          by serv108.segi.ulg.ac.be (qmail-ldap-1.03) with SMTP
          for <netfilter-devel@vger.kernel.org>; 15 Jul 2011 11:16:44 +0200
In-Reply-To: <4E20051D.7080208@student.ulg.ac.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I won't react to anything that has been replied before me about the=20
utility of NAT in general. I obviously agree with those of you that=20
think it's worth a try !


On 15/07/11 01:15, Jan Engelhardt wrote:
> As such, anything revolving around that topic is closely eyed and
> dismantled. (The Linux camp generally being one that likes to DTRT an=
d
> cook their ideas through, at least more than some
> purely-commercially-oriented huts.)
>
I don't like NAT either. But, by definition, RFC means Request for=20
Comments, and I don't know how to make any constructive comment without=
=20
trying to implement it, and see pros and cons...
> As for the thesis paper:
>
> - At times, the document reads like a speech, owing to certain
> linguistic constructs such as enumerations, relatively short sentence=
s
> ("election campaingn" style), and a somewhat abundant use of exclamat=
ion
> marks.
I'm not seeing myself as an English-master, and this is the first real=20
big project I had in English, thus yes, I agree it can be difficult to=20
read. But I don't think we are on this list to criticize my level in=20
English.
>> This feature [NAT] is very common in IPv4 networks today - it made t=
he
>> delay of the X-Day possible - and will surely have its applications =
in
>> IPv6 networks.
> Possible yes, however, delaying of the x-day was surely not one of it=
s
> design goals. As such, the delay seems more like a side-effect at
> first =97 and then when it became apparent that address space runs ou=
t
> "soon", NAT became a constant abuse.
I don't see where I say "Its goal was" in this sentence. A constant=20
abuse, maybe, but an abuse that helped the most people to have an=20
Internet access at home. Some are conservative and will say it is not=20
such a good thing, but I'm not one of them. Some must have said the sam=
e=20
thing when the Television, next the phone have become so popular...

Let's not forget also that, the more people are using internet, the mor=
e=20
servers we need; and the more servers we need, the more IP addresses we=
=20
need; ...; quicker will be be the need of IPv6. And I think, as many=20
others, that it is time for IPv6 to come, not only for the number of=20
available addresses, but for many other reasons !
>
> Side-effect is too soft. Calling NAT a security device comes like
> premeditated deception of end-users.
I insisted enough on the fact that a NAT Device is NOT a security=20
device. And it IS a side-effect; too "soft" is somewhat psychologically=
=20
subjective.
But I didn't think either it was a primary and desired effect, until on=
e=20
member of my jury, who is a recognized and well-known security expert,=20
told me that NAT has two primary interests in today's Internet :=20
Multi-Homing and... Security!

Having said that, I don't think "side-effect" is too soft!
> There is a difference between needed address and available addresses.=
 If
> people did not need so many, they could fit all their hosts in the
> available address space instead - and would not need NAT.
Yes. But these addresses were needed, thus they needed NAT. I don't=20
understand your point here.
> In fact, each IPv6 hosts usually already has more than one address - =
and
> one of them is the fe80::/ link-scope prefix. So they are generally
> already multi-homed once one has added a unicast address to an
> interface.
Yes, and these link-scope addresses are not routable, and if you add a=20
unicast address from the prefix of one ISP, another one will reject thi=
s=20
prefix. Therefore, the utility of NAT66!
>> Fast execution NAT in IPv4 is slowed because the NAT device has to
>> recompute the checksums every time a packet goes through; we want to
>> circumvent this limitation.
> You need to recompute them anyway when doing L7 substitution.
Yes, that's something that remains to be done on the implementation I=20
provided. And my knowledge is that there is very more packets of L7=20
protocols that do not need a L7 substitution, than those that need!
Please, don't read : "there is few L7 protocols that need substitution"=
=20
; I'm talking about the volume of data transferred !
> A 128-bit entity can very well be atomic if the programming language
> implementation decides to make it so. Just because yours does not do =
it
> currently does not mean it will never be.
Yes, but the title of my thesis say "in a Linux kernel", and I'm not=20
thinking that the kernel is compiled in a way that 128 bits are atomic =
!
But you're right on one point : I should have enlightened that by sayin=
g=20
"by the time of this writing, and in the Linux kernel".
>
> This statement seems incorrect. One type's representation may be a tr=
ap
> representation for another type. Again, just because that is not the
> case in contemporary implementations does not mean it is not possible=
=2E
Same as before.
>> routers cannot fragment a packet on their own anymore, and cannot
>> reassemble fragments either.
> While I can agree with this statement, be aware that "routers" runnin=
g
> nf_conntrack will undoubtedly reassemble in all cases, save perhaps f=
or
> packets delievered to raw sockets due to the order of raw-socket
> delivery and nf_defrag.
My knowledge so far is that the reassembling routine in the conntrack=20
(in IPv6) is authorized only in the INPUT chain (Pierre Rondou, who is=20
from same University and has same jury of mine has been confronted to=20
this problem).
And if some modules in the kernel need to reassemble, I'm not, and I ca=
n=20
very well work with packet fragmented.

BTW, if you know a module/a way to reassemble a packet in transit in th=
e=20
kernel, I'm curious to know it !
> nf_conntrack (required by nf_nat) forces reassembly of
> packets exactly because the L4 header is part of the tracking tuple.
In IPv6 also ?
>> int i; // A loop counter
> 	=93A loop counter!? Nobody would have expected _that_!=94
What do you mean ?

If what makes you react is the comment, I will say "a comment not very=20
useful is more than nothing, which is approximately the level of commen=
t=20
in the kernel, and that really is a pain in the ass when you're trying=20
to understand something ; and if I was the reader of this portion of=20
code, such a comment would surely not hinder me".

And if it's the fact that there is a loop counter that makes you react,=
=20
because it's a mistake, explain to me why this is a mistake would=20
certainly be useful !

>> This negotiation happens in a ASCII format data flow and not in a
>> binary format. Therefore, the change of the connection information i=
n
>> the ASCII format may change the length of the packet after the NAT
>> manipulation.
> Note however that binary encodings can also exist as variable-length.=
 So
> binary is not the magic scepter. Think of UTF-8.
What I meant here, is that the length of the IP address may change in=20
ASCII format (2001:db8:1::1 =3D> 2001:db8:1:babe::1) has 5 more charact=
ers=20
in ASCII format. You can have a binary encoding which is=20
variable-length, you will never have the same number of bits in both ca=
ses.

--
Terry Mo=EBs (20061420)
Universit=E9 de Li=E8ge - Facult=E9 des Sciences Appliqu=E9es
2=E8me ann=E9e Master Ing=E9nieur Civil en Informatique - D=E9l=E9gu=E9
Repr=E9sentant Etudiant - Conseil de Facult=E9
=46FSA Administrateur -http://www.ffsa.be
T.Moes@student.ulg.ac.be

--=20

N-HiTec - Nova High Technology Engineering and Consulting

Responsable des Infrastructures - Vice-Pr=E9sident

Web :http://www.nhitec.com
T=E9l :   04/366.20.01

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
