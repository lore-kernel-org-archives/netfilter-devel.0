From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH,RFC] Route match
Date: Fri, 4 Jul 2008 00:21:11 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807040004270.3107@blackhole.kfki.hu>
References: <20080703003942.GA2012@linuxace.com>
 <alpine.LNX.1.10.0807030913510.20393@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu> <486D2044.3090108@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Phil Oester <kernel@linuxace.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:44622 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133AbYGCWVN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 18:21:13 -0400
In-Reply-To: <486D2044.3090108@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 3 Jul 2008, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
> > On Thu, 3 Jul 2008, Jan Engelhardt wrote:
> > 
> > > > TODO: add IPv6 support to kernel side
> > > > 
> > > > Examples:
> > > > 
> > > > 	Egress filtering:
> > > > 		iptables -A FORWARD -m route ! --route-src-exists -j DROP
> > > That's what rp_filter is for.
> > > 
> > > > 	Ingress filtering:
> > > > 		iptables -A FORWARD -i $EXTERNAL_IF -m route
> > > > --route-src-exists -j DROP
> > > rp_filter again.
> > 
> > Quick and not good examples, I'd say. The main problem with rp_filter is
> > that it drops the packets >silently<. The real benefit of such a match is
> > the possibility to log (and drop) faked packets. If the patch had IPv6
> > support, one could add that additionally (as far as I know) there's no
> > rp_filter for IPv6 at all.
> 
> I agree. While I find rp_filter highly annoying (Debian has it enabled
> by default), this patch at least allows you to notice whats going on
> easily. I'm also sure there are people who would like to use rp_filter
> like functionality for IPv6.

A single loop in the routing paths is enough and rp_filter enabled ruins 
everything. :-)

If there's dynamic routing (say OSPF), then sometimes it's not so easy at 
all to write (static) iptables rules for egress/ingress filtering. That is 
also a case where the route match can be important (besides the 
possibility to log nasty packets when the routing is trivial).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
