Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F312F508C
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 13:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752671402; cv=none; b=P/axVTzg+6OexBopKeM36D+OOVWCCNQRffM8kGVM7956iB4qOC0DTXkJLZzoYsTUHIoidfhSRej9mHSNjO6xFDx5knYW+ScsHgwi1yVWl5DS1lDIeNvaPquQgriZLQaqFd711/nhKj/doIXE1QKsh+Q3UK6f1scd7kmDuATsTdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752671402; c=relaxed/simple;
	bh=CYZ6D3w0YlMPIYKKny6SLQOCorVbQFgDgiURkmyHi/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aqf60qBB6JkaMw/mdtGRBD7YhmUub53HIj5PClNKdvQPeeFB4MV3Bssb88O7RIwxLkNZ4KFrvjsI4KQipoGZ6G7iQQp9dwhvS+qNMT/H21LPD+Vd4lseYDKYVUEdza1x7q0avGWgqJMloaHSvBZUTdPL2WK4Bt/GQnWKvghGfjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qLy1Rr/c; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qLy1Rr/c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=E3ecbc8zSdjIrGOGUBWhUO9IB4P5XRQG46rmrlmLwb4=; b=qLy1Rr/cTRO1ig4rCjjB/7hQ4v
	GGu4KC+jUMdozKQt42GCJUGf+oS2CAu5+DRjwdyNAf252aXl4X3wV11QL6OhDswe7kElfzgH39VWK
	bRvN8WMjVqmPFia8xrt7tsfhHsFEREZTf04jLrb2rHGvpryiFppz+i0/V+4sQDsmtre5yq/nnJ00Q
	0eBkTTv1/IJFClHXxulJ2uiEIvcmvPKthEcFInvZ+TiCQ3O8niVA9gQ5Ua5+5TO1BoPBkSaqEV9Im
	C1o8WdyZPjRegyLR5o1dpIq4VWnwVnR0YChTp+BOBzS+ugtZ5AT6bKCqYF6T7EaVniaiOvcPxp3IW
	8d0SqkGA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uc1tX-000000004ch-1l9x;
	Wed, 16 Jul 2025 15:09:59 +0200
Date: Wed, 16 Jul 2025 15:09:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH v3] utils: Add helpers for interface name
 wildcards
Message-ID: <aHekp4Vp-P7FjPxv@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250716123325.3230-1-phil@nwl.cc>
 <aHejy360JyFlNdbk@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHejy360JyFlNdbk@strlen.de>

On Wed, Jul 16, 2025 at 03:06:19PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > +void nftnl_attr_put_ifname(struct nlmsghdr *nlh, int attr, const char *ifname)
> > +{
> > +	int len = strlen(ifname) + 1;
> 
> Nit: size_t len.
> 
> > +const char *nftnl_attr_get_ifname(struct nlattr *attr)
> > +{
> > +	size_t slen = mnl_attr_get_payload_len(attr);
> > +	const char *dev = mnl_attr_get_str(attr);
> > +	static char buf[IFNAMSIZ];
> 
> I missed this on my last review, sorry:

My fault, I should have at least added a hint about the missing
thread-safety.

> Please pass "char buf[IFNAMESIZ]" as argument.
> 
> Returning pointer to a static buffer breaks thread safety
> of libnftables.
> 
> Alternatively you could always return a malloc'd buffer
> and force caller to free it.  Up to you.

I'll go with the latter option since all callers pass the return value
directly to strdup() anyway.

Thanks, Phil
