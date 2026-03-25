Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BC73E4C8B;
	Wed, 25 Mar 2026 17:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774460316; cv=none; b=VOZ+V7SCmZcXS/pyI0+tiyBnKUrYoaimsE3/oQTx2aG6D6MNnerZjwkX8mmJmnEtpmw1qp9cPEXB49CxUFNZ1ABHIRc5tawi90rjxdMVVUaFaWKdTreTUUekQljg9p4zwvs/mXWXsrMKZ8WXAub01V5nhGjSwdR+G+Qj/aaOsFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774460316; c=relaxed/simple;
	bh=i/PCW2KwbkSGnN7UFnNGlu/tnmgSOsRklYCvWppu7pU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iE0NTzxXXsi+JlWs0Lbrsgj5F//yvX1cTWq1w4y320PgP4OJIKwUxnzS+SYjFyyBUQw1gAqbF2eqFL+gmyYGyLbJCU4TD3RU8qPuFUUXnNFczFPtCTa6zNSUZaDfg87lqnzMUmdtJswqqiALT7c7Q46/NGBXXv3nrmy6pQmNz6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iQEDGglA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iQEDGglA"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5377B600B9;
	Wed, 25 Mar 2026 18:38:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774460313;
	bh=rRXcHrpcOVkMBFaBuInNnRfkXXu/rgto+v/iY4SduS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iQEDGglAVYhEpXWdWadAsO6dZeaqMrwThOuncC6TyEXiLeOHwoYdAu1YRlxmF740h
	 9nElGCkiH7tmrWvoBif7c+S90KH5NSmHmjLXwCNb+9ka88FERr/5atV+AHSME9rOzy
	 tmDMx0p49q7USHeJSeP5JLNgoXBkvuJ3gG5Jgy0P9gznaSRYhYOdQnietuunVoknYL
	 4x+PMnv8P+ehjSKKI4RT5pPQuTL0+ZzaYbY+MdQx9cjYcmXsJMdUNusF0+SD1UPTV4
	 OVDqbijSryVeJbj7agWiY7Fm3CW/wpoQ5ogKx7Y2VnCxTGKyy501yuwmsqu8PyjAMm
	 VdabeOUiqJjDA==
Date: Wed, 25 Mar 2026 18:38:30 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 10/14] netfilter: ctnetlink: ensure safe access to
 master conntrack
Message-ID: <acQdlj8hkZhKWnT4@chamomile>
References: <20260325131108.23045-1-fw@strlen.de>
 <20260325131108.23045-11-fw@strlen.de>
 <acQa30IdYh3PeLAh@chamomile>
 <acQbWvJUK20gbTWg@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <acQbWvJUK20gbTWg@strlen.de>

On Wed, Mar 25, 2026 at 06:28:58PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Sorry for this late followup incremental fix.
> 
> I'm tired.
> 
> > diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> > index 509d3eb6f56a..cf39662c4b97 100644
> > --- a/net/netfilter/nf_conntrack_expect.c
> > +++ b/net/netfilter/nf_conntrack_expect.c
> > @@ -325,7 +325,9 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
> >  		       u_int8_t proto, const __be16 *src, const __be16 *dst)
> >  {
> >  	struct net *net = read_pnet(&exp->master->ct_net);
> > -
> > +	struct nf_conntrack_helper *helper;
> > +	struct nf_conn *ct = exp->master;
> > +	struct nf_conn_help *help;
> >  	int len;
> >  
> >  	if (family == AF_INET)
> > @@ -336,7 +338,14 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
> >  	exp->flags = 0;
> >  	exp->class = class;
> >  	exp->expectfn = NULL;
> > -	rcu_assign_pointer(exp->helper, nfct_help(exp->master)->helper);
> > +	help = nfct_help(ct);
> 
> Do we have a reference here? Is that safe?

This ct is coming from the skb from packet path, while rcu_read_lock()
is held, the skb owns this ct.

> I'm not looking forward to a new PR.

Apologies.
