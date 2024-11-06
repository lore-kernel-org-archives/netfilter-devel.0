Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181A91D63D3
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 10:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730887306; cv=none; b=dVC57XuZNTu+WbWE4oRB+ZY53l9kx569I1xj4cwKLPZQQs1ZIH5yR3IV1cqt5tsbcwsSi/LKlrHLbmtqOM1xjWySV2jx88BS7v3c0W/4BGO55dPnVIifRUxCr1/p7yHYZQQLCSt3kscI+qzFIcVsKh1+bR/ErLCc8a793NJ4/kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730887306; c=relaxed/simple;
	bh=LzFNBHyCjdBPQFZqVP3Hi+NVXbs4kbr4PEv1g3/D8Hw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gc7NTtaPNRiO+jmOY+mMKwFMLo1bJLBT6mjhNk/rP12rgN4qdfypb0qxX6RvOfei5Pxnlp8+RvpXF5t04CXqrNgzPnMSseRw+VYyM7SSGdwoiXcpQfJ/+He4wj/HwDF55IpG0mb0JDp2QN3jFAc72h4Z9rYUlUzOYl2WN2tbXtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=DisqhjVT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DisqhjVT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZODXQBDOMcfDE+kV6WVMZ937tmD7BbeL51tcMwqXU7o=; b=DisqhjVTqzVRJWkEC9mb3rv5C5
	ur+03RXxgDkrQxKTSH+AFQUD6P8r0vf9C9xh/65aRyogu9rAsZNPBv6cZyuxoA8tLW5mIO99uipgL
	egF8dg2hmJSnh1LJqkUfIOoKXuo5pt9/o3zXSvIYLHIFaqrs2si7c92t6KpOeD+lZFNy86tbyObkc
	Naxaqx89q54sXCTpR2nyyxbqBJsUR6+lyH52F7Ahr6aJQYHvXuzEDf6M/E1OH5ooe6Ie+mZf/E1m1
	luVWCeCJeMT29t3egwxpkRxibnN8rNnMVwsZnhHqQp2cFFR4tpkZVv73QGsEmPX0vgwpfdVaw3cKQ
	aUoAZFAA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8cr6-000000007kH-44Js;
	Wed, 06 Nov 2024 11:01:40 +0100
Date: Wed, 6 Nov 2024 11:01:40 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/9] Support wildcard netdev hooks and events
Message-ID: <Zys-hB96lz39P8q6@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20241002193853.13818-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002193853.13818-1-phil@nwl.cc>

On Wed, Oct 02, 2024 at 09:38:44PM +0200, Phil Sutter wrote:
> This series is the second (and last?) step of enabling support for
> name-based and wildcard interface hooks in user space. It depends on the
> previously sent series for libnftnl.
> 
> Patches 1-4 are fallout, fixing for deficits in different areas.

Applied these four patches.
