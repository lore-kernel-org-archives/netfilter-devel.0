Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F70415F31;
	Thu, 30 Jul 2026 11:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785409600; cv=none; b=rNa8EKyXryAeAwqNPA5AQcv4qzScwSjGBc7SKn0eMh9MdEpoHO/x4Kdty387crHph8A7ja7gXmuwaQdHU8mqNpJBwTUHhoE+139Lx6zN39O3AU6f7DpKwJkcCncP+azwci5SxuFJg5QrK9RjEZYswQ8rJ8JPV0Skwi5B0SECbH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785409600; c=relaxed/simple;
	bh=+N6Dgyl+1YGCN+0oVHPkWxB3BueTGxm6due7AUfEiiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OQ87UpsJeRTZpvpLZ1lSoaC1H+POQTuUOS7XLGfPmYxTyUUMPeRCB4qdBtydW4LofUZVQitGbgAYdyKkCVeLvP6sdRgbylJHqrvh+Wme4Jil2cSrzzqiz3w3qsjzx1UQJZSVRhaqpHf9VuBjkOP1h+JYCTcto8ZUzpEkEOHq4U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 209A460301; Thu, 30 Jul 2026 13:06:28 +0200 (CEST)
Date: Thu, 30 Jul 2026 13:06:27 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Zhiling Zou <zhilinz@nebusec.ai>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, kaber@trash.net, zhaojignmin@hotmail.com,
	vega@nebusec.ai
Subject: Re: [PATCH nf v2 1/1] netfilter: validate L4 headers after userspace
 packet writes
Message-ID: <amswI7g2oCttFAvH@strlen.de>
References: <f0efaa7d67a580488fc5e32a09683c992db35742.1785392716.git.zhilinz@nebusec.ai>
 <amsoo3ZjITWDE5qy@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <amsoo3ZjITWDE5qy@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +	const struct nf_conn *ct;
> > +
> > +	ct =3D nf_ct_get(e->skb, &ctinfo);
> > +	if (ct && !nf_ct_is_template(ct) && nf_ct_protonum(ct) !=3D proto)
>=20
> I think it should be easier to disallow protocol number mangling in
> the IP header (layer 3 restrictions), if not done already.

How?  nfqueue is whole-replace, not a delta.
Or do you mean checking ip_hdr(skb) vs. the protocol field in userspace
provided buffer?

I would prefer this solution (i.e. check ct protocol), it still allows theo=
retical nfqueue based
tunneling header insertion, if done in prerouting before conntrack.

> > +	switch (proto) {
> > +	case IPPROTO_TCP: {
> > +		const struct tcphdr *th =3D (const struct tcphdr *)data;
>=20
> This needs to use skb_header_pointer() here, you cannot assume the tcp
> header is in a linear area.

data is a linear buffer coming from userspace
(nla_data(nfqa[NFQA_PAYLOAD]).

> > +	case IPPROTO_SCTP:
> > +		return data_len >=3D sizeof(struct sctphdr);
> > +	case IPPROTO_GRE:
> > +		return data_len >=3D sizeof(struct gre_base_hdr);
> > +	case IPPROTO_NONE:
>=20
> Remove this and make it part of default and return true if protocol is
> unknown.

Hmm.  Its likely safe to accept unknown headers, here.

Perhaps next iteration should indeed do what you suggest but also check
check ESP and AH.

> Default is false for an unknown protocol, should be true.

I suggested it this way, i.e. don't permit unknown l4 protocols, but
maybe its too restrictive.

> > +	if (pkt->tprot !=3D IPPROTO_TCP)
> > +		return true;
> > +
> > +	return priv->offset > doff || priv->offset + priv->len <=3D doff;
>                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>=20
> maybe simply check priv->offset >=3D doff here?

Could you elaborate?  The above LGTM.  priv->offset > doff is already
tested?  I mean, write is ok either if offset exceeds doff (lhs)
or if offset + length doesn't touch doff area (rhs).

Did you mean "just reject everything exceeding doff"?

Patch LGTM, except perhaps switching to "allow unknowns" in nfqueue.
