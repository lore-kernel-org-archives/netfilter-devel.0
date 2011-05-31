From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.7 released
Date: Tue, 31 May 2011 22:13:58 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105312212210.29607@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1105312155260.29607@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:38868 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758325Ab1EaUOA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2011 16:14:00 -0400
In-Reply-To: <alpine.DEB.2.00.1105312155260.29607@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 31 May 2011, Jozsef Kadlecsik wrote:

> Besides a few bugfixes, ipset 6.7 comes with a new set type called 
> hash:net,iface. The new type makes possible to store network address and 
> interface name pairs in a set. That way egress and ingress filtering is 
> possible with ipset, in just a few rules. Just an example:
> 
> # Define the set for all your networks and fill it out
> ipset create nets hash:net
> ipset add nets 10.0.0.0/8
> ipset add nets 192.168.0.0/16
> ...
> # Define the set with the allowed network, interface pairs
> ipset create ifaces hash:net,iface
> ipset add ifaces 10.0.0.0/24,eth0
> ipset add ifaces 10.2.0.0/16,eth1
> ...
> # Create a chain to handle your networks

Sorry, chain here should be named as "ifaces" for the jump at the 
egress/ingress filtering below:

> iptables -N nets
> iptables -A nets -m set --match-set ifaces src,src -j ACCEPT
> iptables -A nets -j log-and-drop-spoofed-packets
> # Egress and ingress filtering
> iptables -t raw -A PREROUTING -m set --match-set nets src -j ifaces
> iptables -t raw -A PREROUTING -i external-iface0 -j ACCEPT
> iptables -t raw -A PREROUTING -i external-iface1 -j ACCEPT
> ...
> iptables -t raw -j log-and-drop-spoofed-packets
> # That's all :-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
