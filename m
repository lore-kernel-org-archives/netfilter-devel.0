Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6221FDE39
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 12:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761741976; cv=none; b=hBORuqsde5lwUBLLVKwSrKcBvi0uv8l+wOOwsKrA3jXYcAmutR2OfFMY2+TGXpjekRaH/mVcEJou3/IYRK5+Zbs42QCZJTknMqY4rZHpImbkiGi2aSDqVbQlMs9OtC/03cQxyMMuX//K7pSxZuFJCG1r/AZ+A7kewQT+uOnpZnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761741976; c=relaxed/simple;
	bh=Y+tntbwMKio/CsMDCUc5CoE6Z279kvuLRx8Mac8BCvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O+XrhSR4LiMCHzt0+16NL+WqgSc8zsHBMgR4DaR8+yHrzppWjJGX1ckmfNJnpMQsdD3uaTqf0KAuyZ6r1L5OBFWRVnagShx5n0+Okw5Qb82s3brXRHGzIz04Ap5F+E9+hrLRLaLVRI6qbJ/CMjoE9ByxqXLDegh8cJ3KmKN7lmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1FE03606D7; Wed, 29 Oct 2025 13:46:11 +0100 (CET)
Date: Wed, 29 Oct 2025 13:46:05 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 26/28] utils: Introduce expr_print_debug()
Message-ID: <aQIMjRNdYN0t7Xyg@strlen.de>
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-27-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023161417.13228-27-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> A simple function to call in random places when debugging
> expression-related code.

Acked-by: Florian Westphal <fw@strlen.de>
