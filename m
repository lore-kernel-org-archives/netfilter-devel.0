From: "John Ye" <johny@asimco.com.cn>
Subject: Re: remarkably Increase iptables' speed on SMP system.
Date: Sat, 29 Sep 2007 17:52:41 +0800
Message-ID: <000b01c8027e$7a6ba930$0201a8c0@ibmea4709fd199>
References: <00de01c80175$7402ef90$ca8510ac@asimco> <46FCF121.8010807@ufomechanic.net>
Cc: <netfilter-devel@vger.kernel.org>, <johny@asimco.com.cn>,
	<iceburgue@gmail.com>
To: "Amin Azez" <azez@ufomechanic.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asimco-na.com ([207.138.153.195]:15985 "EHLO
	mail.asimco-na.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbXI2Jwx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Sep 2007 05:52:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Sam,

Thanks for your reply.

In terms of packet re-ordering, TCP has no problem because I hash the CPU by
cpu = (IP_SRC+IP_DST + tcp_src_port + tcp_dst_port) % nr_cpus.
This can make sure one TCP connection can only be processed on one CPU.

For UDP(snat), now, the code doesn't consider the problem. We need test,
and if we found this is really a big problem, we will change the code.

The main purpose of my message to you is simply to let you review the BS patch code
and point out potential problem for netfilter iptables on smp and give suggestions,
you all are network experts.

GRE is the protocol for MS style VPN if I remembered?. How the GRE re-ordering
is, I had no idea yet.

bridge is not working with BS now. I checked the code net/core/dev.c, bridge is handled
before IP(?). I can make it SMPable, later if need to do so.

Ha-Ha, for networking, a packet being processed too quick is not always a good thing.

BS_POL_RAMDOM ( /proc/sys/net/bs_policy ) is just simply to randomly dispatch skb
to a CPU without considering re-ordering, it's for testing only.
even with random cpu hash, the network speed can be doubled when iptalbes' load
is very high because other CPU joint the work.

John Ye



----- Original Message ----- 
From: "Amin Azez" <azez@ufomechanic.net>
To: "John Ye" <johny@asimco.com.cn>
Cc: <netfilter-devel@vger.kernel.org>; "YE QY" <iceburgue@gmail.com>
Sent: Friday, September 28, 2007 8:18 PM
Subject: Re: remarkably Increase iptables' speed on SMP system.


* John Ye wrote, On 28/09/07 03:15:

> There is a kernel patch to let softirq network code(iptables included in) concurrently run on every CPUs on SMP system.
> We wrote the kernel patch, a loadable module as well, to totally resolve iptables SMP issue.
> Have discussed with kernel netdev experts. it should be working.
>
> The patch(module) will greatly increase the speed of iptalbes by making full use of every CPUs in SMP system.
>
> It can be viewed and downloaded from blog http://blog.chinaunix.net/u/12848/showart.php?id=389602
> You are welcome to review and test without patching and re-compiling the kerenl.


This looks interesting, and I hope worthwhile.

I wonder if it will likely re-order packets with the same flow?

i.e. packets which take more processing may leave the bridge/router
after a packet of the same flow which arrived later.

Cases where this seems more likely are generally where not every packet
of the same flow requires the same level of processing.

Obvious examples are:
* udp snat, where only the first packet follows the nat table
* layer7 when it stops matching, the very next packet may get through
before the one that was the last to be matched.
* packet count or rate based rules that only sometimes call secondary
chains may be delayed more than the next packet if it doesn't match.

TCP (with SACK) may not be so bothered about this, but some GRE or UDP
protocols may care (get degraded service), it may also foil upstream
flow analysis which makes me realise that the layer7 match (and probably
string match) are open to being deceived by deliberate out-of-order
packets or intermediate fake packets with bad tcp sequence numbers. Hmm

Sam




