From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH net-next] nat: remove obsolete rcu_read_unlock call
Date: Fri, 21 Sep 2012 10:08:42 -0700
Message-ID: <20120921100842.1608006f@nehalam.linuxnetplumber.net>
References: <20120920135133.GA21538@uweber-WS>
	<1348150485.31352.87.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Ulrich Weber <ulrich.weber@sophos.com>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:44518 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab2IURJM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:09:12 -0400
In-Reply-To: <1348150485.31352.87.camel@edumazet-glaptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 20 Sep 2012 16:14:45 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> On Thu, 2012-09-20 at 15:52 +0200, Ulrich Weber wrote:
> > hlist walk in find_appropriate_src() is not protected anymore by rcu_read_lock(),
> > so rcu_read_unlock() is unnecessary if in_range() matches.
> > 
> > Signed-off-by: Ulrich Weber <ulrich.weber@sophos.com>
> > ---
> >  net/netfilter/nf_nat_core.c |    4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> > index 1816ad3..125d832 100644
> > --- a/net/netfilter/nf_nat_core.c
> > +++ b/net/netfilter/nf_nat_core.c
> > @@ -201,10 +201,8 @@ find_appropriate_src(struct net *net, u16 zone,
> >  				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
> >  			result->dst = tuple->dst;
> >  
> > -			if (in_range(l3proto, l4proto, result, range)) {
> > -				rcu_read_unlock();
> > +			if (in_range(l3proto, l4proto, result, range))
> >  				return 1;
> > -			}
> >  		}
> >  	}
> >  	return 0;
> 
> 
> This could explain the rcu_read_unlock() imbalance Stephen had (lockdep
> splat with net-next)
> 
> 
> How old is this bug ?
> 
> 
> 

This fixes the lockdep splat I saw when staring KVM vm's with net-next and lockdep enabled
