Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE9F188715
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Jun 2025 14:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750861766; cv=none; b=KRjsShMAzrlwEo3XLol4bg7kQaUZn1xKljNLaiAzJknZFZwrB8Iyvoo5diFpIQRIeqFuQTy29otJZx7lSf7aSDGAbWubKk0GZ1nKUTTrlm33h5HH96s3yHcYT0LCMPJ2nu56RrbkqGLNq3EdDZKRKQSmKU2Y4huqlPXHKsCORHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750861766; c=relaxed/simple;
	bh=bQ3WWOtCMcGzcIHFotfmDcsg7vWUHARGxMmrt0ZKE1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eBYjtShHOpATM3zsjTogBcaFG6pMeaVNI5coCN9wfiWJfa3/odsgWgTpaauCaVSS6V3YrlTzbmuicgmS2YGx9tMLeSIPwSb312uVHGJY2Tf1WdpkyJJRmgiWHs8OoLATT4pN6RRgXuGaWfzrU/AZ9qLL4/qR97nQyONpr+cG/gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C262A6035A; Wed, 25 Jun 2025 16:29:20 +0200 (CEST)
Date: Wed, 25 Jun 2025 16:29:13 +0200
From: Florian Westphal <fw@strlen.de>
To: Sven Auhagen <Sven.Auhagen@belden.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Cannot allocate memory delete table inet filter
Message-ID: <aFwHuT7m7GHtmtSm@strlen.de>
References: <BY1PR18MB5874110CAFF1ED098D0BC4E7E07BA@BY1PR18MB5874.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY1PR18MB5874110CAFF1ED098D0BC4E7E07BA@BY1PR18MB5874.namprd18.prod.outlook.com>

Sven Auhagen <Sven.Auhagen@belden.com> wrote:
> we do see on occasions that we get the following error message, more so on x86 systems than on arm64:
> 
> Error: Could not process rule: Cannot allocate memory delete table inet filter
> 
> It is not a consistent error and does not happen all the time.
> We are on Kernel 6.6.80, seems to me like we have something along the lines of the nf_tables: allow clone callbacks to sleep problem using GFP_ATOMIC.

Yes, set element deletion (flushing) requires atomic (non-sleepable)
allocations.

> Do you have any idea what I can try out/look at?

Do you have large sets? (I suspect yes).

As for a solution, I can see two:
1). Leverage what nft_set_pipapo.c is doing and extend
    this for all sets that could use the same solution.
    The .walk callback for pipapo doesn't need/use rcu read locks,
    and could use sleepable allocations.
    all set types except rhashtable could follow this.

    Then, we'd just need a way for the generic flush code to
    see that the walk callback can sleep (e.g. by annotation in
    set_ops).

    Upside: Clean and straightforward solution.
    Downside: won't work for rhashtable which runs under
    rcu read lock protection.
 2). Preallocate transaction elements before calling .walk
     in nft_set_flush(), based on set->nelems.

2) is a bit more (w)hacky but it would work for all set types.
And I could be wrong and the alloc problem isn't related to
nft_set_flush.
