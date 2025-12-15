Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ABB32D42D
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Dec 2025 21:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765835033; cv=none; b=gN3BBosZlRLHJ1YSLEBtvixhbZXtW5zKJqPmXJ9ITLN7RTSdCMl9m+n1itWBIfrxre7W9wkLsmUA1z0QGPRtrb4VU3XQJ/830b2sJfLU6WkhvGCMhmFlsyBWjW5HauWl91g92y/T1VCzf9Wi+fZQ0P/KjYWED+mGlBOniFG+Zzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765835033; c=relaxed/simple;
	bh=GIvPXmsGCUdtWSedGa+rNgGkbT8hqi8NoqMqcCHc2bM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bHO12zX/ls3kId3bkojKFy50PYs6w+lyIkIctyfL1CRuP6K97FPZhEatKxJqBfN+bXOnaP2X+KtMAPWslQx0+pMhrbKdrwf5pk5BUdM1ALAfG81AKG/fv5GVgjIUu051gE+q1r1ba7IASYKLpGgnoxdnyQoEKMCWHwgT/Et3kLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 51B5D60332; Mon, 15 Dec 2025 22:43:47 +0100 (CET)
Date: Mon, 15 Dec 2025 22:43:46 +0100
From: Florian Westphal <fw@strlen.de>
To: Ian Pilcher <arequipeno@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: RFD - Exposing netfilter types?
Message-ID: <aUCBAau7DREw8YmD@strlen.de>
References: <1944a019-39af-46e6-b489-96715dd2dd01@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1944a019-39af-46e6-b489-96715dd2dd01@gmail.com>

Ian Pilcher <arequipeno@gmail.com> wrote:
> Recently, I asked what I thought would be a simple question.  How should
> an application go about determining the type of objects stored in an
> nftables set.
> 
>   https://marc.info/?l=netfilter&m=176546062431223&w=2
> 
> As seen in the response (thanks Florian!), doing this for all possible
> types, including concatenations, is actually pretty complicated.
> 
> Presumably, this is why the NFTA_SET_KEY_TYPE values that correspond to
> simple types aren't in any public header.  Instead, those values, along
> with all of the logic associated with complex types seem to exist solely
> within the nftables user-space utility (nft).

Yes.  Note that the type info is only used for formatting the data.
Its not used by the kernel and its not relevant for matching.

Theoretically nft could store that data on disk and not even
send it to the kernel.

> Of course, this presents a problem for any other application that wants
> to work with these types/values.  Today, any such program needs to copy
> the values and/or logic that it needs from the nft sources.

Yes.

> Is there any reason that the type-related stuff that's currently in nft
> shouldn't be broken out into a separate library that other applications
> could also use?

Whats the use case?
