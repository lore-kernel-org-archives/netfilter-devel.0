Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F02D18B481
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 19:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729105482; cv=none; b=srAVQtsW+KE2nGNf7EJE6JzK8K27n3Z3S3CiflI4MM2b82eA5VWdAm3Hmyi8pwAysxR5vysfdY4bMjN3+zCsJ0wqwmimwWOtQNNlKckHgD7TCJ1oQgUmZjR+soI6cMW0+EBzypgt6okGfr7hSeL1zpUS/uNODTxxwgOF9ggFlpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729105482; c=relaxed/simple;
	bh=4S7JnRakOThoZ3eG/bAJIRfbRtdDrZRUWUgyjB5Bww8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DviHtc+M0ayNHDS+rJvW33eJNTTxFaD5ZctwWmWgwpvE50HfFh7xX6GAcbhBnbv/yLjYn4FlDPbA8B5W2m9WxlvyjbELrXeoPwcTvYH9DmdQXfm6vk2ak9qszJXmMW+a52ZHyAdFdA0/yLC4Ah3HnPA2b6531fnX7H2s8OehdM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EdcPs3b6; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EdcPs3b6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LCH0GMtCg9iNZza5C4nJlNMakS2pPwXWAZVuIwJs6UM=; b=EdcPs3b6gCTUMP560T51EmEAUo
	y/zEf9RNfkGak6jQ6iSDErxdA/b1v8c7LFHIffw2pL0jzMLGuL0QpSSB/nqaFyOMbED0a1rn3/tQe
	SoLlLA6JK8gpigDzFEyDOoqhWKOcr587y22PmeS0CJQbkGHqM2Jz4VDF1eQyqaLzkEi6MmaEFIJDI
	iR5AbYwYA1G48QmEgHzmhpS4jFLQHO9R78oykYBw+nssAEJxJSgpn0mUaacBLj4pxx8xRUlzUaaaG
	Lh2e0zmAwfAYyw4KwNky4dbMa54hBGkml0JndrDFIH8VCCGJuxYmfFbQhH1sQ1cwwYfMnJlFr/Wpz
	iVo+6yDw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t19K2-000000008C1-01qG;
	Wed, 16 Oct 2024 21:04:38 +0200
Date: Wed, 16 Oct 2024 21:04:37 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [RFC libnftnl/nft 0/5] nftables: indicate presence of
 unsupported netlink attributes
Message-ID: <ZxAORZJ3t4o04KUl@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20241007094943.7544-1-fw@strlen.de>
 <Zw_yzLizGDGzhFRg@orbyte.nwl.cc>
 <ZxAHJO_amh8cIDaR@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxAHJO_amh8cIDaR@calendula>

On Wed, Oct 16, 2024 at 08:34:12PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 16, 2024 at 07:07:24PM +0200, Phil Sutter wrote:
> > On Mon, Oct 07, 2024 at 11:49:33AM +0200, Florian Westphal wrote:
> > [...]
> > > Extend libnftnl to also make an annotation when a known expression has
> > > an unknown attribute included in the dump, then extend nftables to also
> > > display this to the user.
> > 
> > We must be careful with this and LIBVERSION updates. I'm looking at
> > libnftnl-1.2.0 which gained support for NFTA_TABLE_OWNER,
> > NFTA_SOCKET_LEVEL, etc. but did not update LIBVERSION at all - OK,
> > that's probably a bug. But there is also libnftnl-1.1.9 with similar
> > additions (NFTA_{DYNSET,SET,SET_ELEM}_EXPRESSIONS) and a LIBVERSION
> > update in the compatible range (15:0:4 -> 16:0:5).
> 
> LIBVERSION talks about libnftnl API, not netlink attributes?
> Probably 1.1.9 got any API update while 1.20 did not?
> 
> > We may increase incomplete marker correctness by treating support for
> > any new attribute an incompatible update. Given that we often have
> > dependencies between libnftnl and nftables for other things, it may not
> > be too much of a downside though.
> 
> 15:0:4 -> 16:0:5 means new API is available while older are still
> supported, so old nftables can use this library binary safely.

Yes, and my concern is if one installs this newer libnftnl, behaviour of
incomplete marker will change despite the same old nftables package
being in place which doesn't handle the new kernel attribute.

> You mean, we should reset age, considering c:0:a?

I just realize that one may recompile nftables against a newer libnftnl
and achieve the same effect as the "compatible library update" described
above.

So the proposed incomplete marker merely indicates that libnftnl is
outdated compared to the running kernel (or the ruleset loaded into it).
If libnftnl does not signal "incomplete", nftables may still miss
important attributes.

The other way around should work though: If libnftnl indicates
"incomplete", user space is certainly outdated.

No longer incrementing library age value does not help here. Sorry for
the noise!

Cheers, Phil
