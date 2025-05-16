Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D043232
	for <netfilter-devel@vger.kernel.org>; Fri, 16 May 2025 18:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747419417; cv=none; b=G+V/P/h+Nz3s5PyGf18jBNfk4cK5+ZJ/EUBJ1WO2WPjrFC9SHgH0GuGtJ2Eys0CXGN11BOu9KL4GeCgfM1JhLyLWFXQAHbLlHvnpbiIyBbkIi7Wyx9PMVXHwFSlmUKAyMiQ72/qPssu7USedOkkaKX8+gSqXh/hLjWV6qBuFX/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747419417; c=relaxed/simple;
	bh=Mi4c9nZ4ucs72S7EGKLQf3RmwMrx2kZwZVN7aVxQv3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFcTd3TDqY1IL9S7LM6+oPZMGVHBoUhicSXk+TE8+jiwMAbTNvxP4JwjTRBd92SBWVWTBtiI1Mh9vPe5Ap7fI9WvrH4UgtOxbkyUsikBuXHeqIyEBcct2376XaU4UverFCSx6Eh1Oo6RKf5hmp71zgdEPbaWWPdWp6Wpq7C7yQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fnQTTSgm; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fnQTTSgm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2D/z9wFgHmaT3wx6YNWaTvd6237xaeXM5K4cwraiyC0=; b=fnQTTSgmwdu5bB+hN7ldk4wQse
	tgwUql7x0P39HObQJ0twB1r5xEqpzmTIP7pzbj0RZj+TuCl+CuPsNBeQC6obR2hcIcbX/1ruu5CLY
	/klTDvYr0NvIXbE9wGR6D8vxtexF4jXaGnt9mbWuMevDBvliPNhALth1RqH7CIIg0+t6p2hLwUn3c
	5VZrElVxWFubk2SoB/5VUcPRRIuNFvkN9v+w9Rh2nwVZjuy/TxBUmcSoUfNAQX/P5BCj+gmC/l11l
	xOSuAmMxDdAUK1pMcKXGg64ROMO0tjqWyEfVEidhC+jgANvMwtoy58wg2IC0WQicrN9CRQpRqe2iX
	WROJJKmg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uFzbz-000000005cT-0WhR;
	Fri, 16 May 2025 20:16:47 +0200
Date: Fri, 16 May 2025 20:16:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Include kernel taint value in warning
Message-ID: <aCeBDw5rrWUa7szR@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250509125321.21336-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250509125321.21336-1-phil@nwl.cc>

On Fri, May 09, 2025 at 02:53:21PM +0200, Phil Sutter wrote:
> If kernel is already tainted, not all tests yield usable results.
> Printing the taint cause might help users tracking down the external
> cause.
> 
> If a test taints the kernel, the value is stored in rc-failed-tainted
> file already.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
