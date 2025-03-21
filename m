Received: from Chamillionaire.breakpoint.cc (unknown [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C450F1CAA9A
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2025 14:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742567513; cv=none; b=E2r8A9m6nCA/DbU2nP41Ht2fn3eCjQceKQcFoUvHJwoKu243DPI2xTIEMyOmCxP4bWBhGkLlJRWiCmpxXcOMAF2MOqTrAc56hv6/5EJnLxyfa8+xZkwasb8ifr1+JwgO46fQ/QO9nx00erOic7m+AdoOcDL8OE9NBHUXGyYp4Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742567513; c=relaxed/simple;
	bh=/cezscRL3wIGlnkZP7279JKo37jA53rd5fgfx6Zqrlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLaL84GemX27VcWd4P2VQs/bwfd9+IsGtNuEUmjpkpxeLSz/DE7X8ro7f1bsptSI0qDsNLwn+Dkh72+2A0Plj0h37gGD1cEyoWhXwF3/lGrvLzVJqrUiqXp8XKflKaLMOUHzxMdquqetZkmbpeJ+E7lcBvPBmFdzqmQN8ATXBac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tvdPZ-0005JR-5c; Fri, 21 Mar 2025 15:31:49 +0100
Date: Fri, 21 Mar 2025 15:31:49 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: don't update cache for anonymous chains
Message-ID: <20250321143149.GB20305@breakpoint.cc>
References: <20250321114641.9510-1-fw@strlen.de>
 <Z91hRuByR5QtstqP@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z91hRuByR5QtstqP@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> rule_cache_update() is invoked because of index, which toggle
> NFT_CACHE_UPDATE.
> 
> Maybe rule_cache_update() should be skipped for anonymous chain
> instead? ie. return 0.

Makes sense, i sent a v2 and added a comment wrt. anon chains
being immutable.
