Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F7A274B53;
	Wed,  9 Sep 2026 03:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788925782; cv=none; b=our9DOxtWvs7bUO44hn+bkvVYli5iJXGgi1aD2dm65s9Bb3IdQlhjr/ECIqDyhp9JN8TuTC3bNi2PonrZIRHWRCVzv0ZgDUxzQPuUm0EfRGHIaa9q8L09ZogyOXO2KlDRUc9UZq7KFtvCgatl8V0FGehig7M5aD03fijM6txqHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788925782; c=relaxed/simple;
	bh=SXnCGTKDeDeTB+VIeOEETL4y7Vg/mwHP+BvHE9APR2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bw5q1b6wHYUPTvtcqOZzkps4bPuaIdvoE4sEXg7ICMPXwmG+5UoWCJCY24PuHxBlknIf0eO4LxzmmswOaL2xPMhvwMDHIFJHYU/Samq61/c3KqdPtwkTd6qZZgDL3FhoCG00B1vw6pUh7Cv5q0KoCwSt4wvFN5eHgrHt+CYKCCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=nVHYhXsC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="nVHYhXsC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=L1TH5Tdxzzn04sjRWO/fr2uzv9AuxgULbbMfyY2i9MY=; 
	b=nVHYhXsCfSIlMfXXhGzwgdmEdDsVQYbogW0JnzPNFYUQKIVoqYppu3kOuV5oy7NhUbEAAWY7blZ
	jFbRYtrZJH2KesalbgLSfrxbHOR0x0WBM0T1E5SEeHy1niVHi4N1tltvvaN+oIAtQx1lPnZEHdI1y
	A74LWAUYBJE1gMybjpEHlB//tGV1qqimahWU3k+5S+Wh4DU9S5XqU6/tRjRnFvfNoZe/hdUIEKsUs
	OBtHEAk4sWQ9guiUbXIWkEKjrlz0CNsrwqB4TtkW+PzinfufH7GyMPt9WHBVhdb/wcC5WXTz5AvK2
	7NzP4wfcACqNOr8McqJdV1aXZiOK4gbv7unQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x49JT-0000000C7Zx-2IHv;
	Wed, 09 Sep 2026 11:49:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 09 Sep 2026 13:49:31 +1000
Date: Wed, 9 Sep 2026 13:49:31 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH nf-next v4 01/13] rhashtable: add
 rhashtable_flush_and_free helper
Message-ID: <aqDXS550RN2YcoD9@gondor.apana.org.au>
References: <20260904185321.30313-2-fw@strlen.de>
 <ap-ZOyOS6j_K5gmZ@gondor.apana.org.au>
 <ap-dYotn2QqdTVqf@strlen.de>
 <ap_PlDqTNOnB0Y83@gondor.apana.org.au>
 <ap_budC8D-k4k67v@strlen.de>
 <aqACH2VVNGmgW-5B@gondor.apana.org.au>
 <aqAMuQhG4l2mMLw2@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqAMuQhG4l2mMLw2@strlen.de>

On Tue, Sep 08, 2026 at 03:25:13PM +0200, Florian Westphal wrote:
>
> In current ipset home-grown hashes:
> 
> If the insertion is into a region not yet scanned -> will be dropped
> If the insertion is into a region already scanned -> will exist after flush.

OK now I understand what your patch is trying to do.  We can
continue the discussion there.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
