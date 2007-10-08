From: "john ye" <johny@asimco.com.cn>
Subject: Re: remarkably Increase iptables' speed on SMP system.
Date: Mon, 8 Oct 2007 20:04:29 +0800
Message-ID: <000d01c809a3$7019fe10$d6ddfea9@JOHNYE1>
References: <00de01c80175$7402ef90$ca8510ac@asimco> <46FCF121.8010807@ufomechanic.net>
Cc: <netfilter-devel@vger.kernel.org>
To: "Amin Azez" <azez@ufomechanic.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asimco-na.com ([207.138.153.195]:39189 "EHLO
	mail.asimco-na.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbXJHME6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2007 08:04:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

All,

Now, the BS version 2 patch module is available. It support all protocols (version 1 is only working for ipv4).
So now all netfilter code (for example, bridge netfilter, ipv6 netfilter) can be parallelized on SMP.

I make the module be compiled and running on following kernel version:

#define KERNEL_VERSION_2_6_13__         //2.6.13-15 OK
#define KERNEL_VERSION_2_6_16         //2.6.16.53 OK    ------------ this one is selected.
#define KERNEL_VERSION_2_6_17__         //2.6.17.9 #3 OK
#define KERNEL_VERSION_2_6_18__         //2.6.18.8 & 2.6.18.2-34  OK
#define KERNEL_VERSION_2_6_19__         //2.6.19 #1 OK
#define KERNEL_VERSION_2_6_20__         //2.6.20 OK
#define KERNEL_VERSION_2_6_21__         //2.6.21.1 OK
#define KERNEL_VERSION_2_6_22__         //2.6.22.5 OK
#define KERNEL_VERSION_2_6_23__         //2.6.23-rc8 OK

This made the test work much easier without rebuilding kernel.

The file can be downloaded at
ftp://218.247.5.185
login: netfilter
password: iptables

files:
main.c is version 1 BS
bs_smp2.c  is version 2 BS
bs2.tar.gz is tar file of bs_smp2.c

You are welcome to review the code and test the performance.

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


