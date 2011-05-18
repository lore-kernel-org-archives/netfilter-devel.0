From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: UDP DNAT to a broadcast address
Date: Wed, 18 May 2011 22:18:27 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105182203510.27350@frira.zrqbmnf.qr>
References: <m2wrhorofi.fsf@ohwell.denx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Detlev Zundel <dzu@denx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:39112 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab1ERUS3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 May 2011 16:18:29 -0400
In-Reply-To: <m2wrhorofi.fsf@ohwell.denx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-05-18 17:58, Detlev Zundel wrote:

>Hi,
>
>looking for the answer to this problem, I searched the web and this
>mailing list, but I still couldn't find a definitive answer to the
>question that I have.
>
>In my setup I need to a UDP packet sent to the external IP of my router
>to trigger a broadcast UDP packet on the local network and relay back
>the answers to this packet.
>
>It looks like this should do the trick:
>
>iptables -t nat -I PREROUTING -i ppp0 -p udp --dport 3333 -j DNAT --to 
>192.168.0.255
>
>Of course, as I write this e-mail, this does not work.

On the contrary. This should exactly do what is requested: changing
the dst address in the packet to 255, and you should be able to
observe that this address change was successful by using -j LOG in
filter-INPUT.

>I can see the packets entering the INPUT chain, but I see no packets
>on the OUTPUT chain. I speculate that this is because braodcast
>addresses are not routable and thus the packet gets lost somewhere.

By the very definition of broadcast, a receiver is not to route it
any further, wh. As such, it enters INPUT. No loss, the machine
properly receives it (as it is supposed to). OUTPUT is only for
locally-generated packets, but received frames can only appear in
INPUT or FORWARD.

Netfilter does not even play a role in this.

All the bcast/mcast forwarders are userspace AFAICS.
