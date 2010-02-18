From: Afi Gjermund <afigjermund@gmail.com>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l' count
Date: Thu, 18 Feb 2010 09:40:20 -0800
Message-ID: <48ceaa831002180940y65af65b4p5d887f2f1a50b4b@mail.gmail.com>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>
	 <alpine.LSU.2.01.1002151959460.6158@obet.zrqbmnf.qr>
	 <48ceaa831002151130j3c96c72an40653869aac63814@mail.gmail.com>
	 <1266264287.2859.0.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1002152132250.21055@obet.zrqbmnf.qr>
	 <48ceaa831002151308y5bb2606n2058599f3ec4b82@mail.gmail.com>
	 <1266270757.2859.27.camel@edumazet-laptop>
	 <48ceaa831002151400q4178d121h28887cfdf6625499@mail.gmail.com>
	 <1266271377.2859.28.camel@edumazet-laptop>
	 <48ceaa831002151410j1dbdfce3tcbdb5ceaa86b0e2b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54526 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab0BRRkV convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:40:21 -0500
Received: by pwj8 with SMTP id 8so1609053pwj.19
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Feb 2010 09:40:20 -0800 (PST)
In-Reply-To: <48ceaa831002151410j1dbdfce3tcbdb5ceaa86b0e2b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 15, 2010 at 2:10 PM, Afi Gjermund <afigjermund@gmail.com> w=
rote:
> On Mon, Feb 15, 2010 at 2:02 PM, Eric Dumazet <eric.dumazet@gmail.com=
> wrote:
>> Le lundi 15 f=E9vrier 2010 =E0 14:00 -0800, Afi Gjermund a =E9crit :
>>> On Mon, Feb 15, 2010 at 1:52 PM, Eric Dumazet <eric.dumazet@gmail.c=
om> wrote:
>>> > Le lundi 15 f=E9vrier 2010 =E0 13:08 -0800, Afi Gjermund a =E9cri=
t :
>>> >> >
>>> >> On my 2.6.26.5 kernel I do not have CONFIG_NAMESPACES set.
>>> >
>>> > could you post the result of 'netstat -s' ?
>>> >
>>> >
>>> >
>>>
>>> Unfortunately the Busybox version of netstat doesn't have the stati=
stics option.
>>
>> ok then :)
>>
>> cat /proc/net/snmp
>>
>>
>>
> Ip: Forwarding DefaultTTL InReceives InHdrErrors InAddrErrors
> ForwDatagrams InUnknownProtos InDiscards InDelivers OutRequests
> OutDiscards OutNoRoutes ReasmTimeout ReasmReqds ReasmOKs ReasmFails
> FragOKs FragFails FragCreates
> Ip: 2 64 137517215 0 33726 0 0 0 136714167 151150681 186 53 0 0 0 0 0=
 0 0
> Icmp: InMsgs InErrors InDestUnreachs InTimeExcds InParmProbs
> InSrcQuenchs InRedirects InEchos InEchoReps InTimestamps
> InTimestampReps InAddrMasks InAddrMaskReps OutMsgs OutErrors
> OutDestUnreachs OutTimeExcds OutParmProbs OutSrcQuenchs O
> utRedirects OutEchos OutEchoReps OutTimestamps OutTimestampReps
> OutAddrMasks OutAddrMaskReps
> Icmp: 35 0 35 0 0 0 0 0 0 0 0 0 0 437 0 437 0 0 0 0 0 0 0 0 0 0
> IcmpMsg: InType3 OutType3
> IcmpMsg: 35 437
> Tcp: RtoAlgorithm RtoMin RtoMax MaxConn ActiveOpens PassiveOpens
> AttemptFails EstabResets CurrEstab InSegs OutSegs RetransSegs InErrs
> OutRsts
> Tcp: 1 200 120000 -1 0 139 0 80 0 17587 19167 63 0 11984
> Udp: InDatagrams NoPorts InErrors OutDatagrams RcvbufErrors SndbufErr=
ors
> Udp: 136619682 437 0 151131067 0 0
> UdpLite: InDatagrams NoPorts InErrors OutDatagrams RcvbufErrors Sndbu=
fErrors
> UdpLite: 0 0 0 0 0 0
>
I am still trying to figure out why the nf_conntrack_count differs
from the table system.  I decided I would use the conntrack userspace
tools.
Both of my NICs are unplugged with no other userspace applications
running to affect connection tracking counts.


root@titan ~# date
Thu Feb 18 17:35:21 UTC 2010

root@titan ~# ./conntrack -C conntrack
351

root@titan ~# date
Thu Feb 18 17:35:24 UTC 2010

root@titan ~# ./conntrack -F conntrack
conntrack v0.9.14 (conntrack-tools): connection tracking table has been=
 emptied.

root@titan ~# date
Thu Feb 18 17:35:31 UTC 2010

root@titan ~# ./conntrack -C conntrack
351

root@titan ~# date
Thu Feb 18 17:35:36 UTC 2010

Shouldn't the value after the flush be 0? The traffic that has created
this mess is from a REDIRECT rule in the PREROUTING chain of the 'nat'
table.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
