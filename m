From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: ipset: bitmap:ip,mac: fix listing with
 timeout
Date: Fri, 19 Apr 2013 00:05:57 +0200
Message-ID: <20130418220557.GA6401@localhost>
References: <1365857474-4943-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1365857474-4943-2-git-send-email-kadlec@blackhole.kfki.hu>
 <20130416174441.GA3174@localhost>
 <alpine.DEB.2.00.1304162113270.18447@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Yoann JUET <yoann.juet@univ-nantes.fr>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43828 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936446Ab3DRWGD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Apr 2013 18:06:03 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1304162113270.18447@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Tue, Apr 16, 2013 at 09:16:18PM +0200, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> On Tue, 16 Apr 2013, Pablo Neira Ayuso wrote:
> 
> > On Sat, Apr 13, 2013 at 02:51:14PM +0200, Jozsef Kadlecsik wrote:
> > > The type when timeout support was enabled, could not list all elements,
> > > just the first ones which could fit into one netlink message: it just
> > > did not continue listing after the first message.
> > >
> > > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > > ---
> > >  net/netfilter/ipset/ip_set_bitmap_ipmac.c |    6 +++++-
> > >  1 files changed, 5 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> > > index 0f92dc2..d7df6ac 100644
> > > --- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> > > +++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> > > @@ -339,7 +339,11 @@ bitmap_ipmac_tlist(const struct ip_set *set,
> > >  nla_put_failure:
> > >  	nla_nest_cancel(skb, nested);
> > >  	ipset_nest_end(skb, atd);
> > 
> > I think this ipset_nest_end should be after the id == first checking.
> > It doesn't make sense for the -EMSGSIZE case.
> 
> Yes, that could be moved there - candidate for the nf-next tree?

Yes. This is not critical, send me a follow up this in a follow up
patch for nf-next.

> > BTW, in the first message, where `first' is unset, id will never equal
> > first and you will always return success even if you could not add one
> > single nested attribute into the message.
> 
> "first" is always initialized: it's either zero (the id of the first 
> entry) or the id of the next one where listing must be continued.

I see, that's OK.

I have applied this patch. Thanks.
