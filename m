From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: latency increased X 10 on update
Date: Sat, 26 Nov 2011 00:04:52 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1111260001500.15815@blackhole.kfki.hu>
References: <4ED00C92.9030701@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: marty <martinbarrowcliff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:60007 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab1KYXEy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Nov 2011 18:04:54 -0500
In-Reply-To: <4ED00C92.9030701@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 25 Nov 2011, marty wrote:

> Using ipset-6.9.1 on Linux-3.1.1
> Only managing ipv4 traffic on Intel Atom-330 firewall.
> 
> Same iptables rules, however after updating from v4 code I see issues.
> Attacker sends a packet;
> I detect a unserved dest port and --add-set Blah src;
> LOG it, DROP it, and begone;
> But the set may not match for several further packets.
> Ouch. Buffers?
> 
> Blah is used as
> iptables -t raw -I PREROUTING  --match-set Blah src-j DROP
> This DROP is NEVER logged, but certainly counted.
> 
> However I often continue to log multiple packets from blocked hosts, despite I
> am supposedly blocking them on the first bad packet.
> I can confirm they are in the set but when packet_count exceeds 1 something is
> very wrong with that picture.

Please send exact data: the elements of the set at the given moment, the 
iptables rules and the log/counters which proves that something is wrong.

I don't really get how your subject is related to the text in your message 
body.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
