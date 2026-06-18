Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9786D2C21D0
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 17:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781803980; cv=none; b=kN/h0SGoQu/Qcrp9xdLtV4YTuMqUd8YWvclHdxEm/yGo5YNjnG6H2XYqMBiE4zE0SYolkLa3j14FJewNXebn271ix0uUTzYRYxKnaTL893ijX/dsosASwCb059lRZUZvOKTszOgA0BiJNZjTKVgz5DqW7CGd486cmhlrykj5nJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781803980; c=relaxed/simple;
	bh=OrZEEHQkl38wB/X5WsxSpNXLEKhcVHLJrDM81sOj84s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jWaDwp5wVkj3m45aVSCQx5IUfpj9Hqy9KTxSpCDy3j1k/SLwnwNVobxpTlQnK9e+70qec9ejb0O5oFUpPXtwW1zJg8aX7bJmVtSORinAWPZmso4opo+Leb0zpJkn9B5z7OXFZUUwt2M+nRHxBsVVTBQFuBlx0VT/CEXHPuWe5/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 81D3B60541; Thu, 18 Jun 2026 19:32:56 +0200 (CEST)
Date: Thu, 18 Jun 2026 19:32:50 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	phil@nwl.cc
Subject: Re: [PATCH 4/9 nf-next] netfilter: conntrack: use
 DEBUG_NET_WARN_ON_ONCE on packet paths
Message-ID: <ajQrwgb0GkKG-utR@strlen.de>
References: <20260601193049.8131-1-fmancera@suse.de>
 <20260601193049.8131-5-fmancera@suse.de>
 <ajQmsQsCbwJb5P7W@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajQmsQsCbwJb5P7W@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
> > index 32148a3a8509..0f39cb147c4f 100644
> > --- a/net/netfilter/nf_conntrack_proto_icmp.c
> > +++ b/net/netfilter/nf_conntrack_proto_icmp.c
> > @@ -117,7 +117,8 @@ int nf_conntrack_inet_error(struct nf_conn *tmpl, struct sk_buff *skb,
> >  	enum ip_conntrack_dir dir;
> >  	struct nf_conn *ct;
> >  
> > -	WARN_ON(skb_nfct(skb));
> > +	if (unlikely(skb_nfct(skb)))
> > +		DEBUG_NET_WARN_ON_ONCE(1);

Should be
DEBUG_NET_WARN_ON_ONCE(skb_nfct(skb)));
?

> nf_conntrack_in
>  [ reset skb->nfct ]
>  nf_conntrack_handle_icmp
>   nf_conntrack_icmpv4_error
>    nf_conntrack_inet_error
> 
> There is nf_conntrack_inet_error() which performs the ct lookup.
> There is resolve_normal_ct() too, but these two are coming later.
> 
> [ ... snippet that resets skb->nfct ... ]
> unsigned int
> nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
> {
>         enum ip_conntrack_info ctinfo;
>         struct nf_conn *ct, *tmpl;
>         u_int8_t protonum;
>         int dataoff, ret;
>  
>         tmpl = nf_ct_get(skb, &ctinfo);
>         if (tmpl || ctinfo == IP_CT_UNTRACKED) {
>                 /* Previously seen (loopback or untracked)?  Ignore. */
>                 if ((tmpl && !nf_ct_is_template(tmpl)) ||
>                      ctinfo == IP_CT_UNTRACKED)
>                         return NF_ACCEPT;
>                 skb->_nfct = 0; <---------  this is reset here.
>         }
> [ end of snippet ]
> 
> I don't remember to have seen this WARN_ON, so remove it.

I would keep the DEBUG_NET_WARN_ON_ONCE(), else this gives a
refcount leak.

Or, move it closer to the end:

191         /* Update skb to refer to this connection */
	HERE.
192         nf_ct_set(skb, ct, ctinfo);
193         return NF_ACCEPT;
194 }
