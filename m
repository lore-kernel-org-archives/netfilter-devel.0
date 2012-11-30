From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] Handle routing changes for the MASQUERADE target
Date: Fri, 30 Nov 2012 22:40:32 +0100
Message-ID: <20121130214032.GF31969@breakpoint.cc>
References: <alpine.DEB.2.00.1211302149050.16257@blackhole.kfki.hu>
 <20121130211147.GD31969@breakpoint.cc>
 <alpine.DEB.2.00.1211302222190.16257@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35589 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755357Ab2K3Vkd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Nov 2012 16:40:33 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211302222190.16257@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > > +	if (nat->masq_index && hooknum == NF_INET_POST_ROUTING &&
> > > +	    CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
> > > +	    nat->masq_index != out->ifindex) {
> > > +		/* Outgoing interface changed, destroy conntrack. */
> > > +		nf_ct_kill_acct(cf, ctinfo, skb);
> > > +		nf_ct_put(ct);
> > 
> > Hmm. Is the nf_ct_put() correct?
> > nf_ct_kill invokes death_by_timeout(), which also puts ct.
> 
> nf_nat_ipv[46]_fn starts with "nf_ct_get", so that must be released. 

nf_ct_get() does not increase refcount :)

Regards,
Florian
