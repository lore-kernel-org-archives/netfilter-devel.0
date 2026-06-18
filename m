Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C76734E763
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 18:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781806513; cv=none; b=PAOkLgjODa6F04mjWfXIeAKiGppfMjZyeeKYCRYO2nr1qygQQHttX9ljIvQKzSZkEeYdnIq59rqqJrMZLDBTykhRLXzOFvCfaSDkjJLItusQC1x4a5IYORlXJlfK8Nul5fdjG2Pu5++IcbvMWreq44HopoLI4x+nURn1zwToeBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781806513; c=relaxed/simple;
	bh=l0etzyIhd/L4YSZJ01TV0wieQ43X7+HIBkO7zz3dzro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FpAeQdMaHPI4vMsvbdLxHlBu5GuouTq9rdOQX013VeUXjqEuMdMdL4wG24BbTr7kfYhqIYGFxGkIW86OO58Iy4cic/y8UJirTZDsHrimZe9tTCWpmpv7IrExEDI3SoPicnfqJfwnuxZkR8eqfcInGaCMOOPFhpVdPLWcN9cu964=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hTh+YKRV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hTh+YKRV"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id D1BC06017E;
	Thu, 18 Jun 2026 20:15:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781806509;
	bh=njhJ+ybtTz7SzXaye1JlzWzoykAm2dRtsS97CyWtcQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hTh+YKRV6do+O79o4+Vfgha36ZQJkisyDeH2RPBPLZezu1sRBRgOSECipEom8I5Fb
	 GJOYUlFLSMcDRmQn47X0OeeQvoa3ye63mFYnMZREF7kef9KBElTujdZLBeezwYkSFX
	 6j+ZX4Yoo21RVllswyO8qS0JMEVmIfe7YELDRVmATKR25WO//qxrSIUO2FTlJWAP3R
	 b0J1BNnOvQp1mx7TJoVwP4xKTcxWsmI3FBukAKOgR+gptGQIdBuv/bf0grspLMnhX3
	 NYOvsqpmwb8C45Uhx7zZ89hXzzmfBJGvl8uARZe6a6MPQwZJIUSmQ9dyIRJAl6+o42
	 QvHTnTvDqXQFw==
Date: Thu, 18 Jun 2026 20:15:06 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	phil@nwl.cc
Subject: Re: [PATCH 4/9 nf-next] netfilter: conntrack: use
 DEBUG_NET_WARN_ON_ONCE on packet paths
Message-ID: <ajQ1qvJ-7Lw7GryP@chamomile>
References: <20260601193049.8131-1-fmancera@suse.de>
 <20260601193049.8131-5-fmancera@suse.de>
 <ajQmsQsCbwJb5P7W@chamomile>
 <ajQrwgb0GkKG-utR@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ajQrwgb0GkKG-utR@strlen.de>

On Thu, Jun 18, 2026 at 07:32:50PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
> > > index 32148a3a8509..0f39cb147c4f 100644
> > > --- a/net/netfilter/nf_conntrack_proto_icmp.c
> > > +++ b/net/netfilter/nf_conntrack_proto_icmp.c
> > > @@ -117,7 +117,8 @@ int nf_conntrack_inet_error(struct nf_conn *tmpl, struct sk_buff *skb,
> > >  	enum ip_conntrack_dir dir;
> > >  	struct nf_conn *ct;
> > >  
> > > -	WARN_ON(skb_nfct(skb));
> > > +	if (unlikely(skb_nfct(skb)))
> > > +		DEBUG_NET_WARN_ON_ONCE(1);
> 
> Should be
> DEBUG_NET_WARN_ON_ONCE(skb_nfct(skb)));
> ?
> 
> > nf_conntrack_in
> >  [ reset skb->nfct ]
> >  nf_conntrack_handle_icmp
> >   nf_conntrack_icmpv4_error
> >    nf_conntrack_inet_error
> > 
> > There is nf_conntrack_inet_error() which performs the ct lookup.
> > There is resolve_normal_ct() too, but these two are coming later.
> > 
> > [ ... snippet that resets skb->nfct ... ]
> > unsigned int
> > nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
> > {
> >         enum ip_conntrack_info ctinfo;
> >         struct nf_conn *ct, *tmpl;
> >         u_int8_t protonum;
> >         int dataoff, ret;
> >  
> >         tmpl = nf_ct_get(skb, &ctinfo);
> >         if (tmpl || ctinfo == IP_CT_UNTRACKED) {
> >                 /* Previously seen (loopback or untracked)?  Ignore. */
> >                 if ((tmpl && !nf_ct_is_template(tmpl)) ||
> >                      ctinfo == IP_CT_UNTRACKED)
> >                         return NF_ACCEPT;
> >                 skb->_nfct = 0; <---------  this is reset here.
> >         }
> > [ end of snippet ]
> > 
> > I don't remember to have seen this WARN_ON, so remove it.
> 
> I would keep the DEBUG_NET_WARN_ON_ONCE(), else this gives a
> refcount leak.
> 
> Or, move it closer to the end:
> 
> 191         /* Update skb to refer to this connection */
> 	HERE.
> 192         nf_ct_set(skb, ct, ctinfo);
> 193         return NF_ACCEPT;
> 194 }

OK, let's keep it around. Thanks.
