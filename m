Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B6544C658
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2026 22:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792016376; cv=none; b=PFSFfVqSzHW9fdRB4GMK6RNx1VGo8z2IKKLWviowyYMojigBpJ8bSm25FuvSfZVry4M+csx34OuhEr/3lTDDIRYvnbF1/S5D/o6zdAGSUi43t93PEwgMEKaykZy03aQERAaDqzv3D71eVQP8ahBfi3PrKaCBcClf/JZohafBdLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792016376; c=relaxed/simple;
	bh=Qj2E+GJ9bkaYJA5ivlDrXFbWK1fLkq5pePimhAggoOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MnR+E2BY2sGqWIh3M86IZq08csRfsjNSS99qjSUS2ITATefYmxjofqnUbelNHFv6Ps//9xTDcjo0dxMen78fHJ/UDno729YW3cOjZsPCJqA1JE4Q+5KZdSodJtPrTdZ2qs2+6Jh12djU/sl9oY5mTnFLLnkHDFHX0BV55AXUmvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qX2cHope; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qX2cHope"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792016365;
	bh=7nF+YA46/NRTEJObRJDNiBsCepch836YdY2a3DU9+1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qX2cHopeTJB2RyfJkZemo12pCq12b8Ed9rPxjCVUtOUMrREl75FgfatDkh4QsYzHq
	 jMtoShHPqdHNb7Inv4kNRuguMYeljZ5yXHvRGmDvrTcHqA3mR90iWyYaPDcKHHNigM
	 N2z/uHkaKWGR5Nf2UYQSEaJj35PoQ0OgcZpqGFWrxisnGImhbrbTfEFPA2FN7kU6Rx
	 lYHkO49W9/sNVeqtqoma1hPpS/ilZFhCA2V4WHW9Ou3gmq7KzCxv1cCioPuYRFtRpp
	 PKljjFlGQrm2TMceDpuSYMe7qy8d+qO5MiUR6YMGI+Pedm3Jgh0jP8/n3/wpqEXveP
	 sUzFMOLi53Vpg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9B4736005D;
	Thu, 15 Oct 2026 00:19:25 +0200 (CEST)
Date: Thu, 15 Oct 2026 00:19:23 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: netfilter-devel@vger.kernel.org, ericwouds@gmail.com,
	razor@blackwall.org
Subject: Re: [PATCH nf-next] netfilter: flowtable: teardown flow reaching
 bridge port on fdb updates
Message-ID: <as__66RGd9zNVrcd@chamomile>
References: <20261014210256.1573072-1-pablo@netfilter.org>
 <CAC1t37+TzhPP1Q1HZVQUw=vLUxsHwpmyFWHyQWyGyOJnvSUKBQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAC1t37+TzhPP1Q1HZVQUw=vLUxsHwpmyFWHyQWyGyOJnvSUKBQ@mail.gmail.com>

On Wed, Oct 14, 2026 at 10:00:47PM +0000, Julius Bairaktaris wrote:
[...] 
> Your version is smaller in the tuple and cheaper in the gc, though.
> I can send a v7 that takes the fdb lookup from yours and keeps the
> fixes above, if that works for you.

Please, go ahead, let's see how v7 looks like.
