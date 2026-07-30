Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F90D34B1A7;
	Thu, 30 Jul 2026 11:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785411299; cv=none; b=K/vvSLZ74vsKCLsYx6Oykr3OM/LuQcz60hiBRZzPB6MSCTCpeQRKrGGwiM1rKbPcEf0/qNRu0GPQkSC/TN2ujPjF6pZrRexbIZ1mULAurvBJjFuLTUPMgfjCo12XzHNUyDjUSDzd45lfyeBsWx3t7+31mOrNJFZ2LOUWE+dJqiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785411299; c=relaxed/simple;
	bh=RVYNZSVp/aCa6Bj3isOk/fCqOOdnY83/mwFzZXTFFTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AeEBUIiF+zrFIcj3xFPhBb0wBpVAXTJJ0LdcH3qyrawcMYLeE9Huj8gJ5IlrFrpUBzH34DfwwffpDbga3IYbItjozBGuJQbjQm+rH8EQrM5dOyxSBeXVnvxjhHtjB9mnOCv92uBotpBNyVSXbVzPDcRz7+F8qO9LOnlkURzwWKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AfdkaIQO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AfdkaIQO"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 006DF60191;
	Thu, 30 Jul 2026 13:34:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785411295;
	bh=SHM1MDOaW+doB9WJWI/P4+8Yuq+C3DwESvul5h5nLVE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AfdkaIQOxwWCjpwuj0hM3+0bBPo6ASkDKLr69THcULsupy0ij4yJayVficQLFe5G+
	 TrFcDZDyYpPkCtmknzL9PdGfgE7Chxk4eO1s37bfcqz1oqu+vMxJQJQfSwWKDlmcpQ
	 9+mrP9V2it+NizkTazScJfax5RV/gJzm31r2rIG+w/gvW+rGLovCl2AR7sTpCrtotb
	 HjyS8IFS6HY8XK9B6Plw9NpZDTX5IIHY/cRDMvCT9hOBPG3rIDF6653fhWa7DUIM5g
	 ZJPT778gj0A2oE5WsckjXvBzaqoYqLlSBkj/+mUj5FKz3AEvn1olKW1gefau4RxhFj
	 ggp7zuPHHMdvg==
Date: Thu, 30 Jul 2026 13:34:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Zhiling Zou <zhilinz@nebusec.ai>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, kaber@trash.net, zhaojignmin@hotmail.com,
	vega@nebusec.ai
Subject: Re: [PATCH nf v2 1/1] netfilter: validate L4 headers after userspace
 packet writes
Message-ID: <ams22yfvR5oNSxIN@chamomile>
References: <f0efaa7d67a580488fc5e32a09683c992db35742.1785392716.git.zhilinz@nebusec.ai>
 <amsoo3ZjITWDE5qy@chamomile>
 <amswI7g2oCttFAvH@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <amswI7g2oCttFAvH@strlen.de>

On Thu, Jul 30, 2026 at 01:06:27PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > +	const struct nf_conn *ct;
> > > +
> > > +	ct = nf_ct_get(e->skb, &ctinfo);
> > > +	if (ct && !nf_ct_is_template(ct) && nf_ct_protonum(ct) != proto)
> > 
> > I think it should be easier to disallow protocol number mangling in
> > the IP header (layer 3 restrictions), if not done already.
> 
> How?  nfqueue is whole-replace, not a delta.
> Or do you mean checking ip_hdr(skb) vs. the protocol field in userspace
> provided buffer?
> 
> I would prefer this solution (i.e. check ct protocol), it still allows theoretical nfqueue based
> tunneling header insertion, if done in prerouting before conntrack.

OK

> > > +	switch (proto) {
> > > +	case IPPROTO_TCP: {
> > > +		const struct tcphdr *th = (const struct tcphdr *)data;
> > 
> > This needs to use skb_header_pointer() here, you cannot assume the tcp
> > header is in a linear area.
> 
> data is a linear buffer coming from userspace
> (nla_data(nfqa[NFQA_PAYLOAD]).

Indeed.

> > > +	case IPPROTO_SCTP:
> > > +		return data_len >= sizeof(struct sctphdr);
> > > +	case IPPROTO_GRE:
> > > +		return data_len >= sizeof(struct gre_base_hdr);
> > > +	case IPPROTO_NONE:
> > 
> > Remove this and make it part of default and return true if protocol is
> > unknown.
> 
> Hmm.  Its likely safe to accept unknown headers, here.
> 
> Perhaps next iteration should indeed do what you suggest but also check
> check ESP and AH.
> 
> > Default is false for an unknown protocol, should be true.
> 
> I suggested it this way, i.e. don't permit unknown l4 protocols, but
> maybe its too restrictive.
> 
> > > +	if (pkt->tprot != IPPROTO_TCP)
> > > +		return true;
> > > +
> > > +	return priv->offset > doff || priv->offset + priv->len <= doff;
> >                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > maybe simply check priv->offset >= doff here?
> 
> Could you elaborate?  The above LGTM.  priv->offset > doff is already
> tested?  I mean, write is ok either if offset exceeds doff (lhs)
> or if offset + length doesn't touch doff area (rhs).
> 
> Did you mean "just reject everything exceeding doff"?
> 
> Patch LGTM, except perhaps switching to "allow unknowns" in nfqueue.

OK, thanks for explaining.
