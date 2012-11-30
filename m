From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Handle routing changes for the MASQUERADE target
Date: Fri, 30 Nov 2012 23:28:23 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211302327520.16257@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1211302149050.16257@blackhole.kfki.hu> <20121130211147.GD31969@breakpoint.cc> <alpine.DEB.2.00.1211302222190.16257@blackhole.kfki.hu> <20121130214032.GF31969@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:35499 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab2K3W2Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Nov 2012 17:28:25 -0500
In-Reply-To: <20121130214032.GF31969@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 30 Nov 2012, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > > > +	if (nat->masq_index && hooknum == NF_INET_POST_ROUTING &&
> > > > +	    CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
> > > > +	    nat->masq_index != out->ifindex) {
> > > > +		/* Outgoing interface changed, destroy conntrack. */
> > > > +		nf_ct_kill_acct(cf, ctinfo, skb);
> > > > +		nf_ct_put(ct);
> > > 
> > > Hmm. Is the nf_ct_put() correct?
> > > nf_ct_kill invokes death_by_timeout(), which also puts ct.
> > 
> > nf_nat_ipv[46]_fn starts with "nf_ct_get", so that must be released. 
> 
> nf_ct_get() does not increase refcount :)

Ohh, right - I'm blind.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
