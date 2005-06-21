From: "David S. Miller" <davem@davemloft.net>
Subject: Re: 2.6.12: connection tracking broken?
Date: Tue, 21 Jun 2005 15:32:15 -0700 (PDT)
Message-ID: <20050621.153215.74747942.davem@davemloft.net>
References: <42B82F35.3040909@trash.net>
	<1119386772.3379.4.camel@localhost.localdomain>
	<20050621212317.GB9153@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: bdschuym@pandora.be, kaber@trash.net, bdschuym@telenet.be,
	herbert@gondor.apana.org.au, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, rankincj@yahoo.com,
	ebtables-devel@lists.sourceforge.net, netfilter-devel@manty.net
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262404AbVFUWog@vger.kernel.org>
To: chrisw@osdl.org
In-Reply-To: <20050621212317.GB9153@shell0.pdx.osdl.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Chris Wright <chrisw@osdl.org>
Subject: Re: 2.6.12: connection tracking broken?
Date: Tue, 21 Jun 2005 14:23:17 -0700

> * Bart De Schuymer (bdschuym@pandora.be) wrote:
> > Op di, 21-06-2005 te 17:16 +0200, schreef Patrick McHardy:
> > > I unfortunately don't see a way to remove it, but we should keep
> > > thinking about it. Can you please check if the attached patch is
> > > correct? It should exclude all packets handled by bridge-netfilter
> > > from having their conntrack reference dropped. I didn't add nf_reset()'s
> > > to the bridging code because with tc actions the packets can end up
> > > anywhere else anyway, and this will hopefully get fixed right sometime.
> > 
> > Looks good.
> 
> Is this one good for -stable?

We will push it to stable@kernel.org if we deem it should.

I do review the stream going into 2.6.x, and decide if it
should be bound for -stable as well, so you never need to
inquire about this specifically.
