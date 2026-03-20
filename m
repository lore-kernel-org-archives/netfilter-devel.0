Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E153A758A
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 11:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774006327; cv=none; b=A/adi6+TJU47wQa4Sfk8eN7aPFdifBMnU2y00I53TOhWx77lkmMkhviQTkpulJRQNys+q6jRMvPfxAltRstXlv5ysWLeFlb2hNYFqNa9GIlcLhfeTPzfPmwDZScp0HoZo2fCoHlqlnbcWjXDADa3kz+0t0WjZDfflJylJYlBex4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774006327; c=relaxed/simple;
	bh=g5MG+PQkXNFON71VGH27JrUuBXliZLMnjqXRiGnTPgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HFeNTEtxDS6+ZPozEEflTW+tnQ0L0uDHCny68UPkHeqdEljwDqmJ2h7vw7MOSTO3yRO32QvC9eAXzI9M1Hn19pY5kSvhe5MyPHA6C/va2LdEyjdIsVbFaoZN11EhNb6XOeXcC3lSIfIxEXbkmgpceXlvCgqbAlyHRZPeLMX+fF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=LgFtUJs9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LgFtUJs9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+gipUmcqHyefpKDXlyJweQhlbuaXl3xMNl4t1k98d2s=; b=LgFtUJs90k/Y3JiLqUOyi4bX7V
	VVk7gtvFUcd+0oLmti+5Lh8DrORXZepjGHF2dveJ19QUuzTdR9Do52geiAp3hGif9avNAEFJnisxj
	hGlhPeDyQL7+tNQBXqSadBWh76VVrSJ9In/3caI1TZZHUqB5yNYlT2TyBjiM5zbwYum8OnhqrVot0
	MjK+hUylxEKXNUlim+Az4STaD1NJe9vgTHDiJhm+oLQ0u8FQPZZWkCh0R3qtLrwJoewAAvPuXlDxL
	a/GmXAvMYVzSS+qdtJgWI4qSOCUbjf1bV0Z1zpabWTmbhi3Y7E3DZhep98N+p4S7CD5R/UJls3xJA
	iAPbgnGw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w3Y5E-0000000074w-1xAi;
	Fri, 20 Mar 2026 12:32:04 +0100
Date: Fri, 20 Mar 2026 12:32:04 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Daniel Winship <danw@redhat.com>
Subject: Re: [nft PATCH] segtree: Fix for variable-sized object may not be
 initialized
Message-ID: <ab0wNFdmoeeaV9Rs@orbyte.nwl.cc>
References: <20260319133208.19823-1-phil@nwl.cc>
 <ab0sc0AmGcDZjnHh@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab0sc0AmGcDZjnHh@strlen.de>

On Fri, Mar 20, 2026 at 12:16:17PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Seen with gcc-11.5.0 on an aarch64 machine, build failed. Looking at the
> > code, r1len (or r1->len, actually) really seems variable. So use
> > memset() and fix build for that older compiler version at least.
> 
> Thanks for fixing this.
> 
> Acked-by: Florian Westphal <fw@strlen.de>

Patch applied, thanks for your review!
