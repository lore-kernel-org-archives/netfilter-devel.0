Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB3924B2F
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 15:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724080746; cv=none; b=AUR0A5beVmtqqLkJLLIAB2t9UbQKjpCwXPeVbGA4DwW3Ph6vhSD4S8NeTJKvyRXKaAif2K+hke/y050rwfX6qVerrjQ8/97efI/seXGdXKLl1itCvirYzSKTzMnDjG6VMZAMG4zA69ltGSZwnfx02/xpWc/9DUgozZel13/z2Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724080746; c=relaxed/simple;
	bh=21T80qyKdR/jNDw3bO3rrCofz2oINJ+WZd8uDHUX8SM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gH7KXq4aC+SoQL1BlVqZd5TAX2hp5jJDPP2oXE/gI12OcGq1X4sbecZdGlRdmATVigD5IlXe8jQdR1hTZYpbxCwmdKXrJxKjfNo3wzfx50MOAfaGWJ9Itq+oYwRcaoE2w4nCLO7dBEfvuVHnpL1oodHCoDxWEd68p/mG4n+LMTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=e4yKpBRL; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="e4yKpBRL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oZ6pPjTKAVd+riCc/t2iai6ooUPnNpkTc0eO4kBppas=; b=e4yKpBRLGb51BnEKqszpqevdZv
	AYX494UAgbAYeXTiw+W3qk9+RhYlzgPHLKHuZFyD3CG5/3l5uVy3DhEskJVEiJKZqiNzVYJKwSuMz
	9iiTQqQ8cuUdGBM/ZaQielhbNB8KeDNpLXiPd6keiYmrcd/mRNl78j01pcw9rJ9o/JoonmlCbS62B
	v4G+02z+K6wyHpSzdU23pQ4CRwkA482S5D1Y9fTF3BgSdinEQf4h56nCYHWVDqTb/BY3w/YGy/0ZY
	i9LV5YGaXsWWSD1qUBmbzJPK9oZKmFRFL9s7MUZ8/RLLAvbccG71+847qBNkyoWWgbnsX2zX6KS67
	NMJHh/vg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sg49n-000000005zL-1Hnm;
	Mon, 19 Aug 2024 17:18:55 +0200
Date: Mon, 19 Aug 2024 17:18:55 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 1/2] datatype: reject rate in quota statement
Message-ID: <ZsNiX0mRqHDCgm95@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240814115122.279041-1-pablo@netfilter.org>
 <ZrzUt-8mZoqdY0ai@orbyte.nwl.cc>
 <ZrzWpcQehJBmss13@calendula>
 <Zr0E7BZu3fowGLBz@orbyte.nwl.cc>
 <Zr9FKFg8bnfQrqoZ@orbyte.nwl.cc>
 <ZsMipjpB5QylZ3tH@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsMipjpB5QylZ3tH@calendula>

On Mon, Aug 19, 2024 at 12:47:02PM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Fri, Aug 16, 2024 at 02:25:12PM +0200, Phil Sutter wrote:
> > On Wed, Aug 14, 2024 at 09:26:36PM +0200, Phil Sutter wrote:
> > [...]
> > > Maybe one could introduce a start condition which allows strings, but
> > > it might turn into a mess given the wide use of them. I'll give it a try
> > > and let you know.
> > 
> > Looks like I hit a dead end there: For expressions like 'iif', we have
> > to accept STRING on RHS and since I need a token to push SC_STRING, I
> > can't just enable it for all relational expressions. The alternative is
> > to enable it for the whole rule but I can't disable it selectively (as I
> > had to enable it again afterwards without knowing what's next. :(
> 
> flex rules also tells what to find first (order implies priority)
> maybe a combination of start conditions to carefully placing. I can
> take my poor man fix by now so this can be revisited later :)

I have a working draft using an exclusive start condition (Florian
pointed me to that). It passes the testsuite, might need more work
though (the first token after the limit statement is still parsed in the
exclusive condition, so all statement openers must potentially be valid
in all conditions.

Anyway, it's not a simple fix from my side so please go ahead and we'll
discuss my patches later as the "academic project" they are.

Cheers, Phil
