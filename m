From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/3] netfilter: factor out packet duplication for
 IPv4/IPv6
Date: Tue, 4 Aug 2015 19:27:07 +0200
Message-ID: <20150804172707.GA4079@salvia>
References: <1438684042-13709-1-git-send-email-pablo@netfilter.org>
 <1438684042-13709-2-git-send-email-pablo@netfilter.org>
 <20150804114810.GE20471@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57416 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbbHDRVL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 13:21:11 -0400
Content-Disposition: inline
In-Reply-To: <20150804114810.GE20471@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 04, 2015 at 01:48:10PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Extracted from the xtables TEE target. This creates two new modules for IPv4
> > and IPv6 that are shared between the TEE target and the new nf_tables dup
> > expressions.
> 
> > diff --git a/net/ipv4/netfilter/nf_dup_ipv4.c b/net/ipv4/netfilter/nf_dup_ipv4.c
> > new file mode 100644
> > index 0000000..feba24a
> > --- /dev/null
> > +++ b/net/ipv4/netfilter/nf_dup_ipv4.c
> > +unsigned int nf_dup_ipv4(struct sk_buff *skb, unsigned int hooknum,
> > +			 const struct in_addr *gw, int oif)
> > +{
> > +	struct iphdr *iph;
> > +
> > +	if (__this_cpu_read(nf_skb_duplicated))
> > +		return XT_CONTINUE;
> 
> Nit: seems function doesn't need to return anything.
> So the use of XT_* outisde xt core can be avoided.

Unless someone else finds any other problem, I'll fix this nit here
and apply. Thanks for spotting this Florian.
