From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Add support to log original and NAT-ed IP addresses
Date: Mon, 20 Apr 2009 18:47:18 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0904201838090.11586@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0904201012170.10463@blackhole.kfki.hu> <49EC474E.8090604@netfilter.org> <alpine.DEB.2.00.0904201200240.10463@blackhole.kfki.hu> <49EC5794.8090204@netfilter.org> <alpine.DEB.2.00.0904201315030.10463@blackhole.kfki.hu>
 <49EC896E.5070402@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:57920 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbZDTQrT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Apr 2009 12:47:19 -0400
In-Reply-To: <49EC896E.5070402@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 20 Apr 2009, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
> > On Mon, 20 Apr 2009, Pablo Neira Ayuso wrote:
> > > I wasn't refering to any iptables target. New ulogd2 includes support
> > > for ctnetlink, which can do this. I know, that means the extra libraries
> > > dependencies.
> > 
> > I see. Thanks the info, good to know that ulogd2 is capable of this.
> > (Calling 'conntrack' for logging looked really ugly. :-)
> 
> In the kernel, we could log the information from the conntrack
> entry, if any. That would allow to log the manips after they
> have been set up.

Yes, but I'd not want an unconditional logging.
 
> Would Pablo's suggestion or the conntrack method work for you?

Oh, it's not for me at all: at a workshop I was asked how to log the info 
(hint: conflicker ;-) and embarrased enough I had to admit there was no 
easy way. That's why I put together the patch, with all it's questionable 
details.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
