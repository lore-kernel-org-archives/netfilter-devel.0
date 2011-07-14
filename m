From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: NAT66 : A first implementation
Date: Fri, 15 Jul 2011 01:15:47 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr>
References: <4E1F0F88.3090704@student.ulg.ac.be> <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr> <4E1F1902.9020605@student.ulg.ac.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?Terry_Mo=C3=ABs?= <T.Moes@student.ulg.ac.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:43488 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576Ab1GNXPu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jul 2011 19:15:50 -0400
In-Reply-To: <4E1F1902.9020605@student.ulg.ac.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2011-07-14 18:27, Terry Mo=C3=ABs wrote:

>>>Hi all !
>>>
>>>Since the Draft of NPT66 (Stateless Mapping) has gone RFC=20
>>>(http://tools.ietf.org/html/rfc6296), it's the good time for me to=20
>>>publish my master thesis : an implementation, for Netfilter, of NAT=20
>>>in IPv6, with both Stateless and Stateful approaches.
>>>
>>>It's published on Sourceforge :=20
>>>https://sourceforge.net/projects/nfnat66/
>>
>>Hm, how often has this been (re)implemented now... the last one was=20
>>sf.net/projects/map66
>
>If you are willing to compare this implementation, which just add two=20
>targets to Xtables, with mine, which involves the Connection Tracking,=
=20
>and is able to deal with icmp error messages, AND implements stateful,=
=20
>n:1 mapping

Of course yours is feature-richer. But the topic of IPv6 NAT has had=20
come up a number of unrecollectable times, and the response has been th=
e=20
same everytime - NAT is still an ugly undesired hack whose recurrence=20
wants to be avoided.

As such, anything revolving around that topic is closely eyed and=20
dismantled. (The Linux camp generally being one that likes to DTRT and=20
cook their ideas through, at least more than some=20
purely-commercially-oriented huts.)


As for the thesis paper:

- At times, the document reads like a speech, owing to certain=20
linguistic constructs such as enumerations, relatively short sentences=20
("election campaingn" style), and a somewhat abundant use of exclamatio=
n=20
marks.


>This feature [NAT] is very common in IPv4 networks today - it made the=
=20
>delay of the X-Day possible - and will surely have its applications in=
=20
>IPv6 networks.

Possible yes, however, delaying of the x-day was surely not one of its=20
design goals. As such, the delay seems more like a side-effect at=20
first=C2=A0=E2=80=94 and then when it became apparent that address spac=
e runs out=20
"soon", NAT became a constant abuse.


>The NAT general principle is the modification of the addresses=20
>information of IP packets in order to isolate all the network [...]=20
>Security. The NAT Device often blocks packets unassociated to any=20
>existing flow [...] this =E2=80=9Capplication=E2=80=9D is more a side-=
effect

NAT is not a security device, even if a particular implementation with =
a=20
particular configuration _may_ drop packets. A different implementation=
=20
may even allow them by default=C2=A0=E2=80=94 think certain router mode=
ls with=20
clearly labeled "DMZ" ports, and a user plugging stuff in without=20
thinking.

Side-effect is too soft. Calling NAT a security device comes like=20
premeditated deception of end-users.



>Multi-Homing. One network can be a client of several ISPs in order to=20
>ensure redundancy or in order to reduce costs. These different ISPs=20
>will assign the client different prefixes. However, it can be desired=20
>that the client does not have to modify the topology of his subnet eac=
h=20
>time he switches from one ISP to another.

When switching the provider, consider:

- If ISP2 blocks packets with source address SRC1, you are busted. NAT=20
won't fix your problem:

- reason 1: NAT is applied per CT and does not automatically change=20
while a CT exists.

- reason 2: Even if it did, packets of your connection would suddenly=20
have SRC2, and the remote side would reject it with TCP RST, because it=
=20
only knows a connection with SRC1.

- If ISP2 does accept packets from SRC1 (last time I checked, HE.net an=
d=20
SIXXS.net did that), you don't need NAT either.

These issues are known today already because they also apply to v4-NAT.=
=20
The more so because in the providers' little IPv4 space, in practice=20
ISPn almost always block sources claiming not to come from ISP2's space=
=2E


>the main reason for using NAT in IPv4 was the ability to connect=20
>several hosts of an internal network to an external network, using les=
s=20
>public IP Addresses than needed

There is a difference between needed address and available addresses. I=
f=20
people did not need so many, they could fit all their hosts in the=20
available address space instead - and would not need NAT.


>But, if there were only routing tables, there would be a problem with=20
>prefixes: both ISPs would impose their prefixes, and the network insid=
e=20
>the company cannot have several prefixes.

There is no reason that hosts inside a network are limited to a single=20
address. There:

ip addr add 2001:db8:1::1/64 dev dummy0
ip addr add 2001:db8:2::1/64 dev dummy0

In fact, each IPv6 hosts usually already has more than one address - an=
d=20
one of them is the fe80::/ link-scope prefix. So they are generally=20
already multi-homed once one has added a unicast address to an=20
interface.


>Fast execution NAT in IPv4 is slowed because the NAT device has to=20
>recompute the checksums every time a packet goes through; we want to=20
>circumvent this limitation.

You need to recompute them anyway when doing L7 substitution.


>An entity that is 128 bits long is never atomic

A 128-bit entity can very well be atomic if the programming language=20
implementation decides to make it so. Just because yours does not do it=
=20
currently does not mean it will never be.


>And whatever is the type of the variable defined, the representation i=
n=20
>memory will remain the same.

This statement seems incorrect. One type's representation may be a trap=
=20
representation for another type. Again, just because that is not the=20
case in contemporary implementations does not mean it is not possible.


>routers cannot fragment a packet on their own anymore, and cannot=20
>reassemble fragments either.

While I can agree with this statement, be aware that "routers" running=20
nf_conntrack will undoubtedly reassemble in all cases, save perhaps for=
=20
packets delievered to raw sockets due to the order of raw-socket=20
delivery and nf_defrag. Subsequently,


>We will thus have to be aware that some packets arriving have NO Layer=
=20
>4 information while NAT is still working.

is not satisfied. nf_conntrack (required by nf_nat) forces reassembly o=
f=20
packets exactly because the L4 header is part of the tracking tuple.


>int i; // A loop counter

	=E2=80=9CA loop counter!? Nobody would have expected _that_!=E2=80=9D


>This negotiation happens in a ASCII format data flow and not in a=20
>binary format. Therefore, the change of the connection information in=20
>the ASCII format may change the length of the packet after the NAT=20
>manipulation.

Note however that binary encodings can also exist as variable-length. S=
o=20
binary is not the magic scepter. Think of UTF-8.


So far my active readthrough..
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
