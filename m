Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBB723B62B
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Nov 2025 15:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764344300; cv=none; b=FiVhxivMkd3o9qShdG29k1DSGu7rAx70p+ehC40tQGnCbX5uCkbibWPFuyKyqQJFQOPDECW8lJCDKn7N0qdtuI0YUjslhzCOrBQ38zaOT1NiCW9XMddv2a1B2pyix187JEaBUpD8CFg9k1R2YmSvX2BZ+8nZ3xb8bbg0fZOy21M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764344300; c=relaxed/simple;
	bh=sUvj3LO+KZnlIWcilT9kvQT/vgS/TGOgXVG8w+CPsQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aVL2HRMn8BZBb/I3dqjjk3CHcPOgtjpAfZ6D/jK4mVuImF1nBYlIiKB7aqpVYUDv/eqCWRAALuF99qjeaIyT08gnFPT2NiVy6U09sO6Y2PkN6WzHDrN1W8al6V4P7CSDZ2W24bu5boSWBkr2cjeEAp9oBg2Zx0tkUxsbBsr4Hww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Y9aG3s3J; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Y9aG3s3J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ta0c8bt+x0C/PXznwFe/annIaFqcmZV5H/15JZSVmoc=; b=Y9aG3s3JK564Lxnz3gE+7qvBzw
	sfosm5i+wASwfUVpeladEFfal0mme84SlgrFyAma6um6zuQFIAN6Ssrj7BR1/TyT1A2RRjULsYCoB
	JwhqBGurbLImJX9Hbd2kmyqUwsTDGv+9CStu504AkORMGo0SKZa/38uDvKVN5tqUXK4qiHnwR4KlX
	tLCFgE7lhKULytfQNTAoh4wEM50cBgM/fhM9R9sjT3SC62BCd2JofEHcHmnTFvzPUCdOY7udTlUGv
	DDPxieRk4FulU2IwMKBSLj+tg7ySvGHZaaewlJh/24JIKJVfJU8Eciqpaa9CENV0HDX35J8NwznVc
	O7ZZ85dA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vP0Y3-000000002le-11Zw;
	Fri, 28 Nov 2025 16:38:15 +0100
Date: Fri, 28 Nov 2025 16:38:15 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH RFC 2/6] parser_bison: Introduce tokens for chain
 types
Message-ID: <aSnB5y17dU9RioyC@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251126151346.1132-1-phil@nwl.cc>
 <20251126151346.1132-3-phil@nwl.cc>
 <aSm6sRVaq8ciWL-2@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSm6sRVaq8ciWL-2@strlen.de>

On Fri, Nov 28, 2025 at 04:07:29PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Use the already existing SCANSTATE_TYPE for keyword scoping.
> > This is a bit of back-n-forth from string to token and back to string
> > but it eliminates the helper function and also takes care of error
> > handling.
> 
> Did you run this with valgrind or CFLAGS+=-fsanitize=address ?
> 
> > +				$<chain>0->type.str = xstrdup($2);
> 
> This should probably be $<chain>0->type.str = $2;

Oh yes, indeed! I assumed the chain_type destructor would run after
reducing to hook_spec, but they're used for error path, only.

Thanks, Phil
