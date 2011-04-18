From: Pierre Rondou <prondou@gmail.com>
Subject: Re: Problem sending skb built from scratch with IPv6
Date: Mon, 18 Apr 2011 17:05:20 +0200
Message-ID: <4DAC5330.9060107@gmail.com>
References: <4D893485.5050709@gmail.com> <alpine.LNX.2.01.1103242207250.15489@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:1332 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753447Ab1DRPFb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:05:31 -0400
In-Reply-To: <alpine.LNX.2.01.1103242207250.15489@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Long time since my previous mail, I've been looking on other issues.

The problem solved itself by upgrading to debian squeeze (I previously=20
was on a testing version between Lenny and squeeze).

Thanks anyway :-)


Le 24/03/11 22:16, Jan Engelhardt a =E9crit :
> On Wednesday 2011-03-23 00:45, Pierre Rondou wrote:
>
>   =20
>> Hi all,
>>
>>
>> I'm a student at the University of Liege (Belgium) and for my master=
 thesis, I
>> have to devellop a netfilter module implementing NatIvI and Nat64.
>>     =20
> Let me just make aware of preexisting software, such as Ecdysis nat64=
,
> because too often have I encountered students who just reimplemented
> everything and then felt like it was for nothing.
>
>   =20
>> The modules, as stated by the protocols, need to be able to send pac=
ket
>> with IP that doesn't belong to them (i.e, sort of spoofing). Everyth=
ing
>> works fine for the newly created IPv4 skb (I can see the packets in
>> wireshark), you can see the source code at the end.
>>
>> But for Ipv6, the only think I see is neighbour solicitation message=
s
>> (ICMPv6) for both the source IP and the dest IP. There is one only c=
ase
>> when the program works: when the source IP of the packet is the same=
 as
>> the interface's one.
>>     =20
> Of course a connected router will do NDISC if the address is directly
> reachable according to its routing table.
>
>
>   =20
>> The source code used for the new IPv4 packets (working 100%), it's c=
opied from
>> the NAT64 module available in GPL:
>>     =20
> "The NAT64 module", but which?
>
>   =20
>>    skb_dst_set(newskb, dst);
>>    newskb->dev =3D dst->dev;
>>    skb_dst_set(newskb, dst);
>>     =20
> Why set dst twice?
>
>   =20
>> # route --inet
>> Table de routage IP du noyau
>> Destination     Passerelle      Genmask         Indic Metric Ref    =
Use Iface
>> 192.168.1.0     *               255.255.255.0   U     0      0      =
  0 eth1
>> default         192.168.1.1     0.0.0.0         UG    0      0      =
  0 eth1
>>     =20
> For future reference, stick to iproute2.
>
>   =20
>> # route --inet6
>> Table de routage IPv6 du noyau
>> Destination                    Next Hop                   Flag Met R=
ef Use If
>> 2001:6a8:2d80:128::/64         ::                         U    256 0=
     1 eth1
>> fe80::/64                      ::                         U    256 0=
     0 eth1
>> ::/0                           2001:6a8:2d80:128::2       UG   1   0=
    35 eth1
>> ::/0                           ::                         !n   -1  1=
    61 lo
>> ::1/128                        ::                         Un   0   1=
    80 lo
>> 2001:6a8:2d80:128::/128        ::                         Un   0   1=
     0 lo
>> 2001:6a8:2d80:128::1/128       ::                         Un   0   1=
    20 lo
>> fe80::/128                     ::                         Un   0   1=
     0 lo
>> fe80::20e:a6ff:feb0:e1a2/128   ::                         Un   0   1=
    14 lo
>> ff00::/8                       ::                         U    256 0=
     0 eth1
>> ::/0                           ::                         !n   -1  1=
    61 lo
>>     =20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
