From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Add seperated timeout for the connections that only receive
 packets in one direction
Date: Tue, 1 Dec 2009 10:14:21 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0912010940390.575@blackhole.kfki.hu>
References: <4B0FA3AA.4070702@trash.net> <4B0FBC5F.8030108@trash.net> <412e6f7f0911292039v74b89b4cieca5e2a043bad43d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:54643 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbZLAJOQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Dec 2009 04:14:16 -0500
In-Reply-To: <412e6f7f0911292039v74b89b4cieca5e2a043bad43d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 30 Nov 2009, Changli Gao wrote:

> Think about this topologic:
> 
> Attacker -> router1 -> router2 -> ... -> Linux Router -> Apache.
> 
> the packets in the other direction won't be sent to the Linux Router,
> as the other routers will routed them to the other place.

Sorry, I don't get it. 

If the attacker forges the source IP of the packet so that Apache thinks 
it's a local machine from its own point of view and answers it on the LAN, 
then that's the fault of the Linux Router operator: ingress and egress 
filtering is a must, period.

If the attacker forges the source IP of the packet otherwise so that 
Apache thinks it's a non local machine, then Apache will send the answer 
via the Linux Router regardless of the routing table of any router out 
there.
 
> Case 2:
> 
> Attacker ---+
>                 +-- Linux Router --> WAN
> Victim-------+
> 
> If we do sth. like RPF before entering conntrack, the packets in the
> other direction won't be in.

Here again I don't understand it completely: if there's an attacker on the 
LAN, then the point is not to mitigate the load for the Linux Router but 
first to find the attacker and then to prevent source IP forging.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
