Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6907618EB0
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Jul 2025 11:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753268626; cv=none; b=SNUTx8wWbqHlNq5QSAIN9H8rQxLpFmEjMb0A4CXJZ2Y0Ar8wO325PvrWYENgvUJUqRxSxi8r+LIKNXP3kcbPYWNN/+RL7Ndzrb3isDQrBcCVU5+pJ7biRwEJ2QLMd+QHVHZq+vEbl912M5DiNb8m5fwNhJ0e/iBJB2jDh6tt8xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753268626; c=relaxed/simple;
	bh=51esDz9NbTRqsOpW9uj7bn6ERvpF4mT8Og+d/8AKvjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r8lkCTFmegPqTIK9Nmzc0Lbh3VIrMVuKcYlqYE9y4vHLAkDyMsKDtWvm8bkLXcobgQ9+ewWau014uTLMLhnx900W5dwGaE2bgX5IvwTRuDltrpTtzCOMgtl744QAMk5ht/v3amr9+pqg3HJtfMh9cDiM4SmFlVCGW3vBRzcd/0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ObpV4yoj; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ObpV4yoj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7IMjJ4BER4qZOFL5K0GIuBy/tqHbHn7my0S8Azd0fvQ=; b=ObpV4yoj6EQoTjYJ66nc/9dk9l
	Nx0gk4LftoDxzb8vKAT7zzRJDnFq0COd4dg6TUhuMP3XDWQzqlps3vcRf3hYfT4xytCrSe5Rz3uGy
	Dob2b7gsMC+FjR9/JAv59Cxr0lj5H0+bPuKdl86gb4c1WiisYRb6omilc52IWdaO78+si+4obvTRc
	d/sYcXjP5CZ3kfEnOC0jwkX0Vy9gEAJKtsBrLMRjvo6HkpIMnZC8j6e2noFhFNqJ1NWjx9zdWwX4X
	pyB1OTynzc+DKMNu8hxfv6SUq5NLTMltXvzfYpcmTGyCkYxyOBSggV230R7AjvNKMvipRJTIMiNVy
	1dZ3DLQQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ueXG3-000000005ZA-0ACK;
	Wed, 23 Jul 2025 13:03:35 +0200
Date: Wed, 23 Jul 2025 13:03:34 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, shankerwangmiao@gmail.com,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables v2] extensions: libebt_redirect: prevent
 translation
Message-ID: <aIDBho8sN1qRP0of@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>, shankerwangmiao@gmail.com,
	netfilter-devel@vger.kernel.org
References: <20250717-xlat-ebt-redir-v2-1-74fe39757369@gmail.com>
 <aHjmETYGg4UtDdSf@lemonverbena>
 <aHjrV-YUot_fKToY@orbyte.nwl.cc>
 <aHu4moCviA27DpXO@strlen.de>
 <aH9M6kWerwHmVvGP@orbyte.nwl.cc>
 <aIAfaY4aZhAUhuXN@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIAfaY4aZhAUhuXN@strlen.de>

On Wed, Jul 23, 2025 at 01:31:53AM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > > calling 'redirect' verdict will manipulate the IP header as well which
> > > > we don't want
> > > 
> > > Can you point me to the code that alters the IP header?  I can't find
> > > anything.
> > 
> > I guess this is a misunderstanding, but continuing along the lines:
> > xt_REDIRECT.ko calls nf_nat_redirect() for incoming packets passing the
> > incoming interface's IP address as 'newdst' parameter. I assume
> > conntrack then executes, no?
> 
> Hmmm, I was referring to ebt_redirect, not xt/nft redirect.
> Whats the concern here?

I was considering to use nftables' redirect verdict for translating
ebtables' redirect in broute table, but it's nonsense: On one hand,
nftables' bridge family doesn't support redirect to begin with. On the
other, inet redirect is about IP addresses and doesn't alter MACs at
all. I somehow assumed it would set both to the incoming interface's and
then just realized that ebt_redirect does not change the IP address.

> inet redirect should be fully functional, if thats wanted, for skbs
> passed to bridge local in via ebt_redirect (or nft bridge family
> with mac dest rewritten to a local address + altered packet type).
> 
> At least I don't see why it would not work.

I guess we just need NFT_META_IIFHWADDR in addition to Pablo's suggested
NFT_META_BRI_IIFHWADDR for full translation support.

Sorry for the confusion, Phil
