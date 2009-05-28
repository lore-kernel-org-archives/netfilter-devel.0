From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP simultaneous open using iptables NAT?
Date: Thu, 28 May 2009 10:58:41 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905281014090.26723@blackhole.kfki.hu>
References: <4ddb24250905271506qb50323etf3f7deb4e240ff72@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Saatvik Agarwal <saatvik.agarwal@stanford.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:56778 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972AbZE1I6l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2009 04:58:41 -0400
In-Reply-To: <4ddb24250905271506qb50323etf3f7deb4e240ff72@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 27 May 2009, Saatvik Agarwal wrote:

> For my research project in school, I am trying to establish TCP
> connections when both hosts are behind full-cone NATs using TCP's
> simultaneous open functionality. Unfortunately, it seems that iptables
> does not support TCP simultaneous open. For my test environment, I
> simulate a full-cone NAT using iptables. My iptables rule is exactly
> as follows:
> 
> iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

That rule cannot simulate full-cone NAT, because netfilter implements 
port-restricted cone NAT.

> According to the BEHAVE requirements outlined in IETF RFC 5382, TCP
> simultaneous open must be supported by "well behaved NATs". So is
> there a mistake in my rules or does iptables not support simultaneous
> open?

The connection tracking subsystem does not support TCP simultaneous open.

As far as I'm concerned, I do not care whatever RFC is created in trying 
to push NAT over its limits - that is just a totally wrong track. NAT was 
invented solely to slow down the depletion of the IPv4 address space in 
the hope to give more time introducing and *deploying* IPv6 world-wide. 
And everyone was fully aware that NAT breaks one of the key concempts of 
IP, the end-to-end connectivity. These "NAT behavioral requirements" RFCs 
are the results of that breakage (and written exclusively from the point 
of view of the application designers).

It is no point trying to *put back* end-to-end connectivity on top of NAT 
when the clear and straight solution is to go to IPv6. 

The end-to-end connectivity is the very reason why I refuse the idea to 
implement NAT for IPv6 in netfilter. The damage what IPv4 NAT produced 
hasn't taught us not to repeat the same mistake again, willingly?

Best regads,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
