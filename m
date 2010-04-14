From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf-next: TEE only
Date: Wed, 14 Apr 2010 13:24:51 +0200
Message-ID: <4BC5A603.5090403@trash.net>
References: <1271200907-5262-1-git-send-email-jengelh@medozas.de> <4BC59F93.8090209@trash.net> <alpine.LSU.2.01.1004141310120.13840@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37626 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab0DNLYw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Apr 2010 07:24:52 -0400
In-Reply-To: <alpine.LSU.2.01.1004141310120.13840@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-04-14 12:57, Patrick McHardy wrote:
> 
>> Jan Engelhardt wrote:
>>> in this round:
>>> - use IP6SKB_REROUTED in v6 code
>>> - pick_net function: use skb->dev or skb->dst->dev when available
>>>   (or completely fall back to init_net in case there's something
>>>   going on)
>> So what about oif routing which I asked for two times?
> 
> Guess it must have fallen off somewhere between the resends. We can 
> still add it as a patch on top.

Please add it before I apply it. Should be a fairly trivial change.

>> I guess you'd usually have a host for logging or IDS somewhere on a
>> private network and TEE packets there. So specifying oif and gateway
>> seems most useful to me.
> 
> The oif is already determined by the route to the gateway(logging
> host). I'd also fear that people abuse TEE as a ROUTE replacement
> when they see an --oif.

That's something different. The oif forces use of a specific output
device, independant of the routing tables. F.i.:

# ip l l dummy0
4: dummy0: <BROADCAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN
    link/ether 96:7f:5e:d2:d6:c9 brd ff:ff:ff:ff:ff:ff

# ip a s dummy0
4: dummy0: <BROADCAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN
    li# ip a s dummy0
4: dummy0: <BROADCAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN
    link/ether 96:7f:5e:d2:d6:c9 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::947f:5eff:fed2:d6c9/64 scope link
       valid_lft forever preferred_lft forever

# ip r | grep dummy0
#

# ping 10.0.0.1 -I dummy0
IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto ICMP (1), length 84)
    192.168.0.100 > 10.0.0.1: ICMP echo request, id 25874, seq 1, length 64
IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto ICMP (1), length 84)
    192.168.0.100 > 10.0.0.1: ICMP echo request, id 25874, seq 2, length 64

This is quite useful since your logging host doesn't have to be
reachable through normal routing.
