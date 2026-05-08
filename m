Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7EA381AFF
	for <netfilter-devel@vger.kernel.org>; Fri,  8 May 2026 10:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778236135; cv=none; b=eu/Gpwkx6aYmmwt/yPIEeYGZH/g6Pe6VFHLPtQCgyDhazgTu6BERBPNPTgfORHJ1nrAgBgONoDotUpJebtWKNMagUG8zIysqIxC1FcIi1aPYyIdeef3oDbNdBLRZyv5X7uwpjutYCW6SPE04HrbDmHFNMLi+UAqCZ6X25P/6D70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778236135; c=relaxed/simple;
	bh=u8O4jQjTvEDz+6VWCT1mtKp9QKK2oPd2h70Vdft+tVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hvahbcnPPMyNKNstWW58zIyRUmab6TePt4o04dRM8n7mmbglobZig401dvhrRxVXtinTxvSIV3mJkB0nDxSMlBfeFbU2AJR4RmVxoljL4dCfwu4/LHY61iPPK2jHqxS29YkHyUF46ALIxFg+kXFRzGpMThWFsXRdRmstM5BzrUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gn9Suh9P; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gn9Suh9P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NKAty64zqHJy2Wb8oMuqmFu3cLKpJKWVVKiWuogLfbc=; b=gn9Suh9P1jXw+ozJXzEhFbH5jn
	zUkVJzoeaDBL0CLzLic/Jqay2ulDJwxMEXaHxd6/YTwimbW8IlpVK4BM4vw59lR2308VMxT+cJG/0
	6A7JZhVsNgzX4vYxEXaWxQB7841fkI91UyDBpsikk4Dl+1yXs3+aFwDoligJsMUxjV9KVHryzBNJg
	9Cx6bbakOCi7xsckAZ5sRvFMzn5SSG9OrSwkNmLJuRlgyZOmsazsVKq+VoJqHieZ3vAbHrt0p81XU
	M8KOHSoXdJ7dCZqUVP6NkkYTeRlDSyNQGbRs3kst3cO7A+AqFMp6eK33erF8GLg/oKSovNISjP9H5
	dKC7Lx5w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wLIRw-000000004IP-2UhE;
	Fri, 08 May 2026 12:28:52 +0200
Date: Fri, 8 May 2026 12:28:52 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] scanner: Accept all statements' first words in all
 scopes
Message-ID: <af265E0SP78KxmpQ@orbyte.nwl.cc>
References: <20260507203824.3560155-1-phil@nwl.cc>
 <af0MY2qPAuNwULFo@strlen.de>
 <af25GqQQQXt8pZhf@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af25GqQQQXt8pZhf@orbyte.nwl.cc>

On Fri, May 08, 2026 at 12:21:14PM +0200, Phil Sutter wrote:
> On Fri, May 08, 2026 at 12:04:19AM +0200, Florian Westphal wrote:
[...]
> > > -"limit"			{ scanner_push_start_cond(yyscanner, SCANSTATE_LIMIT); return LIMIT; }
> > > +<*>"limit"		{ scanner_push_start_cond(yyscanner, SCANSTATE_LIMIT); return LIMIT; }
> > 
> > limit limit?
> 
> Heh, that is indeed a bug. Aside from the questionable semantics, LIMIT
> token is obviously accepted in SCANSTATE_LIMIT already.

That is not true: The exclusive start condition is SCANSTATE_RATE, not
_LIMIT. So "limit <foo> limit <bar>" is not accepted without this, and
if my approach at ignoring semantics (and keeping the possibility for
more exclusive start conditions in mind) is OK, I'd rather not drop this
change.

Cheers, Phil
