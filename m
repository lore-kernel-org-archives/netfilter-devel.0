From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nf-next: TEE only
Date: Thu, 15 Apr 2010 13:41:00 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004151332180.16012@obet.zrqbmnf.qr>
References: <1271200907-5262-1-git-send-email-jengelh@medozas.de> <4BC59F93.8090209@trash.net> <alpine.LSU.2.01.1004141310120.13840@obet.zrqbmnf.qr> <4BC5A603.5090403@trash.net> <alpine.LSU.2.01.1004141326570.13840@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45194 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab0DOLlD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 07:41:03 -0400
In-Reply-To: <alpine.LSU.2.01.1004141326570.13840@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-04-14 13:32, Jan Engelhardt wrote:
>On Wednesday 2010-04-14 13:24, Patrick McHardy wrote:
>>>> So what about oif routing which I asked for two times?
>>> 
>>> Guess it must have fallen off somewhere between the resends. We can 
>>> still add it as a patch on top.
>>
>>Please add it before I apply it. Should be a fairly trivial change.
>>
>>>> I guess you'd usually have a host for logging or IDS somewhere on a
>>>> private network and TEE packets there. So specifying oif and gateway
>>>> seems most useful to me.
>>> 
>>> The oif is already determined by the route to the gateway(logging
>>> host). I'd also fear that people abuse TEE as a ROUTE replacement
>>> when they see an --oif.
>>
>>That's something different. The oif forces use of a specific output
>>device, independant of the routing tables. F.i.:
>
>You should be able to use a specific output device by use of a routing 
>table, and selecting that table with fwmark.

>This is quite useful since your logging host doesn't have to be
>reachable through normal routing.
>4: dummy0: <BROADCAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN
>    link/ether 96:7f:5e:d2:d6:c9 brd ff:ff:ff:ff:ff:ff
>    inet6 fe80::947f:5eff:fed2:d6c9/64 scope link
>       valid_lft forever preferred_lft forever
>
># ping 10.0.0.1 -I dummy0
>IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto ICMP (1), length 84)
>    192.168.0.100 > 10.0.0.1: ICMP echo request, id 25874, seq 1, length 64
>IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto ICMP (1), length 84)
>    192.168.0.100 > 10.0.0.1: ICMP echo request, id 25874, seq 2, length 64

I don't see why one would want the log server to be unreachable.

What _does_ look reasonable however is an encapsulation device for transporting
teed packets across multiple real hops:

14: gre1: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1476 qdisc noqueue state UNKNOWN
    link/gre 5.6.7.8 peer 1.2.3.4

and this case can be solved with standard(/fwmarking) policy routing
('default via gre1').
