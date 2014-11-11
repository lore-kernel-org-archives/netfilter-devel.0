From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [patch -mainline] netfilter: ipset: small potential read beyond
 the end of buffer
Date: Tue, 11 Nov 2014 14:17:11 +0100
Message-ID: <20141111131702.GA8287@salvia>
References: <20141107062140.GA10905@mwanda>
 <20141110142446.GA29586@salvia>
 <alpine.DEB.2.10.1411101526480.2913@blackhole.kfki.hu>
 <20141110161121.GA7398@salvia>
 <alpine.DEB.2.10.1411102158430.8333@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sergey Popovich <popovich_sergei@mail.ru>,
	Masanari Iida <standby24x7@gmail.com>,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	stephen hemminger <stephen@networkplumber.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernddel.org, kernel-janitors@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37497 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbaKKNPS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:15:18 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1411102158430.8333@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 10, 2014 at 10:00:20PM +0100, Jozsef Kadlecsik wrote:
> On Mon, 10 Nov 2014, Pablo Neira Ayuso wrote:
> 
> > On Mon, Nov 10, 2014 at 03:27:51PM +0100, Jozsef Kadlecsik wrote:
> > > On Mon, 10 Nov 2014, Pablo Neira Ayuso wrote:
> > > > >From other similar code in that location, I can see Jozsef is using
> > > > this pattern:
> > > > 
> > > >                 if (*len != sizeof(struct ip_set_req_version)) {
> > > >                         ret = -EINVAL;
> > > >                         goto done;
> > > >                 }
> > > > 
> > > > I think it would be good to stick to that for consistency. Thanks.
> > > 
> > > Absolutely, yes.
> > > 
> > > Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > 
> > OK, then does this look fine to you? I took over Dan's patch and gave
> > it another spin. See it attached, thanks.
> 
> Yes, it's better this way, thanks!

Applied, thanks Dan and Jozsef.
