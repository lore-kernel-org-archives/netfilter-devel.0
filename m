Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2309222576E;
	Tue,  8 Sep 2026 05:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788844364; cv=none; b=RNRl5Xszk58kcipJzqjT+lDDgbkoCOe2VT3il2HwfKYMD9ZqGh7FXNjO2L8cxpgGJEC7p1Kh6o7MobFVfhN7IwypYstsHj22Xz1AQjNIAhFNIRlYeYkvGHVn1922ywxX8jthFh3Cf2IHChSfhQh2sGezzumUUS+5CpSmhtjFFZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788844364; c=relaxed/simple;
	bh=cMorWarZdN1jd1u6WORj7emd6wkaSp0v5dMvBzPGQjs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=JVyLrxGSIHzGav4dNcgO6Pi0u0Skh5fIqIGcFJi0j/Y2VFCEio3sQuePb1+wugDnVb1zg4V+vvjT4aBY/CdavoK+W9mZzqYsf9997vKMjfxjMQw9WAIZgqFVZ1HF7cHkkkoECgN3255KpB/qMuIt7OQIEObl3Q5TMC8tX0+stbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=O1L0/NoD; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="O1L0/NoD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=7OkINBw+TWKOKb8EYPx07dchb5LUoshWYRMcnbn9JUU=; b=O1L0/NoD+RNuu3k/YWQPMOQmT0
	dp+Cwwo5Q/Q9k1v+lvrQ5+r21ozTC0VBB3eZEYMjYL7DISS7EcVOqEvKY4+YNHxShyL5sE+Hjdb+R
	xcD9xmLQioakuogjMCqzqf5d6/PH3NJZAujB0GO3WzACTdbJoUszVxMMmP4x6cChdt57vrJU94B0z
	+QopzIQiHzSKzOcN/S1s19xsiEtf2fj88wauwiah4FpIHHJ3t2DpT1QXGr7guiRd2Z9atbp6O3zHA
	MfAPhqOhcPqwQJDy0rYGwGpXsA/r9lTj+7KorQvGJz48qy21QpWJk7IstYVJ2mjn5TCFDXqjhdDvz
	8Baw9gMA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x3o8B-0000000BjFB-46pP;
	Tue, 08 Sep 2026 13:12:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 08 Sep 2026 15:12:27 +1000
Date: Tue, 8 Sep 2026 15:12:27 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH nf-next v4 01/13] rhashtable: add
 rhashtable_flush_and_free helper
Message-ID: <ap-ZOyOS6j_K5gmZ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904185321.30313-2-fw@strlen.de>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.netfilter.devel

Florian Westphal <fw@strlen.de> wrote:
> Will be used by upcoming ipset rhashtable conversion.
> 
> "walk rht with unlink+free" triggers LLM reject pattern:
> "possible softirq CPU stall".
> 
> "walk rht with unlink+free + cond_resched" triggers
> "possibly skipped elements".
> 
> Add a helper to detach current hash backend storage from the
> rhashtable, then iterate and flush all contained elements.
> 
> Cc: herbert@gondor.apana.org.au
> Cc: linux-crypto@vger.kernel.org
> Link: https://sashiko.dev/#/patchset/20260828152256.8759-1-fw%40strlen.de
> Assisted-by: Claude:claude-sonnet-5
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> Herbert: If you prefer to take this via the crypto tree, please
> let me know.
> Otherwise, an explicit Ack would be appreciated, so this can
> be handled via nf-next.  Thanks.
> 
> net/ipv6/ila/ could be converted to use this helper too.
> 
> include/linux/rhashtable.h |  19 ++++++
> lib/rhashtable.c           | 127 +++++++++++++++++++++++++++++++++++++
> 2 files changed, 146 insertions(+)

Sorry I wasn't paying attention.

So is the problem that there is no way to remove all elements for
a given key in an rhltable?

If that is what's needed then we should just add it for rhltable
since normal rhashtable's do not contain duplicate objects for a
given key.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
