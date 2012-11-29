From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] [PATCH] Handle routing changes for the MASQUERADE target
Date: Thu, 29 Nov 2012 23:31:51 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211292328370.26251@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1211292202150.25841@blackhole.kfki.hu> <20121129212640.GB26937@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:46842 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304Ab2K2Wbx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:31:53 -0500
In-Reply-To: <20121129212640.GB26937@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Thu, 29 Nov 2012, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> 
> this looks really good, two minor nits below.
> 
> > diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
> > index ac635a7..128885d 100644
> > --- a/net/ipv4/netfilter/iptable_nat.c
> > +++ b/net/ipv4/netfilter/iptable_nat.c
> > @@ -17,6 +17,7 @@
> >  #include <net/netfilter/nf_nat.h>
> >  #include <net/netfilter/nf_nat_core.h>
> >  #include <net/netfilter/nf_nat_l3proto.h>
> > +#include <net/netfilter/nf_conntrack_ecache.h>
> >  
> >  static const struct xt_table nf_nat_ipv4_table = {
> >  	.name		= "nat",
> > @@ -134,6 +135,24 @@ nf_nat_ipv4_fn(unsigned int hooknum,
> >  		/* ESTABLISHED */
> >  		NF_CT_ASSERT(ctinfo == IP_CT_ESTABLISHED ||
> >  			     ctinfo == IP_CT_ESTABLISHED_REPLY);
> > +		if (hooknum == NF_INET_POST_ROUTING &&
> > +		    CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
> > +		    nat->masq_index && nat->masq_index != out->ifindex) {
> > +			/* Outgoing interface changed, kill ct.  */
> 
> Would it be possible to use nf_ct_kill_acct() here instead of
> 
> > +			if (del_timer(&ct->timeout)) {
> > +				if (nf_conntrack_event(IPCT_DESTROY, ct) < 0) {
> [..]

Yes, that'd be even better.
 
> > --- a/net/ipv6/netfilter/ip6table_nat.c
> > +++ b/net/ipv6/netfilter/ip6table_nat.c
> > @@ -19,6 +19,7 @@
> >  #include <net/netfilter/nf_nat.h>
> >  #include <net/netfilter/nf_nat_core.h>
> >  #include <net/netfilter/nf_nat_l3proto.h>
> [..]
> >  static const struct xt_table nf_nat_ipv6_table = {
> > +		if (hooknum == NF_INET_POST_ROUTING &&
> > +		    CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
> > +		    nat->masq_index && nat->masq_index != out->ifindex) {
> > +			/* Outgoing interface changed, kill ct.  */
> > +			if (del_timer(&ct->timeout)) {
> 
> perhaps this could be a helper in include/net/netfilter/nf_nat.h?
> 
> It would avoid the code duplication and the needed #if IS_ENABLED() MASQ
> check.

You mean an inline function? I'll send an updated version tomorrow :-).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
