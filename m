Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920E013EFF3
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 17:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723053427; cv=none; b=ZlpbczBQfs1da2N8XVYsSO1oR5Ca8GueSM+gDZz/lJ4AX2Amj91lI4wYfPoOtnz0RXidjBeuVTc63Gf5to9CEDSO4+z4lyCB+rcKqrkBg7c7xgoeYpEBMmRfAk66SVVj1gYmmPwQLcKPtQPIFWq3igfzaKV7GhQAyt2GOCco+QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723053427; c=relaxed/simple;
	bh=xRW1tyuE2oNILvsVRdzfe1DHCI/rvDYoHGv4vafe75I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ICxggWsC9BsYNU6pcBTpRbQX6glV18AT1hWWd+TcSSZ4FD2owzDBQ4fTJ44uS/7OP+WgXiLc9A1UVcGvpdMpF3nBLru0fqUBG5YE7Nu6x8lvEycDNrrKHwmTwvMYGa0nZ1S5jht2rCUE35xb7C1aFkt85u7AOkF6Rpj0XIZXd5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=57580 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sbku6-005H3o-G8; Wed, 07 Aug 2024 19:56:56 +0200
Date: Wed, 7 Aug 2024 19:56:53 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables RFC PATCH 8/8] nft: Support compat extensions in rule
 userdata
Message-ID: <ZrO1ZVKUT_fNKXx1@calendula>
References: <20240731222703.22741-1-phil@nwl.cc>
 <20240731222703.22741-9-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240731222703.22741-9-phil@nwl.cc>
X-Spam-Score: -1.7 (-)

Hi Phil,

On Thu, Aug 01, 2024 at 12:27:03AM +0200, Phil Sutter wrote:
> Add a mechanism providing forward compatibility for the current and
> future versions of iptables-nft (and all other nft-variants) by
> annotating nftnl rules with the extensions they were created for.
> 
> Upon nftnl rule parsing failure, warn about the situation and perform a
> second attempt loading the respective compat extensions instead of the
> native expressions which replace them. The foundational assumption is
> that libxtables extensions are stable and thus the VM code created on
> their behalf does not need to be.
> 
> Since nftnl rule userdata attributes are restricted to 255 bytes, the
> implementation focusses on low memory consumption. Therefore, extensions
> which remain in the rule as compat expressions are not also added to
> userdata. In turn, extensions in userdata are annotated by start and end
> expression number they are replacing. Also, the actual payload is
> zipped using zlib.

What is store in the userdata extension? Is this a textual
representation of the match/target?

What is in your opinion the upside/downside of this approach?

Thanks.
