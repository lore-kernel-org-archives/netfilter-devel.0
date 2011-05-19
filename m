From: Detlev Zundel <dzu@denx.de>
Subject: Re: UDP DNAT to a broadcast address
Date: Thu, 19 May 2011 09:19:16 +0200
Message-ID: <m27h9nrwcr.fsf@ohwell.denx.de>
References: <m2wrhorofi.fsf@ohwell.denx.de>
	<alpine.LNX.2.01.1105182203510.27350@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:53605 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab1ESHTs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 May 2011 03:19:48 -0400
In-Reply-To: <alpine.LNX.2.01.1105182203510.27350@frira.zrqbmnf.qr> (Jan
	Engelhardt's message of "Wed, 18 May 2011 22:18:27 +0200 (CEST)")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

thanks for the quick answer.

> On Wednesday 2011-05-18 17:58, Detlev Zundel wrote:
>
>>Hi,
>>
>>looking for the answer to this problem, I searched the web and this
>>mailing list, but I still couldn't find a definitive answer to the
>>question that I have.
>>
>>In my setup I need to a UDP packet sent to the external IP of my router
>>to trigger a broadcast UDP packet on the local network and relay back
>>the answers to this packet.
>>
>>It looks like this should do the trick:
>>
>>iptables -t nat -I PREROUTING -i ppp0 -p udp --dport 3333 -j DNAT --to 
>>192.168.0.255
>>
>>Of course, as I write this e-mail, this does not work.
>
> On the contrary. This should exactly do what is requested: changing
> the dst address in the packet to 255, and you should be able to
> observe that this address change was successful by using -j LOG in
> filter-INPUT.
>
>>I can see the packets entering the INPUT chain, but I see no packets
>>on the OUTPUT chain. I speculate that this is because braodcast
>>addresses are not routable and thus the packet gets lost somewhere.
>
> By the very definition of broadcast, a receiver is not to route it
> any further, wh. As such, it enters INPUT. No loss, the machine
> properly receives it (as it is supposed to). OUTPUT is only for
> locally-generated packets, but received frames can only appear in
> INPUT or FORWARD.

Yes, sorry, I really meant that I did not see anything on the FORWARD
chain.

> Netfilter does not even play a role in this.
>
> All the bcast/mcast forwarders are userspace AFAICS.

Ok, thanks for the explanation, this now all makes sense to me and I'll
turn to userspace.

Best wishes
  Detlev

-- 
It is practically impossible to teach good programming to students that have
had a  prior exposure to BASIC:  as potential  programmers they are mentally
mutilated beyond hope of regeneration.                    -- Edsger Dijkstra 
