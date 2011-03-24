From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Problem sending skb built from scratch with IPv6
Date: Thu, 24 Mar 2011 22:16:40 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1103242207250.15489@obet.zrqbmnf.qr>
References: <4D893485.5050709@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pierre Rondou <prondou@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38201 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab1CXVQl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:16:41 -0400
In-Reply-To: <4D893485.5050709@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-03-23 00:45, Pierre Rondou wrote:

> Hi all,
>
>
> I'm a student at the University of Liege (Belgium) and for my master thesis, I
> have to devellop a netfilter module implementing NatIvI and Nat64.

Let me just make aware of preexisting software, such as Ecdysis nat64, 
because too often have I encountered students who just reimplemented
everything and then felt like it was for nothing.

>The modules, as stated by the protocols, need to be able to send packet 
>with IP that doesn't belong to them (i.e, sort of spoofing). Everything 
>works fine for the newly created IPv4 skb (I can see the packets in 
>wireshark), you can see the source code at the end.
>
>But for Ipv6, the only think I see is neighbour solicitation messages 
>(ICMPv6) for both the source IP and the dest IP. There is one only case 
>when the program works: when the source IP of the packet is the same as 
>the interface's one.

Of course a connected router will do NDISC if the address is directly 
reachable according to its routing table.


> The source code used for the new IPv4 packets (working 100%), it's copied from
> the NAT64 module available in GPL:

"The NAT64 module", but which?

>   skb_dst_set(newskb, dst);
>   newskb->dev = dst->dev;
>   skb_dst_set(newskb, dst);

Why set dst twice?

> # route --inet
> Table de routage IP du noyau
> Destination     Passerelle      Genmask         Indic Metric Ref    Use Iface
> 192.168.1.0     *               255.255.255.0   U     0      0        0 eth1
> default         192.168.1.1     0.0.0.0         UG    0      0        0 eth1

For future reference, stick to iproute2.

> # route --inet6
> Table de routage IPv6 du noyau
> Destination                    Next Hop                   Flag Met Ref Use If
> 2001:6a8:2d80:128::/64         ::                         U    256 0     1 eth1
> fe80::/64                      ::                         U    256 0     0 eth1
> ::/0                           2001:6a8:2d80:128::2       UG   1   0    35 eth1
> ::/0                           ::                         !n   -1  1    61 lo
> ::1/128                        ::                         Un   0   1    80 lo
> 2001:6a8:2d80:128::/128        ::                         Un   0   1     0 lo
> 2001:6a8:2d80:128::1/128       ::                         Un   0   1    20 lo
> fe80::/128                     ::                         Un   0   1     0 lo
> fe80::20e:a6ff:feb0:e1a2/128   ::                         Un   0   1    14 lo
> ff00::/8                       ::                         U    256 0     0 eth1
> ::/0                           ::                         !n   -1  1    61 lo
