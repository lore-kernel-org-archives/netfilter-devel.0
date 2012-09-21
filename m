From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] nat: remove obsolete rcu_read_unlock call
Date: Fri, 21 Sep 2012 21:47:07 +0200
Message-ID: <20120921194707.GA32377@1984>
References: <20120920135133.GA21538@uweber-WS>
 <1348150485.31352.87.camel@edumazet-glaptop>
 <20120921100842.1608006f@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Ulrich Weber <ulrich.weber@sophos.com>,
	netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45573 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757656Ab2IUTrL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:47:11 -0400
Content-Disposition: inline
In-Reply-To: <20120921100842.1608006f@nehalam.linuxnetplumber.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 21, 2012 at 10:08:42AM -0700, Stephen Hemminger wrote:
> On Thu, 20 Sep 2012 16:14:45 +0200
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > On Thu, 2012-09-20 at 15:52 +0200, Ulrich Weber wrote:
> > > hlist walk in find_appropriate_src() is not protected anymore by rcu_read_lock(),
> > > so rcu_read_unlock() is unnecessary if in_range() matches.
> > > 
> > > Signed-off-by: Ulrich Weber <ulrich.weber@sophos.com>
> > > ---
> > >  net/netfilter/nf_nat_core.c |    4 +---
> > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > > 
> > > diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> > > index 1816ad3..125d832 100644
> > > --- a/net/netfilter/nf_nat_core.c
> > > +++ b/net/netfilter/nf_nat_core.c
> > > @@ -201,10 +201,8 @@ find_appropriate_src(struct net *net, u16 zone,
> > >  				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
> > >  			result->dst = tuple->dst;
> > >  
> > > -			if (in_range(l3proto, l4proto, result, range)) {
> > > -				rcu_read_unlock();
> > > +			if (in_range(l3proto, l4proto, result, range))
> > >  				return 1;
> > > -			}
> > >  		}
> > >  	}
> > >  	return 0;
> > 
> > 
> > This could explain the rcu_read_unlock() imbalance Stephen had (lockdep
> > splat with net-next)
> > 
> > 
> > How old is this bug ?
> > 
> > 
> > 
> 
> This fixes the lockdep splat I saw when staring KVM vm's with net-next and lockdep enabled

It's in my tree already.

I'll pass it to David asap. Thanks for the report.
