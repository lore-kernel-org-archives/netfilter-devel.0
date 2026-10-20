Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792532185;
	b=vXkBfrCUweAeufSrhYiaDF4vLbgeqIMtfCPb0AEb53/aZA4w5UAzwGbSOxZg6xS29g2H
	 Mg2RzGL9GdIkcBFrk1ggSCPI5SG6NCL/iC+WjPu4ebagS9sfsHHctOzmJOCYJEQCudqJ0
	 wqdre428Z2pBMLE+J4zNDoQXXb46CZ+Ka1mjQFb/vhhdLTolj/85z0qIoAsiAgTfQZgtE
	 +eLarGBLZT7m4rgbwJSXfdpePxhyIdtfeGnAThheT0lBX5j0U8Y7E1YR+arDSTeatGZ9q
	 0BuYxDb0tm69Y1fy2q6xw2wND01g9VsSokGSsC4s8ha3Vi9E+00Qq6OIQ8TneaztvxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792532185;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=WGSLDYYijk345fyikRL5vlE3ORxnO5iKfo0O6aWc3uQ=;
	b=bGKTMCdeFDzslHAWVFqGzMStdTqTFvdhbHEzid80rxGBaBwiuIrkIXaG+260W047VVOI
	 TPiQcz1vcJChQ1gpPdTEB5n3ME4sZb4HnrPAFvwslRLPH57hYsMaqwZKug4XohH7yNx7c
	 lOURVjodiW0FjREuSMS9O/ndyOV5tKozMIO5ZSmLQopCgA90iyb6wI/vzDEd+kPF03gln
	 XSBUkSatsyoGqgIr8jzC/z/hBs6VGs92LA8jyjhVwxqHtccHucmp6xiEXSNIclcjFuETo
	 OJFP/9xGxsUS1HTec/vt1EOCJ8wnky+d3fxSjHjEOZkrkYxMXP0YqtQxIzc/4m0FTLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=MW5nXvg8;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 54DE4606A31D;
	Tue, 20 Oct 2026 21:36:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54DE4606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=MW5nXvg8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792532181;
	bh=WGSLDYYijk345fyikRL5vlE3ORxnO5iKfo0O6aWc3uQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MW5nXvg8hGWdKMkizxJmWLmcb1MbUwNTDmLP0IJKWIfGtPaP/pMscNzT/4e3pYb31
	 U1ZC0LfDTy9QBISMXpmxGICS1tB5tAtQUpT/gZ7f18oPKYj6F9nnftyp8l09UeBV/k
	 WkhHQiD59fYb1AHZSYEPiUmmfrKsPH6w/CjqxtpXVOFmOwvGQ2QI8HobkK7m7N+kcL
	 HZHD5e83u2cnkHSonf2egO5fd0z4p+0RriFvOEDLKfLmQRjigRcQXXSsoCCwCjZngz
	 4wHoswZg3bTjE6Kf2bJTQEXM42nM/JQS7NixNsacxYuYr68EU2n/T6t2y4cm/dyEvv
	 8LfuZi1vaHpwQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B2DC460050;
	Tue, 20 Oct 2026 23:36:21 +0200 (CEST)
Date: Tue, 20 Oct 2026 23:36:18 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@kernel.org,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 00/10] Netfilter/IPVS fixes for net
Message-ID: <atfe0iEREk6PGVT0@chamomile>
References: <20261019150249.1879516-1-pablo@netfilter.org>
 <20261020141058.0acdb035@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261020141058.0acdb035@kernel.org>

On Tue, Oct 20, 2026 at 02:10:58PM -0700, Jakub Kicinski wrote:
> On Mon, 19 Oct 2026 17:02:39 +0200 Pablo Neira Ayuso wrote:
> > 3) Fix races when handling overload flag in IPVS, this patch
> >    is not perfect but Julian considers this improves the situation.
> >    This was uncovered by LLM. From Julian Anastasov.
> 
> > 6) Initialize IPCB for inet/ingress reject, uncovered by LLM.
> 
> Could you look over the LLM review for these two specifically?

Sure.
