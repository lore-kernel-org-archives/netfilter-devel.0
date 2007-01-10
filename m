From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [PATCH/RFC 05/10] Remove local address check on IP output
Date: Wed, 10 Jan 2007 11:01:05 +0100
Message-ID: <200701101101.06274@nienna>
References: <20070103163357.14635.37754.stgit@nienna.balabit> <20070103163627.14635.88250.stgit@nienna.balabit> <45A48BEB.2070207@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45A48BEB.2070207@trash.net>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


  Hi,

On Wednesday 10 January 2007 07:47, Patrick McHardy wrote:
> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index 537b976..bb1158a 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -2498,11 +2498,6 @@ #endif
> >  		    ZERONET(oldflp->fl4_src))
> >  			goto out;
> >
> > -		/* It is equivalent to inet_addr_type(saddr) == RTN_LOCAL */
> > -		dev_out = ip_dev_find(oldflp->fl4_src);
> > -		if (dev_out == NULL)
> > -			goto out;
> > -
>
> I'm not sure how exactly this is used by applications, but couldn't you
> restrict this to sockets without freebind?

  I'll try to do so in the next incarnation of the patches. Thanks for the 
comment, it'd ineed be safer to do so.

  BTW, could anyone shed some light on exactly why that check is 
necessary? As far as I can see it prevents packets with a non-local 
source address being routed -- but I fail to see why we need to prevent 
that.

-- 
 Regards,
  Krisztian Kovacs
