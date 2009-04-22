From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Add support to log original and NAT-ed IP addresses
Date: Wed, 22 Apr 2009 22:39:42 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0904222234570.10604@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0904201012170.10463@blackhole.kfki.hu> <49EC474E.8090604@netfilter.org> <alpine.DEB.2.00.0904201200240.10463@blackhole.kfki.hu> <49EC5794.8090204@netfilter.org> <alpine.DEB.2.00.0904201315030.10463@blackhole.kfki.hu>
 <49EC896E.5070402@trash.net> <alpine.DEB.2.00.0904201838090.11586@blackhole.kfki.hu> <49EDBA7E.2040200@trash.net> <alpine.DEB.2.00.0904211939040.7297@blackhole.kfki.hu> <49EF3EE4.1090204@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:42419 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbZDVUjn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:39:43 -0400
In-Reply-To: <49EF3EE4.1090204@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 22 Apr 2009, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
> > On Tue, 21 Apr 2009, Patrick McHardy wrote:
> > 
> > > I can see that it has some informational value, but for things like
> > > locating infected hosts, why not simply look at the traffic before
> > > it is NATed? I currently can't come up with a real use case for
> > > this ...
> > 
> > The well-maintained sites manage to locate on-site infected machines by
> > using IDS, traffic-analysis, etc. However the typical user case for small
> > sites is that the ISP or other offsite host report an abuse: "your machine
> > x.y.z.w attacked machine a.b.c.d/added to the RBL because of spamming/etc" -
> > and the machine x.y.z.w is of course their firewall. And they have got
> > nothing which could help them to pick the real machine from the NATed
> > network behind the firewall. And the small sites is the main reason why I'd
> > favor an "out of the box" solution, which does not rely on anything besides
> > netfilter/iptables.
> 
> Yes, but at that point, you can look at your logfiles and see who
> connected to a.b.c.d and you'll see the internal address. Logging
> the NATed address is not really helping since you need the internal
> address anyways, so it seems natural to look at the unNATed information.
> What am I missing here?

Hmm, if there are multiple clients connecting to the same external node 
(or even just a few ones but the exact time is not definite due to the 
unsynced clocks) then the hunted client does not stand out. But it might 
indicate multiple infected machines as well...

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
