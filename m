From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH,RFC] Route match
Date: Fri, 4 Jul 2008 22:26:55 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807042222120.4142@blackhole.kfki.hu>
References: <20080703003942.GA2012@linuxace.com>
 <alpine.LNX.1.10.0807030913510.20393@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu> <486D2044.3090108@trash.net>
 <Pine.LNX.4.64.0807040004270.3107@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Phil Oester <kernel@linuxace.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:35436 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbYGDU05 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 16:26:57 -0400
In-Reply-To: <Pine.LNX.4.64.0807040004270.3107@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 4 Jul 2008, Jozsef Kadlecsik wrote:

> If there's dynamic routing (say OSPF), then sometimes it's not so easy at 
> all to write (static) iptables rules for egress/ingress filtering. That is 
> also a case where the route match can be important (besides the 
> possibility to log nasty packets when the routing is trivial).

I have to correct myself: when rp_filter produces false results then the 
route match does also at egress/ingress filtering.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
