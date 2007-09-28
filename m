From: Amin Azez <azez@ufomechanic.net>
Subject: Re: remarkably Increase iptables' speed on SMP system.
Date: Fri, 28 Sep 2007 13:18:41 +0100
Message-ID: <46FCF121.8010807@ufomechanic.net>
References: <00de01c80175$7402ef90$ca8510ac@asimco>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, YE QY <iceburgue@gmail.com>
To: John Ye <johny@asimco.com.cn>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from server1.secure-linux-server.com ([207.44.172.97]:51918 "EHLO
	dbamsoftware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051AbXI1NWn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 09:22:43 -0400
In-Reply-To: <00de01c80175$7402ef90$ca8510ac@asimco>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

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
