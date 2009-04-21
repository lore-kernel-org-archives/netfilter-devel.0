From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Add support to log original and NAT-ed IP addresses
Date: Tue, 21 Apr 2009 20:18:35 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0904211939040.7297@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0904201012170.10463@blackhole.kfki.hu> <49EC474E.8090604@netfilter.org> <alpine.DEB.2.00.0904201200240.10463@blackhole.kfki.hu> <49EC5794.8090204@netfilter.org> <alpine.DEB.2.00.0904201315030.10463@blackhole.kfki.hu>
 <49EC896E.5070402@trash.net> <alpine.DEB.2.00.0904201838090.11586@blackhole.kfki.hu> <49EDBA7E.2040200@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:49654 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbZDUSSh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:18:37 -0400
In-Reply-To: <49EDBA7E.2040200@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

On Tue, 21 Apr 2009, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
>
> > On Mon, 20 Apr 2009, Patrick McHardy wrote:
> >
> > > Jozsef Kadlecsik wrote:
> > Oh, it's not for me at all: at a workshop I was asked how to log the info
> > (hint: conflicker ;-) and embarrased enough I had to admit there was no easy
> > way. That's why I put together the patch, with all it's questionable
> > details.
> 
> I can see that it has some informational value, but for things like
> locating infected hosts, why not simply look at the traffic before
> it is NATed? I currently can't come up with a real use case for
> this ...

The well-maintained sites manage to locate on-site infected machines by 
using IDS, traffic-analysis, etc. However the typical user case for small 
sites is that the ISP or other offsite host report an abuse: "your machine 
x.y.z.w attacked machine a.b.c.d/added to the RBL because of spamming/etc" 
- and the machine x.y.z.w is of course their firewall. And they have got 
nothing which could help them to pick the real machine from the NATed 
network behind the firewall. And the small sites is the main reason why 
I'd favor an "out of the box" solution, which does not rely on anything 
besides netfilter/iptables.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
