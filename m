Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96097519917;
	Tue,  8 Sep 2026 09:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858270; cv=none; b=FfdYld3iOZbt1TzDsG102P+9wj8rcWCpH0Z9+lCt/qZkCFVkX7H0z3YgZcYfxTNsFwSK5Uq6HxWBAZHVHUG3B9gXhVBZiPScZi29Nx8g8IDBTEVAREA4neObCVpy7t82KczGVzWBoTwer8fXHIvOFvWpDti/4I+0qfmHBmVWNT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858270; c=relaxed/simple;
	bh=PHIZ7h9xq+n1EzIQPJwPi3y89CFNA4yF/OY0bv2E2Bg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gt6f3KPoNMu88+cOItBllE9B3QhAUirDgV6mqxVFX4Akk2KgNh/Yz7KHm1GL0JeYiq3e6L3yOIQuoTtGGlNA8JZmDK1iuuDb5mXEvBFCHLbgE1M+Ko+h41++fWZAegEcZiJ1Z0rAKFerslPXIis0LSMP1gmRybzb7w8JrvG4AiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ZxkpM+16; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ZxkpM+16"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=0+1cWH9ZzdahSEqEWtOTJjInFzoOaQDwMsGM0RltdUU=; 
	b=ZxkpM+16QSixs1x3kV9D79qqBbESwWq4mm1bhi6W4wqNVfmcuBtL1o0HBoj0yoSGslmVxfERC89
	EEu6puXcobsVEKOk2GEivr5g+72bUOBvm2RlOtq5mpMjXjqw9hi3mnViT+UNYDYI9Z5tvg/af5CGh
	nPWPti0Y2bBBLI4Fsris0h5lHaUX8WHCMucplfiSTJwzyOpqgkwQjY2k3R/4JK7x96kw23+riZrBW
	2CBluwHzAVzvz+UdZtAQnr0ZLNUUq4nvvKiM3uqOC4C1z1pVvRib0TXVPB+ra3Fs09NuvSJ9YDZAT
	GVQIMURceSH2GFcwCL71/DJkkuN3G/Kjzk4Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x3rka-0000000BnG5-3UMB;
	Tue, 08 Sep 2026 17:04:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 08 Sep 2026 19:04:20 +1000
Date: Tue, 8 Sep 2026 19:04:20 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH nf-next v4 01/13] rhashtable: add
 rhashtable_flush_and_free helper
Message-ID: <ap_PlDqTNOnB0Y83@gondor.apana.org.au>
References: <20260904185321.30313-2-fw@strlen.de>
 <ap-ZOyOS6j_K5gmZ@gondor.apana.org.au>
 <ap-dYotn2QqdTVqf@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap-dYotn2QqdTVqf@strlen.de>

On Tue, Sep 08, 2026 at 07:30:10AM +0200, Florian Westphal wrote:
> 
> I don't understand this response.  This isn't about rhashtable vs.
> rhltable.  This is about my incompetence to flush an rhashtable or
> rhashtable.  Simple version:
> 
>         rhashtable_walk_enter();
>         rhashtable_walk_start();

You should never use rhashtable_walk for real work.  It was only ever
intended for the very limited case of netlink dumping where stability
or accuracy was not a requirement.

>         while ((he = rhashtable_walk_next())) {
>                 if (IS_ERR(he)) {
>                         if (PTR_ERR(he) != -EAGAIN) { ..  break; }
>                         continue;
>                 }
> 
> 		rhashtable_remove_fast()

So you want to free the entire table, right?

We already have rhashtable_free_and_destroy, any reason why it
doesn't work?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
