From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/2] IPv6 conntrack support for neighbour discovery
Date: Fri, 23 Jan 2009 10:50:59 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0901231049000.13848@blackhole.kfki.hu>
References: <200811050444.mA54i7XU020102@toshiba.co.jp>  <20081105133508.67b25090@hiperon.ws.hirg>  <1232581287.16003.47.camel@ice-age>  <200901230741.n0N7f0bx012043@toshiba.co.jp> <1232701347.32071.13.camel@khasse.inl.fr>
 <alpine.DEB.2.00.0901231032320.13848@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	Marek.Szuba@if.pw.edu.pl, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, vstinner@inl.fr,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:36248 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbZAWJvB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:51:01 -0500
In-Reply-To: <alpine.DEB.2.00.0901231032320.13848@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 23 Jan 2009, Jozsef Kadlecsik wrote:

> On Fri, 23 Jan 2009, Eric Leblond wrote:
> 
> > > How about just using NOTRACK target ?
> > 
> > This is a possible solution but you will then have to be a Netfilter
> > Jedi to build a correct IPv6 filtering ruleset. I think even Padawan
> > have no clue about the existence of the NOTRACK target.
> > 
> > Seriously speaking, the NOTRACK target is tagged "NETFILTER_ADVANCED"
> > and IPv6 is becoming more and more frequent. I don't think we should use
> > such a complicated solution for simply obtaining an IPv6 address. We
> > will loose quit a bunch of users on this.
> 
> RFC4890, Recommendations for Filtering ICMPv6 Messages in Firewalls, deals 
> with ICMPv6 filtering on firewalls in details and even contains a sample 
> ip6tables script.
> 
> Wouldn't it make sense to add simply the RFC to the iptables source tree, 
> and a sentence to the ip6tables manpage saying:
> 
> "Please read RFC 4890 and the sample script in it on how to filter ICMPv6
> properly in an IPv6 environment."

Looking through the sample script again, it is incomplete as it does not 
handle the ICMPv6 traffic targeted to/sent from the firewall itself. But 
it'd be not hard to add the missing rules.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
