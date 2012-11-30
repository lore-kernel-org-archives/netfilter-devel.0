From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] [PATCH] Handle routing changes for the MASQUERADE target
Date: Fri, 30 Nov 2012 21:14:54 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211302106080.16257@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1211292202150.25841@blackhole.kfki.hu> <20121129212640.GB26937@breakpoint.cc> <20121129223339.GA9370@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:54827 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab2K3UO4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:14:56 -0500
In-Reply-To: <20121129223339.GA9370@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 29 Nov 2012, Pablo Neira Ayuso wrote:

> On Thu, Nov 29, 2012 at 10:26:40PM +0100, Florian Westphal wrote:
> > Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > 
> > > --- a/net/ipv6/netfilter/ip6table_nat.c
> > > +++ b/net/ipv6/netfilter/ip6table_nat.c
> > > @@ -19,6 +19,7 @@
> > >  #include <net/netfilter/nf_nat.h>
> > >  #include <net/netfilter/nf_nat_core.h>
> > >  #include <net/netfilter/nf_nat_l3proto.h>
> > [..]
> > >  static const struct xt_table nf_nat_ipv6_table = {
> > > +		if (hooknum == NF_INET_POST_ROUTING &&
> > > +		    CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
> > > +		    nat->masq_index && nat->masq_index != out->ifindex) {
> > > +			/* Outgoing interface changed, kill ct.  */
> > > +			if (del_timer(&ct->timeout)) {
> > 
> > perhaps this could be a helper in include/net/netfilter/nf_nat.h?
> > 
> > It would avoid the code duplication and the needed #if IS_ENABLED() MASQ
> > check.
> 
> I'd suggest a hook function that is set via rcu_pointer_assign in the
> init path of the masquerade target.

I have started to write it but it looks over-complicated compared how tiny 
the code is: both ipt_MASQUERADE and ip6t_MASQUERADE could set the hook 
function, so either it requires an reference counter or there should be 
two hooks. And the actual function defined in the nat core, that means 
three exported objects. Also, the setting of the hook function must always 
be checked in nf_nat_ipv[46]_fn which is pretty same as checking 
masq_index first. I'm going to send the new version of the patch for 
comments.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
