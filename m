From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 0/2] IPv6 conntrack support for neighbour discovery
Date: Fri, 23 Jan 2009 20:10:26 +0900 (JST)
Message-ID: <200901231110.n0NBARDe000646@toshiba.co.jp>
References: <1232701347.32071.13.camel@khasse.inl.fr>
	<200901231021.n0NALINO007201@toshiba.co.jp>
	<1232707890.32071.41.camel@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yasuyuki.kozakai@toshiba.co.jp, Marek.Szuba@if.pw.edu.pl,
	kaber@trash.net, netfilter-devel@vger.kernel.org, vstinner@inl.fr,
	pablo@netfilter.org
To: eric@inl.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inet-tsb5.toshiba.co.jp ([202.33.96.24]:61198 "EHLO
	imx2.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbZAWLKb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jan 2009 06:10:31 -0500
Received: from arc1.toshiba.co.jp ([133.199.194.235])
	by imx2.toshiba.co.jp  with ESMTP id n0NBAS0T024120
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2009 20:10:28 +0900 (JST)
Received: (from root@localhost)
	by arc1.toshiba.co.jp  id n0NBASX6004553
	for netfilter-devel@vger.kernel.org; Fri, 23 Jan 2009 20:10:28 +0900 (JST)
Received: from mx12.toshiba.co.jp (localhost [127.0.0.1])
	by ovp2.toshiba.co.jp  with ESMTP id n0NBARfR007345
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2009 20:10:27 +0900 (JST)
In-Reply-To: <1232707890.32071.41.camel@khasse.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

From: Eric Leblond <eric@inl.fr>
Date: Fri, 23 Jan 2009 11:51:30 +0100

> > >  static bool icmpv6_invert_tuple(struct nf_conntrack_tuple *tuple,
> > >  				const struct nf_conntrack_tuple *orig)
> > >  {
> > >  	int type = orig->dst.u.icmp.type - 128;
> > > -	if (type < 0 || type >= sizeof(invmap) || !invmap[type])
> > > +
> > > +	if (type < 0 || type >= sizeof(invmap) || !invmap[type]) {
> > >  		return false;
> > > +	}
> > 
> > Really is this change necessary ?
> 
> I've resend the patch without this change. It was forgotten during a
> merge of previous work. Sorry for that.

Ah, sorry & thank you for noticing.


> > > @@ -198,6 +212,17 @@ icmpv6_error(struct net *net, struct sk_buff *skb, unsigned int dataoff,
> > >  		return -NF_ACCEPT;
> > >  	}
> > >  
> > > +	/* autoconf message handling */
> > > +	if (nf_ct_icmpv6_autoconf) {
> > > +		int type = icmp6h->icmp6_type - 130;
> > > +		if (type >= 0 && type < sizeof(noct_valid_new)
> > > +		    && noct_valid_new[type]) {
> > > +			skb->nfct = &nf_conntrack_untracked.ct_general;
> > > +			skb->nfctinfo = IP_CT_NEW;
> > > +			nf_conntrack_get(skb->nfct);
> > > +			return -NF_ACCEPT;
> > > +		}
> > > +	}
> > 
> > I prefer 'NEW' rather than 'UNTRACKED' as other protocols which
> > validation is unclear. So another solution is to let the connection
> > tracking subsystem to create a new conntrack and to make
> > nf_contrack_proto_icmpv6 assign 0 as timeout. How do you think ?
> 
> If we do that, we can have nfnetlink messages (NEW, DESTROY) send to
> userspace. Personnaly, I don't think they are necessary. But there is an
> other issue: as we can't invert the tuple, the information provided to
> userspace will be false.
>
> Once we agree on this last point, I will send a reworked patchset (with
> at least the removal of sysctl stuff).

Thank you. I understand why ICMPv6 packets are special here and
I agree to assign UNTRACKED to them. Indeed non-invertible tuple might
bring issues.

-- Yasuyuki Kozakai
