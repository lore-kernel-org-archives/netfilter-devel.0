From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [patch -mainline] netfilter: ipset: small potential read beyond
 the end of buffer
Date: Mon, 10 Nov 2014 22:00:20 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1411102158430.8333@blackhole.kfki.hu>
References: <20141107062140.GA10905@mwanda> <20141110142446.GA29586@salvia> <alpine.DEB.2.10.1411101526480.2913@blackhole.kfki.hu> <20141110161121.GA7398@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sergey Popovich <popovich_sergei@mail.ru>,
	Masanari Iida <standby24x7@gmail.com>,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	stephen hemminger <stephen@networkplumber.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernddel.org, kernel-janitors@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:38078 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaKJU7g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:59:36 -0500
In-Reply-To: <20141110161121.GA7398@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 10 Nov 2014, Pablo Neira Ayuso wrote:

> On Mon, Nov 10, 2014 at 03:27:51PM +0100, Jozsef Kadlecsik wrote:
> > On Mon, 10 Nov 2014, Pablo Neira Ayuso wrote:
> > > >From other similar code in that location, I can see Jozsef is using
> > > this pattern:
> > > 
> > >                 if (*len != sizeof(struct ip_set_req_version)) {
> > >                         ret = -EINVAL;
> > >                         goto done;
> > >                 }
> > > 
> > > I think it would be good to stick to that for consistency. Thanks.
> > 
> > Absolutely, yes.
> > 
> > Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> 
> OK, then does this look fine to you? I took over Dan's patch and gave
> it another spin. See it attached, thanks.

Yes, it's better this way, thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
