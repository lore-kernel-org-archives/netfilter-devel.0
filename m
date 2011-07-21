From: Patrick McHardy <kaber@trash.net>
Subject: Re: Possible conntrack/kernel bug - not catching certain ICMP packets
Date: Thu, 21 Jul 2011 08:16:56 +0200
Message-ID: <4E27C458.5030605@trash.net>
References: <4E202844.30602@wildgooses.com> <4E241AB0.5060603@wildgooses.com> <alpine.LNX.2.01.1107181415500.13166@frira.zrqbmnf.qr> <4E274C77.8080605@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61902 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1GUGQ7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jul 2011 02:16:59 -0400
In-Reply-To: <4E274C77.8080605@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20.07.2011 23:45, Ed W wrote:
> Please, could someone take a look at this possible conntrack issue?
> Even just acknowledging that it's reproducible on a selection of recent
> kernels or architectures would help?
> 

It's expected behaviour since ICMP packets related to an existing
connection don't refresh the connection and are not accounted.
I don't have an opinion on whether they should be accounted, I
guess you could argue both ways.

> 
>>> Essentially we have a reproducible situation where conntrack is
>>> (apparently) relating a packet to a connection, but not incrementing the
>>> connection counters?
>>>
>>> Thanks for any help figuring out a fix?
>>>
>>> Ed W
>>>
>>>
>>> On 15/07/2011 12:45, Ed W wrote:
>>>> Hi, This is related to a previous thread, but more complete problem
>>>> statement below:
>>>>
>>>> I notice that I can get an ICMP packet to bypass parts of conntrack
>>>> under the following conditions
>>>>
>>>> - Send a UDP packet that triggers some kind of UDP reply
>>>> - Close the listening UDP socket before that reply arrives
>>>> - Kernel generates an ICMP unreachable response which does not appear to
>>>> be tracked (as expected) by conntrack
>>>>
>>>> Tested with kernel 2.6.38.4 + iptables 1.4.11.1
>>>>
>>>> Reproduce this easily like so:
>>>>
>>>>     nslookup www.yahoo.co.uk 8.8.8.8 & sleep 0.001 && killall nslookup
>>>>
>>>>     (where the sleep obviously needs to be smaller than your DNS RTT
>>>> lookup time. Obviously substitute nslookup/dig as appropriate...)
>>>>
>>>> My results
>>>>
>>>> # conntrack -E
>>>>
>>>>     [NEW] udp      17 30 src=10.141.86.7 dst=8.8.8.8 sport=60721
>>>> dport=53 [UNREPLIED] src=8.8.8.8 dst=10.141.86.7 sport=53 dport=60721
>>>>  [UPDATE] udp      17 29 src=10.141.86.7 dst=8.8.8.8 sport=60721
>>>> dport=53 src=8.8.8.8 dst=10.141.86.7 sport=53 dport=60721
>>>> [DESTROY] udp      17 src=10.141.86.7 dst=8.8.8.8 sport=60721 dport=53
>>>> packets=1 bytes=66 src=8.8.8.8 dst=10.141.86.7 sport=53 dport=60721
>>>> packets=1 bytes=110
>>>>
>>>> # tcpdump
>>>>
>>>> 11:26:35.072564 IP 10.141.86.7.60721 > 8.8.8.8.domain: 2+ PTR?
>>>> 8.8.8.8.in-addr.arpa. (38)
>>>> 11:26:35.351804 IP 8.8.8.8.domain > 10.141.86.7.60721: 2 1/0/0 PTR
>>>> google-public-dns-a.google.com. (82)
>>>> 11:26:35.352110 IP 10.141.86.7 > 8.8.8.8: ICMP 10.141.86.7 udp port
>>>> 60721 unreachable, length 118
>>>>
>>>>
>>>> # iptables -A OUTPUT -j LOGMARK
>>>> # iptables -A OUTPUT -j LOG
>>>>
>>>> Jul 15 11:26:35 localhost kern.warn kernel: [ 6676.964396] iif=0
>>>> hook=OUTPUT nfmark=0x0 secmark=0x0 classify=0x0 ctdir=ORIGINAL
>>>> ct=0xcf3d5060 ctmark=0x0 ctstate=NEW ctstatus= lifetime=6346s
>>>> Jul 15 11:26:35 localhost kern.warn kernel: [ 6676.964396] IN= OUT=ppp1
>>>> SRC=10.141.86.7 DST=8.8.8.8 LEN=66 TOS=0x00 PREC=0x00 TTL=64 ID=19971 DF
>>>> PROTO=UDP SPT=60721 DPT=53 LEN=46
>>>> Jul 15 11:26:35 localhost kern.warn kernel: [ 6677.249312] iif=0
>>>> hook=OUTPUT nfmark=0x0 secmark=0x0 classify=0x0 ctdir=ORIGINAL
>>>> ct=0xcf3d5060 ctmark=0x0 ctstate=RELATED ctstatus=SEEN_REPLY,CONFIRMED
>>>> lifetime=4294937s
>>>> Jul 15 11:26:35 localhost kern.warn kernel: [ 6677.249426] IN= OUT=ppp1
>>>> SRC=10.141.86.7 DST=8.8.8.8 LEN=138 TOS=0x00 PREC=0xC0 TTL=64 ID=18412
>>>> PROTO=ICMP TYPE=3 CODE=3 [SRC=8.8.8.8 DST=10.141.86.7 LEN=110 TOS=0x00
>>>> PREC=0x00 TTL=46 ID=3897 PROTO=UDP SPT=53 DPT=60721 LEN=90
>>>>
>>>>
>>>> Notice that logmark seems to show that the ctstatus on the ICMP packet 
>>>> is SEEN_REPLY, but conntrack -E shows only packets=1?  tcpdump shows
>>>> that the ICMP packet did indeed go out
>>>>
>>>> Could someone with more knowledge of conntrack please investigate further? 
>>>>
>>>> Thanks
>>>>
>>>> Ed W
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe netfilter" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe netfilter" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

