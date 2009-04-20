From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Add support to log original and NAT-ed IP addresses
Date: Mon, 20 Apr 2009 12:49:17 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0904201238480.10463@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0904201012170.10463@blackhole.kfki.hu> <49EC474E.8090604@netfilter.org> <alpine.DEB.2.00.0904201200240.10463@blackhole.kfki.hu> <alpine.LSU.2.00.0904201231270.13423@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:40303 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327AbZDTKtS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Apr 2009 06:49:18 -0400
In-Reply-To: <alpine.LSU.2.00.0904201231270.13423@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 20 Apr 2009, Jan Engelhardt wrote:

> On Monday 2009-04-20 12:12, Jozsef Kadlecsik wrote:
> >
> >But ulogd2 requires the ULOG target
> 
> What purpose would NFLOG serve then?

Thanks for the correction. Still, whatever log target we consider 
(LOG/ULOG/NFLOG), currently there's no hook point at which a rule could be 
added to log the original and (src) NAT-ed IP addresses.
 
> >> I think that Patrick is not going to like the idea of adding more hooks,
> >> what do you think Patrick?
> >
> >Yes, the additional hook is suboptimal. But I couldn't find any other 
> >way to get the data.
> 
> The rawpost_table, as in the RAWNAT branch of Xtables-addons. While
> the additional table is probably just as suboptimal, at least you
> can unload it.

Increasing the number of the tables? I'd better add a module parameter to 
define the really used hook entry points for the tables (raw, mangle and 
maybe nat).
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
