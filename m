Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58F026738D
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Dec 2025 15:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765380532; cv=none; b=qFs25WFa0n2GtZ+aQ0J+c/fnhQOzqBMuZ3RF0fIUG0jtvOOvb5CEubBd5oFjkpTUiCGkuB/6gscC0Ru+1jZQVA9AExWuDp4Z0EYDg3h6QnyIDJd6+nQc6i9cOmam78kZhYZbV4jPfEVhl50nNNx0fNiNMfvmP+/YPvPqyRo0pZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765380532; c=relaxed/simple;
	bh=THJz6o8GfCX3h6Vd1FsW9kgqiQePnjfkzRsYjN/GXwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LEAo3WDZTtG+y8rC6msk8I0wD7MeV8QyblEvJBoTOB7Jp/JUPP/EzuYKKNfG4r7JmlQFN7gloj1Mw0njGxLP53YlNfsAFmHKncORQVuJKfAfoy6sNwA+jdP7UQxNh9K6GSAT8cTdOnEbp/ySuC3mF9wG0UptAaUG6zBfH6KgF/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jVnw4Ao8; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jVnw4Ao8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WbxinGLxzShKG7eEVueoWWAFVBqOkM50v8+pKGeCPhU=; b=jVnw4Ao8HmQt9LOBD6//WJJ+JN
	DxJxgtGcgFNyLaiJdOXfCJa4cUCUKg2jtgQ/tQU1td4aSgjJ066Ht8HmQGfTgr9iLC2DUp0ad4Txr
	M98bBMrO7ick2D7mRr11qvyC9Q+VsUt5iEPXGT+c4jwccvug2bQitgyqb3g14d4ZNEm1WEN5lqkLC
	sqDwJ8A3KdK0KbibCqaTSSWjU2JtxtHzAP8ebDtdFXb2rrToiVf7TR4dTlGAgP7oyc1KTzqmoYoaV
	K/S8osFJpqes13lYbqTe+r6KwI3RD2is/Jgwg7toUzN+kVwOYJtKNXq4z+f9F8xtYLUuXRKKK5r/k
	ZrVUONlw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vTM7T-000000003Zg-3nFP;
	Wed, 10 Dec 2025 16:28:47 +0100
Date: Wed, 10 Dec 2025 16:28:47 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Eric Garver <e@erig.me>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] src: Convert ip {s,d}addr to IPv4-mapped as needed
Message-ID: <aTmRr2GGL8nUZ-wy@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Eric Garver <e@erig.me>,
	netfilter-devel@vger.kernel.org
References: <20251210150333.14654-1-phil@nwl.cc>
 <aTmOaUEmL0P_h0sy@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTmOaUEmL0P_h0sy@strlen.de>

On Wed, Dec 10, 2025 at 04:14:49PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Note that adding IPv4 addresses to sets of type ip6addr_type is still
> > rejected although easily enabled by passing AI_V4MAPPED flag to
> > getaddrinfo(): Since this also resolves DNS names, users may
> > unexpectedly add a host's IPv4 address in mapped notation if the name
> > doesn't resolve to an IPv6 address for whatever reason. If we really
> > want to open this can of worms, it deserves a separate patch anyway.
> 
> I think we should force AI_NUMERICHOST when AI_V4MAPPED gets added, i.e.
> never autofill in a v4mapped address for ip6addr_type when all we had
> was a name.

But this would disable hostname functionality (note we have
NFT_CTX_INPUT_NO_DNS to disable it, so users expect it to be enabled)
and I don't know on which conditions to set AI_V4MAPPED if conditional
setting is desired.

Maybe ip6addr_type_parse() could explicitly try to parse as numeric IPv4
address first? Or a least impact approach checking sym->identifier
consists of dots and digits only?

> > +# ip saddr ::ffff:1.2.3.4
> > +ip test-ip4 input
> > +  [ payload load 4b @ network header + 12 => reg 1 ]
> > +  [ cmp eq reg 1 0x04030201 ]
> 
> Makes sense, no expansion.
> 
> > +# ip saddr @ip6addrset
> > +ip test-ip4 input
> > +  [ immediate reg 1 0x00000000 0x00000000 0xffff0000 ]
> > +  [ payload load 4b @ network header + 12 => reg 11 ]
> > +  [ lookup reg 1 set ip6addrset ]
> 
> Looks good to me, thanks for working on this.

Thanks for your review! The option of converting implicitly didn't
appear to me at all while initially working on it. And for v2, I could
reuse large parts and merely get the chunk in expr_evaluate_payload()
right (if protocol dependencies are created, ctx->ectx gets
overwritten).

Cheers, Phil
