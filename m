Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CE22E5423
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 13:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755696146; cv=none; b=aaCci3XuLhUarMIwWzQrkk2uHM2UwPkPRyv3zmWQJNdYqHm5sPIPNt2XwFCmTv1/0jJ+5dMFKcj7HLb3ncoHfioF04SfM/cgGGsy53DiqjCpASYFe5kNSEA7RgTDob5U21rDpIWKsihEC4SNqvLToXps5bU/YVcOesNg8FGqblg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755696146; c=relaxed/simple;
	bh=Xf4/Cnb1BjFjBuvfWqrPOsT9AsFTciBLfb/coQMPlzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W1/17MpaAyF/idGsYehvS8ituXHO9ODev59mNCpSbQTyE5tITYWpZlufzMJRL8YHirBGw+yYuqsfxsVtFjJ5SBxtCuStUbxENNSWNQaHK9Z5fmkydt9gx7Hc1UV7Oq+apzTJwpoV7Vl0/yK6CoecqM1U1sf0kcYnYZaar/Ssoq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hCG4HNE1; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Eog63qq/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hCG4HNE1";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Eog63qq/"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3829F60276; Wed, 20 Aug 2025 15:22:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755696143;
	bh=H8W/5Fe5r66kg3k/635BRggs69L2pxaGlpWgdpJyag8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hCG4HNE1ph1w4T/PZvfcpEjxMRJyVnYdFbrimCr6KUYBv7Yxla4hZ+v0E2k9sqA+y
	 Rn0m0osPGW/f84kjtobNUkg3WqiqEXtutmrw65vrD18Yd9cPHV0W0+SMlJUZuuW2ZU
	 Snj5nwCeSF5xxNE06gyTuqrgZn9GPt5UJN8czpoIWO0p+/NOqQb3Og3NuNwPHh5jw5
	 RlA7E2xswJXgzwM64L9nx1LRQ9xzA/Qz2UJN1KtUE51zf1SGF3d5PfiCc03UZgnr2D
	 RjUEWI/bg0ukyh/cFrHJ0Zbmn9d2/4BveG90xn/VQHl1Px/jTdfJOE4jlvj4vvzuFA
	 I7PcEtJrofFmw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 92D0760276;
	Wed, 20 Aug 2025 15:22:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755696142;
	bh=H8W/5Fe5r66kg3k/635BRggs69L2pxaGlpWgdpJyag8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Eog63qq/CrBrwvdWsZ8bkZo2tYERWgE735fPTAeTJbJRjRyTqL3DCv9mIUFYppH7Z
	 ujrYCI1jEhYUR4ezePgNSVgUVU2P4vmkdgNn6rOCuM9uCEEHYAsb9MmgH2sIySO89w
	 yPqsYeiiEyY0RuIVxzVOwsaWcmbDV2YryASnGVLcXzWlz7+G1sNTIUCWVfBiFhtta+
	 0kWCO8CDMbyaiX1KcHRY05xlFMHZf65n2yEgMQJHbAzXAeDJG9rntk1ivhY6ovZTzh
	 hNEumam8P52xUUyxfbBmQaT1qvotJyW+cp0RQ/MNjd0gspOdeo2MTj5aq3OqoM/H0M
	 g4ITQnJg++v9w==
Date: Wed, 20 Aug 2025 15:22:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] mnl: silence compiler warning
Message-ID: <aKXMDPl1q7Z5bei8@calendula>
References: <20250820124447.31695-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250820124447.31695-1-fw@strlen.de>

On Wed, Aug 20, 2025 at 02:44:43PM +0200, Florian Westphal wrote:
> gcc 14.3.0 reports this:
> 
> src/mnl.c: In function 'mnl_nft_chain_add':
> src/mnl.c:916:25: warning: 'nest' may be used uninitialized [-Wmaybe-uninitialized]
>   916 |                         mnl_attr_nest_end(nlh, nest);
> 
> I guess its because compiler can't know that the conditions cannot change
> in-between and assumes nest_end() can be called without nest_start().
> 
> Fixes: 01277922fede ("src: ensure chain policy evaluation when specified")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Thanks for this fix.

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
