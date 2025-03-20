Received: from Chamillionaire.breakpoint.cc (unknown [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667A62147F8
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 08:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742459413; cv=none; b=oUQZBU9lkQhVfWh+RIKvvOC1xHZRm6zuIiRFMrGIbaVIyTkbd6IXyhihlYLGvtHz+gs+t4/vWjOHKab5XLIuuJhfBJjfQfmGnRtuyFYRmYxGYuyRdJFAp9iLHrBGtl73FCTUWwC3Gs8dr8sLb7nIN577sZvFToFTZhaBUvr8FdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742459413; c=relaxed/simple;
	bh=zl777qkGSeD8RFB3JhkNKPxsy5G/dynaxclCsaJXk2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fx8W0yge+0vpKYKN9XfVGIrBt6gztob3G4robtfNwDuWaA7e6n9pmCE2vh6kpov+ZzJ3/01Yi+wjMHgeL97mFLrcgTwv+cTnzKy9wioR+W2qD7m5ww2Ivtp9k3rkCBclf8Ne6p7RJZ+pREYmXAc1p0a7megBMGP9mFxHkw6xP9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tvBI0-0000Wd-EH; Thu, 20 Mar 2025 09:30:08 +0100
Date: Thu, 20 Mar 2025 09:30:08 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] expression: tolerate named set protocol dependency
Message-ID: <20250320083008.GB1543@breakpoint.cc>
References: <20250313163955.13487-1-fw@strlen.de>
 <Z9teyXKA-B25J2mO@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9teyXKA-B25J2mO@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +			const struct expr *key = right->set->key;
> > +			struct expr *tmp;
> > +
> > +			tmp = constant_expr_alloc(&expr->location, key->dtype,
> > +						  key->byteorder, key->len,
> > +						  NULL);
> > +
> > +			ops->pctx_update(ctx, &expr->location, left, tmp);
> > +			expr_free(tmp);
> 
> maybe narrow down this to meta on the lhs? I am not sure of the effect
> of this update for payload and ct, they also provide .pctx_update.

Sure, I can amend it accordingly.

> If there is a use-case for these two other expression, this can be
> revisited.

Agreed, lets restrict it for meta for now.

Thanks for reviewing.
