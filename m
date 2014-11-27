From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Re: issue with nftable - goto : Operation not supported
Date: Thu, 27 Nov 2014 13:31:52 +0100
Message-ID: <547719B8.6040302@c-s.fr>
References: <5474BC91.6060108@c-s.fr> <20141126130042.GA1533@salvia> <54760ABA.4040900@c-s.fr> <20141126174721.GA3815@salvia> <5476152E.8010400@c-s.fr> <20141126181312.GA25447@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20141126181312.GA25447@salvia>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Le 26/11/2014 19:13, Pablo Neira Ayuso a =E9crit :
>> How can it interpret the below output which seems buggy ?
>>
>> root@vgoip:~# nft list table filter
>> table ip filter {
>>          chain input {
>>                   type filter hook input priority 0;
>>                   oifname "lo" accept
>>                   ip protocol icmp accept
>>                   ct state 8 unknown unknown 0x16 [invalid type] acc=
ept
>>                   ct state { 4, 2} accept
>>                   reject with icmp type 10
>>          }
> What is the original ruleset you loaded? This should not happen. Any
> relevant information regarding your testbed?
Ruleset is:
nft add table ip filter
nft add chain ip filter input { type filter hook input priority 0 \; }
nft add rule filter input meta oifname lo accept
nft add rule filter input ip protocol icmp accept
nft add rule filter input ct state new tcp dport 22 accept
nft add rule filter input ct state {established, related} accept
nft add rule filter input reject with icmp type host-prohibited

Target is a powerpc
All building is done on a x86 PC, using home built cross-compile gnu=20
tools (binutils, gcc, glibc, ....)

I just ran 'nft' with gdb, and I have seen something wrong with byte=20
ordering.
It looks like in symbolic_constant_print(), mpz_export_data() return a=20
strange val.
=46irst time we get there, we get 0x800000000
Next time, we get 0x400000000
Last time, we get 0x200000000
While we expect 8(new), 4(related), 2(established)

Any idea on how I can fix that ?

Kernel 3.17.4
nftables-20141121
gmp-4.3.2
libmnl-1.0.3
libnfnetlink-1.0.1
libnftnl-20141121
libnetfilter_conntrack-1.0.4

Christophe
