From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: What does SPI firewall Mean?
Date: Fri, 4 Apr 2008 10:49:14 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804041035350.1301@fbirervta.pbzchgretzou.qr>
References: <47F5D9A7.4000403@rocsys.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Bhaskar <vbhaskar@rocsys.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47193 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbYDDItQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2008 04:49:16 -0400
In-Reply-To: <47F5D9A7.4000403@rocsys.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-04-04 09:32, Bhaskar wrote:

> I have been thinking about this questions.  The obvious answer I got is
> SPI firewall understands the states of the packet flow

Security Parameter Index
Single Packet Inspection
Stateless Packet Inspection
Stateful Packet Inspection
...
FWIW PCMCIA!</sarcasm>

(I have no joy figuring out what all your acronyms, SPI and NW mean.)

>   1. iptables -A FORWARD -i eth0 -o eth1 -p tcp -m state --state
>      NEW,ESTABLISHED --dport 80 -j ACCEPT
>   2. iptabgles -A FORWARD -i eth0 -o eth1 -p udp -m udp --dport 53 -j
>      ACCEPT
>   3. iptables -A FORWARD -j LOG --log-prefix "Dropping Other Packets:"
>   4. iptables -A FORWARD -j DROP
>
>   1. iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
>
> The intension is to allow HTTP Traffic to the internal network.  With
> the above setup I am not able to browse from PC connected in Protected
> NW.

That is because -- despite the connection "association" being active --
you only allow http from eth0->eth1 but not the reverse direction.

> After analyzing the Logs and added another 2 policies above Policy
> Number 3:
> iptables -A FORWARD -i eth1 -o eth0 -p tcp -m state --state
> NEW,ESTABLISHED --sport 80 -j ACCEPT
> iptables -A FORWARD -i eth1 -o eth0 -p udp -m udp --sport 53 -j ACCEPT
>
> After adding these policies I am able to browse.  AFAIK, once an
> association is created (first time when packet is passing through
> netfilter), the associated traffic would flow and Policies are not
> parsed for the verdict.
