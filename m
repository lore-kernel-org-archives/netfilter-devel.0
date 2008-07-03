From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH,RFC] Route match
Date: Fri, 4 Jul 2008 00:02:38 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807032348310.3107@blackhole.kfki.hu>
References: <20080703003942.GA2012@linuxace.com>
 <alpine.LNX.1.10.0807030913510.20393@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu>
 <alpine.LNX.1.10.0807031317090.23294@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0807031425530.1816@blackhole.kfki.hu>
 <alpine.LNX.1.10.0807031511310.23294@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0807031517350.1816@blackhole.kfki.hu>
 <alpine.LNX.1.10.0807031612330.23294@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:46280 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbYGCWCk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 18:02:40 -0400
In-Reply-To: <alpine.LNX.1.10.0807031612330.23294@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 3 Jul 2008, Jan Engelhardt wrote:

> On Thursday 2008-07-03 15:31, Jozsef Kadlecsik wrote:
> >On Thu, 3 Jul 2008, Jan Engelhardt wrote:
> >> On Thursday 2008-07-03 14:39, Jozsef Kadlecsik wrote:
> >> >
> >> >One can find a lot of smaller and bigger missing pieces, like a new table, 
> >> >new hook, if we'd associate a 'routing table' to a 'chain in the iptables 
> >> >route table', then we'd need a default policy support (i.e. default route) 
> >> >for the user defined chains too, etc.
> >> 
> >> User-defined chains always have an implicit policy of 'RETURN',
> >> and I would not turn a knob on that property anytime.
> >
> >Routing cannot be replaced by netfilter 'route' table without supporting a 
> >'default policy' (as default route) in the user defined chains (as routing 
> >tables).
> 
> User-defines chains return to the main chain once control runs off their end.
> Since the main chain has a default policy, I do not see aproblem.

That means we'd not support multiple routing tables with default routes.
We'd loose an important functionality, which is unacceptable.

[...] 
> >Unless you intend to define the 'default route' as the last rule in any 
> >chain...
> 
> No, default route would be
> 
> 	iptables -t route -A ROUTING <no further conditions> -j ROUTE --via
> my-default-gw-ip
> 
> Because traditional routing tables can have no default route,
> xtables should not be forced to have one either.

Routing tables can have default route. Most of the time this is the main 
point when using multiple routing tables: source routing via another
default route.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
