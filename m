Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A8243CED7
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 16:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768926522; cv=none; b=WrMfGzUYaisW6mGY4N973vMMCz8nLll2++UJtwWrPrFo7wIn+T7ldBuJcWUvbX6LXDhnaBMH3kItBmbeEhrcYtDYel//hLU8L43vD5zm2AV2RFVb6A6WOimUbOd7q4ZaSNTzbnO3WdOtBHoPib8jbLbSRjCkR6Ej1Fifmxt68Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768926522; c=relaxed/simple;
	bh=umTTDxJpnJ5Tz/kwwXR4mCgkLh33SSa8kLmlFBZ7hOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r9EsvdvxykGy4zaQe+2QqbaG+VMfZo2+PTrbybBrE6UL+Cprw4pG9IU56Ku7RyvXu5H6gbRbfHYIM553V3/GuW0Ida42YhP/LtFLHGGosM7NFifuIP6N66SGUiX3mKbVXpWbgDH3DOInumdR0Lv3/dwAhxYn8ehBdG/OqtbuZk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XEkS10br; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XEkS10br"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=44/mXwghCzs6av4w8HgrAksKT+i3wrRlzp1zNCBS5f8=; b=XEkS10br0sguoDLHAbP0teWfA5
	RQRcn7oP4GTuTCJTyv9CDJxjrCNIaOzhYWmJ5yVVXDbwCwNrTsNtr+zryPBlG3ald2LoRPFaRr3ir
	X9p2RATQEK78muBzFYGtKTQpc5fE2hScOd6ztmTBR63c450uW+fwHECIwKaRdPufDPDrfj3vVYaB0
	Qk4aLvQ6MrJWmwwB87J/u2/w6qaZhStx0z6t9zcqR0e73F77Moa/vM09RWS5zLrEH6kh7Y5egk983
	ktlc/NcYt2zbzeLRdedn3s8PZop1mMwaQbOELEPPFS1Gmr2IuQ2vb+/EmP9QkfoBnJg5l6ZRyjkwL
	PncfIFag==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1viEar-000000001cM-3Peb;
	Tue, 20 Jan 2026 17:28:37 +0100
Date: Tue, 20 Jan 2026 17:28:37 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 6/6] scanner: Introduce SCANSTATE_RATE
Message-ID: <aW-tNd_HhE7SvU6c@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251209164541.13425-1-phil@nwl.cc>
 <20251209164541.13425-7-phil@nwl.cc>
 <aW-SicaUzUULQFv9@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW-SicaUzUULQFv9@strlen.de>

On Tue, Jan 20, 2026 at 03:35:05PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > This is a first exclusive start condition, i.e. one which rejects
> > unscoped tokens. When tokenizing, flex all too easily falls back into
> > treating something as STRING when it could be split into tokens instead.
> > Via an exclusive start condition, the string-fallback can be disabled as
> > needed.
> > 
> > With rates in typical formatting <NUM><bytes-unit>/<time-unit>,
> > tokenizer result depended on whitespace placement. SCANSTATE_RATE forces
> > flex to split the string into tokens and fall back to JUNK upon failure.
> > For this to work, tokens which shall still be recognized must be enabled
> > in SCANSTATE_RATE (or all scopes denoted by '*'). This includes any
> > tokens possibly following SCANSTATE_RATE to please the parser's
> > lookahead behaviour.
> 
> Series:
> Reviewed-by: Florian Westphal <fw@strlen.de>

Series applied, thanks!
