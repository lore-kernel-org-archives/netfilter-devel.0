From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: loopback forwarding not working (aka implicit source local
 NAT)
Date: Wed, 17 Sep 2008 13:13:18 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809171309130.14575@fbirervta.pbzchgretzou.qr>
References: <BLU144-W44C48F9DBE68BEE223EE6FD14C0@phx.gbl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: d i <navilein@hotmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51867 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbYIQRNU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Sep 2008 13:13:20 -0400
In-Reply-To: <BLU144-W44C48F9DBE68BEE223EE6FD14C0@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-09-17 12:35, d i wrote:
>
>Hi,
>I understood that iptables (my version is 1.4.0) do not longer support implicit source local NAT, i.e., the effect of 
>iptables -t nat -A OUTPUT -p tcp --dport 222 -t DNAT --to-destination ${LANIP}:22
>which allows one to  write on the local machine:
>ssh -p 222 localhost
>and connect to the LAN machine with address ${LANIP} on the ssh port.
> 
>Can you please confirm this is no longer available ? I get no error
>when I use it, but it doesn't work either... (while logging, the
>packets in the OUTPUT chain have destination 127.0.0.1, although it
>should be ${LANIP}; also the port is the same 222)
>
>Is there a way to activate/enable it ?
>
>If not, is there a way around it? I (would prefer not to have high
>level applications that do this, but rather do it in the kernel)

iptables -t raw -A OUTPUT 

>From a developer point of view it might seem useless to have
>something like this, since at any time one could just directly
>connect to that destination:port, without a loopback forwarding.
>However, I think this is at least useful for my particular
>situation:
> 
>I am a subnet inside another subnet and I have no access to the
>public router, other than getting DNS and having my connections
>routed.  So my WAN IP is not public. In order to access my router
>from the outside world, I am using a reverse ssh tunnel to a
>computer which is public and to which I have access. This reverse
>ssh tunnel is nothing but remote port forwarding of the ssh.
> 
>Using this reverse ssh tunnel, I can connect (ssh) to my router
>directly from outside by connecting to a local port on that public
>computer.
> 
>I would like to have the same for the other machines in my subnet: I
>want to forward some ports on my router towards the ssh ports of my
>LAN machines, and using the ssh reverse tunnel port forwarding I can
>connect to them from the outside world. This is where I would need
>the implicit source local NAT: these ports would be forwarded (by
>iptables) towards my subnet machines (ssh port).

Can't you just use a VPN solution like ipsec/openvpn for this?
