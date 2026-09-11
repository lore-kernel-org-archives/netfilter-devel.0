Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703874252A0;
	Fri, 11 Sep 2026 11:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789127816; cv=none; b=AAwjtUGmcKi73pEFtdpKnWJTDMCYdAPsBnJBtsqsPrgNTzyHrb/ORZkB2qwFk6jp1h3N+X1PqaJ3eCc9MeM+rsyW0ochj3bKMGydHrr8sHiMwtOKdynGVgsdjZ5EtczQlwQLCAIK6R6kZFIaNFzfZlw4fsgsWgyn370G9epz7sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789127816; c=relaxed/simple;
	bh=mxZAv8+PTWz5o5uQFlYfiCNTyxtxBErqqt2XZxLnyrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ki8ZgCzXbmXtrMc9c4y4971Z1k/97VMHFzEliRUfI/PXKkcoq6vUolmi+ID37rESqa7i8JpptwcmPO7oGcygLz1QuhgEMKY1zaW8DRH11Ulzm0ckAD3D8MLO/EapPfM4bwQeQhV6tEZam3OizlgM1Cf5bndiQNcjkfVeLor5bH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=rwH8xx/n; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="rwH8xx/n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ZGW7E+Tnw6q8TDdm+/hSy8nooSWRajnqZj0uPKL4Ndw=; 
	b=rwH8xx/nP7/e5uXP3JORcsr/z5rUYUKHjdiQo98qvix4U7Jaukcjc5PxaVqLxJcgZngkr9fUYkJ
	BfqliF6RXelAztVafosxYjl4kVgPhBJXLMHT4ALScWfeRaB204ismCLs86QFKfs0EIsl+khPAcLZZ
	+c7W1FqF0xmNY2OMCYYZFX6/91ezD9GNa5TnbdWP5aMyTYppOX+u5E8lrGRD7lUXNlnhKCQXTqU2J
	Z1Ka3tUKRRHhrjcC2Dheu7sOGUt4ARGvP93hZDC+4OqccdAUgMBok3JclYBo8w+z9J1tkXMviEbc9
	y61zYx66c2awo0Li6Cd/2GSAD4iYC4NqmmhQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4zs1-0000000D1Jv-2iDp;
	Fri, 11 Sep 2026 19:56:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 21:56:41 +1000
Date: Fri, 11 Sep 2026 21:56:41 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH nf-next v4 01/13] rhashtable: add
 rhashtable_flush_and_free helper
Message-ID: <aqPsedZD85-zXob3@gondor.apana.org.au>
References: <20260904185321.30313-2-fw@strlen.de>
 <aqDdwKMbvd9aErLy@gondor.apana.org.au>
 <aqFw-_Y4JGRF-0Za@strlen.de>
 <aqJ0QDwEIZg5sDql@gondor.apana.org.au>
 <aqKJUOQYHEGWKgCn@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqKJUOQYHEGWKgCn@strlen.de>

On Thu, Sep 10, 2026 at 12:41:27PM +0200, Florian Westphal wrote:
>
> What problems do you see?  Shouldn't a rehash be a no-op, since it
> can't see anything in the hashtable once the flusher releases the
> mutex post replace_pointer() call?

The problem is that the rehash is just a deferred work which carries
no state.  So it doesn't know why it was triggered.

If we go with the atomic replacement, the issue then comes down
to the fact that if a rehash was triggered before replacement
then it should do nothing, while if a rehash was triggered after
replacement then it should do something.  However, because the
rehash doesn't have state it doesn't know.

If you do a rehash when it shouldn't be done, you may end up with
spurious EBUSY errors because it thinks the hashtable is under
attack.  While if you skip a rehash when it should've be done,
then it could leave the hashtable in a suboptimal state.  But
this should correct itself eventually, so perhaps this would be
the easiest solution.
 
> > It would be a lot simpler if you added the restriction that the
> > caller must not call insert/remove before the flush call returned.
> 
> How to assert that?  Or should that be an 'external' requirement?

It's certainly not easy to detect this from within rhashtable.

> That will, at least afaics, defeat rhashtables purpose, I'd have to
> either serialize by external single lock, or add a flag that would
> 'eat' new insertions while the flush is running.

If there is no natural way of expressing it in the caller, then
we might as well add the complexity to rhashtable.  Let me look
into this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
