From: Anton VG <anton.vazir@gmail.com>
Subject: Re: ipset and interfaces
Date: Tue, 24 May 2011 17:42:14 +0500
Message-ID: <BANLkTi=1fO13Z-uiRiiK2uWfLeS4+ZRvHQ@mail.gmail.com>
References: <BANLkTim0bcPRtN1PYSZz4TyKUHGasGhsBQ@mail.gmail.com>
	<alpine.DEB.2.00.1105241344200.1846@blackhole.kfki.hu>
	<BANLkTi=drvnwAiXk-Js+1Dw0wxWGNsT1xA@mail.gmail.com>
	<alpine.DEB.2.00.1105241433030.1846@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Oskar Berggren <oskar.berggren@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59210 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab1EXMmP convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 08:42:15 -0400
Received: by wwa36 with SMTP id 36so7278129wwa.1
        for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2011 05:42:14 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1105241433030.1846@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hm, my largest instance is about 200 vlan's ;)

2011/5/24 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>:
> On Tue, 24 May 2011, Oskar Berggren wrote:
>
>> 2011/5/24 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>:
>> > On Tue, 24 May 2011, Oskar Berggren wrote:
>> >
>> >> Regarding ipsets.... how crazy would it be to add a set type
>> >> containing interface names?
>> >
>> > Usually the number of interfaces are not quite high in a system, s=
o it
>> > does not seem required.
>>
>> I have machines with plenty of vlans. About 700 interfaces in the
>> largest instance currently. That said, I don't have a clear use case=
 for
>> this particular set type currently, but out of curiosity, would it b=
e
>> reasonably doable within the ipset framework?
>
> Yes, I don't see any problem here.
>
>> >> And how crazy would it be to add a set type containing tuples of
>> >> ip-address and interface name? =A0(I.e. the set match would look =
for ip,
>> >> and match if a tuple with the proper interface is found)
>> >
>> > What is the case where a combination of matches does not solve the=
 issue?
>> > Something like this
>> >
>> > -N interfaces
>> > -A interfaces -i foo -j ACTION
>> > ...
>> >
>> > -A rule -m set --match-set src -j interfaces
>> >
>> > and thus you can match IP addresses and possible (incoming) interf=
aces
>> > easily.
>>
>> As above, about 700 interfaces, each with a generally just a few sou=
rce
>> ip-addresses expected for each interface, or a few subnets. I.e. in =
the
>> simplest case a single ip is acceptable for a single interface, for =
a
>> total of a couple of hundred interfaces. This is similar to rp_filte=
r,
>> but I had trouble getting that to work predictably with multiple rou=
ting
>> tables. Currently I've solved it with a tree structure of iptables
>> chains and rules, but being able to use a single set for this would =
look
>> so much nicer.
>
> So it looks like a valid case, for a new set type with interfaces and=
 IP
> addresses/networks ;-) I'll work on it.
>
> Best regards,
> Jozsef
> -
> E-mail =A0: kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : KFKI Research Institute for Particle and Nuclear Physics
> =A0 =A0 =A0 =A0 =A0H-1525 Budapest 114, POB. 49, Hungary
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
